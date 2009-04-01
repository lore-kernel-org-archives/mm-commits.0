From: akpm@linux-foundation.org
Subject: [merged] rtc-v3020-coding-style-cleanup.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:14 -0700
Message-ID: <200904011842.n31IgEs4009633@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755756AbZDATdR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:33:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike@compulab.co.il, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc-v3020: coding style cleanup
has been removed from the -mm tree.  Its filename was
     rtc-v3020-coding-style-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-v3020: coding style cleanup
From: Mike Rapoport <mike@compulab.co.il>

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-v3020.c |   40 +++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff -puN drivers/rtc/rtc-v3020.c~rtc-v3020-coding-style-cleanup drivers/rtc/rtc-v3020.c
--- a/drivers/rtc/rtc-v3020.c~rtc-v3020-coding-style-cleanup
+++ a/drivers/rtc/rtc-v3020.c
@@ -28,7 +28,7 @@
 #include <linux/rtc-v3020.h>
 #include <linux/delay.h>
 
-#include <asm/io.h>
+#include <linux/io.h>
 
 #undef DEBUG
 
@@ -63,7 +63,7 @@ static void v3020_set_reg(struct v3020 *
 
 static unsigned char v3020_get_reg(struct v3020 *chip, unsigned char address)
 {
-	unsigned int data=0;
+	unsigned int data = 0;
 	int i;
 
 	for (i = 0; i < 4; i++) {
@@ -106,16 +106,14 @@ static int v3020_read_time(struct device
 	tmp = v3020_get_reg(chip, V3020_YEAR);
 	dt->tm_year = bcd2bin(tmp)+100;
 
-#ifdef DEBUG
-	printk("\n%s : Read RTC values\n",__func__);
-	printk("tm_hour: %i\n",dt->tm_hour);
-	printk("tm_min : %i\n",dt->tm_min);
-	printk("tm_sec : %i\n",dt->tm_sec);
-	printk("tm_year: %i\n",dt->tm_year);
-	printk("tm_mon : %i\n",dt->tm_mon);
-	printk("tm_mday: %i\n",dt->tm_mday);
-	printk("tm_wday: %i\n",dt->tm_wday);
-#endif
+	dev_dbg(dev, "\n%s : Read RTC values\n", __func__);
+	dev_dbg(dev, "tm_hour: %i\n", dt->tm_hour);
+	dev_dbg(dev, "tm_min : %i\n", dt->tm_min);
+	dev_dbg(dev, "tm_sec : %i\n", dt->tm_sec);
+	dev_dbg(dev, "tm_year: %i\n", dt->tm_year);
+	dev_dbg(dev, "tm_mon : %i\n", dt->tm_mon);
+	dev_dbg(dev, "tm_mday: %i\n", dt->tm_mday);
+	dev_dbg(dev, "tm_wday: %i\n", dt->tm_wday);
 
 	return 0;
 }
@@ -125,15 +123,13 @@ static int v3020_set_time(struct device 
 {
 	struct v3020 *chip = dev_get_drvdata(dev);
 
-#ifdef DEBUG
-	printk("\n%s : Setting RTC values\n",__func__);
-	printk("tm_sec : %i\n",dt->tm_sec);
-	printk("tm_min : %i\n",dt->tm_min);
-	printk("tm_hour: %i\n",dt->tm_hour);
-	printk("tm_mday: %i\n",dt->tm_mday);
-	printk("tm_wday: %i\n",dt->tm_wday);
-	printk("tm_year: %i\n",dt->tm_year);
-#endif
+	dev_dbg(dev, "\n%s : Setting RTC values\n", __func__);
+	dev_dbg(dev, "tm_sec : %i\n", dt->tm_sec);
+	dev_dbg(dev, "tm_min : %i\n", dt->tm_min);
+	dev_dbg(dev, "tm_hour: %i\n", dt->tm_hour);
+	dev_dbg(dev, "tm_mday: %i\n", dt->tm_mday);
+	dev_dbg(dev, "tm_wday: %i\n", dt->tm_wday);
+	dev_dbg(dev, "tm_year: %i\n", dt->tm_year);
 
 	/* Write all the values to ram... */
 	v3020_set_reg(chip, V3020_SECONDS, 	bin2bcd(dt->tm_sec));
@@ -191,7 +187,7 @@ static int rtc_probe(struct platform_dev
 	/* Test chip by doing a write/read sequence
 	 * to the chip ram */
 	v3020_set_reg(chip, V3020_SECONDS, 0x33);
-	if(v3020_get_reg(chip, V3020_SECONDS) != 0x33) {
+	if (v3020_get_reg(chip, V3020_SECONDS) != 0x33) {
 		retval = -ENODEV;
 		goto err_io;
 	}
_

Patches currently in -mm which might be from mike@compulab.co.il are

origin.patch
linux-next.patch
spi_bfin5xx-remove-unused-is_dma_aligned-macro.patch
spi-add-dma_alignment-field-to-spi_master.patch
pxa2xx_spi-set-spi_masterdma_alignment-=-8.patch
spi_imx-set-spi_masterdma_alignment-=-4.patch
rtc-v3020-add-ability-to-access-v3020-chip-with-gpios.patch

