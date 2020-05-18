From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 fs-include-fmode_exec-when-converting-flags-to-f_mode.patch added to -mm
 tree
Date: Mon, 18 May 2020 13:42:08 -0700
Message-ID: <20200518204208.59t-wjebv%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbgERUmJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 16:42:09 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christian.brauner@ubuntu.com, dvyukov@google.com, ebiggers3@gmail.com, keescook@chromium.org, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs: include FMODE_EXEC when converting flags to f_mode
has been added to the -mm tree.  Its filename is
     fs-include-fmode_exec-when-converting-flags-to-f_mode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-include-fmode_exec-when-converting-flags-to-f_mode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-include-fmode_exec-when-converting-flags-to-f_mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: fs: include FMODE_EXEC when converting flags to f_mode

Include FMODE_EXEC when building the f_mode field, so that code can
actually test the correct field and values.  Only three places actually
examine f_flags for FMODE_EXEC:

fs/open.c:      if (unlikely((f->f_mode & FMODE_EXEC) && !S_ISREG(inode->i_mode))) {
include/linux/fsnotify.h:               if (file->f_mode & FMODE_EXEC) {
include/linux/fsnotify.h:       if (file->f_mode & FMODE_EXEC)

Link: http://lkml.kernel.org/r/20200518055457.12302-5-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Eric Biggers <ebiggers3@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c               |    4 ++--
 include/linux/fs.h       |    3 ++-
 include/linux/fsnotify.h |    4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

--- a/fs/namei.c~fs-include-fmode_exec-when-converting-flags-to-f_mode
+++ a/fs/namei.c
@@ -3213,8 +3213,8 @@ static int do_open(struct nameidata *nd,
 		return -ENOTDIR;
 
 	/* Opening for execution requires a regular file on an exec mnt. */
-	if ((file->f_flags & FMODE_EXEC) && (!d_is_reg(nd->path.dentry) ||
-					     path_noexec(&nd->path)))
+	if ((file->f_mode & FMODE_EXEC) && (!d_is_reg(nd->path.dentry) ||
+					    path_noexec(&nd->path)))
 		return -EACCES;
 
 	do_truncate = false;
--- a/include/linux/fs.h~fs-include-fmode_exec-when-converting-flags-to-f_mode
+++ a/include/linux/fs.h
@@ -3563,10 +3563,11 @@ int __init get_filesystem_list(char *buf
 
 #define __FMODE_EXEC		((__force int) FMODE_EXEC)
 #define __FMODE_NONOTIFY	((__force int) FMODE_NONOTIFY)
+#define __SMUGGLED_FMODE_FLAGS	(__FMODE_EXEC | __FMODE_NONOTIFY)
 
 #define ACC_MODE(x) ("\004\002\006\006"[(x)&O_ACCMODE])
 #define OPEN_FMODE(flag) ((__force fmode_t)(((flag + 1) & O_ACCMODE) | \
-					    (flag & __FMODE_NONOTIFY)))
+					    (flag & __SMUGGLED_FMODE_FLAGS)))
 
 static inline bool is_sxid(umode_t mode)
 {
--- a/include/linux/fsnotify.h~fs-include-fmode_exec-when-converting-flags-to-f_mode
+++ a/include/linux/fsnotify.h
@@ -90,7 +90,7 @@ static inline int fsnotify_perm(struct f
 	if (mask & MAY_OPEN) {
 		fsnotify_mask = FS_OPEN_PERM;
 
-		if (file->f_flags & __FMODE_EXEC) {
+		if (file->f_mode & FMODE_EXEC) {
 			ret = fsnotify_file(file, FS_OPEN_EXEC_PERM);
 
 			if (ret)
@@ -264,7 +264,7 @@ static inline void fsnotify_open(struct
 {
 	__u32 mask = FS_OPEN;
 
-	if (file->f_flags & __FMODE_EXEC)
+	if (file->f_mode & FMODE_EXEC)
 		mask |= FS_OPEN_EXEC;
 
 	fsnotify_file(file, mask);
_

Patches currently in -mm which might be from keescook@chromium.org are

exec-change-uselib2-is_sreg-failure-to-eacces.patch
exec-relocate-s_isreg-check.patch
exec-relocate-path_noexec-check.patch
fs-include-fmode_exec-when-converting-flags-to-f_mode.patch
