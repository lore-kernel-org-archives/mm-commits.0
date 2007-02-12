From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-powerpc.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:48:03 -0800
Message-ID: <200702122248.l1CMm3FU013969@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45462 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030358AbXBLWsI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:48:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: powerpc
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-powerpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: powerpc
From: Alon Bar-Lev <alon.barlev@gmail.com>

Rename saved_command_line into boot_command_line.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/legacy_serial.c     |    2 +-
 arch/powerpc/kernel/prom.c              |    2 +-
 arch/powerpc/kernel/udbg.c              |    2 +-
 arch/powerpc/platforms/powermac/setup.c |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/powerpc/kernel/legacy_serial.c~dynamic-kernel-command-line-powerpc arch/powerpc/kernel/legacy_serial.c
--- a/arch/powerpc/kernel/legacy_serial.c~dynamic-kernel-command-line-powerpc
+++ a/arch/powerpc/kernel/legacy_serial.c
@@ -498,7 +498,7 @@ static int __init check_legacy_serial_co
 	DBG(" -> check_legacy_serial_console()\n");
 
 	/* The user has requested a console so this is already set up. */
-	if (strstr(saved_command_line, "console=")) {
+	if (strstr(boot_command_line, "console=")) {
 		DBG(" console was specified !\n");
 		return -EBUSY;
 	}
diff -puN arch/powerpc/kernel/prom.c~dynamic-kernel-command-line-powerpc arch/powerpc/kernel/prom.c
--- a/arch/powerpc/kernel/prom.c~dynamic-kernel-command-line-powerpc
+++ a/arch/powerpc/kernel/prom.c
@@ -991,7 +991,7 @@ void __init early_init_devtree(void *par
 	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
 
 	/* Save command line for /proc/cmdline and then parse parameters */
-	strlcpy(saved_command_line, cmd_line, COMMAND_LINE_SIZE);
+	strlcpy(boot_command_line, cmd_line, COMMAND_LINE_SIZE);
 	parse_early_param();
 
 	/* Reserve LMB regions used by kernel, initrd, dt, etc... */
diff -puN arch/powerpc/kernel/udbg.c~dynamic-kernel-command-line-powerpc arch/powerpc/kernel/udbg.c
--- a/arch/powerpc/kernel/udbg.c~dynamic-kernel-command-line-powerpc
+++ a/arch/powerpc/kernel/udbg.c
@@ -150,7 +150,7 @@ void __init disable_early_printk(void)
 {
 	if (!early_console_initialized)
 		return;
-	if (strstr(saved_command_line, "udbg-immortal")) {
+	if (strstr(boot_command_line, "udbg-immortal")) {
 		printk(KERN_INFO "early console immortal !\n");
 		return;
 	}
diff -puN arch/powerpc/platforms/powermac/setup.c~dynamic-kernel-command-line-powerpc arch/powerpc/platforms/powermac/setup.c
--- a/arch/powerpc/platforms/powermac/setup.c~dynamic-kernel-command-line-powerpc
+++ a/arch/powerpc/platforms/powermac/setup.c
@@ -506,8 +506,8 @@ void note_bootable_part(dev_t dev, int p
 	if ((goodness <= current_root_goodness) &&
 	    ROOT_DEV != DEFAULT_ROOT_DEVICE)
 		return;
-	p = strstr(saved_command_line, "root=");
-	if (p != NULL && (p == saved_command_line || p[-1] == ' '))
+	p = strstr(boot_command_line, "root=");
+	if (p != NULL && (p == boot_command_line || p[-1] == ' '))
 		return;
 
 	if (!found_boot) {
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

origin.patch
