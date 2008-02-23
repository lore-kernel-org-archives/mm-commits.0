From: akpm@linux-foundation.org
Subject: + amiserial-prepare-for-locking-relaxation-in-caller.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:36:08 -0800
Message-ID: <200802230736.m1N7avTn018464@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756280AbYBWHyx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     amiserial: prepare for locking relaxation in caller
has been added to the -mm tree.  Its filename is
     amiserial-prepare-for-locking-relaxation-in-caller.patch

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
Subject: amiserial: prepare for locking relaxation in caller
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Just wrap this one in a lock_kernel. As I understand it there is no M68K
SMP anyway.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/amiserial.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN drivers/char/amiserial.c~amiserial-prepare-for-locking-relaxation-in-caller drivers/char/amiserial.c
--- a/drivers/char/amiserial.c~amiserial-prepare-for-locking-relaxation-in-caller
+++ a/drivers/char/amiserial.c
@@ -1074,6 +1074,7 @@ static int get_serial_info(struct async_
 	if (!retinfo)
 		return -EFAULT;
 	memset(&tmp, 0, sizeof(tmp));
+	lock_kernel();
 	tmp.type = state->type;
 	tmp.line = state->line;
 	tmp.port = state->port;
@@ -1084,6 +1085,7 @@ static int get_serial_info(struct async_
 	tmp.close_delay = state->close_delay;
 	tmp.closing_wait = state->closing_wait;
 	tmp.custom_divisor = state->custom_divisor;
+	unlock_kernel();
 	if (copy_to_user(retinfo,&tmp,sizeof(*retinfo)))
 		return -EFAULT;
 	return 0;
@@ -1099,13 +1101,17 @@ static int set_serial_info(struct async_
 
 	if (copy_from_user(&new_serial,new_info,sizeof(new_serial)))
 		return -EFAULT;
+
+	lock_kernel();
 	state = info->state;
 	old_state = *state;
   
 	change_irq = new_serial.irq != state->irq;
 	change_port = (new_serial.port != state->port);
-	if(change_irq || change_port || (new_serial.xmit_fifo_size != state->xmit_fifo_size))
+	if(change_irq || change_port || (new_serial.xmit_fifo_size != state->xmit_fifo_size)) {
+	  unlock_kernel();
 	  return -EINVAL;
+	}
   
 	if (!serial_isroot()) {
 		if ((new_serial.baud_base != state->baud_base) ||
@@ -1122,8 +1128,10 @@ static int set_serial_info(struct async_
 		goto check_and_exit;
 	}
 
-	if (new_serial.baud_base < 9600)
+	if (new_serial.baud_base < 9600) {
+		unlock_kernel();
 		return -EINVAL;
+	}
 
 	/*
 	 * OK, past this point, all the error checking has been done.
@@ -1157,6 +1165,7 @@ check_and_exit:
 		}
 	} else
 		retval = startup(info);
+	unlock_kernel();
 	return retval;
 }
 
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
