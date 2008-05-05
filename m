From: akpm@linux-foundation.org
Subject: + uml-make-several-more-things-static.patch added to -mm tree
Date: Mon, 05 May 2008 13:25:04 -0700
Message-ID: <200805052025.m45KP4G4003296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761265AbYEEUZL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 16:25:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jdike@addtoit.com, wangcong@zeuux.org


The patch titled
     UML: make several more things static
has been added to the -mm tree.  Its filename is
     uml-make-several-more-things-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: UML: make several more things static
From: WANG Cong <xiyou.wangcong@gmail.com>

- Make some variables and functions static, since they don't need to be
  global.

- Remove an unused function - arch/um/kernel/time.c::sched_clock().

- Clean the style a bit as complained by checkpatch.pl.

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/skas/skas.h     |    1 -
 arch/um/include/um_uaccess.h    |    1 -
 arch/um/kernel/physmem.c        |    2 +-
 arch/um/kernel/ptrace.c         |    2 +-
 arch/um/kernel/time.c           |    8 --------
 arch/um/kernel/uaccess.c        |    2 +-
 arch/um/os-Linux/sigio.c        |    2 +-
 arch/um/os-Linux/signal.c       |    2 +-
 arch/um/os-Linux/skas/process.c |    2 +-
 arch/um/os-Linux/umid.c         |    2 +-
 arch/um/sys-i386/bugs.c         |    2 +-
 arch/um/sys-i386/checksum.S     |    5 ++---
 arch/um/sys-i386/ldt.c          |    4 ++--
 include/asm-um/ptrace-generic.h |    3 ---
 14 files changed, 12 insertions(+), 26 deletions(-)

