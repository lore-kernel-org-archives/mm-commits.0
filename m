From: akpm@osdl.org
Subject: - rtc-handle-sysfs-errors.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:01:25 -0800
Message-ID: <200612072301.kB7N1PmQ029760@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51538 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163753AbWLGXBh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:01:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     RTC: handle sysfs errors
has been removed from the -mm tree.  Its filename was
     rtc-handle-sysfs-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: RTC: handle sysfs errors
From: Jeff Garzik <jeff@garzik.org>

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/rtc/rtc-ds1672.c  |    9 +++++++--
 drivers/rtc/rtc-rs5c372.c |   12 ++++++++++--
 drivers/rtc/rtc-test.c    |    9 ++++++++-
 drivers/rtc/rtc-x1205.c   |   12 ++++++++++--
 4 files changed, 35 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-ds1672.c~rtc-handle-sysfs-errors drivers/rtc/rtc-ds1672.c
--- a/drivers/rtc/rtc-ds1672.c~rtc-handle-sysfs-errors
+++ a/drivers/rtc/rtc-ds1672.c
@@ -237,17 +237,22 @@ static int ds1672_probe(struct i2c_adapt
 	/* read control register */
 	err = ds1672_get_control(client, &control);
 	if (err)
-		goto exit_detach;
+		goto exit_devreg;
 
 	if (control & DS1672_REG_CONTROL_EOSC)
 		dev_warn(&client->dev, "Oscillator not enabled. "
 					"Set time to enable.\n");
 
 	/* Register sysfs hooks */
-	device_create_file(&client->dev, &dev_attr_control);
+	err = device_create_file(&client->dev, &dev_attr_control);
+	if (err)
+		goto exit_devreg;
 
 	return 0;
 
+exit_devreg:
+	rtc_device_unregister(rtc);
+
 exit_detach:
 	i2c_detach_client(client);
 
diff -puN drivers/rtc/rtc-rs5c372.c~rtc-handle-sysfs-errors drivers/rtc/rtc-rs5c372.c
--- a/drivers/rtc/rtc-rs5c372.c~rtc-handle-sysfs-errors
+++ a/drivers/rtc/rtc-rs5c372.c
@@ -238,11 +238,19 @@ static int rs5c372_probe(struct i2c_adap
 
 	i2c_set_clientdata(client, rtc);
 
-	device_create_file(&client->dev, &dev_attr_trim);
-	device_create_file(&client->dev, &dev_attr_osc);
+	err = device_create_file(&client->dev, &dev_attr_trim);
+	if (err) goto exit_devreg;
+	err = device_create_file(&client->dev, &dev_attr_osc);
+	if (err) goto exit_trim;
 
 	return 0;
 
+exit_trim:
+	device_remove_file(&client->dev, &dev_attr_trim);
+
+exit_devreg:
+	rtc_device_unregister(rtc);
+
 exit_detach:
 	i2c_detach_client(client);
 
diff -puN drivers/rtc/rtc-test.c~rtc-handle-sysfs-errors drivers/rtc/rtc-test.c
--- a/drivers/rtc/rtc-test.c~rtc-handle-sysfs-errors
+++ a/drivers/rtc/rtc-test.c
@@ -123,11 +123,18 @@ static int test_probe(struct platform_de
 		err = PTR_ERR(rtc);
 		return err;
 	}
-	device_create_file(&plat_dev->dev, &dev_attr_irq);
+
+	err = device_create_file(&plat_dev->dev, &dev_attr_irq);
+	if (err)
+		goto err;
 
 	platform_set_drvdata(plat_dev, rtc);
 
 	return 0;
+
+err:
+	rtc_device_unregister(rtc);
+	return err;
 }
 
 static int __devexit test_remove(struct platform_device *plat_dev)
diff -puN drivers/rtc/rtc-x1205.c~rtc-handle-sysfs-errors drivers/rtc/rtc-x1205.c
--- a/drivers/rtc/rtc-x1205.c~rtc-handle-sysfs-errors
+++ a/drivers/rtc/rtc-x1205.c
@@ -562,11 +562,19 @@ static int x1205_probe(struct i2c_adapte
 	else
 		dev_err(&client->dev, "couldn't read status\n");
 
-	device_create_file(&client->dev, &dev_attr_atrim);
-	device_create_file(&client->dev, &dev_attr_dtrim);
+	err = device_create_file(&client->dev, &dev_attr_atrim);
+	if (err) goto exit_devreg;
+	err = device_create_file(&client->dev, &dev_attr_dtrim);
+	if (err) goto exit_atrim;
 
 	return 0;
 
+exit_atrim:
+	device_remove_file(&client->dev, &dev_attr_atrim);
+
+exit_devreg:
+	rtc_device_unregister(rtc);
+
 exit_detach:
 	i2c_detach_client(client);
 
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

