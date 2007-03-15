From: akpm@linux-foundation.org
Subject: + powerpc-fix-breakage-caused-by-72486f1f8f0a2bc828b9d30cf4690cf2dd6807fc.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:48:51 -0800
Message-ID: <200703151848.l2FImrDq023262@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35405 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320AbXCOStS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:49:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pochini@shiny.it, benh@kernel.crashing.org, paulus@samba.org, rmk@arm.linux.org.uk


The patch titled
     powerpc: fix breakage caused by 72486f1f8f0a2bc828b9d30cf4690cf2dd6807fc
has been added to the -mm tree.  Its filename is
     powerpc-fix-breakage-caused-by-72486f1f8f0a2bc828b9d30cf4690cf2dd6807fc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc: fix breakage caused by 72486f1f8f0a2bc828b9d30cf4690cf2dd6807fc
From: Giuliano Pochini <pochini@shiny.it>

72486f1f8f0a2bc828b9d30cf4690cf2dd6807fc inverted the sense for enabling
hotplug CPU controls without reference to any other architecture other than
i386, ia64 and PowerPC.  This left everyone else without hotplug CPU control.

Fix powerpc for this brain damage.

(akpm: patch adapted from rmk's ARM fix.  Changelog stolen from rmk)

Signed-off-by: Giuliano Pochini <pochini@shiny.it>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/setup_32.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN arch/powerpc/kernel/setup_32.c~powerpc-fix-breakage-caused-by-72486f1f8f0a2bc828b9d30cf4690cf2dd6807fc arch/powerpc/kernel/setup_32.c
--- a/arch/powerpc/kernel/setup_32.c~powerpc-fix-breakage-caused-by-72486f1f8f0a2bc828b9d30cf4690cf2dd6807fc
+++ a/arch/powerpc/kernel/setup_32.c
@@ -195,18 +195,22 @@ EXPORT_SYMBOL(nvram_sync);
 
 #endif /* CONFIG_NVRAM */
 
-static struct cpu cpu_devices[NR_CPUS];
+static DEFINE_PER_CPU(struct cpu, cpu_devices);
 
 int __init ppc_init(void)
 {
-	int i;
+	int cpu;
 
 	/* clear the progress line */
-	if ( ppc_md.progress ) ppc_md.progress("             ", 0xffff);
+	if (ppc_md.progress)
+		ppc_md.progress("             ", 0xffff);
 
 	/* register CPU devices */
-	for_each_possible_cpu(i)
-		register_cpu(&cpu_devices[i], i);
+	for_each_possible_cpu(cpu) {
+		struct cpu *c = &per_cpu(cpu_devices, cpu);
+		c->hotpluggable = 1;
+		register_cpu(c, cpu);
+	}
 
 	/* call platform init */
 	if (ppc_md.init != NULL) {
_

Patches currently in -mm which might be from pochini@shiny.it are

powerpc-fix-breakage-caused-by-72486f1f8f0a2bc828b9d30cf4690cf2dd6807fc.patch
