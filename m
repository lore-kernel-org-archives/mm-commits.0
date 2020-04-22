From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-swapfilec-omit-a-duplicate-code-by-compare-tmp-and-max-first.patch added
 to -mm tree
Date: Tue, 21 Apr 2020 18:36:38 -0700
Message-ID: <20200422013638.ByMs9qJ_A%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbgDVBgl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 21 Apr 2020 21:36:41 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, tim.c.chen@linux.intel.com, ying.huang@intel.com


The patch titled
     Subject: mm/swapfile.c: omit a duplicate code by compare tmp and max first
has been added to the -mm tree.  Its filename is
     mm-swapfilec-omit-a-duplicate-code-by-compare-tmp-and-max-first.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapfilec-omit-a-duplicate-code-by-compare-tmp-and-max-first.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfilec-omit-a-duplicate-code-by-compare-tmp-and-max-first.patch

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

mm-swapfilec-offset-is-only-used-when-there-is-more-slots.patch
mm-swapfilec-explicitly-show-ssd-non-ssd-is-handled-mutually-exclusive.patch
mm-swapfilec-remove-the-unnecessary-goto-for-ssd-case.patch
mm-swapfilec-simplify-the-calculation-of-n_goal.patch
mm-swapfilec-remove-the-extra-check-in-scan_swap_map_slots.patch
mm-swapfilec-found_free-could-be-represented-by-tmp-max.patch
mm-swapfilec-tmp-is-always-smaller-than-max.patch
mm-swapfilec-omit-a-duplicate-code-by-compare-tmp-and-max-first.patch
mm-page_allocc-bad_-is-not-necessary-when-pagehwpoison.patch
mm-page_allocc-bad_flags-is-not-necessary-for-bad_page.patch
mm-page_allocc-rename-free_pages_check_bad-to-check_free_page_bad.patch
mm-page_allocc-rename-free_pages_check-to-check_free_page.patch
mm-page_allocc-extract-check__page_bad-common-part-to-page_bad_reason.patch
mm-page_allocc-use-node_mask_none-in-build_zonelists.patch
mm-rename-gfpflags_to_migratetype-to-gfp_migratetype-for-same-convention.patch
mm-vmscanc-use-update_lru_size-in-update_lru_sizes.patch
