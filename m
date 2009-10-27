From: akpm@linux-foundation.org
Subject: + vmscan-force-kswapd-to-take-notice-faster-when-high-order-watermarks-are-being-hit.patch added to -mm tree
Date: Tue, 27 Oct 2009 13:19:18 -0700
Message-ID: <200910272019.n9RKJJh5017690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756765AbZJ0UTv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Oct 2009 16:19:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, riel@redhat.com


The patch titled
     vmscan: force kswapd to take notice faster when high-order watermarks are being hit
has been added to the -mm tree.  Its filename is
     vmscan-force-kswapd-to-take-notice-faster-when-high-order-watermarks-are-being-hit.patch

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
Subject: vmscan: force kswapd to take notice faster when high-order watermarks are being hit
From: Mel Gorman <mel@csn.ul.ie>

When a high-order allocation fails, kswapd is kicked so that it reclaims
at a higher-order to avoid direct reclaimers stall and to help GFP_ATOMIC
allocations.  Something has changed in recent kernels that affect the
timing where high-order GFP_ATOMIC allocations are now failing with more
frequency, particularly under pressure.  This patch forces kswapd to
notice sooner that high-order allocations are occuring.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/vmscan.c~vmscan-force-kswapd-to-take-notice-faster-when-high-order-watermarks-are-being-hit mm/vmscan.c
--- a/mm/vmscan.c~vmscan-force-kswapd-to-take-notice-faster-when-high-order-watermarks-are-being-hit
+++ a/mm/vmscan.c
@@ -2026,6 +2026,15 @@ loop_again:
 					priority != DEF_PRIORITY)
 				continue;
 
+			/*
+			 * Exit the function now and have kswapd start over
+			 * if it is known that higher orders are required
+			 */
+			if (pgdat->kswapd_max_order > order) {
+				all_zones_ok = 1;
+				goto out;
+			}
+
 			if (!zone_watermark_ok(zone, order,
 					high_wmark_pages(zone), end_zone, 0))
 				all_zones_ok = 0;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

mm-order-evictable-rescue-in-lru-putback.patch
page-allocator-always-wake-kswapd-when-restarting-an-allocation-attempt-after-direct-reclaim-failed.patch
page-allocator-do-not-allow-interrupts-to-use-alloc_harder.patch
vmscan-force-kswapd-to-take-notice-faster-when-high-order-watermarks-are-being-hit.patch
linux-next.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
mm-add-notifier-in-pageblock-isolation-for-balloon-drivers.patch
powerpc-make-the-cmm-memory-hotplug-aware.patch
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
add-debugging-aid-for-memory-initialisation-problems.patch

