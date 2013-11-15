From: akpm@linux-foundation.org
Subject: [folded-merged]
 input-route-kbd-leds-through-the-generic-leds-layer-fix-3.patch removed
 from -mm tree
Date: Fri, 15 Nov 2013 14:16:51 -0800
Message-ID: <52869d53.XKSW+mDEdqQQ6dtB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab3KOWQw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 17:16:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, samuel.thibault@ens-lyon.org

Subject: [folded-merged] input-route-kbd-leds-through-the-generic-leds-layer-fix-3.patch removed from -mm tree
To: samuel.thibault@ens-lyon.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 14:16:51 -0800


The patch titled
     Subject: input-route-kbd-leds-through-the-generic-leds-layer-fix-3
has been removed from the -mm tree.  Its filename was
     input-route-kbd-leds-through-the-generic-leds-layer-fix-3.patch

This patch was dropped because it was folded into input-route-kbd-leds-through-the-generic-leds-layer.patch

------------------------------------------------------
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: input-route-kbd-leds-through-the-generic-leds-layer-fix-3

Link input/leds.c along input/input.c instead of separate module

input.c needs to call leds.c and vice-versa, so it is simpler to stuff
them together. INPUT_LEDS thus now depends on LEDS_CLASS being available
enough for input.ko.

This also documents the new leds field.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/Kconfig  |    4 ++--
 drivers/input/Makefile |    4 +++-
 include/linux/input.h  |    1 +
 3 files changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/input/Kconfig~input-route-kbd-leds-through-the-generic-leds-layer-fix-3 drivers/input/Kconfig
--- a/drivers/input/Kconfig~input-route-kbd-leds-through-the-generic-leds-layer-fix-3
+++ a/drivers/input/Kconfig
@@ -179,8 +179,8 @@ comment "Input Device Drivers"
 source "drivers/input/keyboard/Kconfig"
 
 config INPUT_LEDS
-	tristate "LED Support"
-	depends on LEDS_CLASS
+	bool "LED Support"
+	depends on LEDS_CLASS = INPUT || LEDS_CLASS = y
 	select LEDS_TRIGGERS
 	default y
 	help
diff -puN drivers/input/Makefile~input-route-kbd-leds-through-the-generic-leds-layer-fix-3 drivers/input/Makefile
--- a/drivers/input/Makefile~input-route-kbd-leds-through-the-generic-leds-layer-fix-3
+++ a/drivers/input/Makefile
@@ -6,6 +6,9 @@
 
 obj-$(CONFIG_INPUT)		+= input-core.o
 input-core-y := input.o input-compat.o input-mt.o ff-core.o
+ifeq ($(CONFIG_INPUT_LEDS),y)
+input-core-y += leds.o
+endif
 
 obj-$(CONFIG_INPUT_FF_MEMLESS)	+= ff-memless.o
 obj-$(CONFIG_INPUT_POLLDEV)	+= input-polldev.o
@@ -16,7 +19,6 @@ obj-$(CONFIG_INPUT_MOUSEDEV)	+= mousedev
 obj-$(CONFIG_INPUT_JOYDEV)	+= joydev.o
 obj-$(CONFIG_INPUT_EVDEV)	+= evdev.o
 obj-$(CONFIG_INPUT_EVBUG)	+= evbug.o
-obj-$(CONFIG_INPUT_LEDS)	+= leds.o
 
 obj-$(CONFIG_INPUT_KEYBOARD)	+= keyboard/
 obj-$(CONFIG_INPUT_MOUSE)	+= mouse/
diff -puN include/linux/input.h~input-route-kbd-leds-through-the-generic-leds-layer-fix-3 include/linux/input.h
--- a/include/linux/input.h~input-route-kbd-leds-through-the-generic-leds-layer-fix-3
+++ a/include/linux/input.h
@@ -79,6 +79,7 @@ struct input_value {
  * @led: reflects current state of device's LEDs
  * @snd: reflects current state of sound effects
  * @sw: reflects current state of device's switches
+ * @leds: leds objects for the device's LEDs
  * @open: this method is called when the very first user calls
  *	input_open_device(). The driver must prepare the device
  *	to start generating events (start polling thread,
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

origin.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch

