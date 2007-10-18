From: akpm@linux-foundation.org
Subject: - pnp-use-dev_info-dev_err-etc-in-core.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:03:54 -0700
Message-ID: <200710180703.l9I73sjn031479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56018 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760486AbXJRHgR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:36:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, ambx1@neo.rr.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     PNP: use dev_info(), dev_err(), etc in core
has been removed from the -mm tree.  Its filename was
     pnp-use-dev_info-dev_err-etc-in-core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PNP: use dev_info(), dev_err(), etc in core
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

If we have the struct pnp_dev available, we can use dev_info(), dev_err(),
etc., to give a little more information and consistency.

[akpm@linux-foundation.org: fix warning]
Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/Makefile    |    4 ++++
 drivers/pnp/card.c      |    3 +--
 drivers/pnp/driver.c    |    5 ++---
 drivers/pnp/interface.c |    3 +--
 drivers/pnp/manager.c   |   31 ++++++++++++-------------------
 drivers/pnp/quirks.c    |   12 ++++++++++--
 drivers/pnp/resource.c  |    2 +-
 7 files changed, 31 insertions(+), 29 deletions(-)

diff -puN drivers/pnp/Makefile~pnp-use-dev_info-dev_err-etc-in-core drivers/pnp/Makefile
--- a/drivers/pnp/Makefile~pnp-use-dev_info-dev_err-etc-in-core
+++ a/drivers/pnp/Makefile
@@ -7,3 +7,7 @@ obj-y		:= core.o card.o driver.o resourc
 obj-$(CONFIG_PNPACPI)		+= pnpacpi/
 obj-$(CONFIG_PNPBIOS)		+= pnpbios/
 obj-$(CONFIG_ISAPNP)		+= isapnp/
+
+ifeq ($(CONFIG_PNP_DEBUG),y)
+EXTRA_CFLAGS += -DDEBUG
+endif
diff -puN drivers/pnp/card.c~pnp-use-dev_info-dev_err-etc-in-core drivers/pnp/card.c
--- a/drivers/pnp/card.c~pnp-use-dev_info-dev_err-etc-in-core
+++ a/drivers/pnp/card.c
@@ -198,8 +198,7 @@ int pnp_add_card(struct pnp_card *card)
 	card->dev.release = &pnp_release_card;
 	error = device_register(&card->dev);
 	if (error) {
-		pnp_err("sysfs failure, card '%s' will be unavailable",
-			card->dev.bus_id);
+		dev_err(&card->dev, "could not register (err=%d)\n", error);
 		return error;
 	}
 
