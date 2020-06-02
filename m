From: akpm@linux-foundation.org
Subject: [merged]
 mm-swapfilec-found_free-could-be-represented-by-tmp-max.patch removed from
 -mm tree
Date: Tue, 02 Jun 2020 14:40:20 -0700
Message-ID: <20200602214020.6Fdafo56B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgFBVkV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:40:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, tim.c.chen@linux.intel.com, ying.huang@intel.com


The patch titled
     Subject: mm/swapfile.c: found_free could be represented by (tmp < max)
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-found_free-could-be-represented-by-tmp-max.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/swapfile.c: found_free could be represented by (tmp < max)

This is not necessary to use the variable found_free to record the status.
Just check tmp and max is enough.

Link: http://lkml.kernel.org/r/20200421213824.8099-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-found_free-could-be-represented-by-tmp-max
+++ a/mm/swapfile.c
@@ -601,7 +601,6 @@ static bool scan_swap_map_try_ssd_cluste
 {
 	struct percpu_cluster *cluster;
 	struct swap_cluster_info *ci;
-	bool found_free;
 	unsigned long tmp, max;
 
 new_cluster:
@@ -623,8 +622,6 @@ new_cluster:
 			return false;
 	}
 
-	found_free = false;
-
 	/*
 	 * Other CPUs can use our cluster if they can't find a free cluster,
 	 * check if there is still free entry in the cluster
@@ -638,21 +635,19 @@ new_cluster:
 	}
 	ci = lock_cluster(si, tmp);
 	while (tmp < max) {
-		if (!si->swap_map[tmp]) {
-			found_free = true;
+		if (!si->swap_map[tmp])
 			break;
-		}
 		tmp++;
 	}
 	unlock_cluster(ci);
-	if (!found_free) {
+	if (tmp >= max) {
 		cluster_set_null(&cluster->index);
 		goto new_cluster;
 	}
 	cluster->next = tmp + 1;
 	*offset = tmp;
 	*scan_base = tmp;
-	return found_free;
+	return tmp < max;
 }
 
 static void __del_from_avail_list(struct swap_info_struct *p)
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-page_allocc-bad_-is-not-necessary-when-pagehwpoison.patch
mm-page_allocc-bad_flags-is-not-necessary-for-bad_page.patch
mm-page_allocc-rename-free_pages_check_bad-to-check_free_page_bad.patch
mm-page_allocc-rename-free_pages_check-to-check_free_page.patch
mm-page_allocc-extract-check__page_bad-common-part-to-page_bad_reason.patch
mm-page_allocc-use-node_mask_none-in-build_zonelists.patch
mm-rename-gfpflags_to_migratetype-to-gfp_migratetype-for-same-convention.patch
mm-vmscanc-use-update_lru_size-in-update_lru_sizes.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch
lib-make-a-test-module-with-get_count_order-long.patch
