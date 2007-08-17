From: akpm@linux-foundation.org
Subject: + mips-add-cfe-support-to-bcm947xx-code.patch added to -mm tree
Date: Fri, 17 Aug 2007 11:36:27 -0700
Message-ID: <200708171836.l7HIaRF2023824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41621 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759935AbXHQSiE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 14:38:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aurelien@aurel32.net, aurel32@farad.aurel32.net, ralf@linux-mips.org


The patch titled
     mips: add CFE support to BCM947xx code
has been added to the -mm tree.  Its filename is
     mips-add-cfe-support-to-bcm947xx-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mips: add CFE support to BCM947xx code
From: Aurelien Jarno <aurelien@aurel32.net>

Add CFE support to the BCM947xx code.  That includes querying CFE environment
variables as well as using CFE to print messages before the serial port is
initialized (early printk).

Signed-off-by: Aurelien Jarno <aurel32@farad.aurel32.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig          |    2 
 arch/mips/bcm947xx/prom.c  |  113 ++++++++++++++++++++++++++++++++++-
 arch/mips/bcm947xx/setup.c |   51 ++++++++++++++-
 3 files changed, 161 insertions(+), 5 deletions(-)

diff -puN arch/mips/Kconfig~mips-add-cfe-support-to-bcm947xx-code arch/mips/Kconfig
--- a/arch/mips/Kconfig~mips-add-cfe-support-to-bcm947xx-code
+++ a/arch/mips/Kconfig
@@ -56,6 +56,8 @@ config BCM947XX
 	select SSB
 	select SSB_DRIVER_MIPS
 	select GENERIC_GPIO
+	select SYS_HAS_EARLY_PRINTK
+	select CFE
 	help
 	 Support for BCM947xx based boards
 
diff -puN arch/mips/bcm947xx/prom.c~mips-add-cfe-support-to-bcm947xx-code arch/mips/bcm947xx/prom.c
--- a/arch/mips/bcm947xx/prom.c~mips-add-cfe-support-to-bcm947xx-code
+++ a/arch/mips/bcm947xx/prom.c
@@ -1,5 +1,6 @@
 /*
  *  Copyright (C) 2004 Florian Schirmer <jolt@tuxbox.org>
+ *  Copyright (C) 2007 Aurelien Jarno <aurelien@aurel32.net>
  *
  *  This program is free software; you can redistribute  it and/or modify it
  *  under  the terms of  the GNU General  Public License as published by the
@@ -23,18 +24,117 @@
  */
 
 #include <linux/init.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
 #include <asm/bootinfo.h>
+#include <asm/cfe/cfe_api.h>
+#include <asm/cfe/cfe_error.h>
+
+static int cfe_cons_handle;
 
 const char *get_system_type(void)
 {
 	return "Broadcom BCM947xx";
 }
 
-void __init prom_init(void)
+void prom_putchar(char c)
+{
+	while (cfe_write(cfe_cons_handle, &c, 1) == 0)
+		;
+}
+
+static __init void prom_init_cfe(void)
+{
+	uint32_t cfe_ept;
+	uint32_t cfe_handle;
+	uint32_t cfe_eptseal;
+	int argc = fw_arg0;
+	char **envp = (char **) fw_arg2;
+	int *prom_vec = (int *) fw_arg3;
+
+	/*
+	 * Check if a loader was used; if NOT, the 4 arguments are
+	 * what CFE gives us (handle, 0, EPT and EPTSEAL)
+	 */
+	if (argc < 0) {
+		cfe_handle = (uint32_t)argc;
+		cfe_ept = (uint32_t)envp;
+		cfe_eptseal = (uint32_t)prom_vec;
+	} else {
+		if ((int)prom_vec < 0) {
+			/*
+			 * Old loader; all it gives us is the handle,
+			 * so use the "known" entrypoint and assume
+			 * the seal.
+			 */
+			cfe_handle = (uint32_t)prom_vec;
+			cfe_ept = 0xBFC00500;
+			cfe_eptseal = CFE_EPTSEAL;
+		} else {
+			/*
+			 * Newer loaders bundle the handle/ept/eptseal
+			 * Note: prom_vec is in the loader's useg
+			 * which is still alive in the TLB.
+			 */
+			cfe_handle = prom_vec[0];
+			cfe_ept = prom_vec[2];
+			cfe_eptseal = prom_vec[3];
+		}
+	}
+
+	if (cfe_eptseal != CFE_EPTSEAL) {
+		/* too early for panic to do any good */
+		printk(KERN_ERR "CFE's entrypoint seal doesn't match.");
+		while (1) ;
+	}
+
+	cfe_init(cfe_handle, cfe_ept);
+}
+
+static __init void prom_init_console(void)
+{
+	/* Initialize CFE console */
+	cfe_cons_handle = cfe_getstdhandle(CFE_STDHANDLE_CONSOLE);
+}
+
+static __init void prom_init_cmdline(void)
+{
+	char buf[CL_SIZE];
+
+	/* Get the kernel command line from CFE */
+	if (cfe_getenv("LINUX_CMDLINE", buf, CL_SIZE) >= 0) {
+		buf[CL_SIZE-1] = 0;
+		strcpy(arcs_cmdline, buf);
+	}
+
+	/* Force a console handover by adding a console= argument if needed,
+	 * as CFE is not available anymore later in the boot process. */
+	if ((strstr(arcs_cmdline, "console=")) == NULL) {
+		/* Try to read the default serial port used by CFE */
+		if ((cfe_getenv("BOOT_CONSOLE", buf, CL_SIZE) < 0)
+		    || (strncmp("uart", buf, 4)))
+			/* Default to uart0 */
+			strcpy(buf, "uart0");
+
+		/* Compute the new command line */
+		snprintf(arcs_cmdline, CL_SIZE, "%s console=ttyS%c,115200",
+			 arcs_cmdline, buf[4]);
+	}
+}
+
+static __init void prom_init_mem(void)
 {
 	unsigned long mem;
 
-	/* Figure out memory size by finding aliases */
+	/* Figure out memory size by finding aliases.
+	 *
+	 * We should theoretically use the mapping from CFE using cfe_enummem().
+	 * However as the BCM947xx is mostly used on low-memory systems, we
+	 * want to reuse the memory used by CFE (around 4MB). That means cfe_*
+	 * functions stop to work at some point during the boot, we should only
+	 * call them at the beginning of the boot.
+	 */
 	for (mem = (1 << 20); mem < (128 << 20); mem += (1 << 20)) {
 		if (*(unsigned long *)((unsigned long)(prom_init) + mem) ==
 		    *(unsigned long *)(prom_init))
@@ -44,6 +144,15 @@ void __init prom_init(void)
 	add_memory_region(0, mem, BOOT_MEM_RAM);
 }
 
+void __init prom_init(void)
+{
+	prom_init_cfe();
+	prom_init_console();
+	prom_init_cmdline();
+	prom_init_mem();
+}
+
 void __init prom_free_prom_memory(void)
 {
 }
+
diff -puN arch/mips/bcm947xx/setup.c~mips-add-cfe-support-to-bcm947xx-code arch/mips/bcm947xx/setup.c
--- a/arch/mips/bcm947xx/setup.c~mips-add-cfe-support-to-bcm947xx-code
+++ a/arch/mips/bcm947xx/setup.c
@@ -27,9 +27,11 @@
 
 #include <linux/types.h>
 #include <linux/ssb/ssb.h>
+#include <asm/bootinfo.h>
 #include <asm/reboot.h>
 #include <asm/time.h>
 #include <bcm947xx.h>
+#include <asm/cfe/cfe_api.h>
 
 struct ssb_bus ssb_bcm947xx;
 EXPORT_SYMBOL(ssb_bcm947xx);
@@ -53,12 +55,55 @@ static void bcm947xx_machine_halt(void)
 		cpu_relax();
 }
 
