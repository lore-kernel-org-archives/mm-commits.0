From: akpm@linux-foundation.org
Subject: + rtc-s3c-rtc-fixup-wake-support-for-rtc.patch added to -mm tree
Date: Fri, 29 Apr 2011 14:22:08 -0700
Message-ID: <201104292122.p3TLM8jg017866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751061Ab1D2VW3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Apr 2011 17:22:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, a.zummo@towertech.it, broonie@opensource.wolfsonmicro.com, stable@kernel.org


The patch titled
     drivers/rtc/rtc-s3c.c: fixup wake support for rtc
has been added to the -mm tree.  Its filename is
     rtc-s3c-rtc-fixup-wake-support-for-rtc.patch

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
Subject: drivers/rtc/rtc-s3c.c: fixup wake support for rtc
From: Ben Dooks <ben-linux@fluff.org>

The driver is not balancing set_irq and disable_irq_wake() calls, so
ensure that it keeps track of whether the wake is enabled.

The fixes the following error on S3C6410 devices:

WARNING: at kernel/irq/manage.c:382 set_irq_wake+0x84/0xec()
Unbalanced IRQ 92 wake disable

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-s3c-rtc-fixup-wake-support-for-rtc drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-s3c-rtc-fixup-wake-support-for-rtc
+++ a/drivers/rtc/rtc-s3c.c
@@ -46,6 +46,7 @@ static struct clk *rtc_clk;
 static void __iomem *s3c_rtc_base;
 static int s3c_rtc_alarmno = NO_IRQ;
 static int s3c_rtc_tickno  = NO_IRQ;
+static bool wake_en;
 static enum s3c_cpu_type s3c_rtc_cpu_type;
 
 static DEFINE_SPINLOCK(s3c_rtc_pie_lock);
@@ -562,8 +563,12 @@ static int s3c_rtc_suspend(struct platfo
 	}
 	s3c_rtc_enable(pdev, 0);
 
-	if (device_may_wakeup(&pdev->dev))
-		enable_irq_wake(s3c_rtc_alarmno);
+	if (device_may_wakeup(&pdev->dev) && !wake_en) {
+		if (enable_irq_wake(s3c_rtc_alarmno) == 0)
+			wake_en = true;
+		else
+			dev_err(&pdev->dev, "enable_irq_wake failed\n");
+	}
 
 	return 0;
 }
@@ -579,8 +584,10 @@ static int s3c_rtc_resume(struct platfor
 		writew(tmp | ticnt_en_save, s3c_rtc_base + S3C2410_RTCCON);
 	}
 
-	if (device_may_wakeup(&pdev->dev))
+	if (device_may_wakeup(&pdev->dev) && wake_en) {
 		disable_irq_wake(s3c_rtc_alarmno);
+		wake_en = false;
+	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
rtc-s3c-rtc-fixup-wake-support-for-rtc.patch
linux-next.patch
drivers-i2c-busses-i2c-designware-corec-needs-delayh.patch

