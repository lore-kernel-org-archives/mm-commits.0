From: akpm@linux-foundation.org
Subject: - fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch removed from -mm tree
Date: Tue, 08 May 2007 19:47:09 -0700
Message-ID: <200705090247.l492l9IL008938@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934804AbXEICsN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:48:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kraxel@suse.de, ak@suse.de, alan@lxorguk.ukuu.org.uk, benh@kernel.crashing.org, ink@jurassic.park.msu.ru, jeremy@goop.org, kraxel@exsuse.de, lethal@linux-sh.org, paulus@samba.org, ralf@linux-mips.org, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     Fixes and cleanups for earlyprintk aka boot console
has been removed from the -mm tree.  Its filename was
     fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fixes and cleanups for earlyprintk aka boot console
From: Gerd Hoffmann <kraxel@suse.de>

The console subsystem already has an idea of a boot console, using the
CON_BOOT flag.  The implementation has some flaws though.  The major
problem is that presence of a boot console makes register_console() ignore
any other console devices (unless explicitly specified on the kernel
command line).

This patch fixes the console selection code to *not* consider a boot
console a full-featured one, so the first non-boot console registering will
become the default console instead.  This way the unregister call for the
boot console in the register_console() function actually triggers and the
handover from the boot console to the real console device works smoothly. 
Added a printk for the handover, so you know which console device the
output goes to when the boot console stops printing messages.

The disable_early_printk() call is obsolete with that patch, explicitly
disabling the early console isn't needed any more as it works automagically
with that patch.

I've walked through the tree, dropped all disable_early_printk() instances
found below arch/ and tagged the consoles with CON_BOOT if needed.  The
code is tested on x86, sh (thanks to Paul) and mips (thanks to Ralf).

Changes to last version: Rediffed against -rc3, adapted to mips cleanups by
Ralf, fixed "udbg-immortal" cmd line arg on powerpc.

Signed-off-by: Gerd Hoffmann <kraxel@exsuse.de>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/setup.c         |    9 ---------
 arch/alpha/kernel/srmcons.c       |    2 +-
 arch/mips/kernel/early_printk.c   |    5 -----
 arch/powerpc/kernel/udbg.c        |   19 ++++++-------------
 arch/sh/kernel/early_printk.c     |   18 ++++++------------
 arch/sh64/kernel/early_printk.c   |    8 +-------
 arch/x86_64/kernel/early_printk.c |   20 +++++---------------
 drivers/char/tty_io.c             |    5 -----
 kernel/printk.c                   |   26 ++++++++++++++++----------
 9 files changed, 35 insertions(+), 77 deletions(-)

diff -puN arch/alpha/kernel/setup.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console arch/alpha/kernel/setup.c
--- a/arch/alpha/kernel/setup.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console
+++ a/arch/alpha/kernel/setup.c
@@ -744,15 +744,6 @@ setup_arch(char **cmdline_p)
 	paging_init();
 }
 
-void __init
-disable_early_printk(void)
-{
-	if (alpha_using_srm && srmcons_output) {
-		unregister_srm_console();
-		srmcons_output = 0;
-	}
-}
-
 static char sys_unknown[] = "Unknown";
 static char systype_names[][16] = {
 	"0",
diff -puN arch/alpha/kernel/srmcons.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console arch/alpha/kernel/srmcons.c
--- a/arch/alpha/kernel/srmcons.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console
+++ a/arch/alpha/kernel/srmcons.c
@@ -300,7 +300,7 @@ static struct console srmcons = {
 	.write		= srm_console_write,
 	.device		= srm_console_device,
 	.setup		= srm_console_setup,
-	.flags		= CON_PRINTBUFFER,
+	.flags		= CON_PRINTBUFFER | CON_BOOT,
 	.index		= -1,
 };
 
diff -puN arch/mips/kernel/early_printk.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console arch/mips/kernel/early_printk.c
--- a/arch/mips/kernel/early_printk.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console
+++ a/arch/mips/kernel/early_printk.c
@@ -33,8 +33,3 @@ void __init setup_early_printk(void)
 {
 	register_console(&early_console);
 }
-
-void __init disable_early_printk(void)
-{
-	unregister_console(&early_console);
-}
diff -puN arch/powerpc/kernel/udbg.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console arch/powerpc/kernel/udbg.c
--- a/arch/powerpc/kernel/udbg.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console
+++ a/arch/powerpc/kernel/udbg.c
@@ -142,29 +142,22 @@ static void udbg_console_write(struct co
 static struct console udbg_console = {
 	.name	= "udbg",
 	.write	= udbg_console_write,
-	.flags	= CON_PRINTBUFFER | CON_ENABLED,
+	.flags	= CON_PRINTBUFFER | CON_ENABLED | CON_BOOT,
 	.index	= -1,
 };
 
 static int early_console_initialized;
 
-void __init disable_early_printk(void)
-{
-	if (!early_console_initialized)
-		return;
-	if (strstr(boot_command_line, "udbg-immortal")) {
-		printk(KERN_INFO "early console immortal !\n");
-		return;
-	}
-	unregister_console(&udbg_console);
-	early_console_initialized = 0;
-}
-
 /* called by setup_system */
 void register_early_udbg_console(void)
 {
 	if (early_console_initialized)
 		return;
+
+	if (strstr(boot_command_line, "udbg-immortal")) {
+		printk(KERN_INFO "early console immortal !\n");
+		udbg_console.flags &= ~CON_BOOT;
+	}
 	early_console_initialized = 1;
 	register_console(&udbg_console);
 }
diff -puN arch/sh/kernel/early_printk.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console arch/sh/kernel/early_printk.c
--- a/arch/sh/kernel/early_printk.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console
+++ a/arch/sh/kernel/early_printk.c
@@ -192,20 +192,14 @@ int __init setup_early_printk(char *buf)
 	}
 #endif
 
-	if (likely(early_console))
+	if (likely(early_console)) {
+		if (keep_early)
+			early_console->flags &= ~CON_BOOT;
+		else
+			early_console->flags |= CON_BOOT;
 		register_console(early_console);
+	}
 
 	return 0;
 }
 early_param("earlyprintk", setup_early_printk);
