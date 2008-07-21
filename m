From: akpm@linux-foundation.org
Subject: + autofs4-remove-unused-ioctls.patch added to -mm tree
Date: Sun, 20 Jul 2008 23:35:33 -0700
Message-ID: <200807210635.m6L6ZXl8021585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48052 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755541AbYGUGf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 02:35:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, jmoyer@redhat.com


The patch titled
     autofs4: remove unused ioctls
has been added to the -mm tree.  Its filename is
     autofs4-remove-unused-ioctls.patch

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
Subject: autofs4: remove unused ioctls
From: Ian Kent <raven@themaw.net>

The ioctls AUTOFS_IOC_TOGGLEREGHOST and AUTOFS_IOC_ASKREGHOST were added
several years ago but what they were intended for has never been
implemented (as far as I'm aware noone uses them) so remove them.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c        |   68 -------------------------------------
 fs/compat_ioctl.c        |    2 -
 include/linux/auto_fs4.h |    2 -
 3 files changed, 1 insertion(+), 71 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-remove-unused-ioctls fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-remove-unused-ioctls
+++ a/fs/autofs4/root.c
@@ -25,7 +25,6 @@ static int autofs4_dir_rmdir(struct inod
 static int autofs4_dir_mkdir(struct inode *,struct dentry *,int);
 static int autofs4_root_ioctl(struct inode *, struct file *,unsigned int,unsigned long);
 static int autofs4_dir_open(struct inode *inode, struct file *file);
-static int autofs4_root_readdir(struct file * filp, void * dirent, filldir_t filldir);
 static struct dentry *autofs4_lookup(struct inode *,struct dentry *, struct nameidata *);
 static void *autofs4_follow_link(struct dentry *, struct nameidata *);
 
@@ -36,7 +35,7 @@ const struct file_operations autofs4_roo
 	.open		= dcache_dir_open,
 	.release	= dcache_dir_close,
 	.read		= generic_read_dir,
-	.readdir	= autofs4_root_readdir,
+	.readdir	= dcache_readdir,
 	.ioctl		= autofs4_root_ioctl,
 };
 
@@ -71,28 +70,6 @@ const struct inode_operations autofs4_di
 	.rmdir		= autofs4_dir_rmdir,
 };
 
-static int autofs4_root_readdir(struct file *file, void *dirent,
-				filldir_t filldir)
-{
-	struct autofs_sb_info *sbi = autofs4_sbi(file->f_path.dentry->d_sb);
-	int oz_mode = autofs4_oz_mode(sbi);
-
-	DPRINTK("called, filp->f_pos = %lld", file->f_pos);
-
-	/*
-	 * Don't set reghost flag if:
-	 * 1) f_pos is larger than zero -- we've already been here.
-	 * 2) we haven't even enabled reghosting in the 1st place.
-	 * 3) this is the daemon doing a readdir
-	 */
-	if (oz_mode && file->f_pos == 0 && sbi->reghost_enabled)
-		sbi->needs_reghost = 1;
-
-	DPRINTK("needs_reghost = %d", sbi->needs_reghost);
-
-	return dcache_readdir(file, dirent, filldir);
-}
-
 static int autofs4_dir_open(struct inode *inode, struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
@@ -865,44 +842,6 @@ static inline int autofs4_get_protosubve
 }
 
 /*
- * Tells the daemon whether we need to reghost or not. Also, clears
- * the reghost_needed flag.
- */
-static inline int autofs4_ask_reghost(struct autofs_sb_info *sbi, int __user *p)
-{
-	int status;
-
-	DPRINTK("returning %d", sbi->needs_reghost);
-
-	status = put_user(sbi->needs_reghost, p);
-	if (status)
-		return status;
-
-	sbi->needs_reghost = 0;
-	return 0;
-}
-
-/*
- * Enable / Disable reghosting ioctl() operation
- */
-static inline int autofs4_toggle_reghost(struct autofs_sb_info *sbi, int __user *p)
-{
-	int status;
-	int val;
-
-	status = get_user(val, p);
-
-	DPRINTK("reghost = %d", val);
-
-	if (status)
-		return status;
-
-	/* turn on/off reghosting, with the val */
-	sbi->reghost_enabled = val;
-	return 0;
-}
-
-/*
 * Tells the daemon whether it can umount the autofs mount.
 */
 static inline int autofs4_ask_umount(struct vfsmount *mnt, int __user *p)
