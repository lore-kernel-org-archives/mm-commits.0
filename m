From: akpm@linux-foundation.org
Subject: - pnp-increase-the-maximum-number-of-resources.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:20:59 -0800
Message-ID: <200712010020.lB10KxIE031728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42975 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757787AbXLAAVY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:21:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yakui.zhao@intel.com, bjorn.helgaas@hp.com, shaohua.li@intel.com, stable@kernel.org, trenn@suse.de, mm-commits@vger.kernel.org


The patch titled
     PNP: increase the maximum number of resources
has been removed from the -mm tree.  Its filename was
     pnp-increase-the-maximum-number-of-resources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PNP: increase the maximum number of resources
From: Zhao Yakui <yakui.zhao@intel.com>

On some systems the number of resources(IO,MEM) returnedy by PNP device is
greater than the PNP constant, for example motherboard devices.  It brings
that some resources can't be reserved and resource confilicts.  This will
cause PCI resources are assigned wrongly in some systems, and cause hang. 
This is a regression since we deleted ACPI motherboard driver and use PNP
system driver.

[akpm@linux-foundation.org: fix text and coding-style a bit]
Signed-off-by: Li Shaohua <shaohua.li@intel.com>
Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpacpi/rsparser.c |   15 +++++++++++++--
 include/linux/pnp.h            |    4 ++--
 2 files changed, 15 insertions(+), 4 deletions(-)

diff -puN drivers/pnp/pnpacpi/rsparser.c~pnp-increase-the-maximum-number-of-resources drivers/pnp/pnpacpi/rsparser.c
--- a/drivers/pnp/pnpacpi/rsparser.c~pnp-increase-the-maximum-number-of-resources
+++ a/drivers/pnp/pnpacpi/rsparser.c
@@ -83,9 +83,11 @@ static void pnpacpi_parse_allocated_irqr
 	while (!(res->irq_resource[i].flags & IORESOURCE_UNSET) &&
 	       i < PNP_MAX_IRQ)
 		i++;
-	if (i >= PNP_MAX_IRQ)
+	if (i >= PNP_MAX_IRQ) {
+		printk(KERN_ERR "pnpacpi: exceeded the max number of IRQ "
+				"resources: %d \n", PNP_MAX_IRQ);
 		return;
-
+	}
 	/*
 	 * in IO-APIC mode, use overrided attribute. Two reasons:
 	 * 1. BIOS bug in DSDT
@@ -181,6 +183,9 @@ static void pnpacpi_parse_allocated_dmar
 		}
 		res->dma_resource[i].start = dma;
 		res->dma_resource[i].end = dma;
+	} else {
+		printk(KERN_ERR "pnpacpi: exceeded the max number of DMA "
+				"resources: %d \n", PNP_MAX_DMA);
 	}
 }
 
@@ -202,6 +207,9 @@ static void pnpacpi_parse_allocated_iore
 		}
 		res->port_resource[i].start = io;
 		res->port_resource[i].end = io + len - 1;
+	} else {
+		printk(KERN_ERR "pnpacpi: exceeded the max number of IO "
+				"resources: %d \n", PNP_MAX_PORT);
 	}
 }
 
@@ -225,6 +233,9 @@ static void pnpacpi_parse_allocated_memr
 
 		res->mem_resource[i].start = mem;
 		res->mem_resource[i].end = mem + len - 1;
+	} else {
+		printk(KERN_ERR "pnpacpi: exceeded the max number of mem "
+				"resources: %d\n", PNP_MAX_MEM);
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

origin.patch
