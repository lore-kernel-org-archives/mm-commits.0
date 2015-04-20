From: akpm@linux-foundation.org
Subject: [merged]
 hwmon-ina2xx-replace-ina226_avg_bits-with-find_closest.patch removed from
 -mm tree
Date: Mon, 20 Apr 2015 12:16:25 -0700
Message-ID: <55355089.hB5Kt+ubZju1opz9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbbDTTKE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:10:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bgolaszewski@baylibre.com, linux@roeck-us.net, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hwmon: (ina2xx) replace ina226_avg_bits() with find_closest()
has been removed from the -mm tree.  Its filename was
     hwmon-ina2xx-replace-ina226_avg_bits-with-find_closest.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: hwmon: (ina2xx) replace ina226_avg_bits() with find_closest()

Use find_closest() to locate the closest average in ina226_avg_tab.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/ina2xx.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff -puN drivers/hwmon/ina2xx.c~hwmon-ina2xx-replace-ina226_avg_bits-with-find_closest drivers/hwmon/ina2xx.c
--- a/drivers/hwmon/ina2xx.c~hwmon-ina2xx-replace-ina226_avg_bits-with-find_closest
+++ a/drivers/hwmon/ina2xx.c
@@ -36,6 +36,7 @@
 #include <linux/jiffies.h>
 #include <linux/of.h>
 #include <linux/delay.h>
+#include <linux/util_macros.h>
 
 #include <linux/platform_data/ina2xx.h>
 
@@ -141,19 +142,6 @@ static const struct ina2xx_config ina2xx
  */
 static const int ina226_avg_tab[] = { 1, 4, 16, 64, 128, 256, 512, 1024 };
 
-static int ina226_avg_bits(int avg)
-{
-	int i;
-
-	/* Get the closest average from the tab. */
-	for (i = 0; i < ARRAY_SIZE(ina226_avg_tab) - 1; i++) {
-		if (avg <= (ina226_avg_tab[i] + ina226_avg_tab[i + 1]) / 2)
-			break;
-	}
-
-	return i; /* Return 0b0111 for values greater than 1024. */
-}
