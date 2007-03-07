From: akpm@linux-foundation.org
Subject: + mm-fix-clear_page_dirty_for_io-vs-fault-race.patch added to -mm tree
Date: Wed, 07 Mar 2007 13:02:39 -0800
Message-ID: <200703072102.l27L2d4V008666@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57080 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423001AbXCGVC4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 16:02:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, miklos@szeredi.hu, torvalds@linux-foundation.org


The patch titled
     mm: fix clear_page_dirty_for_io vs fault race
has been added to the -mm tree.  Its filename is
     mm-fix-clear_page_dirty_for_io-vs-fault-race.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: fix clear_page_dirty_for_io vs fault race
From: Nick Piggin <npiggin@suse.de>

Fix msync data loss and (less importantly) dirty page accounting
inaccuracies due to the race remaining in clear_page_dirty_for_io().

The deleted comment explains what the race was, and the added comments
explain how it is fixed.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c         |    9 +++++++++
 mm/page-writeback.c |   17 ++++++++++++-----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff -puN mm/memory.c~mm-fix-clear_page_dirty_for_io-vs-fault-race mm/memory.c
--- a/mm/memory.c~mm-fix-clear_page_dirty_for_io-vs-fault-race
+++ a/mm/memory.c
@@ -1669,6 +1669,15 @@ gotten:
 unlock:
 	pte_unmap_unlock(page_table, ptl);
 	if (dirty_page) {
+		/*
+		 * Yes, Virginia, this is actually required to prevent a race
+		 * with clear_page_dirty_for_io() from clearing the page dirty
+		 * bit after it clear all dirty ptes, but before a racing
+		 * do_wp_page installs a dirty pte.
+		 *
+		 * do_no_page is protected similarly.
+		 */
+		wait_on_page_locked(dirty_page);
 		set_page_dirty_balance(dirty_page);
 		put_page(dirty_page);
 	}
diff -puN mm/page-writeback.c~mm-fix-clear_page_dirty_for_io-vs-fault-race mm/page-writeback.c
--- a/mm/page-writeback.c~mm-fix-clear_page_dirty_for_io-vs-fault-race
+++ a/mm/page-writeback.c
@@ -903,6 +903,8 @@ int clear_page_dirty_for_io(struct page 
 {
 	struct address_space *mapping = page_mapping(page);
 
+	BUG_ON(!PageLocked(page));
+
 	if (mapping && mapping_cap_account_dirty(mapping)) {
 		/*
 		 * Yes, Virginia, this is indeed insane.
@@ -928,14 +930,19 @@ int clear_page_dirty_for_io(struct page 
 		 * We basically use the page "master dirty bit"
 		 * as a serialization point for all the different
 		 * threads doing their things.
-		 *
-		 * FIXME! We still have a race here: if somebody
-		 * adds the page back to the page tables in
-		 * between the "page_mkclean()" and the "TestClearPageDirty()",
-		 * we might have it mapped without the dirty bit set.
 		 */
 		if (page_mkclean(page))
 			set_page_dirty(page);
+		/*
+		 * We carefully synchronise fault handlers against
+		 * installing a dirty pte and marking the page dirty
+		 * at this point. We do this by having them hold the
+		 * page lock at some point after installing their
+		 * pte, but before marking the page dirty.
+		 * Pages are always locked coming in here, so we get
+		 * the desired exclusion. See mm/memory.c:do_wp_page()
+		 * for more comments.
+		 */
 		if (TestClearPageDirty(page)) {
 			dec_zone_page_state(page, NR_FILE_DIRTY);
 			return 1;
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-remove-gcc-workaround.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch
mm-simplify-filemap_nopage.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
exec-fix-remove_arg_zero.patch
