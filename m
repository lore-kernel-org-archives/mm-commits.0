From: akpm@linux-foundation.org
Subject: + lis3-add-click-function.patch added to -mm tree
Date: Fri, 12 Jun 2009 08:46:58 -0700
Message-ID: <200906121546.n5CFkwoN026303@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757915AbZFLPrM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jun 2009 11:47:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel@caiaq.de, eric.piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3: add click function
has been added to the -mm tree.  Its filename is
     lis3-add-click-function.patch

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
Subject: lis3: add click function
=46rom: Daniel Mack <daniel@caiaq.de>

The LIS302DL accelerometer chip has a 'click' feature which can be used=
 to
detect sudden motion on any of the three axis.  Configuration data is
passed via spi platform_data and no action is taken if that's not
specified, so it won't harm any existing platform.

To make the configuration effective, the IRQ lines need to be set up
appropriately.  This patch also adds a way to do that from board suppor=
t
code.

The DD_* definitions were factored out to an own enum because they are
specific to LIS3LV02D devices.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.c     |   20 ++++++++++++++++
 drivers/hwmon/lis3lv02d.h     |   19 ++++++++++++++-
 drivers/hwmon/lis3lv02d_spi.c |    1=20
 include/linux/lis3lv02d.h     |   39 ++++++++++++++++++++++++++++++++
 4 files changed, 78 insertions(+), 1 deletion(-)

