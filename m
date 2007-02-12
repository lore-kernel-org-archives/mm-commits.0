From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-avr32.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:47:41 -0800
Message-ID: <200702122247.l1CMlfhf013927@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45381 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030340AbXBLWrp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:47:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: avr32
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-avr32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: avr32
From: Alon Bar-Lev <alon.barlev@gmail.com>

1. Rename saved_command_line into boot_command_line.
2. Set command_line as __initdata.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/kernel/setup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/avr32/kernel/setup.c~dynamic-kernel-command-line-avr32 arch/avr32/kernel/setup.c
--- a/arch/avr32/kernel/setup.c~dynamic-kernel-command-line-avr32
+++ a/arch/avr32/kernel/setup.c
@@ -45,7 +45,7 @@ struct avr32_cpuinfo boot_cpu_data = {
 };
 EXPORT_SYMBOL(boot_cpu_data);
 
-static char command_line[COMMAND_LINE_SIZE];
+static char __initdata command_line[COMMAND_LINE_SIZE];
 
 /*
  * Should be more than enough, but if you have a _really_ complex
@@ -202,7 +202,7 @@ __tagtable(ATAG_MEM, parse_tag_mem);
 
 static int __init parse_tag_cmdline(struct tag *tag)
 {
-	strlcpy(saved_command_line, tag->u.cmdline.cmdline, COMMAND_LINE_SIZE);
+	strlcpy(boot_command_line, tag->u.cmdline.cmdline, COMMAND_LINE_SIZE);
 	return 0;
 }
 __tagtable(ATAG_CMDLINE, parse_tag_cmdline);
@@ -294,7 +294,7 @@ void __init setup_arch (char **cmdline_p
 	init_mm.end_data = (unsigned long) &_edata;
 	init_mm.brk = (unsigned long) &_end;
 
-	strlcpy(command_line, saved_command_line, COMMAND_LINE_SIZE);
+	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 	parse_early_param();
 
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

origin.patch
