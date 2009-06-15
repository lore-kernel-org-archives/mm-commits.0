From: akpm@linux-foundation.org
Subject: + vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim-mm-fix-documentation-of-min_unmapped_ratio.patch added to -mm tree
Date: Mon, 15 Jun 2009 09:02:43 -0700
Message-ID: <200906151602.n5FG2hPw026202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757007AbZFOQEz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 12:04:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, cl@linux-foundation.org, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, stable@kernel.org


The patch titled
     mm: fix documentation of min_unmapped_ratio
has been added to the -mm tree.  Its filename is
     vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim-mm-fix-documentation-of-min_unmapped_ratio.patch

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
Subject: mm: fix documentation of min_unmapped_ratio
From: Mel Gorman <mel@csn.ul.ie>

Kosaki Motohiro pointed out that the documentation for min_unmapped_ratio
no longer matches the implementation.  This patch updates the
documentation.

This patch can be merged with
vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-re
claim.patch .

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN Documentation/sysctl/vm.txt~vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim-mm-fix-documentation-of-min_unmapped_ratio Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim-mm-fix-documentation-of-min_unmapped_ratio
+++ a/Documentation/sysctl/vm.txt
@@ -315,10 +315,14 @@ min_unmapped_ratio:
 
 This is available only on NUMA kernels.
 
-A percentage of the total pages in each zone.  Zone reclaim will only
-occur if more than this percentage of pages are file backed and unmapped.
-This is to insure that a minimal amount of local pages is still available for
-file I/O even if the node is overallocated.
+This is a percentage of the total pages in each zone. Zone reclaim will
+only occur if more than this percentage of pages are in a state that
+zone_reclaim_mode allows to be reclaimed.
+
+If zone_reclaim_mode has the value 4 OR'd, then the percentage is compared
+against all file-backed unmapped pages including swapcache pages and tmpfs
+files. Otherwise, only unmapped pages backed by normal files but not tmpfs
+files and similar are considered.
 
 The default is 1 percent.
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch
mm-alloc_large_system_hash-check-order.patch
page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid.patch
page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation.patch
page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch
page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-calculate-the-migratetype-for-allocation-only-once.patch
page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-inline-__rmqueue_smallest.patch
page-allocator-inline-buffered_rmqueue.patch
page-allocator-inline-__rmqueue_fallback.patch
page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary.patch
page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch
page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node.patch
page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array.patch
page-allocator-update-nr_free_pages-only-as-necessary.patch
page-allocator-update-nr_free_pages-only-as-necessary-fix.patch
page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro.patch
page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch
page-allocator-move-free_page_mlock-to-page_allocc.patch
page-allocator-sanity-check-order-in-the-page-allocator-slow-path.patch
mm-use-alloc_pages_exact-in-alloc_large_system_hash-to-avoid-duplicated-logic.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator-fix-gfp-zone-patch.patch
page-allocator-clean-up-functions-related-to-pages_min.patch
oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
oom-avoid-unnecessary-mm-locking-and-scanning-for-oom_disable.patch
oom-invoke-oom-killer-for-__gfp_nofail.patch
page-allocator-clear-n_high_memory-map-before-se-set-it-again.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports-fix.patch
vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim.patch
vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim-vmscan-fix-use-of-delta-in-zone_pagecache_reclaimable.patch
vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim-mm-fix-documentation-of-min_unmapped_ratio.patch
vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full.patch
vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails.patch
add-debugging-aid-for-memory-initialisation-problems.patch

