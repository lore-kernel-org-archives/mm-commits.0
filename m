From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-r9701c-reset-registers-if-invalid-values-are-detected.patch added to -mm tree
Date: Thu, 05 Apr 2012 16:31:05 -0700
Message-ID: <20120405233105.C98DCA03CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:56246 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab2DEXbI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Apr 2012 19:31:08 -0400
Received: by bkcjm19 with SMTP id jm19so95313bkc.1
        for <mm-commits@vger.kernel.org>; Thu, 05 Apr 2012 16:31:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andreas.dumberger@tqs.de, a.zummo@towertech.it, agust@denx.de


The patch titled
     Subject: drivers/rtc/rtc-r9701.c: reset registers if invalid values are detected
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-r9701c-reset-registers-if-invalid-values-are-detected.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drivers/rtc/rtc-r9701.c: reset registers if invalid values are detected

Patches currently in -mm which might be from andreas.dumberger@tqs.de are

drivers-rtc-rtc-r9701c-reset-registers-if-invalid-values-are-detected.patch

