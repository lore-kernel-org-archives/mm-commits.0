From: akpm@linux-foundation.org
Subject: - input-ff-add-ff_raw-effect.patch removed from -mm tree
Date: Wed, 02 May 2007 23:25:55 -0700
Message-ID: <200705030625.l436Ptw5006281@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030799AbXECG0d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 02:26:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, dtor@mail.ru, johann.deneux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Input: ff, add FF_RAW effect
has been removed from the -mm tree.  Its filename was
     input-ff-add-ff_raw-effect.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Input: ff, add FF_RAW effect
From: Jiri Slaby <jirislaby@gmail.com>

Add new FF_RAW effect for devices such Phantom. The new model has up to 6DOF
torque force feedback independent on any 3d-or-so value.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: johann deneux <johann.deneux@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/ff-memless.c |    4 ++++
 include/linux/input.h      |    4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/input/ff-memless.c~input-ff-add-ff_raw-effect drivers/input/ff-memless.c
--- a/drivers/input/ff-memless.c~input-ff-add-ff_raw-effect
+++ a/drivers/input/ff-memless.c
@@ -275,6 +275,10 @@ static void ml_combine_effects(struct ff
 			min(i + effect->u.rumble.weak_magnitude, 0xffffU);
 		break;
 
+	case FF_RAW:
+		memcpy(effect->u.ff_raw, new->u.ff_raw, sizeof(new->u.ff_raw));
+		break;
+
 	default:
 		printk(KERN_ERR "ff-memless: invalid type in ml_combine_effects()\n");
 		break;
diff -puN include/linux/input.h~input-ff-add-ff_raw-effect include/linux/input.h
--- a/include/linux/input.h~input-ff-add-ff_raw-effect
+++ a/include/linux/input.h
@@ -857,6 +857,7 @@ struct ff_effect {
 		struct ff_periodic_effect periodic;
 		struct ff_condition_effect condition[2]; /* One for each axis */
 		struct ff_rumble_effect rumble;
+		__u32 ff_raw[6];
 	} u;
 };
 
@@ -872,9 +873,10 @@ struct ff_effect {
 #define FF_DAMPER	0x55
 #define FF_INERTIA	0x56
 #define FF_RAMP		0x57
+#define FF_RAW		0x58
 
 #define FF_EFFECT_MIN	FF_RUMBLE
-#define FF_EFFECT_MAX	FF_RAMP
+#define FF_EFFECT_MAX	FF_RAW
 
 /*
  * Force feedback periodic effect types
_

Patches currently in -mm which might be from jirislaby@gmail.com are

serial-serial_core-use-pr_debug.patch
input-ff-add-ff_raw-effect.patch
input-phantom-add-a-new-driver.patch
misc-add-sensable-phantom-driver.patch
char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
drivers-char-use-__set_current_state.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
char-cyclades-remove-pause.patch
char-cyclades-cy_readx-writex-cleanup.patch
char-cyclades-timer-cleanup.patch
char-cyclades-remove-volatiles.patch
char-cyclades-remove-useless-casts.patch
char-cyclades-create-cy_init_ze.patch
char-cyclades-use-pci_iomap-unmap.patch
char-cyclades-init-ze-immediately.patch
char-cyclades-create-cy_pci_probe.patch
char-cyclades-move-card-entries-init-into-function.patch
char-cyclades-init-card-struct-immediately.patch
char-cyclades-remove-some-global-vars.patch
char-cyclades-cy_init-error-handling.patch
char-cyclades-tty_register_device-separately-for-each-device.patch
char-cyclades-clear-interrupts-before-releasing.patch
char-cyclades-allow-debug_shirq.patch
char-mxser-schedule-for-removal.patch
char-isicom-use-pr_debug.patch
shrink_slab-handle-bad-shrinkers.patch
