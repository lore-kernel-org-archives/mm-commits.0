From: akpm@linux-foundation.org
Subject: +
 mm-swapfilec-remove-the-unnecessary-goto-for-ssd-case.patch added to -mm
 tree
Date: Fri, 17 Apr 2020 17:14:48 -0700
Message-ID: <20200418001448.cnOEiHR3U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbgDRAOv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 20:14:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, tim.c.chen@linux.intel.com


The patch titled
     Subject: mm/swapfile.c: remove the unnecessary goto for SSD case
has been added to the -mm tree.  Its filename is
     mm-swapfilec-remove-the-unnecessary-goto-for-ssd-case.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapfilec-remove-the-unnecessary-goto-for-ssd-case.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfilec-remove-the-unnecessary-goto-for-ssd-case.patch

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
Subject: mm/swapfile.c: remove the unnecessary goto for SSD case

Now we can see there is redundant goto for SSD case.  In these two places,
we can just let the code walk through to the correct tag instead of
explicitly jump to it.

Let's remove them for better readability.

Link: http://lkml.kernel.org/r/20200328060520.31449-4-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-remove-the-unnecessary-goto-for-ssd-case
+++ a/mm/swapfile.c
@@ -759,9 +759,7 @@ static int scan_swap_map_slots(struct sw
 
 	/* SSD algorithm */
 	if (si->cluster_info) {
-		if (scan_swap_map_try_ssd_cluster(si, &offset, &scan_base))
-			goto checks;
-		else
+		if (!scan_swap_map_try_ssd_cluster(si, &offset, &scan_base))
 			goto scan;
 	} else if (unlikely(!si->cluster_nr--)) {
 		if (si->pages - si->inuse_pages < SWAPFILE_CLUSTER) {
@@ -869,8 +867,6 @@ checks:
 	if (si->cluster_info) {
 		if (scan_swap_map_try_ssd_cluster(si, &offset, &scan_base))
 			goto checks;
-		else
-			goto done;
 	} else if (si->cluster_nr && !si->swap_map[++offset]) {
 		/* non-ssd case, still more slots in cluster? */
 		--si->cluster_nr;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-swapfilec-offset-is-only-used-when-there-is-more-slots.patch
mm-swapfilec-explicitly-show-ssd-non-ssd-is-handled-mutually-exclusive.patch
mm-swapfilec-remove-the-unnecessary-goto-for-ssd-case.patch
mm-page_allocc-bad_-is-not-necessary-when-pagehwpoison.patch
mm-page_allocc-bad_flags-is-not-necessary-for-bad_page.patch
mm-page_allocc-rename-free_pages_check_bad-to-check_free_page_bad.patch
mm-page_allocc-rename-free_pages_check-to-check_free_page.patch
mm-page_allocc-extract-check__page_bad-common-part-to-page_bad_reason.patch
mm-page_allocc-use-node_mask_none-in-build_zonelists.patch
mm-rename-gfpflags_to_migratetype-to-gfp_migratetype-for-same-convention.patch
mm-vmscanc-use-update_lru_size-in-update_lru_sizes.patch
