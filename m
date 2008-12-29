From: akpm@linux-foundation.org
Subject: + leds-add-a-dac124s085-spi-led-driver.patch added to -mm tree
Date: Mon, 29 Dec 2008 15:12:06 -0800
Message-ID: <200812292312.mBTNC6n0016392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753936AbYL2XMx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 18:12:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lg@denx.de, ben-linux@fluff.org, hmh@hmh.eng.br, rpurdie@rpsys.net


The patch titled
     leds: add a dac124s085 SPI LED driver
has been added to the -mm tree.  Its filename is
     leds-add-a-dac124s085-spi-led-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: add a dac124s085 SPI LED driver
From: Guennadi Liakhovetski <lg@denx.de>

A simple LED driver using the DAC124S085 DAC from NatSemi

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig           |    7 +
 drivers/leds/Makefile          |    3 
 drivers/leds/leds-dac124s085.c |  147 +++++++++++++++++++++++++++++++
 3 files changed, 157 insertions(+)

diff -puN drivers/leds/Kconfig~leds-add-a-dac124s085-spi-led-driver drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-add-a-dac124s085-spi-led-driver
+++ a/drivers/leds/Kconfig
@@ -178,6 +178,13 @@ config LEDS_DA903X
 	  This option enables support for on-chip LED drivers found
 	  on Dialog Semiconductor DA9030/DA9034 PMICs.
 
+config LEDS_DAC124S085
+	tristate "LED Support for DAC124S085 SPI DAC"
+	depends on LEDS_CLASS && SPI
+	help
+	  This option enables support for DAC124S085 SPI DAC from NatSemi,
+	  which can be used to control up to four LEDs.
+
 comment "LED Triggers"
 
 config LEDS_TRIGGERS
diff -puN drivers/leds/Makefile~leds-add-a-dac124s085-spi-led-driver drivers/leds/Makefile
--- a/drivers/leds/Makefile~leds-add-a-dac124s085-spi-led-driver
+++ a/drivers/leds/Makefile
@@ -26,6 +26,9 @@ obj-$(CONFIG_LEDS_DA903X)		+= leds-da903
 obj-$(CONFIG_LEDS_HP_DISK)		+= leds-hp-disk.o
 obj-$(CONFIG_LEDS_WM8350)		+= leds-wm8350.o
 
+# LED SPI Drivers
+obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
+
 # LED Triggers
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
 obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)	+= ledtrig-ide-disk.o
diff -puN /dev/null drivers/leds/leds-dac124s085.c
--- /dev/null
+++ a/drivers/leds/leds-dac124s085.c
@@ -0,0 +1,147 @@
+/*
+ * Copyright 2008
+ * Guennadi Liakhovetski, DENX Software Engineering, <lg@denx.de>
+ *
+ * This file is subject to the terms and conditions of version 2 of
+ * the GNU General Public License.  See the file COPYING in the main
+ * directory of this archive for more details.
+ *
+ * LED driver for the DAC124S085 SPI DAC
+ */
+
+#include <linux/leds.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+#include <linux/spi/spi.h>
+
+struct dac124s085_led {
+	struct led_classdev	ldev;
+	struct spi_device	*spi;
+	int			id;
+	int			brightness;
+	char			name[sizeof("dac124s085-3")];
+
+	struct mutex		mutex;
+	struct work_struct	work;
+	spinlock_t		lock;
+};
+
+struct dac124s085 {
+	struct dac124s085_led leds[4];
+};
+
+#define REG_WRITE		(0 << 12)
+#define REG_WRITE_UPDATE	(1 << 12)
+#define ALL_WRITE_UPDATE	(2 << 12)
+#define POWER_DOWN_OUTPUT	(3 << 12)
+
+static void dac124s085_led_work(struct work_struct *work)
+{
+	struct dac124s085_led *led = container_of(work, struct dac124s085_led,
+						  work);
+	u16 word;
+
+	mutex_lock(&led->mutex);
+	word = cpu_to_le16(((led->id) << 14) | REG_WRITE_UPDATE |
+			   (led->brightness & 0xfff));
+	spi_write(led->spi, (const u8 *)&word, sizeof(word));
+	mutex_unlock(&led->mutex);
+}
+
+static void dac124s085_set_brightness(struct led_classdev *ldev,
+				      enum led_brightness brightness)
+{
+	struct dac124s085_led *led = container_of(ldev, struct dac124s085_led,
+						  ldev);
+
+	spin_lock(&led->lock);
+	led->brightness = brightness;
+	schedule_work(&led->work);
+	spin_unlock(&led->lock);
+}
+
+static int dac124s085_probe(struct spi_device *spi)
+{
+	struct dac124s085	*dac;
+	struct dac124s085_led	*led;
+	int i, ret;
+
+	dac = kzalloc(sizeof(*dac), GFP_KERNEL);
+	if (!dac)
+		return -ENOMEM;
+
+	spi->bits_per_word = 16;
+
+	for (i = 0; i < ARRAY_SIZE(dac->leds); i++) {
+		led		= dac->leds + i;
+		led->id		= i;
+		led->brightness	= LED_OFF;
+		led->spi	= spi;
+		snprintf(led->name, sizeof(led->name), "dac124s085-%d", i);
+		spin_lock_init(&led->lock);
+		INIT_WORK(&led->work, dac124s085_led_work);
+		mutex_init(&led->mutex);
+		led->ldev.name = led->name;
+		led->ldev.brightness = LED_OFF;
+		led->ldev.max_brightness = 0xfff;
+		led->ldev.brightness_set = dac124s085_set_brightness;
+		ret = led_classdev_register(&spi->dev, &led->ldev);
+		if (ret < 0)
+			goto eledcr;
+	}
+
+	spi_set_drvdata(spi, dac);
+
+	return 0;
+
+eledcr:
+	while (i--)
+		led_classdev_unregister(&dac->leds[i].ldev);
+
+	spi_set_drvdata(spi, NULL);
+	kfree(dac);
+	return ret;
+}
+
+static int dac124s085_remove(struct spi_device *spi)
+{
+	struct dac124s085	*dac = spi_get_drvdata(spi);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dac->leds); i++) {
+		led_classdev_unregister(&dac->leds[i].ldev);
+		cancel_work_sync(&dac->leds[i].work);
+	}
+
+	spi_set_drvdata(spi, NULL);
+	kfree(dac);
+
+	return 0;
+}
+
+static struct spi_driver dac124s085_driver = {
+	.probe		= dac124s085_probe,
+	.remove		= dac124s085_remove,
+	.driver = {
+		.name	= "dac124s085",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init dac124s085_leds_init(void)
+{
+	return spi_register_driver(&dac124s085_driver);
+}
+
+static void __exit dac124s085_leds_exit(void)
+{
+	spi_unregister_driver(&dac124s085_driver);
+}
+
+module_init(dac124s085_leds_init);
+module_exit(dac124s085_leds_exit);
+
+MODULE_AUTHOR("Guennadi Liakhovetski <lg@denx.de>");
+MODULE_DESCRIPTION("DAC124S085 LED driver");
+MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from lg@denx.de are

linux-next.patch
leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values.patch
leds-add-a-dac124s085-spi-led-driver.patch
dma_alloc_coherent-clean-it-up.patch
dma-coherent-catch-oversized-requests-to-dma_alloc_from_coherent.patch

