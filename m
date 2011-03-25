From: akpm@linux-foundation.org
Subject: [merged] rapidio-remove-mport-resource-reservation-from-common-rio-code.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:26:17 -0700
Message-ID: <201103250726.p2P7QBTg026117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754729Ab1CYH0l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:26:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, benh@kernel.crashing.org, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com, mm-commi


The patch titled
     rapidio: remove mport resource reservation from common RIO code
has been removed from the -mm tree.  Its filename was
     rapidio-remove-mport-resource-reservation-from-common-rio-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
