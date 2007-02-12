From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-m32r.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:47:53 -0800
Message-ID: <200702122247.l1CMlrDA013946@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45448 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030360AbXBLWsD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:48:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: m32r
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-m32r.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: m32r
From: Alon Bar-Lev <alon.barlev@gmail.com>

1. Rename saved_command_line into boot_command_line.
2. Set command_line as __initdata.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/setup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/m32r/kernel/setup.c~dynamic-kernel-command-line-m32r arch/m32r/kernel/setup.c
--- a/arch/m32r/kernel/setup.c~dynamic-kernel-command-line-m32r
+++ a/arch/m32r/kernel/setup.c
@@ -64,7 +64,7 @@ struct screen_info screen_info = {
 
 extern int root_mountflags;
 
-static char command_line[COMMAND_LINE_SIZE];
+static char __initdata command_line[COMMAND_LINE_SIZE];
 
 static struct resource data_resource = {
 	.name   = "Kernel data",
@@ -95,8 +95,8 @@ static __inline__ void parse_mem_cmdline
 	int usermem = 0;
 
 	/* Save unparsed command line copy for /proc/cmdline */
-	memcpy(saved_command_line, COMMAND_LINE, COMMAND_LINE_SIZE);
-	saved_command_line[COMMAND_LINE_SIZE-1] = '\0';
+	memcpy(boot_command_line, COMMAND_LINE, COMMAND_LINE_SIZE);
+	boot_command_line[COMMAND_LINE_SIZE-1] = '\0';
 
 	memory_start = (unsigned long)CONFIG_MEMORY_START+PAGE_OFFSET;
 	memory_end = memory_start+(unsigned long)CONFIG_MEMORY_SIZE;
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

origin.patch
