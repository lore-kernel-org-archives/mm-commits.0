From: akpm@linux-foundation.org
Subject: - rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:27:08 -0800
Message-ID: <200802070026.m170Qnm0006954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58092 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765791AbYBGApS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc-s3c: Use is_power_of_2() macro for simplicity.
has been removed from the -mm tree.  Its filename was
     rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-s3c: Use is_power_of_2() macro for simplicity.
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Use is_power_of_2() macro for simplicity.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-s3c-use-is_power_of_2-macro-for-simplicity drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-s3c-use-is_power_of_2-macro-for-simplicity
+++ a/drivers/rtc/rtc-s3c.c
@@ -20,6 +20,7 @@
 #include <linux/rtc.h>
 #include <linux/bcd.h>
 #include <linux/clk.h>
+#include <linux/log2.h>
 
 #include <asm/hardware.h>
 #include <asm/uaccess.h>
@@ -309,9 +310,7 @@ static int s3c_rtc_ioctl(struct device *
 		break;
 
 	case RTC_IRQP_SET:
-		/* check for power of 2 */
-
-		if ((arg & (arg-1)) != 0 || arg < 1) {
+		if (!is_power_of_2(arg)) {
 			ret = -EINVAL;
 			goto exit;
 		}
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-hwmon.patch
git-xfs.patch
