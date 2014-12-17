From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-interfacec-check-the-error-after-__rtc_read_time.patch added to -mm tree
Date: Wed, 17 Dec 2014 13:52:00 -0800
Message-ID: <5491fb00.Cpo7kFsxGiBtS5w9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaLQVwB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Dec 2014 16:52:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hyogi.gim@lge.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/interface.c: check the error after __rtc_read_time()
has been added to the -mm tree.  Its filename is
     drivers-rtc-interfacec-check-the-error-after-__rtc_read_time.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-interfacec-check-the-error-after-__rtc_read_time.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-interfacec-check-the-error-after-__rtc_read_time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hyogi Gim <hyogi.gim@lge.com>
Subject: drivers/rtc/interface.c: check the error after __rtc_read_time()

Add the verification code for returned __rtc_read_time() error in
rtc_update_irq_enable() and rtc_timer_do_work().

Signed-off-by: Hyogi Gim <hyogi.gim@lge.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/interface.c~drivers-rtc-interfacec-check-the-error-after-__rtc_read_time drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~drivers-rtc-interfacec-check-the-error-after-__rtc_read_time
+++ a/drivers/rtc/interface.c
@@ -489,7 +489,10 @@ int rtc_update_irq_enable(struct rtc_dev
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
@@ -867,13 +870,17 @@ void rtc_timer_do_work(struct work_struc
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
@@ -898,7 +905,6 @@ again:
 	/* Set next alarm */
 	if (next) {
 		struct rtc_wkalrm alarm;
-		int err;
 		int retry = 3;
 
 		alarm.time = rtc_ktime_to_tm(next->expires);
@@ -920,6 +926,7 @@ reprogram:
 	} else
 		rtc_alarm_disable(rtc);
 
+out:
 	pm_relax(rtc->dev.parent);
 	mutex_unlock(&rtc->ops_lock);
 }
_

Patches currently in -mm which might be from hyogi.gim@lge.com are

origin.patch
drivers-rtc-interfacec-check-the-error-after-__rtc_read_time.patch

