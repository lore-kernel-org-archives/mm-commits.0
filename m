From: akpm@linux-foundation.org
Subject: [merged] xtensa-use-generic-sys_pipe.patch removed from -mm tree
Date: Thu, 17 Dec 2009 12:40:04 -0800
Message-ID: <200912172040.nBHKe4jK017551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764831AbZLQUk6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Dec 2009 15:40:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, amwang@redhat.com, chris@zankel.net, jw@emlix.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     xtensa: use generic sys_pipe()
has been removed from the -mm tree.  Its filename was
     xtensa-use-generic-sys_pipe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: use generic sys_pipe()
From: Amerigo Wang <xiyou.wangcong@gmail.com>

As suggested by Al, we can use the generic sys_pipe() instead of
xtensa_pipe() for xtensa.

Signed-off-by: WANG Cong <amwang@redhat.com>
Reviewed-by: Johannes Weiner <jw@emlix.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/syscall.h |    1 -
 arch/xtensa/include/asm/unistd.h  |    2 +-
 arch/xtensa/kernel/syscall.c      |   18 ------------------
 3 files changed, 1 insertion(+), 20 deletions(-)

diff -puN arch/xtensa/include/asm/syscall.h~xtensa-use-generic-sys_pipe arch/xtensa/include/asm/syscall.h
--- a/arch/xtensa/include/asm/syscall.h~xtensa-use-generic-sys_pipe
+++ a/arch/xtensa/include/asm/syscall.h
@@ -12,7 +12,6 @@ struct pt_regs;
 struct sigaction;
 asmlinkage long xtensa_execve(char*, char**, char**, struct pt_regs*);
 asmlinkage long xtensa_clone(unsigned long, unsigned long, struct pt_regs*);
-asmlinkage long xtensa_pipe(int __user *);
 asmlinkage long xtensa_ptrace(long, long, long, long);
 asmlinkage long xtensa_sigreturn(struct pt_regs*);
 asmlinkage long xtensa_rt_sigreturn(struct pt_regs*);
diff -puN arch/xtensa/include/asm/unistd.h~xtensa-use-generic-sys_pipe arch/xtensa/include/asm/unistd.h
--- a/arch/xtensa/include/asm/unistd.h~xtensa-use-generic-sys_pipe
+++ a/arch/xtensa/include/asm/unistd.h
@@ -94,7 +94,7 @@ __SYSCALL( 35, sys_readlink, 3)
 #define __NR_mknod 				 36
 __SYSCALL( 36, sys_mknod, 3)
 #define __NR_pipe 				 37
-__SYSCALL( 37, xtensa_pipe, 1)
+__SYSCALL( 37, sys_pipe, 1)
 #define __NR_unlink 				 38
 __SYSCALL( 38, sys_unlink, 1)
 #define __NR_rmdir 				 39
diff -puN arch/xtensa/kernel/syscall.c~xtensa-use-generic-sys_pipe arch/xtensa/kernel/syscall.c
--- a/arch/xtensa/kernel/syscall.c~xtensa-use-generic-sys_pipe
+++ a/arch/xtensa/kernel/syscall.c
@@ -39,24 +39,6 @@ syscall_t sys_call_table[__NR_syscall_co
 #include <asm/unistd.h>
 };
 
-/*
- * xtensa_pipe() is the normal C calling standard for creating a pipe. It's not
- * the way unix traditional does this, though.
- */
-
-asmlinkage long xtensa_pipe(int __user *userfds)
-{
-	int fd[2];
-	int error;
-
-	error = do_pipe_flags(fd, 0);
-	if (!error) {
-		if (copy_to_user(userfds, fd, 2 * sizeof(int)))
-			error = -EFAULT;
-	}
-	return error;
-}
