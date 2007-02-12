From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-xtensa.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:48:23 -0800
Message-ID: <200702122248.l1CMmN0F014008@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45514 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030379AbXBLWsZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:48:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, chris@zankel.net, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: xtensa
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-xtensa.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: xtensa
From: Alon Bar-Lev <alon.barlev@gmail.com>

1. Rename saved_command_line into boot_command_line.
2. Set command_line as __initdata.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/setup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/xtensa/kernel/setup.c~dynamic-kernel-command-line-xtensa arch/xtensa/kernel/setup.c
--- a/arch/xtensa/kernel/setup.c~dynamic-kernel-command-line-xtensa
+++ a/arch/xtensa/kernel/setup.c
@@ -78,7 +78,7 @@ extern unsigned long loops_per_jiffy;
 
 /* Command line specified as configuration option. */
 
-static char command_line[COMMAND_LINE_SIZE];
+static char __initdata command_line[COMMAND_LINE_SIZE];
 
 #ifdef CONFIG_CMDLINE_BOOL
 static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
@@ -253,8 +253,8 @@ void __init setup_arch(char **cmdline_p)
 	extern int mem_reserve(unsigned long, unsigned long, int);
 	extern void bootmem_init(void);
 
-	memcpy(saved_command_line, command_line, COMMAND_LINE_SIZE);
-	saved_command_line[COMMAND_LINE_SIZE-1] = '\0';
+	memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
+	boot_command_line[COMMAND_LINE_SIZE-1] = '\0';
 	*cmdline_p = command_line;
 
 	/* Reserve some memory regions */
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

origin.patch
