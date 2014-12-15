From: akpm@linux-foundation.org
Subject: [folded-merged]
 input-route-kbd-leds-through-the-generic-leds-layer-fix.patch removed from
 -mm tree
Date: Mon, 15 Dec 2014 14:25:19 -0800
Message-ID: <548f5fcf.JPr77rC6p8D+rroc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbaLOWZU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Dec 2014 17:25:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samuel.thibault@ens-lyon.org, mm-commits@vger.kernel.org


The patch titled
     Subject: input-route-kbd-leds-through-the-generic-leds-layer-fix
has been removed from the -mm tree.  Its filename was
     input-route-kbd-leds-through-the-generic-leds-layer-fix.patch

This patch was dropped because it was folded into input-route-kbd-leds-through-the-generic-leds-layer.patch

------------------------------------------------------
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: input-route-kbd-leds-through-the-generic-leds-layer-fix



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/leds.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/input/leds.c~input-route-kbd-leds-through-the-generic-leds-layer-fix drivers/input/leds.c
--- a/drivers/input/leds.c~input-route-kbd-leds-through-the-generic-leds-layer-fix
+++ a/drivers/input/leds.c
@@ -1,7 +1,7 @@
 /*
  * LED support for the input layer
  *
- * Copyright 2010-2013 Samuel Thibault <samuel.thibault@ens-lyon.org>
+ * Copyright 2010-2014 Samuel Thibault <samuel.thibault@ens-lyon.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -159,7 +159,7 @@ int input_led_connect(struct input_dev *
 	int i, error = 0;
 	struct led_classdev *leds;
 
-	dev->leds = leds = kzalloc(sizeof(*leds) * LED_CNT, GFP_KERNEL);
+	dev->leds = leds = kcalloc(LED_CNT, sizeof(*leds), GFP_KERNEL);
 	if (!dev->leds)
 		return -ENOMEM;
 
@@ -212,8 +212,8 @@ err:
 }
 
 /*
- * Disconnected input device. Clean it, and deregister now-useless VT LEDs and
- * triggers.
+ * Disconnected input device. Clean it, and deregister now-useless VT LEDs
+ * and triggers.
  */
 void input_led_disconnect(struct input_dev *dev)
 {
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

input-route-kbd-leds-through-the-generic-leds-layer.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix-2.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix-3.patch

