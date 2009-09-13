From: akpm@linux-foundation.org
Subject: [to-be-updated] rtc-philips-nxp-pcf2123-driver-v03-update-fix.patch removed from -mm tree
Date: Sun, 13 Sep 2009 15:56:50 -0700
Message-ID: <200909132256.n8DMuoVU030614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753305AbZIMW5v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Sep 2009 18:57:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chripell@gmail.com, a.zummo@towertech.it, chripell@fsfe.org, chrisv@cyberswitching.com, mm-commits@vger.kernel.org


The patch titled
     rtc-pcf2123 fixes
has been removed from the -mm tree.  Its filename was
     rtc-philips-nxp-pcf2123-driver-v03-update-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-pcf2123 fixes
From: christian pellegrin <chripell@gmail.com>

- Fix bug with write command bitfield

- Fix bug on crashing when module unloaded but no chip present

- Add access to registers via sysfs (needed for accessing calibration
  register which is needed for a good stability of the RTC)

Signed-off: Christian Pellegrin <chripell@fsfe.org>
Tested-by: Christian Pellegrin <chripell@fsfe.org>
Cc: Chris Verges <chrisv@cyberswitching.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf2123.c |   95 ++++++++++++++++++++++++++++++++----
 1 file changed, 86 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/rtc-pcf2123.c~rtc-philips-nxp-pcf2123-driver-v03-update-fix drivers/rtc/rtc-pcf2123.c
--- a/drivers/rtc/rtc-pcf2123.c~rtc-philips-nxp-pcf2123-driver-v03-update-fix
+++ a/drivers/rtc/rtc-pcf2123.c
@@ -10,6 +10,23 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
+ *
+ * Please note that the CS is active high, so platform data
+ * should look something like:
+
+ static struct spi_board_info ek_spi_devices[] = {
+ ...
+  {
+    .modalias	= "rtc-pcf2123",
+    .chip_select	= 1,
+    .controller_data = (void *) AT91_PIN_PA10,
+    .max_speed_hz	= 1000 * 1000,
+    .mode = SPI_CS_HIGH,
+    .bus_num	= 0,
+  },
+...
+};
+
  */
 
 #include <linux/bcd.h>
@@ -20,10 +37,9 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/rtc.h>
-#include <linux/workqueue.h>
 #include <linux/spi/spi.h>
 
-#define DRV_VERSION "0.3"
+#define DRV_VERSION "0.4"
 
 #define PCF2123_REG_CTRL1	0x00 /* Control Register 1 */
 #define PCF2123_REG_CTRL2	0x01 /* Control Register 2 */
@@ -36,13 +52,19 @@
 #define PCF2123_REG_MO		0x07
 #define PCF2123_REG_YR		0x08
 
-#define PCF2123_CMD_W(addr)	(((addr) & 0x0F) | 0x40)  /* single write */
+#define PCF2123_CMD_W(addr)	(((addr) & 0x0F) | 0x10)  /* single write */
 #define PCF2123_CMD_R(addr)	(((addr) & 0x0F) | 0x90)  /* single read */
 
 static struct spi_driver pcf2123_driver;
 
+struct pcf2123_sysfs_reg {
+	struct device_attribute attr; /* must be first */
+	char name[2];
+};
+
 struct pcf2123_plat_data {
 	struct rtc_device *rtc;
+	struct pcf2123_sysfs_reg regs[16];
 };
 
 /*
@@ -55,6 +77,39 @@ static inline void pcf2123_delay_trec(vo
 	ndelay(30);
 }
 
+static ssize_t pcf2123_show(struct device *dev, struct device_attribute *attr,
+			    char *buffer)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct pcf2123_sysfs_reg *r = (struct pcf2123_sysfs_reg *) attr;
+	u8 txbuf[1], rxbuf[1];
+	int ret;
+
+	txbuf[0] = PCF2123_CMD_R(simple_strtoul(r->name, NULL, 16));
+	ret = spi_write_then_read(spi, txbuf, 1, rxbuf, 1);
+	if (ret < 0)
+		return sprintf(buffer, "error: %d", ret);
+	pcf2123_delay_trec();
+	return sprintf(buffer, "0x%x", rxbuf[0]);
+}
+
+static ssize_t pcf2123_store(struct device *dev, struct device_attribute *attr,
+			     const char *buffer, size_t count)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct pcf2123_sysfs_reg *r = (struct pcf2123_sysfs_reg *) attr;
+	u8 txbuf[2];
+	int ret;
+
+	txbuf[0] = PCF2123_CMD_W(simple_strtoul(r->name, NULL, 16));
+	txbuf[1] = simple_strtoul(buffer, NULL, 0);
+	ret = spi_write(spi, txbuf, sizeof(txbuf));
+	if (ret < 0)
+		return -EIO;
+	pcf2123_delay_trec();
+	return count;
+}
+
 static int pcf2123_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct spi_device *spi = to_spi_device(dev);
@@ -149,7 +204,7 @@ static int __devinit pcf2123_probe(struc
 	struct rtc_device *rtc;
 	struct pcf2123_plat_data *pdata;
 	u8 txbuf[2], rxbuf[1];
-	int ret;
+	int ret, i;
 
 	pdata = kzalloc(sizeof(struct pcf2123_plat_data), GFP_KERNEL);
 	if (!pdata)
@@ -201,28 +256,50 @@ static int __devinit pcf2123_probe(struc
 			&pcf2123_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rtc)) {
+		dev_err(&spi->dev, "failed to register.\n");
 		ret = PTR_ERR(rtc);
 		goto kfree_exit;
 	}
 
 	pdata->rtc = rtc;
 
+	for (i = 0; i < 16; i++) {
+		sprintf(pdata->regs[i].name, "%1x", i);
+		pdata->regs[i].attr.attr.mode = S_IRUGO | S_IWUSR;
+		pdata->regs[i].attr.attr.name = pdata->regs[i].name;
+		pdata->regs[i].attr.show = pcf2123_show;
+		pdata->regs[i].attr.store = pcf2123_store;
+		ret = device_create_file(&spi->dev, &pdata->regs[i].attr);
+		if (ret) {
+			dev_err(&spi->dev, "Unable to create sysfs %s\n",
+				pdata->regs[i].name);
+			pdata->regs[i].name[0] = '\0';
+		}
+	}
+
 	return 0;
 kfree_exit:
 	kfree(pdata);
+	spi->dev.platform_data = NULL;
 	return ret;
 }
 
 static int pcf2123_remove(struct spi_device *spi)
 {
 	struct pcf2123_plat_data *pdata = spi->dev.platform_data;
-	struct rtc_device *rtc = pdata->rtc;
+	int i;
 
-	if (rtc)
-		rtc_device_unregister(rtc);
