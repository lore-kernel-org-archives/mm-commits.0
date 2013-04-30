From: akpm@linux-foundation.org
Subject: [merged] early_printk-consolidate-random-copies-of-identical-code.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:50:54 -0700
Message-ID: <20130430185054.A588831C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:34635 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab3D3Su4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:50:56 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so86194qen.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:50:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, benh@kernel.crashing.org, cmetcalf@tilera.com, davem@davemloft.net, geert@linux-m68k.org, lethal@linux-sh.org, linux@arm.linux.org.uk, mingo@kernel.org, monstr@monstr.eu, paul.gortmaker@windriver.com, ralf@linux-mips.org, richard@nod.at, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     Subject: early_printk: consolidate random copies of identical code
has been removed from the -mm tree.  Its filename was
     early_printk-consolidate-random-copies-of-identical-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thomas Gleixner <tglx@linutronix.de>
Subject: early_printk: consolidate random copies of identical code

The early console implementations are the same all over the place.  Move
the print function to kernel/printk and get rid of the copies.

[akpm@linux-foundation.org: arch/mips/kernel/early_printk.c needs kernel.h for va_list]
[paul.gortmaker@windriver.com: sh4: make the bios early console support depend on EARLY_PRINTK]
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Russell King <linux@arm.linux.org.uk>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Richard Weinberger <richard@nod.at>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/early_printk.c        |   17 ++-----------
 arch/blackfin/kernel/early_printk.c   |    2 -
 arch/microblaze/kernel/early_printk.c |   26 +++-----------------
 arch/mips/kernel/early_printk.c       |   12 ++++-----
 arch/powerpc/kernel/udbg.c            |    6 +---
 arch/sh/kernel/sh_bios.c              |    4 +--
 arch/tile/kernel/early_printk.c       |   27 ++++-----------------
 arch/um/kernel/early_printk.c         |    8 ++++--
 arch/unicore32/kernel/early_printk.c  |   12 +++------
 arch/x86/kernel/early_printk.c        |   21 +---------------
 include/linux/console.h               |    1 
 include/linux/printk.h                |    6 ++++
 kernel/printk.c                       |   30 ++++++++++++++++++------
 13 files changed, 63 insertions(+), 109 deletions(-)

diff -puN arch/arm/kernel/early_printk.c~early_printk-consolidate-random-copies-of-identical-code arch/arm/kernel/early_printk.c
--- a/arch/arm/kernel/early_printk.c~early_printk-consolidate-random-copies-of-identical-code
+++ a/arch/arm/kernel/early_printk.c
@@ -29,28 +29,17 @@ static void early_console_write(struct c
 	early_write(s, n);
 }
 
-static struct console early_console = {
+static struct console early_console_dev = {
 	.name =		"earlycon",
 	.write =	early_console_write,
 	.flags =	CON_PRINTBUFFER | CON_BOOT,
 	.index =	-1,
 };
 
-asmlinkage void early_printk(const char *fmt, ...)
-{
-	char buf[512];
-	int n;
-	va_list ap;
-
-	va_start(ap, fmt);
-	n = vscnprintf(buf, sizeof(buf), fmt, ap);
-	early_write(buf, n);
-	va_end(ap);
-}
-
 static int __init setup_early_printk(char *buf)
 {
-	register_console(&early_console);
+	early_console = &early_console_dev;
+	register_console(&early_console_dev);
 	return 0;
 }
 
diff -puN arch/blackfin/kernel/early_printk.c~early_printk-consolidate-random-copies-of-identical-code arch/blackfin/kernel/early_printk.c
--- a/arch/blackfin/kernel/early_printk.c~early_printk-consolidate-random-copies-of-identical-code
+++ a/arch/blackfin/kernel/early_printk.c
@@ -25,8 +25,6 @@ extern struct console *bfin_earlyserial_
 extern struct console *bfin_jc_early_init(void);
 #endif
 
-static struct console *early_console;
-
 /* Default console */
 #define DEFAULT_PORT 0
 #define DEFAULT_CFLAG CS8|B57600
diff -puN arch/microblaze/kernel/early_printk.c~early_printk-consolidate-random-copies-of-identical-code arch/microblaze/kernel/early_printk.c
--- a/arch/microblaze/kernel/early_printk.c~early_printk-consolidate-random-copies-of-identical-code
+++ a/arch/microblaze/kernel/early_printk.c
@@ -21,7 +21,6 @@
 #include <asm/setup.h>
 #include <asm/prom.h>
 
-static u32 early_console_initialized;
 static u32 base_addr;
 
 #ifdef CONFIG_SERIAL_UARTLITE_CONSOLE
@@ -109,27 +108,11 @@ static struct console early_serial_uart1
 };
 #endif /* CONFIG_SERIAL_8250_CONSOLE */
 
