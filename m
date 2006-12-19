From: akpm@osdl.org
Subject: + lockdep-add-graph-depth-information-to-proc-lockdep.patch added to -mm tree
Date: Tue, 19 Dec 2006 12:28:24 -0800
Message-ID: <200612192028.kBJKSOSZ009411@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60497 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932940AbWLSU2i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Dec 2006 15:28:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbaron@redhat.com, mingo@elte.hu


The patch titled
     lockdep: add graph depth information to /proc/lockdep
has been added to the -mm tree.  Its filename is
     lockdep-add-graph-depth-information-to-proc-lockdep.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lockdep: add graph depth information to /proc/lockdep
From: Jason Baron <jbaron@redhat.com>

Generate locking graph information into /proc/lockdep, for lock hierarchy
documentation and visualization purposes.

sample output:

 c089fd5c OPS:     138 FD:   14 BD:    1 --..: &tty->termios_mutex
  -> [c07a3430] tty_ldisc_lock
  -> [c07a37f0] &port_lock_key
  -> [c07afdc0] &rq->rq_lock_key#2

The lock classes listed are all the first-hop lock dependencies that
lockdep has seen so far.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/lockdep.h |    1 
 kernel/lockdep.c        |   19 +++++++++++------
 kernel/lockdep_proc.c   |   41 ++++++++++++++++++++++++++------------
 3 files changed, 42 insertions(+), 19 deletions(-)

diff -puN include/linux/lockdep.h~lockdep-add-graph-depth-information-to-proc-lockdep include/linux/lockdep.h
--- a/include/linux/lockdep.h~lockdep-add-graph-depth-information-to-proc-lockdep
+++ a/include/linux/lockdep.h
@@ -132,6 +132,7 @@ struct lock_list {
 	struct list_head		entry;
 	struct lock_class		*class;
 	struct stack_trace		trace;
+	int				distance;
 };
 
 /*
diff -puN kernel/lockdep.c~lockdep-add-graph-depth-information-to-proc-lockdep kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-add-graph-depth-information-to-proc-lockdep
+++ a/kernel/lockdep.c
@@ -490,7 +490,7 @@ static void print_lock_dependencies(stru
  * Add a new dependency to the head of the list:
  */
 static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
-			    struct list_head *head, unsigned long ip)
+			    struct list_head *head, unsigned long ip, int distance)
 {
 	struct lock_list *entry;
 	/*
@@ -502,6 +502,7 @@ static int add_lock_to_list(struct lock_
 		return 0;
 
 	entry->class = this;
+	entry->distance = distance;
 	if (!save_trace(&entry->trace))
 		return 0;
 
@@ -906,7 +907,7 @@ check_deadlock(struct task_struct *curr,
  */
 static int
 check_prev_add(struct task_struct *curr, struct held_lock *prev,
-	       struct held_lock *next)
+	       struct held_lock *next, int distance)
 {
 	struct lock_list *entry;
 	int ret;
@@ -984,8 +985,11 @@ check_prev_add(struct task_struct *curr,
 	 *  L2 added to its dependency list, due to the first chain.)
 	 */
 	list_for_each_entry(entry, &prev->class->locks_after, entry) {
-		if (entry->class == next->class)
+		if (entry->class == next->class) {
+			if (distance == 1)
+				entry->distance = 1;
 			return 2;
+		}
 	}
 
 	/*
@@ -993,12 +997,13 @@ check_prev_add(struct task_struct *curr,
 	 * to the previous lock's dependency list:
 	 */
 	ret = add_lock_to_list(prev->class, next->class,
-			       &prev->class->locks_after, next->acquire_ip);
+			       &prev->class->locks_after, next->acquire_ip, distance);
+
 	if (!ret)
 		return 0;
 
 	ret = add_lock_to_list(next->class, prev->class,
-			       &next->class->locks_before, next->acquire_ip);
+			       &next->class->locks_before, next->acquire_ip, distance);
 	if (!ret)
 		return 0;
 
@@ -1046,13 +1051,14 @@ check_prevs_add(struct task_struct *curr
 		goto out_bug;
 
 	for (;;) {
+		int distance = curr->lockdep_depth - depth + 1;
 		hlock = curr->held_locks + depth-1;
 		/*
 		 * Only non-recursive-read entries get new dependencies
 		 * added:
 		 */
 		if (hlock->read != 2) {
-			if (!check_prev_add(curr, hlock, next))
+			if (!check_prev_add(curr, hlock, next, distance))
 				return 0;
 			/*
 			 * Stop after the first non-trylock entry,
@@ -2775,4 +2781,3 @@ void debug_show_held_locks(struct task_s
 }
 
 EXPORT_SYMBOL_GPL(debug_show_held_locks);
-
diff -puN kernel/lockdep_proc.c~lockdep-add-graph-depth-information-to-proc-lockdep kernel/lockdep_proc.c
--- a/kernel/lockdep_proc.c~lockdep-add-graph-depth-information-to-proc-lockdep
+++ a/kernel/lockdep_proc.c
@@ -77,12 +77,29 @@ static unsigned long count_backward_deps
 	return ret;
 }
 
+static void print_name(struct seq_file *m, struct lock_class *class)
+{
+	char str[128];
+	const char *name = class->name;
+
+	if (!name) {
+		name = __get_key_name(class->key, str);
+		seq_printf(m, "%s", name);
+	} else{
+		seq_printf(m, "%s", name);
+		if (class->name_version > 1)
+			seq_printf(m, "#%d", class->name_version);
+		if (class->subclass)
+			seq_printf(m, "/%d", class->subclass);
+	}
+}
+
 static int l_show(struct seq_file *m, void *v)
 {
 	unsigned long nr_forward_deps, nr_backward_deps;
 	struct lock_class *class = m->private;
-	char str[128], c1, c2, c3, c4;
-	const char *name;
+	struct lock_list *entry;
+	char c1, c2, c3, c4;
 
 	seq_printf(m, "%p", class->key);
 #ifdef CONFIG_DEBUG_LOCKDEP
@@ -97,16 +114,16 @@ static int l_show(struct seq_file *m, vo
 	get_usage_chars(class, &c1, &c2, &c3, &c4);
 	seq_printf(m, " %c%c%c%c", c1, c2, c3, c4);
 
-	name = class->name;
-	if (!name) {
-		name = __get_key_name(class->key, str);
-		seq_printf(m, ": %s", name);
-	} else{
-		seq_printf(m, ": %s", name);
-		if (class->name_version > 1)
-			seq_printf(m, "#%d", class->name_version);
-		if (class->subclass)
-			seq_printf(m, "/%d", class->subclass);
+	seq_printf(m, ": ");
+	print_name(m, class);
+	seq_puts(m, "\n");
+
+	list_for_each_entry(entry, &class->locks_after, entry) {
+		if (entry->distance == 1) {
+			seq_printf(m, " -> [%p] ", entry->class);
+			print_name(m, entry->class);
+			seq_puts(m, "\n");
+		}
 	}
 	seq_puts(m, "\n");
 
_

Patches currently in -mm which might be from jbaron@redhat.com are

lockdep-add-graph-depth-information-to-proc-lockdep.patch

