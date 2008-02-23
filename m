From: akpm@linux-foundation.org
Subject: + mxser-prepare-for-bkl-pushdown.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:36:21 -0800
Message-ID: <200802230737.m1N7bAg2018491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754520AbYBWIB0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:01:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com


The patch titled
     mxser: prepare for BKL pushdown
has been added to the -mm tree.  Its filename is
     mxser-prepare-for-bkl-pushdown.patch

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
Subject: mxser: prepare for BKL pushdown
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Push the BKL down into various internal routines in the driver ready to
remove it from the break, ioctl and other call points.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |   63 ++++++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 25 deletions(-)

diff -puN drivers/char/mxser.c~mxser-prepare-for-bkl-pushdown drivers/char/mxser.c
--- a/drivers/char/mxser.c~mxser-prepare-for-bkl-pushdown
+++ a/drivers/char/mxser.c
@@ -1460,6 +1460,7 @@ static int mxser_ioctl_special(unsigned 
 	struct mxser_port *port;
 	int result, status;
 	unsigned int i, j;
+	int ret = 0;
 
 	switch (cmd) {
 	case MOXA_GET_MAJOR:
@@ -1467,18 +1468,21 @@ static int mxser_ioctl_special(unsigned 
 
 	case MOXA_CHKPORTENABLE:
 		result = 0;
-
+		lock_kernel();
 		for (i = 0; i < MXSER_BOARDS; i++)
 			for (j = 0; j < MXSER_PORTS_PER_BOARD; j++)
 				if (mxser_boards[i].ports[j].ioaddr)
 					result |= (1 << i);
-
+		unlock_kernel();
 		return put_user(result, (unsigned long __user *)argp);
 	case MOXA_GETDATACOUNT:
+		lock_kernel();
 		if (copy_to_user(argp, &mxvar_log, sizeof(mxvar_log)))
-			return -EFAULT;
-		return 0;
+			ret = -EFAULT;
+		unlock_kernel();
+		return ret;
 	case MOXA_GETMSTATUS:
+		lock_kernel();
 		for (i = 0; i < MXSER_BOARDS; i++)
 			for (j = 0; j < MXSER_PORTS_PER_BOARD; j++) {
 				port = &mxser_boards[i].ports[j];
@@ -1515,6 +1519,7 @@ static int mxser_ioctl_special(unsigned 
 				else
 					GMStatus[i].cts = 0;
 			}
+		unlock_kernel();
 		if (copy_to_user(argp, GMStatus,
 				sizeof(struct mxser_mstatus) * MXSER_PORTS))
 			return -EFAULT;
@@ -1524,7 +1529,8 @@ static int mxser_ioctl_special(unsigned 
 		unsigned long opmode;
 		unsigned cflag, iflag;
 
-		for (i = 0; i < MXSER_BOARDS; i++)
+		lock_kernel();
+		for (i = 0; i < MXSER_BOARDS; i++) {
 			for (j = 0; j < MXSER_PORTS_PER_BOARD; j++) {
 				port = &mxser_boards[i].ports[j];
 				if (!port->ioaddr)
@@ -1589,13 +1595,14 @@ static int mxser_ioctl_special(unsigned 
 				mon_data_ext.iftype[i] = opmode;
 
 			}
-			if (copy_to_user(argp, &mon_data_ext,
-						sizeof(mon_data_ext)))
-				return -EFAULT;
-
-			return 0;
-
-	} default:
+		}
+		unlock_kernel();
+		if (copy_to_user(argp, &mon_data_ext,
+					sizeof(mon_data_ext)))
+			return -EFAULT;
+		return 0;
+	}
+	default:
 		return -ENOIOCTLCMD;
 	}
 	return 0;
@@ -1651,16 +1658,20 @@ static int mxser_ioctl(struct tty_struct
 					opmode != RS422_MODE &&
 					opmode != RS485_4WIRE_MODE)
 				return -EFAULT;
+			lock_kernel();
 			mask = ModeMask[p];
 			shiftbit = p * 2;
 			val = inb(info->opmode_ioaddr);
 			val &= mask;
 			val |= (opmode << shiftbit);
 			outb(val, info->opmode_ioaddr);
+			unlock_kernel();
 		} else {
+			lock_kernel();
 			shiftbit = p * 2;
 			opmode = inb(info->opmode_ioaddr) >> shiftbit;
 			opmode &= OP_MODE_MASK;
+			unlock_kernel();
 			if (put_user(opmode, (int __user *)argp))
 				return -EFAULT;
 		}
@@ -1687,19 +1698,18 @@ static int mxser_ioctl(struct tty_struct
 		tty_wait_until_sent(tty, 0);
 		mxser_send_break(info, arg ? arg * (HZ / 10) : HZ / 4);
 		return 0;
-	case TIOCGSOFTCAR:
-		return put_user(!!C_CLOCAL(tty), (unsigned long __user *)argp);
-	case TIOCSSOFTCAR:
-		if (get_user(arg, (unsigned long __user *)argp))
-			return -EFAULT;
-		tty->termios->c_cflag = ((tty->termios->c_cflag & ~CLOCAL) | (arg ? CLOCAL : 0));
-		return 0;
 	case TIOCGSERIAL:
-		return mxser_get_serial_info(info, argp);
+		lock_kernel();
+		retval = mxser_get_serial_info(info, argp);
+		unlock_kernel();
+		return retval;
 	case TIOCSSERIAL:
-		return mxser_set_serial_info(info, argp);
+		lock_kernel();
+		retval = mxser_set_serial_info(info, argp);
+		unlock_kernel();
+		return retval;
 	case TIOCSERGETLSR:	/* Get line status register */
-		return mxser_get_lsr_info(info, argp);
+		return  mxser_get_lsr_info(info, argp);
 		/*
 		 * Wait for any of the 4 modem inputs (DCD,RI,DSR,CTS) to change
 		 * - mask passed in arg for lines of interest
@@ -1746,24 +1756,27 @@ static int mxser_ioctl(struct tty_struct
 	case MOXA_HighSpeedOn:
 		return put_user(info->baud_base != 115200 ? 1 : 0, (int __user *)argp);
 	case MOXA_SDS_RSTICOUNTER:
+		lock_kernel();
 		info->mon_data.rxcnt = 0;
 		info->mon_data.txcnt = 0;
+		unlock_kernel();
 		return 0;
 
 	case MOXA_ASPP_OQUEUE:{
 		int len, lsr;
 
+		lock_kernel();
 		len = mxser_chars_in_buffer(tty);
-
 		lsr = inb(info->ioaddr + UART_LSR) & UART_LSR_TEMT;
-
 		len += (lsr ? 0 : 1);
+		unlock_kernel();
 
 		return put_user(len, (int __user *)argp);
 	}
 	case MOXA_ASPP_MON: {
 		int mcr, status;
 
+		lock_kernel();
 		status = mxser_get_msr(info->ioaddr, 1, tty->index);
 		mxser_check_modem_status(info, status);
 
@@ -1782,7 +1795,7 @@ static int mxser_ioctl(struct tty_struct
 			info->mon_data.hold_reason |= NPPI_NOTIFY_CTSHOLD;
 		else
 			info->mon_data.hold_reason &= ~NPPI_NOTIFY_CTSHOLD;
-
+		unlock_kernel();
 		if (copy_to_user(argp, &info->mon_data,
 				sizeof(struct mxser_mon)))
 			return -EFAULT;
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
