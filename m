From: akpm@linux-foundation.org
Subject: + input-xpad-fix-dependancy-on-leds-class.patch added to -mm tree
Date: Wed, 26 Sep 2007 21:26:12 -0700
Message-ID: <200709270426.l8R4QCSS019264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50763 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761AbXI0E0V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Sep 2007 00:26:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, dtor@mail.ru


The patch titled
     Input: xpad: fix dependancy on LEDS class
has been added to the -mm tree.  Its filename is
     input-xpad-fix-dependancy-on-leds-class.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Input: xpad: fix dependancy on LEDS class
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

input-xpad-fix-dependancy-on-leds-class.patch
git-input.patch
