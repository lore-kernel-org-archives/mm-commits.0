From: akpm@linux-foundation.org
Subject: [merged]
 mm-swapfilec-offset-is-only-used-when-there-is-more-slots.patch removed
 from -mm tree
Date: Tue, 02 Jun 2020 14:40:10 -0700
Message-ID: <20200602214010.RfJGKNpsP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgFBVkL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:40:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, tim.c.chen@linux.intel.com


The patch titled
     Subject: mm/swapfile.c: offset is only used when there is more slots
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-offset-is-only-used-when-there-is-more-slots.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/swapfile.c: offset is only used when there is more slots

scan_swap_map_slots() is used to iterate swap_map[] array for an available
swap entry.  While after several optimizations, e.g.  for ssd case, the
logic of this function is a little not easy to catch.

This patchset tries to clean up the logic a little:

  * shows the ssd/non-ssd case is handled mutually exclusively
  * remove some unnecessary goto for ssd case


This patch (of 3):

When si->cluster_nr is zero, function would reach done and return.  The
increased offset would not be used any more.  This means we can move the
offset increment into the if clause.

This brings a further code cleanup possibility.

Link: http://lkml.kernel.org/r/20200328060520.31449-1-richard.weiyang@gmail.com
Link: http://lkml.kernel.org/r/20200328060520.31449-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-offset-is-only-used-when-there-is-more-slots
+++ a/mm/swapfile.c
@@ -874,11 +874,9 @@ checks:
 		else
 			goto done;
 	}
-	/* non-ssd case */
-	++offset;
 
 	/* non-ssd case, still more slots in cluster? */
-	if (si->cluster_nr && !si->swap_map[offset]) {
+	if (si->cluster_nr && !si->swap_map[++offset]) {
 		--si->cluster_nr;
 		goto checks;
 	}
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
