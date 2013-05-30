From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ds1302c-handle-write-protection.patch added to
 -mm tree
Date: Thu, 30 May 2013 13:37:50 -0700
Message-ID: <51a7b89e.9zui7FZUtCyjYcrY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757722Ab3E3Uhw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 May 2013 16:37:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sachin.kamat@linaro.org, maz@misterjones.org, jg1.han@samsung.com, a.zummo@towertech.it, ynvich@gmail.com

Subject: + drivers-rtc-rtc-ds1302c-handle-write-protection.patch added to -mm tree
To: ynvich@gmail.com,a.zummo@towertech.it,jg1.han@samsung.com,maz@misterjones.org,sachin.kamat@linaro.org
From: akpm@linux-foundation.org
Date: Thu, 30 May 2013 13:37:50 -0700


The patch titled
     Subject: drivers/rtc/rtc-ds1302.c: handle write protection
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1302c-handle-write-protection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Yanovich <ynvich@gmail.com>
Subject: drivers/rtc/rtc-ds1302.c: handle write protection

This chip has a control register and can prevent altering saved clock.
Without this patch we could have:

(arm)root@pac14:~# date
Tue May 21 03:08:27 MSK 2013
(arm)root@pac14:~# /etc/init.d/hwclock.sh show
Tue May 21 11:13:58 2013  -0.067322 seconds
(arm)root@pac14:~# /etc/init.d/hwclock.sh stop
[info] Saving the system clock.
[info] Hardware Clock updated to Tue May 21 03:09:01 MSK 2013.
(arm)root@pac14:~# /etc/init.d/hwclock.sh show
Tue May 21 11:14:15 2013  -0.624272 seconds

The patch enables write access to rtc before the driver tries to write
time and re-disables when time data is written.

Signed-off-by: Sergey Yanovich <ynvich@gmail.com>
Cc: Marc Zyngier <maz@misterjones.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1302.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/rtc/rtc-ds1302.c~drivers-rtc-rtc-ds1302c-handle-write-protection drivers/rtc/rtc-ds1302.c
--- a/drivers/rtc/rtc-ds1302.c~drivers-rtc-rtc-ds1302c-handle-write-protection
+++ a/drivers/rtc/rtc-ds1302.c
@@ -23,8 +23,12 @@
 #define	RTC_CMD_READ	0x81		/* Read command */
 #define	RTC_CMD_WRITE	0x80		/* Write command */
 
+#define	RTC_CMD_WRITE_ENABLE	0x00		/* Write enable */
+#define	RTC_CMD_WRITE_DISABLE	0x80		/* Write disable */
+
 #define RTC_ADDR_RAM0	0x20		/* Address of RAM0 */
 #define RTC_ADDR_TCR	0x08		/* Address of trickle charge register */
+#define	RTC_ADDR_CTRL	0x07		/* Address of control register */
 #define	RTC_ADDR_YEAR	0x06		/* Address of year register */
 #define	RTC_ADDR_DAY	0x05		/* Address of day of week register */
 #define	RTC_ADDR_MON	0x04		/* Address of month register */
@@ -161,6 +165,7 @@ static int ds1302_rtc_read_time(struct d
 
 static int ds1302_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
+	ds1302_writebyte(RTC_ADDR_CTRL, RTC_CMD_WRITE_ENABLE);
 	/* Stop RTC */
 	ds1302_writebyte(RTC_ADDR_SEC, ds1302_readbyte(RTC_ADDR_SEC) | 0x80);
 
@@ -175,6 +180,8 @@ static int ds1302_rtc_set_time(struct de
 	/* Start RTC */
 	ds1302_writebyte(RTC_ADDR_SEC, ds1302_readbyte(RTC_ADDR_SEC) & ~0x80);
 
+	ds1302_writebyte(RTC_ADDR_CTRL, RTC_CMD_WRITE_DISABLE);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from ynvich@gmail.com are

drivers-rtc-rtc-ds1302c-handle-write-protection.patch