-static struct console *early_console;
-
-void early_printk(const char *fmt, ...)
-{
-	char buf[512];
-	int n;
-	va_list ap;
-
-	if (early_console_initialized) {
-		va_start(ap, fmt);
-		n = vscnprintf(buf, 512, fmt, ap);
-		early_console->write(early_console, buf, n);
-		va_end(ap);
-	}
-}
-
 int __init setup_early_printk(char *opt)
 {
 	int version = 0;
 
-	if (early_console_initialized)
+	if (early_console)
 		return 1;
 
 	base_addr = of_early_console(&version);
@@ -159,7 +142,6 @@ int __init setup_early_printk(char *opt)
 		}
 
 		register_console(early_console);
-		early_console_initialized = 1;
 		return 0;
 	}
 	return 1;
@@ -169,7 +151,7 @@ int __init setup_early_printk(char *opt)
  * only for early console because of performance degression */
 void __init remap_early_printk(void)
 {
-	if (!early_console_initialized || !early_console)
+	if (!early_console)
 		return;
 	pr_info("early_printk_console remapping from 0x%x to ", base_addr);
 	base_addr = (u32) ioremap(base_addr, PAGE_SIZE);
@@ -194,9 +176,9 @@ void __init remap_early_printk(void)
 
 void __init disable_early_printk(void)
 {
-	if (!early_console_initialized || !early_console)
+	if (!early_console)
 		return;
 	pr_warn("disabling early console\n");
 	unregister_console(early_console);
-	early_console_initialized = 0;
+	early_console = NULL;
 }
diff -puN arch/mips/kernel/early_printk.c~early_printk-consolidate-random-copies-of-identical-code arch/mips/kernel/early_printk.c
--- a/arch/mips/kernel/early_printk.c~early_printk-consolidate-random-copies-of-identical-code
+++ a/arch/mips/kernel/early_printk.c
@@ -7,7 +7,9 @@
  * Copyright (C) 2007 MIPS Technologies, Inc.
  *   written by Ralf Baechle (ralf@linux-mips.org)
  */
+#include <linux/kernel.h>
 #include <linux/console.h>
+#include <linux/printk.h>
 #include <linux/init.h>
 
 #include <asm/setup.h>
@@ -24,20 +26,18 @@ static void early_console_write(struct c
 	}
 }
 
-static struct console early_console = {
+static struct console early_console_prom = {
 	.name	= "early",
 	.write	= early_console_write,
 	.flags	= CON_PRINTBUFFER | CON_BOOT,
 	.index	= -1
 };
 
-static int early_console_initialized __initdata;
-
 void __init setup_early_printk(void)
 {
-	if (early_console_initialized)
+	if (early_console)
 		return;
-	early_console_initialized = 1;
+	early_console = &early_console_prom;
 
-	register_console(&early_console);
+	register_console(&early_console_prom);
 }
diff -puN arch/powerpc/kernel/udbg.c~early_printk-consolidate-random-copies-of-identical-code arch/powerpc/kernel/udbg.c
--- a/arch/powerpc/kernel/udbg.c~early_printk-consolidate-random-copies-of-identical-code
+++ a/arch/powerpc/kernel/udbg.c
@@ -156,15 +156,13 @@ static struct console udbg_console = {
 	.index	= 0,
 };
 
-static int early_console_initialized;
-
 /*
  * Called by setup_system after ppc_md->probe and ppc_md->early_init.
  * Call it again after setting udbg_putc in ppc_md->setup_arch.
  */
 void __init register_early_udbg_console(void)
 {
-	if (early_console_initialized)
+	if (early_console)
 		return;
 
 	if (!udbg_putc)
@@ -174,7 +172,7 @@ void __init register_early_udbg_console(
 		printk(KERN_INFO "early console immortal !\n");
 		udbg_console.flags &= ~CON_BOOT;
 	}
-	early_console_initialized = 1;
+	early_console = &udbg_console;
 	register_console(&udbg_console);
 }
 
diff -puN arch/sh/kernel/sh_bios.c~early_printk-consolidate-random-copies-of-identical-code arch/sh/kernel/sh_bios.c
--- a/arch/sh/kernel/sh_bios.c~early_printk-consolidate-random-copies-of-identical-code
+++ a/arch/sh/kernel/sh_bios.c
@@ -104,6 +104,7 @@ void sh_bios_vbr_reload(void)
 		);
 }
 
+#ifdef CONFIG_EARLY_PRINTK
 /*
  *	Print a string through the BIOS
  */
