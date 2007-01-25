From: akpm@osdl.org
Subject: + dynamic-kernel-command-line-x86_64.patch added to -mm tree
Date: Wed, 24 Jan 2007 21:09:20 -0800
Message-ID: <200701250509.l0P59KSJ006570@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47251 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965334AbXAYFJ3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 00:09:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alon.barlev@gmail.com, ak@muc.de


The patch titled
     Dynamic kernel command-line: x86_64
has been added to the -mm tree.  Its filename is
     dynamic-kernel-command-line-x86_64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Dynamic kernel command-line: x86_64
From: Alon Bar-Lev <alon.barlev@gmail.com>

1. Rename saved_command_line into boot_command_line.
2. Set command_line as __initdata.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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
