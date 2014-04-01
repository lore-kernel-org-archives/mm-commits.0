From: akpm@linux-foundation.org
Subject: + rtc-treewide-remove-excess-rtc_device-validation.patch added to -mm tree
Date: Tue, 01 Apr 2014 15:55:50 -0700
Message-ID: <533b43f6.MYRSztWOssl/uCpZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaDAWzu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2014 18:55:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, a.zummo@towertech.it, shc_work@mail.ru

Subject: + rtc-treewide-remove-excess-rtc_device-validation.patch added to -mm tree
To: shc_work@mail.ru,a.zummo@towertech.it
From: akpm@linux-foundation.org
Date: Tue, 01 Apr 2014 15:55:50 -0700


The patch titled
     Subject: rtc: treewide: remove excess rtc_device validation
has been added to the -mm tree.  Its filename is
     rtc-treewide-remove-excess-rtc_device-validation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-treewide-remove-excess-rtc_device-validation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-treewide-remove-excess-rtc_device-validation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Shiyan <shc_work@mail.ru>
Subject: rtc: treewide: remove excess rtc_device validation

9ec5d20993 ("rtc: verify a critical argument to rtc_update_irq() before
using it") introduces validation for rtc_device in the RTC core, so there
are no need to check this argument for rtc_update_irq() from the drivers.

This patch removes such check for the existing rtc_update_irq() users.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1511.c   |    3 +--
 drivers/rtc/rtc-ds1553.c   |    3 +--
 drivers/rtc/rtc-stk17ta8.c |    3 +--
 drivers/rtc/rtc-tx4939.c   |    4 ++--
 4 files changed, 5 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-ds1511.c~rtc-treewide-remove-excess-rtc_device-validation drivers/rtc/rtc-ds1511.c
--- a/drivers/rtc/rtc-ds1511.c~rtc-treewide-remove-excess-rtc_device-validation
+++ a/drivers/rtc/rtc-ds1511.c
@@ -371,8 +371,7 @@ ds1511_interrupt(int irq, void *dev_id)
 			events |= RTC_UF;
 		else
 			events |= RTC_AF;
-		if (likely(pdata->rtc))
-			rtc_update_irq(pdata->rtc, 1, events);
+		rtc_update_irq(pdata->rtc, 1, events);
 	}
 	spin_unlock(&pdata->lock);
 	return events ? IRQ_HANDLED : IRQ_NONE;
diff -puN drivers/rtc/rtc-ds1553.c~rtc-treewide-remove-excess-rtc_device-validation drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~rtc-treewide-remove-excess-rtc_device-validation
+++ a/drivers/rtc/rtc-ds1553.c
@@ -206,8 +206,7 @@ static irqreturn_t ds1553_rtc_interrupt(
 			events |= RTC_UF;
 		else
 			events |= RTC_AF;
-		if (likely(pdata->rtc))
-			rtc_update_irq(pdata->rtc, 1, events);
+		rtc_update_irq(pdata->rtc, 1, events);
 	}
 	spin_unlock(&pdata->lock);
 	return events ? IRQ_HANDLED : IRQ_NONE;
diff -puN drivers/rtc/rtc-stk17ta8.c~rtc-treewide-remove-excess-rtc_device-validation drivers/rtc/rtc-stk17ta8.c
--- a/drivers/rtc/rtc-stk17ta8.c~rtc-treewide-remove-excess-rtc_device-validation
+++ a/drivers/rtc/rtc-stk17ta8.c
@@ -214,8 +214,7 @@ static irqreturn_t stk17ta8_rtc_interrup
 			events |= RTC_UF;
 		else
 			events |= RTC_AF;
-		if (likely(pdata->rtc))
-			rtc_update_irq(pdata->rtc, 1, events);
+		rtc_update_irq(pdata->rtc, 1, events);
 	}
 	spin_unlock(&pdata->lock);
 	return events ? IRQ_HANDLED : IRQ_NONE;
diff -puN drivers/rtc/rtc-tx4939.c~rtc-treewide-remove-excess-rtc_device-validation drivers/rtc/rtc-tx4939.c
--- a/drivers/rtc/rtc-tx4939.c~rtc-treewide-remove-excess-rtc_device-validation
+++ a/drivers/rtc/rtc-tx4939.c
@@ -176,8 +176,8 @@ static irqreturn_t tx4939_rtc_interrupt(
 		tx4939_rtc_cmd(rtcreg, TX4939_RTCCTL_COMMAND_NOP);
 	}
 	spin_unlock(&pdata->lock);
-	if (likely(pdata->rtc))
-		rtc_update_irq(pdata->rtc, 1, events);
+	rtc_update_irq(pdata->rtc, 1, events);
+
 	return IRQ_HANDLED;
 }
 
_

Patches currently in -mm which might be from shc_work@mail.ru are

rtc-fixed-potential-race-condition.patch
rtc-fixed-potential-race-condition-checkpatch-fixes.patch
rtc-mc13xxx-remove-__exit_p.patch
rtc-mc13xxx-request-irqs-after-rtc-registration.patch
rtc-mc13xxx-simplify-alarm_irq_enable.patch
rtc-mc13xxx-fix-1hz-interrupt.patch
rtc-mc13xxx-change-rtc-validation-scheme.patch
rtc-mc13xxx-make-rtc_read_time-more-readable.patch
rtc-verify-a-critical-argument-to-rtc_update_irq-before-using-it.patch
drivers-rtc-rtc-mc13xxxc-fix-potential-race-condition.patch
rtc-treewide-remove-excess-rtc_device-validation.patch
linux-next.patch

