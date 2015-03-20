From: akpm@linux-foundation.org
Subject: + hwmon-lm85-use-find_closest-in-x_to_reg-functions.patch added
 to -mm tree
Date: Fri, 20 Mar 2015 13:51:29 -0700
Message-ID: <550c8851.sMpsdrA0LgdFTrh7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbbCTUva (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Mar 2015 16:51:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bgolaszewski@baylibre.com, linux@roeck-us.net, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hwmon: (lm85) use find_closest() in x_TO_REG() functions
has been added to the -mm tree.  Its filename is
     hwmon-lm85-use-find_closest-in-x_to_reg-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hwmon-lm85-use-find_closest-in-x_to_reg-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hwmon-lm85-use-find_closest-in-x_to_reg-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: hwmon: (lm85) use find_closest() in x_TO_REG() functions

Replace RANGE_TO_REG() and FREQ_TO_REG() implementations with
calls to find_closest().

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lm85.c |   26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff -puN drivers/hwmon/lm85.c~hwmon-lm85-use-find_closest-in-x_to_reg-functions drivers/hwmon/lm85.c
--- a/drivers/hwmon/lm85.c~hwmon-lm85-use-find_closest-in-x_to_reg-functions
+++ a/drivers/hwmon/lm85.c
@@ -34,6 +34,7 @@
 #include <linux/hwmon-sysfs.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/util_macros.h>
 
 /* Addresses to scan */
 static const unsigned short normal_i2c[] = { 0x2c, 0x2d, 0x2e, I2C_CLIENT_END };
@@ -190,15 +191,7 @@ static const int lm85_range_map[] = {
 
 static int RANGE_TO_REG(long range)
 {
-	int i;
-
-	/* Find the closest match */
-	for (i = 0; i < 15; ++i) {
-		if (range <= (lm85_range_map[i] + lm85_range_map[i + 1]) / 2)
-			break;
-	}
-
-	return i;
+	return find_closest(range, lm85_range_map, ARRAY_SIZE(lm85_range_map));
 }
 #define RANGE_FROM_REG(val)	lm85_range_map[(val) & 0x0f]
 
@@ -209,16 +202,12 @@ static const int lm85_freq_map[8] = { /*
 static const int adm1027_freq_map[8] = { /* 1 Hz */
 	11, 15, 22, 29, 35, 44, 59, 88
 };
+#define FREQ_MAP_LEN	8
 
-static int FREQ_TO_REG(const int *map, unsigned long freq)
+static int FREQ_TO_REG(const int *map,
+		       unsigned int map_size, unsigned long freq)
 {
-	int i;
-
-	/* Find the closest match */
-	for (i = 0; i < 7; ++i)
-		if (freq <= (map[i] + map[i + 1]) / 2)
-			break;
-	return i;
+	return find_closest(freq, map, map_size);
 }
 
 static int FREQ_FROM_REG(const int *map, u8 reg)
@@ -828,7 +817,8 @@ static ssize_t set_pwm_freq(struct devic
 		data->cfg5 &= ~ADT7468_HFPWM;
 		lm85_write_value(client, ADT7468_REG_CFG5, data->cfg5);
 	} else {					/* Low freq. mode */
-		data->pwm_freq[nr] = FREQ_TO_REG(data->freq_map, val);
+		data->pwm_freq[nr] = FREQ_TO_REG(data->freq_map,
+						 FREQ_MAP_LEN, val);
 		lm85_write_value(client, LM85_REG_AFAN_RANGE(nr),
 				 (data->zone[nr].range << 4)
 				 | data->pwm_freq[nr]);
_

Patches currently in -mm which might be from bgolaszewski@baylibre.com are

util_macrosh-add-find_closest-macro.patch
documentation-update-codingstyle-on-local-variables-naming-in-macros.patch
hwmon-ina2xx-replace-ina226_avg_bits-with-find_closest.patch
hwmon-lm85-use-find_closest-in-x_to_reg-functions.patch
hwmon-w83795-use-find_closest_descending-in-pwm_freq_to_reg.patch

