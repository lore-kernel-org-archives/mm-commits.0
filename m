From: akpm@linux-foundation.org
Subject: + lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:35:03 -0700
Message-ID: <200808042135.m74LZ3q3032194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765552AbYHDVjf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:39:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, a.p.zijlstra@chello.nl


The patch titled
     lockdep: fix combinatorial explosion in lock subgraph traversal
has been added to the -mm tree.  Its filename is
     lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lockdep: fix combinatorial explosion in lock subgraph traversal
From: David Miller <davem@davemloft.net>

When we traverse the graph, either forwards or backwards, we are
interested in whether a certain property exists somewhere in a node
reachable in the graph.

Therefore it is never necessary to traverse through a node more than once
to get a correct answer to the given query.

Take advantage of this property using a global ID counter so that we need
not clear all the markers in all the lock_class entries before doing a
traversal.  A new ID is choosen when we start to traverse, and we continue
through a lock_class only if it's ID hasn't been marked with the new value
yet.

This short-circuiting is essential especially for high CPU count systems. 
The scheduler has a runqueue per cpu, and needs to take two runqueue locks
at a time, which leads to long chains of backwards and forwards subgraphs
from these runqueue lock nodes.  Without the short-circuit implemented
here, a graph traversal on a runqueue lock can take up to (1 << (N - 1))
checks on a system with N cpus.

For anything more than 16 cpus or so, lockdep will eventually bring the
machine to a complete standstill.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h    |    1 
 kernel/lockdep.c           |   86 +++++++++++++++++++++++++++++++++++
 kernel/lockdep_internals.h |    3 +
 kernel/lockdep_proc.c      |   34 +------------
 4 files changed, 93 insertions(+), 31 deletions(-)

