From: akpm@linux-foundation.org
Subject: - jfs-convert-to-new-aops.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:33:27 -0700
Message-ID: <200710162033.l9GKXREK014793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57703 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754366AbXJPVp5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:45:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, shaggy@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     jfs: convert to new aops
has been removed from the -mm tree.  Its filename was
     jfs-convert-to-new-aops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: jfs: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/inode.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN fs/jfs/inode.c~jfs-convert-to-new-aops fs/jfs/inode.c
--- a/fs/jfs/inode.c~jfs-convert-to-new-aops
+++ a/fs/jfs/inode.c
@@ -255,7 +255,7 @@ int jfs_get_block(struct inode *ip, sect
 
 static int jfs_writepage(struct page *page, struct writeback_control *wbc)
 {
-	return nobh_writepage(page, jfs_get_block, wbc);
+	return block_write_full_page(page, jfs_get_block, wbc);
 }
 
 static int jfs_writepages(struct address_space *mapping,
@@ -275,10 +275,13 @@ static int jfs_readpages(struct file *fi
 	return mpage_readpages(mapping, pages, nr_pages, jfs_get_block);
 }
 
-static int jfs_prepare_write(struct file *file,
-			     struct page *page, unsigned from, unsigned to)
-{
-	return nobh_prepare_write(page, from, to, jfs_get_block);
+static int jfs_write_begin(struct file *file, struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned flags,
+				struct page **pagep, void **fsdata)
+{
+	*pagep = NULL;
+	return block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+				jfs_get_block);
 }
 
 static sector_t jfs_bmap(struct address_space *mapping, sector_t block)
@@ -302,8 +305,8 @@ const struct address_space_operations jf
 	.writepage	= jfs_writepage,
 	.writepages	= jfs_writepages,
 	.sync_page	= block_sync_page,
-	.prepare_write	= jfs_prepare_write,
-	.commit_write	= nobh_commit_write,
+	.write_begin	= jfs_write_begin,
+	.write_end	= generic_write_end,
 	.bmap		= jfs_bmap,
 	.direct_IO	= jfs_direct_IO,
 };
@@ -356,7 +359,7 @@ void jfs_truncate(struct inode *ip)
 {
 	jfs_info("jfs_truncate: size = 0x%lx", (ulong) ip->i_size);
 
-	nobh_truncate_page(ip->i_mapping, ip->i_size);
+	block_truncate_page(ip->i_mapping, ip->i_size, jfs_get_block);
 
 	IWRITE_LOCK(ip, RDWRLOCK_NORMAL);
 	jfs_truncate_nolock(ip, ip->i_size);
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
