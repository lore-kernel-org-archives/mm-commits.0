From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-x86_64.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:48:21 -0800
Message-ID: <200702122248.l1CMmLVE014005@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45522 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030348AbXBLWs3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:48:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, ak@muc.de, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: x86_64
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-x86_64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: x86_64
From: Alon Bar-Lev <alon.barlev@gmail.com>

1. Rename saved_command_line into boot_command_line.
2. Set command_line as __initdata.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/head64.c    |    4 ++--
 arch/x86_64/kernel/setup.c     |    6 +++---
 include/asm-x86_64/bootsetup.h |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/x86_64/kernel/head64.c~dynamic-kernel-command-line-x86_64 arch/x86_64/kernel/head64.c
--- a/arch/x86_64/kernel/head64.c~dynamic-kernel-command-line-x86_64
+++ a/arch/x86_64/kernel/head64.c
@@ -34,7 +34,7 @@ static void __init clear_bss(void)
 #define OLD_CL_BASE_ADDR        0x90000
 #define OLD_CL_OFFSET           0x90022
 
-extern char saved_command_line[];
+extern char __initdata boot_command_line[];
 
 static void __init copy_bootdata(char *real_mode_data)
 {
@@ -50,7 +50,7 @@ static void __init copy_bootdata(char *r
 		new_data = OLD_CL_BASE_ADDR + * (u16 *) OLD_CL_OFFSET;
 	}
 	command_line = (char *) ((u64)(new_data));
-	memcpy(saved_command_line, command_line, COMMAND_LINE_SIZE);
+	memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
 }
 
 void __init x86_64_start_kernel(char * real_mode_data)
diff -puN arch/x86_64/kernel/setup.c~dynamic-kernel-command-line-x86_64 arch/x86_64/kernel/setup.c
--- a/arch/x86_64/kernel/setup.c~dynamic-kernel-command-line-x86_64
+++ a/arch/x86_64/kernel/setup.c
@@ -100,7 +100,7 @@ EXPORT_SYMBOL_GPL(edid_info);
 
 extern int root_mountflags;
 
-char command_line[COMMAND_LINE_SIZE];
+char __initdata command_line[COMMAND_LINE_SIZE];
 
 struct resource standard_io_resources[] = {
 	{ .name = "dma1", .start = 0x00, .end = 0x1f,
@@ -343,7 +343,7 @@ static void discover_ebda(void)
 
 void __init setup_arch(char **cmdline_p)
 {
-	printk(KERN_INFO "Command line: %s\n", saved_command_line);
+	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 
  	ROOT_DEV = old_decode_dev(ORIG_ROOT_DEV);
  	screen_info = SCREEN_INFO;
@@ -373,7 +373,7 @@ void __init setup_arch(char **cmdline_p)
 
 	early_identify_cpu(&boot_cpu_data);
 
-	strlcpy(command_line, saved_command_line, COMMAND_LINE_SIZE);
+	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
 	parse_early_param();
diff -puN include/asm-x86_64/bootsetup.h~dynamic-kernel-command-line-x86_64 include/asm-x86_64/bootsetup.h
--- a/include/asm-x86_64/bootsetup.h~dynamic-kernel-command-line-x86_64
+++ a/include/asm-x86_64/bootsetup.h
@@ -31,7 +31,7 @@ extern char x86_boot_params[BOOT_PARAM_S
 #define EDD_MBR_SIG_NR (*(unsigned char *) (PARAM+EDD_MBR_SIG_NR_BUF))
 #define EDD_MBR_SIGNATURE ((unsigned int *) (PARAM+EDD_MBR_SIG_BUF))
 #define EDD_BUF     ((struct edd_info *) (PARAM+EDDBUF))
-#define COMMAND_LINE saved_command_line
+#define COMMAND_LINE boot_command_line
 
 #define RAMDISK_IMAGE_START_MASK  	0x07FF
 #define RAMDISK_PROMPT_FLAG		0x8000
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

origin.patch
