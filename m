From: akpm@linux-foundation.org
Subject: - fat-convert-to-new-aops.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:32:44 -0700
Message-ID: <200710162032.l9GKWiCc014626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55876 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754366AbXJPVpy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:45:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: convert to new aops
has been removed from the -mm tree.  Its filename was
     fat-convert-to-new-aops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fat: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff -puN fs/fat/inode.c~fat-convert-to-new-aops fs/fat/inode.c
--- a/fs/fat/inode.c~fat-convert-to-new-aops
+++ a/fs/fat/inode.c
@@ -141,19 +141,24 @@ static int fat_readpages(struct file *fi
 	return mpage_readpages(mapping, pages, nr_pages, fat_get_block);
 }
 
-static int fat_prepare_write(struct file *file, struct page *page,
-			     unsigned from, unsigned to)
+static int fat_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
 {
-	return cont_prepare_write(page, from, to, fat_get_block,
-				  &MSDOS_I(page->mapping->host)->mmu_private);
+	*pagep = NULL;
+	return cont_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+				fat_get_block,
+				&MSDOS_I(mapping->host)->mmu_private);
 }
 
-static int fat_commit_write(struct file *file, struct page *page,
-			    unsigned from, unsigned to)
+static int fat_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *pagep, void *fsdata)
 {
-	struct inode *inode = page->mapping->host;
-	int err = generic_commit_write(file, page, from, to);
-	if (!err && !(MSDOS_I(inode)->i_attrs & ATTR_ARCH)) {
+	struct inode *inode = mapping->host;
+	int err;
+	err = generic_write_end(file, mapping, pos, len, copied, pagep, fsdata);
+	if (!(err < 0) && !(MSDOS_I(inode)->i_attrs & ATTR_ARCH)) {
 		inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
 		MSDOS_I(inode)->i_attrs |= ATTR_ARCH;
 		mark_inode_dirty(inode);
@@ -202,8 +207,8 @@ static const struct address_space_operat
 	.writepage	= fat_writepage,
 	.writepages	= fat_writepages,
 	.sync_page	= block_sync_page,
-	.prepare_write	= fat_prepare_write,
-	.commit_write	= fat_commit_write,
+	.write_begin	= fat_write_begin,
+	.write_end	= fat_write_end,
 	.direct_IO	= fat_direct_IO,
 	.bmap		= _fat_bmap
 };
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
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
