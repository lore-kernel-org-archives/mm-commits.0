From: akpm@linux-foundation.org
Subject: + cell-fix-cbe_thermal-for-legacy-slof-tree.patch added to -mm tree
Date: Wed, 18 Jul 2007 12:52:04 -0700
Message-ID: <200707181952.l6IJq4Ml025928@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56286 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754765AbXGRTxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 15:53:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jcd@tribudubois.net, arnd.bergmann@de.ibm.com, krafft@de.ibm.com


The patch titled
     cell: fix cbe_thermal for legacy SLOF tree.
has been added to the -mm tree.  Its filename is
     cell-fix-cbe_thermal-for-legacy-slof-tree.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cell: fix cbe_thermal for legacy SLOF tree.
From: Jean-Christophe DUBOIS <jcd@tribudubois.net>

Previous patch changed based on Christian Krafft's comment.

On some legacy SLOF tree the generic code is unable to ioremap some Cell BE
registers.  Therefore the "generic" functions are returning a NULL pointer,
triggering a crash on such platforms.

Let's handle this more gracefully.

Signed-off-by: Jean-Christophe DUBOIS <jcd@tribudubois.net>
Acked-by: Christian Kraff <krafft@de.ibm.com>
Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/cbe_thermal.c |   25 ++++++++++++++++----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff -puN arch/powerpc/platforms/cell/cbe_thermal.c~cell-fix-cbe_thermal-for-legacy-slof-tree arch/powerpc/platforms/cell/cbe_thermal.c
--- a/arch/powerpc/platforms/cell/cbe_thermal.c~cell-fix-cbe_thermal-for-legacy-slof-tree
+++ a/arch/powerpc/platforms/cell/cbe_thermal.c
@@ -292,7 +292,7 @@ static struct attribute_group ppe_attrib
 /*
  * initialize throttling with default values
  */
-static void __init init_default_values(void)
+static int __init init_default_values(void)
 {
 	int cpu;
 	struct cbe_pmd_regs __iomem *pmd_regs;
@@ -339,25 +339,40 @@ static void __init init_default_values(v
 	for_each_possible_cpu (cpu) {
 		pr_debug("processing cpu %d\n", cpu);
 		sysdev = get_cpu_sysdev(cpu);
+
+		if (!sysdev) {
+			pr_info("invalid sysdev pointer for cbe_thermal\n");
+			return -EINVAL;
+		}
+
 		pmd_regs = cbe_get_cpu_pmd_regs(sysdev->id);
 
+		if (!pmd_regs) {
+			pr_info("invalid CBE regs pointer for cbe_thermal\n");
+			return -EINVAL;
+		}
+
 		out_be64(&pmd_regs->tm_str2, str2);
 		out_be64(&pmd_regs->tm_str1.val, str1.val);
 		out_be64(&pmd_regs->tm_tpr.val, tpr.val);
 		out_be64(&pmd_regs->tm_cr1.val, cr1.val);
 		out_be64(&pmd_regs->tm_cr2, cr2);
 	}
+
+	return 0;
 }
 
 
 static int __init thermal_init(void)
 {
-	init_default_values();
+	int rc = init_default_values();
 
-	spu_add_sysdev_attr_group(&spu_attribute_group);
-	cpu_add_sysdev_attr_group(&ppe_attribute_group);
+	if (rc == 0) {
+		spu_add_sysdev_attr_group(&spu_attribute_group);
+		cpu_add_sysdev_attr_group(&ppe_attribute_group);
+	}
 
-	return 0;
+	return rc;
 }
 module_init(thermal_init);
 
_

Patches currently in -mm which might be from jcd@tribudubois.net are

cell-fix-cbe_cpufreq-for-legacy-slof-tree.patch
cell-fix-cbe_regc-for-legacy-slof-tree.patch
cell-fix-cbe_thermal-for-legacy-slof-tree.patch
cell-allow-linux-to-map-cell-regs-on-legacy-slof-tree.patch
