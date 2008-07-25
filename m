From: akpm@linux-foundation.org
Subject: - fuse-add-fuse_lookup_name-helper.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:03:40 -0700
Message-ID: <200807252303.m6PN3evf003971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754309AbYGYXGp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     fuse: add fuse_lookup_name() helper
has been removed from the -mm tree.  Its filename was
     fuse-add-fuse_lookup_name-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fuse: add fuse_lookup_name() helper
From: Miklos Szeredi <mszeredi@suse.cz>

Add a new helper function which sends a LOOKUP request with the supplied
name.  This will be used by the next patch to send special LOOKUP requests
with "." and ".." as the name.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c |  117 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 77 insertions(+), 40 deletions(-)

diff -puN fs/fuse/dir.c~fuse-add-fuse_lookup_name-helper fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-add-fuse_lookup_name-helper
+++ a/fs/fuse/dir.c
@@ -112,18 +112,16 @@ static void fuse_invalidate_entry(struct
 	fuse_invalidate_entry_cache(entry);
 }
 
-static void fuse_lookup_init(struct fuse_req *req, struct inode *dir,
-			     struct dentry *entry,
+static void fuse_lookup_init(struct fuse_conn *fc, struct fuse_req *req,
+			     u64 nodeid, struct qstr *name,
 			     struct fuse_entry_out *outarg)
 {
-	struct fuse_conn *fc = get_fuse_conn(dir);
-
 	memset(outarg, 0, sizeof(struct fuse_entry_out));
 	req->in.h.opcode = FUSE_LOOKUP;
-	req->in.h.nodeid = get_node_id(dir);
+	req->in.h.nodeid = nodeid;
 	req->in.numargs = 1;
-	req->in.args[0].size = entry->d_name.len + 1;
-	req->in.args[0].value = entry->d_name.name;
+	req->in.args[0].size = name->len + 1;
+	req->in.args[0].value = name->name;
 	req->out.numargs = 1;
 	if (fc->minor < 9)
 		req->out.args[0].size = FUSE_COMPAT_ENTRY_OUT_SIZE;
@@ -189,7 +187,8 @@ static int fuse_dentry_revalidate(struct
 		attr_version = fuse_get_attr_version(fc);
 
 		parent = dget_parent(entry);
-		fuse_lookup_init(req, parent->d_inode, entry, &outarg);
+		fuse_lookup_init(fc, req, get_node_id(parent->d_inode),
+				 &entry->d_name, &outarg);
 		request_send(fc, req);
 		dput(parent);
 		err = req->out.h.error;
@@ -255,73 +254,111 @@ static struct dentry *fuse_d_add_directo
 	return d_splice_alias(inode, entry);
 }
 
-static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry,
-				  struct nameidata *nd)
+int fuse_lookup_name(struct super_block *sb, u64 nodeid, struct qstr *name,
+		     struct fuse_entry_out *outarg, struct inode **inode)
 {
-	int err;
-	struct fuse_entry_out outarg;
-	struct inode *inode = NULL;
-	struct dentry *newent;
-	struct fuse_conn *fc = get_fuse_conn(dir);
+	struct fuse_conn *fc = get_fuse_conn_super(sb);
 	struct fuse_req *req;
 	struct fuse_req *forget_req;
 	u64 attr_version;
+	int err;
 
-	if (entry->d_name.len > FUSE_NAME_MAX)
-		return ERR_PTR(-ENAMETOOLONG);
+	*inode = NULL;
+	err = -ENAMETOOLONG;
+	if (name->len > FUSE_NAME_MAX)
+		goto out;
 
 	req = fuse_get_req(fc);
+	err = PTR_ERR(req);
 	if (IS_ERR(req))
-		return ERR_CAST(req);
+		goto out;
 
 	forget_req = fuse_get_req(fc);
+	err = PTR_ERR(forget_req);
 	if (IS_ERR(forget_req)) {
 		fuse_put_request(fc, req);
-		return ERR_CAST(forget_req);
+		goto out;
 	}
 
 	attr_version = fuse_get_attr_version(fc);
 
-	fuse_lookup_init(req, dir, entry, &outarg);
+	fuse_lookup_init(fc, req, nodeid, name, outarg);
 	request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	/* Zero nodeid is same as -ENOENT, but with valid timeout */
-	if (!err && outarg.nodeid &&
-	    (invalid_nodeid(outarg.nodeid) ||
-	     !fuse_valid_type(outarg.attr.mode)))
-		err = -EIO;
-	if (!err && outarg.nodeid) {
-		inode = fuse_iget(dir->i_sb, outarg.nodeid, outarg.generation,
-				  &outarg.attr, entry_attr_timeout(&outarg),
-				  attr_version);
-		if (!inode) {
-			fuse_send_forget(fc, forget_req, outarg.nodeid, 1);
-			return ERR_PTR(-ENOMEM);
-		}
+	if (err || !outarg->nodeid)
+		goto out_put_forget;
+
+	err = -EIO;
+	if (!outarg->nodeid)
+		goto out_put_forget;
+	if (!fuse_valid_type(outarg->attr.mode))
+		goto out_put_forget;
+
+	*inode = fuse_iget(sb, outarg->nodeid, outarg->generation,
+			   &outarg->attr, entry_attr_timeout(outarg),
+			   attr_version);
+	err = -ENOMEM;
+	if (!*inode) {
+		fuse_send_forget(fc, forget_req, outarg->nodeid, 1);
+		goto out;
 	}
+	err = 0;
+
+ out_put_forget:
 	fuse_put_request(fc, forget_req);
-	if (err && err != -ENOENT)
-		return ERR_PTR(err);
+ out:
+	return err;
+}
+
+static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry,
+				  struct nameidata *nd)
+{
+	int err;
+	struct fuse_entry_out outarg;
+	struct inode *inode;
+	struct dentry *newent;
+	struct fuse_conn *fc = get_fuse_conn(dir);
+	bool outarg_valid = true;
+
+	err = fuse_lookup_name(dir->i_sb, get_node_id(dir), &entry->d_name,
+			       &outarg, &inode);
+	if (err == -ENOENT) {
+		outarg_valid = false;
+		err = 0;
+	}
+	if (err)
+		goto out_err;
+
+	err = -EIO;
+	if (inode && get_node_id(inode) == FUSE_ROOT_ID)
+		goto out_iput;
 
 	if (inode && S_ISDIR(inode->i_mode)) {
 		mutex_lock(&fc->inst_mutex);
 		newent = fuse_d_add_directory(entry, inode);
 		mutex_unlock(&fc->inst_mutex);
-		if (IS_ERR(newent)) {
-			iput(inode);
-			return newent;
-		}
-	} else
+		err = PTR_ERR(newent);
+		if (IS_ERR(newent))
+			goto out_iput;
+	} else {
 		newent = d_splice_alias(inode, entry);
+	}
 
 	entry = newent ? newent : entry;
 	entry->d_op = &fuse_dentry_operations;
-	if (!err)
+	if (outarg_valid)
 		fuse_change_entry_timeout(entry, &outarg);
 	else
 		fuse_invalidate_entry_cache(entry);
+
 	return newent;
+
+ out_iput:
+	iput(inode);
+ out_err:
+	return ERR_PTR(err);
 }
 
 /*
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
linux-next.patch
git-unprivileged-mounts.patch

