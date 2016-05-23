From: akpm@linux-foundation.org
Subject: [merged] exit_thread-remove-empty-bodies.patch removed from -mm
 tree
Date: Mon, 23 May 2016 12:48:10 -0700
Message-ID: <57435e7a.3Cc1l+nmUaP4fuNX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37655 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbcEWTsO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:48:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, a-jacquiot@ti.com, benh@kernel.crashing.org, catalin.marinas@arm.com, chris@zankel.net, cmetcalf@mellanox.com, dalias@libc.org, davem@davemloft.net, deller@gmx.de, dhowells@redhat.com, egtvedt@samfundet.no, fenghua.yu@intel.com, geert@linux-m68k.org, gxt@mprc.pku.edu.cn, heiko.carstens@de.ibm.com, hpa@zytor.com, hskinnemoen@gmail.com, ink@jurassic.park.msu.ru, james.hogan@imgtec.com, jcmvbkbc@gmail.com, jdike@addtoit.com, jejb@parisc-linux.org, jesper.nilsson@axis.com, jonas@southpole.se, lennox.wu@gmail.com, lftan@altera.com, linux@arm.linux.org.uk, liqin.linux@gmail.com, mattst88@gmail.com, mingo@redhat.com, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org, realmz6@gmail.com, richard@nod.at, rkuo@codeaurora.org, rth@twiddle.net, schwidefsky@de.ibm.com, starvik@axis.com, tglx@linutroni


The patch titled
     Subject: exit_thread: remove empty bodies
has been removed from the -mm tree.  Its filename was
     exit_thread-remove-empty-bodies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiri Slaby <jslaby@suse.cz>
Subject: exit_thread: remove empty bodies

Define HAVE_EXIT_THREAD for archs which want to do something in
exit_thread. For others, let's define exit_thread as an empty inline.

This is a cleanup before we change the prototype of exit_thread to
accept a task parameter.

[akpm@linux-foundation.org: fix mips]
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Howells <dhowells@redhat.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Ley Foon Tan <lftan@altera.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig                            |    5 +++++
 arch/alpha/kernel/process.c             |    8 --------
 arch/arc/kernel/process.c               |    7 -------
 arch/arm/Kconfig                        |    1 +
 arch/arm64/kernel/process.c             |    7 -------
 arch/avr32/Kconfig                      |    1 +
 arch/blackfin/include/asm/processor.h   |    7 -------
 arch/c6x/kernel/process.c               |    4 ----
 arch/cris/Kconfig                       |    1 +
 arch/cris/arch-v10/kernel/process.c     |    9 ---------
 arch/frv/include/asm/processor.h        |    7 -------
 arch/h8300/include/asm/processor.h      |    7 -------
 arch/hexagon/kernel/process.c           |    7 -------
 arch/ia64/Kconfig                       |    1 +
 arch/m32r/kernel/process.c              |    9 ---------
 arch/m68k/include/asm/processor.h       |    7 -------
 arch/metag/Kconfig                      |    1 +
 arch/metag/include/asm/processor.h      |    2 --
 arch/microblaze/include/asm/processor.h |   10 ----------
 arch/mips/kernel/process.c              |    4 ----
 arch/mn10300/Kconfig                    |    1 +
 arch/nios2/include/asm/processor.h      |    5 -----
 arch/openrisc/include/asm/processor.h   |    9 ---------
 arch/parisc/kernel/process.c            |    7 -------
 arch/powerpc/kernel/process.c           |    4 ----
 arch/s390/Kconfig                       |    1 +
 arch/score/kernel/process.c             |    2 --
 arch/sh/Kconfig                         |    1 +
 arch/sh/kernel/process_32.c             |    7 -------
 arch/sparc/Kconfig                      |    1 +
 arch/tile/Kconfig                       |    1 +
 arch/um/kernel/process.c                |    4 ----
 arch/unicore32/kernel/process.c         |    7 -------
 arch/x86/Kconfig                        |    1 +
 arch/xtensa/Kconfig                     |    1 +
 include/linux/sched.h                   |    7 +++++++
 36 files changed, 24 insertions(+), 140 deletions(-)

