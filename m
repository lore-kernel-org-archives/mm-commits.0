From: akpm@linux-foundation.org
Subject: [folded] input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch removed from -mm tree
Date: Tue, 12 May 2009 13:41:14 -0700
Message-ID: <200905122100.n4CL0UaJ005627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224AbZELVIS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 May 2009 17:08:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, dmitry.torokhov@gmail.com, mamurph@cs.clemson.edu, mm-commits@vger.kernel.org


The patch titled
     xpad: fix build error and warnings
has been removed from the -mm tree.  Its filename was
     input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch

This patch was dropped because it was folded into input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xpad: fix build error and warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Add a dummy xpad_send_led_command() for the case of
CONFIG_JOYSTICK_XPAD_LEDS=n.  Fixes this build error:

ERROR: "xpad_send_led_command" [drivers/input/joystick/xpad.ko] undefined!

Remove 2 duplicate function prototypes in xpad.h.

Fix these xpad.h warnings:
drivers/input/joystick/xpad.h:231: warning: 'enum led_brightness' declared inside parameter list
drivers/input/joystick/xpad.h:231: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/input/joystick/xpad.h:231: warning: 'struct led_classdev' declared inside parameter list
drivers/input/joystick/xpad.h:231: warning: 'xpad_led_set' declared 'static' but never defined

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mike Murphy <mamurph@cs.clemson.edu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/joystick/xpad.c |    3 ++-
 drivers/input/joystick/xpad.h |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/input/joystick/xpad.c~input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix drivers/input/joystick/xpad.c
--- a/drivers/input/joystick/xpad.c~input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix
+++ a/drivers/input/joystick/xpad.c
@@ -1076,9 +1076,10 @@ static void xpad_led_disconnect(struct u
 	}
 }
 #else
-/* dummies for xpad_probe and xpad_disconnect */
+/* dummies for xpad_probe, xpad_disconnect, & xpad_send_led_command */
 static int xpad_led_probe(struct usb_xpad *xpad) { return 0; }
 static void xpad_led_disconnect(struct usb_xpad *xpad) { }
+static void xpad_send_led_command(struct usb_xpad *xpad, int command) { }
 #endif
 
 /* end LED section */
diff -puN drivers/input/joystick/xpad.h~input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix drivers/input/joystick/xpad.h
--- a/drivers/input/joystick/xpad.h~input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix
+++ a/drivers/input/joystick/xpad.h
@@ -224,13 +224,13 @@ static void xpad_irq_in(struct urb *urb)
 static void xpad_irq_out(struct urb *urb);
 static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad);
 static void xpad_stop_output(struct usb_xpad *xpad);
-static void xpad_stop_output(struct usb_xpad *xpad);
 static int xpad_play_effect(struct input_dev *dev, void *data,
 			    struct ff_effect *effect);
 static int xpad_init_ff(struct usb_xpad *xpad);
-static void xpad_send_led_command(struct usb_xpad *xpad, int command);
+#ifdef CONFIG_JOYSTICK_XPAD_LEDS
 static void xpad_led_set(struct led_classdev *led_cdev,
 	enum led_brightness value);
+#endif
 static int xpad_led_probe(struct usb_xpad *xpad);
 static void xpad_led_disconnect(struct usb_xpad *xpad);
 static int xpad_open(struct input_dev *dev);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kvm-fix-build-error-add-missing-semi-colon.patch
dm-table-fix-printk-formats.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
menu-fix-embedded-menu-presentation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
slqbinfo-eliminate-warnings.patch
lockd-fix-file_locking=n-build-error.patch
xen-use-header-for-export_symbol_gpl.patch
kmap_types-make-most-arches-use-generic-header-file.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
cgroups-make-messages-more-readable.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

