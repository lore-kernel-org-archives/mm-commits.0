From: akpm@linux-foundation.org
Subject: - h8300-update-timer-handler-misc-update.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:10:40 -0700
Message-ID: <200810182310.m9INAe4l027579@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085AbYJRXKt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:10:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     h8300: update timer handler - misc update
has been removed from the -mm tree.  Its filename was
     h8300-update-timer-handler-misc-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: h8300: update timer handler - misc update
From: Yoshinori Sato <ysato@users.sourceforge.jp>

- Update selection
- Update common timer handler
- Add support functions

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/Kconfig.cpu      |  123 ++++++++++++++--------------------
 arch/h8300/include/asm/io.h |   34 +++++++++
 arch/h8300/kernel/Makefile  |    2 
 arch/h8300/kernel/time.c    |   29 +++-----
 4 files changed, 101 insertions(+), 87 deletions(-)

diff -puN arch/h8300/Kconfig.cpu~h8300-update-timer-handler-misc-update arch/h8300/Kconfig.cpu
--- a/arch/h8300/Kconfig.cpu~h8300-update-timer-handler-misc-update
+++ a/arch/h8300/Kconfig.cpu
@@ -1,5 +1,7 @@
 menu "Processor type and features"
 
+source "kernel/time/Kconfig"
+
 choice
 	prompt "H8/300 platform"
 	default H8300H_GENERIC
@@ -11,6 +13,7 @@ config H8300H_GENERIC
 
 config H8300H_AKI3068NET
 	bool "AE-3068/69"
+	select CONFIG_H83068
 	help
 	  AKI-H8/3068F / AKI-H8/3069F Flashmicom LAN Board Support
 	  More Information. (Japanese Only)
@@ -21,6 +24,7 @@ config H8300H_AKI3068NET
 
 config H8300H_H8MAX
 	bool "H8MAX"
+	select CONFIG_H83068
 	help
 	  H8MAX Evaluation Board Support
 	  More Information. (Japanese Only)
@@ -28,6 +32,7 @@ config H8300H_H8MAX
 
 config H8300H_SIM
 	bool "H8/300H Simulator"
+	select CONFIG_H83007
 	help
 	  GDB Simulator Support
 	  More Information.
@@ -40,6 +45,7 @@ config H8S_GENERIC
 
 config H8S_EDOSK2674
 	bool "EDOSK-2674"
+	select CONFIG_H8S2768
 	help
 	  Renesas EDOSK-2674 Evaluation Board Support
 	  More Information.
@@ -55,44 +61,37 @@ config H8S_SIM
 
 endchoice
 
-if (H8300H_GENERIC || H8S_GENERIC)
-menu "Detail Selection"
-if (H8300H_GENERIC)
 choice
 	prompt "CPU Selection"
 
 config H83002
 	bool "H8/3001,3002,3003"
+	select CPU_H8300H
 
 config H83007
 	bool "H8/3006,3007"
+	select CPU_H8300H
 
 config H83048
 	bool "H8/3044,3045,3046,3047,3048,3052"
+	select CPU_H8300H
 
 config H83068
 	bool "H8/3065,3066,3067,3068,3069"
-endchoice
-endif
-
-if (H8S_GENERIC)
-choice
-	prompt "CPU Selection"
+	select CPU_H8300H
 
 config H8S2678
 	bool "H8S/2670,2673,2674R,2675,2676"
+	select CPU_H8S
+
 endchoice
-endif
 
 config CPU_CLOCK
 	int "CPU Clock Frequency (/1KHz)"
 	default "20000"
 	help
 	  CPU Clock Frequency divide to 1000
-endmenu
-endif
 
-if (H8300H_GENERIC || H8S_GENERIC || H8300H_SIM || H8S_SIM || H8S_EDOSK2674)
 choice
 	prompt "Kernel executes from"
 	---help---
@@ -107,75 +106,61 @@ config ROMKERNEL
 	bool "ROM"
 	help
 	  The kernel will be resident in FLASH/ROM when running.
-
 endchoice
-endif
 
-if (H8300H_AKI3068NET)
-config H83068
-	bool
-	default y
 
-config CPU_CLOCK
-	int
-	default "20000"
-
-config RAMKERNEL
-	bool
-	default y
-endif
-
-if (H8300H_H8MAX)
-config H83068
-	bool
-	default y
-
-config CPU_CLOCK
-	int
-	default 25000
-
-config RAMKERNEL
+config CPU_H8300H
 	bool
+	depends on (H83002 || H83007 || H83048 || H83068)
 	default y
-endif
 
-if (H8300H_SIM)
-config H83007
+config CPU_H8S
 	bool
+	depends on H8S2678
 	default y
 
-config CPU_CLOCK
-	int
-	default "16000"
-endif
+choice
+	prompt "Timer"
+config H8300_TIMER8
+	bool "8bit timer (2ch cascade)"
+	depends on (H83007 || H83068 || H8S2678)
+
+config H8300_TIMER16
+	bool "16bit timer"
+	depends on (H83007 || H83068)
+
+config H8300_ITU
+	bool "ITU"
+	depends on (H83002 || H83048)
 
-if (H8S_EDOSK2674)
-config H8S2678
-	bool
-	default y
-config CPU_CLOCK
-	int
-	default 33000
-endif
+config H8300_TPU
+	bool "TPU"
+	depends on H8S2678
+endchoice
 
