From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-ds3232c-fix-time-range-difference-between-linux-and-rtc-chip.patch removed from -mm tree
Date: Mon, 28 Feb 2011 13:10:47 -0800
Message-ID: <201102282110.p1SLAlcf029333__35920.3098262244$1298927504$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755186Ab1B1VLg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 16:11:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: B33228@freescale.com, a.zummo@towertech.it, jack.lan@freescale.com, johnstul@us.ibm.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-ds3232.c: fix time range difference between linux and RTC chip
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-ds3232c-fix-time-range-difference-between-linux-and-rtc-chip.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-ds3232.c: fix time range difference between linux and RTC chip
From: Lei Xu <B33228@freescale.com>

In linux rtc_time struct, tm_mon range is 0~11, tm_wday range is 0~6,
while in RTC HW REG, month range is 1~12, day of the week range is 1~7,
this patch adjusts difference of them.

The efect of this bug was that most of month will be operated on as the
next month by the hardware (When in Jan it maybe even worse).  For
example, if in May, software wrote 4 to the hardware, which handled it as
April.  Then the logic would be different between software and hardware,
which would cause weird things to happen.

Signed-off-by: Lei Xu <B33228@freescale.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Jack Lan <jack.lan@freescale.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds3232.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-ds3232.c~drivers-rtc-rtc-ds3232c-fix-time-range-difference-between-linux-and-rtc-chip drivers/rtc/rtc-ds3232.c
--- a/drivers/rtc/rtc-ds3232.c~drivers-rtc-rtc-ds3232c-fix-time-range-difference-between-linux-and-rtc-chip
+++ a/drivers/rtc/rtc-ds3232.c
@@ -1,7 +1,7 @@
 /*
  * RTC client/driver for the Maxim/Dallas DS3232 Real-Time Clock over I2C
  *
- * Copyright (C) 2009-2010 Freescale Semiconductor.
+ * Copyright (C) 2009-2011 Freescale Semiconductor.
  * Author: Jack Lan <jack.lan@freescale.com>
  *
  * This program is free software; you can redistribute  it and/or modify it
@@ -141,9 +141,11 @@ static int ds3232_read_time(struct devic
 		time->tm_hour = bcd2bin(hour);
 	}
 
-	time->tm_wday = bcd2bin(week);
+	/* Day of the week in linux range is 0~6 while 1~7 in RTC chip */
+	time->tm_wday = bcd2bin(week) - 1;
 	time->tm_mday = bcd2bin(day);
-	time->tm_mon = bcd2bin(month & 0x7F);
+	/* linux tm_mon range:0~11, while month range is 1~12 in RTC chip */
+	time->tm_mon = bcd2bin(month & 0x7F) - 1;
 	if (century)
 		add_century = 100;
 
@@ -162,9 +164,11 @@ static int ds3232_set_time(struct device
 	buf[0] = bin2bcd(time->tm_sec);
 	buf[1] = bin2bcd(time->tm_min);
 	buf[2] = bin2bcd(time->tm_hour);
-	buf[3] = bin2bcd(time->tm_wday); /* Day of the week */
+	/* Day of the week in linux range is 0~6 while 1~7 in RTC chip */
+	buf[3] = bin2bcd(time->tm_wday + 1);
 	buf[4] = bin2bcd(time->tm_mday); /* Date */
-	buf[5] = bin2bcd(time->tm_mon);
+	/* linux tm_mon range:0~11, while month range is 1~12 in RTC chip */
+	buf[5] = bin2bcd(time->tm_mon + 1);
 	if (time->tm_year >= 100) {
 		buf[5] |= 0x80;
 		buf[6] = bin2bcd(time->tm_year - 100);
_

Patches currently in -mm which might be from B33228@freescale.com are

origin.patch

