From: akpm@linux-foundation.org
Subject: - fuse-update-file-size-on-short-read.patch removed from -mm tree
Date: Thu, 01 May 2008 02:32:08 -0700
Message-ID: <200805010932.m419W8a8030959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757071AbYEAJcN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:32:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: update file size on short read
has been removed from the -mm tree.  Its filename was
     fuse-update-file-size-on-short-read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fuse: update file size on short read
From: Miklos Szeredi <mszeredi@suse.cz>

If the READ request returned a short count, then either

  - cached size is incorrect
  - filesystem is buggy, as short reads are only allowed on EOF

So assume that the size is wrong and refresh it, so that cached read() doesn't
zero fill the missing chunk.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c    |    2 -
 fs/fuse/file.c   |   52 +++++++++++++++++++++++++++++++++++++++------
 fs/fuse/fuse_i.h |    7 +++++-
 3 files changed, 53 insertions(+), 8 deletions(-)

diff -puN fs/fuse/dir.c~fuse-update-file-size-on-short-read fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-update-file-size-on-short-read
+++ a/fs/fuse/dir.c
@@ -132,7 +132,7 @@ static void fuse_lookup_init(struct fuse
 	req->out.args[0].value = outarg;
 }
 
-static u64 fuse_get_attr_version(struct fuse_conn *fc)
+u64 fuse_get_attr_version(struct fuse_conn *fc)
 {
 	u64 curr_version;
 
diff -puN fs/fuse/file.c~fuse-update-file-size-on-short-read fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-update-file-size-on-short-read
+++ a/fs/fuse/file.c
@@ -363,7 +363,7 @@ static int fuse_fsync(struct file *file,
 void fuse_read_fill(struct fuse_req *req, struct file *file,
 		    struct inode *inode, loff_t pos, size_t count, int opcode)
 {
-	struct fuse_read_in *inarg = &req->misc.read_in;
+	struct fuse_read_in *inarg = &req->misc.read.in;
 	struct fuse_file *ff = file->private_data;
 
 	inarg->fh = ff->fh;
@@ -389,7 +389,7 @@ static size_t fuse_send_read(struct fuse
 
 	fuse_read_fill(req, file, inode, pos, count, FUSE_READ);
 	if (owner != NULL) {
-		struct fuse_read_in *inarg = &req->misc.read_in;
+		struct fuse_read_in *inarg = &req->misc.read.in;
 
 		inarg->read_flags |= FUSE_READ_LOCKOWNER;
 		inarg->lock_owner = fuse_lock_owner_id(fc, owner);
@@ -398,11 +398,29 @@ static size_t fuse_send_read(struct fuse
 	return req->out.args[0].size;
 }
 
+static void fuse_read_update_size(struct inode *inode, loff_t size,
+				  u64 attr_ver)
+{
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
+
+	spin_lock(&fc->lock);
+	if (attr_ver == fi->attr_version && size < inode->i_size) {
+		fi->attr_version = ++fc->attr_version;
+		i_size_write(inode, size);
+	}
+	spin_unlock(&fc->lock);
+}
+
 static int fuse_readpage(struct file *file, struct page *page)
 {
 	struct inode *inode = page->mapping->host;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_req *req;
+	size_t num_read;
+	loff_t pos = page_offset(page);
+	size_t count = PAGE_CACHE_SIZE;
+	u64 attr_ver;
 	int err;
 
 	err = -EIO;
@@ -421,15 +439,25 @@ static int fuse_readpage(struct file *fi
 	if (IS_ERR(req))
 		goto out;
 
+	attr_ver = fuse_get_attr_version(fc);
+
 	req->out.page_zeroing = 1;
 	req->num_pages = 1;
 	req->pages[0] = page;
-	fuse_send_read(req, file, inode, page_offset(page), PAGE_CACHE_SIZE,
-		       NULL);
+	num_read = fuse_send_read(req, file, inode, pos, count, NULL);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
-	if (!err)
+
+	if (!err) {
+		/*
+		 * Short read means EOF.  If file size is larger, truncate it
+		 */
+		if (num_read < count)
+			fuse_read_update_size(inode, pos + num_read, attr_ver);
+
 		SetPageUptodate(page);
+	}
+
 	fuse_invalidate_attr(inode); /* atime changed */
  out:
 	unlock_page(page);
@@ -439,8 +467,19 @@ static int fuse_readpage(struct file *fi
 static void fuse_readpages_end(struct fuse_conn *fc, struct fuse_req *req)
 {
 	int i;
+	size_t count = req->misc.read.in.size;
+	size_t num_read = req->out.args[0].size;
+	struct inode *inode = req->pages[0]->mapping->host;
 
-	fuse_invalidate_attr(req->pages[0]->mapping->host); /* atime changed */
+	/*
+	 * Short read means EOF.  If file size is larger, truncate it
+	 */
+	if (!req->out.h.error && num_read < count) {
+		loff_t pos = page_offset(req->pages[0]) + num_read;
+		fuse_read_update_size(inode, pos, req->misc.read.attr_ver);
+	}
+
+	fuse_invalidate_attr(inode); /* atime changed */
 
 	for (i = 0; i < req->num_pages; i++) {
 		struct page *page = req->pages[i];
@@ -463,6 +502,7 @@ static void fuse_send_readpages(struct f
 	size_t count = req->num_pages << PAGE_CACHE_SHIFT;
 	req->out.page_zeroing = 1;
 	fuse_read_fill(req, file, inode, pos, count, FUSE_READ);
+	req->misc.read.attr_ver = fuse_get_attr_version(fc);
 	if (fc->async_read) {
 		struct fuse_file *ff = file->private_data;
 		req->ff = fuse_file_get(ff);
diff -puN fs/fuse/fuse_i.h~fuse-update-file-size-on-short-read fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-update-file-size-on-short-read
+++ a/fs/fuse/fuse_i.h
@@ -239,7 +239,10 @@ struct fuse_req {
 		} release;
 		struct fuse_init_in init_in;
 		struct fuse_init_out init_out;
-		struct fuse_read_in read_in;
+		struct {
+			struct fuse_read_in in;
+			u64 attr_ver;
+		} read;
 		struct {
 			struct fuse_write_in in;
 			struct fuse_write_out out;
@@ -637,3 +640,5 @@ void fuse_flush_writepages(struct inode 
 
 void fuse_set_nowrite(struct inode *inode);
 void fuse_release_nowrite(struct inode *inode);
+
+u64 fuse_get_attr_version(struct fuse_conn *fc);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
vfs-fix-permission-checking-in-sys_utimensat.patch

