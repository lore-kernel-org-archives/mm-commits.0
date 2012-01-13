From: akpm@linux-foundation.org
Subject: [merged] treewide-remove-useless-noret_type-macro-and-uses.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:31:36 -0800
Message-ID: <20120113203137.517DB5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:56633 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759063Ab2AMUbk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:31:40 -0500
Received: by mail-ee0-f74.google.com with SMTP id e50so23612eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:31:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, benh@kernel.crashing.org, cmetcalf@tilera.com, egtvedt@samfundet.no, fenghua.yu@intel.com, geert@linux-m68k.org, heiko.carstens@de.ibm.com, hskinnemoen@gmail.com, mingo@elte.hu, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org, schwidefsky@de.ibm.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: treewide: remove useless NORET_TYPE macro and uses
has been removed from the -mm tree.  Its filename was
     treewide-remove-useless-noret_type-macro-and-uses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: treewide: remove useless NORET_TYPE macro and uses

It's a very old and now unused prototype marking so just delete it.

Neaten panic pointer argument style to keep checkpatch quiet.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/include/asm/system.h        |    2 +-
 arch/avr32/kernel/traps.c              |    2 +-
 arch/ia64/kernel/machine_kexec.c       |    2 +-
 arch/m68k/amiga/config.c               |    2 +-
 arch/mips/include/asm/ptrace.h         |    2 +-
 arch/mips/kernel/traps.c               |    2 +-
 arch/powerpc/kernel/machine_kexec_32.c |    2 +-
 arch/powerpc/kernel/machine_kexec_64.c |    6 +++---
 arch/s390/kernel/nmi.c                 |    2 +-
 arch/tile/kernel/machine_kexec.c       |    4 ++--
 include/linux/kernel.h                 |    6 +++---
 include/linux/linkage.h                |    1 -
 include/linux/sched.h                  |    2 +-
 kernel/exit.c                          |    6 +++---
 kernel/panic.c                         |    2 +-
 15 files changed, 21 insertions(+), 22 deletions(-)

diff -puN arch/avr32/include/asm/system.h~treewide-remove-useless-noret_type-macro-and-uses arch/avr32/include/asm/system.h
--- a/arch/avr32/include/asm/system.h~treewide-remove-useless-noret_type-macro-and-uses
+++ a/arch/avr32/include/asm/system.h
@@ -169,7 +169,7 @@ static inline unsigned long __cmpxchg_lo
 #define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
 
 struct pt_regs;
-void NORET_TYPE die(const char *str, struct pt_regs *regs, long err);
+void die(const char *str, struct pt_regs *regs, long err);
 void _exception(long signr, struct pt_regs *regs, int code,
 		unsigned long addr);
 
diff -puN arch/avr32/kernel/traps.c~treewide-remove-useless-noret_type-macro-and-uses arch/avr32/kernel/traps.c
--- a/arch/avr32/kernel/traps.c~treewide-remove-useless-noret_type-macro-and-uses
+++ a/arch/avr32/kernel/traps.c
@@ -24,7 +24,7 @@
 
 static DEFINE_SPINLOCK(die_lock);
 
