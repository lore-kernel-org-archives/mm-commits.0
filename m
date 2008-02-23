From: akpm@linux-foundation.org
Subject: - usb-serial-prepare-for-bkl-push-down.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:23:16 -0800
Message-ID: <200802232023.m1NKNGST013501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763171AbYBWU3v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb-serial: Prepare for BKL push down
has been removed from the -mm tree.  Its filename was
     usb-serial-prepare-for-bkl-push-down.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb-serial: Prepare for BKL push down
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Take the lock in usb-serial instead. As it relies on the BKL internally
we can't push it any deeper yet.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/usb-serial.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN drivers/usb/serial/usb-serial.c~usb-serial-prepare-for-bkl-push-down drivers/usb/serial/usb-serial.c
--- a/drivers/usb/serial/usb-serial.c~usb-serial-prepare-for-bkl-push-down
+++ a/drivers/usb/serial/usb-serial.c
@@ -401,11 +401,13 @@ static int serial_ioctl (struct tty_stru
 	struct usb_serial_port *port = tty->driver_data;
 	int retval = -ENODEV;
 
+	lock_kernel();
 	if (!port)
 		goto exit;
 
 	dbg("%s - port %d, cmd 0x%.4x", __FUNCTION__, port->number, cmd);
 
+	/* Caution - port->open_count is BKL protected */
 	if (!port->open_count) {
 		dbg ("%s - port not open", __FUNCTION__);
 		goto exit;
@@ -416,8 +418,8 @@ static int serial_ioctl (struct tty_stru
 		retval = port->serial->type->ioctl(port, file, cmd, arg);
 	else
 		retval = -ENOIOCTLCMD;
-
 exit:
+	unlock_kernel();
 	return retval;
 }
 
@@ -446,19 +448,24 @@ static void serial_break (struct tty_str
 {
 	struct usb_serial_port *port = tty->driver_data;
 
-	if (!port)
+	lock_kernel();
+	if (!port) {
+		unlock_kernel();
 		return;
+	}
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
 
 	if (!port->open_count) {
 		dbg("%s - port not open", __FUNCTION__);
+		unlock_kernel();
 		return;
 	}
 
 	/* pass on to the driver specific version of this function if it is available */
 	if (port->serial->type->break_ctl)
 		port->serial->type->break_ctl(port, break_state);
+	unlock_kernel();
 }
 
 static int serial_read_proc (char *page, char **start, off_t off, int count, int *eof, void *data)
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
