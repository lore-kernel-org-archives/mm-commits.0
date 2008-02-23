From: akpm@linux-foundation.org
Subject: + crisv10-prepare-for-bkl-push-down.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:33:15 -0800
Message-ID: <200802230734.m1N7Y4Qf018271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751393AbYBWH43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:56:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mikael.starvik@axis.com


The patch titled
     crisv10: prepare for BKL push down
has been added to the -mm tree.  Its filename is
     crisv10-prepare-for-bkl-push-down.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: crisv10: prepare for BKL push down
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Just the modem bits this time

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/crisv10.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/serial/crisv10.c~crisv10-prepare-for-bkl-push-down drivers/serial/crisv10.c
--- a/drivers/serial/crisv10.c~crisv10-prepare-for-bkl-push-down
+++ a/drivers/serial/crisv10.c
@@ -3582,6 +3582,8 @@ rs_tiocmset(struct tty_struct *tty, stru
 {
 	struct e100_serial *info = (struct e100_serial *)tty->driver_data;
 
+	lock_kernel();
+
 	if (clear & TIOCM_RTS)
 		e100_rts(info, 0);
 	if (clear & TIOCM_DTR)
@@ -3601,6 +3603,8 @@ rs_tiocmset(struct tty_struct *tty, stru
 		e100_ri_out(info, 1);
 	if (set & TIOCM_CD)
 		e100_cd_out(info, 1);
+
+	unlock_kernel();
 	return 0;
 }
 
@@ -3610,6 +3614,7 @@ rs_tiocmget(struct tty_struct *tty, stru
 	struct e100_serial *info = (struct e100_serial *)tty->driver_data;
 	unsigned int result;
 
+	lock_kernel();
 	result =
 		(!E100_RTS_GET(info) ? TIOCM_RTS : 0)
 		| (!E100_DTR_GET(info) ? TIOCM_DTR : 0)
@@ -3618,6 +3623,8 @@ rs_tiocmget(struct tty_struct *tty, stru
 		| (!E100_CD_GET(info) ? TIOCM_CAR : 0)
 		| (!E100_CTS_GET(info) ? TIOCM_CTS : 0);
 
+	unlock_kernel();
+
 #ifdef SERIAL_DEBUG_IO
 	printk(KERN_DEBUG "ser%i: modem state: %i 0x%08X\n",
 		info->line, result, result);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
libata-isolate-and-rework-cable-logic.patch
pata_amd-fix-sparse-warning.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
megaraid-outb_p-extermination.patch
usb-serial-prepare-for-bkl-push-down.patch
ftdi_sio-note-missing-locking.patch
usb-serial-note-mos7480-and-option-dont-lock-modem-status.patch
io_ti-lock-mcr-and-msr-shadows-properly.patch
iuu_phoenix-lock-priv-tiostatus-properly.patch
kobil_sct-get-rid-of-unneeded-priv-line_state.patch
ti_usb_3410_5052-extend-locking-to-msr-and-shadow-mcr.patch
git-watchdog.patch
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
