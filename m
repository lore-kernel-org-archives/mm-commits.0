From: akpm@linux-foundation.org
Subject: - acpi-use-dev_printk-when-possible.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:46:47 -0700
Message-ID: <200807020746.m627klP5005593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751429AbYGBHrr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:47:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, andi@firstfloor.org, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     acpi: use dev_printk when possible
has been removed from the -mm tree.  Its filename was
     acpi-use-dev_printk-when-possible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: use dev_printk when possible
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Convert printks to use dev_printk().  The most obvious change will
be messages like this:

   -ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 31 (level, low) -> IRQ 31
   +cciss 0000:00:04.0: PCI INTA# -> GSI 31 (level, low) -> IRQ 31

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/pci_irq.c |   38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff -puN drivers/acpi/pci_irq.c~acpi-use-dev_printk-when-possible drivers/acpi/pci_irq.c
--- a/drivers/acpi/pci_irq.c~acpi-use-dev_printk-when-possible
+++ a/drivers/acpi/pci_irq.c
@@ -162,7 +162,7 @@ do_prt_fixups(struct acpi_prt_entry *ent
 		    !strcmp(prt->source, quirk->source) &&
 		    strlen(prt->source) >= strlen(quirk->actual_source)) {
 			printk(KERN_WARNING PREFIX "firmware reports "
-				"%04x:%02x:%02x[%c] connected to %s; "
+				"%04x:%02x:%02x PCI INT%c# connected to %s; "
 				"changing to %s\n",
 				entry->id.segment, entry->id.bus,
 				entry->id.device, 'A' + entry->pin,
@@ -429,7 +429,7 @@ acpi_pci_irq_derive(struct pci_dev *dev,
 {
 	struct pci_dev *bridge = dev;
 	int irq = -1;
-	u8 bridge_pin = 0;
+	u8 bridge_pin = 0, orig_pin = pin;
 
 
 	if (!dev)
@@ -463,8 +463,8 @@ acpi_pci_irq_derive(struct pci_dev *dev,
 	}
 
 	if (irq < 0) {
-		printk(KERN_WARNING PREFIX "Unable to derive IRQ for device %s\n",
-			      pci_name(dev));
+		dev_warn(&dev->dev, "can't derive routing for PCI INT%c#\n",
+			 'A' + orig_pin);
 		return -1;
 	}
 
@@ -487,6 +487,7 @@ int acpi_pci_irq_enable(struct pci_dev *
 	int triggering = ACPI_LEVEL_SENSITIVE;
 	int polarity = ACPI_ACTIVE_LOW;
 	char *link = NULL;
+	char link_desc[16];
 	int rc;
 
 
@@ -503,7 +504,7 @@ int acpi_pci_irq_enable(struct pci_dev *
 	pin--;
 
 	if (!dev->bus) {
-		printk(KERN_ERR PREFIX "Invalid (NULL) 'bus' field\n");
+		dev_err(&dev->dev, "invalid (NULL) 'bus' field\n");
 		return -ENODEV;
 	}
 
@@ -538,8 +539,7 @@ int acpi_pci_irq_enable(struct pci_dev *
 	 * driver reported one, then use it. Exit in any case.
 	 */
 	if (irq < 0) {
-		printk(KERN_WARNING PREFIX "PCI Interrupt %s[%c]: no GSI",
-		       pci_name(dev), ('A' + pin));
+		dev_warn(&dev->dev, "PCI INT%c#: no GSI", 'A' + pin);
 		/* Interrupt Line values above 0xF are forbidden */
 		if (dev->irq > 0 && (dev->irq <= 0xF)) {
 			printk(" - using IRQ %d\n", dev->irq);
@@ -554,21 +554,21 @@ int acpi_pci_irq_enable(struct pci_dev *
 
 	rc = acpi_register_gsi(irq, triggering, polarity);
 	if (rc < 0) {
-		printk(KERN_WARNING PREFIX "PCI Interrupt %s[%c]: failed "
-		       "to register GSI\n", pci_name(dev), ('A' + pin));
+		dev_warn(&dev->dev, "PCI INT%c#: failed to register GSI\n",
+			 'A' + pin);
 		return rc;
 	}
 	dev->irq = rc;
 
-	printk(KERN_INFO PREFIX "PCI Interrupt %s[%c] -> ",
-	       pci_name(dev), 'A' + pin);
-
 	if (link)
-		printk("Link [%s] -> ", link);
+		snprintf(link_desc, sizeof(link_desc), " -> Link[%s]", link);
+	else
+		link_desc[0] = '\0';
 
-	printk("GSI %u (%s, %s) -> IRQ %d\n", irq,
-	       (triggering == ACPI_LEVEL_SENSITIVE) ? "level" : "edge",
-	       (polarity == ACPI_ACTIVE_LOW) ? "low" : "high", dev->irq);
+	dev_info(&dev->dev, "PCI INT%c#%s -> GSI %u (%s, %s) -> IRQ %d\n",
+		 'A' + pin, link_desc, irq,
+		 (triggering == ACPI_LEVEL_SENSITIVE) ? "level" : "edge",
+		 (polarity == ACPI_ACTIVE_LOW) ? "low" : "high", dev->irq);
 
 #ifdef CONFIG_X86
 	mp_config_acpi_gsi(dev->bus->number, dev->devfn, dev->pin, irq,
@@ -621,10 +621,6 @@ void acpi_pci_irq_disable(struct pci_dev
 	 * (e.g. PCI_UNDEFINED_IRQ).
 	 */
 
-	printk(KERN_INFO PREFIX "PCI interrupt for device %s disabled\n",
-	       pci_name(dev));
-
+	dev_info(&dev->dev, "PCI INT%c# disabled\n", 'A' + pin);
 	acpi_unregister_gsi(gsi);
