From: akpm@linux-foundation.org
Subject: - pnp-use-dev_info-in-system-driver.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:03:56 -0700
Message-ID: <200710180703.l9I73u4F031482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58565 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755519AbXJRHbC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:31:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, ambx1@neo.rr.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     PNP: use dev_info() in system driver
has been removed from the -mm tree.  Its filename was
     pnp-use-dev_info-in-system-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PNP: use dev_info() in system driver
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Use dev_info() for a little consistency.  Changes this:

    pnp: 00:01: ioport range 0xf50-0xf58 has been reserved
    pnp: 00:01: ioport range 0x408-0x40f has been reserved
    pnp: 00:01: ioport range 0x900-0x903 has been reserved

to this:

    system 00:01: ioport range 0xf50-0xf58 has been reserved
    system 00:01: ioport range 0x408-0x40f has been reserved
    system 00:01: ioport range 0x900-0x903 has been reserved

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/system.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff -puN drivers/pnp/system.c~pnp-use-dev_info-in-system-driver drivers/pnp/system.c
--- a/drivers/pnp/system.c~pnp-use-dev_info-in-system-driver
+++ a/drivers/pnp/system.c
@@ -22,36 +22,39 @@ static const struct pnp_device_id pnp_de
 	{"", 0}
 };
 
-static void reserve_range(const char *pnpid, resource_size_t start,
+static void reserve_range(struct pnp_dev *dev, resource_size_t start,
 			  resource_size_t end, int port)
 {
-	struct resource *res;
 	char *regionid;
+	const char *pnpid = dev->dev.bus_id;
+	struct resource *res;
 
 	regionid = kmalloc(16, GFP_KERNEL);
-	if (regionid == NULL)
+	if (!regionid)
 		return;
+
 	snprintf(regionid, 16, "pnp %s", pnpid);
 	if (port)
 		res = request_region(start, end - start + 1, regionid);
 	else
 		res = request_mem_region(start, end - start + 1, regionid);
-	if (res == NULL)
-		kfree(regionid);
-	else
+	if (res)
 		res->flags &= ~IORESOURCE_BUSY;
+	else
+		kfree(regionid);
+
 	/*
 	 * Failures at this point are usually harmless. pci quirks for
 	 * example do reserve stuff they know about too, so we may well
 	 * have double reservations.
 	 */
-	printk(KERN_INFO "pnp: %s: %s range 0x%llx-0x%llx %s reserved\n",
-	       pnpid, port ? "ioport" : "iomem",
-	       (unsigned long long)start, (unsigned long long)end,
-	       NULL != res ? "has been" : "could not be");
+	dev_info(&dev->dev, "%s range 0x%llx-0x%llx %s reserved\n",
+		port ? "ioport" : "iomem",
+		(unsigned long long) start, (unsigned long long) end,
+		res ? "has been" : "could not be");
 }
 
-static void reserve_resources_of_dev(const struct pnp_dev *dev)
+static void reserve_resources_of_dev(struct pnp_dev *dev)
 {
 	int i;
 
@@ -73,7 +76,7 @@ static void reserve_resources_of_dev(con
 		if (pnp_port_end(dev, i) < pnp_port_start(dev, i))
 			continue;	/* invalid */
 
-		reserve_range(dev->dev.bus_id, pnp_port_start(dev, i),
+		reserve_range(dev, pnp_port_start(dev, i),
 			      pnp_port_end(dev, i), 1);
 	}
 
@@ -81,7 +84,7 @@ static void reserve_resources_of_dev(con
 		if (!pnp_mem_valid(dev, i))
 			continue;
 
-		reserve_range(dev->dev.bus_id, pnp_mem_start(dev, i),
+		reserve_range(dev, pnp_mem_start(dev, i),
 			      pnp_mem_end(dev, i), 0);
 	}
 }
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
serial-keep-the-dtr-setting-for-serial-console.patch