@@ -144,8 +145,6 @@ static struct console bios_console = {
 	.index		= -1,
 };
 
-static struct console *early_console;
-
 static int __init setup_early_printk(char *buf)
 {
 	int keep_early = 0;
@@ -170,3 +169,4 @@ static int __init setup_early_printk(cha
 	return 0;
 }
 early_param("earlyprintk", setup_early_printk);
+#endif
diff -puN arch/tile/kernel/early_printk.c~early_printk-consolidate-random-copies-of-identical-code arch/tile/kernel/early_printk.c
--- a/arch/tile/kernel/early_printk.c~early_printk-consolidate-random-copies-of-identical-code
+++ a/arch/tile/kernel/early_printk.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/irqflags.h>
+#include <linux/printk.h>
 #include <asm/setup.h>
 #include <hv/hypervisor.h>
 
@@ -33,25 +34,8 @@ static struct console early_hv_console =
 };
 
 /* Direct interface for emergencies */
-static struct console *early_console = &early_hv_console;
-static int early_console_initialized;
 static int early_console_complete;
 
-static void early_vprintk(const char *fmt, va_list ap)
-{
-	char buf[512];
-	int n = vscnprintf(buf, sizeof(buf), fmt, ap);
-	early_console->write(early_console, buf, n);
-}
-
-void early_printk(const char *fmt, ...)
-{
-	va_list ap;
-	va_start(ap, fmt);
-	early_vprintk(fmt, ap);
-	va_end(ap);
-}
-
 void early_panic(const char *fmt, ...)
 {
 	va_list ap;
@@ -69,14 +53,13 @@ static int __initdata keep_early;
 
 static int __init setup_early_printk(char *str)
 {
-	if (early_console_initialized)
+	if (early_console)
 		return 1;
 
 	if (str != NULL && strncmp(str, "keep", 4) == 0)
 		keep_early = 1;
 
 	early_console = &early_hv_console;
-	early_console_initialized = 1;
 	register_console(early_console);
 
 	return 0;
@@ -85,12 +68,12 @@ static int __init setup_early_printk(cha
 void __init disable_early_printk(void)
 {
 	early_console_complete = 1;
-	if (!early_console_initialized || !early_console)
+	if (!early_console)
 		return;
 	if (!keep_early) {
 		early_printk("disabling early console\n");
 		unregister_console(early_console);
-		early_console_initialized = 0;
+		early_console = NULL;
 	} else {
 		early_printk("keeping early console\n");
 	}
@@ -98,7 +81,7 @@ void __init disable_early_printk(void)
 
 void warn_early_printk(void)
 {
-	if (early_console_complete || early_console_initialized)
+	if (early_console_complete || early_console)
 		return;
 	early_printk("\
 Machine shutting down before console output is fully initialized.\n\
diff -puN arch/um/kernel/early_printk.c~early_printk-consolidate-random-copies-of-identical-code arch/um/kernel/early_printk.c
--- a/arch/um/kernel/early_printk.c~early_printk-consolidate-random-copies-of-identical-code
+++ a/arch/um/kernel/early_printk.c
@@ -16,7 +16,7 @@ static void early_console_write(struct c
 	um_early_printk(s, n);
 }
 
-static struct console early_console = {
+static struct console early_console_dev = {
 	.name = "earlycon",
 	.write = early_console_write,
 	.flags = CON_BOOT,
@@ -25,8 +25,10 @@ static struct console early_console = {
 
 static int __init setup_early_printk(char *buf)
 {
-	register_console(&early_console);
-
+	if (!early_console) {
+		early_console = &early_console_dev;
+		register_console(&early_console_dev);
+	}
 	return 0;
 }
 
diff -puN arch/unicore32/kernel/early_printk.c~early_printk-consolidate-random-copies-of-identical-code arch/unicore32/kernel/early_printk.c
--- a/arch/unicore32/kernel/early_printk.c~early_printk-consolidate-random-copies-of-identical-code
+++ a/arch/unicore32/kernel/early_printk.c
@@ -33,21 +33,17 @@ static struct console early_ocd_console
 	.index =	-1,
 };
 
-/* Direct interface for emergencies */
-static struct console *early_console = &early_ocd_console;
-
-static int __initdata keep_early;
-
 static int __init setup_early_printk(char *buf)
 {
-	if (!buf)
+	int keep_early;
+
+	if (!buf || early_console)
 		return 0;
 
 	if (strstr(buf, "keep"))
 		keep_early = 1;
 
-	if (!strncmp(buf, "ocd", 3))
-		early_console = &early_ocd_console;
+	early_console = &early_ocd_console;
 
 	if (keep_early)
 		early_console->flags &= ~CON_BOOT;
diff -puN arch/x86/kernel/early_printk.c~early_printk-consolidate-random-copies-of-identical-code arch/x86/kernel/early_printk.c
--- a/arch/x86/kernel/early_printk.c~early_printk-consolidate-random-copies-of-identical-code
+++ a/arch/x86/kernel/early_printk.c
@@ -169,25 +169,9 @@ static struct console early_serial_conso
 	.index =	-1,
 };
 
-/* Direct interface for emergencies */
-static struct console *early_console = &early_vga_console;
-static int __initdata early_console_initialized;
-
-asmlinkage void early_printk(const char *fmt, ...)
-{
-	char buf[512];
-	int n;
-	va_list ap;
-
-	va_start(ap, fmt);
-	n = vscnprintf(buf, sizeof(buf), fmt, ap);
-	early_console->write(early_console, buf, n);
-	va_end(ap);
-}
-
 static inline void early_console_register(struct console *con, int keep_early)
 {
-	if (early_console->index != -1) {
+	if (con->index != -1) {
 		printk(KERN_CRIT "ERROR: earlyprintk= %s already used\n",
 		       con->name);
 		return;
@@ -207,9 +191,8 @@ static int __init setup_early_printk(cha
 	if (!buf)
 		return 0;
 
-	if (early_console_initialized)
+	if (early_console)
 		return 0;
-	early_console_initialized = 1;
 
 	keep = (strstr(buf, "keep") != NULL);
 
diff -puN include/linux/console.h~early_printk-consolidate-random-copies-of-identical-code include/linux/console.h
--- a/include/linux/console.h~early_printk-consolidate-random-copies-of-identical-code
+++ a/include/linux/console.h
@@ -141,6 +141,7 @@ struct console {
 	for (con = console_drivers; con != NULL; con = con->next)
 
 extern int console_set_on_cmdline;
+extern struct console *early_console;
 
 extern int add_preferred_console(char *name, int idx, char *options);
 extern int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, char *options);
diff -puN include/linux/printk.h~early_printk-consolidate-random-copies-of-identical-code include/linux/printk.h
--- a/include/linux/printk.h~early_printk-consolidate-random-copies-of-identical-code
+++ a/include/linux/printk.h
@@ -95,8 +95,14 @@ int no_printk(const char *fmt, ...)
 	return 0;
 }
 
+#ifdef CONFIG_EARLY_PRINTK
 extern asmlinkage __printf(1, 2)
 void early_printk(const char *fmt, ...);
+void early_vprintk(const char *fmt, va_list ap);
+#else
+static inline __printf(1, 2) __cold
+void early_printk(const char *s, ...) { }
+#endif
 
 #ifdef CONFIG_PRINTK
 asmlinkage __printf(5, 0)
diff -puN kernel/printk.c~early_printk-consolidate-random-copies-of-identical-code kernel/printk.c
--- a/kernel/printk.c~early_printk-consolidate-random-copies-of-identical-code
+++ a/kernel/printk.c
@@ -49,13 +49,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/printk.h>
 
-/*
- * Architectures can override it:
- */
-void asmlinkage __attribute__((weak)) early_printk(const char *fmt, ...)
-{
-}
-
 /* printk's without a loglevel use this.. */
 #define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
 
@@ -1723,6 +1716,29 @@ static size_t cont_print_text(char *text
 
 #endif /* CONFIG_PRINTK */
 
+#ifdef CONFIG_EARLY_PRINTK
+struct console *early_console;
+
+void early_vprintk(const char *fmt, va_list ap)
+{
+	if (early_console) {
+		char buf[512];
+		int n = vscnprintf(buf, sizeof(buf), fmt, ap);
+
+		early_console->write(early_console, buf, n);
+	}
+}
+
+asmlinkage void early_printk(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	early_vprintk(fmt, ap);
+	va_end(ap);
+}
+#endif
+
 static int __add_preferred_console(char *name, int idx, char *options,
 				   char *brl_options)
 {
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
linux-next.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
selftests-add-basic-posix-timers-selftests.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
kernel-compatc-make-do_sysinfo-static.patch
kernel-timerc-convert-compat_sys_sysinfo-to-compat_syscall_define.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes.patch
ipc-semc-alternatives-to-preempt_disable.patch
wait-add-wait_event_hrtimeout.patch
decompressor-add-lz4-decompressor-module.patch
lib-add-support-for-lz4-compressed-kernel.patch
arm-add-support-for-lz4-compressed-kernel.patch
x86-add-support-for-lz4-compressed-kernel.patch
x86-add-support-for-lz4-compressed-kernel-doc-add-lz4-magic-number-for-the-new-compression.patch

