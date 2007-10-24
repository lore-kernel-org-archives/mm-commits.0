From: akpm@linux-foundation.org
Subject: - usb_serial-stop-passing-null-to-functions-that-expect-data.patch removed from -mm tree
Date: Wed, 24 Oct 2007 14:41:36 -0700
Message-ID: <200710242141.l9OLfaeR013969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46017 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757002AbXJXVl5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 17:41:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb_serial: stop passing NULL to functions that expect data
has been removed from the -mm tree.  Its filename was
     usb_serial-stop-passing-null-to-functions-that-expect-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usb_serial: stop passing NULL to functions that expect data
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Earlier patches have removed the checking for old v new differences from the
USB drivers so we can now pass in a valid blank old termios so that we don't
to fill the drivers with magic hacks for console support

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/serial/serial_core.c~usb_serial-stop-passing-null-to-functions-that-expect-data drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~usb_serial-stop-passing-null-to-functions-that-expect-data
+++ a/drivers/serial/serial_core.c
@@ -1875,6 +1875,7 @@ uart_set_options(struct uart_port *port,
 		 int baud, int parity, int bits, int flow)
 {
 	struct ktermios termios;
+	static struct ktermios dummy;
 	int i;
 
 	/*
@@ -1920,7 +1921,7 @@ uart_set_options(struct uart_port *port,
 	 */
 	port->mctrl |= TIOCM_DTR;
 
-	port->ops->set_termios(port, &termios, NULL);
+	port->ops->set_termios(port, &termios, &dummy);
 	co->cflag = termios.c_cflag;
 
 	return 0;
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
