From: akpm@linux-foundation.org
Subject: [-]
 drivers-rtc-interfacec-check-the-error-after-__rtc_read_time.patch removed
 from -mm tree
Date: Tue, 16 Jun 2015 13:04:52 -0700
Message-ID: <55808164.1Nw4lq/og1EBWRo1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35753 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204AbbFPUEw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jun 2015 16:04:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hyogi.gim@lge.com, a.zummo@towertech.it, alexandre.belloni@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/interface.c: check the error after __rtc_read_time()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-interfacec-check-the-error-after-__rtc_read_time.patch

This patch was dropped because Alexandre is taking care of it

------------------------------------------------------
From: Hyogi Gim <hyogi.gim@lge.com>
Subject: drivers/rtc/interface.c: check the error after __rtc_read_time()

Add the verification code for returned __rtc_read_time() error in
rtc_update_irq_enable() and rtc_timer_do_work().

Signed-off-by: Hyogi Gim <hyogi.gim@lge.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/interface.c~drivers-rtc-interfacec-check-the-error-after-__rtc_read_time drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~drivers-rtc-interfacec-check-the-error-after-__rtc_read_time
+++ a/drivers/rtc/interface.c
@@ -494,7 +494,10 @@ int rtc_update_irq_enable(struct rtc_dev
 		struct rtc_time tm;
 		ktime_t now, onesec;
 
-		__rtc_read_time(rtc, &tm);
+		err = __rtc_read_time(rtc, &tm);
+		if (err < 0)
+			goto out;
+
 		onesec = ktime_set(1, 0);
 		now = rtc_tm_to_ktime(tm);
 		rtc->uie_rtctimer.node.expires = ktime_add(now, onesec);
@@ -872,13 +875,17 @@ void rtc_timer_do_work(struct work_struc
 	struct timerqueue_node *next;
 	ktime_t now;
 	struct rtc_time tm;
+	int err = 0;
 
 	struct rtc_device *rtc =
 		container_of(work, struct rtc_device, irqwork);
 
 	mutex_lock(&rtc->ops_lock);
 again:
-	__rtc_read_time(rtc, &tm);
+	err = __rtc_read_time(rtc, &tm);
+	if (err < 0)
+		goto out;
+
 	now = rtc_tm_to_ktime(tm);
 	while ((next = timerqueue_getnext(&rtc->timerqueue))) {
 		if (next->expires.tv64 > now.tv64)
@@ -903,7 +910,6 @@ again:
 	/* Set next alarm */
 	if (next) {
 		struct rtc_wkalrm alarm;
-		int err;
 		int retry = 3;
 
 		alarm.time = rtc_ktime_to_tm(next->expires);
@@ -925,6 +931,7 @@ reprogram:
 	} else
 		rtc_alarm_disable(rtc);
 
+out:
 	pm_relax(rtc->dev.parent);
 	mutex_unlock(&rtc->ops_lock);
 }
_

Patches currently in -mm which might be from hyogi.gim@lge.com are


