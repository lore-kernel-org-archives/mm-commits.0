From: akpm@linux-foundation.org
Subject: + rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch added to -mm tree
Date: Fri, 09 Nov 2007 00:23:44 -0800
Message-ID: <200711090823.lA98NnZA004411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60536 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989AbXKIIYG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 03:24:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc-s3c: Use is_power_of_2() macro for simplicity.
has been added to the -mm tree.  Its filename is
     rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
arm-remove-reference-to-non-existent-mtd_obsolete_chips.patch
lvm-use-rounddown_pow_of_two-macro-for-simplicity.patch
hwmon-replace-power-of-two-test-in-drivers-hwmon-adt7470c.patch
pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch
blackfin-typo-config_rtc_bfin_module.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
m68knommu-remove-vestiges-of-non-existent-disktel.patch
uml-delete-some-unused-headers.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
