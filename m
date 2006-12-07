From: akpm@osdl.org
Subject: - fuse-add-destroy-operation.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:01:47 -0800
Message-ID: <200612072301.kB7N1lgN029802@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51653 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163778AbWLGXCQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:02:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miklos@szeredi.hu, mm-commits@vger.kernel.org


The patch titled
     fuse: add DESTROY operation
has been removed from the -mm tree.  Its filename was
     fuse-add-destroy-operation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: add DESTROY operation
From: Miklos Szeredi <miklos@szeredi.hu>

Add a DESTROY operation for block device based filesystems.  With the help of
this operation, such a filesystem can flush dirty data to the device
synchronously before the umount returns.

This is needed in situations where the filesystem is assumed to be clean
immediately after unmount (e.g.  ejecting removable media).

Signed-off-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/fuse/fuse_i.h     |    6 ++++++
 fs/fuse/inode.c      |   22 ++++++++++++++++++++++
 include/linux/fuse.h |    1 +
 3 files changed, 29 insertions(+)

diff -puN fs/fuse/fuse_i.h~fuse-add-destroy-operation fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-add-destroy-operation
+++ a/fs/fuse/fuse_i.h
@@ -298,6 +298,9 @@ struct fuse_conn {
 	    reply, before any other request, and never cleared */
 	unsigned conn_error : 1;
 
+	/** Connection successful.  Only set in INIT */
+	unsigned conn_init : 1;
+
 	/** Do readpages asynchronously?  Only set in INIT */
 	unsigned async_read : 1;
 
@@ -368,6 +371,9 @@ struct fuse_conn {
 
 	/** Key for lock owner ID scrambling */
 	u32 scramble_key[4];
+
+	/** Reserved request for the DESTROY message */
+	struct fuse_req *destroy_req;
 };
 
 static inline struct fuse_conn *get_fuse_conn_super(struct super_block *sb)
diff -puN fs/fuse/inode.c~fuse-add-destroy-operation fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-add-destroy-operation
+++ a/fs/fuse/inode.c
@@ -206,10 +206,23 @@ static void fuse_umount_begin(struct vfs
 		fuse_abort_conn(get_fuse_conn_super(vfsmnt->mnt_sb));
 }
 
+static void fuse_send_destroy(struct fuse_conn *fc)
+{
+	struct fuse_req *req = fc->destroy_req;
+	if (req && fc->conn_init) {
+		fc->destroy_req = NULL;
+		req->in.h.opcode = FUSE_DESTROY;
+		req->force = 1;
+		request_send(fc, req);
+		fuse_put_request(fc, req);
+	}
+}
+
 static void fuse_put_super(struct super_block *sb)
 {
 	struct fuse_conn *fc = get_fuse_conn_super(sb);
 
+	fuse_send_destroy(fc);
 	spin_lock(&fc->lock);
 	fc->connected = 0;
 	fc->blocked = 0;
@@ -410,6 +423,8 @@ static struct fuse_conn *new_conn(void)
 void fuse_conn_put(struct fuse_conn *fc)
 {
 	if (atomic_dec_and_test(&fc->count)) {
+		if (fc->destroy_req)
+			fuse_request_free(fc->destroy_req);
 		mutex_destroy(&fc->inst_mutex);
 		kfree(fc);
 	}
@@ -466,6 +481,7 @@ static void process_init_reply(struct fu
 		fc->bdi.ra_pages = min(fc->bdi.ra_pages, ra_pages);
 		fc->minor = arg->minor;
 		fc->max_write = arg->minor < 5 ? 4096 : arg->max_write;
+		fc->conn_init = 1;
 	}
 	fuse_put_request(fc, req);
 	fc->blocked = 0;
@@ -563,6 +579,12 @@ static int fuse_fill_super(struct super_
 	if (!init_req)
 		goto err_put_root;
 
+	if (is_bdev) {
+		fc->destroy_req = fuse_request_alloc();
+		if (!fc->destroy_req)
+			goto err_put_root;
+	}
+
 	mutex_lock(&fuse_mutex);
 	err = -EINVAL;
 	if (file->private_data)
diff -puN include/linux/fuse.h~fuse-add-destroy-operation include/linux/fuse.h
--- a/include/linux/fuse.h~fuse-add-destroy-operation
+++ a/include/linux/fuse.h
@@ -133,6 +133,7 @@ enum fuse_opcode {
 	FUSE_CREATE        = 35,
 	FUSE_INTERRUPT     = 36,
 	FUSE_BMAP          = 37,
+	FUSE_DESTROY       = 38,
 };
 
 /* The read buffer is required to be at least 8k, but may be much larger */
_

Patches currently in -mm which might be from miklos@szeredi.hu are

origin.patch

