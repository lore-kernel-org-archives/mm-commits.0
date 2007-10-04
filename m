From: akpm@linux-foundation.org
Subject: + fuse-fix-race-between-getattr-and-write.patch added to -mm tree
Date: Thu, 04 Oct 2007 15:55:20 -0700
Message-ID: <200710042255.l94MtK4M032605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43609 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758001AbXJDWzf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 18:55:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, jakub.bogusz@gemius.pl


The patch titled
     fuse: fix race between getattr and write
has been added to the -mm tree.  Its filename is
     fuse-fix-race-between-getattr-and-write.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fuse: fix race between getattr and write
From: Miklos Szeredi <mszeredi@suse.cz>

Getattr and lookup operations can be running in parallel to attribute changing
operations, such as write and setattr.

This means, that if for example getattr was slower than a write, the cached
size attribute could be set to a stale value.

To prevent this race, introduce a per-filesystem attribute version counter. 
This counter is incremented whenever cached attributes are modified, and the
incremented value stored in the inode.

Before storing new attributes in the cache, getattr and lookup check, using
the version number, whether the attributes have been modified during the
request's lifetime.  If so, the returned attributes are not cached, because
they might be stale.

Thanks to Jakub Bogusz for the bug report and test program.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Jakub Bogusz <jakub.bogusz@gemius.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/fuse/dir.c~fuse-fix-race-between-getattr-and-write fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-fix-race-between-getattr-and-write
+++ a/fs/fuse/dir.c
@@ -63,13 +63,21 @@ static u64 time_to_jiffies(unsigned long
  * Set dentry and possibly attribute timeouts from the lookup/mk*
  * replies
  */
-static void fuse_change_timeout(struct dentry *entry, struct fuse_entry_out *o)
+static void fuse_change_entry_timeout(struct dentry *entry,
+				      struct fuse_entry_out *o)
 {
 	fuse_dentry_settime(entry,
 		time_to_jiffies(o->entry_valid, o->entry_valid_nsec));
-	if (entry->d_inode)
-		get_fuse_inode(entry->d_inode)->i_time =
-			time_to_jiffies(o->attr_valid, o->attr_valid_nsec);
+}
+
+static u64 attr_timeout(struct fuse_attr_out *o)
+{
+	return time_to_jiffies(o->attr_valid, o->attr_valid_nsec);
+}
+
+static u64 entry_attr_timeout(struct fuse_entry_out *o)
+{
+	return time_to_jiffies(o->attr_valid, o->attr_valid_nsec);
 }
 
 /*
@@ -140,6 +148,7 @@ static int fuse_dentry_revalidate(struct
 		struct fuse_req *req;
 		struct fuse_req *forget_req;
 		struct dentry *parent;
+		u64 attr_version;
 
 		/* For negative dentries, always do a fresh lookup */
 		if (!inode)
@@ -156,6 +165,10 @@ static int fuse_dentry_revalidate(struct
 			return 0;
 		}
 
+		spin_lock(&fc->lock);
+		attr_version = fc->attr_version;
+		spin_unlock(&fc->lock);
+
 		parent = dget_parent(entry);
 		fuse_lookup_init(req, parent->d_inode, entry, &outarg);
 		request_send(fc, req);
@@ -180,8 +193,10 @@ static int fuse_dentry_revalidate(struct
 		if (err || (outarg.attr.mode ^ inode->i_mode) & S_IFMT)
 			return 0;
 
-		fuse_change_attributes(inode, &outarg.attr);
-		fuse_change_timeout(entry, &outarg);
+		fuse_change_attributes(inode, &outarg.attr,
+				       entry_attr_timeout(&outarg),
+				       attr_version);
+		fuse_change_entry_timeout(entry, &outarg);
 	}
 	return 1;
 }
