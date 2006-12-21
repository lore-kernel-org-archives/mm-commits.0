From: akpm@osdl.org
Subject: - char-hid-ff-support-yet-another-wheel.patch removed from -mm tree
Date: Thu, 21 Dec 2006 12:10:23 -0800
Message-ID: <200612212010.kBLKAN63003565@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36567 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423079AbWLUUKl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 15:10:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     Char: hid-ff, support yet another wheel
has been removed from the -mm tree.  Its filename was
     char-hid-ff-support-yet-another-wheel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: hid-ff, support yet another wheel
From: Jiri Slaby <jirislaby@gmail.com>

hid-ff, support yet another wheel

Add support for Logitech Momo racing wheel (046d:ca03) to hid force
feedback.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/input/hid-ff.c   |    1 +
 drivers/usb/input/hid-lgff.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/usb/input/hid-ff.c~char-hid-ff-support-yet-another-wheel drivers/usb/input/hid-ff.c
--- a/drivers/usb/input/hid-ff.c~char-hid-ff-support-yet-another-wheel
+++ a/drivers/usb/input/hid-ff.c
@@ -56,6 +56,7 @@ static struct hid_ff_initializer inits[]
 	{ 0x46d, 0xc283, hid_lgff_init }, /* Logitech Wingman Force 3d */
 	{ 0x46d, 0xc295, hid_lgff_init }, /* Logitech MOMO force wheel */
 	{ 0x46d, 0xc219, hid_lgff_init }, /* Logitech Cordless rumble pad 2 */
+	{ 0x46d, 0xca03, hid_lgff_init }, /* Logitech MOMO force wheel */
 #endif
 #ifdef CONFIG_THRUSTMASTER_FF
 	{ 0x44f, 0xb304, hid_tmff_init },
diff -puN drivers/usb/input/hid-lgff.c~char-hid-ff-support-yet-another-wheel drivers/usb/input/hid-lgff.c
--- a/drivers/usb/input/hid-lgff.c~char-hid-ff-support-yet-another-wheel
+++ a/drivers/usb/input/hid-lgff.c
@@ -52,6 +52,7 @@ static const struct device_type devices[
 	{ 0x046d, 0xc211, ff_rumble },
 	{ 0x046d, 0xc219, ff_rumble },
 	{ 0x046d, 0xc283, ff_joystick },
+	{ 0x046d, 0xca03, ff_joystick },
 	{ 0x0000, 0x0000, ff_joystick }
 };
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-input.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch
mxser-remove-ambiguous-redefinition-of-init_work.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
char-isicom-fix-locking-in-isr.patch
char-isicom-augment-card_reset.patch
char-isicom-check-card-state-in-isr.patch
char-isicom-support-higher-rates.patch
char-isicom-correct-probing-removing.patch
char-tty_wakeup-cleanup.patch
shrink_slab-handle-bad-shrinkers.patch

