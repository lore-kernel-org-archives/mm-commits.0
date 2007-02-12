From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-ppc.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:48:05 -0800
Message-ID: <200702122248.l1CMm5gc013973@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45469 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030367AbXBLWsJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:48:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: ppc
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-ppc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: ppc
From: Alon Bar-Lev <alon.barlev@gmail.com>

Rename saved_command_line into boot_command_line.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

origin.patch
