From: akpm@linux-foundation.org
Subject: + uml-floating-point-signal-delivery-fixes.patch added to -mm tree
Date: Thu, 23 Aug 2007 17:09:57 -0700
Message-ID: <200708240009.l7O09vvu001525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59723 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933776AbXHXAKb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 20:10:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: floating point signal delivery fixes
has been added to the -mm tree.  Its filename is
     uml-floating-point-signal-delivery-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: floating point signal delivery fixes
From: Jeff Dike <jdike@addtoit.com>

Handle floating point state in across signals correctly.  UML/i386 needs to
know whether the host does PTRACE_[GS]ETFPXREGS, so an arch_init_registers
hook is added, which on x86_64 does nothing.

UML doesn't save and restore floating point registers on kernel entry and
exit, so they need to be copied between the host process and the sigcontext. 
save_fpx_registers and restore_fpx_registers are added for this purpose. 
save_fp_registers and restore_fp_registers already exist.

There was a bunch of floating point state conversion code in
arch/um/sys-i386/ptrace.c which isn't needed there, but is needed in signal.c,
so it is moved over.

The i386 code now distinguishes between fp and fpx state and handles them
correctly.  The x86_64 code just needs to copy state as-is between the host
process and the stack.  There are also some fixes there to pass the correct
address of the floating point state around.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/registers.h            |    2 
 arch/um/include/sysdep-i386/ptrace.h   |    2 
 arch/um/include/sysdep-x86_64/ptrace.h |    4 
 arch/um/os-Linux/registers.c           |    2 
 arch/um/os-Linux/sys-i386/registers.c  |   35 +++
 arch/um/sys-i386/ptrace.c              |   79 --------
 arch/um/sys-i386/signal.c              |  221 +++++++++++++++++++++--
 arch/um/sys-x86_64/signal.c            |   53 ++++-
 8 files changed, 283 insertions(+), 115 deletions(-)

diff -puN arch/um/include/registers.h~uml-floating-point-signal-delivery-fixes arch/um/include/registers.h
--- a/arch/um/include/registers.h~uml-floating-point-signal-delivery-fixes
+++ a/arch/um/include/registers.h
@@ -12,6 +12,8 @@
 extern void init_thread_registers(struct uml_pt_regs *to);
 extern int save_fp_registers(int pid, unsigned long *fp_regs);
 extern int restore_fp_registers(int pid, unsigned long *fp_regs);
+extern int save_fpx_registers(int pid, unsigned long *fp_regs);
+extern int restore_fpx_registers(int pid, unsigned long *fp_regs);
 extern void save_registers(int pid, struct uml_pt_regs *regs);
 extern void restore_registers(int pid, struct uml_pt_regs *regs);
 extern void init_registers(int pid);
