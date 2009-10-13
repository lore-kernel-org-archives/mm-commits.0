From: akpm@linux-foundation.org
Subject: + mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch added to -mm tree
Date: Tue, 13 Oct 2009 12:33:14 -0700
Message-ID: <200910131933.n9DJXEx6000556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934115AbZJMTfL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 15:35:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, agl@us.ibm.com, andi@firstfloor.org, apw@canonical.com, cl@linux-foundation.org, eric.whitney@hp.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, nacc@us.ibm.com, randy.dunlap@oracle.com


The patch titled
     mm: add gfp flags for NODEMASK_ALLOC slab allocations
has been added to the -mm tree.  Its filename is
     mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch

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
Subject: mm: add gfp flags for NODEMASK_ALLOC slab allocations
From: David Rientjes <rientjes@google.com>

Objects passed to NODEMASK_ALLOC() are relatively small in size and are
backed by slab caches that are not of large order, traditionally never
greater than PAGE_ALLOC_COSTLY_ORDER.

Thus, using GFP_KERNEL for these allocations on large machines when
CONFIG_NODES_SHIFT > 8 will cause the page allocator to loop endlessly in
the allocation attempt, each time invoking both direct reclaim or the oom
killer.

This is of particular interest when using NODEMASK_ALLOC() from a
mempolicy context (either directly in mm/mempolicy.c or the mempolicy
constrained hugetlb allocations) since the oom killer always kills current
when allocations are constrained by mempolicies.  So for all present use
cases in the kernel, current would end up being oom killed when direct
reclaim fails.  That would allow the NODEMASK_ALLOC() to succeed but
current would have sacrificed itself upon returning.

This patch adds gfp flags to NODEMASK_ALLOC() to pass to kmalloc() on
CONFIG_NODES_SHIFT > 8; this parameter is a nop on other configurations. 
All current use cases either directly from hugetlb code or indirectly via
NODEMASK_SCRATCH() union __GFP_NORETRY to avoid direct reclaim and the oom
killer when the slab allocator needs to allocate additional pages.

The side-effect of this change is that all current use cases of either
NODEMASK_ALLOC() or NODEMASK_SCRATCH() need appropriate -ENOMEM handling
when the allocation fails (never for CONFIG_NODES_SHIFT <= 8).  All
current use cases were audited and do have appropriate error handling at
this time.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Eric Whitney <eric.whitney@hp.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/nodemask.h~mm-add-gfp-flags-for-nodemask_alloc-slab-allocations include/linux/nodemask.h
--- a/include/linux/nodemask.h~mm-add-gfp-flags-for-nodemask_alloc-slab-allocations
+++ a/include/linux/nodemask.h
@@ -485,15 +485,17 @@ static inline int num_node_state(enum no
 #define for_each_online_node(node) for_each_node_state(node, N_ONLINE)
 
 /*
- * For nodemask scrach area.(See CPUMASK_ALLOC() in cpumask.h)
- * NODEMASK_ALLOC(x, m) allocates an object of type 'x' with the name 'm'.
+ * For nodemask scrach area.
+ * NODEMASK_ALLOC(type, name) allocates an object with a specified type and
+ * name.
  */
-#if NODES_SHIFT > 8 /* nodemask_t > 64 bytes */
-#define NODEMASK_ALLOC(x, m)		x *m = kmalloc(sizeof(*m), GFP_KERNEL)
-#define NODEMASK_FREE(m)		kfree(m)
+#if NODES_SHIFT > 8 /* nodemask_t > 256 bytes */
+#define NODEMASK_ALLOC(type, name, gfp_flags)	\
+			type *name = kmalloc(sizeof(*name), gfp_flags)
+#define NODEMASK_FREE(m)			kfree(m)
 #else
-#define NODEMASK_ALLOC(x, m)		x _m, *m = &_m
-#define NODEMASK_FREE(m)		do {} while (0)
+#define NODEMASK_ALLOC(type, name, gfp_flags)	type _name, *name = &_name
+#define NODEMASK_FREE(m)			do {} while (0)
 #endif
 
 /* A example struture for using NODEMASK_ALLOC, used in mempolicy. */
@@ -502,8 +504,9 @@ struct nodemask_scratch {
 	nodemask_t	mask2;
 };
 
-#define NODEMASK_SCRATCH(x)	\
-		NODEMASK_ALLOC(struct nodemask_scratch, x)
+#define NODEMASK_SCRATCH(x)						\
+			NODEMASK_ALLOC(struct nodemask_scratch, x,	\
+					GFP_KERNEL | __GFP_NORETRY)
 #define NODEMASK_SCRATCH_FREE(x)	NODEMASK_FREE(x)
 
 
diff -puN mm/hugetlb.c~mm-add-gfp-flags-for-nodemask_alloc-slab-allocations mm/hugetlb.c
--- a/mm/hugetlb.c~mm-add-gfp-flags-for-nodemask_alloc-slab-allocations
+++ a/mm/hugetlb.c
@@ -1361,7 +1361,7 @@ static ssize_t nr_hugepages_store_common
 	int nid;
 	unsigned long count;
 	struct hstate *h;
-	NODEMASK_ALLOC(nodemask_t, nodes_allowed);
+	NODEMASK_ALLOC(nodemask_t, nodes_allowed, GFP_KERNEL | __GFP_NORETRY);
 
 	err = strict_strtoul(buf, 10, &count);
 	if (err)
@@ -1857,7 +1857,8 @@ static int hugetlb_sysctl_handler_common
 	proc_doulongvec_minmax(table, write, buffer, length, ppos);
 
 	if (write) {
-		NODEMASK_ALLOC(nodemask_t, nodes_allowed);
+		NODEMASK_ALLOC(nodemask_t, nodes_allowed,
+						GFP_KERNEL | __GFP_NORETRY);
 		if (!(obey_mempolicy &&
 			       init_nodemask_of_mempolicy(nodes_allowed))) {
 			NODEMASK_FREE(nodes_allowed);
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
revert-mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
oom-dump-stack-and-vm-state-when-oom-killer-panics.patch
nodemask-make-nodemask_alloc-more-general.patch
hugetlb-rework-hstate_next_node_-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix.patch
hugetlb-factor-init_nodemask_of_node.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-add-generic-definition-of-numa_no_node.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-update-hugetlb-documentation-for-numa-controls.patch
hugetlb-use-only-nodes-with-memory-for-huge-pages.patch
mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch
hugetlb-handle-memory-hot-plug-events.patch
hugetlb-offload-per-node-attribute-registrations.patch
mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

