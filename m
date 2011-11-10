From: akpm@linux-foundation.org
Subject: + treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch added to -mm tree
Date: Thu, 10 Nov 2011 14:37:56 -0800
Message-ID: <201111102237.pAAMbuUk007330@wpaz13.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:65158 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab1KJWiA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Nov 2011 17:38:00 -0500
Received: by ywb5 with SMTP id 5so249382ywb.1
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2011 14:37:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, benh@kernel.crashing.org, cmetcalf@tilera.com, egtvedt@samfundet.no, fenghua.yu@intel.com, geert@linux-m68k.org, heiko.carstens@de.ibm.com, hskinnemoen@gmail.com, mingo@elte.hu, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org, schwidefsky@de.ibm.com, tony.luck@intel.com


The patch titled
     Subject: treewide: convert uses of ATTRIB_NORETURN to __noreturn
has been added to the -mm tree.  Its filename is
     treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch

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
From: Joe Perches <joe@perches.com>
Subject: treewide: convert uses of ATTRIB_NORETURN to __noreturn

Use the more commonly used __noreturn instead of ATTRIB_NORETURN.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/machine_kexec.c       |    2 +-
 arch/m68k/amiga/config.c               |    2 +-
 arch/mips/include/asm/ptrace.h         |    2 +-
 arch/mips/kernel/traps.c               |    2 +-
 arch/mn10300/include/asm/exceptions.h  |    2 +-
 arch/powerpc/kernel/machine_kexec_32.c |    2 +-
 arch/powerpc/kernel/machine_kexec_64.c |    2 +-
 arch/s390/include/asm/processor.h      |    2 +-
 arch/sh/kernel/process_32.c            |    2 +-
 arch/sh/kernel/process_64.c            |    2 +-
 arch/tile/kernel/machine_kexec.c       |    2 +-
 include/linux/kernel.h                 |    6 +++---
 12 files changed, 14 insertions(+), 14 deletions(-)

diff -puN arch/ia64/kernel/machine_kexec.c~treewide-convert-uses-of-attrib_noreturn-to-__noreturn arch/ia64/kernel/machine_kexec.c
--- a/arch/ia64/kernel/machine_kexec.c~treewide-convert-uses-of-attrib_noreturn-to-__noreturn
+++ a/arch/ia64/kernel/machine_kexec.c
@@ -31,7 +31,7 @@ typedef void (*relocate_new_kernel_t)(
 					unsigned long indirection_page,
 					unsigned long start_address,
 					struct ia64_boot_param *boot_param,
-					unsigned long pal_addr) ATTRIB_NORET;
+					unsigned long pal_addr) __noreturn;
 
 struct kimage *ia64_kimage;
 
diff -puN arch/m68k/amiga/config.c~treewide-convert-uses-of-attrib_noreturn-to-__noreturn arch/m68k/amiga/config.c
--- a/arch/m68k/amiga/config.c~treewide-convert-uses-of-attrib_noreturn-to-__noreturn
+++ a/arch/m68k/amiga/config.c
@@ -512,7 +512,7 @@ static unsigned long amiga_gettimeoffset
 }
 
 static void amiga_reset(void)
-    ATTRIB_NORET;
+    __noreturn;
 
 static void amiga_reset(void)
 {
diff -puN arch/mips/include/asm/ptrace.h~treewide-convert-uses-of-attrib_noreturn-to-__noreturn arch/mips/include/asm/ptrace.h
--- a/arch/mips/include/asm/ptrace.h~treewide-convert-uses-of-attrib_noreturn-to-__noreturn
+++ a/arch/mips/include/asm/ptrace.h
@@ -144,7 +144,7 @@ extern int ptrace_set_watch_regs(struct 
 extern asmlinkage void syscall_trace_enter(struct pt_regs *regs);
 extern asmlinkage void syscall_trace_leave(struct pt_regs *regs);
 
-extern void die(const char *, struct pt_regs *) ATTRIB_NORET;
+extern void die(const char *, struct pt_regs *) __noreturn;
 
 static inline void die_if_kernel(const char *str, struct pt_regs *regs)
 {
diff -puN arch/mips/kernel/traps.c~treewide-convert-uses-of-attrib_noreturn-to-__noreturn arch/mips/kernel/traps.c
--- a/arch/mips/kernel/traps.c~treewide-convert-uses-of-attrib_noreturn-to-__noreturn
+++ a/arch/mips/kernel/traps.c
@@ -1340,7 +1340,7 @@ void ejtag_exception_handler(struct pt_r
 /*
  * NMI exception handler.
  */
-void ATTRIB_NORET nmi_exception_handler(struct pt_regs *regs)
+void __noreturn nmi_exception_handler(struct pt_regs *regs)
 {
 	bust_spinlocks(1);
 	printk("NMI taken!!!!\n");
diff -puN arch/mn10300/include/asm/exceptions.h~treewide-convert-uses-of-attrib_noreturn-to-__noreturn arch/mn10300/include/asm/exceptions.h
--- a/arch/mn10300/include/asm/exceptions.h~treewide-convert-uses-of-attrib_noreturn-to-__noreturn
+++ a/arch/mn10300/include/asm/exceptions.h
@@ -110,7 +110,7 @@ extern asmlinkage void nmi_handler(void)
 extern asmlinkage void misalignment(struct pt_regs *, enum exception_code);
 
 extern void die(const char *, struct pt_regs *, enum exception_code)
-	ATTRIB_NORET;
+	__noreturn;
 
 extern int die_if_no_fixup(const char *, struct pt_regs *, enum exception_code);
 
diff -puN arch/powerpc/kernel/machine_kexec_32.c~treewide-convert-uses-of-attrib_noreturn-to-__noreturn arch/powerpc/kernel/machine_kexec_32.c
--- a/arch/powerpc/kernel/machine_kexec_32.c~treewide-convert-uses-of-attrib_noreturn-to-__noreturn
+++ a/arch/powerpc/kernel/machine_kexec_32.c
@@ -19,7 +19,7 @@
 typedef void (*relocate_new_kernel_t)(
 				unsigned long indirection_page,
 				unsigned long reboot_code_buffer,
-				unsigned long start_address) ATTRIB_NORET;
+				unsigned long start_address) __noreturn;
 
 /*
  * This is a generic machine_kexec function suitable at least for
diff -puN arch/powerpc/kernel/machine_kexec_64.c~treewide-convert-uses-of-attrib_noreturn-to-__noreturn arch/powerpc/kernel/machine_kexec_64.c
--- a/arch/powerpc/kernel/machine_kexec_64.c~treewide-convert-uses-of-attrib_noreturn-to-__noreturn
+++ a/arch/powerpc/kernel/machine_kexec_64.c
@@ -309,7 +309,7 @@ struct paca_struct kexec_paca;
 /* Our assembly helper, in kexec_stub.S */
 extern void kexec_sequence(void *newstack, unsigned long start,
 			   void *image, void *control,
-			   void (*clear_all)(void)) ATTRIB_NORET;
+			   void (*clear_all)(void)) __noreturn;
 
 /* too late to fail here */
 void default_machine_kexec(struct kimage *image)
diff -puN arch/s390/include/asm/processor.h~treewide-convert-uses-of-attrib_noreturn-to-__noreturn arch/s390/include/asm/processor.h
--- a/arch/s390/include/asm/processor.h~treewide-convert-uses-of-attrib_noreturn-to-__noreturn
+++ a/arch/s390/include/asm/processor.h
@@ -238,7 +238,7 @@ static inline unsigned long __rewind_psw
 /*
  * Function to drop a processor into disabled wait state
  */
-static inline void ATTRIB_NORET disabled_wait(unsigned long code)
+static inline void __noreturn disabled_wait(unsigned long code)
 {
         unsigned long ctl_buf;
         psw_t dw_psw;
diff -puN arch/sh/kernel/process_32.c~treewide-convert-uses-of-attrib_noreturn-to-__noreturn arch/sh/kernel/process_32.c
--- a/arch/sh/kernel/process_32.c~treewide-convert-uses-of-attrib_noreturn-to-__noreturn
+++ a/arch/sh/kernel/process_32.c
@@ -70,7 +70,7 @@ void show_regs(struct pt_regs * regs)
 /*
  * Create a kernel thread
  */
-ATTRIB_NORET void kernel_thread_helper(void *arg, int (*fn)(void *))
+__noreturn void kernel_thread_helper(void *arg, int (*fn)(void *))
 {
 	do_exit(fn(arg));
 }
diff -puN arch/sh/kernel/process_64.c~treewide-convert-uses-of-attrib_noreturn-to-__noreturn arch/sh/kernel/process_64.c
--- a/arch/sh/kernel/process_64.c~treewide-convert-uses-of-attrib_noreturn-to-__noreturn
+++ a/arch/sh/kernel/process_64.c
@@ -285,7 +285,7 @@ void show_regs(struct pt_regs *regs)
 /*
  * Create a kernel thread
  */
-ATTRIB_NORET void kernel_thread_helper(void *arg, int (*fn)(void *))
+__noreturn void kernel_thread_helper(void *arg, int (*fn)(void *))
 {
 	do_exit(fn(arg));
 }
diff -puN arch/tile/kernel/machine_kexec.c~treewide-convert-uses-of-attrib_noreturn-to-__noreturn arch/tile/kernel/machine_kexec.c
--- a/arch/tile/kernel/machine_kexec.c~treewide-convert-uses-of-attrib_noreturn-to-__noreturn
+++ a/arch/tile/kernel/machine_kexec.c
@@ -252,7 +252,7 @@ void machine_kexec(struct kimage *image)
 {
 	void *reboot_code_buffer;
 	void (*rnk)(unsigned long, void *, unsigned long)
-		ATTRIB_NORET;
+		__noreturn;
 
 	/* Mask all interrupts before starting to reboot. */
 	interrupt_mask_set_mask(~0ULL);
diff -puN include/linux/kernel.h~treewide-convert-uses-of-attrib_noreturn-to-__noreturn include/linux/kernel.h
--- a/include/linux/kernel.h~treewide-convert-uses-of-attrib_noreturn-to-__noreturn
+++ a/include/linux/kernel.h
@@ -187,15 +187,15 @@ extern struct atomic_notifier_head panic
 extern long (*panic_blink)(int state);
 __printf(1, 2)
 void panic(const char *fmt, ...)
-	ATTRIB_NORET __cold;
+	__noreturn __cold;
 extern void oops_enter(void);
 extern void oops_exit(void);
 void print_oops_end_marker(void);
 extern int oops_may_print(void);
 void do_exit(long error_code)
-	ATTRIB_NORET;
+	__noreturn;
 void complete_and_exit(struct completion *, long)
-	ATTRIB_NORET;
+	__noreturn;
 
 /* Internal, do not use. */
 int __must_check _kstrtoul(const char *s, unsigned int base, unsigned long *res);
_
Subject: Subject: treewide: convert uses of ATTRIB_NORETURN to __noreturn

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch
kernelh-neaten-panic-prototype.patch
linkage-remove-unused-noret_and-macro.patch
treewide-remove-useless-noret_type-macro-and-uses.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
linkage-remove-unused-attrib_noret-macro.patch
checkpatch-update-signature-might-be-better-as-warning.patch

