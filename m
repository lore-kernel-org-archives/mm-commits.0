From: akpm@linux-foundation.org
Subject: + x86_64-use-linux-elfcore-compath.patch added to -mm tree
Date: Tue, 07 Aug 2007 13:29:00 -0700
Message-ID: <200708072029.l77KT04A002438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50763 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754858AbXHGU3u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 16:29:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ak@suse.de, benh@kernel.crashing.org, paulus@samba.org, tony.luck@intel.com


The patch titled
     x86_64: Use linux/elfcore-compat.h
has been added to the -mm tree.  Its filename is
     x86_64-use-linux-elfcore-compath.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: Use linux/elfcore-compat.h
From: Roland McGrath <roland@redhat.com>

This makes x86-64's ia32 code use the new linux/elfcore-compat.h, reducing
some hand-copied duplication.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/ia32/ia32_binfmt.c |  123 +++++++++++--------------------
 include/asm-x86_64/compat.h    |    6 +
 2 files changed, 51 insertions(+), 78 deletions(-)

diff -puN arch/x86_64/ia32/ia32_binfmt.c~x86_64-use-linux-elfcore-compath arch/x86_64/ia32/ia32_binfmt.c
--- a/arch/x86_64/ia32/ia32_binfmt.c~x86_64-use-linux-elfcore-compath
+++ a/arch/x86_64/ia32/ia32_binfmt.c
@@ -5,10 +5,6 @@
  * This tricks binfmt_elf.c into loading 32bit binaries using lots 
  * of ugly preprocessor tricks. Talk about very very poor man's inheritance.
  */ 
-#define __ASM_X86_64_ELF_H 1
-
-#undef ELF_CLASS
-#define ELF_CLASS ELFCLASS32
 
 #include <linux/types.h>
 #include <linux/stddef.h>
@@ -19,6 +15,7 @@
 #include <linux/binfmts.h>
 #include <linux/mm.h>
 #include <linux/security.h>
+#include <linux/elfcore-compat.h>
 
 #include <asm/segment.h> 
 #include <asm/ptrace.h>
@@ -31,6 +28,20 @@
 #include <asm/ia32.h>
 #include <asm/vsyscall32.h>
 
+#undef	ELF_ARCH
+#undef	ELF_CLASS
+#define ELF_CLASS	ELFCLASS32
+#define ELF_ARCH	EM_386
+
+#undef	elfhdr
+#undef	elf_phdr
+#undef	elf_note
+#undef	elf_addr_t
+#define elfhdr		elf32_hdr
+#define elf_phdr	elf32_phdr
+#define elf_note	elf32_note
+#define elf_addr_t	Elf32_Off
+
 #define ELF_NAME "elf/i386"
 
 #define AT_SYSINFO 32
@@ -48,70 +59,14 @@ int sysctl_vsyscall32 = 1;
 } while(0)
 
 struct file;
-struct elf_phdr; 
 
 #define IA32_EMULATOR 1
 
+#undef	ELF_ET_DYN_BASE
 #define ELF_ET_DYN_BASE		(TASK_UNMAPPED_BASE + 0x1000000)
 
-#undef ELF_ARCH
-#define ELF_ARCH EM_386
-
-#define ELF_DATA	ELFDATA2LSB
-
-#define USE_ELF_CORE_DUMP 1
-
-/* Override elfcore.h */ 
-#define _LINUX_ELFCORE_H 1
-typedef unsigned int elf_greg_t;
-
-#define ELF_NGREG (sizeof (struct user_regs_struct32) / sizeof(elf_greg_t))
-typedef elf_greg_t elf_gregset_t[ELF_NGREG];
-
-struct elf_siginfo
-{
-	int	si_signo;			/* signal number */
-	int	si_code;			/* extra code */
-	int	si_errno;			/* errno */
-};
-
 #define jiffies_to_timeval(a,b) do { (b)->tv_usec = 0; (b)->tv_sec = (a)/HZ; }while(0)
 
-struct elf_prstatus
-{
-	struct elf_siginfo pr_info;	/* Info associated with signal */
-	short	pr_cursig;		/* Current signal */
-	unsigned int pr_sigpend;	/* Set of pending signals */
-	unsigned int pr_sighold;	/* Set of held signals */
-	pid_t	pr_pid;
-	pid_t	pr_ppid;
-	pid_t	pr_pgrp;
-	pid_t	pr_sid;
-	struct compat_timeval pr_utime;	/* User time */
-	struct compat_timeval pr_stime;	/* System time */
-	struct compat_timeval pr_cutime;	/* Cumulative user time */
-	struct compat_timeval pr_cstime;	/* Cumulative system time */
-	elf_gregset_t pr_reg;	/* GP registers */
-	int pr_fpvalid;		/* True if math co-processor being used.  */
-};
-
-#define ELF_PRARGSZ	(80)	/* Number of chars for args */
-
-struct elf_prpsinfo
-{
-	char	pr_state;	/* numeric process state */
-	char	pr_sname;	/* char for pr_state */
-	char	pr_zomb;	/* zombie */
-	char	pr_nice;	/* nice val */
-	unsigned int pr_flag;	/* flags */
-	__u16	pr_uid;
-	__u16	pr_gid;
-	pid_t	pr_pid, pr_ppid, pr_pgrp, pr_sid;
-	/* Lots missing */
-	char	pr_fname[16];	/* filename of executable */
-	char	pr_psargs[ELF_PRARGSZ];	/* initial part of arg list */
-};
-
 #define __STR(x) #x
 #define STR(x) __STR(x)
 
@@ -119,6 +74,7 @@ struct elf_prpsinfo
 	({ __u32 seg; asm("movl %%" STR(x) ",%0" : "=r"(seg)); seg; })
 
 /* Assumes current==process to be dumped */
