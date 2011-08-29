From: akpm@linux-foundation.org
Subject: + leds-move-renesas-tpu-led-driver-platform-data.patch added to -mm tree
Date: Mon, 29 Aug 2011 15:01:14 -0700
Message-ID: <201108292201.p7TM1Esa000506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755133Ab1H2WB7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Aug 2011 18:01:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@opensource.se, grant.likely@secretlab.ca, lethal@linux-sh.org, rpurdie@rpsys.net


The patch titled
     drivers/leds/leds-renesas-tpu.c: move Renesas TPU LED driver platform data
has been added to the -mm tree.  Its filename is
     leds-move-renesas-tpu-led-driver-platform-data.patch

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
Subject: drivers/leds/leds-renesas-tpu.c: move Renesas TPU LED driver platform data
From: Magnus Damm <damm@opensource.se>

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

linux-next.patch
leds-renesas-tpu-led-driver-v2.patch
leds-renesas-tpu-led-driver-v2-fix.patch
drivers-leds-leds-renesas-tpuc-update-driver-to-use-workqueue.patch
leds-move-renesas-tpu-led-driver-platform-data.patch

