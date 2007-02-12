From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-frv.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:47:45 -0800
Message-ID: <200702122247.l1CMlje8013933@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45428 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030356AbXBLWr5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:47:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: frv
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-frv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: frv
From: Alon Bar-Lev <alon.barlev@gmail.com>

1. Rename saved_command_line into boot_command_line.
2. Set command_line as __initdata.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/setup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/frv/kernel/setup.c~dynamic-kernel-command-line-frv arch/frv/kernel/setup.c
--- a/arch/frv/kernel/setup.c~dynamic-kernel-command-line-frv
+++ a/arch/frv/kernel/setup.c
@@ -110,7 +110,7 @@ unsigned long __initdata num_mappedpages
 
 struct cpuinfo_frv __nongprelbss boot_cpu_data;
 
-char command_line[COMMAND_LINE_SIZE];
+char __initdata command_line[COMMAND_LINE_SIZE];
 char __initdata redboot_command_line[COMMAND_LINE_SIZE];
 
 #ifdef CONFIG_PM
@@ -762,7 +762,7 @@ void __init setup_arch(char **cmdline_p)
 	printk("uClinux FR-V port done by Red Hat Inc <dhowells@redhat.com>\n");
 #endif
 
-	memcpy(saved_command_line, redboot_command_line, COMMAND_LINE_SIZE);
+	memcpy(boot_command_line, redboot_command_line, COMMAND_LINE_SIZE);
 
 	determine_cpu();
 	determine_clocks(1);
@@ -803,7 +803,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	/* deal with the command line - RedBoot may have passed one to the kernel */
-	memcpy(command_line, saved_command_line, sizeof(command_line));
+	memcpy(command_line, boot_command_line, sizeof(command_line));
 	*cmdline_p = &command_line[0];
 	parse_cmdline_early(command_line);
 
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

origin.patch
