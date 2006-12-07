From: akpm@osdl.org
Subject: - spi-improve-sysfs-compiler-complaint-handling.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:01:31 -0800
Message-ID: <200612072301.kB7N1VIW029766@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51548 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163759AbWLGXBl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:01:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     SPI: improve sysfs compiler complaint handling
has been removed from the -mm tree.  Its filename was
     spi-improve-sysfs-compiler-complaint-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SPI: improve sysfs compiler complaint handling
From: Jeff Garzik <jeff@garzik.org>

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/spi/spi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/spi/spi.c~spi-improve-sysfs-compiler-complaint-handling drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-improve-sysfs-compiler-complaint-handling
+++ a/drivers/spi/spi.c
@@ -447,7 +447,9 @@ static int __unregister(struct device *d
  */
 void spi_unregister_master(struct spi_master *master)
 {
-	(void) device_for_each_child(master->cdev.dev, NULL, __unregister);
+	int dummy;
+
+	dummy = device_for_each_child(master->cdev.dev, NULL, __unregister);
 	class_device_unregister(&master->cdev);
 }
 EXPORT_SYMBOL_GPL(spi_unregister_master);
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

