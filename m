From: akpm@osdl.org
Subject: - drm-handle-pci_enable_device-failure.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:56:34 -0800
Message-ID: <200612130656.kBD6uYMq030737@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57973 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965052AbWLMG4m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:56:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     DRM: handle pci_enable_device failure
has been removed from the -mm tree.  Its filename was
     drm-handle-pci_enable_device-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: DRM: handle pci_enable_device failure
From: Jeff Garzik <jeff@garzik.org>

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/drm/drm_stub.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/char/drm/drm_stub.c~drm-handle-pci_enable_device-failure drivers/char/drm/drm_stub.c
--- a/drivers/char/drm/drm_stub.c~drm-handle-pci_enable_device-failure
+++ a/drivers/char/drm/drm_stub.c
@@ -211,14 +211,16 @@ int drm_get_dev(struct pci_dev *pdev, co
 	if (!dev)
 		return -ENOMEM;
 
-	pci_enable_device(pdev);
+	ret = pci_enable_device(pdev);
+	if (ret)
+		goto err_g1;
 
 	if ((ret = drm_fill_in_dev(dev, pdev, ent, driver))) {
 		printk(KERN_ERR "DRM: Fill_in_dev failed.\n");
-		goto err_g1;
+		goto err_g2;
 	}
 	if ((ret = drm_get_head(dev, &dev->primary)))
-		goto err_g1;
+		goto err_g2;
 	
 	DRM_INFO("Initialized %s %d.%d.%d %s on minor %d\n",
 		 driver->name, driver->major, driver->minor, driver->patchlevel,
@@ -226,7 +228,9 @@ int drm_get_dev(struct pci_dev *pdev, co
 
 	return 0;
 
-      err_g1:
+err_g2:
+	pci_disable_device(pdev);
+err_g1:
 	drm_free(dev, sizeof(*dev), DRM_MEM_STUB);
 	return ret;
 }
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-acpi.patch
git-drm.patch
git-libata-all.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
initializer-entry-defined-twice-in-pata_rz1000.patch
user-of-the-jiffies-rounding-patch-ata-subsystem.patch
libata-fix-oops-with-sparsemem.patch
git-mtd.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
8139too-force-media-setting-fix.patch
remove-the-broken-skmc-driver.patch
tulip-fix-shutdown-dma-irq-race.patch
git-ioat.patch
via-sb600-sata-quirk.patch
git-pciseg.patch
pci-device-ensure-sysdata-initialised-v2.patch
mpt-fusion-handle-pci-layer-error-on-resume.patch
fix-numerous-kcalloc-calls-convert-to-kzalloc.patch
getting-rid-of-all-casts-of-kalloc-calls.patch
e1000-printk-warning-fixes.patch
git-gccbug.patch

