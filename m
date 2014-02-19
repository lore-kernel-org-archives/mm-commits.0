From: akpm@linux-foundation.org
Subject: + sh-push-extra-copy-of-r0-r2-for-syscall-parameters.patch added
 to -mm tree
Date: Wed, 19 Feb 2014 13:01:56 -0800
Message-ID: <53051bc4.9XRiuEdzBJVjcebi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289AbaBSVB5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Feb 2014 16:01:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paul.mundt@gmail.com, koorogi@koorogi.info

Subject: + sh-push-extra-copy-of-r0-r2-for-syscall-parameters.patch added to -mm tree
To: koorogi@koorogi.info,paul.mundt@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 19 Feb 2014 13:01:56 -0800


The patch titled
     Subject: sh: push extra copy of r0-r2 for syscall parameters
has been added to the -mm tree.  Its filename is
     sh-push-extra-copy-of-r0-r2-for-syscall-parameters.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-push-extra-copy-of-r0-r2-for-syscall-parameters.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-push-extra-copy-of-r0-r2-for-syscall-parameters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bobby Bingham <koorogi@koorogi.info>
Subject: sh: push extra copy of r0-r2 for syscall parameters

When invoking syscall handlers on sh32, the saved userspace registers are
at the top of the stack.  This seems to have been intentional, as it is an
easy way to pass r0, r1, ...  to the handler as parameters 5, 6, ...

It causes problems, however, because the compiler is allowed to generate
code for a function which clobbers that function's own parameters.  For
example, gcc generates the following code for clone:

    <SyS_clone>:
        mov.l   8c020714 <SyS_clone+0xc>,r1  ! 8c020540 <do_fork>
        mov.l   r7,@r15
        mov     r6,r7
        jmp     @r1
        mov     #0,r6
        nop
        .word 0x0540
        .word 0x8c02

The `mov.l r7,@r15` clobbers the saved value of r0 passed from userspace. 
For most system calls, this might not be a problem, because we'll be
overwriting r0 with the return value anyway.  But in the case of clone,
copy_thread will need the original value of r0 if the CLONE_SETTLS flag
was specified.

The first patch in this series fixes this issue for system calls by
pushing to the stack and extra copy of r0-r2 before invoking the handler. 
We discard this copy before restoring the userspace registers, so it is
not a problem if they are clobbered.

Exception handlers also receive the userspace register values in a similar
manner, and may hit the same problem.  The second patch removes the
do_fpu_error handler, which looks susceptible to this problem and which,
as far as I can tell, has not been used in some time.  The third patch
addresses other exception handlers.


This patch (of 3):

The userspace registers are stored at the top of the stack when the
syscall handler is invoked, which allows r0-r2 to act as parameters 5-7. 
Parameters passed on the stack may be clobbered by the syscall handler. 
The solution is to push an extra copy of the registers which might be used
as syscall parameters to the stack, so that the authoritative set of saved
register values does not get clobbered.

A few system call handlers are also updated to get the userspace registers
using current_pt_regs() instead of from the stack.

Signed-off-by: Bobby Bingham <koorogi@koorogi.info>
Cc: Paul Mundt <paul.mundt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/syscalls_32.h |   12 +++---------
 arch/sh/kernel/entry-common.S     |   15 +++++++++++----
 arch/sh/kernel/signal_32.c        |   12 ++++--------
 arch/sh/kernel/sys_sh32.c         |    7 ++-----
 4 files changed, 20 insertions(+), 26 deletions(-)

diff -puN arch/sh/include/asm/syscalls_32.h~sh-push-extra-copy-of-r0-r2-for-syscall-parameters arch/sh/include/asm/syscalls_32.h
--- a/arch/sh/include/asm/syscalls_32.h~sh-push-extra-copy-of-r0-r2-for-syscall-parameters
+++ a/arch/sh/include/asm/syscalls_32.h
@@ -9,15 +9,9 @@
 
 struct pt_regs;
 