diff -puN arch/um/include/skas/skas.h~uml-make-several-more-things-static arch/um/include/skas/skas.h
--- a/arch/um/include/skas/skas.h~uml-make-several-more-things-static
+++ a/arch/um/include/skas/skas.h
@@ -16,7 +16,6 @@ extern int user_thread(unsigned long sta
 extern void new_thread_handler(void);
 extern void handle_syscall(struct uml_pt_regs *regs);
 extern int new_mm(unsigned long stack);
-extern void get_skas_faultinfo(int pid, struct faultinfo * fi);
 extern long execute_syscall_skas(void *r);
 extern unsigned long current_stub_stack(void);
 
diff -puN arch/um/include/um_uaccess.h~uml-make-several-more-things-static arch/um/include/um_uaccess.h
--- a/arch/um/include/um_uaccess.h~uml-make-several-more-things-static
+++ a/arch/um/include/um_uaccess.h
@@ -34,7 +34,6 @@ extern int copy_to_user(void __user *to,
 
 extern int __do_copy_to_user(void *to, const void *from, int n,
 			     void **fault_addr, jmp_buf **fault_catcher);
-extern void __do_copy(void *to, const void *from, int n);
 
 /*
  * strncpy_from_user: - Copy a NUL terminated string from userspace.
diff -puN arch/um/kernel/physmem.c~uml-make-several-more-things-static arch/um/kernel/physmem.c
--- a/arch/um/kernel/physmem.c~uml-make-several-more-things-static
+++ a/arch/um/kernel/physmem.c
@@ -185,7 +185,7 @@ unsigned long find_iomem(char *driver, u
 	return 0;
 }
 
-int setup_iomem(void)
+static int setup_iomem(void)
 {
 	struct iomem_region *region = iomem_regions;
 	unsigned long iomem_start = high_physmem + PAGE_SIZE;
diff -puN arch/um/kernel/ptrace.c~uml-make-several-more-things-static arch/um/kernel/ptrace.c
--- a/arch/um/kernel/ptrace.c~uml-make-several-more-things-static
+++ a/arch/um/kernel/ptrace.c
@@ -225,7 +225,7 @@ long arch_ptrace(struct task_struct *chi
 	return ret;
 }
 
-void send_sigtrap(struct task_struct *tsk, struct uml_pt_regs *regs,
+static void send_sigtrap(struct task_struct *tsk, struct uml_pt_regs *regs,
 		  int error_code)
 {
 	struct siginfo info;
diff -puN arch/um/kernel/time.c~uml-make-several-more-things-static arch/um/kernel/time.c
--- a/arch/um/kernel/time.c~uml-make-several-more-things-static
+++ a/arch/um/kernel/time.c
@@ -13,14 +13,6 @@
 #include "kern_util.h"
 #include "os.h"
 
-/*
- * Scheduler clock - returns current time in nanosec units.
- */
-unsigned long long sched_clock(void)
-{
-	return (unsigned long long)jiffies_64 * (NSEC_PER_SEC / HZ);
-}
-
 void timer_handler(int sig, struct uml_pt_regs *regs)
 {
 	unsigned long flags;
diff -puN arch/um/kernel/uaccess.c~uml-make-several-more-things-static arch/um/kernel/uaccess.c
--- a/arch/um/kernel/uaccess.c~uml-make-several-more-things-static
+++ a/arch/um/kernel/uaccess.c
@@ -12,7 +12,7 @@
 #include <linux/string.h>
 #include "os.h"
 
-void __do_copy(void *to, const void *from, int n)
+static void __do_copy(void *to, const void *from, int n)
 {
 	memcpy(to, from, n);
 }
diff -puN arch/um/os-Linux/sigio.c~uml-make-several-more-things-static arch/um/os-Linux/sigio.c
--- a/arch/um/os-Linux/sigio.c~uml-make-several-more-things-static
+++ a/arch/um/os-Linux/sigio.c
@@ -523,7 +523,7 @@ static void tty_close(int master, int sl
 		printk(UM_KERN_CONT "No, enabling workaround\n");
 }
 
-void __init check_sigio(void)
+static void __init check_sigio(void)
 {
 	if ((access("/dev/ptmx", R_OK) < 0) &&
 	    (access("/dev/ptyp0", R_OK) < 0)) {
diff -puN arch/um/os-Linux/signal.c~uml-make-several-more-things-static arch/um/os-Linux/signal.c
--- a/arch/um/os-Linux/signal.c~uml-make-several-more-things-static
+++ a/arch/um/os-Linux/signal.c
@@ -125,7 +125,7 @@ void set_sigstack(void *sig_stack, int s
 		panic("enabling signal stack failed, errno = %d\n", errno);
 }
 
-void (*handlers[_NSIG])(int sig, struct sigcontext *sc);
+static void (*handlers[_NSIG])(int sig, struct sigcontext *sc);
 
 void handle_signal(int sig, struct sigcontext *sc)
 {
diff -puN arch/um/os-Linux/skas/process.c~uml-make-several-more-things-static arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-make-several-more-things-static
+++ a/arch/um/os-Linux/skas/process.c
@@ -96,7 +96,7 @@ bad_wait:
 
 extern unsigned long current_stub_stack(void);
 
-void get_skas_faultinfo(int pid, struct faultinfo * fi)
+static void get_skas_faultinfo(int pid, struct faultinfo *fi)
 {
 	int err;
 
diff -puN arch/um/os-Linux/umid.c~uml-make-several-more-things-static arch/um/os-Linux/umid.c
--- a/arch/um/os-Linux/umid.c~uml-make-several-more-things-static
+++ a/arch/um/os-Linux/umid.c
@@ -245,7 +245,7 @@ int __init set_umid(char *name)
 /* Changed in make_umid, which is called during early boot */
 static int umid_setup = 0;
 
-int __init make_umid(void)
+static int __init make_umid(void)
 {
 	int fd, err;
 	char tmp[256];
diff -puN arch/um/sys-i386/bugs.c~uml-make-several-more-things-static arch/um/sys-i386/bugs.c
--- a/arch/um/sys-i386/bugs.c~uml-make-several-more-things-static
+++ a/arch/um/sys-i386/bugs.c
@@ -12,7 +12,7 @@
 #include "sysdep/ptrace.h"
 
 /* Set during early boot */
-int host_has_cmov = 1;
+static int host_has_cmov = 1;
 static jmp_buf cmov_test_return;
 
 static void cmov_sigill_test_handler(int sig)
diff -puN arch/um/sys-i386/checksum.S~uml-make-several-more-things-static arch/um/sys-i386/checksum.S
--- a/arch/um/sys-i386/checksum.S~uml-make-several-more-things-static
+++ a/arch/um/sys-i386/checksum.S
@@ -243,13 +243,12 @@ unsigned int csum_partial_copy_generic (
 	.previous
 
 .align 4
-.globl csum_partial_copy_generic_i386
-				
+
 #ifndef CONFIG_X86_USE_PPRO_CHECKSUM
 
 #define ARGBASE 16		
 #define FP		12
-		
+
 csum_partial_copy_generic_i386:
 	subl  $4,%esp	
 	pushl %edi
diff -puN arch/um/sys-i386/ldt.c~uml-make-several-more-things-static arch/um/sys-i386/ldt.c
--- a/arch/um/sys-i386/ldt.c~uml-make-several-more-things-static
+++ a/arch/um/sys-i386/ldt.c
@@ -14,8 +14,8 @@
 
 extern int modify_ldt(int func, void *ptr, unsigned long bytecount);
 
-long write_ldt_entry(struct mm_id * mm_idp, int func, struct user_desc * desc,
-		     void **addr, int done)
+static long write_ldt_entry(struct mm_id *mm_idp, int func,
+		     struct user_desc *desc, void **addr, int done)
 {
 	long res;
 
diff -puN include/asm-um/ptrace-generic.h~uml-make-several-more-things-static include/asm-um/ptrace-generic.h
--- a/include/asm-um/ptrace-generic.h~uml-make-several-more-things-static
+++ a/include/asm-um/ptrace-generic.h
@@ -47,9 +47,6 @@ extern int set_fpregs(struct user_i387_s
 
 extern void show_regs(struct pt_regs *regs);
 
-extern void send_sigtrap(struct task_struct *tsk, struct uml_pt_regs *regs,
-			 int error_code);
