From: akpm@linux-foundation.org
Subject: - flag-parameters-pipe.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:27:32 -0700
Message-ID: <200807242327.m6ONRW6H011169__10836.5883738317$1216942272$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756765AbYGXX3k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drepper@redhat.com, davidel@xmailserver.org, linux-arch@vger.kernel.org, mtk.manpages@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     flag parameters: pipe
has been removed from the -mm tree.  Its filename was
     flag-parameters-pipe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flag parameters: pipe
From: Ulrich Drepper <drepper@redhat.com>

This patch introduces the new syscall pipe2 which is like pipe but it also
takes an additional parameter which takes a flag value.  This patch implements
the handling of O_CLOEXEC for the flag.  I did not add support for the new
syscall for the architectures which have a special sys_pipe implementation.  I
think the maintainers of those archs have the chance to go with the unified
implementation but that's up to them.

The implementation introduces do_pipe_flags.  I did that instead of changing
all callers of do_pipe because some of the callers are written in assembler. 
I would probably screw up changing the assembly code.  To avoid breaking code
do_pipe is now a small wrapper around do_pipe_flags.  Once all callers are
changed over to do_pipe_flags the old do_pipe function can be removed.

The following test must be adjusted for architectures other than x86 and
x86-64 and in case the syscall numbers changed.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>

#ifndef __NR_pipe2
# ifdef __x86_64__
#  define __NR_pipe2 293
# elif defined __i386__
#  define __NR_pipe2 331
# else
#  error "need __NR_pipe2"
# endif
#endif

