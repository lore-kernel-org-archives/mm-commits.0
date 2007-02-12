From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-cris.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:47:43 -0800
Message-ID: <200702122247.l1CMlhni013930@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45397 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030344AbXBLWrs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:47:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: cris
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-cris.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: cris
From: Alon Bar-Lev <alon.barlev@gmail.com>

1. Rename saved_command_line into boot_command_line.
2. Set cris_command_line as __initdata.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/kernel/setup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/cris/kernel/setup.c~dynamic-kernel-command-line-cris arch/cris/kernel/setup.c
--- a/arch/cris/kernel/setup.c~dynamic-kernel-command-line-cris
+++ a/arch/cris/kernel/setup.c
@@ -29,7 +29,7 @@ struct screen_info screen_info;
 extern int root_mountflags;
 extern char _etext, _edata, _end;
 
-char cris_command_line[COMMAND_LINE_SIZE] = { 0, };
+char __initdata cris_command_line[COMMAND_LINE_SIZE] = { 0, };
 
 extern const unsigned long text_start, edata; /* set by the linker script */
 extern unsigned long dram_start, dram_end;
@@ -153,8 +153,8 @@ setup_arch(char **cmdline_p)
 #endif
 
 	/* Save command line for future references. */
-	memcpy(saved_command_line, cris_command_line, COMMAND_LINE_SIZE);
-	saved_command_line[COMMAND_LINE_SIZE - 1] = '\0';
+	memcpy(boot_command_line, cris_command_line, COMMAND_LINE_SIZE);
+	boot_command_line[COMMAND_LINE_SIZE - 1] = '\0';
 
 	/* give credit for the CRIS port */
 	show_etrax_copyright();
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

origin.patch
