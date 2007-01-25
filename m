From: akpm@osdl.org
Subject: + dynamic-kernel-command-line-ppc.patch added to -mm tree
Date: Wed, 24 Jan 2007 21:09:05 -0800
Message-ID: <200701250509.l0P595nO006543@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47152 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965301AbXAYFJJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 00:09:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alon.barlev@gmail.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     Dynamic kernel command-line: ppc
has been added to the -mm tree.  Its filename is
     dynamic-kernel-command-line-ppc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Dynamic kernel command-line: ppc
From: Alon Bar-Lev <alon.barlev@gmail.com>

Rename saved_command_line into boot_command_line.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ppc/kernel/setup.c         |    2 +-
 arch/ppc/platforms/lopec.c      |    2 +-
 arch/ppc/platforms/pplus.c      |    2 +-
 arch/ppc/platforms/prep_setup.c |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/ppc/kernel/setup.c~dynamic-kernel-command-line-ppc arch/ppc/kernel/setup.c
--- a/arch/ppc/kernel/setup.c~dynamic-kernel-command-line-ppc
+++ a/arch/ppc/kernel/setup.c
@@ -543,7 +543,7 @@ void __init setup_arch(char **cmdline_p)
 	init_mm.brk = (unsigned long) klimit;
 
 	/* Save unparsed command line copy for /proc/cmdline */
-	strlcpy(saved_command_line, cmd_line, COMMAND_LINE_SIZE);
+	strlcpy(boot_command_line, cmd_line, COMMAND_LINE_SIZE);
 	*cmdline_p = cmd_line;
 
 	parse_early_param();
diff -puN arch/ppc/platforms/lopec.c~dynamic-kernel-command-line-ppc arch/ppc/platforms/lopec.c
--- a/arch/ppc/platforms/lopec.c~dynamic-kernel-command-line-ppc
+++ a/arch/ppc/platforms/lopec.c
@@ -344,7 +344,7 @@ lopec_setup_arch(void)
 		 if (bootargs != NULL) {
 			 strcpy(cmd_line, bootargs);
 			 /* again.. */
-			 strcpy(saved_command_line, cmd_line);
+			 strcpy(boot_command_line, cmd_line);
 		}
 	}
 #endif
diff -puN arch/ppc/platforms/pplus.c~dynamic-kernel-command-line-ppc arch/ppc/platforms/pplus.c
--- a/arch/ppc/platforms/pplus.c~dynamic-kernel-command-line-ppc
+++ a/arch/ppc/platforms/pplus.c
@@ -592,7 +592,7 @@ static void __init pplus_setup_arch(void
 		if (bootargs != NULL) {
 			strcpy(cmd_line, bootargs);
 			/* again.. */
-			strcpy(saved_command_line, cmd_line);
+			strcpy(boot_command_line, cmd_line);
 		}
 	}
 #endif
diff -puN arch/ppc/platforms/prep_setup.c~dynamic-kernel-command-line-ppc arch/ppc/platforms/prep_setup.c
--- a/arch/ppc/platforms/prep_setup.c~dynamic-kernel-command-line-ppc
+++ a/arch/ppc/platforms/prep_setup.c
@@ -634,7 +634,7 @@ static void __init prep_init_sound(void)
 	/*
 	 * Find a way to push these informations to the cs4232 driver
 	 * Give it out with printk, when not in cmd_line?
-	 * Append it to  cmd_line and saved_command_line?
+	 * Append it to  cmd_line and boot_command_line?
 	 * Format is cs4232=io,irq,dma,dma2
 	 */
 }
@@ -897,7 +897,7 @@ prep_setup_arch(void)
 		 if (bootargs != NULL) {
 			 strcpy(cmd_line, bootargs);
 			 /* again.. */
-			 strcpy(saved_command_line, cmd_line);
+			 strcpy(boot_command_line, cmd_line);
 		}
 	}
 
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
