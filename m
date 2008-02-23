From: akpm@linux-foundation.org
Subject: - kobil_sct-get-rid-of-unneeded-priv-line_state.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:23:26 -0800
Message-ID: <200802232023.m1NKNQ7Y013516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763271AbYBWU3V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kobil_sct: Get rid of unneeded priv->line_state
has been removed from the -mm tree.  Its filename was
     kobil_sct-get-rid-of-unneeded-priv-line_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kobil_sct: Get rid of unneeded priv->line_state
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/kobil_sct.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN drivers/usb/serial/kobil_sct.c~kobil_sct-get-rid-of-unneeded-priv-line_state drivers/usb/serial/kobil_sct.c
--- a/drivers/usb/serial/kobil_sct.c~kobil_sct-get-rid-of-unneeded-priv-line_state
+++ a/drivers/usb/serial/kobil_sct.c
@@ -139,7 +139,6 @@ struct kobil_private {
 	int filled;  // index of the last char in buf
 	int cur_pos; // index of the next char to send in buf
 	__u16 device_type;
-	int line_state;
 };
 
 
@@ -161,7 +160,6 @@ static int kobil_startup (struct usb_ser
 	priv->filled = 0;
 	priv->cur_pos = 0;
 	priv->device_type = le16_to_cpu(serial->dev->descriptor.idProduct);
-	priv->line_state = 0;
 
 	switch (priv->device_type){
 	case KOBIL_ADAPTER_B_PRODUCT_ID:
@@ -226,7 +224,6 @@ static int kobil_open (struct usb_serial
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
 	priv = usb_get_serial_port_data(port);
-	priv->line_state = 0;
 
 	// someone sets the dev to 0 if the close method has been called
 	port->interrupt_in_urb->dev = port->serial->dev;
@@ -524,14 +521,11 @@ static int kobil_tiocmget(struct usb_ser
 	dbg("%s - port %d Send get_status_line_state URB returns: %i. Statusline: %02x", 
 	    __FUNCTION__, port->number, result, transfer_buffer[0]);
 
-	if ((transfer_buffer[0] & SUSBCR_GSL_DSR) != 0) {
-		priv->line_state |= TIOCM_DSR;
-	} else {
-		priv->line_state &= ~TIOCM_DSR; 
-	}
-
+	result = 0;
+	if ((transfer_buffer[0] & SUSBCR_GSL_DSR) != 0)
+		result = TIOCM_DSR;
 	kfree(transfer_buffer);
-	return priv->line_state;
+	return result;
 }
 
 static int  kobil_tiocmset(struct usb_serial_port *port, struct file *file,
@@ -544,6 +538,7 @@ static int  kobil_tiocmset(struct usb_se
 	unsigned char *transfer_buffer;
 	int transfer_buffer_length = 8;
 
+	/* FIXME: locking ? */
 	priv = usb_get_serial_port_data(port);
 	if ((priv->device_type == KOBIL_USBTWIN_PRODUCT_ID) || (priv->device_type == KOBIL_KAAN_SIM_PRODUCT_ID)) {
 		// This device doesn't support ioctl calls
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
libata-isolate-and-rework-cable-logic.patch
pata_amd-fix-sparse-warning.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
git-scsi-rc-fixes.patch
crisv10-prepare-for-bkl-push-down.patch
fix-tty-speed-handling-on-8250.patch
uart_get_baud_rate-stop-mangling-termios.patch
do_task_stat-dont-take-rcu_read_lock.patch
amiserial-prepare-for-locking-relaxation-in-caller.patch
cyclades-prepare-for-relaxed-locking-in-callers.patch
epca-lock_kernel-push-down.patch
esp-lock_kernel-push-down.patch
isicom-prepare-for-lock_kernel-push-down.patch
isicom-istallion-prepare-for-lock_kernel-pushdown.patch
mxser-prepare-for-bkl-pushdown.patch
nozomi-prepare-for-bkl-pushdown.patch
riscom8-prepare-for-bkl-pushdown.patch
rocket-prepare-for-bkl-pushdown.patch
serial167-prepare-to-push-bkl-down-into-drivers.patch
specialix-prepare-for-bkl-pushdown.patch
stallion-prepare-for-bkl-push-down.patch
sx-prepare-for-bkl-pushdown.patch
synclink-series-prepare-for-bkl-pushdown.patch
viocons-bkl-locking.patch
vt_ioctl-prepare-for-bkl-push-down.patch
isdn_tty-prepare-for-bkl-push-down.patch
68360serial-note-that-there-isnt-any-info-mcr-locking.patch
serial_core-prepare-for-bkl-push-down.patch
tty-bkl-pushdown.patch
tty-bkl-pushdown-fix1.patch
redo-locking-of-tty-pgrp.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch
