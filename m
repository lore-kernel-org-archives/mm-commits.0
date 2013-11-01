From: akpm@linux-foundation.org
Subject: +
 input-route-kbd-leds-through-the-generic-leds-layer-fix-fix-fix.patch added to -mm tree
Date: Fri, 01 Nov 2013 13:14:54 -0700
Message-ID: <52740bbe.XjIHJbqX98KymikN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3KAUOz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Nov 2013 16:14:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ralf@linux-mips.org, dmitry.torokhov@gmail.com, blogic@openwrt.org, samuel.thibault@ens-lyon.org

Subject: + input-route-kbd-leds-through-the-generic-leds-layer-fix-fix-fix.patch added to -mm tree
To: samuel.thibault@ens-lyon.org,blogic@openwrt.org,dmitry.torokhov@gmail.com,ralf@linux-mips.org
From: akpm@linux-foundation.org
Date: Fri, 01 Nov 2013 13:14:54 -0700


The patch titled
     Subject: input-route-kbd-leds-through-the-generic-leds-layer-fix-fix-fix
has been added to the -mm tree.  Its filename is
     input-route-kbd-leds-through-the-generic-leds-layer-fix-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/input-route-kbd-leds-through-the-generic-leds-layer-fix-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/input-route-kbd-leds-through-the-generic-leds-layer-fix-fix-fix.patch

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
Subject: input-route-kbd-leds-through-the-generic-leds-layer-fix-fix-fix

Export input led symbols for input core module.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: John Crispin <blogic@openwrt.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/leds.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/input/leds.c~input-route-kbd-leds-through-the-generic-leds-layer-fix-fix-fix drivers/input/leds.c
--- a/drivers/input/leds.c~input-route-kbd-leds-through-the-generic-leds-layer-fix-fix-fix
+++ a/drivers/input/leds.c
@@ -210,6 +210,7 @@ err:
 	input_led_delete(dev);
 	return error;
 }
+EXPORT_SYMBOL_GPL(input_led_connect);
 
 /* Disconnected input device. Clean it, and deregister now-useless VT LEDs
  * and triggers.  */
@@ -241,6 +242,7 @@ extern void input_led_disconnect(struct
 	}
 	mutex_unlock(&vt_led_registered_lock);
 }
+EXPORT_SYMBOL_GPL(input_led_disconnect);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("User LED support for input layer");
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

input-route-kbd-leds-through-the-generic-leds-layer.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix-fix-fix.patch
linux-next.patch

