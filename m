From: akpm@linux-foundation.org
Subject: + char-mxser-reorder-mxser_cardinfo-fields.patch added to -mm tree
Date: Tue, 22 Jan 2008 00:52:28 -0800
Message-ID: <200801220852.m0M8q8GS013052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54120 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758269AbYAVIx0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jan 2008 03:53:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@redhat.com, jengelh@computergmbh.de


The patch titled
     Char: mxser, reorder mxser_cardinfo fields
has been added to the -mm tree.  Its filename is
     char-mxser-reorder-mxser_cardinfo-fields.patch

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
Subject: Char: mxser, reorder mxser_cardinfo fields
From: Jiri Slaby <jirislaby@gmail.com>

Reorder fields to save some memory and code on 64bit due to alignment as
suggested by Jan.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>
Reviewed-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser_new.c |   60 ++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser-reorder-mxser_cardinfo-fields drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser-reorder-mxser_cardinfo-fields
+++ a/drivers/char/mxser_new.c
@@ -106,41 +106,41 @@ static const struct {
 #define UART_INFO_NUM	ARRAY_SIZE(Gpci_uart_info)
 
 struct mxser_cardinfo {
-	unsigned int nports;
 	char *name;
+	unsigned int nports;
 	unsigned int flags;
 };
 
 static const struct mxser_cardinfo mxser_cards[] = {
-/* 0*/	{ 8, "C168 series", },
-	{ 4, "C104 series", },
-	{ 4, "CI-104J series", },
-	{ 8, "C168H/PCI series", },
-	{ 4, "C104H/PCI series", },
-/* 5*/	{ 4, "C102 series", MXSER_HAS2 },	/* C102-ISA */
-	{ 4, "CI-132 series", MXSER_HAS2 },
-	{ 4, "CI-134 series", },
-	{ 2, "CP-132 series", },
-	{ 4, "CP-114 series", },
-/*10*/	{ 4, "CT-114 series", },
-	{ 2, "CP-102 series", MXSER_HIGHBAUD },
-	{ 4, "CP-104U series", },
-	{ 8, "CP-168U series", },
-	{ 2, "CP-132U series", },
-/*15*/	{ 4, "CP-134U series", },
-	{ 4, "CP-104JU series", },
-	{ 8, "Moxa UC7000 Serial", },		/* RC7000 */
-	{ 8, "CP-118U series", },
-	{ 2, "CP-102UL series", },
-/*20*/	{ 2, "CP-102U series", },
-	{ 8, "CP-118EL series", },
-	{ 8, "CP-168EL series", },
-	{ 4, "CP-104EL series", },
-	{ 8, "CB-108 series", },
-/*25*/	{ 4, "CB-114 series", },
-	{ 4, "CB-134I series", },
-	{ 8, "CP-138U series", },
-	{ 4, "POS-104UL series", }
+/* 0*/	{ "C168 series",	8, },
+	{ "C104 series",	4, },
+	{ "CI-104J series",	4, },
+	{ "C168H/PCI series",	8, },
+	{ "C104H/PCI series",	4, },
+/* 5*/	{ "C102 series",	4, MXSER_HAS2 },	/* C102-ISA */
+	{ "CI-132 series",	4, MXSER_HAS2 },
+	{ "CI-134 series",	4, },
+	{ "CP-132 series",	2, },
+	{ "CP-114 series",	4, },
+/*10*/	{ "CT-114 series",	4, },
+	{ "CP-102 series",	2, MXSER_HIGHBAUD },
+	{ "CP-104U series",	4, },
+	{ "CP-168U series",	8, },
+	{ "CP-132U series",	2, },
+/*15*/	{ "CP-134U series",	4, },
+	{ "CP-104JU series",	4, },
+	{ "Moxa UC7000 Serial",	8, },		/* RC7000 */
+	{ "CP-118U series",	8, },
+	{ "CP-102UL series",	2, },
+/*20*/	{ "CP-102U series",	2, },
+	{ "CP-118EL series",	8, },
+	{ "CP-168EL series",	8, },
+	{ "CP-104EL series",	4, },
+	{ "CB-108 series",	8, },
+/*25*/	{ "CB-114 series",	4, },
+	{ "CB-134I series",	4, },
+	{ "CP-138U series",	8, },
+	{ "POS-104UL series",	4, }
 };
 
 /* driver_data correspond to the lines in the structure above
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
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
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
