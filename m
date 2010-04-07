From: akpm@linux-foundation.org
Subject: + lis3-setup-poll-interval-limits.patch added to -mm tree
Date: Wed, 07 Apr 2010 14:20:24 -0700
Message-ID: <201004072120.o37LKPd8007978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868Ab0DGVVJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 17:21:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samu.p.onkalo@nokia.com, daniel@caiaq.de, eric.piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3: setup poll interval limits
has been added to the -mm tree.  Its filename is
     lis3-setup-poll-interval-limits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lis3: setup poll interval limits
From: Samu Onkalo <samu.p.onkalo@nokia.com>

Set valid adjustment window (0 - 2000ms).

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/hwmon/lis3lv02d.c~lis3-setup-poll-interval-limits drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3-setup-poll-interval-limits
+++ a/drivers/hwmon/lis3lv02d.c
@@ -41,6 +41,8 @@
 
 /* joystick device poll interval in milliseconds */
 #define MDPS_POLL_INTERVAL 50
+#define MDPS_POLL_MIN	   0
+#define MDPS_POLL_MAX	   2000
 /*
  * The sensor can also generate interrupts (DRDY) but it's pretty pointless
  * because they are generated even if the data do not change. So it's better
@@ -459,6 +461,8 @@ int lis3lv02d_joystick_enable(void)
 
 	lis3_dev.idev->poll = lis3lv02d_joystick_poll;
 	lis3_dev.idev->poll_interval = MDPS_POLL_INTERVAL;
+	lis3_dev.idev->poll_interval_min = MDPS_POLL_MIN;
+	lis3_dev.idev->poll_interval_max = MDPS_POLL_MAX;
 	input_dev = lis3_dev.idev->input;
 
 	input_dev->name       = "ST LIS3LV02DL Accelerometer";
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com are

lis3-add-missing-constants-for-8bit-device.patch
lis3-separate-configuration-function-for-8-bit-device.patch
lis3-introduce-platform-data-for-second-ff-wu-unit.patch
lis3-add-skeletons-for-interrupt-handlers.patch
lis3-interrupt-handlers-for-8bit-wakeup-and-click-events.patch
lis3-setup-poll-interval-limits.patch

