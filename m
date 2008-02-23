From: akpm@linux-foundation.org
Subject: - io_ti-lock-mcr-and-msr-shadows-properly.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:23:22 -0800
Message-ID: <200802232023.m1NKNMQf013510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763205AbYBWU3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     io_ti: lock mcr and msr shadows properly
has been removed from the -mm tree.  Its filename was
     io_ti-lock-mcr-and-msr-shadows-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: io_ti: lock mcr and msr shadows properly
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/io_ti.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/usb/serial/io_ti.c~io_ti-lock-mcr-and-msr-shadows-properly drivers/usb/serial/io_ti.c
--- a/drivers/usb/serial/io_ti.c~io_ti-lock-mcr-and-msr-shadows-properly
+++ a/drivers/usb/serial/io_ti.c
@@ -2560,9 +2560,11 @@ static int edge_tiocmset (struct usb_ser
 {
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	unsigned int mcr;
+	unsigned long flags;
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
 
+	spin_lock_irqsave(&edge_port->ep_lock, flags);
 	mcr = edge_port->shadow_mcr;
 	if (set & TIOCM_RTS)
 		mcr |= MCR_RTS;
@@ -2579,6 +2581,7 @@ static int edge_tiocmset (struct usb_ser
 		mcr &= ~MCR_LOOPBACK;
 
 	edge_port->shadow_mcr = mcr;
+	spin_unlock_irqrestore(&edge_port->ep_lock, flags);
 
 	TIRestoreMCR (edge_port, mcr);
 
@@ -2591,9 +2594,12 @@ static int edge_tiocmget(struct usb_seri
 	unsigned int result = 0;
 	unsigned int msr;
 	unsigned int mcr;
+	unsigned long flags;
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
 
+	spin_lock_irqsave(&edge_port->ep_lock, flags);
+
 	msr = edge_port->shadow_msr;
 	mcr = edge_port->shadow_mcr;
 	result = ((mcr & MCR_DTR)	? TIOCM_DTR: 0)	  /* 0x002 */
@@ -2605,6 +2611,7 @@ static int edge_tiocmget(struct usb_seri
 
 
 	dbg("%s -- %x", __FUNCTION__, result);
+	spin_unlock_irqrestore(&edge_port->ep_lock, flags);
 
 	return result;
 }
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