diff -puN arch/Kconfig~exit_thread-remove-empty-bodies arch/Kconfig
--- a/arch/Kconfig~exit_thread-remove-empty-bodies
+++ a/arch/Kconfig
@@ -517,6 +517,11 @@ config HAVE_ARCH_MMAP_RND_BITS
 	  - ARCH_MMAP_RND_BITS_MIN
 	  - ARCH_MMAP_RND_BITS_MAX
 
+config HAVE_EXIT_THREAD
+	bool
+	help
+	  An architecture implements exit_thread.
+
 config ARCH_MMAP_RND_BITS_MIN
 	int
 
diff -puN arch/alpha/kernel/process.c~exit_thread-remove-empty-bodies arch/alpha/kernel/process.c
--- a/arch/alpha/kernel/process.c~exit_thread-remove-empty-bodies
+++ a/arch/alpha/kernel/process.c
@@ -210,14 +210,6 @@ start_thread(struct pt_regs * regs, unsi
 }
 EXPORT_SYMBOL(start_thread);
 
-/*
- * Free current thread data structures etc..
- */
-void
-exit_thread(void)
-{
-}
-
 void
 flush_thread(void)
 {
diff -puN arch/arc/kernel/process.c~exit_thread-remove-empty-bodies arch/arc/kernel/process.c
--- a/arch/arc/kernel/process.c~exit_thread-remove-empty-bodies
+++ a/arch/arc/kernel/process.c
@@ -183,13 +183,6 @@ void flush_thread(void)
 {
 }
 
-/*
- * Free any architecture-specific thread data structures, etc.
- */
-void exit_thread(void)
-{
-}
-
 int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fpu)
 {
 	return 0;
diff -puN arch/arm/Kconfig~exit_thread-remove-empty-bodies arch/arm/Kconfig
--- a/arch/arm/Kconfig~exit_thread-remove-empty-bodies
+++ a/arch/arm/Kconfig
@@ -50,6 +50,7 @@ config ARM
 	select HAVE_DMA_CONTIGUOUS if MMU
 	select HAVE_DYNAMIC_FTRACE if (!XIP_KERNEL) && !CPU_ENDIAN_BE32 && MMU
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS if (CPU_V6 || CPU_V6K || CPU_V7) && MMU
+	select HAVE_EXIT_THREAD
 	select HAVE_FTRACE_MCOUNT_RECORD if (!XIP_KERNEL)
 	select HAVE_FUNCTION_GRAPH_TRACER if (!THUMB2_KERNEL)
 	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
diff -puN arch/arm64/kernel/process.c~exit_thread-remove-empty-bodies arch/arm64/kernel/process.c
--- a/arch/arm64/kernel/process.c~exit_thread-remove-empty-bodies
+++ a/arch/arm64/kernel/process.c
@@ -200,13 +200,6 @@ void show_regs(struct pt_regs * regs)
 	__show_regs(regs);
 }
 
-/*
- * Free current thread data structures etc..
- */
-void exit_thread(void)
-{
-}
-
 static void tls_thread_flush(void)
 {
 	asm ("msr tpidr_el0, xzr");
diff -puN arch/avr32/Kconfig~exit_thread-remove-empty-bodies arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~exit_thread-remove-empty-bodies
+++ a/arch/avr32/Kconfig
@@ -4,6 +4,7 @@ config AVR32
 	# that we usually don't need on AVR32.
 	select EXPERT
 	select HAVE_CLK
+	select HAVE_EXIT_THREAD
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select VIRT_TO_BUS
diff -puN arch/blackfin/include/asm/processor.h~exit_thread-remove-empty-bodies arch/blackfin/include/asm/processor.h
--- a/arch/blackfin/include/asm/processor.h~exit_thread-remove-empty-bodies
+++ a/arch/blackfin/include/asm/processor.h
@@ -76,13 +76,6 @@ static inline void release_thread(struct
 }
 
 /*
- * Free current thread data structures etc..
- */
-static inline void exit_thread(void)
-{
-}
-
-/*
  * Return saved PC of a blocked thread.
  */
 #define thread_saved_pc(tsk)	(tsk->thread.pc)
diff -puN arch/c6x/kernel/process.c~exit_thread-remove-empty-bodies arch/c6x/kernel/process.c
--- a/arch/c6x/kernel/process.c~exit_thread-remove-empty-bodies
+++ a/arch/c6x/kernel/process.c
@@ -82,10 +82,6 @@ void flush_thread(void)
 {
 }
 
-void exit_thread(void)
-{
-}
-
 /*
  * Do necessary setup to start up a newly executed thread.
  */
diff -puN arch/cris/Kconfig~exit_thread-remove-empty-bodies arch/cris/Kconfig
--- a/arch/cris/Kconfig~exit_thread-remove-empty-bodies
+++ a/arch/cris/Kconfig
@@ -59,6 +59,7 @@ config CRIS
 	select GENERIC_IOMAP
 	select MODULES_USE_ELF_RELA
 	select CLONE_BACKWARDS2
+	select HAVE_EXIT_THREAD if ETRAX_ARCH_V32
 	select OLD_SIGSUSPEND
 	select OLD_SIGACTION
 	select GPIOLIB
diff -puN arch/cris/arch-v10/kernel/process.c~exit_thread-remove-empty-bodies arch/cris/arch-v10/kernel/process.c
--- a/arch/cris/arch-v10/kernel/process.c~exit_thread-remove-empty-bodies
+++ a/arch/cris/arch-v10/kernel/process.c
@@ -35,15 +35,6 @@ void default_idle(void)
 	local_irq_enable();
 }
 