@@ -228,6 +243,7 @@ static struct dentry *fuse_lookup(struct
 	struct fuse_conn *fc = get_fuse_conn(dir);
 	struct fuse_req *req;
 	struct fuse_req *forget_req;
+	u64 attr_version;
 
 	if (entry->d_name.len > FUSE_NAME_MAX)
 		return ERR_PTR(-ENAMETOOLONG);
@@ -242,6 +258,10 @@ static struct dentry *fuse_lookup(struct
 		return ERR_PTR(PTR_ERR(forget_req));
 	}
 
+	spin_lock(&fc->lock);
+	attr_version = fc->attr_version;
+	spin_unlock(&fc->lock);
+
 	fuse_lookup_init(req, dir, entry, &outarg);
 	request_send(fc, req);
 	err = req->out.h.error;
@@ -253,7 +273,8 @@ static struct dentry *fuse_lookup(struct
 		err = -EIO;
 	if (!err && outarg.nodeid) {
 		inode = fuse_iget(dir->i_sb, outarg.nodeid, outarg.generation,
-				  &outarg.attr);
+				  &outarg.attr, entry_attr_timeout(&outarg),
+				  attr_version);
 		if (!inode) {
 			fuse_send_forget(fc, forget_req, outarg.nodeid, 1);
 			return ERR_PTR(-ENOMEM);
@@ -276,7 +297,7 @@ static struct dentry *fuse_lookup(struct
 
 	entry->d_op = &fuse_dentry_operations;
 	if (!err)
-		fuse_change_timeout(entry, &outarg);
+		fuse_change_entry_timeout(entry, &outarg);
 	else
 		fuse_invalidate_entry_cache(entry);
 	return NULL;
@@ -363,7 +384,7 @@ static int fuse_create_open(struct inode
 
 	fuse_put_request(fc, req);
 	inode = fuse_iget(dir->i_sb, outentry.nodeid, outentry.generation,
-			  &outentry.attr);
+			  &outentry.attr, entry_attr_timeout(&outentry), 0);
 	if (!inode) {
 		flags &= ~(O_CREAT | O_EXCL | O_TRUNC);
 		ff->fh = outopen.fh;
@@ -373,7 +394,7 @@ static int fuse_create_open(struct inode
 	}
 	fuse_put_request(fc, forget_req);
 	d_instantiate(entry, inode);
-	fuse_change_timeout(entry, &outentry);
+	fuse_change_entry_timeout(entry, &outentry);
 	file = lookup_instantiate_filp(nd, entry, generic_file_open);
 	if (IS_ERR(file)) {
 		ff->fh = outopen.fh;
@@ -428,7 +449,7 @@ static int create_new_entry(struct fuse_
 		goto out_put_forget_req;
 
 	inode = fuse_iget(dir->i_sb, outarg.nodeid, outarg.generation,
-			  &outarg.attr);
+			  &outarg.attr, entry_attr_timeout(&outarg), 0);
 	if (!inode) {
 		fuse_send_forget(fc, forget_req, outarg.nodeid, 1);
 		return -ENOMEM;
@@ -451,7 +472,7 @@ static int create_new_entry(struct fuse_
 	} else
 		d_instantiate(entry, inode);
 
-	fuse_change_timeout(entry, &outarg);
+	fuse_change_entry_timeout(entry, &outarg);
 	fuse_invalidate_attr(dir);
 	return 0;
 
@@ -663,15 +684,43 @@ static int fuse_link(struct dentry *entr
 	return err;
 }
 
-static int fuse_do_getattr(struct inode *inode)
+static void fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
+			  struct kstat *stat)
+{
+	stat->dev = inode->i_sb->s_dev;
+	stat->ino = attr->ino;
+	stat->mode = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
+	stat->nlink = attr->nlink;
+	stat->uid = attr->uid;
+	stat->gid = attr->gid;
+	stat->rdev = inode->i_rdev;
+	stat->atime.tv_sec = attr->atime;
+	stat->atime.tv_nsec = attr->atimensec;
+	stat->mtime.tv_sec = attr->mtime;
+	stat->mtime.tv_nsec = attr->mtimensec;
+	stat->ctime.tv_sec = attr->ctime;
+	stat->ctime.tv_nsec = attr->ctimensec;
+	stat->size = attr->size;
+	stat->blocks = attr->blocks;
+	stat->blksize = (1 << inode->i_blkbits);
+}
+
+static int fuse_do_getattr(struct inode *inode, struct kstat *stat)
 {
 	int err;
 	struct fuse_attr_out arg;
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_req *req = fuse_get_req(fc);
+	struct fuse_req *req;
+	u64 attr_version;
+
+	req = fuse_get_req(fc);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
+	spin_lock(&fc->lock);
+	attr_version = fc->attr_version;
+	spin_unlock(&fc->lock);
+
 	req->in.h.opcode = FUSE_GETATTR;
 	req->in.h.nodeid = get_node_id(inode);
 	req->out.numargs = 1;
@@ -685,30 +734,17 @@ static int fuse_do_getattr(struct inode 
 			make_bad_inode(inode);
 			err = -EIO;
 		} else {
-			struct fuse_inode *fi = get_fuse_inode(inode);
-			fuse_change_attributes(inode, &arg.attr);
-			fi->i_time = time_to_jiffies(arg.attr_valid,
-						     arg.attr_valid_nsec);
+			fuse_change_attributes(inode, &arg.attr,
+					       attr_timeout(&arg),
+					       attr_version);
+			if (stat)
+				fuse_fillattr(inode, &arg.attr, stat);
 		}
 	}
 	return err;
 }
 
 /*
- * Check if attributes are still valid, and if not send a GETATTR
- * request to refresh them.
- */
-static int fuse_refresh_attributes(struct inode *inode)
-{
-	struct fuse_inode *fi = get_fuse_inode(inode);
-
-	if (fi->i_time < get_jiffies_64())
-		return fuse_do_getattr(inode);
-	else
-		return 0;
-}
-
-/*
  * Calling into a user-controlled filesystem gives the filesystem
  * daemon ptrace-like capabilities over the requester process.  This
  * means, that the filesystem daemon is able to record the exact
@@ -795,11 +831,14 @@ static int fuse_permission(struct inode 
 	 */
 	if ((fc->flags & FUSE_DEFAULT_PERMISSIONS) ||
 	    ((mask & MAY_EXEC) && S_ISREG(inode->i_mode))) {
-		err = fuse_refresh_attributes(inode);
-		if (err)
-			return err;
+		struct fuse_inode *fi = get_fuse_inode(inode);
+		if (fi->i_time < get_jiffies_64()) {
+			err = fuse_do_getattr(inode, NULL);
+			if (err)
+				return err;
 
-		refreshed = true;
+			refreshed = true;
+		}
 	}
 
 	if (fc->flags & FUSE_DEFAULT_PERMISSIONS) {
@@ -809,7 +848,7 @@ static int fuse_permission(struct inode 
 		   attributes.  This is also needed, because the root
 		   node will at first have no permissions */
 		if (err == -EACCES && !refreshed) {
-		 	err = fuse_do_getattr(inode);
+		 	err = fuse_do_getattr(inode, NULL);
 			if (!err)
 				err = generic_permission(inode, mask, NULL);
 		}
@@ -825,7 +864,7 @@ static int fuse_permission(struct inode 
 			if (refreshed)
 				return -EACCES;
 
-			err = fuse_do_getattr(inode);
+			err = fuse_do_getattr(inode, NULL);
 			if (!err && !(inode->i_mode & S_IXUGO))
 				return -EACCES;
 		}
@@ -999,7 +1038,6 @@ static int fuse_setattr(struct dentry *e
 {
 	struct inode *inode = entry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct fuse_req *req;
 	struct fuse_setattr_in inarg;
 	struct fuse_attr_out outarg;
@@ -1053,8 +1091,7 @@ static int fuse_setattr(struct dentry *e
 		return -EIO;
 	}
 
-	fuse_change_attributes(inode, &outarg.attr);
-	fi->i_time = time_to_jiffies(outarg.attr_valid, outarg.attr_valid_nsec);
+	fuse_change_attributes(inode, &outarg.attr, attr_timeout(&outarg), 0);
 	return 0;
 }
 
@@ -1069,8 +1106,10 @@ static int fuse_getattr(struct vfsmount 
 	if (!fuse_allow_task(fc, current))
 		return -EACCES;
 
-	err = fuse_refresh_attributes(inode);
-	if (!err) {
+	if (fi->i_time < get_jiffies_64())
+		err = fuse_do_getattr(inode, stat);
+	else {
+		err = 0;
 		generic_fillattr(inode, stat);
 		stat->mode = fi->orig_i_mode;
 	}
diff -puN fs/fuse/file.c~fuse-fix-race-between-getattr-and-write fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-fix-race-between-getattr-and-write
+++ a/fs/fuse/file.c
@@ -478,6 +478,7 @@ static int fuse_buffered_write(struct fi
 	int err;
 	size_t nres;
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
 	unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
 	struct fuse_req *req;
 
@@ -499,6 +500,7 @@ static int fuse_buffered_write(struct fi
 	if (!err) {
 		pos += nres;
 		spin_lock(&fc->lock);
+		fi->attr_version = ++fc->attr_version;
 		if (pos > inode->i_size)
 			i_size_write(inode, pos);
 		spin_unlock(&fc->lock);
diff -puN fs/fuse/fuse_i.h~fuse-fix-race-between-getattr-and-write fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-fix-race-between-getattr-and-write
+++ a/fs/fuse/fuse_i.h
@@ -67,6 +67,9 @@ struct fuse_inode {
 	/** The sticky bit in inode->i_mode may have been removed, so
 	    preserve the original mode */
 	mode_t orig_i_mode;
+
+	/** Version of last attribute change */
+	u64 attr_version;
 };
 
 /** FUSE specific file data */
@@ -387,6 +390,9 @@ struct fuse_conn {
 
 	/** Reserved request for the DESTROY message */
 	struct fuse_req *destroy_req;
+
+	/** Version counter for attribute changes */
+	u64 attr_version;
 };
 
 static inline struct fuse_conn *get_fuse_conn_super(struct super_block *sb)
@@ -416,7 +422,8 @@ extern const struct file_operations fuse
  * Get a filled in inode
  */
 struct inode *fuse_iget(struct super_block *sb, unsigned long nodeid,
-			int generation, struct fuse_attr *attr);
+			int generation, struct fuse_attr *attr,
+			u64 attr_valid, u64 attr_version);
 
 /**
  * Send FORGET command
@@ -477,7 +484,8 @@ void fuse_init_symlink(struct inode *ino
 /**
  * Change attributes of an inode
  */
-void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr);
+void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
+			    u64 attr_valid, u64 attr_version);
 
 /**
  * Initialize the client device
diff -puN fs/fuse/inode.c~fuse-fix-race-between-getattr-and-write fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-fix-race-between-getattr-and-write
+++ a/fs/fuse/inode.c
@@ -117,12 +117,22 @@ static void fuse_truncate(struct address
 	unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
 }
 
-void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr)
+
+void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
+			    u64 attr_valid, u64 attr_version)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_inode *fi = get_fuse_inode(inode);
 	loff_t oldsize;
 
+	spin_lock(&fc->lock);
+	if (attr_version != 0 && fi->attr_version > attr_version) {
+		spin_unlock(&fc->lock);
+		return;
+	}
+	fi->attr_version = ++fc->attr_version;
+	fi->i_time = attr_valid;
+
 	inode->i_ino     = attr->ino;
 	inode->i_mode    = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
 	inode->i_nlink   = attr->nlink;
@@ -145,7 +155,6 @@ void fuse_change_attributes(struct inode
 	if (!(fc->flags & FUSE_DEFAULT_PERMISSIONS))
 		inode->i_mode &= ~S_ISVTX;
 
-	spin_lock(&fc->lock);
 	oldsize = inode->i_size;
 	i_size_write(inode, attr->size);
 	spin_unlock(&fc->lock);
@@ -194,7 +203,8 @@ static int fuse_inode_set(struct inode *
 }
 
 struct inode *fuse_iget(struct super_block *sb, unsigned long nodeid,
-			int generation, struct fuse_attr *attr)
+			int generation, struct fuse_attr *attr,
+			u64 attr_valid, u64 attr_version)
 {
 	struct inode *inode;
 	struct fuse_inode *fi;
@@ -222,7 +232,8 @@ struct inode *fuse_iget(struct super_blo
 	spin_lock(&fc->lock);
 	fi->nlookup ++;
 	spin_unlock(&fc->lock);
-	fuse_change_attributes(inode, attr);
+	fuse_change_attributes(inode, attr, attr_valid, attr_version);
+
 	return inode;
 }
 
@@ -474,6 +485,7 @@ static struct fuse_conn *new_conn(void)
 		}
 		fc->reqctr = 0;
 		fc->blocked = 1;
+		fc->attr_version = 1;
 		get_random_bytes(&fc->scramble_key, sizeof(fc->scramble_key));
 	}
 out:
@@ -505,7 +517,7 @@ static struct inode *get_root_inode(stru
 	attr.mode = mode;
 	attr.ino = FUSE_ROOT_ID;
 	attr.nlink = 1;
-	return fuse_iget(sb, 1, 0, &attr);
+	return fuse_iget(sb, 1, 0, &attr, 0, 0);
 }
 
 static const struct super_operations fuse_super_operations = {
_

Patches currently in -mm which might be from mszeredi@suse.cz are

fuse-convert-to-new-aops.patch
uml-remove-unnecessary-hostfs_getattr.patch
ext2-show-all-mount-options.patch
ext3-show-all-mount-options.patch
ext4-show-all-mount-options.patch
vfs-check-nanoseconds-in-utimensat.patch
fix-execute-checking-in-permission.patch
exec-remove-unnecessary-check-for-mnt_noexec.patch
clean-out-unused-code-in-dentry-pruning.patch
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
fuse-update-backing_dev_info-congestion-state.patch
fuse-fix-reserved-request-wake-up.patch
fuse-add-reference-counting-to-fuse_file.patch
fuse-truncate-on-spontaneous-size-change.patch
fuse-fix-page-invalidation.patch
fuse-set-i_nlink-to-sane-value-after-mount.patch
fuse-refresh-stale-attributes-in-fuse_permission.patch
fuse-fix-permission-checking-on-sticky-directories.patch
fuse-fix-permission-checking-on-sticky-directories-fix.patch
fuse-fix-permission-checking-on-sticky-directories-fix-setting-i_mode-bits.patch
fuse-cleanup-in-release.patch
fuse-no-abort-on-interrupt.patch
fuse-no-enoent-from-fuse-device-read.patch
fuse-clean-up-execute-permission-checking.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
fuse-fix-allowing-operations.patch
fuse-fix-race-between-getattr-and-write.patch
fuse-add-file-handle-to-getattr-operation.patch
fuse-clean-up-open-file-passing-in-setattr.patch
vfs-allow-filesystems-to-implement-atomic-opentruncate.patch
fuse-improve-utimes-support.patch
fuse-add-atomic-opentruncate-support.patch
fuse-support-bsd-locking-semantics.patch
fuse-add-list-of-writable-files-to-fuse_inode.patch
fuse-add-helper-for-asynchronous-writes.patch
fuse-add-support-for-mandatory-locking.patch
fuse-add-blksize-field-to-fuse_attr.patch
