From: akpm@linux-foundation.org
Subject: + rtc-pcf8563-save-battery-power.patch added to -mm tree
Date: Tue, 28 Oct 2014 14:26:13 -0700
Message-ID: <545009f5.qduvPWsgRzo17kH/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbaJ1V0N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Oct 2014 17:26:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kardell@telliq.com, a.zummo@towertech.it, dan.carpenter@oracle.com, grant.likely@linaro.org, robh+dt@kernel.org, vdonnefort@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: pcf8563: save battery power
has been added to the -mm tree.  Its filename is
     rtc-pcf8563-save-battery-power.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-pcf8563-save-battery-power.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-pcf8563-save-battery-power.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rtc-pcf8563-remove-leftover-code.patch
rtc-pcf8563-fix-write-of-invalid-bits-to-st2-reg.patch
rtc-pcf8563-fix-wrong-time-from-read_alarm.patch
rtc-pcf8563-handle-consequeces-of-lacking-second-alarm-reg.patch
rtc-pcf8563-save-battery-power.patch
rtc-pcf8563-clear-expired-alarm-at-boot-time.patch

