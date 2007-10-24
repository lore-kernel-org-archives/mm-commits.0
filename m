From: akpm@linux-foundation.org
Subject: - kobil_sct-termios-encoding-fixups.patch removed from -mm tree
Date: Wed, 24 Oct 2007 14:41:53 -0700
Message-ID: <200710242141.l9OLfrb2013995@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38292 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757304AbXJXVpl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 17:45:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     kobil_sct: termios encoding fixups
has been removed from the -mm tree.  Its filename was
     kobil_sct-termios-encoding-fixups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kobil_sct: termios encoding fixups
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

- Clear unsupported CMSPAR
- Encode resulting speeds

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/usb/serial/kobil_sct.c~kobil_sct-termios-encoding-fixups drivers/usb/serial/kobil_sct.c
--- a/drivers/usb/serial/kobil_sct.c~kobil_sct-termios-encoding-fixups
+++ a/drivers/usb/serial/kobil_sct.c
@@ -616,8 +616,9 @@ static void kobil_set_termios(struct usb
 		case 1200:
 			urb_val = SUSBCR_SBR_1200;
 			break;
-		case 9600:
 		default:
+			speed = 9600;
+		case 9600:
 			urb_val = SUSBCR_SBR_9600;
 			break;
 	}
@@ -641,6 +642,8 @@ static void kobil_set_termios(struct usb
 		urb_val |= SUSBCR_SPASB_NoParity;
 		strcat(settings, "No Parity");
 	}
+	port->tty->termios->c_cflag &= ~CMSPAR;
+	tty_encode_baud_rate(port->tty, speed, speed);
 
 	result = usb_control_msg( port->serial->dev,
 				  usb_rcvctrlpipe(port->serial->dev, 0 ),
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
