From: akpm@linux-foundation.org
Subject: + input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch added to -mm tree
Date: Fri, 06 Mar 2009 14:04:22 -0800
Message-ID: <200903062204.n26M4Mfr004094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751912AbZCFWFA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 17:05:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, dmitry.torokhov@gmail.com, mamurph@cs.clemson.edu


The patch titled
     xpad: fix build error and warnings
has been added to the -mm tree.  Its filename is
     input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch

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

menu-fix-embedded-menu-snafu.patch
linux-next.patch
git-acpi-vs-git-cpufreq.patch
x86-oqo-depends-on-input_polldev.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
input-ad7879-touchscreen-driver.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
qla2x-fix-printk-format-warnings.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
alpha-convert-u64-to-unsigned-long-long.patch
alpha-convert-u64-to-unsigned-long-long-fix.patch
alpha-convert-u64-to-unsigned-long-long-fix-2.patch
alpha-convert-u64-to-unsigned-long-long-fix-3.patch
alpha-convert-u64-to-unsigned-long-long-fix-3-checkpatch-fixes.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-99.patch
atyfb-fix-header-file-trailing-whitespace.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-fix.patch
asiliantfb-fix-cmap-memory-leaks-fix.patch
documentation-ignore-byproducts-from-latex.patch
cpusets-replace-zone-allowed-functions-with-node-allowed.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch
reiser4-export-remove_from_page_cache-fix.patch