+#undef	ELF_CORE_COPY_REGS
 #define ELF_CORE_COPY_REGS(pr_reg, regs)       		\
 	pr_reg[0] = regs->rbx;				\
 	pr_reg[1] = regs->rcx;				\
@@ -138,36 +94,41 @@ struct elf_prpsinfo
 	pr_reg[15] = regs->rsp;				\
 	pr_reg[16] = regs->ss;
 
-#define user user32
+
+#define elf_prstatus	compat_elf_prstatus
+#define elf_prpsinfo	compat_elf_prpsinfo
+#define elf_fpregset_t	struct user_i387_ia32_struct
+#define	elf_fpxregset_t	struct user32_fxsr_struct
+#define user		user32
 
 #undef elf_read_implies_exec
 #define elf_read_implies_exec(ex, executable_stack)     (executable_stack != EXSTACK_DISABLE_X)
-//#include <asm/ia32.h>
-#include <linux/elf.h>
-
-typedef struct user_i387_ia32_struct elf_fpregset_t;
-typedef struct user32_fxsr_struct elf_fpxregset_t;
-
 
-static inline void elf_core_copy_regs(elf_gregset_t *elfregs, struct pt_regs *regs)
+#define elf_core_copy_regs		elf32_core_copy_regs
+static inline void elf32_core_copy_regs(compat_elf_gregset_t *elfregs,
+					struct pt_regs *regs)
 {
-	ELF_CORE_COPY_REGS((*elfregs), regs)
+	ELF_CORE_COPY_REGS((&elfregs->ebx), regs)
 }
 
-static inline int elf_core_copy_task_regs(struct task_struct *t, elf_gregset_t* elfregs)
+#define elf_core_copy_task_regs		elf32_core_copy_task_regs
+static inline int elf32_core_copy_task_regs(struct task_struct *t,
+					    compat_elf_gregset_t* elfregs)
 {	
 	struct pt_regs *pp = task_pt_regs(t);
-	ELF_CORE_COPY_REGS((*elfregs), pp);
+	ELF_CORE_COPY_REGS((&elfregs->ebx), pp);
 	/* fix wrong segments */ 
-	(*elfregs)[7] = t->thread.ds; 
-	(*elfregs)[9] = t->thread.fsindex; 
-	(*elfregs)[10] = t->thread.gsindex; 
-	(*elfregs)[8] = t->thread.es; 	
+	elfregs->ds = t->thread.ds;
+	elfregs->fs = t->thread.fsindex;
+	elfregs->gs = t->thread.gsindex;
+	elfregs->es = t->thread.es;
 	return 1; 
 }
 
+#define elf_core_copy_task_fpregs	elf32_core_copy_task_fpregs
 static inline int 
-elf_core_copy_task_fpregs(struct task_struct *tsk, struct pt_regs *regs, elf_fpregset_t *fpu)
+elf32_core_copy_task_fpregs(struct task_struct *tsk, struct pt_regs *regs,
+			    elf_fpregset_t *fpu)
 {
 	struct _fpstate_ia32 *fpstate = (void*)fpu; 
 	mm_segment_t oldfs = get_fs();
@@ -188,8 +149,9 @@ elf_core_copy_task_fpregs(struct task_st
 }
 
 #define ELF_CORE_COPY_XFPREGS 1
+#define elf_core_copy_task_xfpregs	elf32_core_copy_task_xfpregs
 static inline int 
-elf_core_copy_task_xfpregs(struct task_struct *t, elf_fpxregset_t *xfpu)
+elf32_core_copy_task_xfpregs(struct task_struct *t, elf_fpxregset_t *xfpu)
 {
 	struct pt_regs *regs = task_pt_regs(t);
 	if (!tsk_used_math(t))
@@ -208,6 +170,10 @@ elf_core_copy_task_xfpregs(struct task_s
 
 extern int force_personality32;
 
+#undef	ELF_EXEC_PAGESIZE
+#undef	ELF_HWCAP
+#undef	ELF_PLATFORM
+#undef	SET_PERSONALITY
 #define ELF_EXEC_PAGESIZE PAGE_SIZE
 #define ELF_HWCAP (boot_cpu_data.x86_capability[0])
 #define ELF_PLATFORM  ("i686")
@@ -233,6 +199,7 @@ do {							\
 
 #define load_elf_binary load_elf32_binary
 
+#undef	ELF_PLAT_INIT
 #define ELF_PLAT_INIT(r, load_addr)	elf32_init(r)
 
 #undef start_thread
diff -puN include/asm-x86_64/compat.h~x86_64-use-linux-elfcore-compath include/asm-x86_64/compat.h
--- a/include/asm-x86_64/compat.h~x86_64-use-linux-elfcore-compath
+++ a/include/asm-x86_64/compat.h
@@ -6,6 +6,7 @@
  */
 #include <linux/types.h>
 #include <linux/sched.h>
+#include <asm/user32.h>
 
 #define COMPAT_USER_HZ	100
 
@@ -181,6 +182,11 @@ struct compat_shmid64_ds {
 };
 
 /*
+ * The type of struct elf_prstatus.pr_reg in compatible core dumps.
+ */
+typedef struct user_regs_struct32 compat_elf_gregset_t;
+
+/*
  * A pointer passed in from user mode. This should not
  * be used for syscall parameters, just declare them
  * as pointers because the syscall entry code will have
_

Patches currently in -mm which might be from roland@redhat.com are

powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
add-sys-module-name-notes.patch
do_sigaction-remove-now-unneeded-recalc_sigpending.patch
handle-the-multi-threaded-inits-exit-properly.patch
add-linux-elfcore-compath.patch
x86_64-use-linux-elfcore-compath.patch
powerpc-use-linux-elfcore-compath.patch
