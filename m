From: akpm@linux-foundation.org
Subject: - fuse-pass-open-flags-to-read-and-write.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:22:50 -0800
Message-ID: <200712010022.lB10Mo87031948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48002 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756969AbXLAA1L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:27:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: pass open flags to read and write
has been removed from the -mm tree.  Its filename was
     fuse-pass-open-flags-to-read-and-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: pass open flags to read and write
From: Miklos Szeredi <mszeredi@suse.cz>

Some open flags (O_APPEND, O_DIRECT) can be changed with fcntl(F_SETFL, ...)
after open, but fuse currently only sends the flags to userspace in open.

To make it possible to correcly handle changing flags, send the
current value to userspace in each read and write.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c        |    3 +--
 fs/fuse/file.c       |   26 +++++++++++++++-----------
 fs/fuse/fuse_i.h     |    2 +-
 include/linux/fuse.h |    5 +++++
 4 files changed, 22 insertions(+), 14 deletions(-)

diff -puN fs/fuse/dir.c~fuse-pass-open-flags-to-read-and-write fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-pass-open-flags-to-read-and-write
+++ a/fs/fuse/dir.c
@@ -964,7 +964,6 @@ static int fuse_readdir(struct file *fil
 	struct page *page;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_file *ff = file->private_data;
 	struct fuse_req *req;
 
 	if (is_bad_inode(inode))
@@ -981,7 +980,7 @@ static int fuse_readdir(struct file *fil
 	}
 	req->num_pages = 1;
 	req->pages[0] = page;
-	fuse_read_fill(req, ff, inode, file->f_pos, PAGE_SIZE, FUSE_READDIR);
+	fuse_read_fill(req, file, inode, file->f_pos, PAGE_SIZE, FUSE_READDIR);
 	request_send(fc, req);
 	nbytes = req->out.args[0].size;
 	err = req->out.h.error;
diff -puN fs/fuse/file.c~fuse-pass-open-flags-to-read-and-write fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-pass-open-flags-to-read-and-write
+++ a/fs/fuse/file.c
@@ -289,14 +289,16 @@ static int fuse_fsync(struct file *file,
 	return fuse_fsync_common(file, de, datasync, 0);
 }
 
-void fuse_read_fill(struct fuse_req *req, struct fuse_file *ff,
+void fuse_read_fill(struct fuse_req *req, struct file *file,
 		    struct inode *inode, loff_t pos, size_t count, int opcode)
 {
 	struct fuse_read_in *inarg = &req->misc.read_in;
+	struct fuse_file *ff = file->private_data;
 
 	inarg->fh = ff->fh;
 	inarg->offset = pos;
 	inarg->size = count;
+	inarg->flags = file->f_flags;
 	req->in.h.opcode = opcode;
 	req->in.h.nodeid = get_node_id(inode);
 	req->in.numargs = 1;
@@ -313,9 +315,8 @@ static size_t fuse_send_read(struct fuse
 			     fl_owner_t owner)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_file *ff = file->private_data;
 
-	fuse_read_fill(req, ff, inode, pos, count, FUSE_READ);
+	fuse_read_fill(req, file, inode, pos, count, FUSE_READ);
 	if (owner != NULL) {
 		struct fuse_read_in *inarg = &req->misc.read_in;
 
@@ -376,15 +377,16 @@ static void fuse_readpages_end(struct fu
 	fuse_put_request(fc, req);
 }
 
-static void fuse_send_readpages(struct fuse_req *req, struct fuse_file *ff,
+static void fuse_send_readpages(struct fuse_req *req, struct file *file,
 				struct inode *inode)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	loff_t pos = page_offset(req->pages[0]);
 	size_t count = req->num_pages << PAGE_CACHE_SHIFT;
 	req->out.page_zeroing = 1;
-	fuse_read_fill(req, ff, inode, pos, count, FUSE_READ);
+	fuse_read_fill(req, file, inode, pos, count, FUSE_READ);
 	if (fc->async_read) {
+		struct fuse_file *ff = file->private_data;
 		req->ff = fuse_file_get(ff);
 		req->end = fuse_readpages_end;
 		request_send_background(fc, req);
@@ -396,7 +398,7 @@ static void fuse_send_readpages(struct f
 
 struct fuse_fill_data {
 	struct fuse_req *req;
-	struct fuse_file *ff;
+	struct file *file;
 	struct inode *inode;
 };
 
@@ -411,7 +413,7 @@ static int fuse_readpages_fill(void *_da
 	    (req->num_pages == FUSE_MAX_PAGES_PER_REQ ||
 	     (req->num_pages + 1) * PAGE_CACHE_SIZE > fc->max_read ||
 	     req->pages[req->num_pages - 1]->index + 1 != page->index)) {
-		fuse_send_readpages(req, data->ff, inode);
+		fuse_send_readpages(req, data->file, inode);
 		data->req = req = fuse_get_req(fc);
 		if (IS_ERR(req)) {
 			unlock_page(page);
@@ -435,7 +437,7 @@ static int fuse_readpages(struct file *f
 	if (is_bad_inode(inode))
 		goto out;
 
-	data.ff = file->private_data;
+	data.file = file;
 	data.inode = inode;
 	data.req = fuse_get_req(fc);
 	err = PTR_ERR(data.req);
@@ -445,7 +447,7 @@ static int fuse_readpages(struct file *f
 	err = read_cache_pages(mapping, pages, fuse_readpages_fill, &data);
 	if (!err) {
 		if (data.req->num_pages)
-			fuse_send_readpages(data.req, data.ff, inode);
+			fuse_send_readpages(data.req, file, inode);
 		else
 			fuse_put_request(fc, data.req);
 	}
@@ -472,11 +474,12 @@ static ssize_t fuse_file_aio_read(struct
 	return generic_file_aio_read(iocb, iov, nr_segs, pos);
 }
 
-static void fuse_write_fill(struct fuse_req *req, struct fuse_file *ff,
+static void fuse_write_fill(struct fuse_req *req, struct file *file,
 			    struct inode *inode, loff_t pos, size_t count,
 			    int writepage)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_file *ff = file->private_data;
 	struct fuse_write_in *inarg = &req->misc.write.in;
 	struct fuse_write_out *outarg = &req->misc.write.out;
 
@@ -485,6 +488,7 @@ static void fuse_write_fill(struct fuse_
 	inarg->offset = pos;
 	inarg->size = count;
 	inarg->write_flags = writepage ? FUSE_WRITE_CACHE : 0;
+	inarg->flags = file->f_flags;
 	req->in.h.opcode = FUSE_WRITE;
 	req->in.h.nodeid = get_node_id(inode);
 	req->in.argpages = 1;
@@ -505,7 +509,7 @@ static size_t fuse_send_write(struct fus
 			      fl_owner_t owner)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	fuse_write_fill(req, file->private_data, inode, pos, count, 0);
+	fuse_write_fill(req, file, inode, pos, count, 0);
 	if (owner != NULL) {
 		struct fuse_write_in *inarg = &req->misc.write.in;
 		inarg->write_flags |= FUSE_WRITE_LOCKOWNER;
diff -puN fs/fuse/fuse_i.h~fuse-pass-open-flags-to-read-and-write fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-pass-open-flags-to-read-and-write
+++ a/fs/fuse/fuse_i.h
@@ -447,7 +447,7 @@ void fuse_send_forget(struct fuse_conn *
 /**
  * Initialize READ or READDIR request
  */
-void fuse_read_fill(struct fuse_req *req, struct fuse_file *ff,
+void fuse_read_fill(struct fuse_req *req, struct file *file,
 		    struct inode *inode, loff_t pos, size_t count, int opcode);
 
 /**
diff -puN include/linux/fuse.h~fuse-pass-open-flags-to-read-and-write include/linux/fuse.h
--- a/include/linux/fuse.h~fuse-pass-open-flags-to-read-and-write
+++ a/include/linux/fuse.h
@@ -16,6 +16,7 @@
  *  - add lk_flags in fuse_lk_in
  *  - add lock_owner field to fuse_setattr_in, fuse_read_in and fuse_write_in
  *  - add blksize field to fuse_attr
+ *  - add file flags field to fuse_read_in and fuse_write_in
  */
 
 #include <asm/types.h>
@@ -280,6 +281,8 @@ struct fuse_read_in {
 	__u32	size;
 	__u32	read_flags;
 	__u64	lock_owner;
+	__u32	flags;
+	__u32	padding;
 };
 
 #define FUSE_COMPAT_WRITE_IN_SIZE 24
@@ -290,6 +293,8 @@ struct fuse_write_in {
 	__u32	size;
 	__u32	write_flags;
 	__u64	lock_owner;
+	__u32	flags;
+	__u32	padding;
 };
 
 struct fuse_write_out {
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