diff -puN include/linux/lockdep.h~lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal include/linux/lockdep.h
--- a/include/linux/lockdep.h~lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal
+++ a/include/linux/lockdep.h
@@ -89,6 +89,7 @@ struct lock_class {
 
 	struct lockdep_subclass_key	*key;
 	unsigned int			subclass;
+	unsigned int			dep_gen_id;
 
 	/*
 	 * IRQ/softirq usage tracking bits:
diff -puN kernel/lockdep.c~lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal
+++ a/kernel/lockdep.c
@@ -372,6 +372,19 @@ unsigned int nr_process_chains;
 unsigned int max_lockdep_depth;
 unsigned int max_recursion_depth;
 
+static unsigned int lockdep_dependency_gen_id;
+
+static bool lockdep_dependency_visit(struct lock_class *source,
+				     unsigned int depth)
+{
+	if (!depth)
+		lockdep_dependency_gen_id++;
+	if (source->dep_gen_id == lockdep_dependency_gen_id)
+		return true;
+	source->dep_gen_id = lockdep_dependency_gen_id;
+	return false;
+}
+
 #ifdef CONFIG_DEBUG_LOCKDEP
 /*
  * We cannot printk in early bootup code. Not even early_printk()
@@ -558,6 +571,9 @@ static void print_lock_dependencies(stru
 {
 	struct lock_list *entry;
 
+	if (lockdep_dependency_visit(class, depth))
+		return;
+
 	if (DEBUG_LOCKS_WARN_ON(depth >= 20))
 		return;
 
@@ -959,6 +975,67 @@ static int noinline print_infinite_recur
 	return 0;
 }
 
+unsigned long __lockdep_count_forward_deps(struct lock_class *class,
+					   unsigned int depth)
+{
+	struct lock_list *entry;
+	unsigned long ret = 1;
+
+	if (lockdep_dependency_visit(class, depth))
+		return 0;
+
+	/*
+	 * Recurse this class's dependency list:
+	 */
+	list_for_each_entry(entry, &class->locks_after, entry)
+		ret += __lockdep_count_forward_deps(entry->class, depth + 1);
+
+	return ret;
+}
+
+unsigned long lockdep_count_forward_deps(struct lock_class *class)
+{
+	unsigned long ret, flags;
+
+	local_irq_save(flags);
+	__raw_spin_lock(&lockdep_lock);
+	ret = __lockdep_count_forward_deps(class, 0);
+	__raw_spin_unlock(&lockdep_lock);
+	local_irq_restore(flags);
+
+	return ret;
+}
+
+unsigned long __lockdep_count_backward_deps(struct lock_class *class,
+					    unsigned int depth)
+{
+	struct lock_list *entry;
+	unsigned long ret = 1;
+
+	if (lockdep_dependency_visit(class, depth))
+		return 0;
+	/*
+	 * Recurse this class's dependency list:
+	 */
+	list_for_each_entry(entry, &class->locks_before, entry)
+		ret += __lockdep_count_backward_deps(entry->class, depth + 1);
+
+	return ret;
+}
+
+unsigned long lockdep_count_backward_deps(struct lock_class *class)
+{
+	unsigned long ret, flags;
+
+	local_irq_save(flags);
+	__raw_spin_lock(&lockdep_lock);
+	ret = __lockdep_count_backward_deps(class, 0);
+	__raw_spin_unlock(&lockdep_lock);
+	local_irq_restore(flags);
+
+	return ret;
+}
+
 /*
  * Prove that the dependency graph starting at <entry> can not
  * lead to <target>. Print an error and return 0 if it does.
@@ -968,6 +1045,9 @@ check_noncircular(struct lock_class *sou
 {
 	struct lock_list *entry;
 
+	if (lockdep_dependency_visit(source, depth))
+		return 1;
+
 	debug_atomic_inc(&nr_cyclic_check_recursions);
 	if (depth > max_recursion_depth)
 		max_recursion_depth = depth;
@@ -1011,6 +1091,9 @@ find_usage_forwards(struct lock_class *s
 	struct lock_list *entry;
 	int ret;
 
+	if (lockdep_dependency_visit(source, depth))
+		return 1;
+
 	if (depth > max_recursion_depth)
 		max_recursion_depth = depth;
 	if (depth >= RECURSION_LIMIT)
@@ -1050,6 +1133,9 @@ find_usage_backwards(struct lock_class *
 	struct lock_list *entry;
 	int ret;
 
+	if (lockdep_dependency_visit(source, depth))
+		return 1;
+
 	if (!__raw_spin_is_locked(&lockdep_lock))
 		return DEBUG_LOCKS_WARN_ON(1);
 
diff -puN kernel/lockdep_internals.h~lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal kernel/lockdep_internals.h
--- a/kernel/lockdep_internals.h~lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal
+++ a/kernel/lockdep_internals.h
@@ -53,6 +53,9 @@ extern unsigned int nr_process_chains;
 extern unsigned int max_lockdep_depth;
 extern unsigned int max_recursion_depth;
 
+extern unsigned long lockdep_count_forward_deps(struct lock_class *);
+extern unsigned long lockdep_count_backward_deps(struct lock_class *);
+
 #ifdef CONFIG_DEBUG_LOCKDEP
 /*
  * Various lockdep statistics:
diff -puN kernel/lockdep_proc.c~lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal kernel/lockdep_proc.c
--- a/kernel/lockdep_proc.c~lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal
+++ a/kernel/lockdep_proc.c
@@ -63,34 +63,6 @@ static void l_stop(struct seq_file *m, v
 {
 }
 
-static unsigned long count_forward_deps(struct lock_class *class)
-{
-	struct lock_list *entry;
-	unsigned long ret = 1;
-
-	/*
-	 * Recurse this class's dependency list:
-	 */
-	list_for_each_entry(entry, &class->locks_after, entry)
-		ret += count_forward_deps(entry->class);
-
-	return ret;
-}
-
-static unsigned long count_backward_deps(struct lock_class *class)
-{
-	struct lock_list *entry;
-	unsigned long ret = 1;
-
-	/*
-	 * Recurse this class's dependency list:
-	 */
-	list_for_each_entry(entry, &class->locks_before, entry)
-		ret += count_backward_deps(entry->class);
-
-	return ret;
-}
-
 static void print_name(struct seq_file *m, struct lock_class *class)
 {
 	char str[128];
@@ -124,10 +96,10 @@ static int l_show(struct seq_file *m, vo
 #ifdef CONFIG_DEBUG_LOCKDEP
 	seq_printf(m, " OPS:%8ld", class->ops);
 #endif
-	nr_forward_deps = count_forward_deps(class);
+	nr_forward_deps = lockdep_count_forward_deps(class);
 	seq_printf(m, " FD:%5ld", nr_forward_deps);
 
-	nr_backward_deps = count_backward_deps(class);
+	nr_backward_deps = lockdep_count_backward_deps(class);
 	seq_printf(m, " BD:%5ld", nr_backward_deps);
 
 	get_usage_chars(class, &c1, &c2, &c3, &c4);
@@ -350,7 +322,7 @@ static int lockdep_stats_show(struct seq
 		if (class->usage_mask & LOCKF_ENABLED_HARDIRQS_READ)
 			nr_hardirq_read_unsafe++;
 
-		sum_forward_deps += count_forward_deps(class);
+		sum_forward_deps += lockdep_count_forward_deps(class);
 	}
 #ifdef CONFIG_DEBUG_LOCKDEP
 	DEBUG_LOCKS_WARN_ON(debug_atomic_read(&nr_unused_locks) != nr_unused);
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
radeon-misc-corrections.patch
linux-next.patch
configure-out-igmp-support.patch
lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal.patch
docsrc-fix-ifenslave-type.patch
ali-m7101-pmu-also-available-on-sun-netras-too.patch
x86-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
sparc64-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
introduce-generic-iommu_num_pages-function.patch
sparc64-use-iommu_num_pages-function-in-iommu-code.patch
kprobes-indirectly-call-kprobe_target.patch
kprobes-add-tests-for-register_kprobes.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

