From: akpm@linux-foundation.org
Subject: [merged] syscallsh-remove-duplicated-declarations-for-sys_pipe2.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:37:44 -0700
Message-ID: <200906171837.n5HIbi0G003788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760159AbZFQSir (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:38:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamato@redhat.com, mm-commits@vger.kernel.org


The patch titled
     syscalls.h: remove duplicated declarations for sys_pipe2
has been removed from the -mm tree.  Its filename was
     syscallsh-remove-duplicated-declarations-for-sys_pipe2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: syscalls.h: remove duplicated declarations for sys_pipe2
From: Masatake YAMATO <yamato@redhat.com>

sys_pipe2 is declared twice in include/linux/syscalls.h.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/syscalls.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/syscalls.h~syscallsh-remove-duplicated-declarations-for-sys_pipe2 include/linux/syscalls.h
--- a/include/linux/syscalls.h~syscallsh-remove-duplicated-declarations-for-sys_pipe2
+++ a/include/linux/syscalls.h
@@ -434,6 +434,7 @@ asmlinkage long sys_fcntl(unsigned int f
 asmlinkage long sys_fcntl64(unsigned int fd,
 				unsigned int cmd, unsigned long arg);
 #endif
+asmlinkage long sys_pipe(int __user *fildes);
 asmlinkage long sys_pipe2(int __user *fildes, int flags);
 asmlinkage long sys_dup(unsigned int fildes);
 asmlinkage long sys_dup2(unsigned int oldfd, unsigned int newfd);
@@ -751,8 +752,6 @@ asmlinkage long sys_pselect6(int, fd_set
 asmlinkage long sys_ppoll(struct pollfd __user *, unsigned int,
 			  struct timespec __user *, const sigset_t __user *,
 			  size_t);
-asmlinkage long sys_pipe2(int __user *, int);
-asmlinkage long sys_pipe(int __user *);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
_

Patches currently in -mm which might be from yamato@redhat.com are

origin.patch

