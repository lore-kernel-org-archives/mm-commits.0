From: akpm@linux-foundation.org
Subject: + autofs4-cleanup-expire-code-duplication.patch added to -mm tree
Date: Sun, 22 Mar 2009 18:08:27 -0700
Message-ID: <200903230112.n2N1Cj9Y003168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753720AbZCWBOo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Mar 2009 21:14:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, jmoyer@redhat.com


The patch titled
     autofs4: cleanup expire code duplication
has been added to the -mm tree.  Its filename is
     autofs4-cleanup-expire-code-duplication.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: cleanup expire code duplication
From: Ian Kent <raven@themaw.net>

A significant portion of the autofs_dev_ioctl_expire() and
autofs4_expire_multi() functions is duplicated code.  This patch cleans that
up.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h  |    2 ++
 fs/autofs4/dev-ioctl.c |   29 +----------------------------
 fs/autofs4/expire.c    |   27 +++++++++++++++++----------
 3 files changed, 20 insertions(+), 38 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-cleanup-expire-code-duplication fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-cleanup-expire-code-duplication
+++ a/fs/autofs4/autofs_i.h
@@ -186,6 +186,8 @@ int autofs4_expire_wait(struct dentry *d
 int autofs4_expire_run(struct super_block *, struct vfsmount *,
 			struct autofs_sb_info *,
 			struct autofs_packet_expire __user *);
+int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
+			    struct autofs_sb_info *sbi, int when);
 int autofs4_expire_multi(struct super_block *, struct vfsmount *,
 			struct autofs_sb_info *, int __user *);
 struct dentry *autofs4_expire_direct(struct super_block *sb,
diff -puN fs/autofs4/dev-ioctl.c~autofs4-cleanup-expire-code-duplication fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs4-cleanup-expire-code-duplication
+++ a/fs/autofs4/dev-ioctl.c
@@ -525,40 +525,13 @@ static int autofs_dev_ioctl_expire(struc
 				   struct autofs_sb_info *sbi,
 				   struct autofs_dev_ioctl *param)
 {
-	struct dentry *dentry;
 	struct vfsmount *mnt;
-	int err = -EAGAIN;
 	int how;
 
 	how = param->expire.how;
 	mnt = fp->f_path.mnt;
 
-	if (autofs_type_trigger(sbi->type))
-		dentry = autofs4_expire_direct(sbi->sb, mnt, sbi, how);
-	else
-		dentry = autofs4_expire_indirect(sbi->sb, mnt, sbi, how);
-
-	if (dentry) {
-		struct autofs_info *ino = autofs4_dentry_ino(dentry);
-
-		/*
-		 * This is synchronous because it makes the daemon a
-		 * little easier
-		*/
-		err = autofs4_wait(sbi, dentry, NFY_EXPIRE);
-
-		spin_lock(&sbi->fs_lock);
-		if (ino->flags & AUTOFS_INF_MOUNTPOINT) {
-			ino->flags &= ~AUTOFS_INF_MOUNTPOINT;
-			sbi->sb->s_root->d_mounted++;
-		}
-		ino->flags &= ~AUTOFS_INF_EXPIRING;
-		complete_all(&ino->expire_complete);
-		spin_unlock(&sbi->fs_lock);
-		dput(dentry);
-	}
-
-	return err;
+	return autofs4_do_expire_multi(sbi->sb, mnt, sbi, how);
 }
 
 /* Check if autofs mount point is in use */
diff -puN fs/autofs4/expire.c~autofs4-cleanup-expire-code-duplication fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs4-cleanup-expire-code-duplication
+++ a/fs/autofs4/expire.c
@@ -478,22 +478,16 @@ int autofs4_expire_run(struct super_bloc
 	return ret;
 }
 
-/* Call repeatedly until it returns -EAGAIN, meaning there's nothing
-   more to be done */
-int autofs4_expire_multi(struct super_block *sb, struct vfsmount *mnt,
-			struct autofs_sb_info *sbi, int __user *arg)
+int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
+			    struct autofs_sb_info *sbi, int when)
 {
 	struct dentry *dentry;
 	int ret = -EAGAIN;
-	int do_now = 0;
-
-	if (arg && get_user(do_now, arg))
-		return -EFAULT;
 
 	if (autofs_type_trigger(sbi->type))
-		dentry = autofs4_expire_direct(sb, mnt, sbi, do_now);
+		dentry = autofs4_expire_direct(sb, mnt, sbi, when);
 	else
-		dentry = autofs4_expire_indirect(sb, mnt, sbi, do_now);
+		dentry = autofs4_expire_indirect(sb, mnt, sbi, when);
 
 	if (dentry) {
 		struct autofs_info *ino = autofs4_dentry_ino(dentry);
@@ -516,3 +510,16 @@ int autofs4_expire_multi(struct super_bl
 	return ret;
 }
 
+/* Call repeatedly until it returns -EAGAIN, meaning there's nothing
+   more to be done */
+int autofs4_expire_multi(struct super_block *sb, struct vfsmount *mnt,
+			struct autofs_sb_info *sbi, int __user *arg)
+{
+	int do_now = 0;
+
+	if (arg && get_user(do_now, arg))
+		return -EFAULT;
+
+	return autofs4_do_expire_multi(sb, mnt, sbi, do_now);
+}
+
_

Patches currently in -mm which might be from raven@themaw.net are

autofs4-cleanup-expire-code-duplication.patch
autofs4-fix-lookup-deadlock.patch
autofs4-fix-kernel-includes.patch

