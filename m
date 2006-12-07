From: akpm@osdl.org
Subject: - pnp-handle-sysfs-errors.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:01:22 -0800
Message-ID: <200612072301.kB7N1Mdd029755@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51535 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163756AbWLGXBf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:01:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, ambx1@neo.rr.com, bjorn.helgaas@hp.com, mm-commits@vger.kernel.org


The patch titled
     PNP: handle sysfs errors
has been removed from the -mm tree.  Its filename was
     pnp-handle-sysfs-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PNP: handle sysfs errors
From: Jeff Garzik <jeff@garzik.org>

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pnp/card.c      |   30 +++++++++++++++++++++---------
 drivers/pnp/interface.c |   17 ++++++++++++++---
 2 files changed, 35 insertions(+), 12 deletions(-)

diff -puN drivers/pnp/card.c~pnp-handle-sysfs-errors drivers/pnp/card.c
--- a/drivers/pnp/card.c~pnp-handle-sysfs-errors
+++ a/drivers/pnp/card.c
@@ -164,9 +164,17 @@ static DEVICE_ATTR(card_id,S_IRUGO,pnp_s
 
 static int pnp_interface_attach_card(struct pnp_card *card)
 {
-	device_create_file(&card->dev,&dev_attr_name);
-	device_create_file(&card->dev,&dev_attr_card_id);
+	int rc = device_create_file(&card->dev,&dev_attr_name);
+	if (rc) return rc;
+
+	rc = device_create_file(&card->dev,&dev_attr_card_id);
+	if (rc) goto err_name;
+
 	return 0;
+
+err_name:
+	device_remove_file(&card->dev,&dev_attr_name);
+	return rc;
 }
 
 /**
@@ -306,16 +314,20 @@ found:
 	down_write(&dev->dev.bus->subsys.rwsem);
 	dev->card_link = clink;
 	dev->dev.driver = &drv->link.driver;
-	if (pnp_bus_type.probe(&dev->dev)) {
-		dev->dev.driver = NULL;
-		dev->card_link = NULL;
-		up_write(&dev->dev.bus->subsys.rwsem);
-		return NULL;
-	}
-	device_bind_driver(&dev->dev);
+	if (pnp_bus_type.probe(&dev->dev))
+		goto err_out;
+	if (device_bind_driver(&dev->dev))
+		goto err_out;
+
 	up_write(&dev->dev.bus->subsys.rwsem);
 
 	return dev;
+
+err_out:
+	dev->dev.driver = NULL;
+	dev->card_link = NULL;
+	up_write(&dev->dev.bus->subsys.rwsem);
+	return NULL;
 }
 
 /**
diff -puN drivers/pnp/interface.c~pnp-handle-sysfs-errors drivers/pnp/interface.c
--- a/drivers/pnp/interface.c~pnp-handle-sysfs-errors
+++ a/drivers/pnp/interface.c
@@ -461,8 +461,19 @@ static DEVICE_ATTR(id,S_IRUGO,pnp_show_c
 
 int pnp_interface_attach_device(struct pnp_dev *dev)
 {
-	device_create_file(&dev->dev,&dev_attr_options);
-	device_create_file(&dev->dev,&dev_attr_resources);
-	device_create_file(&dev->dev,&dev_attr_id);
+	int rc = device_create_file(&dev->dev,&dev_attr_options);
+	if (rc) goto err;
+	rc = device_create_file(&dev->dev,&dev_attr_resources);
+	if (rc) goto err_opt;
+	rc = device_create_file(&dev->dev,&dev_attr_id);
+	if (rc) goto err_res;
+
 	return 0;
+
+err_res:
+	device_remove_file(&dev->dev,&dev_attr_resources);
+err_opt:
+	device_remove_file(&dev->dev,&dev_attr_options);
+err:
+	return rc;
 }
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-acpi.patch
git-cpufreq.patch
drm-handle-pci_enable_device-failure.patch
git-input.patch
git-libata-all.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
initializer-entry-defined-twice-in-pata_rz1000.patch
ata_piix-ide-mode-sata-patch-for-intel-ich9.patch
pata_it8213-add-new-driver-for-the-it8213-card.patch
git-mtd.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
8139too-force-media-setting-fix.patch
tulip-fix-shutdown-dma-irq-race.patch
git-ioat.patch
via-sb600-sata-quirk.patch
git-pciseg.patch
pci-device-ensure-sysdata-initialised-v2.patch
mpt-fusion-handle-pci-layer-error-on-resume.patch
usb-fix-ohcih-over-use-warnings.patch
isdn-fix-warnings.patch
atyfb-rivafb-minor-fixes.patch
md-conditionalize-some-code.patch
user-of-the-jiffies-rounding-patch-ata-subsystem.patch
e1000-printk-warning-fixes.patch
git-gccbug.patch

