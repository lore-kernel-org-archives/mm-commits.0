From: akpm@linux-foundation.org
Subject: - ufs-convert-to-new-aops-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:19:35 -0700
Message-ID: <200710160419.l9G4JZeS008405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48642 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752263AbXJPETk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:19:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     ufs convert to new aops fix
has been removed from the -mm tree.  Its filename was
     ufs-convert-to-new-aops-fix.patch

This patch was dropped because it was folded into ufs-convert-to-new-aops.patch

------------------------------------------------------
Subject: ufs convert to new aops fix
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/dir.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ufs/dir.c~ufs-convert-to-new-aops-fix fs/ufs/dir.c
--- a/fs/ufs/dir.c~ufs-convert-to-new-aops-fix
+++ a/fs/ufs/dir.c
@@ -89,7 +89,7 @@ ino_t ufs_inode_by_name(struct inode *di
 void ufs_set_link(struct inode *dir, struct ufs_dir_entry *de,
 		  struct page *page, struct inode *inode)
 {
-	loff_t pos = (page->index << PAGE_CACHE_SHIFT) +
+	loff_t pos = page_offset(page) +
 			(char *) de - (char *) page_address(page);
 	unsigned len = fs16_to_cpu(dir->i_sb, de->d_reclen);
 	int err;
@@ -379,7 +379,7 @@ int ufs_add_link(struct dentry *dentry, 
 	return -EINVAL;
 
 got_it:
-	pos = (page->index << PAGE_CACHE_SHIFT) +
+	pos = page_offset(page) +
 			(char*)de - (char*)page_address(page);
 	err = __ufs_write_begin(NULL, page->mapping, pos, rec_len,
 				AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
@@ -547,7 +547,7 @@ int ufs_delete_entry(struct inode *inode
 	if (pde)
 		from = (char*)pde - (char*)page_address(page);
 
-	pos = (page->index << PAGE_CACHE_SHIFT) + from;
+	pos = page_offset(page) + from;
 	lock_page(page);
 	err = __ufs_write_begin(NULL, mapping, pos, to - from,
 				AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
remove-zero_page.patch
mm-use-lockless-radix-tree-probe.patch
mm-improve-find_lock_page.patch
mm-clarify-__add_to_swap_cache-locking.patch
radix-tree-use-indirect-bit.patch
calculation-of-pgoff-in-do_linear_fault-uses-mixed.patch
fs-fix-nobh-error-handling.patch
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
ufs-convert-to-new-aops-fix.patch
ufs-convert-to-new-aops-fix2.patch
udf-convert-to-new-aops.patch
udf-convert-to-new-aops-fix.patch
sysv-convert-to-new-aops.patch
sysv-convert-to-new-aops-fix.patch
sysv-convert-to-new-aops-fix2.patch
minix-convert-to-new-aops.patch
minix-convert-to-new-aops-fix.patch
minix-convert-to-new-aops-fix2.patch
jfs-convert-to-new-aops.patch
fs-adfs-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch
affs-convert-to-new-aops-fix.patch
affs-convert-to-new-aops-fix-fix.patch
ocfs2-convert-to-new-aops.patch
fs-restore-nobh.patch
fs-restore-nobh-checkpatch-fixes.patch
fs-remove-some-aop_truncated_page.patch
make-swappiness-safer-to-use.patch
mm-document-tree_lock-zonelock-lockorder.patch
fs-reiserfs-cleanups.patch
atomic_opstxt-has-incorrect-misleading-and-insufficient-information.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
bitops-introduce-lock-ops.patch
alpha-fix-bitops.patch
alpha-lock-bitops.patch
alpha-lock-bitops-fix.patch
ia64-lock-bitops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
powerpc-lock-bitops.patch
powerpc-lock-bitops-fix.patch
bit_spin_lock-use-lock-bitops.patch
reiser4-fix-for-new-aops-patches.patch
