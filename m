From: akpm@linux-foundation.org
Subject: + char-use-more-pci_device-macro.patch added to -mm tree
Date: Mon, 05 Feb 2007 14:37:51 -0800
Message-ID: <200702052237.l15Mbp2M001409@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36734 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965005AbXBEWh7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 17:37:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, mb@bu3sch.de, wim@iguana.be


The patch titled
     Char: use more PCI_DEVICE macro
has been added to the -mm tree.  Its filename is
     char-use-more-pci_device-macro.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: use more PCI_DEVICE macro
From: Jiri Slaby <jirislaby@gmail.com>

Use more PCI_DEVICE macro

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Wim Van Sebroeck <wim@iguana.be> (alim7101_wdt.c part)
Cc: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hw_random/intel-rng.c   |   76 ++++++++++++-------------
 drivers/char/watchdog/alim7101_wdt.c |    6 -
 2 files changed, 40 insertions(+), 42 deletions(-)

diff -puN drivers/char/hw_random/intel-rng.c~char-use-more-pci_device-macro drivers/char/hw_random/intel-rng.c
--- a/drivers/char/hw_random/intel-rng.c~char-use-more-pci_device-macro
+++ a/drivers/char/hw_random/intel-rng.c
@@ -96,49 +96,49 @@
  */
 static const struct pci_device_id pci_tbl[] = {
 /* AA
-	{ 0x8086, 0x2418, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, */
-	{ 0x8086, 0x2410, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* AA */
+	{ PCI_DEVICE(0x8086, 0x2418) }, */
+	{ PCI_DEVICE(0x8086, 0x2410) }, /* AA */
 /* AB
-	{ 0x8086, 0x2428, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, */
-	{ 0x8086, 0x2420, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* AB */
+	{ PCI_DEVICE(0x8086, 0x2428) }, */
+	{ PCI_DEVICE(0x8086, 0x2420) }, /* AB */
 /* ??
-	{ 0x8086, 0x2430, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, */
+	{ PCI_DEVICE(0x8086, 0x2430) }, */
 /* BAM, CAM, DBM, FBM, GxM
-	{ 0x8086, 0x2448, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, */
-	{ 0x8086, 0x244c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* BAM */
-	{ 0x8086, 0x248c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* CAM */
-	{ 0x8086, 0x24cc, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* DBM */
-	{ 0x8086, 0x2641, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* FBM */
-	{ 0x8086, 0x27b9, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* GxM */
-	{ 0x8086, 0x27bd, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* GxM DH */
+	{ PCI_DEVICE(0x8086, 0x2448) }, */
+	{ PCI_DEVICE(0x8086, 0x244c) }, /* BAM */
+	{ PCI_DEVICE(0x8086, 0x248c) }, /* CAM */
+	{ PCI_DEVICE(0x8086, 0x24cc) }, /* DBM */
+	{ PCI_DEVICE(0x8086, 0x2641) }, /* FBM */
+	{ PCI_DEVICE(0x8086, 0x27b9) }, /* GxM */
+	{ PCI_DEVICE(0x8086, 0x27bd) }, /* GxM DH */
 /* BA, CA, DB, Ex, 6300, Fx, 631x/632x, Gx
-	{ 0x8086, 0x244e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, */
-	{ 0x8086, 0x2440, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* BA */
-	{ 0x8086, 0x2480, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* CA */
-	{ 0x8086, 0x24c0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* DB */
-	{ 0x8086, 0x24d0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* Ex */
-	{ 0x8086, 0x25a1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 6300 */
-	{ 0x8086, 0x2640, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* Fx */
-	{ 0x8086, 0x2670, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x2671, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x2672, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x2673, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x2674, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x2675, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x2676, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x2677, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x2678, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x2679, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x267a, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x267b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x267c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x267d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x267e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x267f, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x27b8, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* Gx */
+	{ PCI_DEVICE(0x8086, 0x244e) }, */
+	{ PCI_DEVICE(0x8086, 0x2440) }, /* BA */
+	{ PCI_DEVICE(0x8086, 0x2480) }, /* CA */
+	{ PCI_DEVICE(0x8086, 0x24c0) }, /* DB */
+	{ PCI_DEVICE(0x8086, 0x24d0) }, /* Ex */
+	{ PCI_DEVICE(0x8086, 0x25a1) }, /* 6300 */
+	{ PCI_DEVICE(0x8086, 0x2640) }, /* Fx */
+	{ PCI_DEVICE(0x8086, 0x2670) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x2671) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x2672) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x2673) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x2674) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x2675) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x2676) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x2677) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x2678) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x2679) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x267a) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x267b) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x267c) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x267d) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x267e) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x267f) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x27b8) }, /* Gx */
 /* E
-	{ 0x8086, 0x245e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, */
-	{ 0x8086, 0x2450, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* E  */
+	{ PCI_DEVICE(0x8086, 0x245e) }, */
+	{ PCI_DEVICE(0x8086, 0x2450) }, /* E  */
 	{ 0, },	/* terminate list */
 };
 MODULE_DEVICE_TABLE(pci, pci_tbl);
diff -puN drivers/char/watchdog/alim7101_wdt.c~char-use-more-pci_device-macro drivers/char/watchdog/alim7101_wdt.c
--- a/drivers/char/watchdog/alim7101_wdt.c~char-use-more-pci_device-macro
+++ a/drivers/char/watchdog/alim7101_wdt.c
@@ -417,10 +417,8 @@ module_init(alim7101_wdt_init);
 module_exit(alim7101_wdt_unload);
 
 static struct pci_device_id alim7101_pci_tbl[] __devinitdata = {
-	{ PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101) },
 	{ }
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
char-mxser_new-mark-init-functions.patch
char-mxser_new-remove-useless-spinlock.patch
char-serial167-cleanup.patch
char-n_r3964-cleanup.patch
char-mxser_new-remove-unused-stuff.patch
char-mxser-obsolete-old-nonexperimental-new.patch
char-mxser_new-remove-tty_wakeup-bottomhalf.patch
char-mxser_new-clean-request_irq-call.patch
doc-isicom-remove-reserved-ioctl-number.patch
char-mxser_new-alter-locking-in-isr.patch
char-mxser_new-header-file-cleanup.patch
char-mxser_new-less-loops-in-isr.patch
char-mxser_new-fix-twice-resource-releasing.patch
char-mxser_new-do-not-put-pdev.patch
char-mxser_new-upgrade-to-1915.patch
char-mxser_new-upgrade-to-1915-fix.patch
char-mxser_new-do-not-null-driver_data.patch
char-mxser_new-lock-count-and-flags.patch
char-mxser_new-fix-sparse-warning.patch
char-moxa-remove-unused-allocated-page.patch
char-moxa-do-not-initialize-global-static.patch
char-moxa-timers-cleanup.patch
char-moxa-remove-hangup-bottomhalf.patch
char-moxa-remove-unused-functions.patch
char-moxa-devids-cleanup.patch
char-moxa-use-pci_device.patch
char-moxa-eliminate-typedefs.patch
char-moxa-macros-cleanup.patch
char-moxa-use-del_timer_sync.patch
char-moxa-remove-moxa_pci_devinfo.patch
char-moxa-variables-cleanup.patch
char-moxa-remove-useless-vairables.patch
char-moxa-pci_probing-prepare.patch
char-moxa-pci-probing.patch
mxser-remove-useless-fields.patch
char-use-more-pci_device-macro.patch
char-cyclades-use-pci_device_id.patch
maintainers-remove-two-dead-e-mail.patch
shrink_slab-handle-bad-shrinkers.patch
