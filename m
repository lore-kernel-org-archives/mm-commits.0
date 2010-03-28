From: akpm@linux-foundation.org
Subject: [to-be-updated] hpet-convert-from-acpi-to-pnp-driver.patch removed from -mm tree
Date: Sun, 28 Mar 2010 13:34:26 -0400
Message-ID: <201003282035.o2SKZUrC003484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754896Ab0C1Ufn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Mar 2010 16:35:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, clemens@ladisch.de, venki@google.com, mm-commits@vger.kernel.org


The patch titled
     hpet: convert from ACPI to PNP driver
has been removed from the -mm tree.  Its filename was
     hpet-convert-from-acpi-to-pnp-driver.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpet: convert from ACPI to PNP driver
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

PNPACPI already parses _CRS, and does a more complete job than we did here,
so let's just take advantage of that.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Venkatesh Pallipadi <venki@google.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c |  109 ++++++++++++------------------------------
 1 file changed, 33 insertions(+), 76 deletions(-)

diff -puN drivers/char/hpet.c~hpet-convert-from-acpi-to-pnp-driver drivers/char/hpet.c
--- a/drivers/char/hpet.c~hpet-convert-from-acpi-to-pnp-driver
+++ a/drivers/char/hpet.c
@@ -31,6 +31,7 @@
 #include <linux/seq_file.h>
 #include <linux/bitops.h>
 #include <linux/clocksource.h>
+#include <linux/pnp.h>
 
 #include <asm/current.h>
 #include <asm/uaccess.h>
@@ -40,7 +41,6 @@
 #include <asm/div64.h>
 
 #include <linux/acpi.h>
-#include <acpi/acpi_bus.h>
 #include <linux/hpet.h>
 
 /*
@@ -944,101 +944,56 @@ int hpet_alloc(struct hpet_data *hdp)
 	return 0;
 }
 
-static acpi_status hpet_resources(struct acpi_resource *res, void *data)
+#ifdef CONFIG_PNP
+static int hpet_pnp_add(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 {
-	struct hpet_data *hdp;
-	acpi_status status;
-	struct acpi_resource_address64 addr;
-
-	hdp = data;
-
-	status = acpi_resource_to_address64(res, &addr);
-
-	if (ACPI_SUCCESS(status)) {
-		hdp->hd_phys_address = addr.minimum;
-		hdp->hd_address = ioremap(addr.minimum, addr.address_length);
-
-		if (hpet_is_known(hdp)) {
-			iounmap(hdp->hd_address);
-			return AE_ALREADY_EXISTS;
-		}
-	} else if (res->type == ACPI_RESOURCE_TYPE_FIXED_MEMORY32) {
-		struct acpi_resource_fixed_memory32 *fixmem32;
-
-		fixmem32 = &res->data.fixed_memory32;
-		if (!fixmem32)
-			return AE_NO_MEMORY;
-
-		hdp->hd_phys_address = fixmem32->address;
-		hdp->hd_address = ioremap(fixmem32->address,
-						HPET_RANGE_SIZE);
-
-		if (hpet_is_known(hdp)) {
-			iounmap(hdp->hd_address);
-			return AE_ALREADY_EXISTS;
-		}
-	} else if (res->type == ACPI_RESOURCE_TYPE_EXTENDED_IRQ) {
-		struct acpi_resource_extended_irq *irqp;
-		int i, irq;
-
-		irqp = &res->data.extended_irq;
-
-		for (i = 0; i < irqp->interrupt_count; i++) {
-			irq = acpi_register_gsi(NULL, irqp->interrupts[i],
-				      irqp->triggering, irqp->polarity);
-			if (irq < 0)
-				return AE_ERROR;
-
-			hdp->hd_irq[hdp->hd_nirqs] = irq;
-			hdp->hd_nirqs++;
-		}
-	}
-
-	return AE_OK;
-}
-
-static int hpet_acpi_add(struct acpi_device *device)
-{
-	acpi_status result;
 	struct hpet_data data;
+	struct resource *mem, *irq;
+	int i;
 
 	memset(&data, 0, sizeof(data));
 
-	result =
-	    acpi_walk_resources(device->handle, METHOD_NAME__CRS,
-				hpet_resources, &data);
-
-	if (ACPI_FAILURE(result))
+	mem = pnp_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!mem)
 		return -ENODEV;
 
-	if (!data.hd_address || !data.hd_nirqs) {
-		printk("%s: no address or irqs in _CRS\n", __func__);
+	data.hd_phys_address = mem->start;
+
+	if (hpet_is_known(&data))
 		return -ENODEV;
+
+	i = 0;
+	while (data.hd_nirqs < ARRAY_SIZE(data.hd_irq)) {
+		irq = pnp_get_resource(dev, IORESOURCE_IRQ, i++);
+		if (pnp_resource_valid(irq) && pnp_resource_enabled(irq))
+			data.hd_irq[data.hd_nirqs++] = irq->start;
 	}
+	if (!data.hd_nirqs)
+		return -ENODEV;
+
+	data.hd_address = ioremap(mem->start, resource_size(mem));
 
 	return hpet_alloc(&data);
 }
 
-static int hpet_acpi_remove(struct acpi_device *device, int type)
+static void hpet_pnp_remove(struct pnp_dev *dev)
 {
 	/* XXX need to unregister clocksource, dealloc mem, etc */
-	return -EINVAL;
 }
 
-static const struct acpi_device_id hpet_device_ids[] = {
+static const struct pnp_device_id hpet_device_ids[] = {
 	{"PNP0103", 0},
 	{"", 0},
 };
 MODULE_DEVICE_TABLE(acpi, hpet_device_ids);
 
-static struct acpi_driver hpet_acpi_driver = {
+static struct pnp_driver hpet_pnp_driver = {
 	.name = "hpet",
-	.ids = hpet_device_ids,
-	.ops = {
-		.add = hpet_acpi_add,
-		.remove = hpet_acpi_remove,
-		},
+	.id_table = hpet_device_ids,
+	.probe = hpet_pnp_add,
+	.remove = hpet_pnp_remove,
 };
+#endif
 
 static struct miscdevice hpet_misc = { HPET_MINOR, "hpet", &hpet_fops };
 
@@ -1052,26 +1007,28 @@ static int __init hpet_init(void)
 
 	sysctl_header = register_sysctl_table(dev_root);
 
-	result = acpi_bus_register_driver(&hpet_acpi_driver);
+#ifdef CONFIG_PNP
+	result = pnp_register_driver(&hpet_pnp_driver);
 	if (result < 0) {
 		if (sysctl_header)
 			unregister_sysctl_table(sysctl_header);
 		misc_deregister(&hpet_misc);
 		return result;
 	}
+#endif
 
 	return 0;
 }
 
 static void __exit hpet_exit(void)
 {
-	acpi_bus_unregister_driver(&hpet_acpi_driver);
+#ifdef CONFIG_PNP
+	pnp_unregister_driver(&hpet_pnp_driver);
+#endif
 
 	if (sysctl_header)
 		unregister_sysctl_table(sysctl_header);
 	misc_deregister(&hpet_misc);
