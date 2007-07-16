From: akpm@linux-foundation.org
Subject: - mm-debug-check-for-the-fault-vs-invalidate-race.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:49:11 -0700
Message-ID: <200707162049.l6GKnBKj001142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46060 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756300AbXGPVUC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:20:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: debug check for the fault vs invalidate race
has been removed from the -mm tree.  Its filename was
     mm-debug-check-for-the-fault-vs-invalidate-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: debug check for the fault vs invalidate race
From: Nick Piggin <npiggin@suse.de>

Add a bugcheck for Andrea's pagefault vs invalidate race.  This is triggerable
for both linear and nonlinear pages with a userspace test harness (using
direct IO and truncate, respectively).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/filemap.c~mm-debug-check-for-the-fault-vs-invalidate-race mm/filemap.c
--- a/mm/filemap.c~mm-debug-check-for-the-fault-vs-invalidate-race
+++ a/mm/filemap.c
@@ -120,6 +120,7 @@ void __remove_from_page_cache(struct pag
 	page->mapping = NULL;
 	mapping->nrpages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
+	BUG_ON(page_mapped(page));
 }
 
 void remove_from_page_cache(struct page *page)
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-fault-feedback-1.patch
mm-fault-feedback-2.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
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
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
udf-convert-to-new-aops.patch
sysv-convert-to-new-aops.patch
minix-convert-to-new-aops.patch
jfs-convert-to-new-aops.patch
fs-adfs-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch
ocfs2-convert-to-new-aops.patch
fix-read-truncate-race.patch
fs-remove-some-aop_truncated_page.patch
fs-introduce-some-page-buffer-invariants.patch
fs-reiserfs-cleanups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
reiser4-fix-for-new-aops-patches.patch