@@ -966,11 +905,6 @@ static int autofs4_root_ioctl(struct ino
 	case AUTOFS_IOC_SETTIMEOUT:
 		return autofs4_get_set_timeout(sbi, p);
 
-	case AUTOFS_IOC_TOGGLEREGHOST:
-		return autofs4_toggle_reghost(sbi, p);
-	case AUTOFS_IOC_ASKREGHOST:
-		return autofs4_ask_reghost(sbi, p);
-
 	case AUTOFS_IOC_ASKUMOUNT:
 		return autofs4_ask_umount(filp->f_path.mnt, p);
 
diff -puN fs/compat_ioctl.c~autofs4-remove-unused-ioctls fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~autofs4-remove-unused-ioctls
+++ a/fs/compat_ioctl.c
@@ -2297,8 +2297,6 @@ COMPATIBLE_IOCTL(AUTOFS_IOC_PROTOVER)
 COMPATIBLE_IOCTL(AUTOFS_IOC_EXPIRE)
 COMPATIBLE_IOCTL(AUTOFS_IOC_EXPIRE_MULTI)
 COMPATIBLE_IOCTL(AUTOFS_IOC_PROTOSUBVER)
-COMPATIBLE_IOCTL(AUTOFS_IOC_ASKREGHOST)
-COMPATIBLE_IOCTL(AUTOFS_IOC_TOGGLEREGHOST)
 COMPATIBLE_IOCTL(AUTOFS_IOC_ASKUMOUNT)
 /* Raw devices */
 COMPATIBLE_IOCTL(RAW_SETBIND)
diff -puN include/linux/auto_fs4.h~autofs4-remove-unused-ioctls include/linux/auto_fs4.h
--- a/include/linux/auto_fs4.h~autofs4-remove-unused-ioctls
+++ a/include/linux/auto_fs4.h
@@ -98,8 +98,6 @@ union autofs_v5_packet_union {
 #define AUTOFS_IOC_EXPIRE_INDIRECT	AUTOFS_IOC_EXPIRE_MULTI
 #define AUTOFS_IOC_EXPIRE_DIRECT	AUTOFS_IOC_EXPIRE_MULTI
 #define AUTOFS_IOC_PROTOSUBVER		_IOR(0x93,0x67,int)
-#define AUTOFS_IOC_ASKREGHOST           _IOR(0x93,0x68,int)
-#define AUTOFS_IOC_TOGGLEREGHOST        _IOR(0x93,0x69,int)
 #define AUTOFS_IOC_ASKUMOUNT		_IOR(0x93,0x70,int)
 
 
_

Patches currently in -mm which might be from raven@themaw.net are

autofs4-dont-make-expiring-dentry-negative.patch
autofs4-dont-make-expiring-dentry-negative-fix.patch
autofs4-revert-redo-lookup-in-ttfd.patch
autofs4-use-look-aside-list-for-lookups.patch
autofs4-use-look-aside-list-for-lookups-autofs4-fix-symlink-name-allocation.patch
autofs4-dont-release-directory-mutex-if-called-in-oz_mode.patch
autofs4-use-lookup-intent-flags-to-trigger-mounts.patch
autofs4-use-struct-qstr-in-waitqc.patch
autofs4-fix-waitq-locking.patch
autofs4-fix-pending-mount-race.patch
autofs4-fix-pending-mount-race-fix.patch
autofs4-check-kernel-communication-pipe-is-valid-for-write.patch
autofs4-fix-waitq-memory-leak.patch
autofs4-detect-invalid-direct-mount-requests.patch
autofs4-indirect-dentry-must-almost-always-be-positive.patch
autofs4-cleanup-redundant-readir-code.patch
autofs4-fix-pending-checks.patch
autofs4-fix-indirect-mount-pending-expire-race.patch
autofs4-fix-direct-mount-pending-expire-race.patch
autofs4-reorganize-expire-pending-wait-function-calls.patch
autofs4-remove-unused-ioctls.patch

