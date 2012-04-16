From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-r9701c-reset-registers-if-invalid-values-are-detected.patch removed from -mm tree
Date: Mon, 16 Apr 2012 13:15:24 -0700
Message-ID: <20120416201524.72A05A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:41089 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab2DPUPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 16:15:25 -0400
Received: by mail-yx0-f202.google.com with SMTP id q2so644423yen.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 13:15:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.dumberger@tqs.de, a.zummo@towertech.it, agust@denx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-r9701.c: reset registers if invalid values are detected
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-r9701c-reset-registers-if-invalid-values-are-detected.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andreas Dumberger <andreas.dumberger@tqs.de>
Subject: drivers/rtc/rtc-r9701.c: reset registers if invalid values are detected

hwclock refuses to set date/time if RTC registers contain invalid values. 
Check the date/time register values at probe time and initialize them to
make hwclock happy.

Signed-off-by: Andreas Dumberger <andreas.dumberger@tqs.de>
Signed-off-by: Anatolij Gustschin <agust@denx.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-r9701.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN drivers/rtc/rtc-r9701.c~drivers-rtc-rtc-r9701c-reset-registers-if-invalid-values-are-detected drivers/rtc/rtc-r9701.c
--- a/drivers/rtc/rtc-r9701.c~drivers-rtc-rtc-r9701c-reset-registers-if-invalid-values-are-detected
+++ a/drivers/rtc/rtc-r9701.c
@@ -122,6 +122,7 @@ static const struct rtc_class_ops r9701_
 static int __devinit r9701_probe(struct spi_device *spi)
 {
 	struct rtc_device *rtc;
+	struct rtc_time dt;
 	unsigned char tmp;
 	int res;
 
@@ -132,6 +133,27 @@ static int __devinit r9701_probe(struct 
 		return -ENODEV;
 	}
 
+	/*
+	 * The device seems to be present. Now check if the registers
+	 * contain invalid values. If so, try to write a default date:
+	 * 2000/1/1 00:00:00
+	 */
+	r9701_get_datetime(&spi->dev, &dt);
+	if (rtc_valid_tm(&dt)) {
+		dev_info(&spi->dev, "trying to repair invalid date/time\n");
+		dt.tm_sec  = 0;
+		dt.tm_min  = 0;
+		dt.tm_hour = 0;
+		dt.tm_mday = 1;
+		dt.tm_mon  = 0;
+		dt.tm_year = 100;
+
+		if (r9701_set_datetime(&spi->dev, &dt)) {
+			dev_err(&spi->dev, "cannot repair RTC register\n");
+			return -ENODEV;
+		}
+	}
+
 	rtc = rtc_device_register("r9701",
 				&spi->dev, &r9701_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
_

Patches currently in -mm which might be from andreas.dumberger@tqs.de are


