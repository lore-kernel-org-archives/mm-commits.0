From: akpm@linux-foundation.org
Subject: + cyclades-prepare-for-relaxed-locking-in-callers.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:36:11 -0800
Message-ID: <200802230737.m1N7b0fi018467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757859AbYBWIAY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:00:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, john@stoffel.org


The patch titled
     cyclades: Prepare for relaxed locking in callers
has been added to the -mm tree.  Its filename is
     cyclades-prepare-for-relaxed-locking-in-callers.patch

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
Subject: cyclades: Prepare for relaxed locking in callers
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Basically wrap it in lock_kernel where it is hard to prove the locking is
ok.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: "John Stoffel" <john@stoffel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff -puN drivers/char/cyclades.c~cyclades-prepare-for-relaxed-locking-in-callers drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~cyclades-prepare-for-relaxed-locking-in-callers
+++ a/drivers/char/cyclades.c
@@ -3464,6 +3464,8 @@ static int cy_tiocmget(struct tty_struct
 	if (serial_paranoia_check(info, tty->name, __FUNCTION__))
 		return -ENODEV;
 
+	lock_kernel();
+
 	card = info->card;
 	channel = info->line - card->first_line;
 	if (!IS_CYC_Z(*card)) {
@@ -3506,10 +3508,12 @@ static int cy_tiocmget(struct tty_struct
 				((lstatus & C_RS_CTS) ? TIOCM_CTS : 0);
 		} else {
 			result = 0;
+			unlock_kernel();
 			return -ENODEV;
 		}
 
 	}
+	unlock_kernel();
 	return result;
 }				/* cy_tiomget */
 
@@ -3880,6 +3884,7 @@ cy_ioctl(struct tty_struct *tty, struct 
 	printk(KERN_DEBUG "cyc:cy_ioctl ttyC%d, cmd = %x arg = %lx\n",
 		info->line, cmd, arg);
 #endif
+	lock_kernel();
 
 	switch (cmd) {
 	case CYGETMON:
@@ -3988,47 +3993,47 @@ cy_ioctl(struct tty_struct *tty, struct 
 		p_cuser = argp;
 		ret_val = put_user(cnow.cts, &p_cuser->cts);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.dsr, &p_cuser->dsr);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.rng, &p_cuser->rng);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.dcd, &p_cuser->dcd);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.rx, &p_cuser->rx);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.tx, &p_cuser->tx);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.frame, &p_cuser->frame);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.overrun, &p_cuser->overrun);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.parity, &p_cuser->parity);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.brk, &p_cuser->brk);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = put_user(cnow.buf_overrun, &p_cuser->buf_overrun);
 		if (ret_val)
-			return ret_val;
+			break;
 		ret_val = 0;
 		break;
 	default:
 		ret_val = -ENOIOCTLCMD;
 	}
+	unlock_kernel();
 
 #ifdef CY_DEBUG_OTHER
 	printk(KERN_DEBUG "cyc:cy_ioctl done\n");
 #endif
-
 	return ret_val;
 }				/* cy_ioctl */
 
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
