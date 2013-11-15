From: akpm@linux-foundation.org
Subject: [folded-merged]
 input-route-kbd-leds-through-the-generic-leds-layer-fix.patch removed from
 -mm tree
Date: Fri, 15 Nov 2013 14:16:49 -0800
Message-ID: <52869d51.eaa1tT6bIEnYQFYY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab3KOWQu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 17:16:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, samuel.thibault@ens-lyon.org, ralf@linux-mips.org, dmitry.torokhov@gmail.com, blogic@openwrt.org

Subject: [folded-merged] input-route-kbd-leds-through-the-generic-leds-layer-fix.patch removed from -mm tree
To: blogic@openwrt.org,dmitry.torokhov@gmail.com,ralf@linux-mips.org,samuel.thibault@ens-lyon.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 14:16:49 -0800


The patch titled
     Subject: input: CONFIG_INPUT_LEDS stubs should be static inline
has been removed from the -mm tree.  Its filename was
     input-route-kbd-leds-through-the-generic-leds-layer-fix.patch

This patch was dropped because it was folded into input-route-kbd-leds-through-the-generic-leds-layer.patch

------------------------------------------------------
From: John Crispin <blogic@openwrt.org>
Subject: input: CONFIG_INPUT_LEDS stubs should be static inline

The following commit breaks compile when CONFIG_INPUT_LEDS is not selected.

commit 0eb6ee2db914ebb594cb9bc8ae97e3c362c3475a
Author: Samuel Thibault <samuel.thibault@ens-lyon.org>
Date:   Wed Oct 30 11:45:16 2013 +1100
input: route kbd LEDs through the generic LEDs layer

Signed-off-by: John Crispin <blogic@openwrt.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/input.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/input.h~input-route-kbd-leds-through-the-generic-leds-layer-fix include/linux/input.h
--- a/include/linux/input.h~input-route-kbd-leds-through-the-generic-leds-layer-fix
+++ a/include/linux/input.h
@@ -540,12 +540,12 @@ void input_led_disconnect(struct input_d
 
 #else
 
-int input_led_connect(struct input_dev *dev)
+static inline int input_led_connect(struct input_dev *dev)
 {
 	return 0;
 }
 
-void input_led_disconnect(struct input_dev *dev)
+static inline void input_led_disconnect(struct input_dev *dev)
 {
 }
 
_

Patches currently in -mm which might be from blogic@openwrt.org are

origin.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
linux-next.patch

