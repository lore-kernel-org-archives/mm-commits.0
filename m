From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-add-nxp-pcf8523-support-v2.patch removed from -mm tree
Date: Mon, 17 Dec 2012 15:46:47 -0800
Message-ID: <20121217234648.36D31200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:59166 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab2LQXqu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 18:46:50 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so354950eei.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 15:46:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thierry.reding@avionic-design.de, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-add-nxp-pcf8523-support-v2
has been removed from the -mm tree.  Its filename was
     rtc-add-nxp-pcf8523-support-v2.patch

This patch was dropped because it was folded into rtc-add-nxp-pcf8523-support.patch

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

origin.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions.patch
drivers-video-backlight-lp855x_blc-remove-unnecessary-mutex-code.patch
backlight-add-of_find_backlight_by_node-function.patch
rtc-add-nxp-pcf8523-support.patch

