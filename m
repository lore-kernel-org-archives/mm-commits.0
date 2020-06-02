From: akpm@linux-foundation.org
Subject: [merged]
 mm-swapfilec-omit-a-duplicate-code-by-compare-tmp-and-max-first.patch
 removed from -mm tree
Date: Tue, 02 Jun 2020 14:40:22 -0700
Message-ID: <20200602214022.OMcDpYwWk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727794AbgFBVkX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:40:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, tim.c.chen@linux.intel.com, ying.huang@intel.com


The patch titled
     Subject: mm/swapfile.c: omit a duplicate code by compare tmp and max first
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-omit-a-duplicate-code-by-compare-tmp-and-max-first.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/swapfile.c: omit a duplicate code by compare tmp and max first

There are two duplicate code to handle the case when there is no available
swap entry.  To avoid this, we can compare tmp and max first and let the
second guard do its job.

No functional change is expected.

Link: http://lkml.kernel.org/r/20200421213824.8099-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-omit-a-duplicate-code-by-compare-tmp-and-max-first
+++ a/mm/swapfile.c
@@ -629,17 +629,15 @@ new_cluster:
 	tmp = cluster->next;
 	max = min_t(unsigned long, si->max,
 		    (cluster_next(&cluster->index) + 1) * SWAPFILE_CLUSTER);
-	if (tmp >= max) {
-		cluster_set_null(&cluster->index);
-		goto new_cluster;
-	}
-	ci = lock_cluster(si, tmp);
-	while (tmp < max) {
-		if (!si->swap_map[tmp])
-			break;
-		tmp++;
+	if (tmp < max) {
+		ci = lock_cluster(si, tmp);
+		while (tmp < max) {
+			if (!si->swap_map[tmp])
+				break;
+			tmp++;
+		}
+		unlock_cluster(ci);
 	}
-	unlock_cluster(ci);
 	if (tmp >= max) {
 		cluster_set_null(&cluster->index);
 		goto new_cluster;
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
