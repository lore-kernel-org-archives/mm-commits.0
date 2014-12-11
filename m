From: akpm@linux-foundation.org
Subject: [merged] rtc-pcf8563-save-battery-power.patch removed from -mm
 tree
Date: Thu, 11 Dec 2014 11:07:17 -0800
Message-ID: <5489eb65.JWbn1LjrTXf9uCQn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbaLKTHS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:07:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kardell@telliq.com, a.zummo@towertech.it, dan.carpenter@oracle.com, grant.likely@linaro.org, robh+dt@kernel.org, vdonnefort@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: pcf8563: save battery power
has been removed from the -mm tree.  Its filename was
     rtc-pcf8563-save-battery-power.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kardell <jan.kardell@telliq.com>
Subject: rtc: pcf8563: save battery power

According to Haoyu hym8563 datasheet this saves som power.  Might be
importat to battery life.  And maybe it works for the NXP part as well.

Signed-off-by: Jan Kardell <jan.kardell@telliq.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Vincent Donnefort <vdonnefort@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-save-battery-power drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-save-battery-power
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -42,6 +42,13 @@
 
 #define PCF8563_REG_CLKO	0x0D /* clock out */
 #define PCF8563_REG_TMRC	0x0E /* timer control */
+#define PCF8563_TMRC_ENABLE	BIT(7)
+#define PCF8563_TMRC_4096	0
+#define PCF8563_TMRC_64		1
+#define PCF8563_TMRC_1		2
+#define PCF8563_TMRC_1_60	3
+#define PCF8563_TMRC_MASK	3
+
 #define PCF8563_REG_TMR		0x0F /* timer */
 
 #define PCF8563_SC_LV		0x80 /* low voltage */
@@ -406,6 +413,7 @@ static int pcf8563_probe(struct i2c_clie
 {
 	struct pcf8563 *pcf8563;
 	int err;
+	unsigned char buf;
 
 	dev_dbg(&client->dev, "%s\n", __func__);
 
@@ -423,6 +431,14 @@ static int pcf8563_probe(struct i2c_clie
 	pcf8563->client = client;
 	device_set_wakeup_capable(&client->dev, 1);
 
+	/* Set timer to lowest frequency to save power (ref Haoyu datasheet) */
+	buf = PCF8563_TMRC_1_60;
+	err = pcf8563_write_block_data(client, PCF8563_REG_TMRC, 1, &buf);
+	if (err < 0) {
+		dev_err(&client->dev, "%s: write error\n", __func__);
+		return err;
+	}
+
 	pcf8563->rtc = devm_rtc_device_register(&client->dev,
 				pcf8563_driver.driver.name,
 				&pcf8563_rtc_ops, THIS_MODULE);
_

Patches currently in -mm which might be from jan.kardell@telliq.com are

origin.patch

