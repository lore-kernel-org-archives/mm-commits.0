From: akpm@linux-foundation.org
Subject: - pnp-add-pnp_possible_config-can-a-device-could-be-configured-this-way.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:03:11 -0700
Message-ID: <200806232103.m5NL3BZP016142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758007AbYFWVDx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:03:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@keyaccess.nl, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de, mm-commit


The patch titled
     pnp: add pnp_possible_config() -- can a device could be configured this way?
has been removed from the -mm tree.  Its filename was
     pnp-add-pnp_possible_config-can-a-device-could-be-configured-this-way.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: add pnp_possible_config() -- can a device could be configured this way?
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

As part of a heuristic to identify modem devices, 8250_pnp.c checks to see
whether a device can be configured at any of the legacy COM port
addresses.

This patch moves the code that traverses the PNP "possible resource
options" from 8250_pnp.c to the PNP subsystem.  This encapsulation is
important because a future patch will change the implementation of those
resource options.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/resource.c    |   61 ++++++++++++++++++++++++++++++++++++
 drivers/serial/8250_pnp.c |   24 ++++----------
 include/linux/pnp.h       |    3 +
 3 files changed, 71 insertions(+), 17 deletions(-)

diff -puN drivers/pnp/resource.c~pnp-add-pnp_possible_config-can-a-device-could-be-configured-this-way drivers/pnp/resource.c
--- a/drivers/pnp/resource.c~pnp-add-pnp_possible_config-can-a-device-could-be-configured-this-way
+++ a/drivers/pnp/resource.c
@@ -624,6 +624,67 @@ struct pnp_resource *pnp_add_mem_resourc
 	return pnp_res;
 }
 
+static int pnp_possible_option(struct pnp_option *option, int type,
+			       resource_size_t start, resource_size_t size)
+{
+	struct pnp_option *tmp;
+	struct pnp_port *port;
+	struct pnp_mem *mem;
+	struct pnp_irq *irq;
+	struct pnp_dma *dma;
+
+	if (!option)
+		return 0;
+
+	for (tmp = option; tmp; tmp = tmp->next) {
+		switch (type) {
+		case IORESOURCE_IO:
+			for (port = tmp->port; port; port = port->next) {
+				if (port->min == start && port->size == size)
+					return 1;
+			}
+			break;
+		case IORESOURCE_MEM:
+			for (mem = tmp->mem; mem; mem = mem->next) {
+				if (mem->min == start && mem->size == size)
+					return 1;
+			}
+			break;
+		case IORESOURCE_IRQ:
+			for (irq = tmp->irq; irq; irq = irq->next) {
+				if (start < PNP_IRQ_NR &&
+				    test_bit(start, irq->map))
+					return 1;
+			}
+			break;
+		case IORESOURCE_DMA:
+			for (dma = tmp->dma; dma; dma = dma->next) {
+				if (dma->map & (1 << start))
+					return 1;
+			}
+			break;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Determine whether the specified resource is a possible configuration
+ * for this device.
+ */
+int pnp_possible_config(struct pnp_dev *dev, int type, resource_size_t start,
+			resource_size_t size)
+{
+	if (pnp_possible_option(dev->independent, type, start, size))
+		return 1;
+
+	if (pnp_possible_option(dev->dependent, type, start, size))
+		return 1;
+
+	return 0;
+}
+
 /* format is: pnp_reserve_irq=irq1[,irq2] .... */
 static int __init pnp_setup_reserve_irq(char *str)
 {
diff -puN drivers/serial/8250_pnp.c~pnp-add-pnp_possible_config-can-a-device-could-be-configured-this-way drivers/serial/8250_pnp.c
--- a/drivers/serial/8250_pnp.c~pnp-add-pnp_possible_config-can-a-device-could-be-configured-this-way
+++ a/drivers/serial/8250_pnp.c
@@ -383,21 +383,14 @@ static int __devinit check_name(char *na
 	return 0;
 }
 
-static int __devinit check_resources(struct pnp_option *option)
+static int __devinit check_resources(struct pnp_dev *dev)
 {
-	struct pnp_option *tmp;
-	if (!option)
-		return 0;
+	resource_size_t base[] = {0x2f8, 0x3f8, 0x2e8, 0x3e8};
+	int i;
 
-	for (tmp = option; tmp; tmp = tmp->next) {
-		struct pnp_port *port;
-		for (port = tmp->port; port; port = port->next)
-			if ((port->size == 8) &&
-			    ((port->min == 0x2f8) ||
-			     (port->min == 0x3f8) ||
-			     (port->min == 0x2e8) ||
-			     (port->min == 0x3e8)))
-				return 1;
+	for (i = 0; i < ARRAY_SIZE(base); i++) {
+		if (pnp_possible_config(dev, IORESOURCE_IO, base[i], 8))
+			return 1;
 	}
 
 	return 0;
@@ -420,10 +413,7 @@ static int __devinit serial_pnp_guess_bo
 		(dev->card && check_name(dev->card->name))))
 			return -ENODEV;
 
-	if (check_resources(dev->independent))
-		return 0;
-
-	if (check_resources(dev->dependent))
+	if (check_resources(dev))
 		return 0;
 
 	return -ENODEV;
diff -puN include/linux/pnp.h~pnp-add-pnp_possible_config-can-a-device-could-be-configured-this-way include/linux/pnp.h
--- a/include/linux/pnp.h~pnp-add-pnp_possible_config-can-a-device-could-be-configured-this-way
+++ a/include/linux/pnp.h
@@ -472,6 +472,8 @@ void pnp_unregister_card_driver(struct p
 extern struct list_head pnp_cards;
 
 /* resource management */
+int pnp_possible_config(struct pnp_dev *dev, int type, resource_size_t base,
+			resource_size_t size);
 int pnp_auto_config_dev(struct pnp_dev *dev);
 int pnp_start_dev(struct pnp_dev *dev);
 int pnp_stop_dev(struct pnp_dev *dev);
@@ -499,6 +501,7 @@ static inline int pnp_register_card_driv
 static inline void pnp_unregister_card_driver(struct pnp_card_driver *drv) { }
 
 /* resource management */
+static inline int pnp_possible_config(struct pnp_dev *dev, int type, resource_size_t base, resource_size_t size) { return 0; }
 static inline int pnp_auto_config_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_start_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_stop_dev(struct pnp_dev *dev) { return -ENODEV; }
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
make-pnp_add_card_id-static.patch

