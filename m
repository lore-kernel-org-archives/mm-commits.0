From: akpm@linux-foundation.org
Subject: + fuse-add-reference-counting-to-fuse_file.patch added to -mm tree
Date: Fri, 03 Aug 2007 15:54:56 -0700
Message-ID: <200708032254.l73MsuHI031755@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52471 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763192AbXHCWzG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Aug 2007 18:55:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: add reference counting to fuse_file
has been added to the -mm tree.  Its filename is
     fuse-add-reference-counting-to-fuse_file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fuse: add reference counting to fuse_file
From: Miklos Szeredi <mszeredi@suse.cz>

Make lifetime of 'struct fuse_file' independent from 'struct file' by adding a
reference counter and destructor.

This will enable asynchronous page writeback, where it cannot be guaranteed,
that the file is not released while a request with this file handle is being
served.

The actual RELEASE request is only sent when there are no more references to
the fuse_file.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dev.c    |    2 -
 fs/fuse/dir.c    |   14 ++++----
 fs/fuse/file.c   |   72 +++++++++++++++++++++++++++------------------
 fs/fuse/fuse_i.h |   13 +++++---
 4 files changed, 59 insertions(+), 42 deletions(-)

diff -puN fs/fuse/dev.c~fuse-add-reference-counting-to-fuse_file fs/fuse/dev.c
--- a/fs/fuse/dev.c~fuse-add-reference-counting-to-fuse_file
+++ a/fs/fuse/dev.c
@@ -233,8 +233,6 @@ static void request_end(struct fuse_conn
 	spin_unlock(&fc->lock);
 	dput(req->dentry);
 	mntput(req->vfsmount);
-	if (req->file)
-		fput(req->file);
 	wake_up(&req->waitq);
 	if (end)
 		end(fc, req);
diff -puN fs/fuse/dir.c~fuse-add-reference-counting-to-fuse_file fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-add-reference-counting-to-fuse_file
+++ a/fs/fuse/dir.c
@@ -288,12 +288,11 @@ static struct dentry *fuse_lookup(struct
 static void fuse_sync_release(struct fuse_conn *fc, struct fuse_file *ff,
 			      u64 nodeid, int flags)
 {
-	struct fuse_req *req;
-
-	req = fuse_release_fill(ff, nodeid, flags, FUSE_RELEASE);
-	req->force = 1;
-	request_send(fc, req);
-	fuse_put_request(fc, req);
+	fuse_release_fill(ff, nodeid, flags, FUSE_RELEASE);
+	ff->reserved_req->force = 1;
+	request_send(fc, ff->reserved_req);
+	fuse_put_request(fc, ff->reserved_req);
+	kfree(ff);
 }
 
 /*
@@ -859,6 +858,7 @@ static int fuse_readdir(struct file *fil
 	struct page *page;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_file *ff = file->private_data;
 	struct fuse_req *req;
 
 	if (is_bad_inode(inode))
@@ -875,7 +875,7 @@ static int fuse_readdir(struct file *fil
 	}
 	req->num_pages = 1;
 	req->pages[0] = page;
-	fuse_read_fill(req, file, inode, file->f_pos, PAGE_SIZE, FUSE_READDIR);
+	fuse_read_fill(req, ff, inode, file->f_pos, PAGE_SIZE, FUSE_READDIR);
 	request_send(fc, req);
 	nbytes = req->out.args[0].size;
 	err = req->out.h.error;
diff -puN fs/fuse/file.c~fuse-add-reference-counting-to-fuse_file fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-add-reference-counting-to-fuse_file
+++ a/fs/fuse/file.c
@@ -54,6 +54,7 @@ struct fuse_file *fuse_file_alloc(void)
 			kfree(ff);
 			ff = NULL;
 		}
+		atomic_set(&ff->count, 0);
 	}
 	return ff;
 }
@@ -64,6 +65,22 @@ void fuse_file_free(struct fuse_file *ff
 	kfree(ff);
 }
 
+static struct fuse_file *fuse_file_get(struct fuse_file *ff)
+{
+	atomic_inc(&ff->count);
+	return ff;
+}
+
+static void fuse_file_put(struct fuse_file *ff)
+{
+	if (atomic_dec_and_test(&ff->count)) {
+		struct fuse_req *req = ff->reserved_req;
+		struct fuse_conn *fc = get_fuse_conn(req->dentry->d_inode);
+		request_send_background(fc, req);
+		kfree(ff);
+	}
+}
+
 void fuse_finish_open(struct inode *inode, struct file *file,
 		      struct fuse_file *ff, struct fuse_open_out *outarg)
 {
@@ -72,7 +89,7 @@ void fuse_finish_open(struct inode *inod
 	if (!(outarg->open_flags & FOPEN_KEEP_CACHE))
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 	ff->fh = outarg->fh;
-	file->private_data = ff;
+	file->private_data = fuse_file_get(ff);
 }
 
 int fuse_open_common(struct inode *inode, struct file *file, int isdir)
@@ -113,8 +130,7 @@ int fuse_open_common(struct inode *inode
 	return err;
 }
 
-struct fuse_req *fuse_release_fill(struct fuse_file *ff, u64 nodeid, int flags,
-				   int opcode)
+void fuse_release_fill(struct fuse_file *ff, u64 nodeid, int flags, int opcode)
 {
 	struct fuse_req *req = ff->reserved_req;
 	struct fuse_release_in *inarg = &req->misc.release_in;
@@ -126,25 +142,24 @@ struct fuse_req *fuse_release_fill(struc
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(struct fuse_release_in);
 	req->in.args[0].value = inarg;
-	kfree(ff);
-
-	return req;
 }
 
 int fuse_release_common(struct inode *inode, struct file *file, int isdir)
 {
 	struct fuse_file *ff = file->private_data;
 	if (ff) {
-		struct fuse_conn *fc = get_fuse_conn(inode);
-		struct fuse_req *req;
-
-		req = fuse_release_fill(ff, get_node_id(inode), file->f_flags,
-					isdir ? FUSE_RELEASEDIR : FUSE_RELEASE);
+		fuse_release_fill(ff, get_node_id(inode), file->f_flags,
+				  isdir ? FUSE_RELEASEDIR : FUSE_RELEASE);
 
 		/* Hold vfsmount and dentry until release is finished */
-		req->vfsmount = mntget(file->f_path.mnt);
-		req->dentry = dget(file->f_path.dentry);
-		request_send_background(fc, req);
+		ff->reserved_req->vfsmount = mntget(file->f_path.mnt);
+		ff->reserved_req->dentry = dget(file->f_path.dentry);
+		/*
+		 * Normally this will send the RELEASE request,
+		 * however if some asynchronous READ or WRITE requests
+		 * are outstanding, the sending will be delayed
+		 */
+		fuse_file_put(ff);
 	}
 
 	/* Return value is ignored by VFS */
@@ -264,10 +279,9 @@ static int fuse_fsync(struct file *file,
 	return fuse_fsync_common(file, de, datasync, 0);
 }
 
-void fuse_read_fill(struct fuse_req *req, struct file *file,
+void fuse_read_fill(struct fuse_req *req, struct fuse_file *ff,
 		    struct inode *inode, loff_t pos, size_t count, int opcode)
 {
-	struct fuse_file *ff = file->private_data;
 	struct fuse_read_in *inarg = &req->misc.read_in;
 
 	inarg->fh = ff->fh;
@@ -288,7 +302,8 @@ static size_t fuse_send_read(struct fuse
 			     struct inode *inode, loff_t pos, size_t count)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	fuse_read_fill(req, file, inode, pos, count, FUSE_READ);
+	struct fuse_file *ff = file->private_data;
+	fuse_read_fill(req, ff, inode, pos, count, FUSE_READ);
 	request_send(fc, req);
 	return req->out.args[0].size;
 }
@@ -337,20 +352,21 @@ static void fuse_readpages_end(struct fu
 			SetPageError(page);
 		unlock_page(page);
 	}
+	if (req->ff)
+		fuse_file_put(req->ff);
 	fuse_put_request(fc, req);
 }
 
-static void fuse_send_readpages(struct fuse_req *req, struct file *file,
+static void fuse_send_readpages(struct fuse_req *req, struct fuse_file *ff,
 				struct inode *inode)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	loff_t pos = page_offset(req->pages[0]);
 	size_t count = req->num_pages << PAGE_CACHE_SHIFT;
 	req->out.page_zeroing = 1;
-	fuse_read_fill(req, file, inode, pos, count, FUSE_READ);
+	fuse_read_fill(req, ff, inode, pos, count, FUSE_READ);
 	if (fc->async_read) {
-		get_file(file);
-		req->file = file;
+		req->ff = fuse_file_get(ff);
 		req->end = fuse_readpages_end;
 		request_send_background(fc, req);
 	} else {
@@ -359,15 +375,15 @@ static void fuse_send_readpages(struct f
 	}
 }
 
-struct fuse_readpages_data {
+struct fuse_fill_data {
 	struct fuse_req *req;
-	struct file *file;
+	struct fuse_file *ff;
 	struct inode *inode;
 };
 
 static int fuse_readpages_fill(void *_data, struct page *page)
 {
-	struct fuse_readpages_data *data = _data;
+	struct fuse_fill_data *data = _data;
 	struct fuse_req *req = data->req;
 	struct inode *inode = data->inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -376,7 +392,7 @@ static int fuse_readpages_fill(void *_da
 	    (req->num_pages == FUSE_MAX_PAGES_PER_REQ ||
 	     (req->num_pages + 1) * PAGE_CACHE_SIZE > fc->max_read ||
 	     req->pages[req->num_pages - 1]->index + 1 != page->index)) {
-		fuse_send_readpages(req, data->file, inode);
+		fuse_send_readpages(req, data->ff, inode);
 		data->req = req = fuse_get_req(fc);
 		if (IS_ERR(req)) {
 			unlock_page(page);
@@ -393,14 +409,14 @@ static int fuse_readpages(struct file *f
 {
 	struct inode *inode = mapping->host;
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_readpages_data data;
+	struct fuse_fill_data data;
 	int err;
 
 	err = -EIO;
 	if (is_bad_inode(inode))
 		goto out;
 
-	data.file = file;
+	data.ff = file->private_data;
 	data.inode = inode;
 	data.req = fuse_get_req(fc);
 	err = PTR_ERR(data.req);
@@ -410,7 +426,7 @@ static int fuse_readpages(struct file *f
 	err = read_cache_pages(mapping, pages, fuse_readpages_fill, &data);
 	if (!err) {
 		if (data.req->num_pages)
-			fuse_send_readpages(data.req, file, inode);
+			fuse_send_readpages(data.req, data.ff, inode);
 		else
 			fuse_put_request(fc, data.req);
 	}
diff -puN fs/fuse/fuse_i.h~fuse-add-reference-counting-to-fuse_file fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-add-reference-counting-to-fuse_file
+++ a/fs/fuse/fuse_i.h
@@ -72,6 +72,9 @@ struct fuse_file {
 
 	/** File handle used by userspace */
 	u64 fh;
+
+	/** Refcount */
+	atomic_t count;
 };
 
 /** One input argument of a request */
@@ -216,7 +219,7 @@ struct fuse_req {
 	unsigned page_offset;
 
 	/** File used in the request (or NULL) */
-	struct file *file;
+	struct fuse_file *ff;
 
 	/** vfsmount used in release */
 	struct vfsmount *vfsmount;
@@ -420,7 +423,7 @@ void fuse_send_forget(struct fuse_conn *
 /**
  * Initialize READ or READDIR request
  */
-void fuse_read_fill(struct fuse_req *req, struct file *file,
+void fuse_read_fill(struct fuse_req *req, struct fuse_file *ff,
 		    struct inode *inode, loff_t pos, size_t count, int opcode);
 
 /**
@@ -433,9 +436,9 @@ void fuse_file_free(struct fuse_file *ff
 void fuse_finish_open(struct inode *inode, struct file *file,
 		      struct fuse_file *ff, struct fuse_open_out *outarg);
 
-/** */
-struct fuse_req *fuse_release_fill(struct fuse_file *ff, u64 nodeid, int flags,
-				   int opcode);
+/** Fill in ff->reserved_req with a RELEASE request */
+void fuse_release_fill(struct fuse_file *ff, u64 nodeid, int flags, int opcode);
+
 /**
  * Send RELEASE or RELEASEDIR request
  */
_

Patches currently in -mm which might be from mszeredi@suse.cz are

fuse-convert-to-new-aops.patch
ext2-show-all-mount-options.patch
ext3-show-all-mount-options.patch
ext4-show-all-mount-options.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-propagation-inherit-owner-from-parent-fix-for-git-audit.patch
unprivileged-mounts-add-no-submounts-flag.patch
fuse-update-backing_dev_info-congestion-state.patch
fuse-fix-reserved-request-wake-up.patch
fuse-add-reference-counting-to-fuse_file.patch
fuse-truncate-on-spontaneous-size-change.patch
fuse-fix-page-invalidation.patch
fuse-set-i_nlink-to-sane-value-after-mount.patch
fuse-refresh-stale-attributes-in-fuse_permission.patch
fuse-fix-permission-checking-on-sticky-directories.patch
fuse-cleanup-in-release.patch
fuse-no-abort-on-interrupt.patch
fuse-no-enoent-from-fuse-device-read.patch
