From: akpm@linux-foundation.org
Subject: - i2c-use-bcd2bin-bin2bcd.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:37:56 -0700
Message-ID: <200810202037.m9KKbu9N011749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754522AbYJTUqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     i2c: use bcd2bin/bin2bcd
has been removed from the -mm tree.  Its filename was
     i2c-use-bcd2bin-bin2bcd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i2c: use bcd2bin/bin2bcd
From: Adrian Bunk <bunk@kernel.org>

Change i2c to use the new bcd2bin/bin2bcd functions instead of the
obsolete BCD2BIN/BIN2BCD macros.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/chips/menelaus.c |   34 ++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN drivers/i2c/chips/menelaus.c~i2c-use-bcd2bin-bin2bcd drivers/i2c/chips/menelaus.c
--- a/drivers/i2c/chips/menelaus.c~i2c-use-bcd2bin-bin2bcd
+++ a/drivers/i2c/chips/menelaus.c
@@ -832,52 +832,52 @@ static irqreturn_t menelaus_irq(int irq,
 
 static void menelaus_to_time(char *regs, struct rtc_time *t)
 {
-	t->tm_sec = BCD2BIN(regs[0]);
-	t->tm_min = BCD2BIN(regs[1]);
+	t->tm_sec = bcd2bin(regs[0]);
+	t->tm_min = bcd2bin(regs[1]);
 	if (the_menelaus->rtc_control & RTC_CTRL_MODE12) {
-		t->tm_hour = BCD2BIN(regs[2] & 0x1f) - 1;
+		t->tm_hour = bcd2bin(regs[2] & 0x1f) - 1;
 		if (regs[2] & RTC_HR_PM)
 			t->tm_hour += 12;
 	} else
-		t->tm_hour = BCD2BIN(regs[2] & 0x3f);
-	t->tm_mday = BCD2BIN(regs[3]);
-	t->tm_mon = BCD2BIN(regs[4]) - 1;
-	t->tm_year = BCD2BIN(regs[5]) + 100;
+		t->tm_hour = bcd2bin(regs[2] & 0x3f);
+	t->tm_mday = bcd2bin(regs[3]);
+	t->tm_mon = bcd2bin(regs[4]) - 1;
+	t->tm_year = bcd2bin(regs[5]) + 100;
 }
 
 static int time_to_menelaus(struct rtc_time *t, int regnum)
 {
 	int	hour, status;
 
-	status = menelaus_write_reg(regnum++, BIN2BCD(t->tm_sec));
+	status = menelaus_write_reg(regnum++, bin2bcd(t->tm_sec));
 	if (status < 0)
 		goto fail;
 
-	status = menelaus_write_reg(regnum++, BIN2BCD(t->tm_min));
+	status = menelaus_write_reg(regnum++, bin2bcd(t->tm_min));
 	if (status < 0)
 		goto fail;
 
 	if (the_menelaus->rtc_control & RTC_CTRL_MODE12) {
 		hour = t->tm_hour + 1;
 		if (hour > 12)
-			hour = RTC_HR_PM | BIN2BCD(hour - 12);
+			hour = RTC_HR_PM | bin2bcd(hour - 12);
 		else
-			hour = BIN2BCD(hour);
+			hour = bin2bcd(hour);
 	} else
-		hour = BIN2BCD(t->tm_hour);
+		hour = bin2bcd(t->tm_hour);
 	status = menelaus_write_reg(regnum++, hour);
 	if (status < 0)
 		goto fail;
 
-	status = menelaus_write_reg(regnum++, BIN2BCD(t->tm_mday));
+	status = menelaus_write_reg(regnum++, bin2bcd(t->tm_mday));
 	if (status < 0)
 		goto fail;
 
-	status = menelaus_write_reg(regnum++, BIN2BCD(t->tm_mon + 1));
+	status = menelaus_write_reg(regnum++, bin2bcd(t->tm_mon + 1));
 	if (status < 0)
 		goto fail;
 
-	status = menelaus_write_reg(regnum++, BIN2BCD(t->tm_year - 100));
+	status = menelaus_write_reg(regnum++, bin2bcd(t->tm_year - 100));
 	if (status < 0)
 		goto fail;
 
@@ -914,7 +914,7 @@ static int menelaus_read_time(struct dev
 	}
 
 	menelaus_to_time(regs, t);
-	t->tm_wday = BCD2BIN(regs[6]);
+	t->tm_wday = bcd2bin(regs[6]);
 
 	return 0;
 }
@@ -927,7 +927,7 @@ static int menelaus_set_time(struct devi
 	status = time_to_menelaus(t, MENELAUS_RTC_SEC);
 	if (status < 0)
 		return status;
-	status = menelaus_write_reg(MENELAUS_RTC_WKDAY, BIN2BCD(t->tm_wday));
+	status = menelaus_write_reg(MENELAUS_RTC_WKDAY, bin2bcd(t->tm_wday));
 	if (status < 0) {
 		dev_err(&the_menelaus->client->dev, "rtc write reg %02x "
 				"err %d\n", MENELAUS_RTC_WKDAY, status);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-kernel-smpbootc-must-include-linux-cpuh.patch
the-overdue-eepro100-removal.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
reiser4.patch

