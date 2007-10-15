From: akpm@linux-foundation.org
Subject: + io_edgeport-cleanups-and-tty-speed-reporting.patch added to -mm tree
Date: Mon, 15 Oct 2007 16:39:06 -0700
Message-ID: <200710152339.l9FNd6mE031262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34148 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763428AbXJOXjV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 19:39:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     io_edgeport: cleanups, and tty speed reporting
has been added to the -mm tree.  Its filename is
     io_edgeport-cleanups-and-tty-speed-reporting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
git-libata-all.patch
introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch
pcmcia-use-dma_mask_none-for-the-default-for-all.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
8250_pci-autodetect-mainpine-cards-fix.patch
wake-up-from-a-serial-port.patch
git-scsi-misc.patch
initio-fix-conflict-when-loading-driver.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
tty-bring-the-old-cris-driver-back-somewhere-into-the.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
add-config_vt_unicode.patch
keys-missing-word-in-documentation.patch
ide-cd-is-unmaintained.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
fs-correct-sus-compliance-for-open-of-large-file-without.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
usb_serial-stop-passing-null-to-functions-that-expect-data.patch
ark3116-update-termios-handling.patch
usb-serial-kill-another-case-we-pass-null-and-shouldnt.patch
ch341-fix-termios-handling.patch
digi_acceleport-fix-termios-and-also-readability-a-bit.patch
empeg-clean-up-and-handle-speeds.patch
ir_usb-termios-handling.patch
keyspan-termios-tidy.patch
kobil_sct-termios-encoding-fixups.patch
option-termios-handling.patch
sierra-termios.patch
usb-serial-handle-null-termios-methods-as-no-hardware-changing-support.patch
whiteheat-clean-up-cant-happen-checks-and-encode-baud.patch
cp2101-convert-to-new-termios.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
io_edgeport-cleanups-and-tty-speed-reporting.patch
tty-kill-tty_flipbuf_size.patch
