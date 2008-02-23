From: akpm@linux-foundation.org
Subject: - ftdi_sio-note-missing-locking.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:23:18 -0800
Message-ID: <200802232023.m1NKNI2w013504@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763295AbYBWU32 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     ftdi_sio: Note missing locking
has been removed from the -mm tree.  Its filename was
     ftdi_sio-note-missing-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ftdi_sio: Note missing locking
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The ftdi_sio driver has no internal locking on the dtr/rts state. Flag
that up for someone to fix.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ftdi_sio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/usb/serial/ftdi_sio.c~ftdi_sio-note-missing-locking drivers/usb/serial/ftdi_sio.c
--- a/drivers/usb/serial/ftdi_sio.c~ftdi_sio-note-missing-locking
+++ a/drivers/usb/serial/ftdi_sio.c
@@ -524,9 +524,8 @@ static int update_mctrl(struct usb_seria
 	}
 
 	buf = kmalloc(1, GFP_NOIO);
-	if (!buf) {
+	if (!buf)
 		return -ENOMEM;
-	}
 
 	clear &= ~set;	/* 'set' takes precedence over 'clear' */
 	urb_value = 0;
@@ -559,6 +558,7 @@ static int update_mctrl(struct usb_seria
 				(clear & TIOCM_DTR) ? "LOW" : "unchanged",
 				(set & TIOCM_RTS) ? "HIGH" :
 				(clear & TIOCM_RTS) ? "LOW" : "unchanged");
+		/* FIXME: locking on last_dtr_rts */
 		priv->last_dtr_rts = (priv->last_dtr_rts & ~clear) | set;
 	}
 	return rv;
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
