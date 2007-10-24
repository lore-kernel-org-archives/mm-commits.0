From: akpm@linux-foundation.org
Subject: - usb-serial-handle-null-termios-methods-as-no-hardware-changing-support.patch removed from -mm tree
Date: Wed, 24 Oct 2007 14:41:59 -0700
Message-ID: <200710242141.l9OLfxgX014004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43385 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757526AbXJXVpl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 17:45:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb-serial: handle NULL termios methods as "no hardware changing support"
has been removed from the -mm tree.  Its filename was
     usb-serial-handle-null-termios-methods-as-no-hardware-changing-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usb-serial: handle NULL termios methods as "no hardware changing support"
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/usb/serial/usb-serial.c~usb-serial-handle-null-termios-methods-as-no-hardware-changing-support drivers/usb/serial/usb-serial.c
--- a/drivers/usb/serial/usb-serial.c~usb-serial-handle-null-termios-methods-as-no-hardware-changing-support
+++ a/drivers/usb/serial/usb-serial.c
@@ -429,6 +429,8 @@ static void serial_set_termios (struct t
 	/* pass on to the driver specific version of this function if it is available */
 	if (port->serial->type->set_termios)
 		port->serial->type->set_termios(port, old);
+	else
+		tty_termios_copy_hw(tty->termios, old);
 }
 
 static void serial_break (struct tty_struct *tty, int break_state)
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
