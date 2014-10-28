From: akpm@linux-foundation.org
Subject: + rtc-pcf8563-clear-expired-alarm-at-boot-time.patch added to -mm tree
Date: Tue, 28 Oct 2014 14:26:14 -0700
Message-ID: <545009f6.2yI/ucCZxpY4RTQG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbaJ1V0O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Oct 2014 17:26:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kardell@telliq.com, a.zummo@towertech.it, dan.carpenter@oracle.com, grant.likely@linaro.org, robh+dt@kernel.org, vdonnefort@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: pcf8563: clear expired alarm at boot time
has been added to the -mm tree.  Its filename is
     rtc-pcf8563-clear-expired-alarm-at-boot-time.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-pcf8563-clear-expired-alarm-at-boot-time.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-pcf8563-clear-expired-alarm-at-boot-time.patch

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

rtc-pcf8563-remove-leftover-code.patch
rtc-pcf8563-fix-write-of-invalid-bits-to-st2-reg.patch
rtc-pcf8563-fix-wrong-time-from-read_alarm.patch
rtc-pcf8563-handle-consequeces-of-lacking-second-alarm-reg.patch
rtc-pcf8563-save-battery-power.patch
rtc-pcf8563-clear-expired-alarm-at-boot-time.patch

