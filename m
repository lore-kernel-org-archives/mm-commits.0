From: akpm@linux-foundation.org
Subject: - uml-rename-pt_regs-general-purpose-register-file.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:37:48 -0700
Message-ID: <200710162037.l9GKbmNO015317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41109 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965518AbXJPVSO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:18:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: rename pt_regs general-purpose register file
has been removed from the -mm tree.  Its filename was
     uml-rename-pt_regs-general-purpose-register-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: rename pt_regs general-purpose register file
From: Jeff Dike <jdike@addtoit.com>

Before the removal of tt mode, access to a register on the skas-mode side of a
pt_regs struct looked like pt_regs.regs.skas.regs.regs[FOO].  This was bad
enough, but it became pt_regs.regs.regs.regs[FOO] with the removal of the
union from the middle.  To get rid of the run of three "regs", the last field
is renamed to "gp".

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/sysdep-i386/ptrace.h   |   36 ++++++------
 arch/um/include/sysdep-x86_64/ptrace.h |   60 ++++++++++-----------
 arch/um/kernel/process.c               |    4 -
 arch/um/kernel/skas/syscall.c          |    2 
 arch/um/os-Linux/registers.c           |    6 +-
 arch/um/os-Linux/skas/process.c        |    4 -
 arch/um/sys-i386/signal.c              |   64 +++++++++++------------
 arch/um/sys-x86_64/signal.c            |    6 +-
 arch/um/sys-x86_64/tls.c               |    2 
 include/asm-um/elf-x86_64.h            |   42 +++++++--------
 10 files changed, 113 insertions(+), 113 deletions(-)

