From: akpm@linux-foundation.org
Subject: - fs-adfs-convert-to-new-aops.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:33:29 -0700
Message-ID: <200710162033.l9GKXTvo014796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33261 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966150AbXJPVn1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:43:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs: adfs convert to new aops
has been removed from the -mm tree.  Its filename was
     fs-adfs-convert-to-new-aops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: adfs convert to new aops
From: Nick Piggin <npiggin@suse.de>

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/inode.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN fs/adfs/inode.c~fs-adfs-convert-to-new-aops fs/adfs/inode.c
--- a/fs/adfs/inode.c~fs-adfs-convert-to-new-aops
+++ a/fs/adfs/inode.c
@@ -61,10 +61,14 @@ static int adfs_readpage(struct file *fi
 	return block_read_full_page(page, adfs_get_block);
 }
 
-static int adfs_prepare_write(struct file *file, struct page *page, unsigned int from, unsigned int to)
+static int adfs_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
 {
-	return cont_prepare_write(page, from, to, adfs_get_block,
-		&ADFS_I(page->mapping->host)->mmu_private);
+	*pagep = NULL;
+	return cont_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+				adfs_get_block,
+				&ADFS_I(mapping->host)->mmu_private);
 }
 
 static sector_t _adfs_bmap(struct address_space *mapping, sector_t block)
@@ -76,8 +80,8 @@ static const struct address_space_operat
 	.readpage	= adfs_readpage,
 	.writepage	= adfs_writepage,
 	.sync_page	= block_sync_page,
-	.prepare_write	= adfs_prepare_write,
-	.commit_write	= generic_commit_write,
+	.write_begin	= adfs_write_begin,
+	.write_end	= generic_write_end,
 	.bmap		= _adfs_bmap
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
