From: akpm@linux-foundation.org
Subject: - do-not-truncate-irq-number-for-icom-adapter.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:39:01 -0700
Message-ID: <200704252039.l3PKd13J012270@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993122AbXDYUj0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:39:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf@aepfle.de, mm-commits@vger.kernel.org


The patch titled
     do not truncate irq number for icom adapter
has been removed from the -mm tree.  Its filename was
     do-not-truncate-irq-number-for-icom-adapter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: do not truncate irq number for icom adapter
From: Olaf Hering <olaf@aepfle.de>

irq values are u32, not u8. Large irq numbers will be truncated,
free_irq may free a different irq.

Remove incorrectly sized struct member and use the one from pci_dev.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/icom.c |    5 ++---
 drivers/serial/icom.h |    1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/serial/icom.c~do-not-truncate-irq-number-for-icom-adapter drivers/serial/icom.c
--- a/drivers/serial/icom.c~do-not-truncate-irq-number-for-icom-adapter
+++ a/drivers/serial/icom.c
@@ -1473,7 +1473,7 @@ static void icom_remove_adapter(struct i
 		}
 	}
 
-	free_irq(icom_adapter->irq_number, (void *) icom_adapter);
+	free_irq(icom_adapter->pci_dev->irq, (void *) icom_adapter);
 	iounmap(icom_adapter->base_addr);
 	icom_free_adapter(icom_adapter);
 	pci_release_regions(icom_adapter->pci_dev);
@@ -1539,7 +1539,6 @@ static int __devinit icom_probe(struct p
 	}
 
 	 icom_adapter->base_addr_pci = pci_resource_start(dev, 0);
-	 icom_adapter->irq_number = dev->irq;
 	 icom_adapter->pci_dev = dev;
 	 icom_adapter->version = ent->driver_data;
 	 icom_adapter->subsystem_id = ent->subdevice;
@@ -1570,7 +1569,7 @@ static int __devinit icom_probe(struct p
 		icom_port = &icom_adapter->port_info[index];
 
 		if (icom_port->status == ICOM_PORT_ACTIVE) {
-			icom_port->uart_port.irq = icom_port->adapter->irq_number;
+			icom_port->uart_port.irq = icom_port->adapter->pci_dev->irq;
 			icom_port->uart_port.type = PORT_ICOM;
 			icom_port->uart_port.iotype = UPIO_MEM;
 			icom_port->uart_port.membase =
diff -puN drivers/serial/icom.h~do-not-truncate-irq-number-for-icom-adapter drivers/serial/icom.h
--- a/drivers/serial/icom.h~do-not-truncate-irq-number-for-icom-adapter
+++ a/drivers/serial/icom.h
@@ -258,7 +258,6 @@ struct icom_port {
 struct icom_adapter {
 	void __iomem * base_addr;
 	unsigned long base_addr_pci;
-	unsigned char irq_number;
 	struct pci_dev *pci_dev;
 	struct icom_port port_info[4];
 	int index;
_

Patches currently in -mm which might be from olaf@aepfle.de are

origin.patch
git-powerpc.patch
git-kbuild.patch
cleanup-variable-usage-in-mesh-interrupt-handler.patch
keep-track-of-network-interface-renaming.patch
