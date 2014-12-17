From: akpm@linux-foundation.org
Subject: +
 rtc-rtc-isl12057-add-isilirq2-can-wakeup-machine-property-for-in-tree-users.patch added to -mm tree
Date: Wed, 17 Dec 2014 14:13:33 -0800
Message-ID: <5492000d.gpMKAqKalVk5l27v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaLQWNf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Dec 2014 17:13:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arno@natisbad.org, a.zummo@towertech.it, arnd@arndb.de, broonie@kernel.org, darshanapadmadas@gmail.com, galak@codeaurora.org, grant.likely@linaro.org, ijc+devicetree@hellion.org.uk, jason@lakedaemon.net, jgunthorpe@obsidianresearch.com, linus.walleij@linaro.org, linux@roeck-us.net, mark.rutland@arm.com, pawel.moll@arm.com, peter.huewe@infineon.com, rob.herring@calxeda.com, rob@landley.net, swarren@wwwdotorg.org, treding@nvidia.com, uwe@kleine-koenig.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-isl12057: add isil,irq2-can-wakeup-machine prope=
rty for in-tree users
has been added to the -mm tree.  Its filename is
     rtc-rtc-isl12057-add-isilirq2-can-wakeup-machine-property-for-in-t=
ree-users.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-isl12057-add-isili=
rq2-can-wakeup-machine-property-for-in-tree-users.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-isl12057-add-isili=
rq2-can-wakeup-machine-property-for-in-tree-users.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Arnaud Ebalard <arno@natisbad.org>
Subject: rtc: rtc-isl12057: add isil,irq2-can-wakeup-machine property f=
or in-tree users

Current in-tree users of ISL12057 RTC chip (NETGEAR ReadyNAS 102, 104 a=
nd
2120) do not have the IRQ#2 pin of the chip (associated w/ the Alarm1
mechanism) connected to their SoC, but to a PMIC (TPS65251 FWIW).  This
specific hardware configuration allows the NAS to wake up when the alar=
ms
rings.

Recently introduced alarm support for ISL12057 relies on the provision =
of
an "interrupts" property in system .dts file, which previous three user=
s
will never get.  For that reason, alarm support on those devices is not
function.  To support this use case, this patch adds a new DT property =
for
ISL12057 (isil,irq2-can-wakeup-machine) to indicate that the chip is
capable of waking up the device using its IRQ#2 pin (even though it doe=
s
not have its IRQ#2 pin connected directly to the SoC).

This specific configuration was tested on a ReadyNAS 102 by setting an
alarm, powering off the device and see it reboot as expected when the
alarm rang w/:

  # echo `date '+%s' -d '+ 1 minutes'` > /sys/class/rtc/rtc0/wakealarm
  # shutdown -h now

As a side note, the ISL12057 remains in the list of trivial devices,
because the property is not per se required by the device to work but c=
an
help handle system w/ specific requirements.  In exchange, the new feat=
ure
is described in details in a specific documentation file.

Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Peter Huewe <peter.huewe@infineon.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Darshana Padmadas <darshanapadmadas@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Landley <rob@landley.net>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Kumar Gala <galak@codeaurora.org>>
Cc: Uwe Kleine-K=F6nig <uwe@kleine-koenig.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/isil,isl12057.txt |   78 +++++++=
+++
 drivers/rtc/rtc-isl12057.c                              |   45 +++++
 2 files changed, 117 insertions(+), 6 deletions(-)

diff -puN /dev/null Documentation/devicetree/bindings/rtc/isil,isl12057=
=2Etxt
--- /dev/null
+++ a/Documentation/devicetree/bindings/rtc/isil,isl12057.txt
@@ -0,0 +1,78 @@
+Intersil ISL12057 I2C RTC/Alarm chip
+
+ISL12057 is a trivial I2C device (it has simple device tree bindings,
+consisting of a compatible field, an address and possibly an interrupt
+line).
+
+Nonetheless, it also supports an option boolean property
+("isil,irq2-can-wakeup-machine") to handle the specific use-case found
+on at least three in-tree users of the chip (NETGEAR ReadyNAS 102, 104
+and 2120 ARM-based NAS); On those devices, the IRQ#2 pin of the chip
+(associated with the alarm supported by the driver) is not connected
+to the SoC but to a PMIC. It allows the device to be powered up when
+RTC alarm rings. In order to mark the device has a wakeup source and
+get access to the 'wakealarm' sysfs entry, this specific property can
+be set when the IRQ#2 pin of the chip is not connected to the SoC but
+can wake up the device.
+
+Required properties supported by the device:
+
+ - "compatible": must be "isil,isl12057"
+ - "reg": I2C bus address of the device
+
+Optional properties:
+
+ - "isil,irq2-can-wakeup-machine": mark the chip as a wakeup source,
+   independently of the availability of an IRQ line connected to the
+   SoC.
+
+ - "interrupt-parent", "interrupts": for passing the interrupt line
+   of the SoC connected to IRQ#2 of the RTC chip.
+
+
+Example isl12057 node without IRQ#2 pin connected (no alarm support):
+
+	isl12057: isl12057@68 {
+		compatible =3D "isil,isl12057";
+		reg =3D <0x68>;
+	};
+
+
+Example isl12057 node with IRQ#2 pin connected to main SoC via MPP6 (n=
ote
+that the pinctrl-related properties below are given for completeness a=
nd
+may not be required or may be different depending on your system or
+SoC, and the main function of the MPP used as IRQ line, i.e.
+"interrupt-parent" and "interrupts" are usually sufficient):
+
+		    pinctrl {
+				...
+
+				rtc_alarm_pin: rtc_alarm_pin {
+					marvell,pins =3D "mpp6";
+					marvell,function =3D "gpio";
+				};
+
+				...
+
+		    };
+
+	...
+
+	isl12057: isl12057@68 {
+		compatible =3D "isil,isl12057";
+		reg =3D <0x68>;
+		pinctrl-0 =3D <&rtc_alarm_pin>;
+		pinctrl-names =3D "default";
+		interrupt-parent =3D <&gpio0>;
+		interrupts =3D <6 IRQ_TYPE_EDGE_FALLING>;
+	};
+
+
+Example isl12057 node without IRQ#2 pin connected to the SoC but to a
+PMIC, allowing the device to be started based on configured alarm:
+
+	isl12057: isl12057@68 {
+		compatible =3D "isil,isl12057";
+		reg =3D <0x68>;
+		isil,irq2-can-wakeup-machine;
+	};
diff -puN drivers/rtc/rtc-isl12057.c~rtc-rtc-isl12057-add-isilirq2-can-=
wakeup-machine-property-for-in-tree-users drivers/rtc/rtc-isl12057.c
--- a/drivers/rtc/rtc-isl12057.c~rtc-rtc-isl12057-add-isilirq2-can-wake=
up-machine-property-for-in-tree-users
+++ a/drivers/rtc/rtc-isl12057.c
@@ -457,6 +457,40 @@ static int isl12057_check_rtc_status(str
 	return 0;
 }
