From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-i386.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:47:49 -0800
Message-ID: <200702122247.l1CMln8u013940@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45434 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030357AbXBLWr6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:47:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, ak@muc.de, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: i386
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-i386.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: i386
From: Alon Bar-Lev <alon.barlev@gmail.com>

1. Rename saved_command_line into boot_command_line.
2. Set command_line as __initdata.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/head.S  |    2 +-
 arch/i386/kernel/setup.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/i386/kernel/head.S~dynamic-kernel-command-line-i386 arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S~dynamic-kernel-command-line-i386
+++ a/arch/i386/kernel/head.S
@@ -103,7 +103,7 @@ ENTRY(startup_32)
 	movzwl OLD_CL_OFFSET,%esi
 	addl $(OLD_CL_BASE_ADDR),%esi
 2:
-	movl $(saved_command_line - __PAGE_OFFSET),%edi
+	movl $(boot_command_line - __PAGE_OFFSET),%edi
 	movl $(COMMAND_LINE_SIZE/4),%ecx
 	rep
 	movsl
diff -puN arch/i386/kernel/setup.c~dynamic-kernel-command-line-i386 arch/i386/kernel/setup.c
--- a/arch/i386/kernel/setup.c~dynamic-kernel-command-line-i386
+++ a/arch/i386/kernel/setup.c
@@ -132,7 +132,7 @@ unsigned long saved_videomode;
 #define RAMDISK_PROMPT_FLAG		0x8000
 #define RAMDISK_LOAD_FLAG		0x4000	
 
-static char command_line[COMMAND_LINE_SIZE];
+static char __initdata command_line[COMMAND_LINE_SIZE];
 
 unsigned char __initdata boot_params[PARAM_SIZE];
 
@@ -576,7 +576,7 @@ void __init setup_arch(char **cmdline_p)
 		print_memory_map("user");
 	}
 
-	strlcpy(command_line, saved_command_line, COMMAND_LINE_SIZE);
+	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
 	max_low_pfn = setup_memory();
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

origin.patch
