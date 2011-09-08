From: akpm@linux-foundation.org
Subject: + rtc-rtc-s3c-fix-no-occurrence-of-alarm-interrupt.patch added to -mm tree
Date: Thu, 08 Sep 2011 16:54:42 -0700
Message-ID: <201109082354.p88NshqG015784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754223Ab1IHXys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2011 19:54:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dg77.kim@samsung.com, kyungmin.park@samsung.com, myungjoo.ham@samsung.com


The patch titled
     drivers/rtc/rtc-s3c.c: fix no occurrence of alarm interrupt
has been added to the -mm tree.  Its filename is
     rtc-rtc-s3c-fix-no-occurrence-of-alarm-interrupt.patch

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
Subject: drivers/rtc/rtc-s3c.c: fix no occurrence of alarm interrupt
From: Donggeun Kim <dg77.kim@samsung.com>

The driver does not generate an alarm interrupt
even though a time for an alarm is set.
This results from disabling rtc_clk after setting the alarm time.

To generate an alarm interrupt the driver should maintain its enabled
state for rtc_clk the until alarm interrupt occurs.  This patch permits
generation of an alarm interrupt.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff -puN drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-fix-no-occurrence-of-alarm-interrupt drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-fix-no-occurrence-of-alarm-interrupt
+++ a/drivers/rtc/rtc-s3c.c
@@ -50,6 +50,27 @@ static bool wake_en;
 static enum s3c_cpu_type s3c_rtc_cpu_type;
 
 static DEFINE_SPINLOCK(s3c_rtc_pie_lock);
+static DEFINE_SPINLOCK(s3c_rtc_alarm_clk_lock);
+
+static void s3c_rtc_alarm_clk_enable(bool enable)
+{
+	static bool alarm_clk_enabled;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&s3c_rtc_alarm_clk_lock, irq_flags);
+	if (enable) {
+		if (!alarm_clk_enabled) {
+			clk_enable(rtc_clk);
+			alarm_clk_enabled = true;
+		}
+	} else {
+		if (alarm_clk_enabled) {
+			clk_disable(rtc_clk);
+			alarm_clk_enabled = false;
+		}
+	}
+	spin_unlock_irqrestore(&s3c_rtc_alarm_clk_lock, irq_flags);
+}
 
 /* IRQ Handlers */
 
@@ -64,6 +85,9 @@ static irqreturn_t s3c_rtc_alarmirq(int 
 		writeb(S3C2410_INTP_ALM, s3c_rtc_base + S3C2410_INTP);
 
 	clk_disable(rtc_clk);
+
+	s3c_rtc_alarm_clk_enable(false);
+
 	return IRQ_HANDLED;
 }
 
@@ -97,6 +121,8 @@ static int s3c_rtc_setaie(struct device 
 	writeb(tmp, s3c_rtc_base + S3C2410_RTCALM);
 	clk_disable(rtc_clk);
 
+	s3c_rtc_alarm_clk_enable(enabled);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from dg77.kim@samsung.com are

rtc-rtc-s3c-fix-no-occurrence-of-alarm-interrupt.patch
rtc-rtc-s3c-fix-no-occurrence-of-alarm-interrupt-fix.patch
linux-next.patch
driver-misc-fsa9480c-fix-potential-null-pointer-dereference.patch

