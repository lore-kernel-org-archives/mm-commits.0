From: akpm@linux-foundation.org
Subject: - mxser-prepare-for-bkl-pushdown.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:56 -0700
Message-ID: <200805010927.m419RuUM030460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756282AbYEAJ2S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mxser: prepare for BKL pushdown
has been removed from the -mm tree.  Its filename was
     mxser-prepare-for-bkl-pushdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
