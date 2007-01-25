From: akpm@osdl.org
Subject: + dynamic-kernel-command-line-sh64.patch added to -mm tree
Date: Wed, 24 Jan 2007 21:09:11 -0800
Message-ID: <200701250509.l0P59Bqv006552@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47199 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965320AbXAYFJP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 00:09:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alon.barlev@gmail.com, lethal@linux-sh.org


The patch titled
     Dynamic kernel command-line: sh64
has been added to the -mm tree.  Its filename is
     dynamic-kernel-command-line-sh64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Dynamic kernel command-line: sh64
From: Alon Bar-Lev <alon.barlev@gmail.com>

1. Rename saved_command_line into boot_command_line.
2. Set command_line as __initdata.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/sh64/kernel/setup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/sh64/kernel/setup.c~dynamic-kernel-command-line-sh64 arch/sh64/kernel/setup.c
--- a/arch/sh64/kernel/setup.c~dynamic-kernel-command-line-sh64
+++ a/arch/sh64/kernel/setup.c
@@ -83,7 +83,7 @@ extern int sh64_tlb_init(void);
 #define RAMDISK_PROMPT_FLAG		0x8000
 #define RAMDISK_LOAD_FLAG		0x4000
 
-static char command_line[COMMAND_LINE_SIZE] = { 0, };
+static char __initdata command_line[COMMAND_LINE_SIZE] = { 0, };
 unsigned long long memory_start = CONFIG_MEMORY_START;
 unsigned long long memory_end = CONFIG_MEMORY_START + (CONFIG_MEMORY_SIZE_IN_MB * 1024 * 1024);
 
@@ -95,8 +95,8 @@ static inline void parse_mem_cmdline (ch
 	int len = 0;
 
 	/* Save unparsed command line copy for /proc/cmdline */
-	memcpy(saved_command_line, COMMAND_LINE, COMMAND_LINE_SIZE);
-	saved_command_line[COMMAND_LINE_SIZE-1] = '\0';
+	memcpy(boot_command_line, COMMAND_LINE, COMMAND_LINE_SIZE);
+	boot_command_line[COMMAND_LINE_SIZE-1] = '\0';
 
 	for (;;) {
 	  /*
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
