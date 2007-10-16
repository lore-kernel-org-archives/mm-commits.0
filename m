From: akpm@linux-foundation.org
Subject: - ext2-convert-to-new-aops-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:14:17 -0700
Message-ID: <200710160414.l9G4EHmE008195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36044 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763264AbXJPEOV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:14:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     ext2 convert to new aops fix
has been removed from the -mm tree.  Its filename was
     ext2-convert-to-new-aops-fix.patch

This patch was dropped because it was folded into ext2-convert-to-new-aops.patch

------------------------------------------------------
Subject: ext2 convert to new aops fix
From: Nick Piggin <npiggin@suse.de>

These are some write_begin aops conversion fixes for the current -mm tree.  I
didn't quite get it building, but did compile test at least.

Patches all address the same silly bug in my directory pagecache conversions.

ext2 directory code has a conversion overflow.  Spotted by Hugh Dickins. 
Probably would hurt anyone in practice unless they are using >4GB directories,
but must fix.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/dir.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ext2/dir.c~ext2-convert-to-new-aops-fix fs/ext2/dir.c
--- a/fs/ext2/dir.c~ext2-convert-to-new-aops-fix
+++ a/fs/ext2/dir.c
@@ -424,7 +424,7 @@ ino_t ext2_inode_by_name(struct inode * 
 void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
 			struct page *page, struct inode *inode)
 {
-	loff_t pos = (page->index << PAGE_CACHE_SHIFT) +
+	loff_t pos = page_offset(page) +
 			(char *) de - (char *) page_address(page);
 	unsigned len = le16_to_cpu(de->rec_len);
 	int err;
@@ -511,7 +511,7 @@ int ext2_add_link (struct dentry *dentry
 	return -EINVAL;
 
 got_it:
-	pos = (page->index << PAGE_CACHE_SHIFT) +
+	pos = page_offset(page) +
 		(char*)de - (char*)page_address(page);
 	err = __ext2_write_begin(NULL, page->mapping, pos, rec_len, 0,
 							&page, NULL);
@@ -569,7 +569,7 @@ int ext2_delete_entry (struct ext2_dir_e
 	}
 	if (pde)
 		from = (char*)pde - (char*)page_address(page);
-	pos = (page->index << PAGE_CACHE_SHIFT) + from;
+	pos = page_offset(page) + from;
 	lock_page(page);
 	err = __ext2_write_begin(NULL, page->mapping, pos, to - from, 0,
 							&page, NULL);
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
ext2-convert-to-new-aops-fix.patch
ext2-convert-to-new-aops-fix2.patch
ext3-convert-to-new-aops.patch
ext3-convert-to-new-aops-fix.patch
ext3-convert-to-new-aops-fix-fix.patch
ext4-convert-to-new-aops.patch
ext4-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops-fix-fix.patch
xfs-convert-to-new-aops.patch
gfs2-convert-to-new-aops-fix.patch
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
reiserfs-convert-to-new-aops-fix2.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
hostfs-convert-to-new-aops-fix.patch
hostfs-convert-to-new-aops-fix-fix.patch
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
