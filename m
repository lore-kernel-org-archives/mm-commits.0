From: akpm@linux-foundation.org
Subject: - inotify-fix-type-errors-in-interfaces.patch removed from -mm tree
Date: Tue, 06 Jan 2009 11:59:04 -0800
Message-ID: <200901061959.n06Jx4T6031903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751661AbZAFT72 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 14:59:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mtk.manpages@googlemail.com, drepper@redhat.com, john@johnmccutchan.com, rlove@rlove.org, vegard.nossum@gmail.com, mm-commits@vger.kernel.org


The patch titled
     inotify: fix type errors in interfaces
has been removed from the -mm tree.  Its filename was
     inotify-fix-type-errors-in-interfaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Robert Love <rlove@rlove.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Acked-by: John McCutchan <john@johnmccutchan.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/inotify_user.c |    2 +-
 include/linux/syscalls.h         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/notify/inotify/inotify_user.c~inotify-fix-type-errors-in-interfaces fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~inotify-fix-type-errors-in-interfaces
+++ a/fs/notify/inotify/inotify_user.c
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

origin.patch

