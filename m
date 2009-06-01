From: akpm@linux-foundation.org
Subject: + syscallsh-remove-duplicated-declarations-for-sys_pipe2.patch added to -mm tree
Date: Mon, 01 Jun 2009 14:36:10 -0700
Message-ID: <200906012136.n51LaAQS028895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751489AbZFAVgx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 17:36:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yamato@redhat.com


The patch titled
     syscalls.h: remove duplicated declarations for sys_pipe2
has been added to the -mm tree.  Its filename is
     syscallsh-remove-duplicated-declarations-for-sys_pipe2.patch

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
@@ -433,6 +433,7 @@ asmlinkage long sys_fcntl(unsigned int f
 asmlinkage long sys_fcntl64(unsigned int fd,
 				unsigned int cmd, unsigned long arg);
 #endif
+asmlinkage long sys_pipe(int __user *fildes);
 asmlinkage long sys_pipe2(int __user *fildes, int flags);
 asmlinkage long sys_dup(unsigned int fildes);
 asmlinkage long sys_dup2(unsigned int oldfd, unsigned int newfd);
@@ -750,8 +751,6 @@ asmlinkage long sys_pselect6(int, fd_set
 asmlinkage long sys_ppoll(struct pollfd __user *, unsigned int,
 			  struct timespec __user *, const sigset_t __user *,
 			  size_t);
-asmlinkage long sys_pipe2(int __user *, int);
-asmlinkage long sys_pipe(int __user *);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
_

Patches currently in -mm which might be from yamato@redhat.com are

syscallsh-remove-duplicated-declarations-for-sys_pipe2.patch