-if (H8S_SIM)
-config H8S2678
-	bool
-	default y
-config CPU_CLOCK
-	int
-	default 33000
+if H8300_TIMER8
+choice
+	prompt "Timer Channel"
+config H8300_TIMER8_CH0
+	bool "Channel 0"
+config H8300_TIMER8_CH2
+	bool "Channel 2"
+	depends on CPU_H8300H
+endchoice
 endif
 
-config CPU_H8300H
-	bool
-	depends on (H83002 || H83007 || H83048 || H83068)
-	default y
-
-config CPU_H8S
-	bool
-	depends on H8S2678
-	default y
+config H8300_TIMER16_CH
+	int "16bit timer channel (0 - 2)"
+	depends on H8300_TIMER16
+	range 0 2
+
+config H8300_ITU_CH
+	int "ITU channel"
+	depends on H8300_ITU
+
+config H8300_TPU_CH
+	int "TPU channel"
+	depends on H8300_TPU
 
 config PREEMPT
 	bool "Preemptible Kernel"
diff -puN arch/h8300/include/asm/io.h~h8300-update-timer-handler-misc-update arch/h8300/include/asm/io.h
--- a/arch/h8300/include/asm/io.h~h8300-update-timer-handler-misc-update
+++ a/arch/h8300/include/asm/io.h
@@ -295,6 +295,40 @@ static __inline__ void ctrl_outl(unsigne
         *(volatile unsigned long*)addr = b;
 }
 
+static __inline__ void ctrl_bclr(int b, unsigned long addr)
+{
+	if (__builtin_constant_p(b))
+		switch (b) {
+		case 0: __asm__("bclr #0,@%0"::"r"(addr)); break;
+		case 1: __asm__("bclr #1,@%0"::"r"(addr)); break;
+		case 2: __asm__("bclr #2,@%0"::"r"(addr)); break;
+		case 3: __asm__("bclr #3,@%0"::"r"(addr)); break;
+		case 4: __asm__("bclr #4,@%0"::"r"(addr)); break;
+		case 5: __asm__("bclr #5,@%0"::"r"(addr)); break;
+		case 6: __asm__("bclr #6,@%0"::"r"(addr)); break;
+		case 7: __asm__("bclr #7,@%0"::"r"(addr)); break;
+		}
+	else
+		__asm__("bclr %w0,@%1"::"r"(b), "r"(addr));
+}
+
+static __inline__ void ctrl_bset(int b, unsigned long addr)
+{
+	if (__builtin_constant_p(b))
+		switch (b) {
+		case 0: __asm__("bset #0,@%0"::"r"(addr)); break;
+		case 1: __asm__("bset #1,@%0"::"r"(addr)); break;
+		case 2: __asm__("bset #2,@%0"::"r"(addr)); break;
+		case 3: __asm__("bset #3,@%0"::"r"(addr)); break;
+		case 4: __asm__("bset #4,@%0"::"r"(addr)); break;
+		case 5: __asm__("bset #5,@%0"::"r"(addr)); break;
+		case 6: __asm__("bset #6,@%0"::"r"(addr)); break;
+		case 7: __asm__("bset #7,@%0"::"r"(addr)); break;
+		}
+	else
+		__asm__("bset %w0,@%1"::"r"(b), "r"(addr));
+}
+
 /* Pages to physical address... */
 #define page_to_phys(page)      ((page - mem_map) << PAGE_SHIFT)
 #define page_to_bus(page)       ((page - mem_map) << PAGE_SHIFT)
diff -puN arch/h8300/kernel/Makefile~h8300-update-timer-handler-misc-update arch/h8300/kernel/Makefile
--- a/arch/h8300/kernel/Makefile~h8300-update-timer-handler-misc-update
+++ a/arch/h8300/kernel/Makefile
@@ -7,6 +7,6 @@ extra-y := vmlinux.lds
 obj-y := process.o traps.o ptrace.o irq.o \
 	 sys_h8300.o time.o signal.o \
          setup.o gpio.o init_task.o syscalls.o \
-	 entry.o
+	 entry.o timer/
 
 obj-$(CONFIG_MODULES) += module.o h8300_ksyms.o 
diff -puN arch/h8300/kernel/time.c~h8300-update-timer-handler-misc-update arch/h8300/kernel/time.c
--- a/arch/h8300/kernel/time.c~h8300-update-timer-handler-misc-update
+++ a/arch/h8300/kernel/time.c
@@ -27,27 +27,21 @@
 #include <linux/profile.h>
 
 #include <asm/io.h>
-#include <asm/target_time.h>
+#include <asm/timer.h>
 
 #define	TICK_SIZE (tick_nsec / 1000)
 
-/*
- * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
- */
-static void timer_interrupt(int irq, void *dummy, struct pt_regs * regs)
+void h8300_timer_tick(void)
 {
-	/* may need to kick the hardware timer */
-	platform_timer_eoi();
-
+	if (current->pid)
+		profile_tick(CPU_PROFILING);
+	write_seqlock(&xtime_lock);
 	do_timer(1);
-#ifndef CONFIG_SMP
-	update_process_times(user_mode(regs));
-#endif
-	profile_tick(CPU_PROFILING);
+	write_sequnlock(&xtime_lock);
+	update_process_times(user_mode(get_irq_regs()));
 }
 
-void time_init(void)
+void __init time_init(void)
 {
 	unsigned int year, mon, day, hour, min, sec;
 
@@ -57,12 +51,13 @@ void time_init(void)
 	year = 1980;
 	mon = day = 1;
 	hour = min = sec = 0;
-	platform_gettod (&year, &mon, &day, &hour, &min, &sec);
