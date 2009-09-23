From: akpm@linux-foundation.org
Subject: [merged] rtc-philips-pcf2123-rtc-spi-driver-updates.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:58:49 -0700
Message-ID: <200909231958.n8NJwnFD009690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753823AbZIWUAD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:00:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chrisv@cyberswitching.com, a.zummo@towertech.it, chripell@fsfe.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc-philips-pcf2123-rtc-spi-driver-updates
has been removed from the -mm tree.  Its filename was
     rtc-philips-pcf2123-rtc-spi-driver-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-philips-pcf2123-rtc-spi-driver-updates
From: "Chris Verges" <chrisv@cyberswitching.com>

Signed-off: Chris Verges <chrisv@cyberswitching.com>
Cc: Christian Pellegrin <chripell@fsfe.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf2123.c |   44 ++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-pcf2123.c~rtc-philips-pcf2123-rtc-spi-driver-updates drivers/rtc/rtc-pcf2123.c
--- a/drivers/rtc/rtc-pcf2123.c~rtc-philips-pcf2123-rtc-spi-driver-updates
+++ a/drivers/rtc/rtc-pcf2123.c
@@ -42,7 +42,7 @@
 #include <linux/rtc.h>
 #include <linux/spi/spi.h>
 
-#define DRV_VERSION "0.5"
+#define DRV_VERSION "0.6"
 
 #define PCF2123_REG_CTRL1	(0x00)	/* Control Register 1 */
 #define PCF2123_REG_CTRL2	(0x01)	/* Control Register 2 */
@@ -61,7 +61,7 @@
 static struct spi_driver pcf2123_driver;
 
 struct pcf2123_sysfs_reg {
-	struct device_attribute attr; /* must be first */
+	struct device_attribute attr;
 	char name[2];
 };
 
@@ -84,27 +84,42 @@ static ssize_t pcf2123_show(struct devic
 			    char *buffer)
 {
 	struct spi_device *spi = to_spi_device(dev);
-	struct pcf2123_sysfs_reg *r = (struct pcf2123_sysfs_reg *) attr;
+	struct pcf2123_sysfs_reg *r;
 	u8 txbuf[1], rxbuf[1];
+	unsigned long reg;
 	int ret;
 
-	txbuf[0] = PCF2123_READ | simple_strtoul(r->name, NULL, 16);
+	r = container_of(attr, struct pcf2123_sysfs_reg, attr);
+
+	if (strict_strtoul(r->name, 16, &reg))
+		return -EINVAL;
+
+	txbuf[0] = PCF2123_READ | reg;
 	ret = spi_write_then_read(spi, txbuf, 1, rxbuf, 1);
 	if (ret < 0)
-		return sprintf(buffer, "error: %d", ret);
+		return -EIO;
 	pcf2123_delay_trec();
-	return sprintf(buffer, "0x%x", rxbuf[0]);
+	return sprintf(buffer, "0x%x\n", rxbuf[0]);
 }
 
 static ssize_t pcf2123_store(struct device *dev, struct device_attribute *attr,
 			     const char *buffer, size_t count) {
 	struct spi_device *spi = to_spi_device(dev);
-	struct pcf2123_sysfs_reg *r = (struct pcf2123_sysfs_reg *) attr;
+	struct pcf2123_sysfs_reg *r;
 	u8 txbuf[2];
+	unsigned long reg;
+	unsigned long val;
+
 	int ret;
 
-	txbuf[0] = PCF2123_WRITE | simple_strtoul(r->name, NULL, 16);
-	txbuf[1] = simple_strtoul(buffer, NULL, 0);
+	r = container_of(attr, struct pcf2123_sysfs_reg, attr);
+
+	if (strict_strtoul(r->name, 16, &reg)
+		|| strict_strtoul(buffer, 10, &val))
+		return -EINVAL;
+
+	txbuf[0] = PCF2123_WRITE | reg;
+	txbuf[1] = val;
 	ret = spi_write(spi, txbuf, sizeof(txbuf));
 	if (ret < 0)
 		return -EIO;
@@ -220,7 +235,7 @@ static int __devinit pcf2123_probe(struc
 			txbuf[0], txbuf[1]);
 	ret = spi_write(spi, txbuf, 2 * sizeof(u8));
 	if (ret < 0)
-		return ret;
+		goto kfree_exit;
 	pcf2123_delay_trec();
 
 	/* Stop the counter */
@@ -230,7 +245,7 @@ static int __devinit pcf2123_probe(struc
 			txbuf[0], txbuf[1]);
 	ret = spi_write(spi, txbuf, 2 * sizeof(u8));
 	if (ret < 0)
-		return ret;
+		goto kfree_exit;
 	pcf2123_delay_trec();
 
 	/* See if the counter was actually stopped */
@@ -284,11 +299,16 @@ static int __devinit pcf2123_probe(struc
 		if (ret) {
 			dev_err(&spi->dev, "Unable to create sysfs %s\n",
 				pdata->regs[i].name);
-			pdata->regs[i].name[0] = '\0';
+			goto sysfs_exit;
 		}
 	}
 
 	return 0;
+
+sysfs_exit:
+	for (i--; i >= 0; i--)
+		device_remove_file(&spi->dev, &pdata->regs[i].attr);
+
 kfree_exit:
 	kfree(pdata);
 	spi->dev.platform_data = NULL;
_

Patches currently in -mm which might be from chrisv@cyberswitching.com are

origin.patch

