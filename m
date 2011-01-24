From: akpm@linux-foundation.org
Subject: + rtc-properly-handle-rtc_read_alarm-error-propagation-and-fix-bug.patch added to -mm tree
Date: Mon, 24 Jan 2011 14:37:39 -0800
Message-ID: <201101242237.p0OMbd7E014998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339Ab1AXWiX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 17:38:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: john.stultz@linaro.org, a.zummo@towertech.it, tglx@linutronix.de


The patch titled
     rtc: properly handle rtc_read_alarm error propagation and fix bug
has been added to the -mm tree.  Its filename is
     rtc-properly-handle-rtc_read_alarm-error-propagation-and-fix-bug.patch

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
Subject: rtc: properly handle rtc_read_alarm error propagation and fix bug
From: John Stultz <john.stultz@linaro.org>

In reviewing cases where the virtualized interfaces didn't propagate
errors properly, I noticed rtc_read_alarm needed fixing.  In doing so I
noticed my RTC rework dropped a memset and that the behavior of
rtc_read_alarm shouldn't be conditionalized on the alarm.enabled flag (as
the alarm may be set, but the irqs may be disabled).  So those were
corrected as well.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/interface.c~rtc-properly-handle-rtc_read_alarm-error-propagation-and-fix-bug drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-properly-handle-rtc_read_alarm-error-propagation-and-fix-bug
+++ a/drivers/rtc/interface.c
@@ -123,12 +123,18 @@ int rtc_read_alarm(struct rtc_device *rt
 	err = mutex_lock_interruptible(&rtc->ops_lock);
 	if (err)
 		return err;
-	alarm->enabled = rtc->aie_timer.enabled;
-	if (alarm->enabled)
+	if (rtc->ops == NULL)
+		err = -ENODEV;
+	else if (!rtc->ops->read_alarm)
+		err = -EINVAL;
+	else {
+		memset(alarm, 0, sizeof(struct rtc_wkalrm));
+		alarm->enabled = rtc->aie_timer.enabled;
 		alarm->time = rtc_ktime_to_tm(rtc->aie_timer.node.expires);
+	}
 	mutex_unlock(&rtc->ops_lock);
 
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(rtc_read_alarm);
 
_

Patches currently in -mm which might be from john.stultz@linaro.org are

rtc-propagate-error-handling-via-rtc_timer_enqueue-properly.patch
rtc-properly-handle-rtc_read_alarm-error-propagation-and-fix-bug.patch

