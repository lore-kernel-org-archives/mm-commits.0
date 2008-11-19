From: akpm@linux-foundation.org
Subject: + inotify-fix-type-errors-in-interfaces.patch added to -mm tree
Date: Wed, 19 Nov 2008 00:06:31 -0800
Message-ID: <200811190806.mAJ86VuO000334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752007AbYKSIGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 03:06:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mtk.manpages@googlemail.com, drepper@redhat.com, rlove@google.com, vegard.nossum@gmail.com


The patch titled
     inotify: fix type errors in interfaces
has been added to the -mm tree.  Its filename is
     inotify-fix-type-errors-in-interfaces.patch

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
Subject: inotify: fix type errors in interfaces
From: Michael Kerrisk <mtk.manpages@googlemail.com>

The problems lie in the types used for some inotify interfaces, both at
the kernel level and at the glibc level.  This mail addresses the kernel
problem.  I will follow up with some suggestions for glibc changes.

For the sys_inotify_rm_watch() interface, the type of the 'wd' argument is
currently 'u32', it should be '__s32' .  That is Robert's suggestion, and
is consistent with the other declarations of watch descriptors in the
kernel source, in particular, the inotify_event structure in
include/linux/inotify.h:

struct inotify_event {
        __s32           wd;             /* watch descriptor */
        __u32           mask;           /* watch mask */
        __u32           cookie;         /* cookie to synchronize two events */
        __u32           len;            /* length (including nulls) of name */
        char            name[0];        /* stub for possible name */
};

The patch makes the changes needed for inotify_rm_watch().

Signed-off-by: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Robert Love <rlove@google.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inotify_user.c        |    2 +-
 include/linux/syscalls.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/inotify_user.c~inotify-fix-type-errors-in-interfaces fs/inotify_user.c
--- a/fs/inotify_user.c~inotify-fix-type-errors-in-interfaces
+++ a/fs/inotify_user.c
@@ -704,7 +704,7 @@ fput_and_out:
 	return ret;
 }
 
-asmlinkage long sys_inotify_rm_watch(int fd, u32 wd)
+asmlinkage long sys_inotify_rm_watch(int fd, __s32 wd)
 {
 	struct file *filp;
 	struct inotify_device *dev;
diff -puN include/linux/syscalls.h~inotify-fix-type-errors-in-interfaces include/linux/syscalls.h
--- a/include/linux/syscalls.h~inotify-fix-type-errors-in-interfaces
+++ a/include/linux/syscalls.h
@@ -549,7 +549,7 @@ asmlinkage long sys_inotify_init(void);
 asmlinkage long sys_inotify_init1(int flags);
 asmlinkage long sys_inotify_add_watch(int fd, const char __user *path,
 					u32 mask);
-asmlinkage long sys_inotify_rm_watch(int fd, u32 wd);
+asmlinkage long sys_inotify_rm_watch(int fd, __s32 wd);
 
 asmlinkage long sys_spu_run(int fd, __u32 __user *unpc,
 				 __u32 __user *ustatus);
_

Patches currently in -mm which might be from mtk.manpages@googlemail.com are

inotify-fix-type-errors-in-interfaces.patch

