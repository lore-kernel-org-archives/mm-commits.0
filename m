From: akpm@linux-foundation.org
Subject: + rtc-v3020-fixes.patch added to -mm tree
Date: Mon, 10 Sep 2007 01:00:48 -0700
Message-ID: <200709100800.l8A80mVt014491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52805 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755306AbXIJIBY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 04:01:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike@compulab.co.il, a.zummo@towertech.it, david-b@pacbell.net, raph@8d.com


The patch titled
     RTC v3020 fixes
has been added to the -mm tree.  Its filename is
     rtc-v3020-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: RTC v3020 fixes
From: Mike Rapoport <mike@compulab.co.il>

Fix off-by-one in month calculations
Add delay for bus accesses to satisfy Tw > 500ns

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Acked-by: Raphael Assenat <raph@8d.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-v3020.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-v3020.c~rtc-v3020-fixes drivers/rtc/rtc-v3020.c
--- a/drivers/rtc/rtc-v3020.c~rtc-v3020-fixes
+++ a/drivers/rtc/rtc-v3020.c
@@ -26,6 +26,7 @@
 #include <linux/types.h>
 #include <linux/bcd.h>
 #include <linux/rtc-v3020.h>
+#include <linux/delay.h>
 
 #include <asm/io.h>
 
@@ -47,6 +48,7 @@ static void v3020_set_reg(struct v3020 *
 	for (i = 0; i < 4; i++) {
 		writel((tmp & 1) << chip->leftshift, chip->ioaddress);
 		tmp >>= 1;
+		udelay(1);
 	}
 
 	/* Commands dont have data */
@@ -54,6 +56,7 @@ static void v3020_set_reg(struct v3020 *
 		for (i = 0; i < 8; i++) {
 			writel((data & 1) << chip->leftshift, chip->ioaddress);
 			data >>= 1;
+			udelay(1);
 		}
 	}
 }
@@ -66,12 +69,14 @@ static unsigned char v3020_get_reg(struc
 	for (i = 0; i < 4; i++) {
 		writel((address & 1) << chip->leftshift, chip->ioaddress);
 		address >>= 1;
+		udelay(1);
 	}
 
 	for (i = 0; i < 8; i++) {
 		data >>= 1;
 		if (readl(chip->ioaddress) & (1 << chip->leftshift))
 			data |= 0x80;
+		udelay(1);
 	}
 
 	return data;
@@ -95,7 +100,7 @@ static int v3020_read_time(struct device
 	tmp = v3020_get_reg(chip, V3020_MONTH_DAY);
 	dt->tm_mday	= BCD2BIN(tmp);
 	tmp = v3020_get_reg(chip, V3020_MONTH);
-	dt->tm_mon	= BCD2BIN(tmp);
+	dt->tm_mon    = BCD2BIN(tmp) - 1;
 	tmp = v3020_get_reg(chip, V3020_WEEK_DAY);
 	dt->tm_wday	= BCD2BIN(tmp);
 	tmp = v3020_get_reg(chip, V3020_YEAR);
@@ -135,7 +140,7 @@ static int v3020_set_time(struct device 
 	v3020_set_reg(chip, V3020_MINUTES, 	BIN2BCD(dt->tm_min));
 	v3020_set_reg(chip, V3020_HOURS, 	BIN2BCD(dt->tm_hour));
 	v3020_set_reg(chip, V3020_MONTH_DAY,	BIN2BCD(dt->tm_mday));
-	v3020_set_reg(chip, V3020_MONTH, 	BIN2BCD(dt->tm_mon));
+	v3020_set_reg(chip, V3020_MONTH,     BIN2BCD(dt->tm_mon + 1));
 	v3020_set_reg(chip, V3020_WEEK_DAY, 	BIN2BCD(dt->tm_wday));
 	v3020_set_reg(chip, V3020_YEAR, 	BIN2BCD(dt->tm_year % 100));
 
_

Patches currently in -mm which might be from mike@compulab.co.il are

rtc-v3020-fixes.patch
make-power-supply-class-available-for-arm-architecture.patch
