From: akpm@linux-foundation.org
Subject: + fuse-save-space-in-struct-fuse_req.patch added to -mm tree
Date: Tue, 29 Jan 2008 12:31:51 -0800
Message-ID: <200801292031.m0TKVpOx003151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54192 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753790AbYA2UcF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 15:32:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: save space in struct fuse_req
has been added to the -mm tree.  Its filename is
     fuse-save-space-in-struct-fuse_req.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fuse: save space in struct fuse_req
From: Miklos Szeredi <mszeredi@suse.cz>

Move the fields 'dentry' and 'vfsmount' into the request specific union, since
these are only used for the RELEASE request.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c   |   14 ++++++++------
 fs/fuse/fuse_i.h |   12 +++++-------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff -puN fs/fuse/file.c~fuse-save-space-in-struct-fuse_req fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-save-space-in-struct-fuse_req
+++ a/fs/fuse/file.c
@@ -77,8 +77,8 @@ static struct fuse_file *fuse_file_get(s
 
 static void fuse_release_end(struct fuse_conn *fc, struct fuse_req *req)
 {
-	dput(req->dentry);
-	mntput(req->vfsmount);
+	dput(req->misc.release.dentry);
+	mntput(req->misc.release.vfsmount);
 	fuse_put_request(fc, req);
 }
 
@@ -86,7 +86,8 @@ static void fuse_file_put(struct fuse_fi
 {
 	if (atomic_dec_and_test(&ff->count)) {
 		struct fuse_req *req = ff->reserved_req;
-		struct fuse_conn *fc = get_fuse_conn(req->dentry->d_inode);
+		struct inode *inode = req->misc.release.dentry->d_inode;
+		struct fuse_conn *fc = get_fuse_conn(inode);
 		req->end = fuse_release_end;
 		request_send_background(fc, req);
 		kfree(ff);
@@ -137,7 +138,7 @@ int fuse_open_common(struct inode *inode
 void fuse_release_fill(struct fuse_file *ff, u64 nodeid, int flags, int opcode)
 {
 	struct fuse_req *req = ff->reserved_req;
-	struct fuse_release_in *inarg = &req->misc.release_in;
+	struct fuse_release_in *inarg = &req->misc.release.in;
 
 	inarg->fh = ff->fh;
 	inarg->flags = flags;
@@ -153,13 +154,14 @@ int fuse_release_common(struct inode *in
 	struct fuse_file *ff = file->private_data;
 	if (ff) {
 		struct fuse_conn *fc = get_fuse_conn(inode);
+		struct fuse_req *req = ff->reserved_req;
 
 		fuse_release_fill(ff, get_node_id(inode), file->f_flags,
 				  isdir ? FUSE_RELEASEDIR : FUSE_RELEASE);
 
 		/* Hold vfsmount and dentry until release is finished */
-		ff->reserved_req->vfsmount = mntget(file->f_path.mnt);
-		ff->reserved_req->dentry = dget(file->f_path.dentry);
+		req->misc.release.vfsmount = mntget(file->f_path.mnt);
+		req->misc.release.dentry = dget(file->f_path.dentry);
 
 		spin_lock(&fc->lock);
 		list_del(&ff->write_entry);
diff -puN fs/fuse/fuse_i.h~fuse-save-space-in-struct-fuse_req fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-save-space-in-struct-fuse_req
+++ a/fs/fuse/fuse_i.h
@@ -215,7 +215,11 @@ struct fuse_req {
 	/** Data for asynchronous requests */
 	union {
 		struct fuse_forget_in forget_in;
-		struct fuse_release_in release_in;
+		struct {
+			struct fuse_release_in in;
+			struct vfsmount *vfsmount;
+			struct dentry *dentry;
+		} release;
 		struct fuse_init_in init_in;
 		struct fuse_init_out init_out;
 		struct fuse_read_in read_in;
@@ -238,12 +242,6 @@ struct fuse_req {
 	/** File used in the request (or NULL) */
 	struct fuse_file *ff;
 
-	/** vfsmount used in release */
-	struct vfsmount *vfsmount;
-
-	/** dentry used in release */
-	struct dentry *dentry;
-
 	/** Request completion callback */
 	void (*end)(struct fuse_conn *, struct fuse_req *);
 
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
git-x86.patch
fuse-fix-attribute-caching-after-create.patch
fuse-save-space-in-struct-fuse_req.patch
fuse-limit-queued-background-requests.patch
