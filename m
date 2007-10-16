From: akpm@linux-foundation.org
Subject: - hfs-convert-to-new-aops.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:32:46 -0700
Message-ID: <200710162032.l9GKWkPX014649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39831 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966364AbXJPVrf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:47:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hfs: convert to new aops
has been removed from the -mm tree.  Its filename was
     hfs-convert-to-new-aops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hfs: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/extent.c |   19 ++++++++-----------
 fs/hfs/inode.c  |   20 ++++++++++++--------
 2 files changed, 20 insertions(+), 19 deletions(-)

diff -puN fs/hfs/extent.c~hfs-convert-to-new-aops fs/hfs/extent.c
--- a/fs/hfs/extent.c~hfs-convert-to-new-aops
+++ a/fs/hfs/extent.c
@@ -464,23 +464,20 @@ void hfs_file_truncate(struct inode *ino
 	       (long long)HFS_I(inode)->phys_size, inode->i_size);
 	if (inode->i_size > HFS_I(inode)->phys_size) {
 		struct address_space *mapping = inode->i_mapping;
+		void *fsdata;
 		struct page *page;
 		int res;
 
+		/* XXX: Can use generic_cont_expand? */
 		size = inode->i_size - 1;
-		page = grab_cache_page(mapping, size >> PAGE_CACHE_SHIFT);
-		if (!page)
-			return;
-		size &= PAGE_CACHE_SIZE - 1;
-		size++;
-		res = mapping->a_ops->prepare_write(NULL, page, size, size);
-		if (!res)
-			res = mapping->a_ops->commit_write(NULL, page, size, size);
+		res = pagecache_write_begin(NULL, mapping, size+1, 0,
+				AOP_FLAG_UNINTERRUPTIBLE, &page, &fsdata);
+		if (!res) {
+			res = pagecache_write_end(NULL, mapping, size+1, 0, 0,
+					page, fsdata);
+		}
 		if (res)
 			inode->i_size = HFS_I(inode)->phys_size;
-		unlock_page(page);
-		page_cache_release(page);
-		mark_inode_dirty(inode);
 		return;
 	} else if (inode->i_size == HFS_I(inode)->phys_size)
 		return;
diff -puN fs/hfs/inode.c~hfs-convert-to-new-aops fs/hfs/inode.c
--- a/fs/hfs/inode.c~hfs-convert-to-new-aops
+++ a/fs/hfs/inode.c
@@ -35,10 +35,14 @@ static int hfs_readpage(struct file *fil
 	return block_read_full_page(page, hfs_get_block);
 }
 
-static int hfs_prepare_write(struct file *file, struct page *page, unsigned from, unsigned to)
-{
-	return cont_prepare_write(page, from, to, hfs_get_block,
-				  &HFS_I(page->mapping->host)->phys_size);
+static int hfs_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
+{
+	*pagep = NULL;
+	return cont_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+				hfs_get_block,
+				&HFS_I(mapping->host)->phys_size);
 }
 
 static sector_t hfs_bmap(struct address_space *mapping, sector_t block)
@@ -119,8 +123,8 @@ const struct address_space_operations hf
 	.readpage	= hfs_readpage,
 	.writepage	= hfs_writepage,
 	.sync_page	= block_sync_page,
-	.prepare_write	= hfs_prepare_write,
-	.commit_write	= generic_commit_write,
+	.write_begin	= hfs_write_begin,
+	.write_end	= generic_write_end,
 	.bmap		= hfs_bmap,
 	.releasepage	= hfs_releasepage,
 };
@@ -129,8 +133,8 @@ const struct address_space_operations hf
 	.readpage	= hfs_readpage,
 	.writepage	= hfs_writepage,
 	.sync_page	= block_sync_page,
-	.prepare_write	= hfs_prepare_write,
-	.commit_write	= generic_commit_write,
+	.write_begin	= hfs_write_begin,
+	.write_end	= generic_write_end,
 	.bmap		= hfs_bmap,
 	.direct_IO	= hfs_direct_IO,
 	.writepages	= hfs_writepages,
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
