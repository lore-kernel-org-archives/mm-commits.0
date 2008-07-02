From: akpm@linux-foundation.org
Subject: - vfs-path_getput-cleanups.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:47:29 -0700
Message-ID: <200807020747.m627lTNo005651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753499AbYGBHsM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:48:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, jens.axboe@oracle.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: path_{get,put}() cleanups
has been removed from the -mm tree.  Its filename was
     vfs-path_getput-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: path_{get,put}() cleanups
From: Jan Blunck <jblunck@suse.de>

Here are some more places where path_{get,put}() can be used instead of
dput()/mntput() pair.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |   11 +++++------
 fs/pipe.c  |   10 ++++------
 2 files changed, 9 insertions(+), 12 deletions(-)

diff -puN fs/namei.c~vfs-path_getput-cleanups fs/namei.c
--- a/fs/namei.c~vfs-path_getput-cleanups
+++ a/fs/namei.c
@@ -582,15 +582,13 @@ static __always_inline int link_path_wal
 	int result;
 
 	/* make sure the stuff we saved doesn't go away */
-	dget(save.dentry);
-	mntget(save.mnt);
+	path_get(&save);
 
 	result = __link_path_walk(name, nd);
 	if (result == -ESTALE) {
 		/* nd->path had been dropped */
 		nd->path = save;
-		dget(nd->path.dentry);
-		mntget(nd->path.mnt);
+		path_get(&nd->path);
 		nd->flags |= LOOKUP_REVAL;
 		result = __link_path_walk(name, nd);
 	}
@@ -1217,8 +1215,9 @@ int vfs_path_lookup(struct dentry *dentr
 	nd->flags = flags;
 	nd->depth = 0;
 
-	nd->path.mnt = mntget(mnt);
-	nd->path.dentry = dget(dentry);
+	nd->path.dentry = dentry;
+	nd->path.mnt = mnt;
+	path_get(&nd->path);
 
 	retval = path_walk(name, nd);
 	if (unlikely(!retval && !audit_dummy_context() && nd->path.dentry &&
diff -puN fs/pipe.c~vfs-path_getput-cleanups fs/pipe.c
--- a/fs/pipe.c~vfs-path_getput-cleanups
+++ a/fs/pipe.c
@@ -1003,8 +1003,7 @@ struct file *create_write_pipe(void)
 void free_write_pipe(struct file *f)
 {
 	free_pipe_info(f->f_dentry->d_inode);
-	dput(f->f_path.dentry);
-	mntput(f->f_path.mnt);
+	path_put(&f->f_path);
 	put_filp(f);
 }
 
@@ -1015,8 +1014,8 @@ struct file *create_read_pipe(struct fil
 		return ERR_PTR(-ENFILE);
 
 	/* Grab pipe from the writer */
-	f->f_path.mnt = mntget(wrf->f_path.mnt);
-	f->f_path.dentry = dget(wrf->f_path.dentry);
+	f->f_path = wrf->f_path;
+	path_get(&wrf->f_path);
 	f->f_mapping = wrf->f_path.dentry->d_inode->i_mapping;
 
 	f->f_pos = 0;
@@ -1068,8 +1067,7 @@ int do_pipe(int *fd)
  err_fdr:
 	put_unused_fd(fdr);
  err_read_pipe:
-	dput(fr->f_dentry);
-	mntput(fr->f_vfsmnt);
+	path_put(&fr->f_path);
 	put_filp(fr);
  err_write_pipe:
 	free_write_pipe(fw);
_

Patches currently in -mm which might be from jblunck@suse.de are

origin.patch
git-unionfs.patch

