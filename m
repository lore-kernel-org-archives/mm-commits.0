From: akpm@linux-foundation.org
Subject: - usb-serial-note-mos7480-and-option-dont-lock-modem-status.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:23:20 -0800
Message-ID: <200802232023.m1NKNKgq013507@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762589AbYBWU3i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb serial: Note mos7480 and option don't lock modem status
has been removed from the -mm tree.  Its filename was
     usb-serial-note-mos7480-and-option-dont-lock-modem-status.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb serial: Note mos7480 and option don't lock modem status
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/mos7840.c |    1 +
 drivers/usb/serial/option.c  |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/usb/serial/mos7840.c~usb-serial-note-mos7480-and-option-dont-lock-modem-status drivers/usb/serial/mos7840.c
--- a/drivers/usb/serial/mos7840.c~usb-serial-note-mos7480-and-option-dont-lock-modem-status
+++ a/drivers/usb/serial/mos7840.c
@@ -1709,6 +1709,7 @@ static int mos7840_tiocmset(struct usb_s
 	if (mos7840_port == NULL)
 		return -ENODEV;
 
+	/* FIXME: What locks the port registers ? */
 	mcr = mos7840_port->shadowMCR;
 	if (clear & TIOCM_RTS)
 		mcr &= ~MCR_RTS;
diff -puN drivers/usb/serial/option.c~usb-serial-note-mos7480-and-option-dont-lock-modem-status drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c~usb-serial-note-mos7480-and-option-dont-lock-modem-status
+++ a/drivers/usb/serial/option.c
@@ -347,6 +347,7 @@ static int option_tiocmset(struct usb_se
 
 	portdata = usb_get_serial_port_data(port);
 
+	/* FIXME: what locks portdata fields ? */
 	if (set & TIOCM_RTS)
 		portdata->rts_state = 1;
 	if (set & TIOCM_DTR)
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
