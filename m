From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-arm26.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:47:39 -0800
Message-ID: <200702122247.l1CMld3k013922@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45388 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030341AbXBLWrq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:47:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, spyro@f2s.com, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: arm26
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-arm26.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: arm26
From: Alon Bar-Lev <alon.barlev@gmail.com>

1. Rename saved_command_line into boot_command_line.
2. Set command_line as __initdata.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Ian Molton <spyro@f2s.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm26/kernel/setup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/arm26/kernel/setup.c~dynamic-kernel-command-line-arm26 arch/arm26/kernel/setup.c
--- a/arch/arm26/kernel/setup.c~dynamic-kernel-command-line-arm26
+++ a/arch/arm26/kernel/setup.c
@@ -80,7 +80,7 @@ unsigned long phys_initrd_size __initdat
 static struct meminfo meminfo __initdata = { 0, };
 static struct proc_info_item proc_info;
 static const char *machine_name;
-static char command_line[COMMAND_LINE_SIZE];
+static char __initdata command_line[COMMAND_LINE_SIZE];
 
 static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
 
@@ -492,8 +492,8 @@ void __init setup_arch(char **cmdline_p)
 	init_mm.end_data   = (unsigned long) &_edata;
 	init_mm.brk	   = (unsigned long) &_end;
 
-	memcpy(saved_command_line, from, COMMAND_LINE_SIZE);
-	saved_command_line[COMMAND_LINE_SIZE-1] = '\0';
+	memcpy(boot_command_line, from, COMMAND_LINE_SIZE);
+	boot_command_line[COMMAND_LINE_SIZE-1] = '\0';
 	parse_cmdline(&meminfo, cmdline_p, from);
 	bootmem_init(&meminfo);
 	paging_init(&meminfo);
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

origin.patch
