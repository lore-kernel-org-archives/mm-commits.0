From: akpm@linux-foundation.org
Subject: + phantom-dont-grab-other-devices.patch added to -mm tree
Date: Mon, 07 Jan 2008 15:59:26 -0800
Message-ID: <200801072359.m07NxQJN018839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51314 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754606AbYAHAAF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 19:00:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, andreas.block@esd-electronics.com, oliver.thimm@esd-electronics.com


The patch titled
     phantom: don't grab other devices
has been added to the -mm tree.  Its filename is
     phantom-dont-grab-other-devices.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: phantom: don't grab other devices
From: Jiri Slaby <jirislaby@gmail.com>

Specify also sub pci ids to not grab devices with properly set sub ids.
This devices has these set (unset) to the same as (plx 9050) ids.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Andreas Block <andreas.block@esd-electronics.com>
Cc: Oliver Thimm <oliver.thimm@esd-electronics.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/phantom.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/misc/phantom.c~phantom-dont-grab-other-devices drivers/misc/phantom.c
--- a/drivers/misc/phantom.c~phantom-dont-grab-other-devices
+++ a/drivers/misc/phantom.c
@@ -25,7 +25,7 @@
 #include <asm/atomic.h>
 #include <asm/io.h>
 
-#define PHANTOM_VERSION		"n0.9.7"
+#define PHANTOM_VERSION		"n0.9.8"
 
 #define PHANTOM_MAX_MINORS	8
 
@@ -456,8 +456,9 @@ static int phantom_resume(struct pci_dev
 #endif
 
 static struct pci_device_id phantom_pci_tbl[] __devinitdata = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050),
-		.class = PCI_CLASS_BRIDGE_OTHER << 8, .class_mask = 0xffff00 },
+	{ .vendor = PCI_VENDOR_ID_PLX, .device = PCI_DEVICE_ID_PLX_9050,
+	  .subvendor = PCI_VENDOR_ID_PLX, .subdevice = PCI_DEVICE_ID_PLX_9050,
+	  .class = PCI_CLASS_BRIDGE_OTHER << 8, .class_mask = 0xffff00 },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, phantom_pci_tbl);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-drm.patch
git-watchdog.patch
git-wireless.patch
drm-i915-fix-oops-after-killing-x.patch
capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check.patch
maintainers-order-auerswald-alphabetically.patch
phantom-dont-grab-other-devices.patch
pnp-do-not-stop-start-devices-in-suspend-resume-path.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-rocket-remove-useless-macros.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
char-esp-remove-hangup-and-wakeup-bottomhalves.patch
char-istallion-remove-hangup-bottomhalf.patch
char-specialix-remove-bottomhalves.patch
char-stallion-remove-bottomhalf.patch
char-serial167-remove-bottomhalf.patch
char-riscom8-remove-wakeup-anf-hangup-bottomhalves.patch
mxser-mxser_new-first-pass-over-termios-reporting-for-the.patch
moxa-first-pass-at-termios-reporting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