-/*
- * Free current thread data structures etc..
- */
-
-void exit_thread(void)
-{
-	/* Nothing needs to be done.  */
-}
-
 /* if the watchdog is enabled, we can simply disable interrupts and go
  * into an eternal loop, and the watchdog will reset the CPU after 0.1s
  * if on the other hand the watchdog wasn't enabled, we just enable it and wait
diff -puN arch/frv/include/asm/processor.h~exit_thread-remove-empty-bodies arch/frv/include/asm/processor.h
--- a/arch/frv/include/asm/processor.h~exit_thread-remove-empty-bodies
+++ a/arch/frv/include/asm/processor.h
@@ -97,13 +97,6 @@ extern asmlinkage void *restore_user_reg
 #define forget_segments()		do { } while (0)
 
 /*
- * Free current thread data structures etc..
- */
-static inline void exit_thread(void)
-{
-}
-
-/*
  * Return saved PC of a blocked thread.
  */
 extern unsigned long thread_saved_pc(struct task_struct *tsk);
diff -puN arch/h8300/include/asm/processor.h~exit_thread-remove-empty-bodies arch/h8300/include/asm/processor.h
--- a/arch/h8300/include/asm/processor.h~exit_thread-remove-empty-bodies
+++ a/arch/h8300/include/asm/processor.h
@@ -111,13 +111,6 @@ static inline void release_thread(struct
 }
 
 /*
- * Free current thread data structures etc..
- */
-static inline void exit_thread(void)
-{
-}
-
-/*
  * Return saved PC of a blocked thread.
  */
 unsigned long thread_saved_pc(struct task_struct *tsk);
diff -puN arch/hexagon/kernel/process.c~exit_thread-remove-empty-bodies arch/hexagon/kernel/process.c
--- a/arch/hexagon/kernel/process.c~exit_thread-remove-empty-bodies
+++ a/arch/hexagon/kernel/process.c
@@ -137,13 +137,6 @@ void release_thread(struct task_struct *
 }
 
 /*
- * Free any architecture-specific thread data structures, etc.
- */
-void exit_thread(void)
-{
-}
-
-/*
  * Some archs flush debug and FPU info here
  */
 void flush_thread(void)
diff -puN arch/ia64/Kconfig~exit_thread-remove-empty-bodies arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~exit_thread-remove-empty-bodies
+++ a/arch/ia64/Kconfig
@@ -18,6 +18,7 @@ config IA64
 	select ACPI_SYSTEM_POWER_STATES_SUPPORT if ACPI
 	select ARCH_MIGHT_HAVE_ACPI_PDC if ACPI
 	select HAVE_UNSTABLE_SCHED_CLOCK
