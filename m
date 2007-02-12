From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-sh64.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:48:11 -0800
Message-ID: <200702122248.l1CMmBVc013984@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45488 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030371AbXBLWsP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:48:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: sh64
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-sh64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: sh64
From: Alon Bar-Lev <alon.barlev@gmail.com>

1. Rename saved_command_line into boot_command_line.
2. Set command_line as __initdata.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

origin.patch
