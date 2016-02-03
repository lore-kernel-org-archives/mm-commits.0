From: akpm@linux-foundation.org
Subject: + autofs4-fix-some-white-space-errors.patch added to -mm tree
Date: Tue, 02 Feb 2016 19:42:25 -0800
Message-ID: <56b17721.iBqVDDE4MKT46Xwe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59239 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845AbcBCDm0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 22:42:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: fix some white space errors
has been added to the -mm tree.  Its filename is
     autofs4-fix-some-white-space-errors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs4-fix-some-white-space-errors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs4-fix-some-white-space-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: autofs4: fix some white space errors

Fix some white space format errors.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c        |    1 -
 fs/autofs4/inode.c            |    2 +-
 fs/autofs4/root.c             |    8 ++++----
 fs/autofs4/waitq.c            |    3 +--
 include/uapi/linux/auto_fs.h  |    2 +-
 include/uapi/linux/auto_fs4.h |    2 +-
 6 files changed, 8 insertions(+), 10 deletions(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs4-fix-some-white-space-errors fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs4-fix-some-white-space-errors
+++ a/fs/autofs4/dev-ioctl.c
@@ -765,4 +765,3 @@ void autofs_dev_ioctl_exit(void)
 {
 	misc_deregister(&_autofs_dev_ioctl_misc);
 }
-
diff -puN fs/autofs4/inode.c~autofs4-fix-some-white-space-errors fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs4-fix-some-white-space-errors
+++ a/fs/autofs4/inode.c
@@ -327,7 +327,7 @@ int autofs4_fill_super(struct super_bloc
 	 */
 	s->s_root = root;
 	return 0;
-	
+
 	/*
 	 * Failure ... clean up.
 	 */
diff -puN fs/autofs4/root.c~autofs4-fix-some-white-space-errors fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-fix-some-white-space-errors
+++ a/fs/autofs4/root.c
@@ -618,7 +618,7 @@ static int autofs4_dir_unlink(struct ino
 	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	struct autofs_info *p_ino;
-	
+
 	/* This allows root to remove symlinks */
 	if (!autofs4_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -698,7 +698,7 @@ static int autofs4_dir_rmdir(struct inod
 	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	struct autofs_info *p_ino;
-	
+
 	DPRINTK("dentry %p, removing %pd", dentry, dentry);
 
 	if (!autofs4_oz_mode(sbi))
@@ -878,10 +878,10 @@ static int autofs4_root_ioctl_unlocked(s
 	if (_IOC_TYPE(cmd) != _IOC_TYPE(AUTOFS_IOC_FIRST) ||
 	     _IOC_NR(cmd) - _IOC_NR(AUTOFS_IOC_FIRST) >= AUTOFS_IOC_COUNT)
 		return -ENOTTY;
-	
+
 	if (!autofs4_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	
+
 	switch (cmd) {
 	case AUTOFS_IOC_READY:	/* Wait queue: go ahead and retry */
 		return autofs4_wait_release(sbi, (autofs_wqt_t) arg, 0);
diff -puN fs/autofs4/waitq.c~autofs4-fix-some-white-space-errors fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-fix-some-white-space-errors
+++ a/fs/autofs4/waitq.c
@@ -88,7 +88,7 @@ static int autofs4_write(struct autofs_s
 
 	return (bytes > 0);
 }
-	
+
 static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 				 struct autofs_wait_queue *wq,
 				 int type)
@@ -569,4 +569,3 @@ int autofs4_wait_release(struct autofs_s
 
 	return 0;
 }
-
diff -puN include/uapi/linux/auto_fs.h~autofs4-fix-some-white-space-errors include/uapi/linux/auto_fs.h
--- a/include/uapi/linux/auto_fs.h~autofs4-fix-some-white-space-errors
+++ a/include/uapi/linux/auto_fs.h
@@ -48,7 +48,7 @@ struct autofs_packet_hdr {
 
 struct autofs_packet_missing {
 	struct autofs_packet_hdr hdr;
-        autofs_wqt_t wait_queue_token;
+	autofs_wqt_t wait_queue_token;
 	int len;
 	char name[NAME_MAX+1];
 };	
diff -puN include/uapi/linux/auto_fs4.h~autofs4-fix-some-white-space-errors include/uapi/linux/auto_fs4.h
--- a/include/uapi/linux/auto_fs4.h~autofs4-fix-some-white-space-errors
+++ a/include/uapi/linux/auto_fs4.h
@@ -108,7 +108,7 @@ enum autofs_notify {
 /* v4 multi expire (via pipe) */
 struct autofs_packet_expire_multi {
 	struct autofs_packet_hdr hdr;
-        autofs_wqt_t wait_queue_token;
+	autofs_wqt_t wait_queue_token;
 	int len;
 	char name[NAME_MAX+1];
 };
_

Patches currently in -mm which might be from raven@themaw.net are

autofs4-coding-style-fixes.patch
autofs4-fix-coding-style-problem-in-autofs4_get_set_timeout.patch
autofs4-fix-coding-style-line-length-in-autofs4_wait.patch
autofs4-fix-invalid-ioctl-return-in-autofs4_root_ioctl_unlocked.patch
autofs4-fix-some-white-space-errors.patch
autofs4-fix-stringh-include-in-auto_dev-ioctlh.patch