diff -puN arch/um/include/sysdep-i386/ptrace.h~uml-floating-point-signal-delivery-fixes arch/um/include/sysdep-i386/ptrace.h
--- a/arch/um/include/sysdep-i386/ptrace.h~uml-floating-point-signal-delivery-fixes
+++ a/arch/um/include/sysdep-i386/ptrace.h
@@ -168,4 +168,6 @@ struct syscall_args {
 
 #define UPT_FAULTINFO(r) (&(r)->faultinfo)
 
+extern void arch_init_registers(int pid);
+
 #endif
diff -puN arch/um/include/sysdep-x86_64/ptrace.h~uml-floating-point-signal-delivery-fixes arch/um/include/sysdep-x86_64/ptrace.h
--- a/arch/um/include/sysdep-x86_64/ptrace.h~uml-floating-point-signal-delivery-fixes
+++ a/arch/um/include/sysdep-x86_64/ptrace.h
@@ -234,4 +234,8 @@ struct syscall_args {
 
 #define UPT_FAULTINFO(r) (&(r)->faultinfo)
 
+static inline void arch_init_registers(int pid)
+{
+}
+
 #endif
diff -puN arch/um/os-Linux/registers.c~uml-floating-point-signal-delivery-fixes arch/um/os-Linux/registers.c
--- a/arch/um/os-Linux/registers.c~uml-floating-point-signal-delivery-fixes
+++ a/arch/um/os-Linux/registers.c
@@ -47,6 +47,8 @@ void init_registers(int pid)
 	if (err)
 		panic("check_ptrace : PTRACE_GETREGS failed, errno = %d",
 		      errno);
+
+	arch_init_registers(pid);
 }
 
 void get_safe_registers(unsigned long *regs)
diff -puN arch/um/os-Linux/sys-i386/registers.c~uml-floating-point-signal-delivery-fixes arch/um/os-Linux/sys-i386/registers.c
--- a/arch/um/os-Linux/sys-i386/registers.c~uml-floating-point-signal-delivery-fixes
+++ a/arch/um/os-Linux/sys-i386/registers.c
@@ -8,9 +8,6 @@
 #include "longjmp.h"
 #include "user.h"
 
-/* XXX These need to use [GS]ETFPXREGS and copy_sc_{to,from}_user_skas needs
- * to pass in a sufficiently large buffer
- */
 int save_fp_registers(int pid, unsigned long *fp_regs)
 {
 	if(ptrace(PTRACE_GETFPREGS, pid, 0, fp_regs) < 0)
@@ -25,6 +22,20 @@ int restore_fp_registers(int pid, unsign
 	return 0;
 }
 
+int save_fpx_registers(int pid, unsigned long *fp_regs)
+{
+	if(ptrace(PTRACE_GETFPXREGS, pid, 0, fp_regs) < 0)
+		return -errno;
+	return 0;
+}
+
+int restore_fpx_registers(int pid, unsigned long *fp_regs)
+{
+	if(ptrace(PTRACE_SETFPXREGS, pid, 0, fp_regs) < 0)
+		return -errno;
+	return 0;
+}
+
 unsigned long get_thread_reg(int reg, jmp_buf *buf)
 {
 	switch(reg){
@@ -36,3 +47,21 @@ unsigned long get_thread_reg(int reg, jm
 		return 0;
 	}
 }
+
+int have_fpx_regs = 1;
+
+void arch_init_registers(int pid)
+{
+	unsigned long fpx_regs[HOST_XFP_SIZE];
+	int err;
+
+	err = ptrace(PTRACE_GETFPXREGS, pid, 0, fpx_regs);
+	if(!err)
+		return;
+
+	if(errno != EIO)
+		panic("check_ptrace : PTRACE_GETFPXREGS failed, errno = %d",
+		      errno);
+
+	have_fpx_regs = 0;
+}
diff -puN arch/um/sys-i386/ptrace.c~uml-floating-point-signal-delivery-fixes arch/um/sys-i386/ptrace.c
--- a/arch/um/sys-i386/ptrace.c~uml-floating-point-signal-delivery-fixes
+++ a/arch/um/sys-i386/ptrace.c
@@ -144,85 +144,6 @@ int peek_user(struct task_struct *child,
 	return put_user(tmp, (unsigned long __user *) data);
 }
 
-struct i387_fxsave_struct {
-	unsigned short	cwd;
-	unsigned short	swd;
-	unsigned short	twd;
-	unsigned short	fop;
-	long	fip;
-	long	fcs;
-	long	foo;
-	long	fos;
-	long	mxcsr;
-	long	reserved;
-	long	st_space[32];	/* 8*16 bytes for each FP-reg = 128 bytes */
-	long	xmm_space[32];	/* 8*16 bytes for each XMM-reg = 128 bytes */
-	long	padding[56];
-};
-
-/*
- * FPU tag word conversions.
- */
-
-static inline unsigned short twd_i387_to_fxsr( unsigned short twd )
-{
-	unsigned int tmp; /* to avoid 16 bit prefixes in the code */
-
-	/* Transform each pair of bits into 01 (valid) or 00 (empty) */
-	tmp = ~twd;
-	tmp = (tmp | (tmp>>1)) & 0x5555; /* 0V0V0V0V0V0V0V0V */
-	/* and move the valid bits to the lower byte. */
-	tmp = (tmp | (tmp >> 1)) & 0x3333; /* 00VV00VV00VV00VV */
-	tmp = (tmp | (tmp >> 2)) & 0x0f0f; /* 0000VVVV0000VVVV */
-	tmp = (tmp | (tmp >> 4)) & 0x00ff; /* 00000000VVVVVVVV */
-	return tmp;
-}
-
-static inline unsigned long twd_fxsr_to_i387( struct i387_fxsave_struct *fxsave )
-{
-	struct _fpxreg *st = NULL;
-	unsigned long twd = (unsigned long) fxsave->twd;
-	unsigned long tag;
-	unsigned long ret = 0xffff0000;
-	int i;
-
-#define FPREG_ADDR(f, n)	((char *)&(f)->st_space + (n) * 16);
-
-	for ( i = 0 ; i < 8 ; i++ ) {
-		if ( twd & 0x1 ) {
-			st = (struct _fpxreg *) FPREG_ADDR( fxsave, i );
-
-			switch ( st->exponent & 0x7fff ) {
-			case 0x7fff:
-				tag = 2;		/* Special */
-				break;
-			case 0x0000:
-				if ( !st->significand[0] &&
-				     !st->significand[1] &&
-				     !st->significand[2] &&
-				     !st->significand[3] ) {
-					tag = 1;	/* Zero */
-				} else {
-					tag = 2;	/* Special */
-				}
-				break;
-			default:
-				if ( st->significand[3] & 0x8000 ) {
-					tag = 0;	/* Valid */
-				} else {
-					tag = 2;	/* Special */
-				}
-				break;
-			}
-		} else {
-			tag = 3;			/* Empty */
-		}
-		ret |= (tag << (2 * i));
-		twd = twd >> 1;
-	}
-	return ret;
-}
-
 static inline int convert_fxsr_to_user(struct _fpstate __user *buf,
 				       struct pt_regs *regs)
 {
diff -puN arch/um/sys-i386/signal.c~uml-floating-point-signal-delivery-fixes arch/um/sys-i386/signal.c
--- a/arch/um/sys-i386/signal.c~uml-floating-point-signal-delivery-fixes
+++ a/arch/um/sys-i386/signal.c
@@ -32,25 +32,186 @@ void copy_sc(struct uml_pt_regs *regs, v
 	REGS_SS(regs->gp) = sc->ss;
 }
 
+/*
+ * FPU tag word conversions.
+ */
+
+static inline unsigned short twd_i387_to_fxsr(unsigned short twd)
+{
+	unsigned int tmp; /* to avoid 16 bit prefixes in the code */
+
+	/* Transform each pair of bits into 01 (valid) or 00 (empty) */
+	tmp = ~twd;
+	tmp = (tmp | (tmp>>1)) & 0x5555; /* 0V0V0V0V0V0V0V0V */
+	/* and move the valid bits to the lower byte. */
+	tmp = (tmp | (tmp >> 1)) & 0x3333; /* 00VV00VV00VV00VV */
+	tmp = (tmp | (tmp >> 2)) & 0x0f0f; /* 0000VVVV0000VVVV */
+	tmp = (tmp | (tmp >> 4)) & 0x00ff; /* 00000000VVVVVVVV */
+	return tmp;
+}
+
+static inline unsigned long twd_fxsr_to_i387(struct user_fxsr_struct *fxsave)
+{
+	struct _fpxreg *st = NULL;
+	unsigned long twd = (unsigned long) fxsave->twd;
+	unsigned long tag;
+	unsigned long ret = 0xffff0000;
+	int i;
+
+#define FPREG_ADDR(f, n)	((char *)&(f)->st_space + (n) * 16);
+
+	for (i = 0; i < 8; i++) {
+		if (twd & 0x1) {
+			st = (struct _fpxreg *) FPREG_ADDR(fxsave, i);
+
+			switch (st->exponent & 0x7fff) {
+			case 0x7fff:
+				tag = 2;		/* Special */
+				break;
+			case 0x0000:
+				if ( !st->significand[0] &&
+				     !st->significand[1] &&
+				     !st->significand[2] &&
+				     !st->significand[3] ) {
+					tag = 1;	/* Zero */
+				} else {
+					tag = 2;	/* Special */
+				}
+				break;
+			default:
+				if (st->significand[3] & 0x8000) {
+					tag = 0;	/* Valid */
+				} else {
+					tag = 2;	/* Special */
+				}
+				break;
+			}
+		} else {
+			tag = 3;			/* Empty */
+		}
+		ret |= (tag << (2 * i));
+		twd = twd >> 1;
+	}
+	return ret;
+}
+
+static int convert_fxsr_to_user(struct _fpstate __user *buf,
+				struct user_fxsr_struct *fxsave)
+{
+	unsigned long env[7];
+	struct _fpreg __user *to;
+	struct _fpxreg *from;
+	int i;
+
+	env[0] = (unsigned long)fxsave->cwd | 0xffff0000ul;
+	env[1] = (unsigned long)fxsave->swd | 0xffff0000ul;
+	env[2] = twd_fxsr_to_i387(fxsave);
+	env[3] = fxsave->fip;
+	env[4] = fxsave->fcs | ((unsigned long)fxsave->fop << 16);
+	env[5] = fxsave->foo;
+	env[6] = fxsave->fos;
+
+	if (__copy_to_user(buf, env, 7 * sizeof(unsigned long)))
+		return 1;
+
+	to = &buf->_st[0];
+	from = (struct _fpxreg *) &fxsave->st_space[0];
+	for (i = 0; i < 8; i++, to++, from++) {
+		unsigned long __user *t = (unsigned long __user *)to;
+		unsigned long *f = (unsigned long *)from;
+
+		if (__put_user(*f, t) ||
+				__put_user(*(f + 1), t + 1) ||
+				__put_user(from->exponent, &to->exponent))
+			return 1;
+	}
+	return 0;
+}
+
+static int convert_fxsr_from_user(struct user_fxsr_struct *fxsave,
+				  struct _fpstate __user *buf)
+{
+	unsigned long env[7];
+	struct _fpxreg *to;
+	struct _fpreg __user *from;
+	int i;
+
+	if (copy_from_user( env, buf, 7 * sizeof(long)))
+		return 1;
+
+	fxsave->cwd = (unsigned short)(env[0] & 0xffff);
+	fxsave->swd = (unsigned short)(env[1] & 0xffff);
+	fxsave->twd = twd_i387_to_fxsr((unsigned short)(env[2] & 0xffff));
+	fxsave->fip = env[3];
+	fxsave->fop = (unsigned short)((env[4] & 0xffff0000ul) >> 16);
+	fxsave->fcs = (env[4] & 0xffff);
+	fxsave->foo = env[5];
+	fxsave->fos = env[6];
+
+	to = (struct _fpxreg *) &fxsave->st_space[0];
+	from = &buf->_st[0];
+	for (i = 0; i < 8; i++, to++, from++) {
+		unsigned long *t = (unsigned long *)to;
+		unsigned long __user *f = (unsigned long __user *)from;
+
+		if (__get_user(*t, f) ||
+		    __get_user(*(t + 1), f + 1) ||
+		    __get_user(to->exponent, &from->exponent))
+			return 1;
+	}
+	return 0;
+}
+
+extern int have_fpx_regs;
+
 static int copy_sc_from_user(struct pt_regs *regs,
 			     struct sigcontext __user *from)
 {
- 	struct sigcontext sc;
-	unsigned long fpregs[HOST_FP_SIZE];
+	struct sigcontext sc;
 	int err;
 
 	err = copy_from_user(&sc, from, sizeof(sc));
-	err |= copy_from_user(fpregs, sc.fpstate, sizeof(fpregs));
 	if (err)
 		return err;
 
 	copy_sc(&regs->regs, &sc);
+	if (have_fpx_regs) {
+		struct user_fxsr_struct fpx;
 
-	err = restore_fp_registers(userspace_pid[0], fpregs);
-	if (err < 0) {
-	  	printk(KERN_ERR "copy_sc_from_user_skas - PTRACE_SETFPREGS "
-		       "failed, errno = %d\n", -err);
-		return err;
+		err = copy_from_user(&fpx, &sc.fpstate->_fxsr_env[0],
+				     sizeof(struct user_fxsr_struct));
+		if (err)
+			return 1;
+
+		err = convert_fxsr_from_user(&fpx, sc.fpstate);
+		if (err)
+			return 1;
+
+		err = restore_fpx_registers(userspace_pid[current_thread->cpu],
+					    (unsigned long *) &fpx);
+		if (err < 0) {
+			printk(KERN_ERR "copy_sc_from_user - "
+			       "restore_fpx_registers failed, errno = %d\n",
+			       -err);
+			return 1;
+		}
+	}
+	else {
+		struct user_i387_struct fp;
+
+		err = copy_from_user(&fp, sc.fpstate,
+				     sizeof(struct user_i387_struct));
+		if (err)
+			return 1;
+
+		err = restore_fp_registers(userspace_pid[current_thread->cpu],
+					   (unsigned long *) &fp);
+		if (err < 0) {
+			printk(KERN_ERR "copy_sc_from_user - "
+			       "restore_fp_registers failed, errno = %d\n",
+			       -err);
+			return 1;
+		}
 	}
 
 	return 0;
@@ -61,7 +222,6 @@ static int copy_sc_to_user(struct sigcon
 			   unsigned long sp)
 {
 	struct sigcontext sc;
-	unsigned long fpregs[HOST_FP_SIZE];
 	struct faultinfo * fi = &current->thread.arch.faultinfo;
 	int err;
 
@@ -86,20 +246,43 @@ static int copy_sc_to_user(struct sigcon
 	sc.err = fi->error_code;
 	sc.trapno = fi->trap_no;
 
-	err = save_fp_registers(userspace_pid[0], fpregs);
-	if (err < 0) {
-	  	printk(KERN_ERR "copy_sc_to_user_skas - PTRACE_GETFPREGS "
-		       "failed, errno = %d\n", err);
-		return 1;
-	}
 	to_fp = (to_fp ? to_fp : (struct _fpstate __user *) (to + 1));
 	sc.fpstate = to_fp;
 
-	if (err)
-	  	return err;
+	if (have_fpx_regs) {
+		struct user_fxsr_struct fpx;
+
+		err = save_fpx_registers(userspace_pid[current_thread->cpu],
+					 (unsigned long *) &fpx);
+		if (err < 0){
+			printk(KERN_ERR "copy_sc_to_user - save_fpx_registers "
+			       "failed, errno = %d\n", err);
+			return 1;
+		}
+
+		err = convert_fxsr_to_user(to_fp, &fpx);
+		if (err)
+			return 1;
+
+		err |= __put_user(fpx.swd, &to_fp->status);
+		err |= __put_user(X86_FXSR_MAGIC, &to_fp->magic);
+		if (err)
+			return 1;
+
+		if (copy_to_user(&to_fp->_fxsr_env[0], &fpx,
+				 sizeof(struct user_fxsr_struct)))
+			return 1;
+	}
+	else {
+		struct user_i387_struct fp;
+
+		err = save_fp_registers(userspace_pid[current_thread->cpu],
+					(unsigned long *) &fp);
+		if (copy_to_user(to_fp, &fp, sizeof(struct user_i387_struct)))
+			return 1;
+	}
 
-	return copy_to_user(to, &sc, sizeof(sc)) ||
-	       copy_to_user(to_fp, fpregs, sizeof(fpregs));
+	return copy_to_user(to, &sc, sizeof(sc));
 }
 
 static int copy_ucontext_to_user(struct ucontext __user *uc,
diff -puN arch/um/sys-x86_64/signal.c~uml-floating-point-signal-delivery-fixes arch/um/sys-x86_64/signal.c
--- a/arch/um/sys-x86_64/signal.c~uml-floating-point-signal-delivery-fixes
+++ a/arch/um/sys-x86_64/signal.c
@@ -42,8 +42,10 @@ void copy_sc(struct uml_pt_regs *regs, v
 }
 
 static int copy_sc_from_user(struct pt_regs *regs,
-			     struct sigcontext __user *from)
+			     struct sigcontext __user *from,
+			     struct _fpstate __user *fpp)
 {
+	struct user_i387_struct fp;
 	int err = 0;
 
 #define GETREG(regs, regno, sc, regname)				\
@@ -69,10 +71,25 @@ static int copy_sc_from_user(struct pt_r
 	err |= GETREG(regs, RIP, from, rip);
 	err |= GETREG(regs, EFLAGS, from, eflags);
 	err |= GETREG(regs, CS, from, cs);
+	if (err)
+		return 1;
 
 #undef GETREG
 
-	return err;
+	err = copy_from_user(&fp, fpp, sizeof(struct user_i387_struct));
+	if (err)
+		return 1;
+
+	err = restore_fp_registers(userspace_pid[current_thread->cpu],
+				   (unsigned long *) &fp);
+	if (err < 0) {
+		printk(KERN_ERR "copy_sc_from_user - "
+		       "restore_fp_registers failed, errno = %d\n",
+		       -err);
+		return 1;
+	}
+
+	return 0;
 }
 
 static int copy_sc_to_user(struct sigcontext __user *to,
@@ -80,6 +97,7 @@ static int copy_sc_to_user(struct sigcon
 			   unsigned long mask, unsigned long sp)
 {
 	struct faultinfo * fi = &current->thread.arch.faultinfo;
+	struct user_i387_struct fp;
 	int err = 0;
 
 	err |= __put_user(0, &to->gs);
@@ -120,6 +138,19 @@ static int copy_sc_to_user(struct sigcon
 #undef PUTREG
 
 	err |= __put_user(mask, &to->oldmask);
+	if (err)
+		return 1;
+
+	err = save_fp_registers(userspace_pid[current_thread->cpu],
+				(unsigned long *) &fp);
+	if (err < 0) {
+		printk(KERN_ERR "copy_sc_from_user - restore_fp_registers "
+		       "failed, errno = %d\n", -err);
+		return 1;
+	}
+
+	if (copy_to_user(to_fp, &fp, sizeof(struct user_i387_struct)))
+		return 1;
 
 	return(err);
 }
@@ -129,6 +160,7 @@ struct rt_sigframe
 	char __user *pretcode;
 	struct ucontext uc;
 	struct siginfo info;
+	struct _fpstate fpstate;
 };
 
 #define round_down(m, n) (((m) / (n)) * (n))
@@ -138,7 +170,6 @@ int setup_signal_stack_si(unsigned long 
 			  siginfo_t *info, sigset_t *set)
 {
 	struct rt_sigframe __user *frame;
-	struct _fpstate __user *fp = NULL;
 	unsigned long save_sp = PT_REGS_RSP(regs);
 	int err = 0;
 	struct task_struct *me = current;
@@ -148,13 +179,6 @@ int setup_signal_stack_si(unsigned long 
 	/* Subtract 128 for a red zone and 8 for proper alignment */
 	frame = (struct rt_sigframe __user *) ((unsigned long) frame - 128 - 8);
 
-	if (!access_ok(VERIFY_WRITE, fp, sizeof(struct _fpstate)))
-		goto out;
-
-#if 0 /* XXX */
-	if (save_i387(fp) < 0)
-		err |= -1;
-#endif
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto out;
 
@@ -181,9 +205,9 @@ int setup_signal_stack_si(unsigned long 
 	err |= __put_user(sas_ss_flags(save_sp),
 			  &frame->uc.uc_stack.ss_flags);
 	err |= __put_user(me->sas_ss_size, &frame->uc.uc_stack.ss_size);
-	err |= copy_sc_to_user(&frame->uc.uc_mcontext, fp, regs, set->sig[0],
-		save_sp);
-	err |= __put_user(fp, &frame->uc.uc_mcontext.fpstate);
+	err |= copy_sc_to_user(&frame->uc.uc_mcontext, &frame->fpstate, regs,
+			       set->sig[0], save_sp);
+	err |= __put_user(&frame->fpstate, &frame->uc.uc_mcontext.fpstate);
 	if (sizeof(*set) == 16) {
 		__put_user(set->sig[0], &frame->uc.uc_sigmask.sig[0]);
 		__put_user(set->sig[1], &frame->uc.uc_sigmask.sig[1]);
@@ -246,7 +270,8 @@ long sys_rt_sigreturn(struct pt_regs *re
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
-	if (copy_sc_from_user(&current->thread.regs, &uc->uc_mcontext))
+	if (copy_sc_from_user(&current->thread.regs, &uc->uc_mcontext,
+			      &frame->fpstate))
 		goto segfault;
 
 	/* Avoid ERESTART handling */
_

Patches currently in -mm which might be from jdike@addtoit.com are

introduce-config_check_signature-was-re-uninline.patch
uml-fix-previous-request-size-limit-fix.patch
uml-fix-linker-script-alignment-bugs.patch
uml-fix-x86_64-core-dump-crash.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-physmem-code-tidying.patch
uml-add-vde-networking-support.patch
uml-remove-unnecessary-hostfs_getattr.patch
uml-throw-out-config_mode_tt.patch
uml-remove-sysdep-threadh.patch
uml-style-fixes-pass-1.patch
uml-throw-out-choose_mode.patch
uml-style-fixes-pass-2.patch
uml-remove-code-made-redundant-by-choose_mode-removal.patch
uml-style-fixes-pass-3.patch
uml-remove-__u64-usage-from-physical-memory-subsystem.patch
uml-get-rid-of-do_longjmp.patch
uml-fold-mmu_context_skas-into-mm_context.patch
uml-rename-pt_regs-general-purpose-register-file.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch
uml-fix-inlines.patch
uml-use-64-bits-for-block-size-on-x86_64.patch
uml-userspace-files-should-call-libc-directly.patch
uml-clean-up-tlb-flush-path.patch
uml-remove-unneeded-if-from-hostfs.patch
uml-fix-hostfs-style.patch
uml-dont-use-glibc-asm-userh.patch
uml-floating-point-signal-delivery-fixes.patch
uml-ptrace-floating-point-fixes.patch
uml-coredumping-floating-point-fixes.patch
uml-sysrq-and-mconsole-fixes.patch
uml-style-fixes-in-fp-code.patch
uml-eliminate-floating-point-state-from-register-file.patch
