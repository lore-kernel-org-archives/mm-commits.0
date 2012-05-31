From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-m41t93c-dont-let-get_time-reset-error-state.patch removed from -mm tree
Date: Thu, 31 May 2012 12:20:36 -0700
Message-ID: <20120531192036.6EF90A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:54968 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125Ab2EaTUj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:20:39 -0400
Received: by bkty5 with SMTP id y5so75606bkt.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:20:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n.voss@weinmann.de, a.zummo@towertech.it, grant.likely@secretlab.ca, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-m41t93.c: don't let get_time() reset M41T93_FLAG_OF
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-m41t93c-dont-let-get_time-reset-error-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