diff -puN drivers/hwmon/lis3lv02d.c~lis3-add-click-function drivers/hwm=
on/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3-add-click-function
+++ a/drivers/hwmon/lis3lv02d.c
@@ -438,6 +438,26 @@ int lis3lv02d_init_device(struct lis3lv0
 	if (lis3lv02d_joystick_enable())
 		printk(KERN_ERR DRIVER_NAME ": joystick initialization failed\n");
=20
+	/* passing in platform specific data is purely optional and only
+	 * used by the SPI transport layer at the moment */
+	if (dev->pdata) {
+		struct lis3lv02d_platform_data *p =3D dev->pdata;
+
+		if (p->click_flags && (dev->whoami =3D=3D LIS_SINGLE_ID)) {
+			dev->write(dev, CLICK_CFG, p->click_flags);
+			dev->write(dev, CLICK_TIMELIMIT, p->click_time_limit);
+			dev->write(dev, CLICK_LATENCY, p->click_latency);
+			dev->write(dev, CLICK_WINDOW, p->click_window);
+			dev->write(dev, CLICK_THSZ, p->click_thresh_z & 0xf);
+			dev->write(dev, CLICK_THSY_X,
+					(p->click_thresh_x & 0xf) |
+					(p->click_thresh_y << 4));
+		}
+
+		if (p->irq_cfg)
+			dev->write(dev, CTRL_REG3, p->irq_cfg);
+	}
+
 	/* bail if we did not get an IRQ from the bus layer */
 	if (!dev->irq) {
 		printk(KERN_ERR DRIVER_NAME
diff -puN drivers/hwmon/lis3lv02d.h~lis3-add-click-function drivers/hwm=
on/lis3lv02d.h
--- a/drivers/hwmon/lis3lv02d.h~lis3-add-click-function
+++ a/drivers/hwmon/lis3lv02d.h
@@ -29,12 +29,14 @@
  * They can also be connected via I=C2=B2C.
  */
=20
+#include <linux/lis3lv02d.h>
+
 /* 2-byte registers */
 #define LIS_DOUBLE_ID	0x3A /* LIS3LV02D[LQ] */
 /* 1-byte registers */
 #define LIS_SINGLE_ID	0x3B /* LIS[32]02DL and others */
=20
-enum lis3lv02d_reg {
+enum lis3_reg {
 	WHO_AM_I	=3D 0x0F,
 	OFFSET_X	=3D 0x16,
 	OFFSET_Y	=3D 0x17,
@@ -62,6 +64,19 @@ enum lis3lv02d_reg {
 	FF_WU_THS_L	=3D 0x34,
 	FF_WU_THS_H	=3D 0x35,
 	FF_WU_DURATION	=3D 0x36,
+};
+
+enum lis302d_reg {
+	CLICK_CFG	=3D 0x38,
+	CLICK_SRC	=3D 0x39,
+	CLICK_THSY_X	=3D 0x3B,
+	CLICK_THSZ	=3D 0x3C,
+	CLICK_TIMELIMIT	=3D 0x3D,
+	CLICK_LATENCY	=3D 0x3E,
+	CLICK_WINDOW	=3D 0x3F,
+};
+
+enum lis3lv02d_reg {
 	DD_CFG		=3D 0x38,
 	DD_SRC		=3D 0x39,
 	DD_ACK		=3D 0x3A,
@@ -183,6 +198,8 @@ struct lis3lv02d {
 	struct fasync_struct	*async_queue; /* queue for the misc device */
 	wait_queue_head_t	misc_wait; /* Wait queue for the misc device */
 	unsigned long		misc_opened; /* bit0: whether the device is open */
+
+	struct lis3lv02d_platform_data *pdata;	/* for passing board config */
 };
=20
 int lis3lv02d_init_device(struct lis3lv02d *lis3);
diff -puN drivers/hwmon/lis3lv02d_spi.c~lis3-add-click-function drivers=
/hwmon/lis3lv02d_spi.c
--- a/drivers/hwmon/lis3lv02d_spi.c~lis3-add-click-function
+++ a/drivers/hwmon/lis3lv02d_spi.c
@@ -72,6 +72,7 @@ static int __devinit lis302dl_spi_probe(
 	lis3_dev.write =3D lis3_spi_write;
 	lis3_dev.irq =3D spi->irq;
 	lis3_dev.ac =3D lis3lv02d_axis_normal;
+	lis3_dev.pdata =3D spi->dev.platform_data;
 	spi_set_drvdata(spi, &lis3_dev);
=20
 	ret =3D lis3lv02d_init_device(&lis3_dev);
diff -puN /dev/null include/linux/lis3lv02d.h
--- /dev/null
+++ a/include/linux/lis3lv02d.h
@@ -0,0 +1,39 @@
+#ifndef __LIS3LV02D_H_
+#define __LIS3LV02D_H_
+
+struct lis3lv02d_platform_data {
+	/* please note: the 'click' feature is only supported for
+	 * LIS[32]02DL variants of the chip and will be ignored for
+	 * others */
+#define LIS3_CLICK_SINGLE_X	(1 << 0)
+#define LIS3_CLICK_DOUBLE_X	(1 << 1)
+#define LIS3_CLICK_SINGLE_Y	(1 << 2)
+#define LIS3_CLICK_DOUBLE_Y	(1 << 3)
+#define LIS3_CLICK_SINGLE_Z	(1 << 4)
+#define LIS3_CLICK_DOUBLE_Z	(1 << 5)
+	unsigned char click_flags;
+	unsigned char click_thresh_x;
+	unsigned char click_thresh_y;
+	unsigned char click_thresh_z;
+	unsigned char click_time_limit;
+	unsigned char click_latency;
+	unsigned char click_window;
+
+#define LIS3_IRQ1_DISABLE	(0 << 0)
+#define LIS3_IRQ1_FF_WU_1	(1 << 0)
+#define LIS3_IRQ1_FF_WU_2	(2 << 0)
+#define LIS3_IRQ1_FF_WU_12	(3 << 0)
+#define LIS3_IRQ1_DATA_READY	(4 << 0)
+#define LIS3_IRQ1_CLICK		(7 << 0)
+#define LIS3_IRQ2_DISABLE	(0 << 3)
+#define LIS3_IRQ2_FF_WU_1	(1 << 3)
+#define LIS3_IRQ2_FF_WU_2	(2 << 3)
+#define LIS3_IRQ2_FF_WU_12	(3 << 3)
+#define LIS3_IRQ2_DATA_READY	(4 << 3)
+#define LIS3_IRQ2_CLICK		(7 << 3)
+#define LIS3_IRQ_OPEN_DRAIN	(1 << 6)
+#define LIS3_IRQ_ACTIVE_HIGH	(1 << 7)
+	unsigned char irq_cfg;
+};
+
+#endif /* __LIS3LV02D_H_ */
_

Patches currently in -mm which might be from daniel@caiaq.de are

linux-next.patch
console-make-blank-timeout-value-a-boot-option.patch
lis3-add-click-function.patch
w1-gpio-add-external-pull-up-enable-callback.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
