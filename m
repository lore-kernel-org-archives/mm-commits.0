From: akpm@linux-foundation.org
Subject: +
 rtc-armada38x-fix-concurrency-access-in-armada38x_rtc_set_time.patch added
 to -mm tree
Date: Mon, 04 May 2015 14:14:55 -0700
Message-ID: <5547e14f.7gtys3Dxxz08o92T%akpm__7616.60904759101$1430774115$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41267 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbbEDVO4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2015 17:14:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregory.clement@free-electrons.com, a.zummo@towertech.it, alexandre.belloni@free-electrons.com, andrew@lunn.ch, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: armada38x: fix concurrency access in armada38x_rtc_set_time
has been added to the -mm tree.  Its filename is
     rtc-armada38x-fix-concurrency-access-in-armada38x_rtc_set_time.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-armada38x-fix-concurrency-access-in-armada38x_rtc_set_time.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-armada38x-fix-concurrency-access-in-armada38x_rtc_set_time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: rtc: armada38x: fix concurrency access in armada38x_rtc_set_time

While setting the time, the RTC TIME register should not be accessed. 
However due to hardware constraints, setting the RTC time involves
sleeping during 100ms.  This sleep was done outside the critical section
protected by the spinlock, so it was possible to read the RTC TIME
register and get an incorrect value.  This patch introduces a mutex for
protecting the RTC TIME access, unlike the spinlock it is allowed to sleep
in a critical section protected by a mutex.  The RTC STATUS register can
still be used from the interrupt handler but it has no effect on setting
the time.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Andrew Lunn <andrew@lunn.ch>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: <stable@vger.kernel.org>	[4.0]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-armada38x.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-armada38x.c~rtc-armada38x-fix-concurrency-access-in-armada38x_rtc_set_time drivers/rtc/rtc-armada38x.c
--- a/drivers/rtc/rtc-armada38x.c~rtc-armada38x-fix-concurrency-access-in-armada38x_rtc_set_time
+++ a/drivers/rtc/rtc-armada38x.c
@@ -40,6 +40,13 @@ struct armada38x_rtc {
 	void __iomem	    *regs;
 	void __iomem	    *regs_soc;
 	spinlock_t	    lock;
+	/*
+	 * While setting the time, the RTC TIME register should not be
+	 * accessed. Setting the RTC time involves sleeping during
+	 * 100ms, so a mutex instead of a spinlock is used to protect
+	 * it
+	 */
+	struct mutex	    mutex_time;
 	int		    irq;
 };
 
@@ -59,8 +66,7 @@ static int armada38x_rtc_read_time(struc
 	struct armada38x_rtc *rtc = dev_get_drvdata(dev);
 	unsigned long time, time_check, flags;
 
-	spin_lock_irqsave(&rtc->lock, flags);
-
+	mutex_lock(&rtc->mutex_time);
 	time = readl(rtc->regs + RTC_TIME);
 	/*
 	 * WA for failing time set attempts. As stated in HW ERRATA if
@@ -71,7 +77,7 @@ static int armada38x_rtc_read_time(struc
 	if ((time_check - time) > 1)
 		time_check = readl(rtc->regs + RTC_TIME);
 
-	spin_unlock_irqrestore(&rtc->lock, flags);
+	mutex_unlock(&rtc->mutex_time);
 
 	rtc_time_to_tm(time_check, tm);
 
@@ -94,19 +100,12 @@ static int armada38x_rtc_set_time(struct
 	 * then wait for 100ms before writing to the time register to be
 	 * sure that the data will be taken into account.
 	 */
-	spin_lock_irqsave(&rtc->lock, flags);
-
+	mutex_lock(&rtc->mutex_time);
 	rtc_delayed_write(0, rtc, RTC_STATUS);
-
-	spin_unlock_irqrestore(&rtc->lock, flags);
-
 	msleep(100);
-
-	spin_lock_irqsave(&rtc->lock, flags);