+	select HAVE_EXIT_THREAD
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
diff -puN arch/m32r/kernel/process.c~exit_thread-remove-empty-bodies arch/m32r/kernel/process.c
--- a/arch/m32r/kernel/process.c~exit_thread-remove-empty-bodies
+++ a/arch/m32r/kernel/process.c
@@ -101,15 +101,6 @@ void show_regs(struct pt_regs * regs)
 #endif
 }
 
-/*
- * Free current thread data structures etc..
- */
-void exit_thread(void)
-{
-	/* Nothing to do. */
-	DPRINTK("pid = %d\n", current->pid);
-}
-
 void flush_thread(void)
 {
 	DPRINTK("pid = %d\n", current->pid);
diff -puN arch/m68k/include/asm/processor.h~exit_thread-remove-empty-bodies arch/m68k/include/asm/processor.h
--- a/arch/m68k/include/asm/processor.h~exit_thread-remove-empty-bodies
+++ a/arch/m68k/include/asm/processor.h
@@ -153,13 +153,6 @@ static inline void release_thread(struct
 {
 }
 
-/*
- * Free current thread data structures etc..
- */
-static inline void exit_thread(void)
-{
-}
-
 extern unsigned long thread_saved_pc(struct task_struct *tsk);
 
 unsigned long get_wchan(struct task_struct *p);
diff -puN arch/metag/Kconfig~exit_thread-remove-empty-bodies arch/metag/Kconfig
--- a/arch/metag/Kconfig~exit_thread-remove-empty-bodies
+++ a/arch/metag/Kconfig
@@ -11,6 +11,7 @@ config METAG
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_DYNAMIC_FTRACE
+	select HAVE_EXIT_THREAD
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_TRACER
 	select HAVE_KERNEL_BZIP2
diff -puN arch/metag/include/asm/processor.h~exit_thread-remove-empty-bodies arch/metag/include/asm/processor.h
--- a/arch/metag/include/asm/processor.h~exit_thread-remove-empty-bodies
+++ a/arch/metag/include/asm/processor.h
@@ -134,8 +134,6 @@ static inline void release_thread(struct
 #define copy_segments(tsk, mm)		do { } while (0)
 #define release_segments(mm)		do { } while (0)
 
-extern void exit_thread(void);
-
 /*
  * Return saved PC of a blocked thread.
  */
diff -puN arch/microblaze/include/asm/processor.h~exit_thread-remove-empty-bodies arch/microblaze/include/asm/processor.h
--- a/arch/microblaze/include/asm/processor.h~exit_thread-remove-empty-bodies
+++ a/arch/microblaze/include/asm/processor.h
@@ -70,11 +70,6 @@ static inline void release_thread(struct
 {
 }
 
-/* Free all resources held by a thread. */
-static inline void exit_thread(void)
-{
-}
-
 extern unsigned long thread_saved_pc(struct task_struct *t);
 
 extern unsigned long get_wchan(struct task_struct *p);
@@ -127,11 +122,6 @@ static inline void release_thread(struct
 {
 }
 
-/* Free current thread data structures etc.  */
-static inline void exit_thread(void)
-{
-}
-
 /* Return saved (kernel) PC of a blocked thread.  */
 #  define thread_saved_pc(tsk)	\
 	((tsk)->thread.regs ? (tsk)->thread.regs->r15 : 0)
diff -puN arch/mips/kernel/process.c~exit_thread-remove-empty-bodies arch/mips/kernel/process.c
--- a/arch/mips/kernel/process.c~exit_thread-remove-empty-bodies
+++ a/arch/mips/kernel/process.c
@@ -73,10 +73,6 @@ void start_thread(struct pt_regs * regs,
 	regs->regs[29] = sp;
 }
 
-void exit_thread(void)
-{
-}
-
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
 	/*
diff -puN arch/mn10300/Kconfig~exit_thread-remove-empty-bodies arch/mn10300/Kconfig
--- a/arch/mn10300/Kconfig~exit_thread-remove-empty-bodies
+++ a/arch/mn10300/Kconfig
@@ -1,5 +1,6 @@
 config MN10300
 	def_bool y
+	select HAVE_EXIT_THREAD
 	select HAVE_OPROFILE
 	select HAVE_UID16
 	select GENERIC_IRQ_SHOW
diff -puN arch/nios2/include/asm/processor.h~exit_thread-remove-empty-bodies arch/nios2/include/asm/processor.h
--- a/arch/nios2/include/asm/processor.h~exit_thread-remove-empty-bodies
+++ a/arch/nios2/include/asm/processor.h
@@ -75,11 +75,6 @@ static inline void release_thread(struct
 {
 }
 
-/* Free current thread data structures etc.. */
-static inline void exit_thread(void)
-{
-}
-
 /* Return saved PC of a blocked thread. */
 #define thread_saved_pc(tsk)	((tsk)->thread.kregs->ea)
 
diff -puN arch/openrisc/include/asm/processor.h~exit_thread-remove-empty-bodies arch/openrisc/include/asm/processor.h
--- a/arch/openrisc/include/asm/processor.h~exit_thread-remove-empty-bodies
+++ a/arch/openrisc/include/asm/processor.h
@@ -85,15 +85,6 @@ void release_thread(struct task_struct *
 unsigned long get_wchan(struct task_struct *p);
 
 /*
- * Free current thread data structures etc..
- */
-
-extern inline void exit_thread(void)
-{
-	/* Nothing needs to be done.  */
-}
-
-/*
  * Return saved PC of a blocked thread. For now, this is the "user" PC
  */
 extern unsigned long thread_saved_pc(struct task_struct *t);
diff -puN arch/parisc/kernel/process.c~exit_thread-remove-empty-bodies arch/parisc/kernel/process.c
--- a/arch/parisc/kernel/process.c~exit_thread-remove-empty-bodies
+++ a/arch/parisc/kernel/process.c
@@ -144,13 +144,6 @@ void machine_power_off(void)
 void (*pm_power_off)(void) = machine_power_off;
 EXPORT_SYMBOL(pm_power_off);
 
-/*
- * Free current thread data structures etc..
- */
-void exit_thread(void)
-{
-}
-
 void flush_thread(void)
 {
 	/* Only needs to handle fpu stuff or perf monitors.
diff -puN arch/powerpc/kernel/process.c~exit_thread-remove-empty-bodies arch/powerpc/kernel/process.c
--- a/arch/powerpc/kernel/process.c~exit_thread-remove-empty-bodies
+++ a/arch/powerpc/kernel/process.c
@@ -1329,10 +1329,6 @@ void show_regs(struct pt_regs * regs)
 		show_instructions(regs);
 }
 
-void exit_thread(void)
-{
-}
-
 void flush_thread(void)
 {
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
diff -puN arch/s390/Kconfig~exit_thread-remove-empty-bodies arch/s390/Kconfig
--- a/arch/s390/Kconfig~exit_thread-remove-empty-bodies
+++ a/arch/s390/Kconfig
@@ -134,6 +134,7 @@ config S390
 	select HAVE_DMA_API_DEBUG
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_DYNAMIC_FTRACE_WITH_REGS
+	select HAVE_EXIT_THREAD
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACER
diff -puN arch/score/kernel/process.c~exit_thread-remove-empty-bodies arch/score/kernel/process.c
--- a/arch/score/kernel/process.c~exit_thread-remove-empty-bodies
+++ a/arch/score/kernel/process.c
@@ -56,8 +56,6 @@ void start_thread(struct pt_regs *regs,
 	regs->regs[0] = sp;
 }
 
-void exit_thread(void) {}
-
 /*
  * When a process does an "exec", machine state like FPU and debug
  * registers need to be reset.  This is a hook function for that.
diff -puN arch/sh/Kconfig~exit_thread-remove-empty-bodies arch/sh/Kconfig
--- a/arch/sh/Kconfig~exit_thread-remove-empty-bodies
+++ a/arch/sh/Kconfig
@@ -71,6 +71,7 @@ config SUPERH32
 
 config SUPERH64
 	def_bool ARCH = "sh64"
+	select HAVE_EXIT_THREAD
 	select KALLSYMS
 
 config ARCH_DEFCONFIG
diff -puN arch/sh/kernel/process_32.c~exit_thread-remove-empty-bodies arch/sh/kernel/process_32.c
--- a/arch/sh/kernel/process_32.c~exit_thread-remove-empty-bodies
+++ a/arch/sh/kernel/process_32.c
@@ -76,13 +76,6 @@ void start_thread(struct pt_regs *regs,
 }
 EXPORT_SYMBOL(start_thread);
 
-/*
- * Free current thread data structures etc..
- */
-void exit_thread(void)
-{
-}
-
 void flush_thread(void)
 {
 	struct task_struct *tsk = current;
diff -puN arch/sparc/Kconfig~exit_thread-remove-empty-bodies arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~exit_thread-remove-empty-bodies
+++ a/arch/sparc/Kconfig
@@ -20,6 +20,7 @@ config SPARC
 	select HAVE_OPROFILE
 	select HAVE_ARCH_KGDB if !SMP || SPARC64
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_EXIT_THREAD
 	select SYSCTL_EXCEPTION_TRACE
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select RTC_CLASS
diff -puN arch/tile/Kconfig~exit_thread-remove-empty-bodies arch/tile/Kconfig
--- a/arch/tile/Kconfig~exit_thread-remove-empty-bodies
+++ a/arch/tile/Kconfig
@@ -3,6 +3,7 @@
 
 config TILE
 	def_bool y
+	select HAVE_EXIT_THREAD
 	select HAVE_PERF_EVENTS
 	select USE_PMC if PERF_EVENTS
 	select HAVE_DMA_API_DEBUG
diff -puN arch/um/kernel/process.c~exit_thread-remove-empty-bodies arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~exit_thread-remove-empty-bodies
+++ a/arch/um/kernel/process.c
@@ -103,10 +103,6 @@ void interrupt_end(void)
 		tracehook_notify_resume(regs);
 }
 
-void exit_thread(void)
-{
-}
-
 int get_current_pid(void)
 {
 	return task_pid_nr(current);
diff -puN arch/unicore32/kernel/process.c~exit_thread-remove-empty-bodies arch/unicore32/kernel/process.c
--- a/arch/unicore32/kernel/process.c~exit_thread-remove-empty-bodies
+++ a/arch/unicore32/kernel/process.c
@@ -201,13 +201,6 @@ void show_regs(struct pt_regs *regs)
 	__backtrace();
 }
 
-/*
- * Free current thread data structures etc..
- */
-void exit_thread(void)
-{
-}
-
 void flush_thread(void)
 {
 	struct thread_info *thread = current_thread_info();
diff -puN arch/x86/Kconfig~exit_thread-remove-empty-bodies arch/x86/Kconfig
--- a/arch/x86/Kconfig~exit_thread-remove-empty-bodies
+++ a/arch/x86/Kconfig
@@ -105,6 +105,7 @@ config X86
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_DYNAMIC_FTRACE_WITH_REGS
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
+	select HAVE_EXIT_THREAD
 	select HAVE_FENTRY			if X86_64
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_GRAPH_FP_TEST
diff -puN arch/xtensa/Kconfig~exit_thread-remove-empty-bodies arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~exit_thread-remove-empty-bodies
+++ a/arch/xtensa/Kconfig
@@ -14,6 +14,7 @@ config XTENSA
 	select GENERIC_PCI_IOMAP
 	select GENERIC_SCHED_CLOCK
 	select HAVE_DMA_API_DEBUG
+	select HAVE_EXIT_THREAD
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUTEX_CMPXCHG if !MMU
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
diff -puN include/linux/sched.h~exit_thread-remove-empty-bodies include/linux/sched.h
--- a/include/linux/sched.h~exit_thread-remove-empty-bodies
+++ a/include/linux/sched.h
@@ -2769,7 +2769,14 @@ static inline int copy_thread_tls(
 }
 #endif
 extern void flush_thread(void);
+
+#ifdef CONFIG_HAVE_EXIT_THREAD
 extern void exit_thread(void);
+#else
+static inline void exit_thread(void)
+{
+}
+#endif
 
 extern void exit_files(struct task_struct *);
 extern void __cleanup_sighand(struct sighand_struct *);
_

Patches currently in -mm which might be from jslaby@suse.cz are

exit_thread-accept-a-task-parameter-to-be-exited.patch
fork-free-thread-in-copy_process-on-failure.patch
maintainers-remove-linux-listsopenriscnet.patch
maintainers-remove-koichi-yasutake.patch
kgdb-depends-on-vt.patch

