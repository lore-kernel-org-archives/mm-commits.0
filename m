From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-lp5523c-change-some-macros-to-functions.patch removed from -mm tree
Date: Mon, 29 Nov 2010 11:51:03 -0800
Message-ID: <201011291951.oATJpWEh007295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358Ab0K2Tvq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Nov 2010 14:51:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samu.p.onkalo@nokia.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     drivers/leds/leds-lp5523.c: change some macros to functions
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-lp5523c-change-some-macros-to-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/leds/leds-lp5523.c: change some macros to functions
From: Samu Onkalo <samu.p.onkalo@nokia.com>

A small macro changed to inline function to have proper type checking. 
Inline added to two similar small functions.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5523.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/leds/leds-lp5523.c~drivers-leds-leds-lp5523c-change-some-macros-to-functions drivers/leds/leds-lp5523.c
--- a/drivers/leds/leds-lp5523.c~drivers-leds-leds-lp5523c-change-some-macros-to-functions
+++ a/drivers/leds/leds-lp5523.c
@@ -134,15 +134,18 @@ struct lp5523_chip {
 	u8			num_leds;
 };
 
-#define cdev_to_led(c)          container_of(c, struct lp5523_led, cdev)
+static inline struct lp5523_led *cdev_to_led(struct led_classdev *cdev)
+{
+	return container_of(cdev, struct lp5523_led, cdev);
+}
 
-static struct lp5523_chip *engine_to_lp5523(struct lp5523_engine *engine)
+static inline struct lp5523_chip *engine_to_lp5523(struct lp5523_engine *engine)
 {
 	return container_of(engine, struct lp5523_chip,
 			    engines[engine->id - 1]);
 }
 
-static struct lp5523_chip *led_to_lp5523(struct lp5523_led *led)
+static inline struct lp5523_chip *led_to_lp5523(struct lp5523_led *led)
 {
 	return container_of(led, struct lp5523_chip,
 			    leds[led->id]);
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com are

origin.patch

