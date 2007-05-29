From: akpm@linux-foundation.org
Subject: + fuse-convert-to-new-aops.patch added to -mm tree
Date: Tue, 29 May 2007 14:20:38 -0700
Message-ID: <200705292120.l4TLKcPh011812@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229AbXE2VVK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:21:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, mszeredi@suse.cz


The patch titled
     fuse: convert to new aops
has been added to the -mm tree.  Its filename is
     fuse-convert-to-new-aops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 33 insertions(+), 15 deletions(-)

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
