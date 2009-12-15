From: akpm@linux-foundation.org
Subject: [merged] mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:51:16 -0800
Message-ID: <200912152151.nBFLpGXD015018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761384AbZLOWWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:22:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, agl@us.ibm.com, andi@firstfloor.org, apw@canonical.com, cl@linux-foundation.org, eric.whitney@hp.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel


The patch titled
     mm: clear node in N_HIGH_MEMORY and stop kswapd when all memory is offlined
has been removed from the -mm tree.  Its filename was
     mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 include/linux/swap.h |    1 +
 mm/memory_hotplug.c  |    4 ++++
 mm/vmscan.c          |   28 ++++++++++++++++++++++------
 3 files changed, 27 insertions(+), 6 deletions(-)

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
@@ -853,6 +853,10 @@ repeat:
 
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
@@ -2173,6 +2173,7 @@ static int kswapd(void *p)
 	order = 0;
 	for ( ; ; ) {
 		unsigned long new_order;
+		int ret;
 
 		prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
 		new_order = pgdat->kswapd_max_order;
@@ -2184,19 +2185,23 @@ static int kswapd(void *p)
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
@@ -2451,6 +2456,17 @@ int kswapd_run(int nid)
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

origin.patch
acpi-remove-nid_inval.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

