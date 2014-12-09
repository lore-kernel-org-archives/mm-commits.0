From: akpm@linux-foundation.org
Subject: +
 rtc-refine-rtc_timer_do_work-to-consider-other-set-alarm-failures.patch
 added to -mm tree
Date: Tue, 09 Dec 2014 15:05:06 -0800
Message-ID: <54878022.FNk6kZB0kju//Fdu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbaLIXFH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Dec 2014 18:05:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pang.xunlei@linaro.org, a.zummo@towertech.it, arnd.bergmann@linaro.org, john.stultz@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: refine rtc_timer_do_work() to consider other set alarm failures
has been added to the -mm tree.  Its filename is
     rtc-refine-rtc_timer_do_work-to-consider-other-set-alarm-failures.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-refine-rtc_timer_do_work-to-consider-other-set-alarm-failures.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-refine-rtc_timer_do_work-to-consider-other-set-alarm-failures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rtc-ab8500-set-uie_unsupported-flag.patch
rtc-refine-rtc_timer_do_work-to-consider-other-set-alarm-failures.patch
linux-next.patch

