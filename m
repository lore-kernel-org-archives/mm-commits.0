From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-ep93xx_pwmc-world-writable-sysfs-files.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:38:47 -0700
Message-ID: <201103232042.p2NKgNnC028755@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933407Ab1CWUnU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:43:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segoon@openwall.com, hartleys@visionengravers.com, mcrapet@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/ep93xx_pwm.c: world-writable sysfs files
has been removed from the -mm tree.  Its filename was
     drivers-misc-ep93xx_pwmc-world-writable-sysfs-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/ep93xx_pwm.c: world-writable sysfs files
From: Vasiliy Kulikov <segoon@openwall.com>

Don't allow everybody to change device settings.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Acked-by: Hartley Sweeten <hartleys@visionengravers.com>
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
aic94xx-world-writable-sysfs-update_bios-file.patch

