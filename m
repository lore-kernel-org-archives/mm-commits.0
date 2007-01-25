From: akpm@osdl.org
Subject: + dynamic-kernel-command-line-parisc.patch added to -mm tree
Date: Wed, 24 Jan 2007 21:09:01 -0800
Message-ID: <200701250509.l0P591TX006537@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47356 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965275AbXAYFMT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 00:12:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alon.barlev@gmail.com, ralf@linux-mips.org


The patch titled
     Dynamic kernel command-line: parisc
has been added to the -mm tree.  Its filename is
     dynamic-kernel-command-line-parisc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Dynamic kernel command-line: parisc
From: Alon Bar-Lev <alon.barlev@gmail.com>

1. Rename saved_command_line into boot_command_line.
2. Set command_line as __initdata.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/parisc/kernel/setup.c |    8 ++++----
 arch/parisc/mm/init.c      |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/parisc/kernel/setup.c~dynamic-kernel-command-line-parisc arch/parisc/kernel/setup.c
--- a/arch/parisc/kernel/setup.c~dynamic-kernel-command-line-parisc
+++ a/arch/parisc/kernel/setup.c
@@ -45,7 +45,7 @@
 #include <asm/io.h>
 #include <asm/setup.h>
 
-char	command_line[COMMAND_LINE_SIZE] __read_mostly;
+char	__initdata command_line[COMMAND_LINE_SIZE] __read_mostly;
 
 /* Intended for ccio/sba/cpu statistics under /proc/bus/{runway|gsc} */
 struct proc_dir_entry * proc_runway_root __read_mostly = NULL;
@@ -71,9 +71,9 @@ void __init setup_cmdline(char **cmdline
 	/* boot_args[0] is free-mem start, boot_args[1] is ptr to command line */
 	if (boot_args[0] < 64) {
 		/* called from hpux boot loader */
-		saved_command_line[0] = '\0';
+		boot_command_line[0] = '\0';
 	} else {
-		strcpy(saved_command_line, (char *)__va(boot_args[1]));
+		strcpy(boot_command_line, (char *)__va(boot_args[1]));
 
 #ifdef CONFIG_BLK_DEV_INITRD
 		if (boot_args[2] != 0) /* did palo pass us a ramdisk? */
@@ -84,7 +84,7 @@ void __init setup_cmdline(char **cmdline
 #endif
 	}
 
-	strcpy(command_line, saved_command_line);
+	strcpy(command_line, boot_command_line);
 	*cmdline_p = command_line;
 }
 
diff -puN arch/parisc/mm/init.c~dynamic-kernel-command-line-parisc arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~dynamic-kernel-command-line-parisc
+++ a/arch/parisc/mm/init.c
@@ -77,12 +77,12 @@ static void __init mem_limit_func(void)
 {
 	char *cp, *end;
 	unsigned long limit;
-	extern char saved_command_line[];
+	extern char __initdata boot_command_line[];
 
 	/* We need this before __setup() functions are called */
 
 	limit = MAX_MEM;
-	for (cp = saved_command_line; *cp; ) {
+	for (cp = boot_command_line; *cp; ) {
 		if (memcmp(cp, "mem=", 4) == 0) {
 			cp += 4;
 			limit = memparse(cp, &end);
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-alpha.patch
dynamic-kernel-command-line-arm.patch
dynamic-kernel-command-line-arm26.patch
dynamic-kernel-command-line-avr32.patch
dynamic-kernel-command-line-cris.patch
dynamic-kernel-command-line-frv.patch
dynamic-kernel-command-line-h8300.patch
dynamic-kernel-command-line-i386.patch
dynamic-kernel-command-line-ia64.patch
dynamic-kernel-command-line-m32r.patch
dynamic-kernel-command-line-m68k.patch
dynamic-kernel-command-line-m68knommu.patch
dynamic-kernel-command-line-mips.patch
dynamic-kernel-command-line-parisc.patch
dynamic-kernel-command-line-powerpc.patch
dynamic-kernel-command-line-ppc.patch
dynamic-kernel-command-line-s390.patch
dynamic-kernel-command-line-sh.patch
dynamic-kernel-command-line-sh64.patch
dynamic-kernel-command-line-sparc.patch
dynamic-kernel-command-line-sparc64.patch
dynamic-kernel-command-line-um.patch
dynamic-kernel-command-line-v850.patch
dynamic-kernel-command-line-x86_64.patch
dynamic-kernel-command-line-xtensa.patch
