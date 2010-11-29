From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-lp5521c-change-some-macros-to-functions.patch removed from -mm tree
Date: Mon, 29 Nov 2010 11:51:01 -0800
Message-ID: <201011291951.oATJpUfF007292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358Ab0K2Tvo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Nov 2010 14:51:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samu.p.onkalo@nokia.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     drivers/leds/leds-lp5521.c: change some macros to functions
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-lp5521c-change-some-macros-to-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/leds/leds-lp5521.c: change some macros to functions
From: Samu Onkalo <samu.p.onkalo@nokia.com>

Some small macros changed to inline functions to have proper type
checking.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5521.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff -puN drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-change-some-macros-to-functions drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-change-some-macros-to-functions
+++ a/drivers/leds/leds-lp5521.c
@@ -125,11 +125,22 @@ struct lp5521_chip {
 	u8			num_leds;
 };
 
-#define cdev_to_led(c)		container_of(c, struct lp5521_led, cdev)
-#define engine_to_lp5521(eng)	container_of((eng), struct lp5521_chip, \
-						engines[(eng)->id - 1])
-#define led_to_lp5521(led)	container_of((led), struct lp5521_chip, \
-						leds[(led)->id])
+static inline struct lp5521_led *cdev_to_led(struct led_classdev *cdev)
+{
+	return container_of(cdev, struct lp5521_led, cdev);
+}
+
+static inline struct lp5521_chip *engine_to_lp5521(struct lp5521_engine *engine)
+{
+	return container_of(engine, struct lp5521_chip,
+			    engines[engine->id - 1]);
+}
+
+static inline struct lp5521_chip *led_to_lp5521(struct lp5521_led *led)
+{
+	return container_of(led, struct lp5521_chip,
+			    leds[led->id]);
+}
 
 static void lp5521_led_brightness_work(struct work_struct *work);
 
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com are

origin.patch

