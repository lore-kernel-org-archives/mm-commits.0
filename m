From: akpm@linux-foundation.org
Subject: [merged] rtc-pcf8563-clear-expired-alarm-at-boot-time.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 11:07:20 -0800
Message-ID: <5489eb68.Q4XjHfX909AC+RdT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45942 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaLKTHV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:07:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kardell@telliq.com, a.zummo@towertech.it, dan.carpenter@oracle.com, grant.likely@linaro.org, robh+dt@kernel.org, vdonnefort@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: pcf8563: clear expired alarm at boot time
has been removed from the -mm tree.  Its filename was
     rtc-pcf8563-clear-expired-alarm-at-boot-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kardell <jan.kardell@telliq.com>
Subject: rtc: pcf8563: clear expired alarm at boot time

In case the card is woken up of the rtc alarm, the
devm_rtc_device_register function detects it as a pending alarm about a
month in the future.  Fix this by clearing the alarm in module probe.

Signed-off-by: Jan Kardell <jan.kardell@telliq.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Vincent Donnefort <vdonnefort@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-clear-expired-alarm-at-boot-time drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-clear-expired-alarm-at-boot-time
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -396,6 +396,7 @@ static int pcf8563_rtc_set_alarm(struct
 
 static int pcf8563_irq_enable(struct device *dev, unsigned int enabled)
 {
+	dev_dbg(dev, "%s: en=%d\n", __func__, enabled);
 	return pcf8563_set_alarm_mode(to_i2c_client(dev), !!enabled);
 }
 
@@ -414,6 +415,7 @@ static int pcf8563_probe(struct i2c_clie
 	struct pcf8563 *pcf8563;
 	int err;
 	unsigned char buf;
+	unsigned char alm_pending;
 
 	dev_dbg(&client->dev, "%s\n", __func__);
 
@@ -439,6 +441,14 @@ static int pcf8563_probe(struct i2c_clie
 		return err;
 	}
 
+	err = pcf8563_get_alarm_mode(client, NULL, &alm_pending);
+	if (err < 0) {
+		dev_err(&client->dev, "%s: read error\n", __func__);
+		return err;
+	}
+	if (alm_pending)
+		pcf8563_set_alarm_mode(client, 0);
+
 	pcf8563->rtc = devm_rtc_device_register(&client->dev,
 				pcf8563_driver.driver.name,
 				&pcf8563_rtc_ops, THIS_MODULE);
_

Patches currently in -mm which might be from jan.kardell@telliq.com are

origin.patch

