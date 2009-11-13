From: akpm@linux-foundation.org
Subject: [merged] rtc-pcf50633-consider-alrm-enable-in-pcf50633_rtc_set_alarm.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:26:48 -0800
Message-ID: <200911131926.nADJQm4l029116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932211AbZKMT1G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:27:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: werner@openmoko.org, a.zummo@towertech.it, balajirrao@openmoko.org, fercerpav@gmail.com, mickey@openmoko.org, p_gortmaker@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     rtc: pcf50633: consider alrm->enable in pcf50633_rtc_set_alarm
has been removed from the -mm tree.  Its filename was
     rtc-pcf50633-consider-alrm-enable-in-pcf50633_rtc_set_alarm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: pcf50633: consider alrm->enable in pcf50633_rtc_set_alarm
From: Werner Almesberger <werner@openmoko.org>

According to Documentation/rtc.txt, RTC_WKALM_SET sets the alarm time and
enables/disables the alarm.  We implement RTC_WKALM_SET through
pcf50633_rtc_set_alarm.  The enabling/disabling part was missing.

Signed-off-by: Werner Almesberger <werner@openmoko.org>
Reported-by: Michael 'Mickey' Lauer <mickey@openmoko.org>
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Balaji Rao <balajirrao@openmoko.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/rtc/rtc-pcf50633.c~rtc-pcf50633-consider-alrm-enable-in-pcf50633_rtc_set_alarm drivers/rtc/rtc-pcf50633.c
--- a/drivers/rtc/rtc-pcf50633.c~rtc-pcf50633-consider-alrm-enable-in-pcf50633_rtc_set_alarm
+++ a/drivers/rtc/rtc-pcf50633.c
@@ -245,8 +245,9 @@ static int pcf50633_rtc_set_alarm(struct
 	ret = pcf50633_write_block(rtc->pcf, PCF50633_REG_RTCSCA,
 				PCF50633_TI_EXTENT, &pcf_tm.time[0]);
 
-	if (!alarm_masked)
+	if (!alarm_masked || alrm->enabled)
 		pcf50633_irq_unmask(rtc->pcf, PCF50633_IRQ_ALARM);
+	rtc->alarm_enabled = alrm->enabled;
 
 	return ret;
 }
_

Patches currently in -mm which might be from werner@openmoko.org are

rtc-pcf50633-manage-rtc-alarm-pending-flag.patch

