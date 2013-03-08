From: akpm@linux-foundation.org
Subject: + early_printk-consolidate-random-copies-of-identical-code-v3.patch added to -mm tree
Date: Fri, 08 Mar 2013 13:46:20 -0800
Message-ID: <20130308214621.004B15A41D2@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:62312 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757654Ab3CHVqW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Mar 2013 16:46:22 -0500
Received: by mail-qe0-f74.google.com with SMTP id 9so205481qea.3
        for <mm-commits@vger.kernel.org>; Fri, 08 Mar 2013 13:46:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, benh@kernel.crashing.org, cmetcalf@tilera.com, davem@davemloft.net, lethal@linux-sh.org, linux@arm.linux.org.uk, mingo@kernel.org, monstr@monstr.eu, paul.gortmaker@windriver.com, ralf@linux-mips.org, richard@nod.at, vapier@gentoo.org


The patch titled
     Subject: early_printk: consolidate random copies of identical code
has been added to the -mm tree.  Its filename is
     early_printk-consolidate-random-copies-of-identical-code-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thomas Gleixner <tglx@linutronix.de>
Subject: early_printk: consolidate random copies of identical code

The early console implementations are the same all over the place.  Move
the print function to kernel/printk and get rid of the copies.

[v3: drop sparc bits as suggested by tglx, redo build tests on sparc
 sparc32, Randy's randconfig, ppc, mips, arm...]

[v2: essentially unchanged since v1, so I've left the acked/reviewed
 tags.  There was a compile fail[1] for a randconfig with EARLY_PRINTK=y
 and PRINTK=n, because the early_console struct and early_printk calls
 were nested within an #ifdef CONFIG_PRINTK -- moving that whole block
 exactly as-is to be outside the #ifdef CONFIG_PRINTK fixes the randconfig
 and still works for everyday sane configs too.]
 [1] http://marc.info/?l=linux-next&m=136219350914998&w=2

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/setup_32.c |    1 
 arch/sparc/kernel/setup_64.c |    8 -----
 kernel/printk.c              |   46 ++++++++++++++++-----------------
 3 files changed, 24 insertions(+), 31 deletions(-)

diff -puN arch/sparc/kernel/setup_32.c~early_printk-consolidate-random-copies-of-identical-code-v3 arch/sparc/kernel/setup_32.c
--- a/arch/sparc/kernel/setup_32.c~early_printk-consolidate-random-copies-of-identical-code-v3
+++ a/arch/sparc/kernel/setup_32.c
@@ -309,7 +309,6 @@ void __init setup_arch(char **cmdline_p)
 
 	boot_flags_init(*cmdline_p);
 
-	early_console = &prom_early_console;
 	register_console(&prom_early_console);
 
 	printk("ARCH: ");
diff -puN arch/sparc/kernel/setup_64.c~early_printk-consolidate-random-copies-of-identical-code-v3 arch/sparc/kernel/setup_64.c
--- a/arch/sparc/kernel/setup_64.c~early_printk-consolidate-random-copies-of-identical-code-v3
+++ a/arch/sparc/kernel/setup_64.c
@@ -551,12 +551,6 @@ static void __init init_sparc64_elf_hwca
 		pause_patch();
 }
 
-static inline void register_prom_console(void)
-{
-	early_console = &prom_early_console;
-	register_console(&prom_early_console);
-}
-
 void __init setup_arch(char **cmdline_p)
 {
 	/* Initialize PROM console and command line. */
@@ -568,7 +562,7 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_EARLYFB
 	if (btext_find_display())
 #endif
-		register_prom_console();
+		register_console(&prom_early_console);
 
 	if (tlb_type == hypervisor)
 		printk("ARCH: SUN4V\n");
diff -puN kernel/printk.c~early_printk-consolidate-random-copies-of-identical-code-v3 kernel/printk.c
--- a/kernel/printk.c~early_printk-consolidate-random-copies-of-identical-code-v3
+++ a/kernel/printk.c
@@ -759,29 +759,6 @@ module_param(ignore_loglevel, bool, S_IR
 MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
 	"print all kernel messages to the console.");
 
-#ifdef CONFIG_EARLY_PRINTK
-struct console *early_console;
-
-void early_vprintk(const char *fmt, va_list ap)
-{
-	if (early_console) {
-		char buf[512];
-		int n = vscnprintf(buf, sizeof(buf), fmt, ap);
-
-		early_console->write(early_console, buf, n);
-	}
-}
-
-asmlinkage void early_printk(const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	early_vprintk(fmt, ap);
-	va_end(ap);
-}
-#endif
-
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
 static int boot_delay; /* msecs delay after each printk during bootup */
@@ -1743,6 +1720,29 @@ static size_t cont_print_text(char *text
 
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
revert-parts-of-hlist-drop-the-node-parameter-from-iterators.patch
linux-next.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
timer_list-split-timer_list_show_tickdevices.patch
timer_list-split-timer_list_show_tickdevices-v4.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
mkcapflagspl-convert-to-mkcapflagssh.patch
headers_installpl-convert-to-headers_installsh.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
early_printk-consolidate-random-copies-of-identical-code.patch
early_printk-consolidate-random-copies-of-identical-code-v3.patch
ipc-semc-alternatives-to-preempt_disable.patch
x86-pageattr-test-remove-srandom32-call.patch
x86-rename-random32-to-prandom_u32.patch
futex-fix-kernel-doc-notation-and-spello.patch
wait-add-wait_event_hrtimeout.patch
decompressor-add-lz4-decompressor-module.patch
lib-add-support-for-lz4-compressed-kernel.patch
arm-add-support-for-lz4-compressed-kernel.patch
x86-add-support-for-lz4-compressed-kernel.patch