diff -puN drivers/pnp/driver.c~pnp-use-dev_info-dev_err-etc-in-core drivers/pnp/driver.c
--- a/drivers/pnp/driver.c~pnp-use-dev_info-dev_err-etc-in-core
+++ a/drivers/pnp/driver.c
@@ -86,9 +86,6 @@ static int pnp_device_probe(struct devic
 	pnp_dev = to_pnp_dev(dev);
 	pnp_drv = to_pnp_driver(dev->driver);
 
-	pnp_dbg("match found with the PnP device '%s' and the driver '%s'",
-		dev->bus_id, pnp_drv->name);
-
 	error = pnp_device_attach(pnp_dev);
 	if (error < 0)
 		return error;
@@ -116,6 +113,8 @@ static int pnp_device_probe(struct devic
 		error = 0;
 	} else
 		goto fail;
+
+	dev_dbg(dev, "driver attached\n");
 	return error;
 
 fail:
diff -puN drivers/pnp/interface.c~pnp-use-dev_info-dev_err-etc-in-core drivers/pnp/interface.c
--- a/drivers/pnp/interface.c~pnp-use-dev_info-dev_err-etc-in-core
+++ a/drivers/pnp/interface.c
@@ -327,8 +327,7 @@ pnp_set_current_resources(struct device 
 
 	if (dev->status & PNP_ATTACHED) {
 		retval = -EBUSY;
-		pnp_info("Device %s cannot be configured because it is in use.",
-			 dev->dev.bus_id);
+		dev_info(&dev->dev, "in use; can't configure\n");
 		goto done;
 	}
 
diff -puN drivers/pnp/manager.c~pnp-use-dev_info-dev_err-etc-in-core drivers/pnp/manager.c
--- a/drivers/pnp/manager.c~pnp-use-dev_info-dev_err-etc-in-core
+++ a/drivers/pnp/manager.c
@@ -22,8 +22,7 @@ static int pnp_assign_port(struct pnp_de
 	unsigned long *flags;
 
 	if (idx >= PNP_MAX_PORT) {
-		pnp_err
-		    ("More than 4 ports is incompatible with pnp specifications.");
+		dev_err(&dev->dev, "too many I/O port resources\n");
 		/* pretend we were successful so at least the manager won't try again */
 		return 1;
 	}
@@ -64,8 +63,7 @@ static int pnp_assign_mem(struct pnp_dev
 	unsigned long *flags;
 
 	if (idx >= PNP_MAX_MEM) {
-		pnp_err
-		    ("More than 8 mems is incompatible with pnp specifications.");
+		dev_err(&dev->dev, "too many memory resources\n");
 		/* pretend we were successful so at least the manager won't try again */
 		return 1;
 	}
@@ -122,8 +120,7 @@ static int pnp_assign_irq(struct pnp_dev
 	};
 
 	if (idx >= PNP_MAX_IRQ) {
-		pnp_err
-		    ("More than 2 irqs is incompatible with pnp specifications.");
+		dev_err(&dev->dev, "too many IRQ resources\n");
 		/* pretend we were successful so at least the manager won't try again */
 		return 1;
 	}
@@ -173,8 +170,7 @@ static void pnp_assign_dma(struct pnp_de
 	};
 
 	if (idx >= PNP_MAX_DMA) {
-		pnp_err("More than 2 dmas is incompatible with pnp "
-			"specifications.");
+		dev_err(&dev->dev, "too many DMA resources\n");
 		return;
 	}
 
@@ -442,8 +438,7 @@ int pnp_auto_config_dev(struct pnp_dev *
 	int i = 1;
 
 	if (!pnp_can_configure(dev)) {
-		pnp_dbg("Device %s does not support resource configuration.",
-			dev->dev.bus_id);
+		dev_dbg(&dev->dev, "configuration not supported\n");
 		return -ENODEV;
 	}
 
@@ -460,7 +455,7 @@ int pnp_auto_config_dev(struct pnp_dev *
 		} while (dep);
 	}
 
-	pnp_err("Unable to assign resources to device %s.", dev->dev.bus_id);
+	dev_err(&dev->dev, "unable to assign resources\n");
 	return -EBUSY;
 }
 
@@ -473,17 +468,16 @@ int pnp_auto_config_dev(struct pnp_dev *
 int pnp_start_dev(struct pnp_dev *dev)
 {
 	if (!pnp_can_write(dev)) {
-		pnp_dbg("Device %s does not support activation.",
-			dev->dev.bus_id);
+		dev_dbg(&dev->dev, "activation not supported\n");
 		return -EINVAL;
 	}
 
 	if (dev->protocol->set(dev, &dev->res) < 0) {
-		pnp_err("Failed to activate device %s.", dev->dev.bus_id);
+		dev_err(&dev->dev, "activation failed\n");
 		return -EIO;
 	}
 
-	pnp_info("Device %s activated.", dev->dev.bus_id);
+	dev_info(&dev->dev, "activated\n");
 	return 0;
 }
 
@@ -496,16 +490,15 @@ int pnp_start_dev(struct pnp_dev *dev)
 int pnp_stop_dev(struct pnp_dev *dev)
 {
 	if (!pnp_can_disable(dev)) {
-		pnp_dbg("Device %s does not support disabling.",
-			dev->dev.bus_id);
+		dev_dbg(&dev->dev, "disabling not supported\n");
 		return -EINVAL;
 	}
 	if (dev->protocol->disable(dev) < 0) {
-		pnp_err("Failed to disable device %s.", dev->dev.bus_id);
+		dev_err(&dev->dev, "disable failed\n");
 		return -EIO;
 	}
 
-	pnp_info("Device %s disabled.", dev->dev.bus_id);
+	dev_info(&dev->dev, "disabled\n");
 	return 0;
 }
 
diff -puN drivers/pnp/quirks.c~pnp-use-dev_info-dev_err-etc-in-core drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-use-dev_info-dev_err-etc-in-core
+++ a/drivers/pnp/quirks.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/pnp.h>
 #include <linux/io.h>
+#include <linux/kallsyms.h>
 #include "base.h"
 
 static void quirk_awe32_resources(struct pnp_dev *dev)
@@ -133,11 +134,18 @@ static struct pnp_fixup pnp_fixups[] = {
 void pnp_fixup_device(struct pnp_dev *dev)
 {
 	int i = 0;
+	void (*quirk)(struct pnp_dev *);
 
 	while (*pnp_fixups[i].id) {
 		if (compare_pnp_id(dev->id, pnp_fixups[i].id)) {
-			pnp_dbg("Calling quirk for %s", dev->dev.bus_id);
-			pnp_fixups[i].quirk_function(dev);
+			quirk = pnp_fixups[i].quirk_function;
+
+#ifdef DEBUG
+			dev_dbg(&dev->dev, "calling quirk 0x%p", quirk);
+			print_fn_descriptor_symbol(": %s()\n",
+				(unsigned long) *quirk);
+#endif
+			(*quirk)(dev);
 		}
 		i++;
 	}
diff -puN drivers/pnp/resource.c~pnp-use-dev_info-dev_err-etc-in-core drivers/pnp/resource.c
--- a/drivers/pnp/resource.c~pnp-use-dev_info-dev_err-etc-in-core
+++ a/drivers/pnp/resource.c
@@ -51,7 +51,7 @@ struct pnp_option *pnp_register_independ
 
 	/* this should never happen but if it does we'll try to continue */
 	if (dev->independent)
-		pnp_err("independent resource already registered");
+		dev_err(&dev->dev, "independent resource already registered\n");
 	dev->independent = option;
 	return option;
 }
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
serial-keep-the-dtr-setting-for-serial-console.patch