int
main (void)
{
  int fd[2];
  if (syscall (__NR_pipe2, fd, 0) != 0)
    {
      puts ("pipe2(0) failed");
      return 1;
    }
  for (int i = 0; i < 2; ++i)
    {
      int coe = fcntl (fd[i], F_GETFD);
      if (coe == -1)
        {
          puts ("fcntl failed");
          return 1;
        }
      if (coe & FD_CLOEXEC)
        {
          printf ("pipe2(0) set close-on-exit for fd[%d]\n", i);
          return 1;
        }
    }
  close (fd[0]);
  close (fd[1]);

  if (syscall (__NR_pipe2, fd, O_CLOEXEC) != 0)
    {
      puts ("pipe2(O_CLOEXEC) failed");
      return 1;
    }
  for (int i = 0; i < 2; ++i)
    {
      int coe = fcntl (fd[i], F_GETFD);
      if (coe == -1)
        {
          puts ("fcntl failed");
          return 1;
        }
      if ((coe & FD_CLOEXEC) == 0)
        {
          printf ("pipe2(O_CLOEXEC) does not set close-on-exit for fd[%d]\n", i);
          return 1;
        }
    }
  close (fd[0]);
  close (fd[1]);

  puts ("OK");

  return 0;
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/ia32/sys_ia32.c          |    2 +-
 arch/ia64/kernel/sys_ia64.c        |    2 +-
 arch/mips/kernel/syscall.c         |    2 +-
 arch/parisc/hpux/sys_hpux.c        |    2 +-
 arch/sh/kernel/sys_sh32.c          |    2 +-
 arch/sparc/kernel/sys_sparc.c      |    2 +-
 arch/sparc64/kernel/sys_sparc.c    |    2 +-
 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/ia32/sys_ia32.c           |    2 +-
 arch/x86/kernel/syscall_table_32.S |    1 +
 arch/xtensa/kernel/syscall.c       |    2 +-
 fs/pipe.c                          |   23 ++++++++++++++++++-----
 include/asm-x86/unistd_32.h        |    1 +
 include/asm-x86/unistd_64.h        |    2 ++
 include/linux/fs.h                 |    1 +
 15 files changed, 33 insertions(+), 14 deletions(-)

diff -puN arch/ia64/ia32/sys_ia32.c~flag-parameters-pipe arch/ia64/ia32/sys_ia32.c
--- a/arch/ia64/ia32/sys_ia32.c~flag-parameters-pipe
+++ a/arch/ia64/ia32/sys_ia32.c
@@ -1139,7 +1139,7 @@ sys32_pipe (int __user *fd)
 	int retval;
 	int fds[2];
 
-	retval = do_pipe(fds);
+	retval = do_pipe_flags(fds, 0);
 	if (retval)
 		goto out;
 	if (copy_to_user(fd, fds, sizeof(fds)))
diff -puN arch/ia64/kernel/sys_ia64.c~flag-parameters-pipe arch/ia64/kernel/sys_ia64.c
--- a/arch/ia64/kernel/sys_ia64.c~flag-parameters-pipe
+++ a/arch/ia64/kernel/sys_ia64.c
@@ -160,7 +160,7 @@ sys_pipe (void)
 	int fd[2];
 	int retval;
 
-	retval = do_pipe(fd);
+	retval = do_pipe_flags(fd, 0);
 	if (retval)
 		goto out;
 	retval = fd[0];
diff -puN arch/mips/kernel/syscall.c~flag-parameters-pipe arch/mips/kernel/syscall.c
--- a/arch/mips/kernel/syscall.c~flag-parameters-pipe
+++ a/arch/mips/kernel/syscall.c
@@ -52,7 +52,7 @@ asmlinkage int sysm_pipe(nabi_no_regargs
 	int fd[2];
 	int error, res;
 
-	error = do_pipe(fd);
+	error = do_pipe_flags(fd, 0);
 	if (error) {
 		res = error;
 		goto out;
diff -puN arch/parisc/hpux/sys_hpux.c~flag-parameters-pipe arch/parisc/hpux/sys_hpux.c
--- a/arch/parisc/hpux/sys_hpux.c~flag-parameters-pipe
+++ a/arch/parisc/hpux/sys_hpux.c
@@ -448,7 +448,7 @@ int hpux_pipe(int *kstack_fildes)
 	int error;
 
 	lock_kernel();
-	error = do_pipe(kstack_fildes);
+	error = do_pipe_flags(kstack_fildes, 0);
 	unlock_kernel();
 	return error;
 }
diff -puN arch/sh/kernel/sys_sh32.c~flag-parameters-pipe arch/sh/kernel/sys_sh32.c
--- a/arch/sh/kernel/sys_sh32.c~flag-parameters-pipe
+++ a/arch/sh/kernel/sys_sh32.c
@@ -29,7 +29,7 @@ asmlinkage int sys_pipe(unsigned long r4
 	int fd[2];
 	int error;
 
-	error = do_pipe(fd);
+	error = do_pipe_flags(fd, 0);
 	if (!error) {
 		regs->regs[1] = fd[1];
 		return fd[0];
diff -puN arch/sparc/kernel/sys_sparc.c~flag-parameters-pipe arch/sparc/kernel/sys_sparc.c
--- a/arch/sparc/kernel/sys_sparc.c~flag-parameters-pipe
+++ a/arch/sparc/kernel/sys_sparc.c
@@ -97,7 +97,7 @@ asmlinkage int sparc_pipe(struct pt_regs
 	int fd[2];
 	int error;
 
-	error = do_pipe(fd);
+	error = do_pipe_flags(fd, 0);
 	if (error)
 		goto out;
 	regs->u_regs[UREG_I1] = fd[1];
diff -puN arch/sparc64/kernel/sys_sparc.c~flag-parameters-pipe arch/sparc64/kernel/sys_sparc.c
--- a/arch/sparc64/kernel/sys_sparc.c~flag-parameters-pipe
+++ a/arch/sparc64/kernel/sys_sparc.c
@@ -418,7 +418,7 @@ asmlinkage long sparc_pipe(struct pt_reg
 	int fd[2];
 	int error;
 
-	error = do_pipe(fd);
+	error = do_pipe_flags(fd, 0);
 	if (error)
 		goto out;
 	regs->u_regs[UREG_I1] = fd[1];
diff -puN arch/x86/ia32/ia32entry.S~flag-parameters-pipe arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~flag-parameters-pipe
+++ a/arch/x86/ia32/ia32entry.S
@@ -747,4 +747,5 @@ ia32_sys_call_table:
 	.quad sys_eventfd2
 	.quad sys_epoll_create2
 	.quad sys_dup3			/* 330 */
+	.quad sys_pipe2
 ia32_syscall_end:
diff -puN arch/x86/ia32/sys_ia32.c~flag-parameters-pipe arch/x86/ia32/sys_ia32.c
--- a/arch/x86/ia32/sys_ia32.c~flag-parameters-pipe
+++ a/arch/x86/ia32/sys_ia32.c
@@ -238,7 +238,7 @@ asmlinkage long sys32_pipe(int __user *f
 	int retval;
 	int fds[2];
 
-	retval = do_pipe(fds);
+	retval = do_pipe_flags(fds, 0);
 	if (retval)
 		goto out;
 	if (copy_to_user(fd, fds, sizeof(fds)))
diff -puN arch/x86/kernel/syscall_table_32.S~flag-parameters-pipe arch/x86/kernel/syscall_table_32.S
--- a/arch/x86/kernel/syscall_table_32.S~flag-parameters-pipe
+++ a/arch/x86/kernel/syscall_table_32.S
@@ -330,3 +330,4 @@ ENTRY(sys_call_table)
 	.long sys_eventfd2
 	.long sys_epoll_create2
 	.long sys_dup3			/* 330 */
+	.long sys_pipe2
diff -puN arch/xtensa/kernel/syscall.c~flag-parameters-pipe arch/xtensa/kernel/syscall.c
--- a/arch/xtensa/kernel/syscall.c~flag-parameters-pipe
+++ a/arch/xtensa/kernel/syscall.c
@@ -49,7 +49,7 @@ asmlinkage long xtensa_pipe(int __user *
 	int fd[2];
 	int error;
 
-	error = do_pipe(fd);
+	error = do_pipe_flags(fd, 0);
 	if (!error) {
 		if (copy_to_user(userfds, fd, 2 * sizeof(int)))
 			error = -EFAULT;
diff -puN fs/pipe.c~flag-parameters-pipe fs/pipe.c
--- a/fs/pipe.c~flag-parameters-pipe
+++ a/fs/pipe.c
@@ -1027,12 +1027,15 @@ struct file *create_read_pipe(struct fil
 	return f;
 }
 
-int do_pipe(int *fd)
+int do_pipe_flags(int *fd, int flags)
 {
 	struct file *fw, *fr;
 	int error;
 	int fdw, fdr;
 
+	if (flags & ~O_CLOEXEC)
+		return -EINVAL;
+
 	fw = create_write_pipe();
 	if (IS_ERR(fw))
 		return PTR_ERR(fw);
@@ -1041,12 +1044,12 @@ int do_pipe(int *fd)
 	if (IS_ERR(fr))
 		goto err_write_pipe;
 
-	error = get_unused_fd();
+	error = get_unused_fd_flags(flags);
 	if (error < 0)
 		goto err_read_pipe;
 	fdr = error;
 
-	error = get_unused_fd();
+	error = get_unused_fd_flags(flags);
 	if (error < 0)
 		goto err_fdr;
 	fdw = error;
@@ -1074,16 +1077,21 @@ int do_pipe(int *fd)
 	return error;
 }
 
+int do_pipe(int *fd)
+{
+	return do_pipe_flags(fd, 0);
+}
+
 /*
  * sys_pipe() is the normal C calling standard for creating
  * a pipe. It's not the way Unix traditionally does this, though.
  */
-asmlinkage long __weak sys_pipe(int __user *fildes)
+asmlinkage long __weak sys_pipe2(int __user *fildes, int flags)
 {
 	int fd[2];
 	int error;
 
-	error = do_pipe(fd);
+	error = do_pipe_flags(fd, flags);
 	if (!error) {
 		if (copy_to_user(fildes, fd, sizeof(fd))) {
 			sys_close(fd[0]);
@@ -1094,6 +1102,11 @@ asmlinkage long __weak sys_pipe(int __us
 	return error;
 }
 
+asmlinkage long __weak sys_pipe(int __user *fildes)
+{
+	return sys_pipe2(fildes, 0);
+}
+
 /*
  * pipefs should _never_ be mounted by userland - too much of security hassle,
  * no real gain from having the whole whorehouse mounted. So we don't need
diff -puN include/asm-x86/unistd_32.h~flag-parameters-pipe include/asm-x86/unistd_32.h
--- a/include/asm-x86/unistd_32.h~flag-parameters-pipe
+++ a/include/asm-x86/unistd_32.h
@@ -336,6 +336,7 @@
 #define __NR_eventfd2		328
 #define __NR_epoll_create2	329
 #define __NR_dup3		330
+#define __NR_pipe2		331
 
 #ifdef __KERNEL__
 
diff -puN include/asm-x86/unistd_64.h~flag-parameters-pipe include/asm-x86/unistd_64.h
--- a/include/asm-x86/unistd_64.h~flag-parameters-pipe
+++ a/include/asm-x86/unistd_64.h
@@ -649,6 +649,8 @@ __SYSCALL(__NR_eventfd2, sys_eventfd2)
 __SYSCALL(__NR_epoll_create2, sys_epoll_create2)
 #define __NR_dup3				292
 __SYSCALL(__NR_dup3, sys_dup3)
+#define __NR_pipe2				293
+__SYSCALL(__NR_pipe2, sys_pipe2)
 
 
 #ifndef __NO_STUBS
diff -puN include/linux/fs.h~flag-parameters-pipe include/linux/fs.h
--- a/include/linux/fs.h~flag-parameters-pipe
+++ a/include/linux/fs.h
@@ -1777,6 +1777,7 @@ static inline void allow_write_access(st
 		atomic_inc(&file->f_path.dentry->d_inode->i_writecount);
 }
 extern int do_pipe(int *);
+extern int do_pipe_flags(int *, int);
 extern struct file *create_read_pipe(struct file *f);
 extern struct file *create_write_pipe(void);
 extern void free_write_pipe(struct file *);
_

Patches currently in -mm which might be from drepper@redhat.com are

origin.patch
linux-next.patch

