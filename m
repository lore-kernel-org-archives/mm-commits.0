From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ds1305c-add-missing-braces-around-sizeof.patch added to -mm tree
Date: Tue, 07 May 2013 15:39:02 -0700
Message-ID: <20130507223902.C6BBB5A4016@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:63792 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab3EGWjD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 18:39:03 -0400
Received: by mail-qe0-f74.google.com with SMTP id 1so121042qec.5
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 15:39:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, jg1.han@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-ds1305.c: add missing braces around sizeof
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1305c-add-missing-braces-around-sizeof.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-ds1305.c: add missing braces around sizeof

Silences the following type of warnings:
WARNING: sizeof buf should be sizeof(buf)

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1305.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN drivers/rtc/rtc-ds1305.c~drivers-rtc-rtc-ds1305c-add-missing-braces-around-sizeof drivers/rtc/rtc-ds1305.c
--- a/drivers/rtc/rtc-ds1305.c~drivers-rtc-rtc-ds1305c-add-missing-braces-around-sizeof
+++ a/drivers/rtc/rtc-ds1305.c
@@ -158,7 +158,7 @@ static int ds1305_alarm_irq_enable(struc
 			goto done;
 		buf[1] &= ~DS1305_AEI0;
 	}
-	err = spi_write_then_read(ds1305->spi, buf, sizeof buf, NULL, 0);
+	err = spi_write_then_read(ds1305->spi, buf, sizeof(buf), NULL, 0);
 	if (err >= 0)
 		ds1305->ctrl[0] = buf[1];
 done:
