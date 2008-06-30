From: akpm@linux-foundation.org
Subject: + char-mxser-globals-cleanup.patch added to -mm tree
Date: Mon, 30 Jun 2008 14:21:32 -0700
Message-ID: <200806302121.m5ULLgkT025994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762073AbYF3VWa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 17:22:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@redhat.com


The patch titled
     Char: mxser, globals cleanup
has been added to the -mm tree.  Its filename is
     char-mxser-globals-cleanup.patch

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
Subject: Char: mxser, globals cleanup
From: Jiri Slaby <jirislaby@gmail.com>

- remove unused mxvar_diagflag
- move mxser_msr into the only user/function
- GMStatus, hmm, fix race-prone access to it. We need only one instance for
  real, not MXSER_PORTS. Move it to MOXA_GETMSTATUS ioctl.
- mxser_mon_ext, almost the same, but alloc it on heap, since it has more than
  2 kilos.
- fix indexing, `i' is not the index value, `i * MXSER_PORTS_PER_BOARD + j' is

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |  130 +++++++++++++++++------------------------
 1 file changed, 55 insertions(+), 75 deletions(-)

diff -puN drivers/char/mxser.c~char-mxser-globals-cleanup drivers/char/mxser.c
--- a/drivers/char/mxser.c~char-mxser-globals-cleanup
+++ a/drivers/char/mxser.c
@@ -291,8 +291,6 @@ struct mxser_mstatus {
 	int dcd;
 };
 
