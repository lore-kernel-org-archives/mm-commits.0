From: akpm@linux-foundation.org
Subject: + rtc-add-nxp-pcf8523-support-v2.patch added to -mm tree
Date: Wed, 28 Nov 2012 15:34:52 -0800
Message-ID: <20121128233458.81DDA20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:44145 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab2K1XfA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Nov 2012 18:35:00 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so724683fae.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Nov 2012 15:34:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thierry.reding@avionic-design.de, a.zummo@towertech.it


The patch titled
     Subject: rtc-add-nxp-pcf8523-support-v2
has been added to the -mm tree.  Its filename is
     rtc-add-nxp-pcf8523-support-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thierry Reding <thierry.reding@avionic-design.de>
Subject: rtc-add-nxp-pcf8523-support-v2

Changes in v2:
- return an error if the OS flag cannot be cleared
- add comment as to why we clear the OS flag
- restart RTC if setting the time fails

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8523.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-pcf8523.c~rtc-add-nxp-pcf8523-support-v2 drivers/rtc/rtc-pcf8523.c
--- a/drivers/rtc/rtc-pcf8523.c~rtc-add-nxp-pcf8523-support-v2
+++ a/drivers/rtc/rtc-pcf8523.c
@@ -178,14 +178,26 @@ static int pcf8523_rtc_read_time(struct 
 		return err;
 
 	if (regs[0] & REG_SECONDS_OS) {
-		dev_dbg(dev, "clock integrity is not guaranteed\n");
+		/*
+		 * If the oscillator was stopped, try to clear the flag. Upon
+		 * power-up the flag is always set, but if we cannot clear it
+		 * the oscillator isn't running properly for some reason. The
+		 * sensible thing therefore is to return an error, signalling
+		 * that the clock cannot be assumed to be correct.
+		 */
 
-		/* try to clear the flag */
 		regs[0] &= ~REG_SECONDS_OS;
 
 		err = pcf8523_write(client, REG_SECONDS, regs[0]);
 		if (err < 0)
 			return err;
+
+		err = pcf8523_read(client, REG_SECONDS, &regs[0]);
+		if (err < 0)
+			return err;
+
+		if (regs[0] & REG_SECONDS_OS)
+			return -EAGAIN;
 	}
 
 	tm->tm_sec = bcd2bin(regs[0] & 0x7f);
@@ -225,8 +237,15 @@ static int pcf8523_rtc_set_time(struct d
 	msg.buf = regs;
 
 	err = i2c_transfer(client->adapter, &msg, 1);
-	if (err < 0)
+	if (err < 0) {
+		/*
+		 * If the time cannot be set, restart the RTC anyway. Note
+		 * that errors are ignored if the RTC cannot be started so
+		 * that we have a chance to propagate the original error.
+		 */
+		pcf8523_start_rtc(client);
 		return err;
+	}
 
 	return pcf8523_start_rtc(client);
 }
_

Patches currently in -mm which might be from thierry.reding@avionic-design.de are

linux-next.patch
mm-compaction-fix-compiler-warning.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-video-backlight-lp855x_blc-remove-unnecessary-mutex-code.patch
backlight-add-of_find_backlight_by_node-function.patch
backlight-add-of_find_backlight_by_node-function-fix.patch
backlight-add-of_find_backlight_by_node-function-fix-2.patch
rtc-add-nxp-pcf8523-support.patch
rtc-add-nxp-pcf8523-support-v2.patch

