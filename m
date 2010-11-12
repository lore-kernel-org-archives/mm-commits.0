From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-lp5523c-change-some-macros-to-functions.patch added to -mm tree
Date: Fri, 12 Nov 2010 11:44:54 -0800
Message-ID: <201011121944.oACJislL028058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756541Ab0KLTpg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Nov 2010 14:45:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samu.p.onkalo@nokia.com, rpurdie@rpsys.net


The patch titled
     drivers/leds/leds-lp5523.c: change some macros to functions
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-lp5523c-change-some-macros-to-functions.patch

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

drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store.patch
leds-driver-for-national-semiconductor-lp5521-chip.patch
leds-driver-for-national-semiconductors-lp5523-chip.patch
leds-update-lp552x-support-kconfig-and-makefile.patch
documentation-led-drivers-lp5521-and-lp5523.patch
drivers-leds-leds-lp5521c-change-some-macros-to-functions.patch
drivers-leds-leds-lp5523c-change-some-macros-to-functions.patch
drivers-leds-leds-lp5521c-adjust-delays-and-add-comments-to-them.patch
drivers-leds-leds-lp5523c-adjust-delays-and-add-comments-to-them.patch
drivers-leds-leds-lp5521c-perform-sw-reset-before-detection.patch
drivers-leds-leds-lp5523c-perform-sw-reset-before-detection.patch

