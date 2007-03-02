From: akpm@linux-foundation.org
Subject: - fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch removed from -mm tree
Date: Fri, 02 Mar 2007 00:47:07 -0700
Message-ID: <200703020747.l227l7rs003531@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47451 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161242AbXCBHup (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 02:50:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kraxel@suse.de, ak@suse.de, alan@lxorguk.ukuu.org.uk, benh@kernel.crashing.org, ink@jurassic.park.msu.ru, jeremy@goop.org, lethal@linux-sh.org, paulus@samba.org, ralf@linux-mips.org, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     Fixes and cleanups for earlyprintk aka boot console
has been removed from the -mm tree.  Its filename was
     fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch

This patch was dropped because it had testing failures

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
code is tested on x86 only so far.

Signed-off-by: Gerd Hoffmann <kraxel@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/setup.c         |    9 ---------
 arch/alpha/kernel/srmcons.c       |    2 +-
 arch/mips/cobalt/console.c        |    5 -----
 arch/mips/dec/prom/console.c      |    5 +----
 arch/mips/sgi-ip27/ip27-console.c |    5 -----
 arch/powerpc/kernel/udbg.c        |   14 +-------------
 arch/sh/kernel/early_printk.c     |   18 ++++++------------
 arch/sh64/kernel/early_printk.c   |    8 +-------
 printk.c                          |    0 
 9 files changed, 10 insertions(+), 56 deletions(-)

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
 
diff -puN arch/mips/cobalt/console.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console arch/mips/cobalt/console.c
--- a/arch/mips/cobalt/console.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console
+++ a/arch/mips/cobalt/console.c
@@ -40,8 +40,3 @@ void __init cobalt_early_console(void)
 
 	printk("Cobalt: early console registered\n");
 }
-
-void __init disable_early_printk(void)
-{
-	unregister_console(&cons_info);
-}
diff -puN arch/mips/dec/prom/console.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console arch/mips/dec/prom/console.c
--- a/arch/mips/dec/prom/console.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console
+++ a/arch/mips/dec/prom/console.c
@@ -29,7 +29,7 @@ static void __init prom_console_write(st
 static struct console promcons __initdata = {
 	.name	= "prom",
 	.write	= prom_console_write,
-	.flags	= CON_PRINTBUFFER,
+	.flags	= CON_PRINTBUFFER | CON_BOOT,
 	.index	= -1,
 };
 
@@ -50,6 +50,3 @@ void __init unregister_prom_console(void
 		promcons_output = 0;
 	}
 }
-
-void disable_early_printk(void)
-	__attribute__((alias("unregister_prom_console")));
diff -puN arch/mips/sgi-ip27/ip27-console.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console arch/mips/sgi-ip27/ip27-console.c
--- a/arch/mips/sgi-ip27/ip27-console.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console
+++ a/arch/mips/sgi-ip27/ip27-console.c
@@ -67,8 +67,3 @@ __init void ip27_setup_console(void)
 {
 	register_console(&ioc3_console);
 }
-
-void __init disable_early_printk(void)
-{
-	unregister_console(&ioc3_console);
-}
diff -puN arch/powerpc/kernel/udbg.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console arch/powerpc/kernel/udbg.c
--- a/arch/powerpc/kernel/udbg.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console
+++ a/arch/powerpc/kernel/udbg.c
@@ -142,24 +142,12 @@ static void udbg_console_write(struct co
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
diff -puN drivers/char/tty_io.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console drivers/char/tty_io.c
diff -puN kernel/printk.c~fixes-and-cleanups-for-earlyprintk-aka-boot-console kernel/printk.c
_

Patches currently in -mm which might be from kraxel@suse.de are

fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