@@ -181,8 +181,8 @@ static int ds1305_get_time(struct device
 	/* Use write-then-read to get all the date/time registers
 	 * since dma from stack is nonportable
 	 */
-	status = spi_write_then_read(ds1305->spi, &addr, sizeof addr,
-			buf, sizeof buf);
+	status = spi_write_then_read(ds1305->spi, &addr, sizeof(addr),
+			buf, sizeof(buf));
 	if (status < 0)
 		return status;
 
@@ -237,7 +237,7 @@ static int ds1305_set_time(struct device
 		buf[4], buf[5], buf[6], buf[7]);
 
 	/* use write-then-read since dma from stack is nonportable */
-	return spi_write_then_read(ds1305->spi, buf, sizeof buf,
+	return spi_write_then_read(ds1305->spi, buf, sizeof(buf),
 			NULL, 0);
 }
 
@@ -286,8 +286,8 @@ static int ds1305_get_alarm(struct devic
 	 * of EFI status is at best fragile anyway (given IRQ handlers).
 	 */
 	addr = DS1305_CONTROL;
-	status = spi_write_then_read(spi, &addr, sizeof addr,
-			ds1305->ctrl, sizeof ds1305->ctrl);
+	status = spi_write_then_read(spi, &addr, sizeof(addr),
+			ds1305->ctrl, sizeof(ds1305->ctrl));
 	if (status < 0)
 		return status;
 
@@ -296,8 +296,8 @@ static int ds1305_get_alarm(struct devic
 
 	/* get and check ALM0 registers */
 	addr = DS1305_ALM0(DS1305_SEC);
-	status = spi_write_then_read(spi, &addr, sizeof addr,
-			buf, sizeof buf);
+	status = spi_write_then_read(spi, &addr, sizeof(addr),
+			buf, sizeof(buf));
 	if (status < 0)
 		return status;
 
@@ -381,7 +381,7 @@ static int ds1305_set_alarm(struct devic
 		"alm0 write", buf[1 + DS1305_SEC], buf[1 + DS1305_MIN],
 		buf[1 + DS1305_HOUR], buf[1 + DS1305_WDAY]);
 
-	status = spi_write_then_read(spi, buf, sizeof buf, NULL, 0);
+	status = spi_write_then_read(spi, buf, sizeof(buf), NULL, 0);
 	if (status < 0)
 		return status;
 
@@ -474,7 +474,7 @@ static void ds1305_work(struct work_stru
 	buf[1] = ds1305->ctrl[0];
 	buf[2] = 0;
 
-	status = spi_write_then_read(spi, buf, sizeof buf,
+	status = spi_write_then_read(spi, buf, sizeof(buf),
 			NULL, 0);
 	if (status < 0)
 		dev_dbg(&spi->dev, "clear irq --> %d\n", status);
@@ -627,8 +627,8 @@ static int ds1305_probe(struct spi_devic
 
 	/* read and cache control registers */
 	addr = DS1305_CONTROL;
-	status = spi_write_then_read(spi, &addr, sizeof addr,
-			ds1305->ctrl, sizeof ds1305->ctrl);
+	status = spi_write_then_read(spi, &addr, sizeof(addr),
+			ds1305->ctrl, sizeof(ds1305->ctrl));
 	if (status < 0) {
 		dev_dbg(&spi->dev, "can't %s, %d\n",
 				"read", status);
@@ -659,7 +659,7 @@ static int ds1305_probe(struct spi_devic
 
 		buf[0] = DS1305_WRITE | DS1305_CONTROL;
 		buf[1] = ds1305->ctrl[0];
-		status = spi_write_then_read(spi, buf, sizeof buf, NULL, 0);
+		status = spi_write_then_read(spi, buf, sizeof(buf), NULL, 0);
 
 		dev_dbg(&spi->dev, "clear WP --> %d\n", status);
 		if (status < 0)
@@ -713,7 +713,7 @@ static int ds1305_probe(struct spi_devic
 		buf[1] = ds1305->ctrl[0];
 		buf[2] = ds1305->ctrl[1];
 		buf[3] = ds1305->ctrl[2];
-		status = spi_write_then_read(spi, buf, sizeof buf, NULL, 0);
+		status = spi_write_then_read(spi, buf, sizeof(buf), NULL, 0);
 		if (status < 0) {
 			dev_dbg(&spi->dev, "can't %s, %d\n",
 					"write", status);
@@ -725,8 +725,8 @@ static int ds1305_probe(struct spi_devic
 
 	/* see if non-Linux software set up AM/PM mode */
 	addr = DS1305_HOUR;
-	status = spi_write_then_read(spi, &addr, sizeof addr,
-				&value, sizeof value);
+	status = spi_write_then_read(spi, &addr, sizeof(addr),
+				&value, sizeof(value));
 	if (status < 0) {
 		dev_dbg(&spi->dev, "read HOUR --> %d\n", status);
 		return status;
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
drivers-rtc-rtc-v3020c-remove-redundant-goto.patch
drivers-rtc-interfacec-fix-checkpatch-errors.patch
drivers-rtc-rtc-at32ap700xc-fix-checkpatch-error.patch
drivers-rtc-rtc-at91rm9200c-include-linux-uaccessh.patch
drivers-rtc-rtc-cmosc-fix-whitespace-related-errors.patch
drivers-rtc-rtc-davincic-fix-whitespace-warning.patch
drivers-rtc-rtc-ds1305c-add-missing-braces-around-sizeof.patch
drivers-rtc-rtc-ds1374c-fix-spacing-related-issues.patch
drivers-rtc-rtc-ds1511c-fix-issues-related-to-spaces-and-braces.patch
drivers-rtc-rtc-ds3234c-fix-whitespace-issue.patch
drivers-rtc-rtc-fm3130c-fix-whitespace-related-issue.patch
drivers-rtc-rtc-m41t80c-fix-spacing-related-issue.patch
drivers-rtc-rtc-max6902c-remove-unwanted-spaces.patch
drivers-rtc-rtc-max77686c-remove-space-before-semicolon.patch
drivers-rtc-rtc-max8997c-remove-space-before-semicolon.patch
drivers-rtc-rtc-mpc5121c-remove-space-before-tab.patch
drivers-rtc-rtc-msm6242c-use-pr_warn.patch
drivers-rtc-rtc-mxcc-fix-checkpatch-error.patch
drivers-rtc-rtc-omapc-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-pcf2123c-remove-space-before-tabs.patch
drivers-rtc-rtc-pcf8583c-move-assignment-outside-if-condition.patch
drivers-rtc-rtc-rs5c313c-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-rs5c313c-fix-spacing-related-issues.patch
drivers-rtc-rtc-v3020c-fix-spacing-issues.patch
drivers-rtc-rtc-vr41xxc-fix-spacing-issues.patch
drivers-rtc-rtc-x1205c-fix-checkpatch-issues.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch

