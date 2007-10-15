From: akpm@linux-foundation.org
Subject: + whiteheat-clean-up-cant-happen-checks-and-encode-baud.patch added to -mm tree
Date: Mon, 15 Oct 2007 16:37:35 -0700
Message-ID: <200710152337.l9FNbZGQ031149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40495 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025AbXJOXhw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 19:37:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     whiteheat: clean up can't happen checks and encode baud rate
has been added to the -mm tree.  Its filename is
     whiteheat-clean-up-cant-happen-checks-and-encode-baud.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
io_edgeport-cleanups-and-tty-speed-reporting.patch
tty-kill-tty_flipbuf_size.patch
