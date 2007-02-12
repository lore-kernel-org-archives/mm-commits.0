From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-arm.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:47:37 -0800
Message-ID: <200702122247.l1CMlb1u013919@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45413 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030351AbXBLWrw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:47:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: arm
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-arm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: arm
From: Alon Bar-Lev <alon.barlev@gmail.com>

1. Rename saved_command_line into boot_command_line.
2. Set command_line as __initdata.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/setup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/arm/kernel/setup.c~dynamic-kernel-command-line-arm arch/arm/kernel/setup.c
--- a/arch/arm/kernel/setup.c~dynamic-kernel-command-line-arm
+++ a/arch/arm/kernel/setup.c
@@ -106,7 +106,7 @@ unsigned long phys_initrd_size __initdat
 static struct meminfo meminfo __initdata = { 0, };
 static const char *cpu_name;
 static const char *machine_name;
-static char command_line[COMMAND_LINE_SIZE];
+static char __initdata command_line[COMMAND_LINE_SIZE];
 
 static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
 static union { char c[4]; unsigned long l; } endian_test __initdata = { { 'l', '?', '?', 'b' } };
@@ -803,8 +803,8 @@ void __init setup_arch(char **cmdline_p)
 	init_mm.end_data   = (unsigned long) &_edata;
 	init_mm.brk	   = (unsigned long) &_end;
 
-	memcpy(saved_command_line, from, COMMAND_LINE_SIZE);
-	saved_command_line[COMMAND_LINE_SIZE-1] = '\0';
+	memcpy(boot_command_line, from, COMMAND_LINE_SIZE);
+	boot_command_line[COMMAND_LINE_SIZE-1] = '\0';
 	parse_cmdline(cmdline_p, from);
 	paging_init(&meminfo, mdesc);
 	request_standard_resources(&meminfo, mdesc);
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

origin.patch
