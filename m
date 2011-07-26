From: akpm@linux-foundation.org
Subject: [merged] x86-olpc-move-cs5536-related-constants-to-cs5535h.patch removed from -mm tree
Date: Tue, 26 Jul 2011 13:33:49 -0700
Message-ID: <201107262032.p6QKWkeA007265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753641Ab1GZUdE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 16:33:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dsd@laptop.org, dilinger@queued.net, grant.likely@secretlab.ca, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86, olpc: move CS5536-related constants to cs5535.h
has been removed from the -mm tree.  Its filename was
     x86-olpc-move-cs5536-related-constants-to-cs5535h.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86, olpc: move CS5536-related constants to cs5535.h
From: Daniel Drake <dsd@laptop.org>

Move these definitions into the relevant header file.  This was requested
in the review of the upcoming XO-1 suspend/resume code.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Andres Salomon <dilinger@queued.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/olpc/olpc-xo1.c |   26 ++++++++------------------
 include/linux/cs5535.h            |   21 +++++++++++++++++++++
 2 files changed, 29 insertions(+), 18 deletions(-)

diff -puN arch/x86/platform/olpc/olpc-xo1.c~x86-olpc-move-cs5536-related-constants-to-cs5535h arch/x86/platform/olpc/olpc-xo1.c
--- a/arch/x86/platform/olpc/olpc-xo1.c~x86-olpc-move-cs5536-related-constants-to-cs5535h
+++ a/arch/x86/platform/olpc/olpc-xo1.c
@@ -12,6 +12,7 @@
  * (at your option) any later version.
  */
 
+#include <linux/cs5535.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
@@ -22,17 +23,6 @@
 
 #define DRV_NAME "olpc-xo1"
 
-/* PMC registers (PMS block) */
-#define PM_SCLK		0x10
-#define PM_IN_SLPCTL	0x20
-#define PM_WKXD		0x34
-#define PM_WKD		0x30
-#define PM_SSC		0x54
-
-/* PM registers (ACPI block) */
-#define PM1_CNT		0x08
-#define PM_GPE0_STS	0x18
-
 static unsigned long acpi_base;
 static unsigned long pms_base;
 
@@ -41,17 +31,17 @@ static void xo1_power_off(void)
 	printk(KERN_INFO "OLPC XO-1 power off sequence...\n");
 
 	/* Enable all of these controls with 0 delay */
-	outl(0x40000000, pms_base + PM_SCLK);
-	outl(0x40000000, pms_base + PM_IN_SLPCTL);
-	outl(0x40000000, pms_base + PM_WKXD);
-	outl(0x40000000, pms_base + PM_WKD);
+	outl(0x40000000, pms_base + CS5536_PM_SCLK);
+	outl(0x40000000, pms_base + CS5536_PM_IN_SLPCTL);
+	outl(0x40000000, pms_base + CS5536_PM_WKXD);
+	outl(0x40000000, pms_base + CS5536_PM_WKD);
 
 	/* Clear status bits (possibly unnecessary) */
-	outl(0x0002ffff, pms_base  + PM_SSC);
-	outl(0xffffffff, acpi_base + PM_GPE0_STS);
+	outl(0x0002ffff, pms_base  + CS5536_PM_SSC);
+	outl(0xffffffff, acpi_base + CS5536_PM_GPE0_STS);
 
 	/* Write SLP_EN bit to start the machinery */
-	outl(0x00002000, acpi_base + PM1_CNT);
+	outl(0x00002000, acpi_base + CS5536_PM1_CNT);
 }
 
 static int __devinit olpc_xo1_probe(struct platform_device *pdev)
diff -puN include/linux/cs5535.h~x86-olpc-move-cs5536-related-constants-to-cs5535h include/linux/cs5535.h
--- a/include/linux/cs5535.h~x86-olpc-move-cs5536-related-constants-to-cs5535h
+++ a/include/linux/cs5535.h
@@ -49,6 +49,27 @@
 #define LBAR_ACPI_SIZE		0x40
 #define LBAR_PMS_SIZE		0x80
 
+/*
+ * PMC registers (PMS block)
+ * It is only safe to access these registers as dword accesses.
+ * See CS5536 Specification Update erratas 17 & 18
+ */
+#define CS5536_PM_SCLK		0x10
+#define CS5536_PM_IN_SLPCTL	0x20
+#define CS5536_PM_WKXD		0x34
+#define CS5536_PM_WKD		0x30
+#define CS5536_PM_SSC		0x54
+
+/*
+ * PM registers (ACPI block)
+ * It is only safe to access these registers as dword accesses.
+ * See CS5536 Specification Update erratas 17 & 18
+ */
+#define CS5536_PM1_STS		0x00
+#define CS5536_PM1_EN		0x02
+#define CS5536_PM1_CNT		0x08
+#define CS5536_PM_GPE0_STS	0x18
+
 /* VSA2 magic values */
 #define VSA_VRC_INDEX		0xAC1C
 #define VSA_VRC_DATA		0xAC1E
_

Patches currently in -mm which might be from dsd@laptop.org are

origin.patch
linux-next.patch

