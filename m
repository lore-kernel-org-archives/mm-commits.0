From: akpm@linux-foundation.org
Subject: - hfsplus-convert-to-new-aops.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:32:48 -0700
Message-ID: <200710162032.l9GKWmKf014652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60394 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966218AbXJPVre (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:47:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hfsplus: convert to new aops
has been removed from the -mm tree.  Its filename was
     hfsplus-convert-to-new-aops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hfsplus: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/extents.c |   21 +++++++++------------
 fs/hfsplus/inode.c   |   20 ++++++++++++--------
 2 files changed, 21 insertions(+), 20 deletions(-)

diff -puN fs/hfsplus/extents.c~hfsplus-convert-to-new-aops fs/hfsplus/extents.c
--- a/fs/hfsplus/extents.c~hfsplus-convert-to-new-aops
+++ a/fs/hfsplus/extents.c
@@ -443,21 +443,18 @@ void hfsplus_file_truncate(struct inode 
 	if (inode->i_size > HFSPLUS_I(inode).phys_size) {
 		struct address_space *mapping = inode->i_mapping;
 		struct page *page;
-		u32 size = inode->i_size - 1;
+		void *fsdata;
+		u32 size = inode->i_size;
 		int res;
 
-		page = grab_cache_page(mapping, size >> PAGE_CACHE_SHIFT);
-		if (!page)
-			return;
-		size &= PAGE_CACHE_SIZE - 1;
-		size++;
-		res = mapping->a_ops->prepare_write(NULL, page, size, size);
-		if (!res)
-			res = mapping->a_ops->commit_write(NULL, page, size, size);
+		res = pagecache_write_begin(NULL, mapping, size, 0,
+						AOP_FLAG_UNINTERRUPTIBLE,
+						&page, &fsdata);
 		if (res)
-			inode->i_size = HFSPLUS_I(inode).phys_size;
-		unlock_page(page);
-		page_cache_release(page);
+			return;
+		res = pagecache_write_end(NULL, mapping, size, 0, 0, page, fsdata);
+		if (res < 0)
+			return;
 		mark_inode_dirty(inode);
 		return;
 	} else if (inode->i_size == HFSPLUS_I(inode).phys_size)
diff -puN fs/hfsplus/inode.c~hfsplus-convert-to-new-aops fs/hfsplus/inode.c
--- a/fs/hfsplus/inode.c~hfsplus-convert-to-new-aops
+++ a/fs/hfsplus/inode.c
@@ -27,10 +27,14 @@ static int hfsplus_writepage(struct page
 	return block_write_full_page(page, hfsplus_get_block, wbc);
 }
 
-static int hfsplus_prepare_write(struct file *file, struct page *page, unsigned from, unsigned to)
-{
-	return cont_prepare_write(page, from, to, hfsplus_get_block,
-		&HFSPLUS_I(page->mapping->host).phys_size);
+static int hfsplus_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
+{
+	*pagep = NULL;
+	return cont_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+				hfsplus_get_block,
+				&HFSPLUS_I(mapping->host).phys_size);
 }
 
 static sector_t hfsplus_bmap(struct address_space *mapping, sector_t block)
@@ -114,8 +118,8 @@ const struct address_space_operations hf
 	.readpage	= hfsplus_readpage,
 	.writepage	= hfsplus_writepage,
 	.sync_page	= block_sync_page,
-	.prepare_write	= hfsplus_prepare_write,
-	.commit_write	= generic_commit_write,
+	.write_begin	= hfsplus_write_begin,
+	.write_end	= generic_write_end,
 	.bmap		= hfsplus_bmap,
 	.releasepage	= hfsplus_releasepage,
 };
@@ -124,8 +128,8 @@ const struct address_space_operations hf
 	.readpage	= hfsplus_readpage,
 	.writepage	= hfsplus_writepage,
 	.sync_page	= block_sync_page,
-	.prepare_write	= hfsplus_prepare_write,
-	.commit_write	= generic_commit_write,
+	.write_begin	= hfsplus_write_begin,
+	.write_end	= generic_write_end,
 	.bmap		= hfsplus_bmap,
 	.direct_IO	= hfsplus_direct_IO,
 	.writepages	= hfsplus_writepages,
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
