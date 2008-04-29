From: akpm@linux-foundation.org
Subject: + autofs-path_getput-cleanups.patch added to -mm tree
Date: Tue, 29 Apr 2008 16:18:19 -0700
Message-ID: <200804292318.m3TNIJJj015356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754753AbYD2XSz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 19:18:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, raven@themaw.net


The patch titled
     autofs: path_{get,put}() cleanups
has been added to the -mm tree.  Its filename is
     autofs-path_getput-cleanups.patch

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
Subject: autofs: path_{get,put}() cleanups
From: Jan Blunck <jblunck@suse.de>

Here are some more places where path_{get,put}() can be used instead of
dput()/mntput() pair.  Besides that it fixes a bug in autofs4_mount_busy()
where mntput() was called before dput().

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/expire.c |    2 +-
 fs/autofs4/root.c   |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/autofs4/expire.c~autofs-path_getput-cleanups fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs-path_getput-cleanups
+++ a/fs/autofs4/expire.c
@@ -73,8 +73,8 @@ static int autofs4_mount_busy(struct vfs
 	status = 0;
 done:
 	DPRINTK("returning = %d", status);
-	mntput(mnt);
 	dput(dentry);
+	mntput(mnt);
 	return status;
 }
 
diff -puN fs/autofs4/root.c~autofs-path_getput-cleanups fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs-path_getput-cleanups
+++ a/fs/autofs4/root.c
@@ -146,17 +146,17 @@ static int autofs4_dir_open(struct inode
 
 	if (d_mountpoint(dentry)) {
 		struct file *fp = NULL;
-		struct vfsmount *fp_mnt = mntget(mnt);
-		struct dentry *fp_dentry = dget(dentry);
+		struct path fp_path = { .dentry = dentry, .mnt = mnt };
 
-		if (!autofs4_follow_mount(&fp_mnt, &fp_dentry)) {
-			dput(fp_dentry);
-			mntput(fp_mnt);
+		path_get(&fp_path);
+
+		if (!autofs4_follow_mount(&fp_path.mnt, &fp_path.dentry)) {
+			path_put(&fp_path);
 			dcache_dir_close(inode, file);
 			goto out;
 		}
 
-		fp = dentry_open(fp_dentry, fp_mnt, file->f_flags);
+		fp = dentry_open(fp_path.dentry, fp_path.mnt, file->f_flags);
 		status = PTR_ERR(fp);
 		if (IS_ERR(fp)) {
 			dcache_dir_close(inode, file);
_

Patches currently in -mm which might be from jblunck@suse.de are

vfs-remove-lives_below_in_same_fs.patch
nfs-path_getput-cleanups.patch
git-unionfs.patch
vfs-path_getput-cleanups.patch
autofs-path_getput-cleanups.patch