+static void str2eaddr(char *str, char *dest)
+{
+	int i = 0;
+
+	if (str == NULL) {
+		memset(dest, 0, 6);
+		return;
+	}
+
+	for (;;) {
+		dest[i++] = (char) simple_strtoul(str, NULL, 16);
+		str += 2;
+		if (!*str++ || i == 6)
+			break;
+	}
+}
+
 static int bcm947xx_get_invariants(struct ssb_bus *bus,
 				   struct ssb_init_invariants *iv)
 {
-	/* TODO: fill ssb_init_invariants using boardtype/boardrev
-	 * CFE environment variables.
-	 */
+	char buf[100];
+
+	/* Fill boardinfo structure */
+	memset(&(iv->boardinfo), 0 , sizeof(struct ssb_boardinfo));
+
+	if (cfe_getenv("boardvendor", buf, sizeof(buf)) >= 0)
+		iv->boardinfo.type = (u16)simple_strtoul(buf, NULL, 0);
+	if (cfe_getenv("boardtype", buf, sizeof(buf)) >= 0)
+		iv->boardinfo.type = (u16)simple_strtoul(buf, NULL, 0);
+	if (cfe_getenv("boardrev", buf, sizeof(buf)) >= 0)
+		iv->boardinfo.rev = (u16)simple_strtoul(buf, NULL, 0);
+
+	/* Fill sprom structure */
+	memset(&(iv->sprom), 0, sizeof(struct ssb_sprom));
+	iv->sprom.revision = 3;
+
+	if (cfe_getenv("et0macaddr", buf, sizeof(buf)) >= 0)
+		str2eaddr(buf, iv->sprom.r1.et0mac);
+	if (cfe_getenv("et1macaddr", buf, sizeof(buf)) >= 0)
+		str2eaddr(buf, iv->sprom.r1.et1mac);
+	if (cfe_getenv("et0phyaddr", buf, sizeof(buf)) >= 0)
+		iv->sprom.r1.et0phyaddr = simple_strtoul(buf, NULL, 10);
+	if (cfe_getenv("et1phyaddr", buf, sizeof(buf)) >= 0)
+		iv->sprom.r1.et1phyaddr = simple_strtoul(buf, NULL, 10);
+	if (cfe_getenv("et0mdcport", buf, sizeof(buf)) >= 0)
+		iv->sprom.r1.et0mdcport = simple_strtoul(buf, NULL, 10);
+	if (cfe_getenv("et1mdcport", buf, sizeof(buf)) >= 0)
+		iv->sprom.r1.et1mdcport = simple_strtoul(buf, NULL, 10);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from aurelien@aurel32.net are

git-kvm.patch
mips-detect-bcm947xx-cpus.patch
mips-bcm947xx-support.patch
rfc-add-bcm947xx-to-kconfig.patch
mips-add-bcm947xx-to-makefile.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch
mips-add-cfe-support-to-bcm947xx-code.patch
git-wireless.patch
move-mm_struct-and-vm_area_struct-fix.patch
