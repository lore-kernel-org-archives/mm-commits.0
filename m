From: akpm@linux-foundation.org
Subject: [merged] leds-move-renesas-tpu-led-driver-platform-data.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:15:18 -0700
Message-ID: <201111012115.pA1LFIRB019850@hpaq5.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16558 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1KAVPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:15:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: damm@opensource.se, grant.likely@secretlab.ca, lethal@linux-sh.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-renesas-tpu.c: move Renesas TPU LED driver platform data
has been removed from the -mm tree.  Its filename was
     leds-move-renesas-tpu-led-driver-platform-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Magnus Damm <damm@opensource.se>
Subject: drivers/leds/leds-renesas-tpu.c: move Renesas TPU LED driver platform data

Use the platform_data include directory for the TPU LED driver, as
suggested by Paul Mundt.

Signed-off-by: Magnus Damm <damm@opensource.se>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-renesas-tpu.c                |    2 +-
 include/linux/leds-renesas-tpu.h               |   14 --------------
 include/linux/platform_data/leds-renesas-tpu.h |   14 ++++++++++++++
 3 files changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/leds/leds-renesas-tpu.c~leds-move-renesas-tpu-led-driver-platform-data drivers/leds/leds-renesas-tpu.c
--- a/drivers/leds/leds-renesas-tpu.c~leds-move-renesas-tpu-led-driver-platform-data
+++ a/drivers/leds/leds-renesas-tpu.c
@@ -26,7 +26,7 @@
 #include <linux/io.h>
 #include <linux/clk.h>
 #include <linux/leds.h>
-#include <linux/leds-renesas-tpu.h>
+#include <linux/platform_data/leds-renesas-tpu.h>
 #include <linux/gpio.h>
 #include <linux/err.h>
 #include <linux/slab.h>
diff -puN include/linux/leds-renesas-tpu.h~leds-move-renesas-tpu-led-driver-platform-data /dev/null
--- a/include/linux/leds-renesas-tpu.h
+++ /dev/null
@@ -1,14 +0,0 @@
-#ifndef __LEDS_RENESAS_TPU_H__
-#define __LEDS_RENESAS_TPU_H__
-
-struct led_renesas_tpu_config {
-	char *name;
-	unsigned pin_gpio_fn;
-	unsigned pin_gpio;
-	unsigned int channel_offset;
-	unsigned int timer_bit;
-	unsigned int max_brightness;
-	unsigned int refresh_rate;
-};
-
-#endif /* __LEDS_RENESAS_TPU_H__ */
diff -puN /dev/null include/linux/platform_data/leds-renesas-tpu.h
--- /dev/null
+++ a/include/linux/platform_data/leds-renesas-tpu.h
@@ -0,0 +1,14 @@
+#ifndef __LEDS_RENESAS_TPU_H__
+#define __LEDS_RENESAS_TPU_H__
+
+struct led_renesas_tpu_config {
+	char *name;
+	unsigned pin_gpio_fn;
+	unsigned pin_gpio;
+	unsigned int channel_offset;
+	unsigned int timer_bit;
+	unsigned int max_brightness;
+	unsigned int refresh_rate;
+};
+
+#endif /* __LEDS_RENESAS_TPU_H__ */
_

Patches currently in -mm which might be from damm@opensource.se are

origin.patch
linux-next.patch

