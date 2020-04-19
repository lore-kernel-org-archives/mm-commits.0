From: akpm@linux-foundation.org
Subject: +
 mm-swapfilec-move-new_cluster-to-check-free_clusters-directly.patch added
 to -mm tree
Date: Sat, 18 Apr 2020 20:57:28 -0700
Message-ID: <20200419035728.hOeCxpchk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbgDSD53 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 18 Apr 2020 23:57:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, tim.c.chen@linux.intel.com, ying.huang@intel.com


The patch titled
     Subject: mm/swapfile.c: move new_cluster to check free_clusters directly
has been added to the -mm tree.  Its filename is
     mm-swapfilec-move-new_cluster-to-check-free_clusters-directly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapfilec-move-new_cluster-to-check-free_clusters-directly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfilec-move-new_cluster-to-check-free_clusters-directly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/swapfile.c: move new_cluster to check free_clusters directly

Each time it needs jump to new_cluster, it is sure current
percpu_cluster is null.

Move the new_cluster to check free_clusters directly.

Link: http://lkml.kernel.org/r/20200419013921.14390-4-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swapfilec-move-new_cluster-to-check-free_clusters-directly
+++ a/mm/swapfile.c
@@ -603,9 +603,9 @@ static bool scan_swap_map_try_ssd_cluste
 	struct swap_cluster_info *ci;
 	unsigned long tmp, max;
 
-new_cluster:
 	cluster = this_cpu_ptr(si->percpu_cluster);
 	if (cluster_is_null(&cluster->index)) {
+new_cluster:
 		if (!cluster_list_empty(&si->free_clusters)) {
 			cluster->index = si->free_clusters.head;
 			cluster->next = cluster_next(&cluster->index) *
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-swapfilec-offset-is-only-used-when-there-is-more-slots.patch
mm-swapfilec-explicitly-show-ssd-non-ssd-is-handled-mutually-exclusive.patch
mm-swapfilec-remove-the-unnecessary-goto-for-ssd-case.patch
mm-swapfilec-simplify-the-calculation-of-n_goal.patch
mm-swapfilec-remove-the-extra-check-in-scan_swap_map_slots.patch
mm-swapfilec-found_free-could-be-represented-by-tmp-max.patch
mm-swapfilec-tmp-is-always-smaller-than-max.patch
mm-swapfilec-compare-tmp-and-max-after-trying-to-iterate-on-swap_map.patch
mm-swapfilec-move-new_cluster-to-check-free_clusters-directly.patch
mm-page_allocc-bad_-is-not-necessary-when-pagehwpoison.patch
mm-page_allocc-bad_flags-is-not-necessary-for-bad_page.patch
mm-page_allocc-rename-free_pages_check_bad-to-check_free_page_bad.patch
mm-page_allocc-rename-free_pages_check-to-check_free_page.patch
mm-page_allocc-extract-check__page_bad-common-part-to-page_bad_reason.patch
mm-page_allocc-use-node_mask_none-in-build_zonelists.patch
mm-rename-gfpflags_to_migratetype-to-gfp_migratetype-for-same-convention.patch
mm-vmscanc-use-update_lru_size-in-update_lru_sizes.patch