=20
+#ifdef CONFIG_OF
+/*
+ * One would expect the device to be marked as a wakeup source only
+ * when an IRQ pin of the RTC is routed to an interrupt line of the
+ * CPU. In practice, such an IRQ pin can be connected to a PMIC and
+ * this allows the device to be powered up when RTC alarm rings. This
+ * is for instance the case on ReadyNAS 102, 104 and 2120. On those
+ * devices with no IRQ driectly connected to the SoC, the RTC chip
+ * can be forced as a wakeup source by stating that explicitly in
+ * the device's .dts file using the "isil,irq2-can-wakeup-machine"
+ * boolean property. This will guarantee 'wakealarm' sysfs entry is
+ * available on the device.
+ *
+ * The function below returns 1, i.e. the capability of the chip to
+ * wakeup the device, based on IRQ availability or if the boolean
+ * property has been set in the .dts file. Otherwise, it returns 0.
+ */
+
+static bool isl12057_can_wakeup_machine(struct device *dev)
+{
+	struct isl12057_rtc_data *data =3D dev_get_drvdata(dev);
+
+	return (data->irq || of_property_read_bool(dev->of_node,
+					      "isil,irq2-can-wakeup-machine"));
+}
+#else
+static bool isl12057_can_wakeup_machine(struct device *dev)
+{
+	struct isl12057_rtc_data *data =3D dev_get_drvdata(dev);
+
+	return !!data->irq;
+}
+#endif
+
 static int isl12057_rtc_alarm_irq_enable(struct device *dev,
 					 unsigned int enable)
 {
@@ -555,7 +589,8 @@ static int isl12057_probe(struct i2c_cli
 				client->irq, ret);
 	}
=20
-	device_init_wakeup(dev, !!data->irq);
+	if (isl12057_can_wakeup_machine(dev))
+		device_init_wakeup(dev, true);
=20
 	data->rtc =3D devm_rtc_device_register(dev, DRV_NAME, &rtc_ops,
 					     THIS_MODULE);
@@ -576,9 +611,7 @@ err:
=20
 static int isl12057_remove(struct i2c_client *client)
 {
-	struct isl12057_rtc_data *rtc_data =3D dev_get_drvdata(&client->dev);
-
-	if (rtc_data->irq)
+	if (isl12057_can_wakeup_machine(&client->dev))
 		device_init_wakeup(&client->dev, false);
=20
 	return 0;
@@ -589,7 +622,7 @@ static int isl12057_rtc_suspend(struct d
 {
 	struct isl12057_rtc_data *rtc_data =3D dev_get_drvdata(dev);
=20
-	if (device_may_wakeup(dev))
+	if (rtc_data->irq && device_may_wakeup(dev))
 		return enable_irq_wake(rtc_data->irq);
=20
 	return 0;
@@ -599,7 +632,7 @@ static int isl12057_rtc_resume(struct de
 {
 	struct isl12057_rtc_data *rtc_data =3D dev_get_drvdata(dev);
=20
-	if (device_may_wakeup(dev))
+	if (rtc_data->irq && device_may_wakeup(dev))
 		return disable_irq_wake(rtc_data->irq);
=20
 	return 0;
_

Patches currently in -mm which might be from arno@natisbad.org are

origin.patch
rtc-rtc-isl12057-add-alarm-support-to-intersil-isl12057-rtc-driver.patc=
h
rtc-rtc-isl12057-add-alarm-support-to-intersil-isl12057-rtc-driver-upda=
te.patch
rtc-rtc-isl12057-add-isilirq2-can-wakeup-machine-property-for-in-tree-u=
sers.patch
arm-mvebu-isl12057-rtc-chip-can-now-wake-up-rn102-rn102-and-rn2120.patc=
h

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
