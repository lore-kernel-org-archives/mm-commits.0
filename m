From: akpm@linux-foundation.org
Subject: [folded-merged] mm-reclaim-madv_free-pages-fix.patch removed from -mm tree
Date: Wed, 03 May 2017 14:34:54 -0700
Message-ID: <590a4cfe.FznT5rYIM4S8F3cX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44910 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbdECVe4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:34:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, shli@fb.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clean up lazyfree page handling
has been removed from the -mm tree.  Its filename was
     mm-reclaim-madv_free-pages-fix.patch

This patch was dropped because it was folded into mm-reclaim-madv_free-pages.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: clean up lazyfree page handling

We can make it simple to understand without need to be aware of
clean-swapin page.
This patch just clean up lazyfree page handling in try_to_unmap_one.

Link: http://lkml.kernel.org/r/20170303025237.GB3503@bbox
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Shaohua Li <shli@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN mm/rmap.c~mm-reclaim-madv_free-pages-fix mm/rmap.c
--- a/mm/rmap.c~mm-reclaim-madv_free-pages-fix
+++ a/mm/rmap.c
@@ -1421,17 +1421,17 @@ static int try_to_unmap_one(struct page
 			VM_BUG_ON_PAGE(!PageSwapCache(page) && PageSwapBacked(page),
 				page);
 
-			/*
-			 * swapin page could be clean, it has data stored in
-			 * swap. We can't silently discard it without setting
-			 * swap entry in the page table.
-			 */
-			if (!PageDirty(page) && !PageSwapCache(page)) {
-				/* It's a freeable page by MADV_FREE */
-				dec_mm_counter(mm, MM_ANONPAGES);
-				goto discard;
-			} else if (!PageSwapBacked(page)) {
-				/* dirty MADV_FREE page */
+			/* MADV_FREE page check */
+			if (!PageSwapBacked(page)) {
+				if (!PageDirty(page)) {
+					dec_mm_counter(mm, MM_ANONPAGES);
+					goto discard;
+				}
+
+				/*
+				 * If the page was redirtied, it cannot be
+				 * discarded. Remap the page to page table.
+				 */
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				ret = SWAP_DIRTY;
 				page_vma_mapped_walk_done(&pvmw);
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-reclaim-madv_free-pages.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one-fix.patch
mm-do-not-use-double-negation-for-testing-page-flags.patch
mm-remove-unncessary-ret-in-page_referenced.patch
mm-remove-swap_dirty-in-ttu.patch
mm-remove-swap_mlock-check-for-swap_success-in-ttu.patch
mm-make-the-try_to_munlock-void-function.patch
mm-make-the-try_to_munlock-void-function-fix.patch
mm-remove-swap_mlock-in-ttu.patch
mm-remove-swap_again-in-ttu.patch
mm-make-ttus-return-boolean.patch
mm-make-rmap_walk-void-function.patch
mm-make-rmap_one-boolean-function.patch
mm-remove-swap_.patch
mm-remove-swap_-fix.patch
zram-handle-multiple-pages-attached-bios-bvec.patch
zram-partial-io-refactoring.patch
zram-use-zram_slot_lock-instead-of-raw-bit_spin_lock-op.patch
zram-remove-zram_meta-structure.patch
zram-introduce-zram-data-accessor.patch
zram-use-zram_free_page-instead-of-open-coded.patch

