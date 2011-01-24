From: akpm@linux-foundation.org
Subject: + rtc-propagate-error-handling-via-rtc_timer_enqueue-properly.patch added to -mm tree
Date: Mon, 24 Jan 2011 14:37:34 -0800
Message-ID: <201101242237.p0OMbZQD014992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339Ab1AXWil (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 17:38:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: john.stultz@linaro.org, a.zummo@towertech.it, ddaney@caviumnetworks.com, geert@linux-m68k.org, schwab@linux-m68k.org, tglx@linutronix.de


The patch titled
     rtc: propagate error handling via rtc_timer_enqueue properly
has been added to the -mm tree.  Its filename is
     rtc-propagate-error-handling-via-rtc_timer_enqueue-properly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: propagate error handling via rtc_timer_enqueue properly
From: John Stultz <john.stultz@linaro.org>

In cases where RTC hardware does not support alarms, the virtualized RTC
interfaces did not have a way to propagate the error up to userland.

This patch extends rtc_timer_enqueue so it catches errors from the
hardware and returns them upwards to the virtualized interfaces.  To
simplify error handling, it also internalizes the management of the
timer->enabled bit into rtc_timer_enqueue and rtc_timer_remove.

Also makes rtc_timer_enqueue and rtc_timer_remove static.

Reported-by: David Daney <ddaney@caviumnetworks.com>
Reported-by: Andreas Schwab <schwab@linux-m68k.org>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Diagnosed-by: David Daney <ddaney@caviumnetworks.com>
Tested-by: David Daney <ddaney@caviumnetworks.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |   49 +++++++++++++++++++++-----------------
 include/linux/rtc.h     |    2 -
 2 files changed, 28 insertions(+), 23 deletions(-)

diff -puN drivers/rtc/interface.c~rtc-propagate-error-handling-via-rtc_timer_enqueue-properly drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-propagate-error-handling-via-rtc_timer_enqueue-properly
+++ a/drivers/rtc/interface.c
@@ -16,6 +16,9 @@
 #include <linux/log2.h>
 #include <linux/workqueue.h>
 
+static int rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer);
+static void rtc_timer_remove(struct rtc_device *rtc, struct rtc_timer *timer);
+
 static int __rtc_read_time(struct rtc_device *rtc, struct rtc_time *tm)
 {
 	int err;
@@ -175,16 +178,14 @@ int rtc_set_alarm(struct rtc_device *rtc
 		return err;
 	if (rtc->aie_timer.enabled) {
 		rtc_timer_remove(rtc, &rtc->aie_timer);
-		rtc->aie_timer.enabled = 0;
 	}
 	rtc->aie_timer.node.expires = rtc_tm_to_ktime(alarm->time);
 	rtc->aie_timer.period = ktime_set(0, 0);
 	if (alarm->enabled) {
-		rtc->aie_timer.enabled = 1;
-		rtc_timer_enqueue(rtc, &rtc->aie_timer);
+		err = rtc_timer_enqueue(rtc, &rtc->aie_timer);
 	}
 	mutex_unlock(&rtc->ops_lock);
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(rtc_set_alarm);
 
@@ -195,15 +196,15 @@ int rtc_alarm_irq_enable(struct rtc_devi
 		return err;
 
 	if (rtc->aie_timer.enabled != enabled) {
-		if (enabled) {
-			rtc->aie_timer.enabled = 1;
-			rtc_timer_enqueue(rtc, &rtc->aie_timer);
-		} else {
+		if (enabled)
+			err = rtc_timer_enqueue(rtc, &rtc->aie_timer);
+		else
 			rtc_timer_remove(rtc, &rtc->aie_timer);
-			rtc->aie_timer.enabled = 0;
-		}
 	}
 
+	if (err)
+		return err;
+
 	if (!rtc->ops)
 		err = -ENODEV;
 	else if (!rtc->ops->alarm_irq_enable)
@@ -235,12 +236,9 @@ int rtc_update_irq_enable(struct rtc_dev
 		now = rtc_tm_to_ktime(tm);
 		rtc->uie_rtctimer.node.expires = ktime_add(now, onesec);
 		rtc->uie_rtctimer.period = ktime_set(1, 0);
-		rtc->uie_rtctimer.enabled = 1;
-		rtc_timer_enqueue(rtc, &rtc->uie_rtctimer);
-	} else {
+		err = rtc_timer_enqueue(rtc, &rtc->uie_rtctimer);
+	} else
 		rtc_timer_remove(rtc, &rtc->uie_rtctimer);
-		rtc->uie_rtctimer.enabled = 0;
-	}
 
 out:
 	mutex_unlock(&rtc->ops_lock);
@@ -488,10 +486,13 @@ EXPORT_SYMBOL_GPL(rtc_irq_set_freq);
  * Enqueues a timer onto the rtc devices timerqueue and sets
  * the next alarm event appropriately.
  *
+ * Sets the enabled bit on the added timer.
+ *
  * Must hold ops_lock for proper serialization of timerqueue
  */
-void rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
+static int rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
 {
+	timer->enabled = 1;
 	timerqueue_add(&rtc->timerqueue, &timer->node);
 	if (&timer->node == timerqueue_getnext(&rtc->timerqueue)) {
 		struct rtc_wkalrm alarm;
@@ -501,7 +502,13 @@ void rtc_timer_enqueue(struct rtc_device
 		err = __rtc_set_alarm(rtc, &alarm);
 		if (err == -ETIME)
 			schedule_work(&rtc->irqwork);
+		else if (err) {
+			timerqueue_del(&rtc->timerqueue, &timer->node);
+			timer->enabled = 0;
+			return err;
+		}
 	}
+	return 0;
 }
 
 /**
@@ -512,13 +519,15 @@ void rtc_timer_enqueue(struct rtc_device
  * Removes a timer onto the rtc devices timerqueue and sets
  * the next alarm event appropriately.
  *
+ * Clears the enabled bit on the removed timer.
+ *
  * Must hold ops_lock for proper serialization of timerqueue
  */
-void rtc_timer_remove(struct rtc_device *rtc, struct rtc_timer *timer)
+static void rtc_timer_remove(struct rtc_device *rtc, struct rtc_timer *timer)
 {
 	struct timerqueue_node *next = timerqueue_getnext(&rtc->timerqueue);
 	timerqueue_del(&rtc->timerqueue, &timer->node);
-
+	timer->enabled = 0;
 	if (next == &timer->node) {
 		struct rtc_wkalrm alarm;
 		int err;
@@ -626,8 +635,7 @@ int rtc_timer_start(struct rtc_device *r
 	timer->node.expires = expires;
 	timer->period = period;
 
-	timer->enabled = 1;
-	rtc_timer_enqueue(rtc, timer);
+	ret = rtc_timer_enqueue(rtc, timer);
 
 	mutex_unlock(&rtc->ops_lock);
 	return ret;
@@ -645,7 +653,6 @@ int rtc_timer_cancel(struct rtc_device *
 	mutex_lock(&rtc->ops_lock);
 	if (timer->enabled)
 		rtc_timer_remove(rtc, timer);
-	timer->enabled = 0;
 	mutex_unlock(&rtc->ops_lock);
 	return ret;
 }
diff -puN include/linux/rtc.h~rtc-propagate-error-handling-via-rtc_timer_enqueue-properly include/linux/rtc.h
--- a/include/linux/rtc.h~rtc-propagate-error-handling-via-rtc_timer_enqueue-properly
+++ a/include/linux/rtc.h
@@ -246,8 +246,6 @@ int rtc_register(rtc_task_t *task);
 int rtc_unregister(rtc_task_t *task);
 int rtc_control(rtc_task_t *t, unsigned int cmd, unsigned long arg);
 
-void rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer);
-void rtc_timer_remove(struct rtc_device *rtc, struct rtc_timer *timer);
 void rtc_timer_init(struct rtc_timer *timer, void (*f)(void* p), void* data);
 int rtc_timer_start(struct rtc_device *rtc, struct rtc_timer* timer,
 			ktime_t expires, ktime_t period);
_

Patches currently in -mm which might be from john.stultz@linaro.org are

rtc-propagate-error-handling-via-rtc_timer_enqueue-properly.patch
rtc-properly-handle-rtc_read_alarm-error-propagation-and-fix-bug.patch

