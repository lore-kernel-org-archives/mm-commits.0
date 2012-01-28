From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-twlc-enable-rtc-irrespective-of-its-prior-state.patch added to -mm tree
Date: Fri, 27 Jan 2012 16:41:52 -0800
Message-ID: <20120128004153.139E4A01C7@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:47582 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab2A1Alz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jan 2012 19:41:55 -0500
Received: by eekb15 with SMTP id b15so119135eek.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2012 16:41:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vbyravarasu@nvidia.com, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc/rtc-twl.c: enable RTC irrespective of its prior state
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-twlc-enable-rtc-irrespective-of-its-prior-state.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: drivers/rtc/rtc-twl.c: enable RTC irrespective of its prior state

As part of probe, before enabling RTC, RTC_CTRL register is read to check
if it is already running.  If RTC is used by kernel alone, then this read
is not required.  Even if RTC was enabled already by boot loader, setting
STOP_RTC bit again should not harm.  Hence removed unwanted read
operation.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff -puN drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-enable-rtc-irrespective-of-its-prior-state drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-enable-rtc-irrespective-of-its-prior-state
+++ a/drivers/rtc/rtc-twl.c
@@ -457,19 +457,11 @@ static int __devinit twl_rtc_probe(struc
 			REG_INT_MSK_STS_A);
 	}
 
-	/* Check RTC module status, Enable if it is off */
-	ret = twl_rtc_read_u8(&rd_reg, REG_RTC_CTRL_REG);
+	dev_info(&pdev->dev, "Enabling TWL-RTC\n");
+	ret = twl_rtc_write_u8(BIT_RTC_CTRL_REG_STOP_RTC_M, REG_RTC_CTRL_REG);
 	if (ret < 0)
 		goto out1;
 
-	if (!(rd_reg & BIT_RTC_CTRL_REG_STOP_RTC_M)) {
-		dev_info(&pdev->dev, "Enabling TWL-RTC.\n");
-		rd_reg = BIT_RTC_CTRL_REG_STOP_RTC_M;
-		ret = twl_rtc_write_u8(rd_reg, REG_RTC_CTRL_REG);
-		if (ret < 0)
-			goto out1;
-	}
