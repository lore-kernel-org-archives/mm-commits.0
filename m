From: akpm@linux-foundation.org
Subject: - input-xpad-fix-dependancy-on-leds-class.patch removed from -mm tree
Date: Mon, 01 Oct 2007 00:13:40 -0700
Message-ID: <200710010713.l917DeCD004461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34758 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823AbXJAHOD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2007 03:14:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmitry.torokhov@gmail.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     Input: xpad: fix dependency on LEDS class
has been removed from the -mm tree.  Its filename was
     input-xpad-fix-dependancy-on-leds-class.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Input: xpad: fix dependency on LEDS class
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

The driver can not be built-in when LEDS class is a module.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/joystick/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/joystick/Kconfig~input-xpad-fix-dependancy-on-leds-class drivers/input/joystick/Kconfig
--- a/drivers/input/joystick/Kconfig~input-xpad-fix-dependancy-on-leds-class
+++ a/drivers/input/joystick/Kconfig
@@ -277,7 +277,7 @@ config JOYSTICK_XPAD_FF
 
 config JOYSTICK_XPAD_LEDS
 	bool "LED Support for Xbox360 controller 'BigX' LED"
-	depends on LEDS_CLASS && JOYSTICK_XPAD
+	depends on JOYSTICK_XPAD && (LEDS_CLASS=y || LEDS_CLASS=JOYSTICK_XPAD)
 	---help---
 	  This option enables support for the LED which surrounds the Big X on
 	  XBox 360 controller.
_

Patches currently in -mm which might be from dmitry.torokhov@gmail.com are

origin.patch
git-input.patch
