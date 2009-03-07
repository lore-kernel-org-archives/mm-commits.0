From: akpm@linux-foundation.org
Subject: + input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch added to -mm tree
Date: Fri, 06 Mar 2009 20:30:36 -0800
Message-ID: <200903070430.n274UaHd005004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792AbZCGEbi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 23:31:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mamurph@cs.clemson.edu, dmitry.torokhov@gmail.com, randy.dunlap@oracle.com


The patch titled
     xpad: add missing prototype and update history
has been added to the -mm tree.  Its filename is
     input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch

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
Subject: xpad: add missing prototype and update history
From: Mike Murphy <mamurph@cs.clemson.edu>

Add missing prototype to xpad.h and update driver history and last
modified dates

Signed-off-by: Mike Murphy <mamurph@cs.clemson.edu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/joystick/xpad.c |    2 +-
 drivers/input/joystick/xpad.h |   10 +++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff -puN drivers/input/joystick/xpad.c~input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history drivers/input/joystick/xpad.c
--- a/drivers/input/joystick/xpad.c~input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history
+++ a/drivers/input/joystick/xpad.c
@@ -1,7 +1,7 @@
 /*
  * Xbox gamepad driver with Xbox 360 wired/wireless support
  *
- * Last Modified:	2 March 2009
+ * Last Modified:	6 March 2009
  *			Mike Murphy <mamurph@cs.clemson.edu>
  *
  * Copyright (c) 2002 Marko Friedemann <mfr@bmx-chemnitz.de>
diff -puN drivers/input/joystick/xpad.h~input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history drivers/input/joystick/xpad.h
--- a/drivers/input/joystick/xpad.h~input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history
+++ a/drivers/input/joystick/xpad.h
@@ -1,7 +1,7 @@
 /*
  * Xbox gamepad driver with Xbox 360 wired/wireless support
  *
- * Last Modified:	2 March 2009
+ * Last Modified:	6 March 2009
  *			Mike Murphy <mamurph@cs.clemson.edu>
  *
  * Copyright (c) 2002 Marko Friedemann <mfr@bmx-chemnitz.de>
@@ -224,6 +224,7 @@ static void xpad_irq_in(struct urb *urb)
 static void xpad_irq_out(struct urb *urb);
 static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad);
 static void xpad_stop_output(struct usb_xpad *xpad);
+static void xpad_deinit_output(struct usb_xpad *xpad);
 static int xpad_play_effect(struct input_dev *dev, void *data,
 			    struct ff_effect *effect);
 static int xpad_init_ff(struct usb_xpad *xpad);
@@ -298,6 +299,13 @@ static struct attribute_group xpad_defau
 
 /* Driver History:
  *
+ * 2009-03-06 : Patches from -mm tree
+ *  - fixed build issue when CONFIG_JOYSTICK_XPAD_LEDS not set and removed
+ *    duplicate prototypes (thanks Randy Dunlap for patch)
+ *  - fixed erroneous whitespace reported by checkpatch (thanks Andrew Morton
+ *    for patch)
+ *  - added missing prototype
+ *
  * 2009-03-02 : Code cleanup
  *  - used min(), max(), and abs() where appropriate, simplifying code
  *  - moved code that generates data objects out of xpad.h and into xpad.c
_

Patches currently in -mm which might be from mamurph@cs.clemson.edu are

input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
input-documentation-abi-testing-game_device-sysfs-interface-document-game_device-interface-added-to-xpad-driver.patch

