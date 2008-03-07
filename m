From: akpm@linux-foundation.org
Subject: - nozomi-prepare-for-bkl-pushdown.patch removed from -mm tree
Date: Fri, 07 Mar 2008 15:00:17 -0800
Message-ID: <200803072300.m27N0Hg1021680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757123AbYCGXBy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 18:01:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     nozomi: Prepare for BKL pushdown
has been removed from the -mm tree.  Its filename was
     nozomi-prepare-for-bkl-pushdown.patch

This patch was dropped because of rejects agaisnt Greg's tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nozomi: Prepare for BKL pushdown
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

We leave the BKL around the rts/dtr handler because there is *no* locking
of any kind on this in the driver. It's not "right" with this change but
it's the same wrong as before..

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/nozomi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/char/nozomi.c~nozomi-prepare-for-bkl-pushdown drivers/char/nozomi.c
--- a/drivers/char/nozomi.c~nozomi-prepare-for-bkl-pushdown
+++ a/drivers/char/nozomi.c
@@ -1716,6 +1716,7 @@ static int ntty_tiocmget(struct tty_stru
 static int ntty_tiocmset(struct tty_struct *tty, struct file *file,
 	unsigned int set, unsigned int clear)
 {
+	lock_kernel();		/* FIXME: Add internal locking */
 	if (set & TIOCM_RTS)
 		set_rts(tty, 1);
 	else if (clear & TIOCM_RTS)
@@ -1725,7 +1726,7 @@ static int ntty_tiocmset(struct tty_stru
 		set_dtr(tty, 1);
 	else if (clear & TIOCM_DTR)
 		set_dtr(tty, 0);
-
+	unlock_kernel();
 	return 0;
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
libata-isolate-and-rework-cable-logic.patch
pata_amd-fix-sparse-warning.patch
drivers-net-8390c-replace-init_modulecleanup_module-with-module_initmodule_exit.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
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
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
tty_io-fix-remaining-pid-struct-locking-small-cleanup.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

