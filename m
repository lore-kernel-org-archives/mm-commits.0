From: akpm@linux-foundation.org
Subject: - mm-fix-clear_page_dirty_for_io-vs-fault-race.patch removed from -mm tree
Date: Thu, 19 Jul 2007 12:59:40 -0700
Message-ID: <200707191959.l6JJxec5019372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35376 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755477AbXGSUEX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:04:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, miklos@szeredi.hu, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     mm: fix clear_page_dirty_for_io vs fault race
has been removed from the -mm tree.  Its filename was
     mm-fix-clear_page_dirty_for_io-vs-fault-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: fix clear_page_dirty_for_io vs fault race
From: Nick Piggin <npiggin@suse.de>

Fix msync data loss and (less importantly) dirty page accounting
inaccuracies due to the race remaining in clear_page_dirty_for_io().

The deleted comment explains what the race was, and the added comments
explain how it is fixed.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c         |    9 +++++++++
 mm/page-writeback.c |   17 ++++++++++++-----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff -puN mm/memory.c~mm-fix-clear_page_dirty_for_io-vs-fault-race mm/memory.c
--- a/mm/memory.c~mm-fix-clear_page_dirty_for_io-vs-fault-race
+++ a/mm/memory.c
@@ -1765,6 +1765,15 @@ gotten:
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
@@ -918,6 +918,8 @@ int clear_page_dirty_for_io(struct page 
 {
 	struct address_space *mapping = page_mapping(page);
 
+	BUG_ON(!PageLocked(page));
+
 	if (mapping && mapping_cap_account_dirty(mapping)) {
 		/*
 		 * Yes, Virginia, this is indeed insane.
@@ -943,14 +945,19 @@ int clear_page_dirty_for_io(struct page 
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

origin.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
mm-debug-write-deadlocks.patch
mm-trim-more-holes.patch
mm-buffered-write-cleanup.patch
mm-write-iovec-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
mm-buffered-write-iterator.patch
fs-fix-data-loss-on-error.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
introduce-write_begin-write_end-aops-important-fix.patch
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext3-convert-to-new-aops.patch
ext3-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops.patch
ext4-convert-to-new-aops-fix.patch
xfs-convert-to-new-aops.patch
fs-new-cont-helpers.patch
fat-convert-to-new-aops.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
hpfs-convert-to-new-aops.patch
bfs-convert-to-new-aops.patch
qnx4-convert-to-new-aops.patch
reiserfs-use-generic-write.patch
reiserfs-convert-to-new-aops.patch
reiserfs-convert-to-new-aops-fix.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
hostfs-convert-to-new-aops-fix.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
udf-convert-to-new-aops.patch
udf-convert-to-new-aops-fix.patch
sysv-convert-to-new-aops.patch
minix-convert-to-new-aops.patch
jfs-convert-to-new-aops.patch
fs-adfs-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch
affs-convert-to-new-aops-fix.patch
ocfs2-convert-to-new-aops.patch
fs-remove-some-aop_truncated_page.patch
fs-reiserfs-cleanups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
reiser4-fix-for-new-aops-patches.patch
