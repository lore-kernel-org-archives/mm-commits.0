From: akpm@linux-foundation.org
Subject: - io_edgeport-cleanups-and-tty-speed-reporting.patch removed from -mm tree
Date: Wed, 24 Oct 2007 14:42:09 -0700
Message-ID: <200710242142.l9OLg9st014026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50150 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754926AbXJXVpa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 17:45:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     io_edgeport: cleanups, and tty speed reporting
has been removed from the -mm tree.  Its filename was
     io_edgeport-cleanups-and-tty-speed-reporting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: io_edgeport: cleanups, and tty speed reporting
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/io_edgeport.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/usb/serial/io_edgeport.c~io_edgeport-cleanups-and-tty-speed-reporting drivers/usb/serial/io_edgeport.c
--- a/drivers/usb/serial/io_edgeport.c~io_edgeport-cleanups-and-tty-speed-reporting
+++ a/drivers/usb/serial/io_edgeport.c
@@ -1503,22 +1503,16 @@ static void edge_unthrottle (struct usb_
  *****************************************************************************/
 static void edge_set_termios (struct usb_serial_port *port, struct ktermios *old_termios)
 {
+	/* FIXME: This function appears unused ?? */
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	struct tty_struct *tty = port->tty;
 	unsigned int cflag;
 
-	if (!port->tty || !port->tty->termios) {
-		dbg ("%s - no tty or termios", __FUNCTION__);
-		return;
-	}
-
 	cflag = tty->termios->c_cflag;
 	dbg("%s - clfag %08x iflag %08x", __FUNCTION__, 
 	    tty->termios->c_cflag, tty->termios->c_iflag);
-	if (old_termios) {
-		dbg("%s - old clfag %08x old iflag %08x", __FUNCTION__,
-		    old_termios->c_cflag, old_termios->c_iflag);
-	}
+	dbg("%s - old clfag %08x old iflag %08x", __FUNCTION__,
+	    old_termios->c_cflag, old_termios->c_iflag);
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
 
@@ -2653,7 +2647,11 @@ static void change_port_settings (struct
 
 	dbg("%s - baud rate = %d", __FUNCTION__, baud);
 	status = send_cmd_write_baud_rate (edge_port, baud);
-
+	if (status == -1) {
+		/* Speed change was not possible - put back the old speed */
+		baud = tty_termios_baud_rate(old_termios);
+		tty_encode_baud_rate(tty, baud, baud);
+	}
 	return;
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
