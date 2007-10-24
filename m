From: akpm@linux-foundation.org
Subject: - ch341-fix-termios-handling.patch removed from -mm tree
Date: Wed, 24 Oct 2007 14:41:43 -0700
Message-ID: <200710242141.l9OLfhTD013978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55842 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758236AbXJXVpn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 17:45:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     ch341: fix termios handling
has been removed from the -mm tree.  Its filename was
     ch341-fix-termios-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ch341: fix termios handling
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The ch341 currently doesn't support most of the hardware setting.  So to keep
the termios data right we propogate the old termios hardware values back then
encode the speed.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/usb/serial/ch341.c~ch341-fix-termios-handling drivers/usb/serial/ch341.c
--- a/drivers/usb/serial/ch341.c~ch341-fix-termios-handling
+++ a/drivers/usb/serial/ch341.c
@@ -272,9 +272,6 @@ static void ch341_set_termios(struct usb
 
 	dbg("ch341_set_termios()");
 
-	if (!tty || !tty->termios)
-		return;
-
 	baud_rate = tty_get_baud_rate(tty);
 
 	switch (baud_rate) {
@@ -299,6 +296,11 @@ static void ch341_set_termios(struct usb
 	 * (cflag & PARENB) : parity {NONE, EVEN, ODD}
 	 * (cflag & CSTOPB) : stop bits [1, 2]
 	 */
+
+	 /* Copy back the old hardware settings */
+	 tty_termios_copy_hw(tty->termios, old_termios);
+	 /* And re-encode with the new baud */
+	 tty_encode_baud_rate(tty, baud_rate, baud_rate);
 }
 
 static struct usb_driver ch341_driver = {
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
serial-keep-the-dtr-setting-for-serial-console.patch
initio-fix-conflict-when-loading-driver.patch
geode-lists-are-subscriber-only.patch
tty-kill-tty_flipbuf_size.patch
drivers-edac-turnon-edac-device-error-logging.patch
drivers-edac-use-round_jiffies_relative.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-add-freescale-mpc85xx-driver.patch
drivers-edac-add-marvell-mv64x60-driver.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