-
-void __init disable_early_printk(void)
-{
-	if (!early_console_initialized || !early_console)
-		return;
-	if (!keep_early) {
-		printk("disabling early console\n");
-		unregister_console(early_console);
-	} else
-		printk("keeping early console\n");
-}
diff -puN arch/sh64/kernel/early_printk.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console arch/sh64/kernel/early_printk.c
--- a/arch/sh64/kernel/early_printk.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console
+++ a/arch/sh64/kernel/early_printk.c
@@ -79,7 +79,7 @@ static struct console sh_console = {
 	.name		= "scifcon",
 	.write		= sh_console_write,
 	.setup		= sh_console_setup,
-	.flags		= CON_PRINTBUFFER,
+	.flags		= CON_PRINTBUFFER | CON_BOOT,
 	.index		= -1,
 };
 
@@ -97,9 +97,3 @@ void __init enable_early_printk(void)
 
 	register_console(&sh_console);
 }
-
-void disable_early_printk(void)
-{
-	unregister_console(&sh_console);
-}
-
diff -puN arch/x86_64/kernel/early_printk.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console arch/x86_64/kernel/early_printk.c
--- a/arch/x86_64/kernel/early_printk.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console
+++ a/arch/x86_64/kernel/early_printk.c
@@ -243,22 +243,12 @@ static int __init setup_early_printk(cha
  		early_console = &simnow_console;
  		keep_early = 1;
 	}
+
+	if (keep_early)
+		early_console->flags &= ~CON_BOOT;
+	else
+		early_console->flags |= CON_BOOT;
 	register_console(early_console);
 	return 0;
 }
-
 early_param("earlyprintk", setup_early_printk);
-
-void __init disable_early_printk(void)
-{
-	if (!early_console_initialized || !early_console)
-		return;
-	if (!keep_early) {
-		printk("disabling early console\n");
-		unregister_console(early_console);
-		early_console_initialized = 0;
-	} else {
-		printk("keeping early console\n");
-	}
-}
-
diff -puN drivers/char/tty_io.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console
+++ a/drivers/char/tty_io.c
@@ -141,8 +141,6 @@ static DECLARE_MUTEX(allocated_ptys_lock
 static int ptmx_open(struct inode *, struct file *);
 #endif
 
-extern void disable_early_printk(void);
-
 static void initialize_tty_struct(struct tty_struct *tty);
 
 static ssize_t tty_read(struct file *, char __user *, size_t, loff_t *);
@@ -3897,9 +3895,6 @@ void __init console_init(void)
 	 * set up the console device so that later boot sequences can 
 	 * inform about problems etc..
 	 */
-#ifdef CONFIG_EARLY_PRINTK
-	disable_early_printk();
-#endif
 	call = __con_initcall_start;
 	while (call < __con_initcall_end) {
 		(*call)();
diff -puN kernel/printk.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console kernel/printk.c
--- a/kernel/printk.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console
+++ a/kernel/printk.c
@@ -931,8 +931,16 @@ void register_console(struct console *co
 {
 	int i;
 	unsigned long flags;
+	struct console *bootconsole = NULL;
 
-	if (preferred_console < 0)
+	if (console_drivers) {
+		if (console->flags & CON_BOOT)
+			return;
+		if (console_drivers->flags & CON_BOOT)
+			bootconsole = console_drivers;
+	}
+
+	if (preferred_console < 0 || bootconsole || !console_drivers)
 		preferred_console = selected_console;
 
 	/*
@@ -978,8 +986,11 @@ void register_console(struct console *co
 	if (!(console->flags & CON_ENABLED))
 		return;
 
-	if (console_drivers && (console_drivers->flags & CON_BOOT)) {
-		unregister_console(console_drivers);
+	if (bootconsole) {
+		printk(KERN_INFO "console handover: boot [%s%d] -> real [%s%d]\n",
+		       bootconsole->name, bootconsole->index,
+		       console->name, console->index);
+		unregister_console(bootconsole);
 		console->flags &= ~CON_PRINTBUFFER;
 	}
 
@@ -1030,16 +1041,11 @@ int unregister_console(struct console *c
 		}
 	}
 
-	/* If last console is removed, we re-enable picking the first
-	 * one that gets registered. Without that, pmac early boot console
-	 * would prevent fbcon from taking over.
-	 *
+	/*
 	 * If this isn't the last console and it has CON_CONSDEV set, we
 	 * need to set it on the next preferred console.
 	 */
-	if (console_drivers == NULL)
-		preferred_console = selected_console;
-	else if (console->flags & CON_CONSDEV)
+	if (console_drivers != NULL && console->flags & CON_CONSDEV)
 		console_drivers->flags |= CON_CONSDEV;
 
 	release_console_sem();
_

Patches currently in -mm which might be from kraxel@suse.de are

origin.patch
