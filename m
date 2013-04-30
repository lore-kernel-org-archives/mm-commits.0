From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-max6902c-use-register-defines-instead-of-magic-numbers.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:01:06 -0700
Message-ID: <20130430190106.7EEA831C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:44960 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933593Ab3D3TBH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:01:07 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so87199yhz.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:01:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@ingics.com, a.zummo@towertech.it, fengguang.wu@intel.com, raph@raphnet.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-max6902.c: use register defines instead of magic numbers
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-max6902c-use-register-defines-instead-of-magic-numbers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Axel Lin <axel.lin@ingics.com>
Subject: drivers/rtc/rtc-max6902.c: use register defines instead of magic numbers

Current code has defines for registers, use the defines rather than magic
numbers.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Cc: Raphael Assenat <raph@raphnet.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max6902.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-max6902.c~drivers-rtc-rtc-max6902c-use-register-defines-instead-of-magic-numbers drivers/rtc/rtc-max6902.c
--- a/drivers/rtc/rtc-max6902.c~drivers-rtc-rtc-max6902c-use-register-defines-instead-of-magic-numbers
+++ a/drivers/rtc/rtc-max6902.c
@@ -93,24 +93,24 @@ static int max6902_set_time(struct devic
 	dt->tm_year = dt->tm_year + 1900;
 
 	/* Remove write protection */
-	max6902_set_reg(dev, 0xF, 0);
+	max6902_set_reg(dev, MAX6902_REG_CONTROL, 0);
 
-	max6902_set_reg(dev, 0x01, bin2bcd(dt->tm_sec));
-	max6902_set_reg(dev, 0x03, bin2bcd(dt->tm_min));
-	max6902_set_reg(dev, 0x05, bin2bcd(dt->tm_hour));
-
-	max6902_set_reg(dev, 0x07, bin2bcd(dt->tm_mday));
-	max6902_set_reg(dev, 0x09, bin2bcd(dt->tm_mon + 1));
-	max6902_set_reg(dev, 0x0B, bin2bcd(dt->tm_wday));
-	max6902_set_reg(dev, 0x0D, bin2bcd(dt->tm_year % 100));
-	max6902_set_reg(dev, 0x13, bin2bcd(dt->tm_year / 100));
+	max6902_set_reg(dev, MAX6902_REG_SECONDS, bin2bcd(dt->tm_sec));
+	max6902_set_reg(dev, MAX6902_REG_MINUTES, bin2bcd(dt->tm_min));
+	max6902_set_reg(dev, MAX6902_REG_HOURS, bin2bcd(dt->tm_hour));
+
+	max6902_set_reg(dev, MAX6902_REG_DATE, bin2bcd(dt->tm_mday));
+	max6902_set_reg(dev, MAX6902_REG_MONTH, bin2bcd(dt->tm_mon + 1));
+	max6902_set_reg(dev, MAX6902_REG_DAY, bin2bcd(dt->tm_wday));
+	max6902_set_reg(dev, MAX6902_REG_YEAR, bin2bcd(dt->tm_year % 100));
+	max6902_set_reg(dev, MAX6902_REG_CENTURY, bin2bcd(dt->tm_year / 100));
 
 	/* Compulab used a delay here. However, the datasheet
 	 * does not mention a delay being required anywhere... */
 	/* delay(2000); */
 
 	/* Write protect */
-	max6902_set_reg(dev, 0xF, 0x80);
+	max6902_set_reg(dev, MAX6902_REG_CONTROL, 0x80);
 
 	return 0;
 }
_

Patches currently in -mm which might be from axel.lin@ingics.com are

origin.patch
linux-next.patch

