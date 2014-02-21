From: akpm@linux-foundation.org
Subject: + rtc-mc13xxx-simplify-alarm_irq_enable.patch added to -mm tree
Date: Fri, 21 Feb 2014 15:10:02 -0800
Message-ID: <5307dcca.uOW4YkKGrt+WhcfG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbaBUXKD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 18:10:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, u.kleine-koenig@pengutronix.de, kernel@pengutronix.de, shc_work@mail.ru

Subject: + rtc-mc13xxx-simplify-alarm_irq_enable.patch added to -mm tree
To: shc_work@mail.ru,kernel@pengutronix.de,u.kleine-koenig@pengutronix.de
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 15:10:02 -0800


The patch titled
     Subject: rtc: mc13xxx: simplify alarm_irq_enable()
has been added to the -mm tree.  Its filename is
     rtc-mc13xxx-simplify-alarm_irq_enable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-mc13xxx-simplify-alarm_irq_enable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-mc13xxx-simplify-alarm_irq_enable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Shiyan <shc_work@mail.ru>
Subject: rtc: mc13xxx: simplify alarm_irq_enable()

This patch removes excess layer for alarm_irq_enable() function.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Sascha Hauer <kernel@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mc13xxx.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/rtc-mc13xxx.c~rtc-mc13xxx-simplify-alarm_irq_enable drivers/rtc/rtc-mc13xxx.c
--- a/drivers/rtc/rtc-mc13xxx.c~rtc-mc13xxx-simplify-alarm_irq_enable
+++ a/drivers/rtc/rtc-mc13xxx.c
@@ -42,15 +42,15 @@ static int mc13xxx_rtc_irq_enable_unlock
 	return func(priv->mc13xxx, irq);
 }
 
-static int mc13xxx_rtc_irq_enable(struct device *dev,
-		unsigned int enabled, int irq)
+static int mc13xxx_rtc_alarm_irq_enable(struct device *dev,
+					unsigned int enabled)
 {
 	struct mc13xxx_rtc *priv = dev_get_drvdata(dev);
 	int ret;
 
 	mc13xxx_lock(priv->mc13xxx);
 
-	ret = mc13xxx_rtc_irq_enable_unlocked(dev, enabled, irq);
+	ret = mc13xxx_rtc_irq_enable_unlocked(dev, enabled, MC13XXX_IRQ_TODA);
 
 	mc13xxx_unlock(priv->mc13xxx);
 
@@ -282,12 +282,6 @@ static irqreturn_t mc13xxx_rtc_update_ha
 	return IRQ_HANDLED;
 }
 
-static int mc13xxx_rtc_alarm_irq_enable(struct device *dev,
-		unsigned int enabled)
-{
-	return mc13xxx_rtc_irq_enable(dev, enabled, MC13XXX_IRQ_TODA);
-}