-static struct mxser_mstatus GMStatus[MXSER_PORTS];
-
 static int mxserBoardCAP[MXSER_BOARDS] = {
 	0, 0, 0, 0
 	/*  0x180, 0x280, 0x200, 0x320 */
@@ -301,9 +299,6 @@ static int mxserBoardCAP[MXSER_BOARDS] =
 static struct mxser_board mxser_boards[MXSER_BOARDS];
 static struct tty_driver *mxvar_sdriver;
 static struct mxser_log mxvar_log;
-static int mxvar_diagflag;
-static unsigned char mxser_msr[MXSER_PORTS + 1];
-static struct mxser_mon_ext mon_data_ext;
 static int mxser_set_baud_method[MXSER_PORTS + 1];
 
 static void mxser_enable_must_enchance_mode(unsigned long baseio)
@@ -547,6 +542,7 @@ static void process_txrx_fifo(struct mxs
 
 static unsigned char mxser_get_msr(int baseaddr, int mode, int port)
 {
+	static unsigned char mxser_msr[MXSER_PORTS + 1];
 	unsigned char status = 0;
 
 	status = inb(baseaddr + UART_MSR);
@@ -1659,62 +1655,60 @@ static int mxser_ioctl_special(unsigned 
 			ret = -EFAULT;
 		unlock_kernel();
 		return ret;
-	case MOXA_GETMSTATUS:
+	case MOXA_GETMSTATUS: {
+		struct mxser_mstatus ms, __user *msu = argp;
 		lock_kernel();
 		for (i = 0; i < MXSER_BOARDS; i++)
 			for (j = 0; j < MXSER_PORTS_PER_BOARD; j++) {
 				port = &mxser_boards[i].ports[j];
+				memset(&ms, 0, sizeof(ms));
 
-				GMStatus[i].ri = 0;
-				if (!port->ioaddr) {
-					GMStatus[i].dcd = 0;
-					GMStatus[i].dsr = 0;
-					GMStatus[i].cts = 0;
-					continue;
-				}
+				if (!port->ioaddr)
+					goto copy;
 
 				if (!port->tty || !port->tty->termios)
-					GMStatus[i].cflag =
-						port->normal_termios.c_cflag;
+					ms.cflag = port->normal_termios.c_cflag;
 				else
-					GMStatus[i].cflag =
-						port->tty->termios->c_cflag;
+					ms.cflag = port->tty->termios->c_cflag;
 
 				status = inb(port->ioaddr + UART_MSR);
-				if (status & 0x80 /*UART_MSR_DCD */ )
-					GMStatus[i].dcd = 1;
-				else
-					GMStatus[i].dcd = 0;
-
-				if (status & 0x20 /*UART_MSR_DSR */ )
-					GMStatus[i].dsr = 1;
-				else
-					GMStatus[i].dsr = 0;
-
-
-				if (status & 0x10 /*UART_MSR_CTS */ )
-					GMStatus[i].cts = 1;
-				else
-					GMStatus[i].cts = 0;
+				if (status & UART_MSR_DCD)
+					ms.dcd = 1;
+				if (status & UART_MSR_DSR)
+					ms.dsr = 1;
+				if (status & UART_MSR_CTS)
+					ms.cts = 1;
+			copy:
+				if (copy_to_user(msu, &ms, sizeof(ms))) {
+					unlock_kernel();
+					return -EFAULT;
+				}
+				msu++;
 			}
 		unlock_kernel();
-		if (copy_to_user(argp, GMStatus,
-				sizeof(struct mxser_mstatus) * MXSER_PORTS))
-			return -EFAULT;
 		return 0;
+	}
 	case MOXA_ASPP_MON_EXT: {
-		int p, shiftbit;
-		unsigned long opmode;
-		unsigned cflag, iflag;
+		struct mxser_mon_ext *me; /* it's 2k, stack unfriendly */
+		unsigned int cflag, iflag, p;
+		u8 opmode;
+
+		me = kzalloc(sizeof(*me), GFP_KERNEL);
+		if (!me)
+			return -ENOMEM;
 
 		lock_kernel();
-		for (i = 0; i < MXSER_BOARDS; i++) {
-			for (j = 0; j < MXSER_PORTS_PER_BOARD; j++) {
+		for (i = 0, p = 0; i < MXSER_BOARDS; i++) {
+			for (j = 0; j < MXSER_PORTS_PER_BOARD; j++, p++) {
+				if (p >= ARRAY_SIZE(me->rx_cnt)) {
+					i = MXSER_BOARDS;
+					break;
+				}
 				port = &mxser_boards[i].ports[j];
 				if (!port->ioaddr)
 					continue;
 
-				status = mxser_get_msr(port->ioaddr, 0, i);
+				status = mxser_get_msr(port->ioaddr, 0, p);
 
 				if (status & UART_MSR_TERI)
 					port->icount.rng++;
@@ -1726,16 +1720,13 @@ static int mxser_ioctl_special(unsigned 
 					port->icount.cts++;
 
 				port->mon_data.modem_status = status;
-				mon_data_ext.rx_cnt[i] = port->mon_data.rxcnt;
-				mon_data_ext.tx_cnt[i] = port->mon_data.txcnt;
-				mon_data_ext.up_rxcnt[i] =
-					port->mon_data.up_rxcnt;
-				mon_data_ext.up_txcnt[i] =
-					port->mon_data.up_txcnt;
-				mon_data_ext.modem_status[i] =
+				me->rx_cnt[p] = port->mon_data.rxcnt;
+				me->tx_cnt[p] = port->mon_data.txcnt;
+				me->up_rxcnt[p] = port->mon_data.up_rxcnt;
+				me->up_txcnt[p] = port->mon_data.up_txcnt;
+				me->modem_status[p] =
 					port->mon_data.modem_status;
-				mon_data_ext.baudrate[i] =
-					tty_get_baud_rate(port->tty);
+				me->baudrate[p] = tty_get_baud_rate(port->tty);
 
 				if (!port->tty || !port->tty->termios) {
 					cflag = port->normal_termios.c_cflag;
@@ -1745,40 +1736,31 @@ static int mxser_ioctl_special(unsigned 
 					iflag = port->tty->termios->c_iflag;
 				}
 
-				mon_data_ext.databits[i] = cflag & CSIZE;
-
-				mon_data_ext.stopbits[i] = cflag & CSTOPB;
-
-				mon_data_ext.parity[i] =
-					cflag & (PARENB | PARODD | CMSPAR);
-
-				mon_data_ext.flowctrl[i] = 0x00;
+				me->databits[p] = cflag & CSIZE;
+				me->stopbits[p] = cflag & CSTOPB;
+				me->parity[p] = cflag & (PARENB | PARODD |
+						CMSPAR);
 
 				if (cflag & CRTSCTS)
-					mon_data_ext.flowctrl[i] |= 0x03;
+					me->flowctrl[p] |= 0x03;
 
 				if (iflag & (IXON | IXOFF))
-					mon_data_ext.flowctrl[i] |= 0x0C;
+					me->flowctrl[p] |= 0x0C;
 
 				if (port->type == PORT_16550A)
-					mon_data_ext.fifo[i] = 1;
-				else
-					mon_data_ext.fifo[i] = 0;
+					me->fifo[p] = 1;
 
-				p = i % 4;
-				shiftbit = p * 2;
-				opmode = inb(port->opmode_ioaddr) >> shiftbit;
+				opmode = inb(port->opmode_ioaddr) >>
+						((p % 4) * 2);
 				opmode &= OP_MODE_MASK;
-
-				mon_data_ext.iftype[i] = opmode;
-
+				me->iftype[p] = opmode;
 			}
 		}
 		unlock_kernel();
-		if (copy_to_user(argp, &mon_data_ext,
-					sizeof(mon_data_ext)))
-			return -EFAULT;
-		return 0;
+		if (copy_to_user(argp, me, sizeof(*me)))
+			ret = -EFAULT;
+		kfree(me);
+		return ret;
 	}
 	default:
 		return -ENOIOCTLCMD;
@@ -2809,8 +2791,6 @@ static int __init mxser_module_init(void
 		goto err_put;
 	}
 
-	mxvar_diagflag = 0;
-
 	m = 0;
 	/* Start finding ISA boards here */
 	for (isaloop = 0; isaloop < 2; isaloop++)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
serial-z85c30-avoid-a-hang-at-console-switch-over.patch
serial-dz11-avoid-a-hang-at-console-switch-over.patch
vt-hold-console_sem-across-sysfs-operations.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
dsp56k-bkl-pushdown.patch
char-mxser-ioctl-cleanup.patch
char-mxser-globals-cleanup.patch
char-mxser-add-cp-102uf-support.patch
char-mxser-update-documentation.patch
char-mxser-prints-cleanup.patch
char-mxser-remove-predefined-isa-support.patch
char-mxser-various-cleanups.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

