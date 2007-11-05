From: akpm@linux-foundation.org
Subject: + embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch added to -mm tree
Date: Mon, 05 Nov 2007 13:03:25 -0800
Message-ID: <200711052103.lA5L3PNa019609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53183 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753792AbXKEVDi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 16:03:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, agruen@suse.de, hch@lst.de, linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Embed a struct path into struct nameidata instead of nd->{dentry,mnt}
has been added to the -mm tree.  Its filename is
     embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Embed a struct path into struct nameidata instead of nd->{dentry,mnt}
From: Jan Blunck <jblunck@suse.de>

Switch from nd->{dentry,mnt} to nd->path.{dentry,mnt} everywhere.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
CC: <linux-fsdevel@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/unionfs/inode.c |   12 ++++--------
 fs/unionfs/main.c  |    9 ++++-----
 fs/unionfs/super.c |   17 ++++++++---------
 3 files changed, 16 insertions(+), 22 deletions(-)

diff -puN fs/unionfs/inode.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs fs/unionfs/inode.c
--- a/fs/unionfs/inode.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs
+++ a/fs/unionfs/inode.c
@@ -168,10 +168,8 @@ static struct dentry *unionfs_lookup(str
 	unionfs_read_lock(dentry->d_sb);
 
 	/* save the dentry & vfsmnt from namei */
-	if (nd) {
-		path_save.dentry = nd->dentry;
-		path_save.mnt = nd->mnt;
-	}
+	if (nd)
+		path_save = nd->path;
 
 	/*
 	 * unionfs_lookup_backend returns a locked dentry upon success,
@@ -180,10 +178,8 @@ static struct dentry *unionfs_lookup(str
 	ret = unionfs_lookup_backend(dentry, nd, INTERPOSE_LOOKUP);
 
 	/* restore the dentry & vfsmnt in namei */
-	if (nd) {
-		nd->dentry = path_save.dentry;
-		nd->mnt = path_save.mnt;
-	}
+	if (nd)
+		nd->path = path_save;
 	if (!IS_ERR(ret)) {
 		if (ret)
 			dentry = ret;
diff -puN fs/unionfs/main.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs fs/unionfs/main.c
--- a/fs/unionfs/main.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs
+++ a/fs/unionfs/main.c
@@ -227,11 +227,11 @@ void unionfs_reinterpose(struct dentry *
 int check_branch(struct nameidata *nd)
 {
 	/* XXX: remove in ODF code -- stacking unions allowed there */
-	if (!strcmp(nd->dentry->d_sb->s_type->name, UNIONFS_NAME))
+	if (!strcmp(nd->path.dentry->d_sb->s_type->name, UNIONFS_NAME))
 		return -EINVAL;
-	if (!nd->dentry->d_inode)
+	if (!nd->path.dentry->d_inode)
 		return -ENOENT;
-	if (!S_ISDIR(nd->dentry->d_inode->i_mode))
+	if (!S_ISDIR(nd->path.dentry->d_inode->i_mode))
 		return -ENOTDIR;
 	return 0;
 }
@@ -372,8 +372,7 @@ static int parse_dirs_option(struct supe
 			goto out;
 		}
 
-		lower_root_info->lower_paths[bindex].dentry = nd.dentry;
-		lower_root_info->lower_paths[bindex].mnt = nd.mnt;
+		lower_root_info->lower_paths[bindex] = nd.path;
 
 		set_branchperms(sb, bindex, perms);
 		set_branch_count(sb, bindex, 0);
diff -puN fs/unionfs/super.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs fs/unionfs/super.c
--- a/fs/unionfs/super.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs
+++ a/fs/unionfs/super.c
@@ -202,8 +202,8 @@ static noinline int do_remount_mode_opti
 		goto out;
 	}
 	for (idx = 0; idx < cur_branches; idx++)
-		if (nd.mnt == new_lower_paths[idx].mnt &&
-		    nd.dentry == new_lower_paths[idx].dentry)
+		if (nd.path.mnt == new_lower_paths[idx].mnt &&
+		    nd.path.dentry == new_lower_paths[idx].dentry)
 			break;
 	path_release(&nd);	/* no longer needed */
 	if (idx == cur_branches) {
@@ -245,8 +245,8 @@ static noinline int do_remount_del_optio
 		goto out;
 	}
 	for (idx = 0; idx < cur_branches; idx++)
-		if (nd.mnt == new_lower_paths[idx].mnt &&
-		    nd.dentry == new_lower_paths[idx].dentry)
+		if (nd.path.mnt == new_lower_paths[idx].mnt &&
+		    nd.path.dentry == new_lower_paths[idx].dentry)
 			break;
 	path_release(&nd);	/* no longer needed */
 	if (idx == cur_branches) {
@@ -329,8 +329,8 @@ static noinline int do_remount_add_optio
 		goto out;
 	}
 	for (idx = 0; idx < cur_branches; idx++)
-		if (nd.mnt == new_lower_paths[idx].mnt &&
-		    nd.dentry == new_lower_paths[idx].dentry)
+		if (nd.path.mnt == new_lower_paths[idx].mnt &&
+		    nd.path.dentry == new_lower_paths[idx].dentry)
 			break;
 	path_release(&nd);	/* no longer needed */
 	if (idx == cur_branches) {
@@ -392,10 +392,9 @@ found_insertion_point:
 		memmove(&new_lower_paths[idx+1], &new_lower_paths[idx],
 			(cur_branches - idx) * sizeof(struct path));
 	}
-	new_lower_paths[idx].dentry = nd.dentry;
-	new_lower_paths[idx].mnt = nd.mnt;
+	new_lower_paths[idx] = nd.path;
 
-	new_data[idx].sb = nd.dentry->d_sb;
+	new_data[idx].sb = nd.path.dentry->d_sb;
 	atomic_set(&new_data[idx].open_files, 0);
 	new_data[idx].branchperms = perms;
 	new_data[idx].branch_id = ++*high_branch_id; /* assign new branch ID */
_

Patches currently in -mm which might be from jblunck@suse.de are

r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix.patch
r-o-bind-mounts-track-number-of-mount-writers-fix.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
introduce-path_get-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
one-less-parameter-to-__d_path.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
