From: akpm@linux-foundation.org
Subject: + drivers-rtc-interfacec-fix-checkpatch-errors.patch added to -mm tree
Date: Tue, 07 May 2013 15:38:52 -0700
Message-ID: <20130507223852.DBD5431C082@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:40812 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab3EGWix (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 18:38:53 -0400
Received: by mail-gh0-f201.google.com with SMTP id r14so109209ghr.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 15:38:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, jg1.han@samsung.com


The patch titled
     Subject: drivers/rtc/interface.c: fix checkpatch errors
has been added to the -mm tree.  Its filename is
     drivers-rtc-interfacec-fix-checkpatch-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/interface.c: fix checkpatch errors

Fixes the following types of errors:
ERROR: "foo* bar" should be "foo *bar"
ERROR: else should follow close brace '}'
WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/interface.c~drivers-rtc-interfacec-fix-checkpatch-errors drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~drivers-rtc-interfacec-fix-checkpatch-errors
+++ a/drivers/rtc/interface.c
@@ -109,9 +109,9 @@ int rtc_set_mmss(struct rtc_device *rtc,
 				err = rtc->ops->set_time(rtc->dev.parent,
 						&new);
 		}
-	}
-	else
+	} else {
 		err = -EINVAL;
+	}
 
 	mutex_unlock(&rtc->ops_lock);
 	/* A timer might have just expired */
@@ -367,14 +367,14 @@ int rtc_set_alarm(struct rtc_device *rtc
 	err = mutex_lock_interruptible(&rtc->ops_lock);
 	if (err)
 		return err;
-	if (rtc->aie_timer.enabled) {
+	if (rtc->aie_timer.enabled)
 		rtc_timer_remove(rtc, &rtc->aie_timer);
-	}
+
 	rtc->aie_timer.node.expires = rtc_tm_to_ktime(alarm->time);
 	rtc->aie_timer.period = ktime_set(0, 0);
-	if (alarm->enabled) {
+	if (alarm->enabled)
 		err = rtc_timer_enqueue(rtc, &rtc->aie_timer);
-	}
+
 	mutex_unlock(&rtc->ops_lock);
 	return err;
 }
@@ -891,7 +891,7 @@ again:
  *
  * Kernel interface to initializing an rtc_timer.
  */
-void rtc_timer_init(struct rtc_timer *timer, void (*f)(void* p), void* data)
+void rtc_timer_init(struct rtc_timer *timer, void (*f)(void *p), void *data)
 {
 	timerqueue_init(&timer->node);
 	timer->enabled = 0;
@@ -907,7 +907,7 @@ void rtc_timer_init(struct rtc_timer *ti
  *
  * Kernel interface to set an rtc_timer
  */
-int rtc_timer_start(struct rtc_device *rtc, struct rtc_timer* timer,
+int rtc_timer_start(struct rtc_device *rtc, struct rtc_timer *timer,
 			ktime_t expires, ktime_t period)
 {
 	int ret = 0;
@@ -930,7 +930,7 @@ int rtc_timer_start(struct rtc_device *r
  *
  * Kernel interface to cancel an rtc_timer
  */
-int rtc_timer_cancel(struct rtc_device *rtc, struct rtc_timer* timer)
+int rtc_timer_cancel(struct rtc_device *rtc, struct rtc_timer *timer)
 {
 	int ret = 0;
 	mutex_lock(&rtc->ops_lock);
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
drivers-rtc-rtc-v3020c-remove-redundant-goto.patch
drivers-rtc-interfacec-fix-checkpatch-errors.patch
drivers-rtc-rtc-at32ap700xc-fix-checkpatch-error.patch
drivers-rtc-rtc-at91rm9200c-include-linux-uaccessh.patch
drivers-rtc-rtc-cmosc-fix-whitespace-related-errors.patch
drivers-rtc-rtc-davincic-fix-whitespace-warning.patch
drivers-rtc-rtc-ds1305c-add-missing-braces-around-sizeof.patch
drivers-rtc-rtc-ds1374c-fix-spacing-related-issues.patch
drivers-rtc-rtc-ds1511c-fix-issues-related-to-spaces-and-braces.patch
drivers-rtc-rtc-ds3234c-fix-whitespace-issue.patch
drivers-rtc-rtc-fm3130c-fix-whitespace-related-issue.patch
drivers-rtc-rtc-m41t80c-fix-spacing-related-issue.patch
drivers-rtc-rtc-max6902c-remove-unwanted-spaces.patch
drivers-rtc-rtc-max77686c-remove-space-before-semicolon.patch
drivers-rtc-rtc-max8997c-remove-space-before-semicolon.patch
drivers-rtc-rtc-mpc5121c-remove-space-before-tab.patch
drivers-rtc-rtc-msm6242c-use-pr_warn.patch
drivers-rtc-rtc-mxcc-fix-checkpatch-error.patch
drivers-rtc-rtc-omapc-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-pcf2123c-remove-space-before-tabs.patch
drivers-rtc-rtc-pcf8583c-move-assignment-outside-if-condition.patch
drivers-rtc-rtc-rs5c313c-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-rs5c313c-fix-spacing-related-issues.patch
drivers-rtc-rtc-v3020c-fix-spacing-issues.patch
drivers-rtc-rtc-vr41xxc-fix-spacing-issues.patch
drivers-rtc-rtc-x1205c-fix-checkpatch-issues.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch

