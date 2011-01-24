From: akpm@linux-foundation.org
Subject: + drivers-dma-ipu-ipu_irqc-irq_data-conversion.patch added to -mm tree
Date: Mon, 24 Jan 2011 14:11:56 -0800
Message-ID: <201101242211.p0OMBuBv013748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124Ab1AXWMd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 17:12:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: buytenh@wantstofly.org, buytenh@secretlab.ca, dan.j.williams@intel.com, tglx@linutronix.de


The patch titled
     drivers/dma/ipu/ipu_irq.c: irq_data conversion
has been added to the -mm tree.  Its filename is
     drivers-dma-ipu-ipu_irqc-irq_data-conversion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/dma/ipu/ipu_irq.c: irq_data conversion
From: Lennert Buytenhek <buytenh@wantstofly.org>

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ipu/ipu_irq.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/dma/ipu/ipu_irq.c~drivers-dma-ipu-ipu_irqc-irq_data-conversion drivers/dma/ipu/ipu_irq.c
--- a/drivers/dma/ipu/ipu_irq.c~drivers-dma-ipu-ipu_irqc-irq_data-conversion
+++ a/drivers/dma/ipu/ipu_irq.c
@@ -94,9 +94,9 @@ static struct ipu_irq_map *src2map(unsig
 	return NULL;
 }
 
-static void ipu_irq_unmask(unsigned int irq)
+static void ipu_irq_unmask(struct irq_data *d)
 {
-	struct ipu_irq_map *map = get_irq_chip_data(irq);
+	struct ipu_irq_map *map = irq_data_get_irq_chip_data(d);
 	struct ipu_irq_bank *bank;
 	uint32_t reg;
 	unsigned long lock_flags;
@@ -106,7 +106,7 @@ static void ipu_irq_unmask(unsigned int 
 	bank = map->bank;
 	if (!bank) {
 		spin_unlock_irqrestore(&bank_lock, lock_flags);
-		pr_err("IPU: %s(%u) - unmapped!\n", __func__, irq);
+		pr_err("IPU: %s(%u) - unmapped!\n", __func__, d->irq);
 		return;
 	}
 
@@ -117,9 +117,9 @@ static void ipu_irq_unmask(unsigned int 
 	spin_unlock_irqrestore(&bank_lock, lock_flags);
 }
 
-static void ipu_irq_mask(unsigned int irq)
+static void ipu_irq_mask(struct irq_data *d)
 {
-	struct ipu_irq_map *map = get_irq_chip_data(irq);
+	struct ipu_irq_map *map = irq_data_get_irq_chip_data(d);
 	struct ipu_irq_bank *bank;
 	uint32_t reg;
 	unsigned long lock_flags;
@@ -129,7 +129,7 @@ static void ipu_irq_mask(unsigned int ir
 	bank = map->bank;
 	if (!bank) {
 		spin_unlock_irqrestore(&bank_lock, lock_flags);
-		pr_err("IPU: %s(%u) - unmapped!\n", __func__, irq);
+		pr_err("IPU: %s(%u) - unmapped!\n", __func__, d->irq);
 		return;
 	}
 
@@ -140,9 +140,9 @@ static void ipu_irq_mask(unsigned int ir
 	spin_unlock_irqrestore(&bank_lock, lock_flags);
 }
 
-static void ipu_irq_ack(unsigned int irq)
+static void ipu_irq_ack(struct irq_data *d)
 {
-	struct ipu_irq_map *map = get_irq_chip_data(irq);
+	struct ipu_irq_map *map = irq_data_get_irq_chip_data(d);
 	struct ipu_irq_bank *bank;
 	unsigned long lock_flags;
 
@@ -151,7 +151,7 @@ static void ipu_irq_ack(unsigned int irq
 	bank = map->bank;
 	if (!bank) {
 		spin_unlock_irqrestore(&bank_lock, lock_flags);
-		pr_err("IPU: %s(%u) - unmapped!\n", __func__, irq);
+		pr_err("IPU: %s(%u) - unmapped!\n", __func__, d->irq);
 		return;
 	}
 
@@ -345,10 +345,10 @@ static void ipu_irq_fn(unsigned int irq,
 }
 
 static struct irq_chip ipu_irq_chip = {
-	.name	= "ipu_irq",
-	.ack	= ipu_irq_ack,
-	.mask	= ipu_irq_mask,
-	.unmask	= ipu_irq_unmask,
+	.name		= "ipu_irq",
+	.irq_ack	= ipu_irq_ack,
+	.irq_mask	= ipu_irq_mask,
+	.irq_unmask	= ipu_irq_unmask,
 };
 
 /* Install the IRQ handler */
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

drivers-dma-ipu-ipu_irqc-irq_data-conversion.patch

