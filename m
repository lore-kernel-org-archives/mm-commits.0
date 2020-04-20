From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-swapfilec-compare-tmp-and-max-after-trying-to-iterate-on-swap_map.patch
 removed from -mm tree
Date: Mon, 20 Apr 2020 15:10:27 -0700
Message-ID: <20200420221027.HHl1fYTfV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgDTWK2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 18:10:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, tim.c.chen@linux.intel.com, ying.huang@intel.com


The patch titled
     Subject: mm/swapfile.c: compare tmp and max after trying to iterate on swap_map
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-compare-tmp-and-max-after-trying-to-iterate-on-swap_map.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/swapfile.c: compare tmp and max after trying to iterate on swap_map

There are two duplicate code to handle the case when there is no
available swap entry. Just let the code go through and do the check at
second place.

No functional change is expected.

Link: http://lkml.kernel.org/r/20200419013921.14390-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-compare-tmp-and-max-after-trying-to-iterate-on-swap_map
+++ a/mm/swapfile.c
@@ -629,10 +629,6 @@ new_cluster:
 	tmp = cluster->next;
 	max = min_t(unsigned long, si->max,
 		    (cluster_next(&cluster->index) + 1) * SWAPFILE_CLUSTER);
-	if (tmp >= max) {
-		cluster_set_null(&cluster->index);
-		goto new_cluster;
-	}
 	ci = lock_cluster(si, tmp);
 	while (tmp < max) {
 		if (!si->swap_map[tmp])
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-swapfilec-offset-is-only-used-when-there-is-more-slots.patch
mm-swapfilec-explicitly-show-ssd-non-ssd-is-handled-mutually-exclusive.patch
mm-swapfilec-remove-the-unnecessary-goto-for-ssd-case.patch
mm-swapfilec-simplify-the-calculation-of-n_goal.patch
mm-swapfilec-remove-the-extra-check-in-scan_swap_map_slots.patch
mm-swapfilec-move-new_cluster-to-check-free_clusters-directly.patch
mm-page_allocc-bad_-is-not-necessary-when-pagehwpoison.patch
mm-page_allocc-bad_flags-is-not-necessary-for-bad_page.patch
mm-page_allocc-rename-free_pages_check_bad-to-check_free_page_bad.patch
mm-page_allocc-rename-free_pages_check-to-check_free_page.patch
mm-page_allocc-extract-check__page_bad-common-part-to-page_bad_reason.patch
mm-page_allocc-use-node_mask_none-in-build_zonelists.patch
mm-rename-gfpflags_to_migratetype-to-gfp_migratetype-for-same-convention.patch
mm-vmscanc-use-update_lru_size-in-update_lru_sizes.patch
