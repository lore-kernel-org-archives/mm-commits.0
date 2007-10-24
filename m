From: akpm@linux-foundation.org
Subject: - whiteheat-clean-up-cant-happen-checks-and-encode-baud.patch removed from -mm tree
Date: Wed, 24 Oct 2007 14:42:01 -0700
Message-ID: <200710242142.l9OLg1rU014007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42766 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754501AbXJXVp3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 17:45:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     whiteheat: clean up can't happen checks and encode baud rate
has been removed from the -mm tree.  Its filename was
     whiteheat-clean-up-cant-happen-checks-and-encode-baud.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: whiteheat: clean up can't happen checks and encode baud rate
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/whiteheat.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff -puN drivers/usb/serial/whiteheat.c~whiteheat-clean-up-cant-happen-checks-and-encode-baud drivers/usb/serial/whiteheat.c
--- a/drivers/usb/serial/whiteheat.c~whiteheat-clean-up-cant-happen-checks-and-encode-baud
+++ a/drivers/usb/serial/whiteheat.c
@@ -885,16 +885,7 @@ static int whiteheat_ioctl (struct usb_s
 static void whiteheat_set_termios(struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	dbg("%s -port %d", __FUNCTION__, port->number);
-
-	if ((!port->tty) || (!port->tty->termios)) {
-		dbg("%s - no tty structures", __FUNCTION__);
-		goto exit;
-	}
-	
 	firm_setup_port(port);
-
-exit:
-	return;
 }
 
 
@@ -1244,6 +1235,8 @@ static int firm_setup_port(struct usb_se
 	port_settings.baud = tty_get_baud_rate(port->tty);
 	dbg("%s - baud rate = %d", __FUNCTION__, port_settings.baud);
 
+	/* fixme: should set validated settings */
+	tty_encode_baud_rate(port->tty, port_settings.baud, port_settings.baud);
 	/* handle any settings that aren't specified in the tty structure */
 	port_settings.lloop = 0;
 	
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