diff -puN arch/um/include/sysdep-i386/ptrace.h~uml-rename-pt_regs-general-purpose-register-file arch/um/include/sysdep-i386/ptrace.h
--- a/arch/um/include/sysdep-i386/ptrace.h~uml-rename-pt_regs-general-purpose-register-file
+++ a/arch/um/include/sysdep-i386/ptrace.h
@@ -53,7 +53,7 @@ extern int sysemu_supported;
 #endif
 
 struct uml_pt_regs {
-	unsigned long regs[MAX_REG_NR];
+	unsigned long gp[MAX_REG_NR];
 	unsigned long fp[HOST_FP_SIZE];
 	unsigned long xfp[HOST_XFP_SIZE];
 	struct faultinfo faultinfo;
@@ -63,23 +63,23 @@ struct uml_pt_regs {
 
 #define EMPTY_UML_PT_REGS { }
 
-#define UPT_IP(r) REGS_IP((r)->regs)
-#define UPT_SP(r) REGS_SP((r)->regs)
-#define UPT_EFLAGS(r) REGS_EFLAGS((r)->regs)
-#define UPT_EAX(r) REGS_EAX((r)->regs)
-#define UPT_EBX(r) REGS_EBX((r)->regs)
-#define UPT_ECX(r) REGS_ECX((r)->regs)
-#define UPT_EDX(r) REGS_EDX((r)->regs)
-#define UPT_ESI(r) REGS_ESI((r)->regs)
-#define UPT_EDI(r) REGS_EDI((r)->regs)
-#define UPT_EBP(r) REGS_EBP((r)->regs)
+#define UPT_IP(r) REGS_IP((r)->gp)
+#define UPT_SP(r) REGS_SP((r)->gp)
+#define UPT_EFLAGS(r) REGS_EFLAGS((r)->gp)
+#define UPT_EAX(r) REGS_EAX((r)->gp)
+#define UPT_EBX(r) REGS_EBX((r)->gp)
+#define UPT_ECX(r) REGS_ECX((r)->gp)
+#define UPT_EDX(r) REGS_EDX((r)->gp)
+#define UPT_ESI(r) REGS_ESI((r)->gp)
+#define UPT_EDI(r) REGS_EDI((r)->gp)
+#define UPT_EBP(r) REGS_EBP((r)->gp)
 #define UPT_ORIG_EAX(r) ((r)->syscall)
-#define UPT_CS(r) REGS_CS((r)->regs)
-#define UPT_SS(r) REGS_SS((r)->regs)
-#define UPT_DS(r) REGS_DS((r)->regs)
-#define UPT_ES(r) REGS_ES((r)->regs)
-#define UPT_FS(r) REGS_FS((r)->regs)
-#define UPT_GS(r) REGS_GS((r)->regs)
+#define UPT_CS(r) REGS_CS((r)->gp)
+#define UPT_SS(r) REGS_SS((r)->gp)
+#define UPT_DS(r) REGS_DS((r)->gp)
+#define UPT_ES(r) REGS_ES((r)->gp)
+#define UPT_FS(r) REGS_FS((r)->gp)
+#define UPT_GS(r) REGS_GS((r)->gp)
 
 #define UPT_SYSCALL_ARG1(r) UPT_EBX(r)
 #define UPT_SYSCALL_ARG2(r) UPT_ECX(r)
@@ -161,7 +161,7 @@ struct syscall_args {
 #define UPT_SET_SYSCALL_RETURN(r, res) \
 	REGS_SET_SYSCALL_RETURN((r)->regs, (res))
 
-#define UPT_RESTART_SYSCALL(r) REGS_RESTART_SYSCALL((r)->regs)
+#define UPT_RESTART_SYSCALL(r) REGS_RESTART_SYSCALL((r)->gp)
 
 #define UPT_ORIG_SYSCALL(r) UPT_EAX(r)
 #define UPT_SYSCALL_NR(r) UPT_ORIG_EAX(r)
diff -puN arch/um/include/sysdep-x86_64/ptrace.h~uml-rename-pt_regs-general-purpose-register-file arch/um/include/sysdep-x86_64/ptrace.h
--- a/arch/um/include/sysdep-x86_64/ptrace.h~uml-rename-pt_regs-general-purpose-register-file
+++ a/arch/um/include/sysdep-x86_64/ptrace.h
@@ -85,7 +85,7 @@
 #define REGS_ERR(r) ((r)->fault_type)
 
 struct uml_pt_regs {
-	unsigned long regs[MAX_REG_NR];
+	unsigned long gp[MAX_REG_NR];
 	unsigned long fp[HOST_FP_SIZE];
 	struct faultinfo faultinfo;
 	long syscall;
@@ -94,36 +94,36 @@ struct uml_pt_regs {
 
 #define EMPTY_UML_PT_REGS { }
 
-#define UPT_RBX(r) REGS_RBX((r)->regs)
-#define UPT_RCX(r) REGS_RCX((r)->regs)
-#define UPT_RDX(r) REGS_RDX((r)->regs)
-#define UPT_RSI(r) REGS_RSI((r)->regs)
-#define UPT_RDI(r) REGS_RDI((r)->regs)
-#define UPT_RBP(r) REGS_RBP((r)->regs)
-#define UPT_RAX(r) REGS_RAX((r)->regs)
-#define UPT_R8(r) REGS_R8((r)->regs)
-#define UPT_R9(r) REGS_R9((r)->regs)
-#define UPT_R10(r) REGS_R10((r)->regs)
-#define UPT_R11(r) REGS_R11((r)->regs)
-#define UPT_R12(r) REGS_R12((r)->regs)
-#define UPT_R13(r) REGS_R13((r)->regs)
-#define UPT_R14(r) REGS_R14((r)->regs)
-#define UPT_R15(r) REGS_R15((r)->regs)
-#define UPT_CS(r) REGS_CS((r)->regs)
-#define UPT_FS_BASE(r) REGS_FS_BASE((r)->regs)
-#define UPT_FS(r) REGS_FS((r)->regs)
-#define UPT_GS_BASE(r) REGS_GS_BASE((r)->regs)
-#define UPT_GS(r) REGS_GS((r)->regs)
-#define UPT_DS(r) REGS_DS((r)->regs)
-#define UPT_ES(r) REGS_ES((r)->regs)
-#define UPT_CS(r) REGS_CS((r)->regs)
-#define UPT_SS(r) REGS_SS((r)->regs)
-#define UPT_ORIG_RAX(r) REGS_ORIG_RAX((r)->regs)
+#define UPT_RBX(r) REGS_RBX((r)->gp)
+#define UPT_RCX(r) REGS_RCX((r)->gp)
+#define UPT_RDX(r) REGS_RDX((r)->gp)
+#define UPT_RSI(r) REGS_RSI((r)->gp)
+#define UPT_RDI(r) REGS_RDI((r)->gp)
+#define UPT_RBP(r) REGS_RBP((r)->gp)
+#define UPT_RAX(r) REGS_RAX((r)->gp)
+#define UPT_R8(r) REGS_R8((r)->gp)
+#define UPT_R9(r) REGS_R9((r)->gp)
+#define UPT_R10(r) REGS_R10((r)->gp)
+#define UPT_R11(r) REGS_R11((r)->gp)
+#define UPT_R12(r) REGS_R12((r)->gp)
+#define UPT_R13(r) REGS_R13((r)->gp)
+#define UPT_R14(r) REGS_R14((r)->gp)
+#define UPT_R15(r) REGS_R15((r)->gp)
+#define UPT_CS(r) REGS_CS((r)->gp)
+#define UPT_FS_BASE(r) REGS_FS_BASE((r)->gp)
+#define UPT_FS(r) REGS_FS((r)->gp)
+#define UPT_GS_BASE(r) REGS_GS_BASE((r)->gp)
+#define UPT_GS(r) REGS_GS((r)->gp)
+#define UPT_DS(r) REGS_DS((r)->gp)
+#define UPT_ES(r) REGS_ES((r)->gp)
+#define UPT_CS(r) REGS_CS((r)->gp)
+#define UPT_SS(r) REGS_SS((r)->gp)
+#define UPT_ORIG_RAX(r) REGS_ORIG_RAX((r)->gp)
 
-#define UPT_IP(r) REGS_IP((r)->regs)
-#define UPT_SP(r) REGS_SP((r)->regs)
+#define UPT_IP(r) REGS_IP((r)->gp)
+#define UPT_SP(r) REGS_SP((r)->gp)
 
-#define UPT_EFLAGS(r) REGS_EFLAGS((r)->regs)
+#define UPT_EFLAGS(r) REGS_EFLAGS((r)->gp)
 #define UPT_SYSCALL_NR(r) ((r)->syscall)
 #define UPT_SYSCALL_RET(r) UPT_RAX(r)
 
@@ -228,7 +228,7 @@ struct syscall_args {
 #define UPT_SET_SYSCALL_RETURN(r, res) \
 	REGS_SET_SYSCALL_RETURN((r)->regs, (res))
 
-#define UPT_RESTART_SYSCALL(r) REGS_RESTART_SYSCALL((r)->regs)
+#define UPT_RESTART_SYSCALL(r) REGS_RESTART_SYSCALL((r)->gp)
 
 #define UPT_SEGV_IS_FIXABLE(r) REGS_SEGV_IS_FIXABLE(&r->skas)
 
diff -puN arch/um/kernel/process.c~uml-rename-pt_regs-general-purpose-register-file arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-rename-pt_regs-general-purpose-register-file
+++ a/arch/um/kernel/process.c
@@ -201,9 +201,9 @@ int copy_thread(int nr, unsigned long cl
 	if (current->thread.forking) {
 	  	memcpy(&p->thread.regs.regs, &regs->regs,
 		       sizeof(p->thread.regs.regs));
-		REGS_SET_SYSCALL_RETURN(p->thread.regs.regs.regs, 0);
+		REGS_SET_SYSCALL_RETURN(p->thread.regs.regs.gp, 0);
 		if (sp != 0)
-			REGS_SP(p->thread.regs.regs.regs) = sp;
+			REGS_SP(p->thread.regs.regs.gp) = sp;
 
 		handler = fork_handler;
 
diff -puN arch/um/kernel/skas/syscall.c~uml-rename-pt_regs-general-purpose-register-file arch/um/kernel/skas/syscall.c
--- a/arch/um/kernel/skas/syscall.c~uml-rename-pt_regs-general-purpose-register-file
+++ a/arch/um/kernel/skas/syscall.c
@@ -34,7 +34,7 @@ void handle_syscall(struct uml_pt_regs *
 		result = -ENOSYS;
 	else result = EXECUTE_SYSCALL(syscall, regs);
 
-	REGS_SET_SYSCALL_RETURN(r->regs, result);
+	REGS_SET_SYSCALL_RETURN(r->gp, result);
 
 	syscall_trace(r, 1);
 }
diff -puN arch/um/os-Linux/registers.c~uml-rename-pt_regs-general-purpose-register-file arch/um/os-Linux/registers.c
--- a/arch/um/os-Linux/registers.c~uml-rename-pt_regs-general-purpose-register-file
+++ a/arch/um/os-Linux/registers.c
@@ -16,14 +16,14 @@ static unsigned long exec_regs[MAX_REG_N
 
 void init_thread_registers(struct uml_pt_regs *to)
 {
-	memcpy(to->regs, exec_regs, sizeof(to->regs));
+	memcpy(to->gp, exec_regs, sizeof(to->gp));
 }
 
 void save_registers(int pid, struct uml_pt_regs *regs)
 {
 	int err;
 
-	err = ptrace(PTRACE_GETREGS, pid, 0, regs->regs);
+	err = ptrace(PTRACE_GETREGS, pid, 0, regs->gp);
 	if (err < 0)
 		panic("save_registers - saving registers failed, errno = %d\n",
 		      errno);
@@ -33,7 +33,7 @@ void restore_registers(int pid, struct u
 {
 	int err;
 
-	err = ptrace(PTRACE_SETREGS, pid, 0, regs->regs);
+	err = ptrace(PTRACE_SETREGS, pid, 0, regs->gp);
 	if (err < 0)
 		panic("restore_registers - saving registers failed, "
 		      "errno = %d\n", errno);
diff -puN arch/um/os-Linux/skas/process.c~uml-rename-pt_regs-general-purpose-register-file arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-rename-pt_regs-general-purpose-register-file
+++ a/arch/um/os-Linux/skas/process.c
@@ -138,7 +138,7 @@ static void handle_trap(int pid, struct 
 	int err, status;
 
 	/* Mark this as a syscall */
-	UPT_SYSCALL_NR(regs) = PT_SYSCALL_NR(regs->regs);
+	UPT_SYSCALL_NR(regs) = PT_SYSCALL_NR(regs->gp);
 
 	if (!local_using_sysemu)
 	{
@@ -352,7 +352,7 @@ void userspace(struct uml_pt_regs *regs)
 
 			/* Avoid -ERESTARTSYS handling in host */
 			if (PT_SYSCALL_NR_OFFSET != PT_SYSCALL_RET_OFFSET)
-				PT_SYSCALL_NR(regs->regs) = -1;
+				PT_SYSCALL_NR(regs->gp) = -1;
 		}
 	}
 }
diff -puN arch/um/sys-i386/signal.c~uml-rename-pt_regs-general-purpose-register-file arch/um/sys-i386/signal.c
--- a/arch/um/sys-i386/signal.c~uml-rename-pt_regs-general-purpose-register-file
+++ a/arch/um/sys-i386/signal.c
@@ -14,22 +14,22 @@ void copy_sc(struct uml_pt_regs *regs, v
 {
 	struct sigcontext *sc = from;
 
-	REGS_GS(regs->regs) = sc->gs;
-	REGS_FS(regs->regs) = sc->fs;
-	REGS_ES(regs->regs) = sc->es;
-	REGS_DS(regs->regs) = sc->ds;
-	REGS_EDI(regs->regs) = sc->edi;
-	REGS_ESI(regs->regs) = sc->esi;
-	REGS_EBP(regs->regs) = sc->ebp;
-	REGS_SP(regs->regs) = sc->esp;
-	REGS_EBX(regs->regs) = sc->ebx;
-	REGS_EDX(regs->regs) = sc->edx;
-	REGS_ECX(regs->regs) = sc->ecx;
-	REGS_EAX(regs->regs) = sc->eax;
-	REGS_IP(regs->regs) = sc->eip;
-	REGS_CS(regs->regs) = sc->cs;
-	REGS_EFLAGS(regs->regs) = sc->eflags;
-	REGS_SS(regs->regs) = sc->ss;
+	REGS_GS(regs->gp) = sc->gs;
+	REGS_FS(regs->gp) = sc->fs;
+	REGS_ES(regs->gp) = sc->es;
+	REGS_DS(regs->gp) = sc->ds;
+	REGS_EDI(regs->gp) = sc->edi;
+	REGS_ESI(regs->gp) = sc->esi;
+	REGS_EBP(regs->gp) = sc->ebp;
+	REGS_SP(regs->gp) = sc->esp;
+	REGS_EBX(regs->gp) = sc->ebx;
+	REGS_EDX(regs->gp) = sc->edx;
+	REGS_ECX(regs->gp) = sc->ecx;
+	REGS_EAX(regs->gp) = sc->eax;
+	REGS_IP(regs->gp) = sc->eip;
+	REGS_CS(regs->gp) = sc->cs;
+	REGS_EFLAGS(regs->gp) = sc->eflags;
+	REGS_SS(regs->gp) = sc->ss;
 }
 
 static int copy_sc_from_user(struct pt_regs *regs,
@@ -65,23 +65,23 @@ static int copy_sc_to_user(struct sigcon
 	struct faultinfo * fi = &current->thread.arch.faultinfo;
 	int err;
 
-	sc.gs = REGS_GS(regs->regs.regs);
-	sc.fs = REGS_FS(regs->regs.regs);
-	sc.es = REGS_ES(regs->regs.regs);
-	sc.ds = REGS_DS(regs->regs.regs);
-	sc.edi = REGS_EDI(regs->regs.regs);
-	sc.esi = REGS_ESI(regs->regs.regs);
-	sc.ebp = REGS_EBP(regs->regs.regs);
+	sc.gs = REGS_GS(regs->regs.gp);
+	sc.fs = REGS_FS(regs->regs.gp);
+	sc.es = REGS_ES(regs->regs.gp);
+	sc.ds = REGS_DS(regs->regs.gp);
+	sc.edi = REGS_EDI(regs->regs.gp);
+	sc.esi = REGS_ESI(regs->regs.gp);
+	sc.ebp = REGS_EBP(regs->regs.gp);
 	sc.esp = sp;
-	sc.ebx = REGS_EBX(regs->regs.regs);
-	sc.edx = REGS_EDX(regs->regs.regs);
-	sc.ecx = REGS_ECX(regs->regs.regs);
-	sc.eax = REGS_EAX(regs->regs.regs);
-	sc.eip = REGS_IP(regs->regs.regs);
-	sc.cs = REGS_CS(regs->regs.regs);
-	sc.eflags = REGS_EFLAGS(regs->regs.regs);
-	sc.esp_at_signal = regs->regs.regs[UESP];
-	sc.ss = regs->regs.regs[SS];
+	sc.ebx = REGS_EBX(regs->regs.gp);
+	sc.edx = REGS_EDX(regs->regs.gp);
+	sc.ecx = REGS_ECX(regs->regs.gp);
+	sc.eax = REGS_EAX(regs->regs.gp);
+	sc.eip = REGS_IP(regs->regs.gp);
+	sc.cs = REGS_CS(regs->regs.gp);
+	sc.eflags = REGS_EFLAGS(regs->regs.gp);
+	sc.esp_at_signal = regs->regs.gp[UESP];
+	sc.ss = regs->regs.gp[SS];
 	sc.cr2 = fi->cr2;
 	sc.err = fi->error_code;
 	sc.trapno = fi->trap_no;
diff -puN arch/um/sys-x86_64/signal.c~uml-rename-pt_regs-general-purpose-register-file arch/um/sys-x86_64/signal.c
--- a/arch/um/sys-x86_64/signal.c~uml-rename-pt_regs-general-purpose-register-file
+++ a/arch/um/sys-x86_64/signal.c
@@ -16,7 +16,7 @@ void copy_sc(struct uml_pt_regs *regs, v
 	struct sigcontext *sc = from;
 
 #define GETREG(regs, regno, sc, regname)				\
-	(regs)->regs[(regno) / sizeof(unsigned long)] = (sc)->regname
+	(regs)->gp[(regno) / sizeof(unsigned long)] = (sc)->regname
 
 	GETREG(regs, R8, sc, r8);
 	GETREG(regs, R9, sc, r9);
@@ -47,7 +47,7 @@ static int copy_sc_from_user(struct pt_r
 	int err = 0;
 
 #define GETREG(regs, regno, sc, regname)				\
-	__get_user((regs)->regs.regs[(regno) / sizeof(unsigned long)],	\
+	__get_user((regs)->regs.gp[(regno) / sizeof(unsigned long)],	\
 		   &(sc)->regname)
 
 	err |= GETREG(regs, R8, from, r8);
@@ -86,7 +86,7 @@ static int copy_sc_to_user(struct sigcon
 	err |= __put_user(0, &to->fs);
 
 #define PUTREG(regs, regno, sc, regname)				\
-	__put_user((regs)->regs.regs[(regno) / sizeof(unsigned long)],	\
+	__put_user((regs)->regs.gp[(regno) / sizeof(unsigned long)],	\
 		   &(sc)->regname)
 
 	err |= PUTREG(regs, RDI, to, rdi);
diff -puN arch/um/sys-x86_64/tls.c~uml-rename-pt_regs-general-purpose-register-file arch/um/sys-x86_64/tls.c
--- a/arch/um/sys-x86_64/tls.c~uml-rename-pt_regs-general-purpose-register-file
+++ a/arch/um/sys-x86_64/tls.c
@@ -11,7 +11,7 @@ int arch_copy_tls(struct task_struct *t)
 	 * (which is argument 5, child_tid, of clone) so it can be set
 	 * during context switches.
 	 */
-	t->thread.arch.fs = t->thread.regs.regs.regs[R8 / sizeof(long)];
+	t->thread.arch.fs = t->thread.regs.regs.gp[R8 / sizeof(long)];
 
 	return 0;
 }
diff -puN include/asm-um/elf-x86_64.h~uml-rename-pt_regs-general-purpose-register-file include/asm-um/elf-x86_64.h
--- a/include/asm-um/elf-x86_64.h~uml-rename-pt_regs-general-purpose-register-file
+++ a/include/asm-um/elf-x86_64.h
@@ -67,27 +67,27 @@ typedef struct { } elf_fpregset_t;
 } while (0)
 
 #define ELF_CORE_COPY_REGS(pr_reg, regs)		\
-	(pr_reg)[0] = (regs)->regs.skas.regs[0];			\
-	(pr_reg)[1] = (regs)->regs.skas.regs[1];			\
-	(pr_reg)[2] = (regs)->regs.skas.regs[2];			\
-	(pr_reg)[3] = (regs)->regs.skas.regs[3];			\
-	(pr_reg)[4] = (regs)->regs.skas.regs[4];			\
-	(pr_reg)[5] = (regs)->regs.skas.regs[5];			\
-	(pr_reg)[6] = (regs)->regs.skas.regs[6];			\
-	(pr_reg)[7] = (regs)->regs.skas.regs[7];			\
-	(pr_reg)[8] = (regs)->regs.skas.regs[8];			\
-	(pr_reg)[9] = (regs)->regs.skas.regs[9];			\
-	(pr_reg)[10] = (regs)->regs.skas.regs[10];			\
-	(pr_reg)[11] = (regs)->regs.skas.regs[11];			\
-	(pr_reg)[12] = (regs)->regs.skas.regs[12];			\
-	(pr_reg)[13] = (regs)->regs.skas.regs[13];			\
-	(pr_reg)[14] = (regs)->regs.skas.regs[14];			\
-	(pr_reg)[15] = (regs)->regs.skas.regs[15];			\
-	(pr_reg)[16] = (regs)->regs.skas.regs[16];			\
-	(pr_reg)[17] = (regs)->regs.skas.regs[17];			\
-	(pr_reg)[18] = (regs)->regs.skas.regs[18];			\
-	(pr_reg)[19] = (regs)->regs.skas.regs[19];			\
-	(pr_reg)[20] = (regs)->regs.skas.regs[20];			\
+	(pr_reg)[0] = (regs)->regs.gp[0];			\
+	(pr_reg)[1] = (regs)->regs.gp[1];			\
+	(pr_reg)[2] = (regs)->regs.gp[2];			\
+	(pr_reg)[3] = (regs)->regs.gp[3];			\
+	(pr_reg)[4] = (regs)->regs.gp[4];			\
+	(pr_reg)[5] = (regs)->regs.gp[5];			\
+	(pr_reg)[6] = (regs)->regs.gp[6];			\
+	(pr_reg)[7] = (regs)->regs.gp[7];			\
+	(pr_reg)[8] = (regs)->regs.gp[8];			\
+	(pr_reg)[9] = (regs)->regs.gp[9];			\
+	(pr_reg)[10] = (regs)->regs.gp[10];			\
+	(pr_reg)[11] = (regs)->regs.gp[11];			\
+	(pr_reg)[12] = (regs)->regs.gp[12];			\
+	(pr_reg)[13] = (regs)->regs.gp[13];			\
+	(pr_reg)[14] = (regs)->regs.gp[14];			\
+	(pr_reg)[15] = (regs)->regs.gp[15];			\
+	(pr_reg)[16] = (regs)->regs.gp[16];			\
+	(pr_reg)[17] = (regs)->regs.gp[17];			\
+	(pr_reg)[18] = (regs)->regs.gp[18];			\
+	(pr_reg)[19] = (regs)->regs.gp[19];			\
+	(pr_reg)[20] = (regs)->regs.gp[20];			\
 	(pr_reg)[21] = current->thread.arch.fs;			\
 	(pr_reg)[22] = 0;					\
 	(pr_reg)[23] = 0;					\
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
