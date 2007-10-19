From: akpm@linux-foundation.org
Subject: - fuse-add-helper-for-asynchronous-writes.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:46:01 -0700
Message-ID: <200710190346.l9J3k1qw013269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36606 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763307AbXJSDzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: add helper for asynchronous writes
has been removed from the -mm tree.  Its filename was
     fuse-add-helper-for-asynchronous-writes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: add helper for asynchronous writes
From: Miklos Szeredi <mszeredi@suse.cz>

This patch adds a new helper function fuse_write_fill() which makes it
possible to send WRITE requests asynchronously.

A new flag for WRITE requests is also added which indicates that this a write
from the page cache, and not a "normal" file write.

This patch is in preparation for writable mmap support.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c       |   37 ++++++++++++++++++++++---------------
 fs/fuse/fuse_i.h     |    4 ++++
 include/linux/fuse.h |    7 +++++++
 3 files changed, 33 insertions(+), 15 deletions(-)

diff -puN fs/fuse/file.c~fuse-add-helper-for-asynchronous-writes fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-add-helper-for-asynchronous-writes
+++ a/fs/fuse/file.c
@@ -443,30 +443,37 @@ out:
 	return err;
 }
 
-static size_t fuse_send_write(struct fuse_req *req, struct file *file,
-			      struct inode *inode, loff_t pos, size_t count)
-{
-	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_file *ff = file->private_data;
-	struct fuse_write_in inarg;
-	struct fuse_write_out outarg;
-
-	memset(&inarg, 0, sizeof(struct fuse_write_in));
-	inarg.fh = ff->fh;
-	inarg.offset = pos;
-	inarg.size = count;
+static void fuse_write_fill(struct fuse_req *req, struct fuse_file *ff,
+			    struct inode *inode, loff_t pos, size_t count,
+			    int writepage)
+{
+	struct fuse_write_in *inarg = &req->misc.write.in;
+	struct fuse_write_out *outarg = &req->misc.write.out;
+
+	memset(inarg, 0, sizeof(struct fuse_write_in));
+	inarg->fh = ff->fh;
+	inarg->offset = pos;
+	inarg->size = count;
+	inarg->write_flags = writepage ? FUSE_WRITE_CACHE : 0;
 	req->in.h.opcode = FUSE_WRITE;
 	req->in.h.nodeid = get_node_id(inode);
 	req->in.argpages = 1;
 	req->in.numargs = 2;
 	req->in.args[0].size = sizeof(struct fuse_write_in);
-	req->in.args[0].value = &inarg;
+	req->in.args[0].value = inarg;
 	req->in.args[1].size = count;
 	req->out.numargs = 1;
 	req->out.args[0].size = sizeof(struct fuse_write_out);
-	req->out.args[0].value = &outarg;
+	req->out.args[0].value = outarg;
+}
+
+static size_t fuse_send_write(struct fuse_req *req, struct file *file,
+			      struct inode *inode, loff_t pos, size_t count)
+{
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	fuse_write_fill(req, file->private_data, inode, pos, count, 0);
 	request_send(fc, req);
-	return outarg.size;
+	return req->misc.write.out.size;
 }
 
 static int fuse_write_begin(struct file *file, struct address_space *mapping,
diff -puN fs/fuse/fuse_i.h~fuse-add-helper-for-asynchronous-writes fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-add-helper-for-asynchronous-writes
+++ a/fs/fuse/fuse_i.h
@@ -219,6 +219,10 @@ struct fuse_req {
 		struct fuse_init_in init_in;
 		struct fuse_init_out init_out;
 		struct fuse_read_in read_in;
+		struct {
+			struct fuse_write_in in;
+			struct fuse_write_out out;
+		} write;
 		struct fuse_lk_in lk_in;
 	} misc;
 
diff -puN include/linux/fuse.h~fuse-add-helper-for-asynchronous-writes include/linux/fuse.h
--- a/include/linux/fuse.h~fuse-add-helper-for-asynchronous-writes
+++ a/include/linux/fuse.h
@@ -119,6 +119,13 @@ struct fuse_file_lock {
  */
 #define FUSE_LK_FLOCK		(1 << 0)
 
+/**
+ * WRITE flags
+ *
+ * FUSE_WRITE_CACHE: delayed write from page cache, file handle is guessed
+ */
+#define FUSE_WRITE_CACHE	(1 << 0)
+
 enum fuse_opcode {
 	FUSE_LOOKUP	   = 1,
 	FUSE_FORGET	   = 2,  /* no reply */
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-mounts-fix-subtype-handling.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-propagation-inherit-owner-from-parent-fix-for-git-audit.patch
unprivileged-mounts-add-no-submounts-flag.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
