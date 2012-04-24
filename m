From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-m41t93c-dont-let-get_time-reset-error-state.patch added to -mm tree
Date: Tue, 24 Apr 2012 14:11:40 -0700
Message-ID: <20120424211140.767CFA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:39228 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650Ab2DXVLs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Apr 2012 17:11:48 -0400
Received: by eekc41 with SMTP id c41so15147eek.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Apr 2012 14:11:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n.voss@weinmann.de, a.zummo@towertech.it, grant.likely@secretlab.ca


The patch titled
     Subject: drivers/rtc/rtc-m41t93.c: don't let get_time() reset M41T93_FLAG_OF
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-m41t93c-dont-let-get_time-reset-error-state.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nikolaus Voss <n.voss@weinmann.de>
Subject: drivers/rtc/rtc-m41t93.c: don't let get_time() reset M41T93_FLAG_OF

If the rtc reports the time might be invalid due to oscillator failure,
M41T93_FLAG_OF flag must not be reset by get_time() as the read operation
doesn't make the time valid.

Without this patch, only the first get_time() reported an invalid time,
the second get_time() reported a valid time althought the reported time is
probably wrong due to oscillator failure.

Instead of resetting in get_time(), with this patch M41T93_FLAG_OF is
reset in set_time() when a valid time is to be written.

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m41t93.c |   46 +++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff -puN drivers/rtc/rtc-m41t93.c~drivers-rtc-rtc-m41t93c-dont-let-get_time-reset-error-state drivers/rtc/rtc-m41t93.c
--- a/drivers/rtc/rtc-m41t93.c~drivers-rtc-rtc-m41t93c-dont-let-get_time-reset-error-state
+++ a/drivers/rtc/rtc-m41t93.c
@@ -48,6 +48,7 @@ static inline int m41t93_set_reg(struct 
 static int m41t93_set_time(struct device *dev, struct rtc_time *tm)
 {
 	struct spi_device *spi = to_spi_device(dev);
+	int tmp;
 	u8 buf[9] = {0x80};        /* write cmd + 8 data bytes */
 	u8 * const data = &buf[1]; /* ptr to first data byte */
 
@@ -62,6 +63,30 @@ static int m41t93_set_time(struct device
 		return -EINVAL;
 	}
 
+	tmp = spi_w8r8(spi, M41T93_REG_FLAGS);
+	if (tmp < 0)
+		return tmp;
+
+	if (tmp & M41T93_FLAG_OF) {
+		dev_warn(&spi->dev, "OF bit is set, resetting.\n");
+		m41t93_set_reg(spi, M41T93_REG_FLAGS, tmp & ~M41T93_FLAG_OF);
+
+		tmp = spi_w8r8(spi, M41T93_REG_FLAGS);
+		if (tmp < 0) {
+			return tmp;
+		} else if (tmp & M41T93_FLAG_OF) {
+			/* OF cannot be immediately reset: oscillator has to be
+			 * restarted. */
+			u8 reset_osc = buf[M41T93_REG_ST_SEC] | M41T93_FLAG_ST;
+
+			dev_warn(&spi->dev,
+				 "OF bit is still set, kickstarting clock.\n");
+			m41t93_set_reg(spi, M41T93_REG_ST_SEC, reset_osc);
+			reset_osc &= ~M41T93_FLAG_ST;
+			m41t93_set_reg(spi, M41T93_REG_ST_SEC, reset_osc);
+		}
+	}
+
 	data[M41T93_REG_SSEC]		= 0;
 	data[M41T93_REG_ST_SEC]		= bin2bcd(tm->tm_sec);
 	data[M41T93_REG_MIN]		= bin2bcd(tm->tm_min);
@@ -89,10 +114,7 @@ static int m41t93_get_time(struct device
 	   1. halt bit (HT) is set: the clock is running but update of readout
 	      registers has been disabled due to power failure. This is normal
 	      case after poweron. Time is valid after resetting HT bit.
-	   2. oscillator fail bit (OF) is set. Oscillator has be stopped and
-	      time is invalid:
-	      a) OF can be immeditely reset.
-	      b) OF cannot be immediately reset: oscillator has to be restarted.
+	   2. oscillator fail bit (OF) is set: time is invalid.
 	*/
 	tmp = spi_w8r8(spi, M41T93_REG_ALM_HOUR_HT);
 	if (tmp < 0)
@@ -110,21 +132,7 @@ static int m41t93_get_time(struct device
 
 	if (tmp & M41T93_FLAG_OF) {
 		ret = -EINVAL;
-		dev_warn(&spi->dev, "OF bit is set, resetting.\n");
-		m41t93_set_reg(spi, M41T93_REG_FLAGS, tmp & ~M41T93_FLAG_OF);
-
-		tmp = spi_w8r8(spi, M41T93_REG_FLAGS);
-		if (tmp < 0)
-			return tmp;
-		else if (tmp & M41T93_FLAG_OF) {
-			u8 reset_osc = buf[M41T93_REG_ST_SEC] | M41T93_FLAG_ST;