-void NORET_TYPE die(const char *str, struct pt_regs *regs, long err)
+void die(const char *str, struct pt_regs *regs, long err)
 {
 	static int die_counter;
 
diff -puN arch/ia64/kernel/machine_kexec.c~treewide-remove-useless-noret_type-macro-and-uses arch/ia64/kernel/machine_kexec.c
--- a/arch/ia64/kernel/machine_kexec.c~treewide-remove-useless-noret_type-macro-and-uses
+++ a/arch/ia64/kernel/machine_kexec.c
@@ -27,7 +27,7 @@
 #include <asm/sal.h>
 #include <asm/mca.h>
 
-typedef NORET_TYPE void (*relocate_new_kernel_t)(
+typedef void (*relocate_new_kernel_t)(
 					unsigned long indirection_page,
 					unsigned long start_address,
 					struct ia64_boot_param *boot_param,
diff -puN arch/m68k/amiga/config.c~treewide-remove-useless-noret_type-macro-and-uses arch/m68k/amiga/config.c
--- a/arch/m68k/amiga/config.c~treewide-remove-useless-noret_type-macro-and-uses
+++ a/arch/m68k/amiga/config.c
@@ -511,7 +511,7 @@ static unsigned long amiga_gettimeoffset
 	return ticks + offset;
 }
 
-static NORET_TYPE void amiga_reset(void)
+static void amiga_reset(void)
     ATTRIB_NORET;
 
 static void amiga_reset(void)
diff -puN arch/mips/include/asm/ptrace.h~treewide-remove-useless-noret_type-macro-and-uses arch/mips/include/asm/ptrace.h
--- a/arch/mips/include/asm/ptrace.h~treewide-remove-useless-noret_type-macro-and-uses
+++ a/arch/mips/include/asm/ptrace.h
@@ -144,7 +144,7 @@ extern int ptrace_set_watch_regs(struct 
 extern asmlinkage void syscall_trace_enter(struct pt_regs *regs);
 extern asmlinkage void syscall_trace_leave(struct pt_regs *regs);
 
-extern NORET_TYPE void die(const char *, struct pt_regs *) ATTRIB_NORET;
+extern void die(const char *, struct pt_regs *) ATTRIB_NORET;
 
 static inline void die_if_kernel(const char *str, struct pt_regs *regs)
 {
diff -puN arch/mips/kernel/traps.c~treewide-remove-useless-noret_type-macro-and-uses arch/mips/kernel/traps.c
--- a/arch/mips/kernel/traps.c~treewide-remove-useless-noret_type-macro-and-uses
+++ a/arch/mips/kernel/traps.c
@@ -1340,7 +1340,7 @@ void ejtag_exception_handler(struct pt_r
 /*
  * NMI exception handler.
  */
-NORET_TYPE void ATTRIB_NORET nmi_exception_handler(struct pt_regs *regs)
+void ATTRIB_NORET nmi_exception_handler(struct pt_regs *regs)
 {
 	bust_spinlocks(1);
 	printk("NMI taken!!!!\n");
diff -puN arch/powerpc/kernel/machine_kexec_32.c~treewide-remove-useless-noret_type-macro-and-uses arch/powerpc/kernel/machine_kexec_32.c
--- a/arch/powerpc/kernel/machine_kexec_32.c~treewide-remove-useless-noret_type-macro-and-uses
+++ a/arch/powerpc/kernel/machine_kexec_32.c
@@ -16,7 +16,7 @@
 #include <asm/hw_irq.h>
 #include <asm/io.h>
 
-typedef NORET_TYPE void (*relocate_new_kernel_t)(
+typedef void (*relocate_new_kernel_t)(
 				unsigned long indirection_page,
 				unsigned long reboot_code_buffer,
 				unsigned long start_address) ATTRIB_NORET;
diff -puN arch/powerpc/kernel/machine_kexec_64.c~treewide-remove-useless-noret_type-macro-and-uses arch/powerpc/kernel/machine_kexec_64.c
--- a/arch/powerpc/kernel/machine_kexec_64.c~treewide-remove-useless-noret_type-macro-and-uses
+++ a/arch/powerpc/kernel/machine_kexec_64.c
@@ -307,9 +307,9 @@ static union thread_union kexec_stack __
 struct paca_struct kexec_paca;
 
 /* Our assembly helper, in kexec_stub.S */
-extern NORET_TYPE void kexec_sequence(void *newstack, unsigned long start,
-					void *image, void *control,
-					void (*clear_all)(void)) ATTRIB_NORET;
+extern void kexec_sequence(void *newstack, unsigned long start,
+			   void *image, void *control,
+			   void (*clear_all)(void)) ATTRIB_NORET;
 
 /* too late to fail here */
 void default_machine_kexec(struct kimage *image)
diff -puN arch/s390/kernel/nmi.c~treewide-remove-useless-noret_type-macro-and-uses arch/s390/kernel/nmi.c
--- a/arch/s390/kernel/nmi.c~treewide-remove-useless-noret_type-macro-and-uses
+++ a/arch/s390/kernel/nmi.c
@@ -30,7 +30,7 @@ struct mcck_struct {
 
 static DEFINE_PER_CPU(struct mcck_struct, cpu_mcck);
 
-static NORET_TYPE void s390_handle_damage(char *msg)
+static void s390_handle_damage(char *msg)
 {
 	smp_send_stop();
 	disabled_wait((unsigned long) __builtin_return_address(0));
diff -puN arch/tile/kernel/machine_kexec.c~treewide-remove-useless-noret_type-macro-and-uses arch/tile/kernel/machine_kexec.c
--- a/arch/tile/kernel/machine_kexec.c~treewide-remove-useless-noret_type-macro-and-uses
+++ a/arch/tile/kernel/machine_kexec.c
@@ -248,10 +248,10 @@ static void setup_quasi_va_is_pa(void)
 }
 
 
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 	void *reboot_code_buffer;
-	NORET_TYPE void (*rnk)(unsigned long, void *, unsigned long)
+	void (*rnk)(unsigned long, void *, unsigned long)
 		ATTRIB_NORET;
 
 	/* Mask all interrupts before starting to reboot. */
diff -puN include/linux/kernel.h~treewide-remove-useless-noret_type-macro-and-uses include/linux/kernel.h
--- a/include/linux/kernel.h~treewide-remove-useless-noret_type-macro-and-uses
+++ a/include/linux/kernel.h
@@ -185,16 +185,16 @@ static inline void might_fault(void)
 
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(int state);
-NORET_TYPE __printf(1, 2)
+__printf(1, 2)
 void panic(const char *fmt, ...)
 	ATTRIB_NORET __cold;
 extern void oops_enter(void);
 extern void oops_exit(void);
 void print_oops_end_marker(void);
 extern int oops_may_print(void);
-NORET_TYPE void do_exit(long error_code)
+void do_exit(long error_code)
 	ATTRIB_NORET;
-NORET_TYPE void complete_and_exit(struct completion *, long)
+void complete_and_exit(struct completion *, long)
 	ATTRIB_NORET;
 
 /* Internal, do not use. */
diff -puN include/linux/linkage.h~treewide-remove-useless-noret_type-macro-and-uses include/linux/linkage.h
--- a/include/linux/linkage.h~treewide-remove-useless-noret_type-macro-and-uses
+++ a/include/linux/linkage.h
@@ -88,7 +88,6 @@
 
 #endif
 
-#define NORET_TYPE    /**/
 #define ATTRIB_NORET  __attribute__((noreturn))
 
 #endif
diff -puN include/linux/sched.h~treewide-remove-useless-noret_type-macro-and-uses include/linux/sched.h
--- a/include/linux/sched.h~treewide-remove-useless-noret_type-macro-and-uses
+++ a/include/linux/sched.h
@@ -2275,7 +2275,7 @@ extern void __cleanup_sighand(struct sig
 extern void exit_itimers(struct signal_struct *);
 extern void flush_itimer_signals(void);
 
-extern NORET_TYPE void do_group_exit(int);
+extern void do_group_exit(int);
 
 extern void daemonize(const char *, ...);
 extern int allow_signal(int);
diff -puN kernel/exit.c~treewide-remove-useless-noret_type-macro-and-uses kernel/exit.c
--- a/kernel/exit.c~treewide-remove-useless-noret_type-macro-and-uses
+++ a/kernel/exit.c
@@ -887,7 +887,7 @@ static void check_stack_usage(void)
 static inline void check_stack_usage(void) {}
 #endif
 
-NORET_TYPE void do_exit(long code)
+void do_exit(long code)
 {
 	struct task_struct *tsk = current;
 	int group_dead;
@@ -1051,7 +1051,7 @@ NORET_TYPE void do_exit(long code)
 
 EXPORT_SYMBOL_GPL(do_exit);
 
-NORET_TYPE void complete_and_exit(struct completion *comp, long code)
+void complete_and_exit(struct completion *comp, long code)
 {
 	if (comp)
 		complete(comp);
@@ -1070,7 +1070,7 @@ SYSCALL_DEFINE1(exit, int, error_code)
  * Take down every thread in the group.  This is called by fatal signals
  * as well as by sys_exit_group (below).
  */
-NORET_TYPE void
+void
 do_group_exit(int exit_code)
 {
 	struct signal_struct *sig = current->signal;
diff -puN kernel/panic.c~treewide-remove-useless-noret_type-macro-and-uses kernel/panic.c
--- a/kernel/panic.c~treewide-remove-useless-noret_type-macro-and-uses
+++ a/kernel/panic.c
@@ -57,7 +57,7 @@ EXPORT_SYMBOL(panic_blink);
  *
  *	This function never returns.
  */
-NORET_TYPE void panic(const char * fmt, ...)
+void panic(const char *fmt, ...)
 {
 	static char buf[1024];
 	va_list args;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch

