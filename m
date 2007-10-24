From: akpm@linux-foundation.org
Subject: - digi_acceleport-fix-termios-and-also-readability-a-bit.patch removed from -mm tree
Date: Wed, 24 Oct 2007 14:41:45 -0700
Message-ID: <200710242141.l9OLfjNb013981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56083 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756431AbXJXVqF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 17:46:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     digi_acceleport: fix termios and also readability a bit
has been removed from the -mm tree.  Its filename was
     digi_acceleport-fix-termios-and-also-readability-a-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: digi_acceleport: fix termios and also readability a bit
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

- Expand some x&y to x & y so I could read it when checking
- Clear CMSPAR bit in the termios (as the driver does not support it)
- Encode the speed using the new tty_encode_baud_rate facility

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/usb/serial/digi_acceleport.c~digi_acceleport-fix-termios-and-also-readability-a-bit drivers/usb/serial/digi_acceleport.c
--- a/drivers/usb/serial/digi_acceleport.c~digi_acceleport-fix-termios-and-also-readability-a-bit
+++ a/drivers/usb/serial/digi_acceleport.c
@@ -973,6 +973,8 @@ static void digi_set_termios(struct usb_
 		}
 	}
 	/* set parity */
+	tty->termios->c_cflag &= ~CMSPAR;
+
 	if ((cflag&(PARENB|PARODD)) != (old_cflag&(PARENB|PARODD))) {
 		if (cflag&PARENB) {
 			if (cflag&PARODD)
@@ -1054,15 +1056,15 @@ static void digi_set_termios(struct usb_
 	}
 
 	/* set output flow control */
-	if ((iflag&IXON) != (old_iflag&IXON)
-	    || (cflag&CRTSCTS) != (old_cflag&CRTSCTS)) {
+	if ((iflag & IXON) != (old_iflag & IXON)
+	    || (cflag & CRTSCTS) != (old_cflag & CRTSCTS)) {
 		arg = 0;
-		if (iflag&IXON)
+		if (iflag & IXON)
 			arg |= DIGI_OUTPUT_FLOW_CONTROL_XON_XOFF;
 		else
 			arg &= ~DIGI_OUTPUT_FLOW_CONTROL_XON_XOFF;
 
-		if (cflag&CRTSCTS) {
+		if (cflag & CRTSCTS) {
 			arg |= DIGI_OUTPUT_FLOW_CONTROL_CTS;
 		} else {
 			arg &= ~DIGI_OUTPUT_FLOW_CONTROL_CTS;
@@ -1076,8 +1078,8 @@ static void digi_set_termios(struct usb_
 	}
 
 	/* set receive enable/disable */
-	if ((cflag&CREAD) != (old_cflag&CREAD)) {
-		if (cflag&CREAD)
+	if ((cflag & CREAD) != (old_cflag & CREAD)) {
+		if (cflag & CREAD)
 			arg = DIGI_ENABLE;
 		else
 			arg = DIGI_DISABLE;
@@ -1089,7 +1091,7 @@ static void digi_set_termios(struct usb_
 	}
 	if ((ret = digi_write_oob_command(port, buf, i, 1)) != 0)
 		dbg("digi_set_termios: write oob failed, ret=%d", ret);
-
+	tty_encode_baud_rate(tty, baud, baud);
 }
 
 
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
