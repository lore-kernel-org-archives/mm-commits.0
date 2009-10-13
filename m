From: akpm@linux-foundation.org
Subject: + mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch added to -mm tree
Date: Tue, 13 Oct 2009 12:33:05 -0700
Message-ID: <200910131933.n9DJX5ww032671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703AbZJMTfY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 15:35:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, agl@us.ibm.com, andi@firstfloor.org, apw@canonical.com, cl@linux-foundation.org, eric.whitney@hp.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, nacc@us.ibm.com, randy.dunlap@oracle.com, riel@redhat.com, rjw@sisk.pl, y-goto@jp.fujitsu.com


The patch titled
     mm: clear node in N_HIGH_MEMORY and stop kswapd when all memory is offlined
has been added to the -mm tree.  Its filename is
     mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch

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
Subject: mm: clear node in N_HIGH_MEMORY and stop kswapd when all memory is offlined
From: David Rientjes <rientjes@google.com>

When memory is hot-removed, its node must be cleared in N_HIGH_MEMORY if
there are no present pages left.

In such a situation, kswapd must also be stopped since it has nothing left
to do.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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


diff -puN include/linux/swap.h~mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined include/linux/swap.h
--- a/include/linux/swap.h~mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined
+++ a/include/linux/swap.h
@@ -273,6 +273,7 @@ extern int scan_unevictable_register_nod
 extern void scan_unevictable_unregister_node(struct node *node);
 
 extern int kswapd_run(int nid);
+extern void kswapd_stop(int nid);
 
 #ifdef CONFIG_MMU
 /* linux/mm/shmem.c */
diff -puN mm/memory_hotplug.c~mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined
+++ a/mm/memory_hotplug.c
@@ -842,6 +842,10 @@ repeat:
 
 	setup_per_zone_wmarks();
 	calculate_zone_inactive_ratio(zone);
+	if (!node_present_pages(node)) {
+		node_clear_state(node, N_HIGH_MEMORY);
+		kswapd_stop(node);
+	}
 
 	vm_total_pages = nr_free_pagecache_pages();
 	writeback_set_ratelimit();
diff -puN mm/vmscan.c~mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined mm/vmscan.c
--- a/mm/vmscan.c~mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined
+++ a/mm/vmscan.c
@@ -2167,6 +2167,7 @@ static int kswapd(void *p)
 	order = 0;
 	for ( ; ; ) {
 		unsigned long new_order;
+		int ret;
 
 		prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
 		new_order = pgdat->kswapd_max_order;
@@ -2178,19 +2179,23 @@ static int kswapd(void *p)
 			 */
 			order = new_order;
 		} else {
-			if (!freezing(current))
+			if (!freezing(current) && !kthread_should_stop())
 				schedule();
 
 			order = pgdat->kswapd_max_order;
 		}
 		finish_wait(&pgdat->kswapd_wait, &wait);
 
-		if (!try_to_freeze()) {
-			/* We can speed up thawing tasks if we don't call
-			 * balance_pgdat after returning from the refrigerator
-			 */
+		ret = try_to_freeze();
+		if (kthread_should_stop())
+			break;
+
+		/*
+		 * We can speed up thawing tasks if we don't call balance_pgdat
+		 * after returning from the refrigerator
+		 */
+		if (!ret)
 			balance_pgdat(pgdat, order);
-		}
 	}
 	return 0;
 }
@@ -2445,6 +2450,17 @@ int kswapd_run(int nid)
 	return ret;
 }
 
+/*
+ * Called by memory hotplug when all memory in a node is offlined.
+ */
+void kswapd_stop(int nid)
+{
+	struct task_struct *kswapd = NODE_DATA(nid)->kswapd;
+
+	if (kswapd)
+		kthread_stop(kswapd);
+}
+
 static int __init kswapd_init(void)
 {
 	int nid;
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

