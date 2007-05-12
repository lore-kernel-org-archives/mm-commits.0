From: akpm@linux-foundation.org
Subject: - rtc-rs5c313c-add-error-handling-to-avoid-hardware-hangup.patch removed from -mm tree
Date: Fri, 11 May 2007 22:34:22 -0700
Message-ID: <200705120534.l4C5YM3n002195@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755254AbXELFe2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:34:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kogiidena@eggplant.ddo.jp, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc-rs5c313.c: add error handling to avoid hardware hangup
has been removed from the -mm tree.  Its filename was
     rtc-rs5c313c-add-error-handling-to-avoid-hardware-hangup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc-rs5c313.c: add error handling to avoid hardware hangup
From: "kogiidena" <kogiidena@eggplant.ddo.jp>

Add error processing.  Hanging up by an infinite loop is evaded.

Signed-off-by: kogiidena <kogiidena@eggplant.ddo.jp>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rs5c313.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-rs5c313.c~rtc-rs5c313c-add-error-handling-to-avoid-hardware-hangup drivers/rtc/rtc-rs5c313.c
--- a/drivers/rtc/rtc-rs5c313.c~rtc-rs5c313c-add-error-handling-to-avoid-hardware-hangup
+++ a/drivers/rtc/rtc-rs5c313.c
@@ -212,7 +212,9 @@ static inline void rs5c313_write_intintv
 static int rs5c313_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	int data;
+	int cnt;
 
+	cnt = 0;
 	while (1) {
 		RS5C313_CEENABLE;	/* CE:H */
 
@@ -225,6 +227,10 @@ static int rs5c313_rtc_read_time(struct 
 		RS5C313_CEDISABLE;
 		ndelay(700);	/* CE:L */
 
+		if (cnt++ > 100) {
+			dev_err(dev, "%s: timeout error\n", __FUNCTION__);
+			return -EIO;
+		}
 	}
 
 	data = rs5c313_read_reg(RS5C313_ADDR_SEC);
@@ -266,7 +272,9 @@ static int rs5c313_rtc_read_time(struct 
 static int rs5c313_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	int data;
+	int cnt;
 
+	cnt = 0;
 	/* busy check. */
 	while (1) {
 		RS5C313_CEENABLE;	/* CE:H */
@@ -279,6 +287,11 @@ static int rs5c313_rtc_set_time(struct d
 		RS5C313_MISCOP;
 		RS5C313_CEDISABLE;
 		ndelay(700);	/* CE:L */
+
+		if (cnt++ > 100) {
+			dev_err(dev, "%s: timeout error\n", __FUNCTION__);
+			return -EIO;
+		}
 	}
 
 	data = BIN2BCD(tm->tm_sec);
@@ -317,6 +330,7 @@ static int rs5c313_rtc_set_time(struct d
 static void rs5c313_check_xstp_bit(void)
 {
 	struct rtc_time tm;
+	int cnt;
 
 	RS5C313_CEENABLE;	/* CE:H */
 	if (rs5c313_read_cntreg() & RS5C313_CNTREG_WTEN_XSTP) {
@@ -326,8 +340,11 @@ static void rs5c313_check_xstp_bit(void)
 		rs5c313_write_cntreg(0x07);
 
 		/* busy check. */
-		while (rs5c313_read_cntreg() & RS5C313_CNTREG_ADJ_BSY)
+		for (cnt = 0; cnt < 100; cnt++) {
+			if (!(rs5c313_read_cntreg() & RS5C313_CNTREG_ADJ_BSY))
+				break;
 			RS5C313_MISCOP;
+		}
 
 		memset(&tm, 0, sizeof(struct rtc_time));
 		tm.tm_mday 	= 1;
_

Patches currently in -mm which might be from kogiidena@eggplant.ddo.jp are

origin.patch
