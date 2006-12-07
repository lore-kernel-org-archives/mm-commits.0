From: akpm@osdl.org
Subject: - export-pm_suspend-for-the-shared-apm-emulation.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:01:58 -0800
Message-ID: <200612072301.kB7N1wfU029823@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51698 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163792AbWLGXCc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:02:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, lethal@linux-sh.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Export pm_suspend for the shared APM emulation
has been removed from the -mm tree.  Its filename was
     export-pm_suspend-for-the-shared-apm-emulation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Export pm_suspend for the shared APM emulation
From: Ralf Baechle <ralf@linux-mips.org>

The new shared APM emulation just like its ARM and MIPS predecessors uses
pm_suspend() which was only exported on SH.  Move export to close to it's
definition where it really should be anyway.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/sh/kernel/sh_ksyms.c |    4 ----
 kernel/power/main.c       |    3 ++-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -puN arch/sh/kernel/sh_ksyms.c~export-pm_suspend-for-the-shared-apm-emulation arch/sh/kernel/sh_ksyms.c
--- a/arch/sh/kernel/sh_ksyms.c~export-pm_suspend-for-the-shared-apm-emulation
+++ a/arch/sh/kernel/sh_ksyms.c
@@ -99,10 +99,6 @@ EXPORT_SYMBOL(__down_trylock);
 EXPORT_SYMBOL(synchronize_irq);
 #endif
 
-#ifdef CONFIG_PM
-EXPORT_SYMBOL(pm_suspend);
-#endif
-
 EXPORT_SYMBOL(csum_partial);
 #ifdef CONFIG_IPV6
 EXPORT_SYMBOL(csum_ipv6_magic);
diff -puN kernel/power/main.c~export-pm_suspend-for-the-shared-apm-emulation kernel/power/main.c
--- a/kernel/power/main.c~export-pm_suspend-for-the-shared-apm-emulation
+++ a/kernel/power/main.c
@@ -8,6 +8,7 @@
  *
  */
 
+#include <linux/module.h>
 #include <linux/suspend.h>
 #include <linux/kobject.h>
 #include <linux/string.h>
@@ -230,7 +231,7 @@ int pm_suspend(suspend_state_t state)
 	return -EINVAL;
 }
 
-
+EXPORT_SYMBOL(pm_suspend);
 
 decl_subsys(power,NULL,NULL);
 
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
mips-dbg_io-stray-brackets-fix.patch
mmc-fix-syntax-error.patch
git-mtd.patch
pci-legacy-resource-fix.patch
pci-legacy-resource-fix-tidy.patch
generic-ioremap_page_range-mips-conversion.patch

