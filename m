From: akpm@linux-foundation.org
Subject: - fuse-convert-to-new-aops.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:33:09 -0700
Message-ID: <200710162033.l9GKX9n5014762@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60237 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966344AbXJPVrZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:47:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: convert to new aops
has been removed from the -mm tree.  Its filename was
     fuse-convert-to-new-aops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: convert to new aops
From: Nick Piggin <npiggin@suse.de>

[mszeredi]
 - don't send zero length write requests
 - it is not legal for the filesystem to return with zero written bytes

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c |   48 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff -puN fs/fuse/file.c~fuse-convert-to-new-aops fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-convert-to-new-aops
+++ a/fs/fuse/file.c
@@ -444,22 +444,25 @@ static size_t fuse_send_write(struct fus
 	return outarg.size;
 }
 
-static int fuse_prepare_write(struct file *file, struct page *page,
-			      unsigned offset, unsigned to)
-{
-	/* No op */
+static int fuse_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
+{
+	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
+
+	*pagep = __grab_cache_page(mapping, index);
+	if (!*pagep)
+		return -ENOMEM;
 	return 0;
 }
 
-static int fuse_commit_write(struct file *file, struct page *page,
-			     unsigned offset, unsigned to)
+static int fuse_buffered_write(struct file *file, struct inode *inode,
+			       loff_t pos, unsigned count, struct page *page)
 {
 	int err;
 	size_t nres;
-	unsigned count = to - offset;
-	struct inode *inode = page->mapping->host;
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	loff_t pos = page_offset(page) + offset;
+	unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
 	struct fuse_req *req;
 
 	if (is_bad_inode(inode))
@@ -475,20 +478,35 @@ static int fuse_commit_write(struct file
 	nres = fuse_send_write(req, file, inode, pos, count);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
-	if (!err && nres != count)
+	if (!err && !nres)
 		err = -EIO;
 	if (!err) {
-		pos += count;
+		pos += nres;
 		spin_lock(&fc->lock);
 		if (pos > inode->i_size)
 			i_size_write(inode, pos);
 		spin_unlock(&fc->lock);
 
-		if (offset == 0 && to == PAGE_CACHE_SIZE)
+		if (count == PAGE_CACHE_SIZE)
 			SetPageUptodate(page);
 	}
 	fuse_invalidate_attr(inode);
-	return err;
+	return err ? err : nres;
+}
+
+static int fuse_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
+{
+	struct inode *inode = mapping->host;
+	int res = 0;
+
+	if (copied)
+		res = fuse_buffered_write(file, inode, pos, copied, page);
+
+	unlock_page(page);
+	page_cache_release(page);
+	return res;
 }
 
 static void fuse_release_user_pages(struct fuse_req *req, int write)
@@ -819,8 +837,8 @@ static const struct file_operations fuse
 
 static const struct address_space_operations fuse_file_aops  = {
 	.readpage	= fuse_readpage,
-	.prepare_write	= fuse_prepare_write,
-	.commit_write	= fuse_commit_write,
+	.write_begin	= fuse_write_begin,
+	.write_end	= fuse_write_end,
 	.readpages	= fuse_readpages,
 	.set_page_dirty	= fuse_set_page_dirty,
 	.bmap		= fuse_bmap,
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
