From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-h8300.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:47:47 -0800
Message-ID: <200702122247.l1CMllmR013936@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45412 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030214AbXBLWrv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:47:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: h8300
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-h8300.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: h8300
From: Alon Bar-Lev <alon.barlev@gmail.com>

1. Rename saved_command_line into boot_command_line.
2. Set command_line as __initdata.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/setup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/h8300/kernel/setup.c~dynamic-kernel-command-line-h8300 arch/h8300/kernel/setup.c
--- a/arch/h8300/kernel/setup.c~dynamic-kernel-command-line-h8300
+++ a/arch/h8300/kernel/setup.c
@@ -54,7 +54,7 @@ unsigned long rom_length;
 unsigned long memory_start;
 unsigned long memory_end;
 
-char command_line[COMMAND_LINE_SIZE];
+char __initdata command_line[COMMAND_LINE_SIZE];
 
 extern int _stext, _etext, _sdata, _edata, _sbss, _ebss, _end;
 extern int _ramstart, _ramend;
@@ -154,8 +154,8 @@ void __init setup_arch(char **cmdline_p)
 #endif
 	/* Keep a copy of command line */
 	*cmdline_p = &command_line[0];
-	memcpy(saved_command_line, command_line, COMMAND_LINE_SIZE);
-	saved_command_line[COMMAND_LINE_SIZE-1] = 0;
+	memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
+	boot_command_line[COMMAND_LINE_SIZE-1] = 0;
 
 #ifdef DEBUG
 	if (strlen(*cmdline_p)) 
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

origin.patch
