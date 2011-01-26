From: akpm@linux-foundation.org
Subject: [merged] langwell_gpio-modify-eoi-handling-following-change-of-kernel-irq-subsystem.patch removed from -mm tree
Date: Wed, 26 Jan 2011 12:32:26 -0800
Message-ID: <201101262032.p0QKWQBT003171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754122Ab1AZUcf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Jan 2011 15:32:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: feng.tang@intel.com, alan@lxorguk.ukuu.org.uk, alek.du@intel.com, mm-commits@vger.kernel.org


The patch titled
     langwell_gpio: modify EOI handling following change of kernel irq subsystem
has been removed from the -mm tree.  Its filename was
     langwell_gpio-modify-eoi-handling-following-change-of-kernel-irq-subsystem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: langwell_gpio: modify EOI handling following change of kernel irq subsystem
From: Feng Tang <feng.tang@intel.com>

Latest kernel has many changes in IRQ subsystem and its interfaces, like
adding "irq_eoi" for struct irq_chip, this patch is a follow up change for
that.

Also remove the unnecessary cast for a "void *".

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Alek Du <alek.du@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/langwell_gpio.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/gpio/langwell_gpio.c~langwell_gpio-modify-eoi-handling-following-change-of-kernel-irq-subsystem drivers/gpio/langwell_gpio.c
--- a/drivers/gpio/langwell_gpio.c~langwell_gpio-modify-eoi-handling-following-change-of-kernel-irq-subsystem
+++ a/drivers/gpio/langwell_gpio.c
@@ -187,7 +187,7 @@ MODULE_DEVICE_TABLE(pci, lnw_gpio_ids);
 
 static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 {
-	struct lnw_gpio *lnw = (struct lnw_gpio *)get_irq_data(irq);
+	struct lnw_gpio *lnw = get_irq_data(irq);
 	u32 base, gpio;
 	void __iomem *gedr;
 	u32 gedr_v;
@@ -206,7 +206,12 @@ static void lnw_irq_handler(unsigned irq
 		/* clear the edge detect status bit */
 		writel(gedr_v, gedr);
 	}
-	desc->chip->eoi(irq);
+
+	if (desc->chip->irq_eoi)
+		desc->chip->irq_eoi(irq_get_irq_data(irq));
+	else
+		dev_warn(lnw->chip.dev, "missing EOI handler for irq %d\n", irq);
+
 }
 
 static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
_

Patches currently in -mm which might be from feng.tang@intel.com are

origin.patch
console-prevent-registered-consoles-from-dumping-old-kernel-message-over-again.patch

