From: akpm@linux-foundation.org
Subject: - iuu_phoenix-lock-priv-tiostatus-properly.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:23:24 -0800
Message-ID: <200802232023.m1NKNOBW013513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762234AbYBWU3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     iuu_phoenix: lock priv->tiostatus properly
has been removed from the -mm tree.  Its filename was
     iuu_phoenix-lock-priv-tiostatus-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iuu_phoenix: lock priv->tiostatus properly
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/iuu_phoenix.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN drivers/usb/serial/iuu_phoenix.c~iuu_phoenix-lock-priv-tiostatus-properly drivers/usb/serial/iuu_phoenix.c
--- a/drivers/usb/serial/iuu_phoenix.c~iuu_phoenix-lock-priv-tiostatus-properly
+++ a/drivers/usb/serial/iuu_phoenix.c
@@ -148,20 +148,21 @@ static int iuu_tiocmset(struct usb_seria
 			unsigned int set, unsigned int clear)
 {
 	struct iuu_private *priv = usb_get_serial_port_data(port);
-	struct tty_struct *tty;
-	tty = port->tty;
+	unsigned long flags;
 
+	/* FIXME: locking on tiomstatus */
 	dbg("%s (%d) msg : SET = 0x%04x, CLEAR = 0x%04x ", __FUNCTION__,
 	    port->number, set, clear);
+
+	spin_lock_irqsave(&priv->lock, flags);
 	if (set & TIOCM_RTS)
 		priv->tiostatus = TIOCM_RTS;
 
 	if (!(set & TIOCM_RTS) && priv->tiostatus == TIOCM_RTS) {
 		dbg("%s TIOCMSET RESET called !!!", __FUNCTION__);
 		priv->reset = 1;
-		return 0;
 	}
-
+	spin_unlock_irqrestore(&priv->lock, flags);
 	return 0;
 }
 
@@ -173,7 +174,14 @@ static int iuu_tiocmset(struct usb_seria
 static int iuu_tiocmget(struct usb_serial_port *port, struct file *file)
 {
 	struct iuu_private *priv = usb_get_serial_port_data(port);
-	return priv->tiostatus;
+	unsigned long flags;
+	int rc;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	rc = priv->tiostatus;
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return rc;
 }
 
 static void iuu_rxcmd(struct urb *urb)
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
