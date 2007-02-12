From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-m68knommu.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:47:57 -0800
Message-ID: <200702122247.l1CMlvmL013954@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45526 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030339AbXBLWsb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:48:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: m68knommu
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-m68knommu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: m68knommu
From: Alon Bar-Lev <alon.barlev@gmail.com>

1. Rename saved_command_line into boot_command_line.
2. Set command_line as __initdata.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/kernel/setup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/m68knommu/kernel/setup.c~dynamic-kernel-command-line-m68knommu arch/m68knommu/kernel/setup.c
--- a/arch/m68knommu/kernel/setup.c~dynamic-kernel-command-line-m68knommu
+++ a/arch/m68knommu/kernel/setup.c
@@ -44,7 +44,7 @@ unsigned long memory_end;
 EXPORT_SYMBOL(memory_start);
 EXPORT_SYMBOL(memory_end);
 
-char command_line[COMMAND_LINE_SIZE];
+char __initdata command_line[COMMAND_LINE_SIZE];
 
 /* setup some dummy routines */
 static void dummy_waitbut(void)
@@ -231,8 +231,8 @@ void setup_arch(char **cmdline_p)
 
 	/* Keep a copy of command line */
 	*cmdline_p = &command_line[0];
-	memcpy(saved_command_line, command_line, COMMAND_LINE_SIZE);
-	saved_command_line[COMMAND_LINE_SIZE-1] = 0;
+	memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
+	boot_command_line[COMMAND_LINE_SIZE-1] = 0;
 
 #ifdef DEBUG
 	if (strlen(*cmdline_p))
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

origin.patch
