From: akpm@linux-foundation.org
Subject: + mm-restore-kernel_ds-optimisations.patch added to -mm tree
Date: Tue, 29 May 2007 14:19:57 -0700
Message-ID: <200705292119.l4TLJvaJ011729@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751117AbXE2VUD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:20:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mm: restore KERNEL_DS optimisations
has been added to the -mm tree.  Its filename is
     mm-restore-kernel_ds-optimisations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: restore KERNEL_DS optimisations
From: Nick Piggin <npiggin@suse.de>

Restore the KERNEL_DS optimisation, especially helpful to the 2copy write
path.

This may be a pretty questionable gain in most cases, especially after the
legacy 2copy write path is removed, but it doesn't cost much.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff -puN mm/filemap.c~mm-restore-kernel_ds-optimisations mm/filemap.c
--- a/mm/filemap.c~mm-restore-kernel_ds-optimisations
+++ a/mm/filemap.c
@@ -2103,7 +2103,7 @@ static ssize_t generic_perform_write_2co
 		 * cannot take a pagefault with the destination page locked.
 		 * So pin the source page to copy it.
 		 */
-		if (!PageUptodate(page)) {
+		if (!PageUptodate(page) && !segment_eq(get_fs(), KERNEL_DS)) {
 			unlock_page(page);
 
 			src_page = alloc_page(GFP_KERNEL);
@@ -2228,6 +2228,13 @@ static ssize_t generic_perform_write(str
 	const struct address_space_operations *a_ops = mapping->a_ops;
 	long status = 0;
 	ssize_t written = 0;
+	unsigned int flags = 0;
+
+	/*
+	 * Copies from kernel address space cannot fail (NFSD is a big user).
+	 */
+	if (segment_eq(get_fs(), KERNEL_DS))
+		flags |= AOP_FLAG_UNINTERRUPTIBLE;
 
 	do {
 		struct page *page;
@@ -2259,7 +2266,7 @@ again:
 			break;
 		}
 
-		status = a_ops->write_begin(file, mapping, pos, bytes, 0,
+		status = a_ops->write_begin(file, mapping, pos, bytes, flags,
 						&page, &fsdata);
 		if (unlikely(status))
 			break;
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
git-arm-master.patch
slob-rework-freelist-handling.patch
slob-remove-bigblock-tracking.patch
slob-improved-alignment-handling.patch
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
ext4-convert-to-new-aops.patch
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
mm-document-fault_data-and-flags.patch
fs-introduce-some-page-buffer-invariants.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
