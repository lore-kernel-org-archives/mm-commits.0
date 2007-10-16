From: akpm@linux-foundation.org
Subject: - udf-convert-to-new-aops.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:33:19 -0700
Message-ID: <200710162033.l9GKXJIN014776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41094 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966422AbXJPVuc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:50:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, bfennema@falcon.csc.calpoly.edu, jack@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     udf: convert to new aops
has been removed from the -mm tree.  Its filename was
     udf-convert-to-new-aops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: udf: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Convert udf to new aops.  Also seem to have fixed pagecache corruption in
udf_adinicb_commit_write -- page was marked uptodate when it is not.  Also,
fixed the silly setup where prepare_write was doing a kmap to be used in
commit_write: just do kmap_atomic in write_end.  Use libfs helpers to make
this easier.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: <bfennema@falcon.csc.calpoly.edu>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/file.c  |   35 ++++++++++++++---------------------
 fs/udf/inode.c |   15 +++++++++------
 2 files changed, 23 insertions(+), 27 deletions(-)

diff -puN fs/udf/file.c~udf-convert-to-new-aops fs/udf/file.c
--- a/fs/udf/file.c~udf-convert-to-new-aops
+++ a/fs/udf/file.c
@@ -76,36 +76,29 @@ static int udf_adinicb_writepage(struct 
 	return 0;
 }
 
-static int udf_adinicb_prepare_write(struct file *file, struct page *page,
-				     unsigned offset, unsigned to)
+static int udf_adinicb_write_end(struct file *file,
+			struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
 {
-	kmap(page);
-	return 0;
-}
-
-static int udf_adinicb_commit_write(struct file *file, struct page *page,
-				    unsigned offset, unsigned to)
-{
-	struct inode *inode = page->mapping->host;
-	char *kaddr = page_address(page);
+	struct inode *inode = mapping->host;
+	unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
+	char *kaddr;
 
+	kaddr = kmap_atomic(page, KM_USER0);
 	memcpy(UDF_I_DATA(inode) + UDF_I_LENEATTR(inode) + offset,
-	       kaddr + offset, to - offset);
-	mark_inode_dirty(inode);
-	SetPageUptodate(page);
-	kunmap(page);
-	/* only one page here */
-	if (to > inode->i_size)
-		inode->i_size = to;
-	return 0;
+		kaddr + offset, copied);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	return simple_write_end(file, mapping, pos, len, copied, page, fsdata);
 }
 
 const struct address_space_operations udf_adinicb_aops = {
 	.readpage	= udf_adinicb_readpage,
 	.writepage	= udf_adinicb_writepage,
 	.sync_page	= block_sync_page,
-	.prepare_write	= udf_adinicb_prepare_write,
-	.commit_write	= udf_adinicb_commit_write,
+	.write_begin = simple_write_begin,
+	.write_end = udf_adinicb_write_end,
 };
 
 static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
diff -puN fs/udf/inode.c~udf-convert-to-new-aops fs/udf/inode.c
--- a/fs/udf/inode.c~udf-convert-to-new-aops
+++ a/fs/udf/inode.c
@@ -133,10 +133,13 @@ static int udf_readpage(struct file *fil
 	return block_read_full_page(page, udf_get_block);
 }
 
-static int udf_prepare_write(struct file *file, struct page *page,
-			     unsigned from, unsigned to)
-{
-	return block_prepare_write(page, from, to, udf_get_block);
+static int udf_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
+{
+	*pagep = NULL;
+	return block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+				udf_get_block);
 }
 
 static sector_t udf_bmap(struct address_space *mapping, sector_t block)
@@ -148,8 +151,8 @@ const struct address_space_operations ud
 	.readpage	= udf_readpage,
 	.writepage	= udf_writepage,
 	.sync_page	= block_sync_page,
-	.prepare_write	= udf_prepare_write,
-	.commit_write	= generic_commit_write,
+	.write_begin		= udf_write_begin,
+	.write_end		= generic_write_end,
 	.bmap		= udf_bmap,
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
