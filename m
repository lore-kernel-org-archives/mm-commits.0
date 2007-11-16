From: akpm@linux-foundation.org
Subject: + pnp-increase-the-maximum-number-of-resources.patch added to -mm tree
Date: Fri, 16 Nov 2007 15:52:33 -0800
Message-ID: <200711162352.lAGNqXiT010068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45059 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761769AbXKPXwy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Nov 2007 18:52:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yakui.zhao@intel.com, bjorn.helgaas@hp.com, shaohua.li@intel.com, stable@kernel.org, trenn@suse.de


The patch titled
     PNP: increase the maximum number of resources
has been added to the -mm tree.  Its filename is
     pnp-increase-the-maximum-number-of-resources.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PNP: increase the maximum number of resources
From: Zhao Yakui <yakui.zhao@intel.com>

On some systems the number of resources(IO,MEM) returnedy by PNP device is
greater than the PNP constant, for example motherboard devices.  It brings
that some resources can't be reserved and resource confilicts.  This will
cause PCI resources are assigned wrongly in some systems, and cause hang. 
This is a regression since we deleted ACPI motherboard driver and use PNP
system driver.

Signed-off-by: Li Shaohua <shaohua.li@intel.com>
Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpacpi/rsparser.c |   18 ++++++++++++++++--
 include/linux/pnp.h            |    4 ++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff -puN drivers/pnp/pnpacpi/rsparser.c~pnp-increase-the-maximum-number-of-resources drivers/pnp/pnpacpi/rsparser.c
--- a/drivers/pnp/pnpacpi/rsparser.c~pnp-increase-the-maximum-number-of-resources
+++ a/drivers/pnp/pnpacpi/rsparser.c
@@ -82,9 +82,11 @@ static void pnpacpi_parse_allocated_irqr
 	while (!(res->irq_resource[i].flags & IORESOURCE_UNSET) &&
 	       i < PNP_MAX_IRQ)
 		i++;
-	if (i >= PNP_MAX_IRQ)
+	if (i >= PNP_MAX_IRQ) {
+		printk(KERN_ERR "Exceed the max number of IRQ resource: "
+				"%d \n",PNP_MAX_IRQ);
 		return;
-
+	}
 #ifdef CONFIG_X86
 	if (gsi < 16 && (triggering != ACPI_EDGE_SENSITIVE ||
 				polarity != ACPI_ACTIVE_HIGH)) {
@@ -173,6 +175,10 @@ static void pnpacpi_parse_allocated_dmar
 		}
 		res->dma_resource[i].start = dma;
 		res->dma_resource[i].end = dma;
+	} else {
+		printk(KERN_ERR "Exceed the max number of DMA resource: "
+				"%d \n",PNP_MAX_DMA);
+		return;
 	}
 }
 
@@ -194,6 +200,10 @@ static void pnpacpi_parse_allocated_iore
 		}
 		res->port_resource[i].start = io;
 		res->port_resource[i].end = io + len - 1;
+	} else {
+		printk(KERN_ERR "Exceed the max number of IO Resource: "
+				"%d \n",PNP_MAX_PORT);
+		return;
 	}
 }
 
@@ -217,6 +227,10 @@ static void pnpacpi_parse_allocated_memr
 
 		res->mem_resource[i].start = mem;
 		res->mem_resource[i].end = mem + len - 1;
+	} else {
+		printk(KERN_ERR "Exceed the max number of Mem Resource: "
+				"%d \n",PNP_MAX_MEM);
+		return;
 	}
 }
 
diff -puN include/linux/pnp.h~pnp-increase-the-maximum-number-of-resources include/linux/pnp.h
--- a/include/linux/pnp.h~pnp-increase-the-maximum-number-of-resources
+++ a/include/linux/pnp.h
@@ -13,8 +13,8 @@
 #include <linux/errno.h>
 #include <linux/mod_devicetable.h>
 
-#define PNP_MAX_PORT		8
-#define PNP_MAX_MEM		4
+#define PNP_MAX_PORT		24
+#define PNP_MAX_MEM		12
 #define PNP_MAX_IRQ		2
 #define PNP_MAX_DMA		2
 #define PNP_NAME_LEN		50
_

Patches currently in -mm which might be from yakui.zhao@intel.com are

pnp-increase-the-maximum-number-of-resources.patch
pnp-increase-the-maximum-number-of-resources-fix.patch
pci-add-pci-quirk-function-for-some-chipsets.patch
