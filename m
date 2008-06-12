From: akpm@linux-foundation.org
Subject: - usb-cp2101c-fix-sparse-signedness-mismatch-warnings.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:37:25 -0700
Message-ID: <200806122037.m5CKbPoR005425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756184AbYFLUh3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:37:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: cp2101.c fix sparse signedness mismatch warnings
has been removed from the -mm tree.  Its filename was
     usb-cp2101c-fix-sparse-signedness-mismatch-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: cp2101.c fix sparse signedness mismatch warnings
From: Harvey Harrison <harvey.harrison@gmail.com>

The get/set 2101_config helpers take an unsigned int rather than an int. 
It is safe to change these in each case and may even produce better code
as it will be an unsigned divide rather than a signed divide in places. 
All other manipulation was setting/masking bits which will not be affected
by the sign change.

Fixes the following sparse warnings:
drivers/usb/serial/cp2101.c:378:44: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:378:44:    expected unsigned int *data
drivers/usb/serial/cp2101.c:378:44:    got int *<noident>
drivers/usb/serial/cp2101.c:388:40: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:388:40:    expected unsigned int *data
drivers/usb/serial/cp2101.c:388:40:    got int *<noident>
drivers/usb/serial/cp2101.c:413:42: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:413:42:    expected unsigned int *data
drivers/usb/serial/cp2101.c:413:42:    got int *<noident>
drivers/usb/serial/cp2101.c:421:42: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:421:42:    expected unsigned int *data
drivers/usb/serial/cp2101.c:421:42:    got int *<noident>
drivers/usb/serial/cp2101.c:444:42: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:444:42:    expected unsigned int *data
drivers/usb/serial/cp2101.c:444:42:    got int *<noident>
drivers/usb/serial/cp2101.c:451:42: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:451:42:    expected unsigned int *data
drivers/usb/serial/cp2101.c:451:42:    got int *<noident>
drivers/usb/serial/cp2101.c:458:42: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:458:42:    expected unsigned int *data
drivers/usb/serial/cp2101.c:458:42:    got int *<noident>
drivers/usb/serial/cp2101.c:471:42: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:471:42:    expected unsigned int *data
drivers/usb/serial/cp2101.c:471:42:    got int *<noident>
drivers/usb/serial/cp2101.c:481:42: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:481:42:    expected unsigned int *data
drivers/usb/serial/cp2101.c:481:42:    got int *<noident>
drivers/usb/serial/cp2101.c:561:41: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:561:41:    expected unsigned int *data
drivers/usb/serial/cp2101.c:561:41:    got int *<noident>
drivers/usb/serial/cp2101.c:591:45: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:591:45:    expected unsigned int *data
drivers/usb/serial/cp2101.c:591:45:    got int *<noident>
drivers/usb/serial/cp2101.c:597:41: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:597:41:    expected unsigned int *data
drivers/usb/serial/cp2101.c:597:41:    got int *<noident>
drivers/usb/serial/cp2101.c:608:45: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:608:45:    expected unsigned int *data
drivers/usb/serial/cp2101.c:608:45:    got int *<noident>
drivers/usb/serial/cp2101.c:614:41: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:614:41:    expected unsigned int *data
drivers/usb/serial/cp2101.c:614:41:    got int *<noident>
drivers/usb/serial/cp2101.c:623:45: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:623:45:    expected unsigned int *data
drivers/usb/serial/cp2101.c:623:45:    got int *<noident>
drivers/usb/serial/cp2101.c:680:50: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:680:50:    expected unsigned int *data
drivers/usb/serial/cp2101.c:680:50:    got int *<noident>
drivers/usb/serial/cp2101.c:690:43: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:690:43:    expected unsigned int *data
drivers/usb/serial/cp2101.c:690:43:    got int *<noident>
drivers/usb/serial/cp2101.c:715:41: warning: incorrect type in argument 3 (different signedness)
drivers/usb/serial/cp2101.c:715:41:    expected unsigned int *data
drivers/usb/serial/cp2101.c:715:41:    got int *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/cp2101.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/usb/serial/cp2101.c~usb-cp2101c-fix-sparse-signedness-mismatch-warnings drivers/usb/serial/cp2101.c
--- a/drivers/usb/serial/cp2101.c~usb-cp2101c-fix-sparse-signedness-mismatch-warnings
+++ a/drivers/usb/serial/cp2101.c
@@ -365,8 +365,8 @@ static void cp2101_close (struct usb_ser
 static void cp2101_get_termios (struct usb_serial_port *port)
 {
 	unsigned int cflag, modem_ctl[4];
-	int baud;
-	int bits;
+	unsigned int baud;
+	unsigned int bits;
 
 	dbg("%s - port %d", __func__, port->number);
 
@@ -498,7 +498,7 @@ static void cp2101_set_termios (struct u
 		struct ktermios *old_termios)
 {
 	unsigned int cflag, old_cflag;
-	int baud=0, bits;
+	unsigned int baud = 0, bits;
 	unsigned int modem_ctl[4];
 
 	dbg("%s - port %d", __func__, port->number);
@@ -654,7 +654,7 @@ static void cp2101_set_termios (struct u
 static int cp2101_tiocmset (struct usb_serial_port *port, struct file *file,
 		unsigned int set, unsigned int clear)
 {
-	int control = 0;
+	unsigned int control = 0;
 
 	dbg("%s - port %d", __func__, port->number);
 
@@ -683,7 +683,8 @@ static int cp2101_tiocmset (struct usb_s
 
 static int cp2101_tiocmget (struct usb_serial_port *port, struct file *file)
 {
-	int control, result;
+	unsigned int control;
+	int result;
 
 	dbg("%s - port %d", __func__, port->number);
 
@@ -703,7 +704,7 @@ static int cp2101_tiocmget (struct usb_s
 
 static void cp2101_break_ctl (struct usb_serial_port *port, int break_state)
 {
-	int state;
+	unsigned int state;
 
 	dbg("%s - port %d", __func__, port->number);
 	if (break_state == 0)
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch

