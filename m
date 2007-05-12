From: akpm@linux-foundation.org
Subject: - rtc-rs5c313c-error-and-warning-are-fixed.patch removed from -mm tree
Date: Fri, 11 May 2007 22:34:15 -0700
Message-ID: <200705120534.l4C5YFon002189@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755254AbXELFe1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:34:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kogiidena@eggplant.ddo.jp, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc-rs5c313.c: error and warning are fixed
has been removed from the -mm tree.  Its filename was
     rtc-rs5c313c-error-and-warning-are-fixed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc-rs5c313.c: error and warning are fixed
From: "kogiidena" <kogiidena@eggplant.ddo.jp>

Correct a compile error and warning.

Signed-off-by: kogiidena <kogiidena@eggplant.ddo.jp>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig       |    2 +-
 drivers/rtc/rtc-rs5c313.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-rs5c313c-error-and-warning-are-fixed drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-rs5c313c-error-and-warning-are-fixed
+++ a/drivers/rtc/Kconfig
@@ -397,7 +397,7 @@ config RTC_DRV_BFIN
 
 config RTC_DRV_RS5C313
 	tristate "Ricoh RS5C313"
-	depends on RTC_CLASS && BROKEN
+	depends on RTC_CLASS && SH_LANDISK
 	help
 	  If you say yes here you get support for the Ricoh RS5C313 RTC chips.
 
diff -puN drivers/rtc/rtc-rs5c313.c~rtc-rs5c313c-error-and-warning-are-fixed drivers/rtc/rtc-rs5c313.c
--- a/drivers/rtc/rtc-rs5c313.c~rtc-rs5c313c-error-and-warning-are-fixed
+++ a/drivers/rtc/rtc-rs5c313.c
@@ -126,7 +126,7 @@ static void rs5c313_write_data(unsigned 
 static unsigned char rs5c313_read_data(void)
 {
 	int i;
-	unsigned char data;
+	unsigned char data = 0;
 
 	for (i = 0; i < 8; i++) {
 		ndelay(700);
@@ -194,7 +194,7 @@ static void rs5c313_write_reg(unsigned c
 	return;
 }
 
-static inline unsigned char rs5c313_read_cntreg(unsigned char addr)
+static inline unsigned char rs5c313_read_cntreg(void)
 {
 	return rs5c313_read_reg(RS5C313_ADDR_CNTREG);
 }
@@ -356,7 +356,7 @@ static int rs5c313_rtc_probe(struct plat
 
 	platform_set_drvdata(pdev, rtc);
 
-	return err;
+	return 0;
 }
 
 static int __devexit rs5c313_rtc_remove(struct platform_device *pdev)
_

Patches currently in -mm which might be from kogiidena@eggplant.ddo.jp are

origin.patch
