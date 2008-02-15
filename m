From: akpm@linux-foundation.org
Subject: - remove-path_release_on_umount.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:16:38 -0500
Message-ID: <200802150720.m1F7K0v3025753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33675 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763376AbYBOH3a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:29:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Remove path_release_on_umount()
has been removed from the -mm tree.  Its filename was
     remove-path_release_on_umount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove path_release_on_umount()
From: Jan Blunck <jblunck@suse.de>

path_release_on_umount() should only be called from sys_umount(). I merged the
function into sys_umount() instead of having in in namei.c.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c            |   10 ----------
 fs/namespace.c        |    4 +++-
 include/linux/namei.h |    1 -
 3 files changed, 3 insertions(+), 12 deletions(-)

diff -puN fs/namei.c~remove-path_release_on_umount fs/namei.c
--- a/fs/namei.c~remove-path_release_on_umount
+++ a/fs/namei.c
@@ -368,16 +368,6 @@ void path_release(struct nameidata *nd)
 	mntput(nd->mnt);
 }
 
-/*
- * umount() mustn't call path_release()/mntput() as that would clear
- * mnt_expiry_mark
- */
-void path_release_on_umount(struct nameidata *nd)
-{
-	dput(nd->dentry);
-	mntput_no_expire(nd->mnt);
-}
-
 /**
  * release_open_intent - free up open intent resources
  * @nd: pointer to nameidata
diff -puN fs/namespace.c~remove-path_release_on_umount fs/namespace.c
--- a/fs/namespace.c~remove-path_release_on_umount
+++ a/fs/namespace.c
@@ -690,7 +690,9 @@ asmlinkage long sys_umount(char __user *
 
 	retval = do_umount(nd.mnt, flags);
 dput_and_out:
-	path_release_on_umount(&nd);
+	/* we mustn't call path_put() as that would clear mnt_expiry_mark */
+	dput(nd.dentry);
+	mntput_no_expire(nd.mnt);
 out:
 	return retval;
 }
diff -puN include/linux/namei.h~remove-path_release_on_umount include/linux/namei.h
--- a/include/linux/namei.h~remove-path_release_on_umount
+++ a/include/linux/namei.h
@@ -72,7 +72,6 @@ extern int path_lookup(const char *, uns
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct nameidata *);
 extern void path_release(struct nameidata *);
-extern void path_release_on_umount(struct nameidata *);
 
 extern int __user_path_lookup_open(const char __user *, unsigned lookup_flags, struct nameidata *nd, int open_flags);
 extern int path_lookup_open(int dfd, const char *name, unsigned lookup_flags, struct nameidata *, int open_flags);
_

Patches currently in -mm which might be from jblunck@suse.de are

origin.patch
introduce-path_put-unionfs.patch
