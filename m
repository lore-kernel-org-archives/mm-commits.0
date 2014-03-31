From: akpm@linux-foundation.org
Subject: + input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
 added to -mm tree
Date: Mon, 31 Mar 2014 12:11:06 -0700
Message-ID: <5339bdca.PIbwcpDqpqMr0eQg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbaCaTLH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Mar 2014 15:11:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, samuel.thibault@ens-lyon.org

Subject: + input-route-kbd-leds-through-the-generic-leds-layer-fix.patch added to -mm tree
To: samuel.thibault@ens-lyon.org
From: akpm@linux-foundation.org
Date: Mon, 31 Mar 2014 12:11:06 -0700


The patch titled
     Subject: input-route-kbd-leds-through-the-generic-leds-layer-fix
has been added to the -mm tree.  Its filename is
     input-route-kbd-leds-through-the-generic-leds-layer-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/input-route-kbd-leds-through-the-generic-leds-layer-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch

