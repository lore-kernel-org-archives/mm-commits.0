From: akpm@linux-foundation.org
Subject: + use-path_put-in-a-few-places-instead-of-mntdput.patch added to -mm tree
Date: Mon, 05 Nov 2007 13:02:13 -0800
Message-ID: <200711052102.lA5L2DSg019553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38615 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753738AbXKEVCf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 16:02:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, agruen@suse.de, dhowells@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     Use path_put() in a few places instead of {mnt,d}put()
has been added to the -mm tree.  Its filename is
     use-path_put-in-a-few-places-instead-of-mntdput.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use path_put() in a few places instead of {mnt,d}put()
From: Jan Blunck <jblunck@suse.de>

Use path_put() in a few places instead of {mnt,d}put()

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/mntpt.c |    3 +--
 fs/namei.c     |   15 +++++----------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff -puN fs/afs/mntpt.c~use-path_put-in-a-few-places-instead-of-mntdput fs/afs/mntpt.c
--- a/fs/afs/mntpt.c~use-path_put-in-a-few-places-instead-of-mntdput
+++ a/fs/afs/mntpt.c
@@ -235,8 +235,7 @@ static void *afs_mntpt_follow_link(struc
 	err = do_add_mount(newmnt, nd, MNT_SHRINKABLE, &afs_vfsmounts);
 	switch (err) {
 	case 0:
-		dput(nd->path.dentry);
-		mntput(nd->path.mnt);
+		path_put(&nd->path);
 		nd->path.mnt = newmnt;
 		nd->path.dentry = dget(newmnt->mnt_root);
 		schedule_delayed_work(&afs_mntpt_expiry_timer,
diff -puN fs/namei.c~use-path_put-in-a-few-places-instead-of-mntdput fs/namei.c
--- a/fs/namei.c~use-path_put-in-a-few-places-instead-of-mntdput
+++ a/fs/namei.c
@@ -626,8 +626,7 @@ static __always_inline int __do_follow_l
 		if (dentry->d_inode->i_op->put_link)
 			dentry->d_inode->i_op->put_link(dentry, nd, cookie);
 	}
-	dput(dentry);
-	mntput(path->mnt);
+	path_put(path);
 
 	return error;
 }
@@ -1034,8 +1033,7 @@ static int fastcall link_path_walk(const
 		result = __link_path_walk(name, nd);
 	}
 
-	dput(save.path.dentry);
-	mntput(save.path.mnt);
+	path_put(&save.path);
 
 	return result;
 }
@@ -1057,8 +1055,7 @@ static int __emul_lookup_dentry(const ch
 
 	if (!nd->path.dentry->d_inode ||
 	    S_ISDIR(nd->path.dentry->d_inode->i_mode)) {
-		struct dentry *old_dentry = nd->path.dentry;
-		struct vfsmount *old_mnt = nd->path.mnt;
+		struct path old_path = nd->path;
 		struct qstr last = nd->last;
 		int last_type = nd->last_type;
 		struct fs_struct *fs = current->fs;
@@ -1074,14 +1071,12 @@ static int __emul_lookup_dentry(const ch
 		read_unlock(&fs->lock);
 		if (path_walk(name, nd) == 0) {
 			if (nd->path.dentry->d_inode) {
-				dput(old_dentry);
-				mntput(old_mnt);
+				path_put(&old_path);
 				return 1;
 			}
 			path_put(&nd->path);
 		}
-		nd->path.dentry = old_dentry;
-		nd->path.mnt = old_mnt;
+		nd->path = old_path;
 		nd->last = last;
 		nd->last_type = last_type;
 	}
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
