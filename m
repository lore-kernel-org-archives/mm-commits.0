From: akpm@linux-foundation.org
Subject: [merged]
 hwmon-w83795-use-find_closest_descending-in-pwm_freq_to_reg.patch removed
 from -mm tree
Date: Mon, 20 Apr 2015 12:16:29 -0700
Message-ID: <5535508d.d8NuKFAwM+WxC28B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbbDTTKI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:10:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bgolaszewski@baylibre.com, linux@roeck-us.net, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hwmon: (w83795) use find_closest_descending() in pwm_freq_to_reg()
has been removed from the -mm tree.  Its filename was
     hwmon-w83795-use-find_closest_descending-in-pwm_freq_to_reg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: hwmon: (w83795) use find_closest_descending() in pwm_freq_to_reg()

Replace the loop iterating over pwm_freq_cksel0 with a call to
find_closest_descending().

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/w83795.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/hwmon/w83795.c~hwmon-w83795-use-find_closest_descending-in-pwm_freq_to_reg drivers/hwmon/w83795.c
--- a/drivers/hwmon/w83795.c~hwmon-w83795-use-find_closest_descending-in-pwm_freq_to_reg
+++ a/drivers/hwmon/w83795.c
@@ -35,6 +35,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/jiffies.h>
+#include <linux/util_macros.h>
 
 /* Addresses to scan */
 static const unsigned short normal_i2c[] = {
@@ -308,11 +309,8 @@ static u8 pwm_freq_to_reg(unsigned long
 	unsigned long best0, best1;
 
 	/* Best fit for cksel = 0 */
-	for (reg0 = 0; reg0 < ARRAY_SIZE(pwm_freq_cksel0) - 1; reg0++) {
-		if (val > (pwm_freq_cksel0[reg0] +
-			   pwm_freq_cksel0[reg0 + 1]) / 2)
-			break;
-	}
+	reg0 = find_closest_descending(val, pwm_freq_cksel0,
+				       ARRAY_SIZE(pwm_freq_cksel0));
 	if (val < 375)	/* cksel = 1 can't beat this */
 		return reg0;
 	best0 = pwm_freq_cksel0[reg0];
_

Patches currently in -mm which might be from bgolaszewski@baylibre.com are

origin.patch