-asmlinkage int sys_sigreturn(unsigned long r4, unsigned long r5,
-			     unsigned long r6, unsigned long r7,
-			     struct pt_regs __regs);
-asmlinkage int sys_rt_sigreturn(unsigned long r4, unsigned long r5,
-				unsigned long r6, unsigned long r7,
-				struct pt_regs __regs);
-asmlinkage int sys_sh_pipe(unsigned long r4, unsigned long r5,
-			   unsigned long r6, unsigned long r7,
-			   struct pt_regs __regs);
+asmlinkage int sys_sigreturn(void);
+asmlinkage int sys_rt_sigreturn(void);
+asmlinkage int sys_sh_pipe(void);
 asmlinkage ssize_t sys_pread_wrapper(unsigned int fd, char __user *buf,
 				     size_t count, long dummy, loff_t pos);
 asmlinkage ssize_t sys_pwrite_wrapper(unsigned int fd, const char __user *buf,
diff -puN arch/sh/kernel/entry-common.S~sh-push-extra-copy-of-r0-r2-for-syscall-parameters arch/sh/kernel/entry-common.S
--- a/arch/sh/kernel/entry-common.S~sh-push-extra-copy-of-r0-r2-for-syscall-parameters
+++ a/arch/sh/kernel/entry-common.S
@@ -193,10 +193,10 @@ syscall_trace_entry:
 	!			Reload R0-R4 from kernel stack, where the
 	!   	    	    	parent may have modified them using
 	!   	    	    	ptrace(POKEUSR).  (Note that R0-R2 are
-	!   	    	    	used by the system call handler directly
-	!   	    	    	from the kernel stack anyway, so don't need
-	!   	    	    	to be reloaded here.)  This allows the parent
-	!   	    	    	to rewrite system calls and args on the fly.
+	!   	    	    	reloaded from the kernel stack by syscall_call
+	!   	    	    	below, so don't need to be reloaded here.)
+	!   	    	    	This allows the parent to rewrite system calls
+	!   	    	    	and args on the fly.
 	mov.l	@(OFF_R4,r15), r4   ! arg0
 	mov.l	@(OFF_R5,r15), r5
 	mov.l	@(OFF_R6,r15), r6
@@ -357,8 +357,15 @@ syscall_call:
 	mov.l	3f, r8		! Load the address of sys_call_table
 	add	r8, r3
 	mov.l	@r3, r8
+	mov.l	@(OFF_R2,r15), r2
+	mov.l	@(OFF_R1,r15), r1
+	mov.l	@(OFF_R0,r15), r0
+	mov.l	r2, @-r15
+	mov.l	r1, @-r15
+	mov.l	r0, @-r15
 	jsr	@r8	    	! jump to specific syscall handler
 	 nop
+	add	#12, r15
 	mov.l	@(OFF_R0,r15), r12		! save r0
 	mov.l	r0, @(OFF_R0,r15)		! save the return value
 	!
diff -puN arch/sh/kernel/signal_32.c~sh-push-extra-copy-of-r0-r2-for-syscall-parameters arch/sh/kernel/signal_32.c
--- a/arch/sh/kernel/signal_32.c~sh-push-extra-copy-of-r0-r2-for-syscall-parameters
+++ a/arch/sh/kernel/signal_32.c
@@ -148,11 +148,9 @@ restore_sigcontext(struct pt_regs *regs,
 	return err;
 }
 
-asmlinkage int sys_sigreturn(unsigned long r4, unsigned long r5,
-			     unsigned long r6, unsigned long r7,
-			     struct pt_regs __regs)
+asmlinkage int sys_sigreturn(void)
 {
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
+	struct pt_regs *regs = current_pt_regs();
 	struct sigframe __user *frame = (struct sigframe __user *)regs->regs[15];
 	sigset_t set;
 	int r0;
@@ -180,11 +178,9 @@ badframe:
 	return 0;
 }
 
-asmlinkage int sys_rt_sigreturn(unsigned long r4, unsigned long r5,
-				unsigned long r6, unsigned long r7,
-				struct pt_regs __regs)
+asmlinkage int sys_rt_sigreturn(void)
 {
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
+	struct pt_regs *regs = current_pt_regs();
 	struct rt_sigframe __user *frame = (struct rt_sigframe __user *)regs->regs[15];
 	sigset_t set;
 	int r0;
diff -puN arch/sh/kernel/sys_sh32.c~sh-push-extra-copy-of-r0-r2-for-syscall-parameters arch/sh/kernel/sys_sh32.c
--- a/arch/sh/kernel/sys_sh32.c~sh-push-extra-copy-of-r0-r2-for-syscall-parameters
+++ a/arch/sh/kernel/sys_sh32.c
@@ -21,17 +21,14 @@
  * sys_pipe() is the normal C calling standard for creating
  * a pipe. It's not the way Unix traditionally does this, though.
  */
-asmlinkage int sys_sh_pipe(unsigned long r4, unsigned long r5,
-	unsigned long r6, unsigned long r7,
-	struct pt_regs __regs)
+asmlinkage int sys_sh_pipe(void)
 {
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
 	int fd[2];
 	int error;
 
 	error = do_pipe_flags(fd, 0);
 	if (!error) {
-		regs->regs[1] = fd[1];
+		current_pt_regs()->regs[1] = fd[1];
 		return fd[0];
 	}
 	return error;
_

Patches currently in -mm which might be from koorogi@koorogi.info are

sh-push-extra-copy-of-r0-r2-for-syscall-parameters.patch
sh-remove-unused-do_fpu_error.patch
sh-dont-pass-saved-userspace-state-to-exception-handlers.patch

