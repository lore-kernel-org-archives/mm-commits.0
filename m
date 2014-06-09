From: akpm@linux-foundation.org
Subject: [merged] arm-at91-fix-rtc-irq-mask-for-sam9x5-socs.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:30:42 -0700
Message-ID: <53960b62.NU80G6wbi0CZIs9R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbaFITan (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:30:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, plagnioj@jcrosoft.com, nicolas.ferre@atmel.com, mark.roszko@gmail.com, linux@maxim.org.za, johan@hovold.com, bevenson@melinkcorp.com, a.zummo@towertech.it, boris.brezillon@free-electrons.com

Subject: [merged] arm-at91-fix-rtc-irq-mask-for-sam9x5-socs.patch removed from -mm tree
To: boris.brezillon@free-electrons.com,a.zummo@towertech.it,bevenson@melinkcorp.com,johan@hovold.com,linux@maxim.org.za,mark.roszko@gmail.com,nicolas.ferre@atmel.com,plagnioj@jcrosoft.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:30:42 -0700


The patch titled
     Subject: ARM: at91: fix at91_sysirq_mask_rtc for sam9x5 SoCs
has been removed from the -mm tree.  Its filename was
     arm-at91-fix-rtc-irq-mask-for-sam9x5-socs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: ARM: at91: fix at91_sysirq_mask_rtc for sam9x5 SoCs

sam9x5 SoCs have the following errata:
"RTC: Interrupt Mask Register cannot be used
 Interrupt Mask Register read always returns 0."

Hence we should not rely on what IMR claims about already masked IRQs
and just disable all IRQs.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Reported-by: Bryan Evenson <bevenson@melinkcorp.com>
Reviewed-by: Johan Hovold <johan@hovold.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Bryan Evenson <bevenson@melinkcorp.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Mark Roszko <mark.roszko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-at91/sysirq_mask.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff -puN arch/arm/mach-at91/sysirq_mask.c~arm-at91-fix-rtc-irq-mask-for-sam9x5-socs arch/arm/mach-at91/sysirq_mask.c
--- a/arch/arm/mach-at91/sysirq_mask.c~arm-at91-fix-rtc-irq-mask-for-sam9x5-socs
+++ a/arch/arm/mach-at91/sysirq_mask.c
@@ -25,24 +25,28 @@
 
 #include "generic.h"
 
-#define AT91_RTC_IDR	0x24	/* Interrupt Disable Register */
-#define AT91_RTC_IMR	0x28	/* Interrupt Mask Register */
+#define AT91_RTC_IDR		0x24	/* Interrupt Disable Register */
+#define AT91_RTC_IMR		0x28	/* Interrupt Mask Register */
+#define AT91_RTC_IRQ_MASK	0x1f	/* Available IRQs mask */
 
 void __init at91_sysirq_mask_rtc(u32 rtc_base)
 {
 	void __iomem *base;
-	u32 mask;
 
 	base = ioremap(rtc_base, 64);
 	if (!base)
 		return;
 
-	mask = readl_relaxed(base + AT91_RTC_IMR);
-	if (mask) {
-		pr_info("AT91: Disabling rtc irq\n");
-		writel_relaxed(mask, base + AT91_RTC_IDR);
-		(void)readl_relaxed(base + AT91_RTC_IMR);	/* flush */
-	}
+	/*
+	 * sam9x5 SoCs have the following errata:
+	 * "RTC: Interrupt Mask Register cannot be used
+	 *  Interrupt Mask Register read always returns 0."
+	 *
+	 * Hence we're not relying on IMR values to disable
+	 * interrupts.
+	 */
+	writel_relaxed(AT91_RTC_IRQ_MASK, base + AT91_RTC_IDR);
+	(void)readl_relaxed(base + AT91_RTC_IMR);	/* flush */
 
 	iounmap(base);
 }
_

Patches currently in -mm which might be from boris.brezillon@free-electrons.com are

origin.patch
linux-next.patch

