From: akpm@linux-foundation.org
Subject: + rapidio-remove-mport-resource-reservation-from-common-rio-code.patch added to -mm tree
Date: Tue, 01 Mar 2011 16:24:09 -0800
Message-ID: <201103020024.p220OAE9008472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754185Ab1CBAZa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2011 19:25:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, benh@kernel.crashing.org, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: remove mport resource reservation from common RIO code
has been added to the -mm tree.  Its filename is
     rapidio-remove-mport-resource-reservation-from-common-rio-code.patch

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
Subject: rapidio: remove mport resource reservation from common RIO code
From: Alexandre Bounine <alexandre.bounine@idt.com>

Removes resource reservation from the common sybsystem initialization code
and make it part of mport driver initialization.  This resolves conflict
with resource reservation by device specific mport drivers.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |    9 +++++++++
 drivers/rapidio/rio.c         |   14 +-------------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-remove-mport-resource-reservation-from-common-rio-code arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-remove-mport-resource-reservation-from-common-rio-code
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -1432,6 +1432,14 @@ int fsl_rio_setup(struct platform_device
 	port->iores.flags = IORESOURCE_MEM;
 	port->iores.name = "rio_io_win";
 
+	if (request_resource(&iomem_resource, &port->iores) < 0) {
+		dev_err(&dev->dev, "RIO: Error requesting master port region"
+			" 0x%016llx-0x%016llx\n",
+			(u64)port->iores.start, (u64)port->iores.end);
+			rc = -ENOMEM;
+			goto err_res;
+	}
+
 	priv->pwirq   = irq_of_parse_and_map(dev->dev.of_node, 0);
 	priv->bellirq = irq_of_parse_and_map(dev->dev.of_node, 2);
 	priv->txirq = irq_of_parse_and_map(dev->dev.of_node, 3);
@@ -1536,6 +1544,7 @@ int fsl_rio_setup(struct platform_device
 	return 0;
 err:
 	iounmap(priv->regs_win);
+err_res:
 	kfree(priv);
 err_priv:
 	kfree(port);
diff -puN drivers/rapidio/rio.c~rapidio-remove-mport-resource-reservation-from-common-rio-code drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-remove-mport-resource-reservation-from-common-rio-code
+++ a/drivers/rapidio/rio.c
@@ -1137,20 +1137,9 @@ static int __devinit rio_init(void)
 
 int __devinit rio_init_mports(void)
 {
-	int rc = 0;
 	struct rio_mport *port;
 
 	list_for_each_entry(port, &rio_mports, node) {
-		if (!request_mem_region(port->iores.start,
-					resource_size(&port->iores),
-					port->name)) {
-			printk(KERN_ERR
-			       "RIO: Error requesting master port region 0x%016llx-0x%016llx\n",
-			       (u64)port->iores.start, (u64)port->iores.end);
-			rc = -ENOMEM;
-			goto out;
-		}
-
 		if (port->host_deviceid >= 0)
 			rio_enum_mport(port);
 		else
@@ -1159,8 +1148,7 @@ int __devinit rio_init_mports(void)
 
 	rio_init();
 
-      out:
-	return rc;
+	return 0;
 }
 
 device_initcall_sync(rio_init_mports);
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch
rapidio-add-new-sysfs-attributes.patch
rapidio-add-new-sysfs-attributes-v2.patch
rapidio-add-rapidio-documentation.patch
rapidio-add-rapidio-documentation-v2.patch
rapidio-add-architecture-specific-callbacks.patch
rapidio-modify-configuration-to-support-pci-srio-controller.patch
rapidio-modify-subsystem-and-driver-initialization-sequence.patch
rapidio-modify-mport-id-assignment.patch
rapidio-remove-mport-resource-reservation-from-common-rio-code.patch

