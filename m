From: akpm@linux-foundation.org
Subject: - rtc-m41t80-century-bit-support.patch removed from -mm tree
Date: Tue, 20 May 2008 13:03:22 -0700
Message-ID: <200805202003.m4KK3Mae008765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759108AbYETUEP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 16:04:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, a.zummo@towertech.it, anemo@mba.ocn.ne.jp, david-b@pacbell.net, hvr@gnu.org, mm-commits@vger.kernel.org


The patch titled
     rtc: m41t80: cenutury bit support
has been removed from the -mm tree.  Its filename was
     rtc-m41t80-century-bit-support.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: m41t80: cenutury bit support
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Make use of the Century Bit to support years in the range from 1970 to
2169.  Enable toggling of the bit at the end of a century on a clock
update.

The clock is used with the Broadcom SWARM and the D-Link DNS-323 platform.

I have verified correct operation with the SWARM -- the firmware assumes
19YY when CB is clear and 20YY otherwise.  Which means years 1900-1969
will be shown as 2100-2169 in Linux.  I think this is a feature rather
than a problem.  The firmware does not set the CEB bit itself and does not
care of what its state is.

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Herbert Valerio Riedel <hvr@gnu.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: "Maciej W. Rozycki" <macro@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m41t80.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-m41t80.c~rtc-m41t80-century-bit-support drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~rtc-m41t80-century-bit-support
+++ a/drivers/rtc/rtc-m41t80.c
@@ -50,6 +50,8 @@
 	(M41T80_REG_ALARM_SEC + 1 - M41T80_REG_ALARM_MON)
 
 #define M41T80_SEC_ST		(1 << 7)	/* ST: Stop Bit */
+#define M41T80_HOUR_CEB		(1 << 7)	/* CEB: Century Enable Bit */
+#define M41T80_HOUR_CB		(1 << 6)	/* CB: Century Bit */
 #define M41T80_ALMON_AFE	(1 << 7)	/* AFE: AF Enable Bit */
 #define M41T80_ALMON_SQWE	(1 << 6)	/* SQWE: SQW Enable Bit */
 #define M41T80_ALHOUR_HT	(1 << 6)	/* HT: Halt Update Bit */
@@ -110,8 +112,12 @@ static int m41t80_get_datetime(struct i2
 	tm->tm_wday = buf[M41T80_REG_WDAY] & 0x07;
 	tm->tm_mon = BCD2BIN(buf[M41T80_REG_MON] & 0x1f) - 1;
 
-	/* assume 20YY not 19YY, and ignore the Century Bit */
-	tm->tm_year = BCD2BIN(buf[M41T80_REG_YEAR]) + 100;
+	/* Assume 1970-2169, taking the Century Bit into account. */
+	tm->tm_year = BCD2BIN(buf[M41T80_REG_YEAR]);
+	if ((buf[M41T80_REG_HOUR] & M41T80_HOUR_CB) != 0)
+		tm->tm_year += 100;
+	if (tm->tm_year < 70)
+		tm->tm_year += 200;
 	return 0;
 }
 
@@ -165,8 +171,14 @@ static int m41t80_set_datetime(struct i2
 		BIN2BCD(tm->tm_mday) | (buf[M41T80_REG_DAY] & ~0x3f);
 	buf[M41T80_REG_MON] =
 		BIN2BCD(tm->tm_mon + 1) | (buf[M41T80_REG_MON] & ~0x1f);
-	/* assume 20YY not 19YY */
+	/* Assume 1970-2169 and set the Century Bit for 19YY/21YY. */
 	buf[M41T80_REG_YEAR] = BIN2BCD(tm->tm_year % 100);
+	if ((tm->tm_year / 100) % 2 != 0)
+		buf[M41T80_REG_HOUR] |= M41T80_HOUR_CB;
+	else
+		buf[M41T80_REG_HOUR] &= ~M41T80_HOUR_CB;
+	/* Enable toggling of the Century Bit at the end of a century. ;-) */
+	buf[M41T80_REG_HOUR] |= M41T80_HOUR_CEB;
 
 	if (i2c_transfer(client->adapter, msgs, 1) != 1) {
 		dev_err(&client->dev, "write error\n");
_

Patches currently in -mm which might be from macro@linux-mips.org are

ntp-make-the-rtc-sync-mode-11-minute-again.patch
ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync.patch
rtc-m41t80-sort-header-inclusions-for-readability.patch
rtc-m41t80-use-pr_info-as-appropriate.patch
rtc-m41t80-century-bit-support.patch

