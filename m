From: akpm@linux-foundation.org
Subject: - use-path_put-in-a-few-places-instead-of-mntdput.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:16:46 -0500
Message-ID: <200802150720.m1F7K8fE025789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36148 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764578AbYBOHaH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:30:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, agruen@suse.de, dhowells@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Use path_put() in a few places instead of {mnt,d}put()
has been removed from the -mm tree.  Its filename was
     use-path_put-in-a-few-places-instead-of-mntdput.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use path_put() in a few places instead of {mnt,d}put()
From: Jan Blunck <jblunck@suse.de>

Use path_put() in a few places instead of {mnt,d}put()

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: David Howells <dhowells@redhat.com>
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
@@ -625,8 +625,7 @@ static __always_inline int __do_follow_l
 		if (dentry->d_inode->i_op->put_link)
 			dentry->d_inode->i_op->put_link(dentry, nd, cookie);
 	}
-	dput(dentry);
-	mntput(path->mnt);
+	path_put(path);
 
 	return error;
 }
@@ -1033,8 +1032,7 @@ static int link_path_walk(const char *na
 		result = __link_path_walk(name, nd);
 	}
 
-	dput(save.path.dentry);
-	mntput(save.path.mnt);
+	path_put(&save.path);
 
 	return result;
 }
@@ -1056,8 +1054,7 @@ static int __emul_lookup_dentry(const ch
 
 	if (!nd->path.dentry->d_inode ||
 	    S_ISDIR(nd->path.dentry->d_inode->i_mode)) {
-		struct dentry *old_dentry = nd->path.dentry;
-		struct vfsmount *old_mnt = nd->path.mnt;
+		struct path old_path = nd->path;
 		struct qstr last = nd->last;
 		int last_type = nd->last_type;
 		struct fs_struct *fs = current->fs;
@@ -1073,14 +1070,12 @@ static int __emul_lookup_dentry(const ch
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

origin.patch
introduce-path_put-unionfs.patch
