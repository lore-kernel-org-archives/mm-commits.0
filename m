From: akpm@linux-foundation.org
Subject: + i2c-timberdale-i2c-ocores-can-add-i2c-devices-to-the-bus.patch added to -mm tree
Date: Tue, 09 Jun 2009 16:10:04 -0700
Message-ID: <200906092310.n59NA70p001353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754400AbZFIXMx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 19:12:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard.rojfors.ext@mocean-labs.com, jacmet@sunsite.dk, khali@linux-fr.org


The patch titled
     i2c: timberdale: i2c-ocores: can add I2C devices to the bus
has been added to the -mm tree.  Its filename is
     i2c-timberdale-i2c-ocores-can-add-i2c-devices-to-the-bus.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: i2c: timberdale: i2c-ocores: can add I2C devices to the bus
=46rom: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>

There is sometimes a need for the ocores driver to add devices to the b=
us
when installed.

i2c_register_board_info can not always be used, because the I2C devices
 are not known at an early state, they could for instance be connected
 on a I2C bus on a PCI device which has the Open Cores IP.

i2c_new_device can not be used in all cases either since the resulting
bus nummer might be unknown.

The solution is the pass a list of I2C devices in the platform data to
the Open Cores driver. This is useful for MFD drivers.

Signed-off-by: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/i2c/busses/i2c-ocores |   17 +++++++++++++++++
 drivers/i2c/busses/i2c-ocores.c     |    5 +++++
 include/linux/i2c-ocores.h          |    2 ++
 3 files changed, 24 insertions(+)

diff -puN Documentation/i2c/busses/i2c-ocores~i2c-timberdale-i2c-ocores=
-can-add-i2c-devices-to-the-bus Documentation/i2c/busses/i2c-ocores
--- a/Documentation/i2c/busses/i2c-ocores~i2c-timberdale-i2c-ocores-can=
-add-i2c-devices-to-the-bus
+++ a/Documentation/i2c/busses/i2c-ocores
@@ -20,6 +20,8 @@ platform_device with the base address an
 dev.platform_data of the device should also point to a struct
 ocores_i2c_platform_data (see linux/i2c-ocores.h) describing the
 distance between registers and the input clock speed.
+There is also a possibility to attach a list of i2c_board_info which
+the i2c-ocores driver will add to the bus upon creation.
=20
 E.G. something like:
=20
@@ -36,9 +38,24 @@ static struct resource ocores_resources[
 	},
 };
=20
+/* optional board info */
+struct i2c_board_info ocores_i2c_board_info[] =3D {
+	{
+		I2C_BOARD_INFO("tsc2003", 0x48),
+		.platform_data =3D &tsc2003_platform_data,
+		.irq =3D TSC_IRQ
+	},
+	{
+		I2C_BOARD_INFO("adv7180", 0x42 >> 1),
+		.irq =3D ADV_IRQ
+	}
+};
+
 static struct ocores_i2c_platform_data myi2c_data =3D {
 	.regstep	=3D 2,		/* two bytes between registers */
 	.clock_khz	=3D 50000,	/* input clock of 50MHz */
+	.devices	=3D ocores_i2c_board_info, /* optional table of devices */
+	.num_devices	=3D ARRAY_SIZE(ocores_i2c_board_info), /* table size */
 };
=20
 static struct platform_device myi2c =3D {
diff -puN drivers/i2c/busses/i2c-ocores.c~i2c-timberdale-i2c-ocores-can=
-add-i2c-devices-to-the-bus drivers/i2c/busses/i2c-ocores.c
--- a/drivers/i2c/busses/i2c-ocores.c~i2c-timberdale-i2c-ocores-can-add=
-i2c-devices-to-the-bus
+++ a/drivers/i2c/busses/i2c-ocores.c
@@ -216,6 +216,7 @@ static int __devinit ocores_i2c_probe(st
 	struct ocores_i2c_platform_data *pdata;
 	struct resource *res, *res2;
 	int ret;
+	int i;
=20
 	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
@@ -271,6 +272,10 @@ static int __devinit ocores_i2c_probe(st
 		goto add_adapter_failed;
 	}
=20
+	/* add in known devices to the bus */
+	for (i =3D 0; i < pdata->num_devices; i++)
+		i2c_new_device(&i2c->adap, pdata->devices + i);
+
 	return 0;
=20
 add_adapter_failed:
diff -puN include/linux/i2c-ocores.h~i2c-timberdale-i2c-ocores-can-add-=
i2c-devices-to-the-bus include/linux/i2c-ocores.h
--- a/include/linux/i2c-ocores.h~i2c-timberdale-i2c-ocores-can-add-i2c-=
devices-to-the-bus
+++ a/include/linux/i2c-ocores.h
@@ -14,6 +14,8 @@
 struct ocores_i2c_platform_data {
 	u32 regstep;   /* distance between registers */
 	u32 clock_khz; /* input clock in kHz */
+	u8 num_devices; /* number of devices in the devices list */
+	struct i2c_board_info const *devices; /* devices connected to the bus=
 */
 };
=20
 #endif /* _LINUX_I2C_OCORES_H */
_

Patches currently in -mm which might be from richard.rojfors.ext@mocean=
-labs.com are

linux-next.patch
gpio-timberdale-add-mc33880-driver.patch
i2c-timberdale-i2c-ocores-can-add-i2c-devices-to-the-bus.patch
mfd-timberdale-add-timberdale-dma-driver.patch
v4l2-timberdale-add-timberdale-logiwin-driver.patch
v4l2-timberdale-add-timberdale-logiwin-driver-in-kconfig-and-makefile.p=
atch
mfd-timberdale-add-timberdale-driver.patch
serial-timberdale-add-timberdale-uart-driver.patch
gpio-timberdale-add-timbgpio.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
