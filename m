From: akpm@linux-foundation.org
Subject: + rtc-pcf50633-manage-rtc-alarm-pending-flag.patch added to -mm tree
Date: Tue, 10 Nov 2009 14:52:38 -0800
Message-ID: <200911102252.nAAMqc55013849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214AbZKJWw7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Nov 2009 17:52:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: werner@openmoko.org, a.zummo@towertech.it, balajirrao@openmoko.org, fercerpav@gmail.com, p_gortmaker@yahoo.com


The patch titled
     rtc: pcf50633: manage RTC alarm "pending" flag
has been added to the -mm tree.  Its filename is
     rtc-pcf50633-manage-rtc-alarm-pending-flag.patch

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
Subject: rtc: pcf50633: manage RTC alarm "pending" flag
From: Werner Almesberger <werner@openmoko.org>

Add setting and clearing of the "pending" flag of the RTC alarm.  The
semantics follow the UEFI specification 2.2 available at
http://www.uefi.org/specs/, i.e., the "pending" flag is cleared by
disabling the alarm, but not by any other condition (such as the passing
of time, a successful wakeup, or setting of a new alarm.)

Signed-off-by: Werner Almesberger <werner@openmoko.org>
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Balaji Rao <balajirrao@openmoko.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/rtc/rtc-pcf50633.c~rtc-pcf50633-manage-rtc-alarm-pending-flag drivers/rtc/rtc-pcf50633.c
--- a/drivers/rtc/rtc-pcf50633.c~rtc-pcf50633-manage-rtc-alarm-pending-flag
+++ a/drivers/rtc/rtc-pcf50633.c
@@ -58,6 +58,7 @@ struct pcf50633_time {
 struct pcf50633_rtc {
 	int alarm_enabled;
 	int second_enabled;
+	int alarm_pending;
 
 	struct pcf50633 *pcf;
 	struct rtc_device *rtc_dev;
@@ -209,6 +210,7 @@ static int pcf50633_rtc_read_alarm(struc
 	rtc = dev_get_drvdata(dev);
 
 	alrm->enabled = rtc->alarm_enabled;
+	alrm->pending = rtc->alarm_pending;
 
 	ret = pcf50633_read_block(rtc->pcf, PCF50633_REG_RTCSCA,
 				PCF50633_TI_EXTENT, &pcf_tm.time[0]);
@@ -244,6 +246,8 @@ static int pcf50633_rtc_set_alarm(struct
 	/* Returns 0 on success */
 	ret = pcf50633_write_block(rtc->pcf, PCF50633_REG_RTCSCA,
 				PCF50633_TI_EXTENT, &pcf_tm.time[0]);
+	if (!alrm->enabled)
+		rtc->alarm_pending = 0;
 
 	if (!alarm_masked || alrm->enabled)
 		pcf50633_irq_unmask(rtc->pcf, PCF50633_IRQ_ALARM);
@@ -268,6 +272,7 @@ static void pcf50633_rtc_irq(int irq, vo
 	switch (irq) {
 	case PCF50633_IRQ_ALARM:
 		rtc_update_irq(rtc->rtc_dev, 1, RTC_AF | RTC_IRQF);
+		rtc->alarm_pending = 1;
 		break;
 	case PCF50633_IRQ_SECOND:
 		rtc_update_irq(rtc->rtc_dev, 1, RTC_UF | RTC_IRQF);
_

Patches currently in -mm which might be from werner@openmoko.org are

rtc-pcf50633-consider-alrm-enable-in-pcf50633_rtc_set_alarm.patch
rtc-pcf50633-manage-rtc-alarm-pending-flag.patch

