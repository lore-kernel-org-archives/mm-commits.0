From: akpm@linux-foundation.org
Subject: + cpusets-new-round-robin-rotor-for-slab-allocations.patch added to -mm tree
Date: Fri, 30 Apr 2010 13:53:36 -0700
Message-ID: <201004302053.o3UKrax1012891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752494Ab0D3UyT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 16:54:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com, cl@linux-foundation.org, holt@sgi.com, menage@google.com, penberg@cs.helsinki.fi


The patch titled
     cpusets: new round-robin rotor for SLAB allocations
has been added to the -mm tree.  Its filename is
     cpusets-new-round-robin-rotor-for-slab-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: new round-robin rotor for SLAB allocations
From: Jack Steiner <steiner@sgi.com>

We have observed several workloads running on multi-node systems where
memory is assigned unevenly across the nodes in the system.  There are
numerous reasons for this but one is the round-robin rotor in
cpuset_mem_spread_node().

For example, a simple test that writes a multi-page file will allocate
pages on nodes 0 2 4 6 ...  Odd nodes are skipped.  (Sometimes it
allocates on odd nodes & skips even nodes).

An example is shown below.  The program "lfile" writes a file consisting
of 10 pages.  The program then mmaps the file & uses get_mempolicy(...,
MPOL_F_NODE) to determine the nodes where the file pages were allocated. 
The output is shown below:

	# ./lfile
	 allocated on nodes: 2 4 6 0 1 2 6 0 2

There is a single rotor that is used for allocating both file pages & slab
pages.  Writing the file allocates both a data page & a slab page
(buffer_head).  This advances the RR rotor 2 nodes for each page
allocated.

A quick confirmation seems to confirm this is the cause of the uneven
allocation:

	# echo 0 >/dev/cpuset/memory_spread_slab
	# ./lfile
	 allocated on nodes: 6 7 8 9 0 1 2 3 4 5

This patch introduces a second rotor that is used for slab allocations.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Paul Menage <menage@google.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |    6 ++++++
 include/linux/sched.h  |    1 +
 kernel/cpuset.c        |   20 ++++++++++++++++----
 mm/slab.c              |    2 +-
 4 files changed, 24 insertions(+), 5 deletions(-)

diff -puN include/linux/cpuset.h~cpusets-new-round-robin-rotor-for-slab-allocations include/linux/cpuset.h
--- a/include/linux/cpuset.h~cpusets-new-round-robin-rotor-for-slab-allocations
+++ a/include/linux/cpuset.h
@@ -69,6 +69,7 @@ extern void cpuset_task_status_allowed(s
 					struct task_struct *task);
 
 extern int cpuset_mem_spread_node(void);
+extern int cpuset_slab_spread_node(void);
 
 static inline int cpuset_do_page_mem_spread(void)
 {
@@ -159,6 +160,11 @@ static inline int cpuset_mem_spread_node
 	return 0;
 }
 
+static inline int cpuset_slab_spread_node(void)
+{
+	return 0;
+}
+
 static inline int cpuset_do_page_mem_spread(void)
 {
 	return 0;
diff -puN include/linux/sched.h~cpusets-new-round-robin-rotor-for-slab-allocations include/linux/sched.h
--- a/include/linux/sched.h~cpusets-new-round-robin-rotor-for-slab-allocations
+++ a/include/linux/sched.h
@@ -1423,6 +1423,7 @@ struct task_struct {
 #ifdef CONFIG_CPUSETS
 	nodemask_t mems_allowed;	/* Protected by alloc_lock */
 	int cpuset_mem_spread_rotor;
+	int cpuset_slab_spread_rotor;
 #endif
 #ifdef CONFIG_CGROUPS
 	/* Control Group info protected by css_set_lock */
diff -puN kernel/cpuset.c~cpusets-new-round-robin-rotor-for-slab-allocations kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-new-round-robin-rotor-for-slab-allocations
+++ a/kernel/cpuset.c
@@ -2427,7 +2427,8 @@ void cpuset_unlock(void)
 }
 
 /**
- * cpuset_mem_spread_node() - On which node to begin search for a page
+ * cpuset_mem_spread_node() - On which node to begin search for a file page
+ * cpuset_slab_spread_node() - On which node to begin search for a slab page
  *
  * If a task is marked PF_SPREAD_PAGE or PF_SPREAD_SLAB (as for
  * tasks in a cpuset with is_spread_page or is_spread_slab set),
@@ -2452,16 +2453,27 @@ void cpuset_unlock(void)
  * See kmem_cache_alloc_node().
  */
 
-int cpuset_mem_spread_node(void)
+static int cpuset_spread_node(int *rotor)
 {
 	int node;
 
-	node = next_node(current->cpuset_mem_spread_rotor, current->mems_allowed);
+	node = next_node(*rotor, current->mems_allowed);
 	if (node == MAX_NUMNODES)
 		node = first_node(current->mems_allowed);
-	current->cpuset_mem_spread_rotor = node;
+	*rotor = node;
 	return node;
 }
+
+int cpuset_mem_spread_node(void)
+{
+	return cpuset_spread_node(&current->cpuset_mem_spread_rotor);
+}
+
+int cpuset_slab_spread_node(void)
+{
+	return cpuset_spread_node(&current->cpuset_slab_spread_rotor);
+}
+
 EXPORT_SYMBOL_GPL(cpuset_mem_spread_node);
 
 /**
diff -puN mm/slab.c~cpusets-new-round-robin-rotor-for-slab-allocations mm/slab.c
--- a/mm/slab.c~cpusets-new-round-robin-rotor-for-slab-allocations
+++ a/mm/slab.c
@@ -3242,7 +3242,7 @@ static void *alternate_node_alloc(struct
 		return NULL;
 	nid_alloc = nid_here = numa_node_id();
 	if (cpuset_do_slab_mem_spread() && (cachep->flags & SLAB_MEM_SPREAD))
-		nid_alloc = cpuset_mem_spread_node();
+		nid_alloc = cpuset_slab_spread_node();
 	else if (current->mempolicy)
 		nid_alloc = slab_node(current->mempolicy);
 	if (nid_alloc != nid_here)
_

Patches currently in -mm which might be from steiner@sgi.com are

linux-next.patch
cpusets-new-round-robin-rotor-for-slab-allocations.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
pids-increase-pid_max-based-on-num_possible_cpus.patch

