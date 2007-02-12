From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-sparc64.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:48:15 -0800
Message-ID: <200702122248.l1CMmFAG013992@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45499 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030376AbXBLWsT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:48:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: sparc64
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-sparc64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: sparc64
From: Alon Bar-Lev <alon.barlev@gmail.com>

Rename saved_command_line into boot_command_line.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/kernel/setup.c         |    2 +-
 arch/sparc64/kernel/sparc64_ksyms.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/sparc64/kernel/setup.c~dynamic-kernel-command-line-sparc64 arch/sparc64/kernel/setup.c
--- a/arch/sparc64/kernel/setup.c~dynamic-kernel-command-line-sparc64
+++ a/arch/sparc64/kernel/setup.c
@@ -315,7 +315,7 @@ void __init setup_arch(char **cmdline_p)
 {
 	/* Initialize PROM console and command line. */
 	*cmdline_p = prom_getbootargs();
-	strcpy(saved_command_line, *cmdline_p);
+	strcpy(boot_command_line, *cmdline_p);
 
 	if (tlb_type == hypervisor)
 		printk("ARCH: SUN4V\n");
diff -puN arch/sparc64/kernel/sparc64_ksyms.c~dynamic-kernel-command-line-sparc64 arch/sparc64/kernel/sparc64_ksyms.c
--- a/arch/sparc64/kernel/sparc64_ksyms.c~dynamic-kernel-command-line-sparc64
+++ a/arch/sparc64/kernel/sparc64_ksyms.c
@@ -253,7 +253,7 @@ EXPORT_SYMBOL(prom_getproplen);
 EXPORT_SYMBOL(prom_getproperty);
 EXPORT_SYMBOL(prom_node_has_property);
 EXPORT_SYMBOL(prom_setprop);
-EXPORT_SYMBOL(saved_command_line);
+EXPORT_SYMBOL(boot_command_line);
 EXPORT_SYMBOL(prom_finddevice);
 EXPORT_SYMBOL(prom_feval);
 EXPORT_SYMBOL(prom_getbool);
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

origin.patch
