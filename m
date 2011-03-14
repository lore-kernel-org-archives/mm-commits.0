From: akpm@linux-foundation.org
Subject: + drivers-misc-ep93xx_pwmc-world-writable-sysfs-files.patch added to -mm tree
Date: Mon, 14 Mar 2011 15:17:03 -0700
Message-ID: <201103142217.p2EMH3Db014186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752663Ab1CNWR6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Mar 2011 18:17:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segoon@openwall.com, hartleys@visionengravers.com, mcrapet@gmail.com


The patch titled
     drivers/misc/ep93xx_pwm.c: world-writable sysfs files
has been added to the -mm tree.  Its filename is
     drivers-misc-ep93xx_pwmc-world-writable-sysfs-files.patch

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
Subject: drivers/misc/ep93xx_pwm.c: world-writable sysfs files
From: Vasiliy Kulikov <segoon@openwall.com>

Don't allow everybody to change device settings.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Hartley Sweeten <hartleys@visionengravers.com>
Cc: Matthieu Crapet <mcrapet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ep93xx_pwm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/misc/ep93xx_pwm.c~drivers-misc-ep93xx_pwmc-world-writable-sysfs-files drivers/misc/ep93xx_pwm.c
--- a/drivers/misc/ep93xx_pwm.c~drivers-misc-ep93xx_pwmc-world-writable-sysfs-files
+++ a/drivers/misc/ep93xx_pwm.c
@@ -249,11 +249,11 @@ static ssize_t ep93xx_pwm_set_invert(str
 
 static DEVICE_ATTR(min_freq, S_IRUGO, ep93xx_pwm_get_min_freq, NULL);
 static DEVICE_ATTR(max_freq, S_IRUGO, ep93xx_pwm_get_max_freq, NULL);
-static DEVICE_ATTR(freq, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(freq, S_IWUSR | S_IRUGO,
 		   ep93xx_pwm_get_freq, ep93xx_pwm_set_freq);
-static DEVICE_ATTR(duty_percent, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(duty_percent, S_IWUSR | S_IRUGO,
 		   ep93xx_pwm_get_duty_percent, ep93xx_pwm_set_duty_percent);
-static DEVICE_ATTR(invert, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(invert, S_IWUSR | S_IRUGO,
 		   ep93xx_pwm_get_invert, ep93xx_pwm_set_invert);
 
 static struct attribute *ep93xx_pwm_attrs[] = {
_

Patches currently in -mm which might be from segoon@openwall.com are

origin.patch
linux-next.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
drivers-leds-leds-lp5521c-world-writable-sysfs-engine-files.patch
drivers-leds-leds-lp5523c-world-writable-engine-sysfs-files.patch
drivers-misc-ep93xx_pwmc-world-writable-sysfs-files.patch
drivers-rtc-rtc-ds1511c-world-writable-sysfs-nvram-file.patch
aic94xx-world-writable-sysfs-update_bios-file.patch
drivers-scsi-scsi_transport_iscsic-world-writable-sysfs-priv_sess-file.patch

