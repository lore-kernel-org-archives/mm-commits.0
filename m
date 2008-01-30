From: akpm@linux-foundation.org
Subject: + char-applicom-use-pci_match_id.patch added to -mm tree
Date: Wed, 30 Jan 2008 15:02:05 -0800
Message-ID: <200801302302.m0UN2BCL029215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47895 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763546AbYA3XDP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jan 2008 18:03:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, dwmw2@infradead.org, xiyou.wangcong@gmail.com


The patch titled
     Char: applicom, use pci_match_id
has been added to the -mm tree.  Its filename is
     char-applicom-use-pci_match_id.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: applicom, use pci_match_id
From: Jiri Slaby <jirislaby@gmail.com>

Instead of testing hardcoded values, use pci_match_id to reference the
pci_device_id table. Sideways, it allows easy new additions to the table.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/applicom.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN drivers/char/applicom.c~char-applicom-use-pci_match_id drivers/char/applicom.c
--- a/drivers/char/applicom.c~char-applicom-use-pci_match_id
+++ a/drivers/char/applicom.c
@@ -57,7 +57,6 @@
 #define PCI_DEVICE_ID_APPLICOM_PCI2000IBS_CAN 0x0002
 #define PCI_DEVICE_ID_APPLICOM_PCI2000PFB     0x0003
 #endif
-#define MAX_PCI_DEVICE_NUM 3
 
 static char *applicom_pci_devnames[] = {
 	"PCI board",
@@ -66,12 +65,9 @@ static char *applicom_pci_devnames[] = {
 };
 
 static struct pci_device_id applicom_pci_tbl[] = {
-	{ PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCIGENERIC,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	{ PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCI2000IBS_CAN,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	{ PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCI2000PFB,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_VDEVICE(APPLICOM, PCI_DEVICE_ID_APPLICOM_PCIGENERIC) },
+	{ PCI_VDEVICE(APPLICOM, PCI_DEVICE_ID_APPLICOM_PCI2000IBS_CAN) },
+	{ PCI_VDEVICE(APPLICOM, PCI_DEVICE_ID_APPLICOM_PCI2000PFB) },
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, applicom_pci_tbl);
@@ -197,10 +193,7 @@ static int __init applicom_init(void)
 
 	while ( (dev = pci_get_class(PCI_CLASS_OTHERS << 16, dev))) {
 
-		if (dev->vendor != PCI_VENDOR_ID_APPLICOM)
-			continue;
-		
-		if (dev->device  > MAX_PCI_DEVICE_NUM || dev->device == 0)
+		if (!pci_match_id(applicom_pci_tbl, dev));
 			continue;
 		
 		if (pci_enable_device(dev))
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-net.patch
git-watchdog.patch
capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check.patch
maintainers-order-auerswald-alphabetically.patch
phantom-dont-grab-other-devices.patch
driver-ip27-rtc-convert-ioctl-to-unlocked_ioctl-v2.patch
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
char-mxser-remove-special-baudrate-processing.patch
char-mxser-0-to-null-in-pointer.patch
char-mxser-reorder-mxser_cardinfo-fields.patch
char-mxser-simplify-mxser_get_serial_info.patch
char-mxser-ioctl-cleanup.patch
char-mxser-remove-it.patch
char-mxser-add-support-for-cp-114ul.patch
moxa-first-pass-at-termios-reporting.patch
char-applicom-use-pci_resource_start.patch
char-applicom-use-pci_match_id.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
