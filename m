From: akpm@linux-foundation.org
Subject: - sys_pipe-fix-file-descriptor-leaks.patch removed from -mm tree
Date: Fri, 09 May 2008 14:46:39 -0700
Message-ID: <200805092146.m49Lkdkq027135@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607AbYEIV4l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:56:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drepper@redhat.com, dm.n9107@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sys_pipe(): fix file descriptor leaks
has been removed from the -mm tree.  Its filename was
     sys_pipe-fix-file-descriptor-leaks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_pipe(): fix file descriptor leaks
From: Ulrich Drepper <drepper@redhat.com>

Remember to close the files if copy_to_user() failed.

Spotted by dm.n9107@gmail.com.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Cc: DM <dm.n9107@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/kernel/sys_cris.c |    5 ++++-
 arch/m32r/kernel/sys_m32r.c |    5 ++++-
 fs/pipe.c                   |    6 +++++-
 3 files changed, 13 insertions(+), 3 deletions(-)

diff -puN arch/cris/kernel/sys_cris.c~sys_pipe-fix-file-descriptor-leaks arch/cris/kernel/sys_cris.c
--- a/arch/cris/kernel/sys_cris.c~sys_pipe-fix-file-descriptor-leaks
+++ a/arch/cris/kernel/sys_cris.c
@@ -40,8 +40,11 @@ asmlinkage int sys_pipe(unsigned long __
         error = do_pipe(fd);
         unlock_kernel();
         if (!error) {
-                if (copy_to_user(fildes, fd, 2*sizeof(int)))
+                if (copy_to_user(fildes, fd, 2*sizeof(int))) {
+			sys_close(fd[0]);
+			sys_close(fd[1]);
                         error = -EFAULT;
+		}
         }
         return error;
 }
diff -puN arch/m32r/kernel/sys_m32r.c~sys_pipe-fix-file-descriptor-leaks arch/m32r/kernel/sys_m32r.c
--- a/arch/m32r/kernel/sys_m32r.c~sys_pipe-fix-file-descriptor-leaks
+++ a/arch/m32r/kernel/sys_m32r.c
@@ -90,8 +90,11 @@ sys_pipe(unsigned long r0, unsigned long
 
 	error = do_pipe(fd);
 	if (!error) {
-		if (copy_to_user((void __user *)r0, fd, 2*sizeof(int)))
+		if (copy_to_user((void __user *)r0, fd, 2*sizeof(int))) {
+			sys_close(fd[0]);
+			sys_close(fd[1]);
 			error = -EFAULT;
+		}
 	}
 	return error;
 }
diff -puN fs/pipe.c~sys_pipe-fix-file-descriptor-leaks fs/pipe.c
--- a/fs/pipe.c~sys_pipe-fix-file-descriptor-leaks
+++ a/fs/pipe.c
@@ -17,6 +17,7 @@
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
 #include <linux/audit.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
@@ -1086,8 +1087,11 @@ asmlinkage long __weak sys_pipe(int __us
 
 	error = do_pipe(fd);
 	if (!error) {
-		if (copy_to_user(fildes, fd, sizeof(fd)))
+		if (copy_to_user(fildes, fd, sizeof(fd))) {
+			sys_close(fd[0]);
+			sys_close(fd[1]);
 			error = -EFAULT;
+		}
 	}
 	return error;
 }
_

Patches currently in -mm which might be from drepper@redhat.com are

origin.patch
execve-filename-document-and-export-via-auxiliary-vector.patch
flag-parameters-socket-and-socketpair.patch
flag-parameters-paccept.patch
flag-parameters-paccept-fix.patch
flag-parameters-anon_inode_getfd-extension.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd.patch
flag-parameters-eventfd.patch
flag-parameters-timerfd_create.patch
flag-parameters-epoll_create.patch
flag-parameters-dup2.patch
flag-parameters-pipe.patch
flag-parameters-inotify_init.patch
flag-parameters-inotify_init-fix.patch
flag-parametersi-nonblock-in-anon_inode_getfd.patch
flag-parameters-nonblock-in-socket-and-socketpair.patch
flag-parameters-nonblock-in-signalfd.patch
flag-parameters-nonblock-in-eventfd.patch
flag-parameters-nonblock-in-timerfd_create.patch
flag-parameters-nonblock-in-pipe.patch
flag-parameters-nonblock-in-inotify_init.patch
flag-parameters-check-magic-constants.patch
flag-parameters-add-on-remove-epoll_create-size-param.patch

