From: akpm@linux-foundation.org
Subject: [merged]
 rtc-refine-rtc_timer_do_work-to-consider-other-set-alarm-failures.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 11:07:54 -0800
Message-ID: <5489eb8a.H5RSETwmeYbGcfev%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919AbaLKTHz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:07:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pang.xunlei@linaro.org, a.zummo@towertech.it, arnd.bergmann@linaro.org, john.stultz@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: refine rtc_timer_do_work() to consider other set alarm failures
has been removed from the -mm tree.  Its filename was
     rtc-refine-rtc_timer_do_work-to-consider-other-set-alarm-failures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xunlei Pang <pang.xunlei@linaro.org>
Subject: rtc: refine rtc_timer_do_work() to consider other set alarm failures

rtc_timer_do_work() only judges -ETIME failure of__rtc_set_alarm(), but
doesn't handle other failures like -EIO, -EBUSY, etc.

If there is a failure other than -ETIME, the next rtc_timer will stay in
the timerqueue.  Then later rtc_timers will be enqueued directly because
they have a later expires time, so the alarm irq will never be programmed.

When such failures happen, this patch will retry __rtc_set_alarm(), if
still can't program the alarm time, it will remove current rtc_timer from
timerqueue and fetch next one, thus preventing it from affecting other rtc
timers.

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN drivers/rtc/interface.c~rtc-refine-rtc_timer_do_work-to-consider-other-set-alarm-failures drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-refine-rtc_timer_do_work-to-consider-other-set-alarm-failures
+++ a/drivers/rtc/interface.c
@@ -899,11 +899,24 @@ again:
 	if (next) {
 		struct rtc_wkalrm alarm;
 		int err;
+		int retry = 3;
+
 		alarm.time = rtc_ktime_to_tm(next->expires);
 		alarm.enabled = 1;
+reprogram:
 		err = __rtc_set_alarm(rtc, &alarm);
 		if (err == -ETIME)
 			goto again;
+		else if (err) {
+			if (retry-- > 0)
+				goto reprogram;
+
+			timer = container_of(next, struct rtc_timer, node);
+			timerqueue_del(&rtc->timerqueue, &timer->node);
+			timer->enabled = 0;
+			dev_err(&rtc->dev, "__rtc_set_alarm: err=%d\n", err);
+			goto again;
+		}
 	} else
 		rtc_alarm_disable(rtc);
 
_

Patches currently in -mm which might be from pang.xunlei@linaro.org are

origin.patch

