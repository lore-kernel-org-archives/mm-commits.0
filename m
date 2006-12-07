From: akpm@osdl.org
Subject: - fuse-add-bmap-support.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:01:45 -0800
Message-ID: <200612072301.kB7N1jhS029798@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51649 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163775AbWLGXCO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:02:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miklos@szeredi.hu, mm-commits@vger.kernel.org


The patch titled
     fuse: add bmap support
has been removed from the -mm tree.  Its filename was
     fuse-add-bmap-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: add bmap support
From: Miklos Szeredi <miklos@szeredi.hu>

Add support for the BMAP operation for block device based filesystems.  This
is needed to support swap-files and lilo.

Signed-off-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/fuse/dir.c        |    2 ++
 fs/fuse/file.c       |   37 +++++++++++++++++++++++++++++++++++++
 fs/fuse/fuse_i.h     |    3 +++
 include/linux/fuse.h |   11 +++++++++++
 4 files changed, 53 insertions(+)

diff -puN fs/fuse/dir.c~fuse-add-bmap-support fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-add-bmap-support
+++ a/fs/fuse/dir.c
@@ -1024,6 +1024,8 @@ static int fuse_setattr(struct dentry *e
 	if (attr->ia_valid & ATTR_SIZE) {
 		unsigned long limit;
 		is_truncate = 1;
+		if (IS_SWAPFILE(inode))
+			return -ETXTBSY;
 		limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
 		if (limit != RLIM_INFINITY && attr->ia_size > (loff_t) limit) {
 			send_sig(SIGXFSZ, current, 0);
diff -puN fs/fuse/file.c~fuse-add-bmap-support fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-add-bmap-support
+++ a/fs/fuse/file.c
@@ -754,6 +754,42 @@ static int fuse_file_lock(struct file *f
 	return err;
 }
 
+static sector_t fuse_bmap(struct address_space *mapping, sector_t block)
+{
+	struct inode *inode = mapping->host;
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_req *req;
+	struct fuse_bmap_in inarg;
+	struct fuse_bmap_out outarg;
+	int err;
+
+	if (!inode->i_sb->s_bdev || fc->no_bmap)
+		return 0;
+
+	req = fuse_get_req(fc);
+	if (IS_ERR(req))
+		return 0;
+
+	memset(&inarg, 0, sizeof(inarg));
+	inarg.block = block;
+	inarg.blocksize = inode->i_sb->s_blocksize;
+	req->in.h.opcode = FUSE_BMAP;
+	req->in.h.nodeid = get_node_id(inode);
+	req->in.numargs = 1;
+	req->in.args[0].size = sizeof(inarg);
+	req->in.args[0].value = &inarg;
+	req->out.numargs = 1;
+	req->out.args[0].size = sizeof(outarg);
+	req->out.args[0].value = &outarg;
+	request_send(fc, req);
+	err = req->out.h.error;
+	fuse_put_request(fc, req);
+	if (err == -ENOSYS)
+		fc->no_bmap = 1;
+
+	return err ? 0 : outarg.block;
+}
+
 static const struct file_operations fuse_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
@@ -787,6 +823,7 @@ static const struct address_space_operat
 	.commit_write	= fuse_commit_write,
 	.readpages	= fuse_readpages,
 	.set_page_dirty	= fuse_set_page_dirty,
+	.bmap		= fuse_bmap,
 };
 
 void fuse_init_file_inode(struct inode *inode)
diff -puN fs/fuse/fuse_i.h~fuse-add-bmap-support fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-add-bmap-support
+++ a/fs/fuse/fuse_i.h
@@ -339,6 +339,9 @@ struct fuse_conn {
 	/** Is interrupt not implemented by fs? */
 	unsigned no_interrupt : 1;
 
+	/** Is bmap not implemented by fs? */
+	unsigned no_bmap : 1;
+
 	/** The number of requests waiting for completion */
 	atomic_t num_waiting;
 
diff -puN include/linux/fuse.h~fuse-add-bmap-support include/linux/fuse.h
--- a/include/linux/fuse.h~fuse-add-bmap-support
+++ a/include/linux/fuse.h
@@ -132,6 +132,7 @@ enum fuse_opcode {
 	FUSE_ACCESS        = 34,
 	FUSE_CREATE        = 35,
 	FUSE_INTERRUPT     = 36,
+	FUSE_BMAP          = 37,
 };
 
 /* The read buffer is required to be at least 8k, but may be much larger */
@@ -302,6 +303,16 @@ struct fuse_interrupt_in {
 	__u64	unique;
 };
 
+struct fuse_bmap_in {
+	__u64	block;
+	__u32	blocksize;
+	__u32	padding;
+};
+
+struct fuse_bmap_out {
+	__u64	block;
+};
+
 struct fuse_in_header {
 	__u32	len;
 	__u32	opcode;
_

Patches currently in -mm which might be from miklos@szeredi.hu are

origin.patch

