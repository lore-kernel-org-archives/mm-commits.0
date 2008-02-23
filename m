From: akpm@linux-foundation.org
Subject: + ti_usb_3410_5052-extend-locking-to-msr-and-shadow-mcr.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:31:05 -0800
Message-ID: <200802230731.m1N7VrxV018040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752285AbYBWH70 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:59:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com


The patch titled
     ti_usb_3410_5052: Extend locking to msr and shadow mcr
has been added to the -mm tree.  Its filename is
     ti_usb_3410_5052-extend-locking-to-msr-and-shadow-mcr.patch

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
Subject: ti_usb_3410_5052: Extend locking to msr and shadow mcr
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ti_usb_3410_5052.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/usb/serial/ti_usb_3410_5052.c~ti_usb_3410_5052-extend-locking-to-msr-and-shadow-mcr drivers/usb/serial/ti_usb_3410_5052.c
--- a/drivers/usb/serial/ti_usb_3410_5052.c~ti_usb_3410_5052-extend-locking-to-msr-and-shadow-mcr
+++ a/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1022,14 +1022,17 @@ static int ti_tiocmget(struct usb_serial
 	unsigned int result;
 	unsigned int msr;
 	unsigned int mcr;
+	unsigned long flags;
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
 
 	if (tport == NULL)
 		return -ENODEV;
 
+	spin_lock_irqsave(&tport->tp_lock, flags);
 	msr = tport->tp_msr;
 	mcr = tport->tp_shadow_mcr;
+	spin_unlock_irqrestore(&tport->tp_lock, flags);
 
 	result = ((mcr & TI_MCR_DTR) ? TIOCM_DTR : 0)
 		| ((mcr & TI_MCR_RTS) ? TIOCM_RTS : 0)
@@ -1050,12 +1053,14 @@ static int ti_tiocmset(struct usb_serial
 {
 	struct ti_port *tport = usb_get_serial_port_data(port);
 	unsigned int mcr;
+	unsigned long flags;
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
 
 	if (tport == NULL)
 		return -ENODEV;
 
+	spin_lock_irqsave(&tport->tp_lock, flags);
 	mcr = tport->tp_shadow_mcr;
 
 	if (set & TIOCM_RTS)
@@ -1071,6 +1076,7 @@ static int ti_tiocmset(struct usb_serial
 		mcr &= ~TI_MCR_DTR;
 	if (clear & TIOCM_LOOP)
 		mcr &= ~TI_MCR_LOOP;
+	spin_unlock_irqrestore(&tport->tp_lock, flags);
 
 	return ti_set_mcr(tport, mcr);
 }
@@ -1358,14 +1364,17 @@ static void ti_send(struct ti_port *tpor
 
 static int ti_set_mcr(struct ti_port *tport, unsigned int mcr)
 {
+	unsigned long flags;
 	int status;
 
 	status = ti_write_byte(tport->tp_tdev,
 		tport->tp_uart_base_addr + TI_UART_OFFSET_MCR,
 		TI_MCR_RTS | TI_MCR_DTR | TI_MCR_LOOP, mcr);
 
+	spin_lock_irqsave(&tport->tp_lock, flags);
 	if (!status)
 		tport->tp_shadow_mcr = mcr;
+	spin_unlock_irqrestore(&tport->tp_lock, flags);
 
 	return status;
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
