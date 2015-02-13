From: akpm@linux-foundation.org
Subject: [folded-merged]
 rtc-rtc-isl12057-add-alarm-support-to-intersil-isl12057-rtc-driver-update.patch removed from -mm tree
Date: Fri, 13 Feb 2015 14:31:09 -0800
Message-ID: <54de7b2d.Dq8bQdZAWWwOJCHJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51329 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbbBMWbK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 17:31:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arno@natisbad.org, a.zummo@towertech.it, broonie@kernel.org, uwe@kleine-koenig.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-rtc-isl12057-add-alarm-support-to-intersil-isl12057-r=
tc-driver-update
has been removed from the -mm tree.  Its filename was
     rtc-rtc-isl12057-add-alarm-support-to-intersil-isl12057-rtc-driver=
-update.patch

This patch was dropped because it was folded into rtc-rtc-isl12057-add-=
alarm-support-to-intersil-isl12057-rtc-driver.patch

------------------------------------------------------
=46rom: Arnaud Ebalard <arno@natisbad.org>
Subject: rtc-rtc-isl12057-add-alarm-support-to-intersil-isl12057-rtc-dr=
iver-update

Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Uwe Kleine-K=F6nig <uwe@kleine-koenig.org>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/i2c/trivial-devices.txt |    2 -
 drivers/rtc/rtc-isl12057.c                                |   15 ++---=
-----
 2 files changed, 5 insertions(+), 12 deletions(-)

diff -puN Documentation/devicetree/bindings/i2c/trivial-devices.txt~rtc=
-rtc-isl12057-add-alarm-support-to-intersil-isl12057-rtc-driver-update =
Documentation/devicetree/bindings/i2c/trivial-devices.txt
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt~rtc-rtc=
-isl12057-add-alarm-support-to-intersil-isl12057-rtc-driver-update
+++ a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -59,7 +59,7 @@ fsl,sgtl5000		SGTL5000: Ultra Low-Power
 gmt,g751		G751: Digital Temperature Sensor and Thermal Watchdog with T=
wo-Wire Interface
 infineon,slb9635tt	Infineon SLB9635 (Soft-) I2C TPM (old protocol, max=
 100khz)
 infineon,slb9645tt	Infineon SLB9645 I2C TPM (new protocol, max 400khz)
-isl,isl12057		Intersil ISL12057 I2C RTC/Alarm Chip
+isl,isl12057		Intersil ISL12057 I2C RTC Chip
 isil,isl29028           (deprecated, use isl)
 isl,isl29028            Intersil ISL29028 Ambient Light and Proximity =
Sensor
 maxim,ds1050		5 Bit Programmable, Pulse-Width Modulator
diff -puN drivers/rtc/rtc-isl12057.c~rtc-rtc-isl12057-add-alarm-support=
-to-intersil-isl12057-rtc-driver-update drivers/rtc/rtc-isl12057.c
--- a/drivers/rtc/rtc-isl12057.c~rtc-rtc-isl12057-add-alarm-support-to-=
intersil-isl12057-rtc-driver-update
+++ a/drivers/rtc/rtc-isl12057.c
@@ -1,5 +1,5 @@
 /*
- * rtc-isl12057 - Driver for Intersil ISL12057 I2C Real Time Clock / A=
larm
+ * rtc-isl12057 - Driver for Intersil ISL12057 I2C Real Time Clock
  *
  * Copyright (C) 2013, Arnaud EBALARD <arno@natisbad.org>
  *
@@ -555,14 +555,7 @@ static int isl12057_probe(struct i2c_cli
 				client->irq, ret);
 	}
=20
-	/*
-	 * This is needed to have 'wakealarm' sysfs entry available. One
-	 * would expect the device to be marked as a wakeup source only
-	 * when an IRQ pin of the RTC is routed to an interrupt line of the
-	 * CPU. In practice, such an IRQ pin can be connected to a PMIC and
-	 * this allows the device to be powered up when RTC alarm rings.
-	 */
-	device_init_wakeup(dev, true);
+	device_init_wakeup(dev, !!data->irq);
=20
 	data->rtc =3D devm_rtc_device_register(dev, DRV_NAME, &rtc_ops,
 					     THIS_MODULE);
@@ -585,7 +578,7 @@ static int isl12057_remove(struct i2c_cl
 {
 	struct isl12057_rtc_data *rtc_data =3D dev_get_drvdata(&client->dev);
=20
-	if (rtc_data->irq > 0)
+	if (rtc_data->irq)
 		device_init_wakeup(&client->dev, false);
=20
 	return 0;
@@ -643,5 +636,5 @@ static struct i2c_driver isl12057_driver
 module_i2c_driver(isl12057_driver);
=20
 MODULE_AUTHOR("Arnaud EBALARD <arno@natisbad.org>");
-MODULE_DESCRIPTION("Intersil ISL12057 RTC/Alarm driver");
+MODULE_DESCRIPTION("Intersil ISL12057 RTC driver");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from arno@natisbad.org are

origin.patch
rtc-rtc-isl12057-add-alarm-support-to-intersil-isl12057-rtc-driver.patc=
h
rtc-rtc-isl12057-add-isilirq2-can-wakeup-machine-property-for-in-tree-u=
sers.patch
arm-mvebu-isl12057-rtc-chip-can-now-wake-up-rn102-rn102-and-rn2120.patc=
h
of-add-vendor-prefix-for-abracon-corporation.patch
rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip.patc=
h
rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip-v2.p=
atch
rtc-rtc-ab-b5ze-s3-add-sub-minute-alarm-support.patch
rtc-armada38x-add-the-device-tree-binding-documentation.patch
drivers-rtc-rtc-armada38x-add-a-new-rtc-driver-for-recent-mvebu-socs.pa=
tch
maintainers-add-the-rtc-driver-for-the-armada38x.patch
arm-mvebu-add-device-tree-description-of-rtc-on-armada-38x.patch
arm-mvebu-enable-armada-38x-rtc-driver-in-mvebu_v7_defconfig.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
