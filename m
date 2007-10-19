From: akpm@linux-foundation.org
Subject: - mxser-remove-commented-crap.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:43:26 -0700
Message-ID: <200710190343.l9J3hQsv013055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46666 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934165AbXJSD42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mxser: remove commented crap
has been removed from the -mm tree.  Its filename was
     mxser-remove-commented-crap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mxser: remove commented crap
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This is years dead code and it keeps turning up in confusing ways when
grepping for stuff.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |   19 -------------------
 1 file changed, 19 deletions(-)

diff -puN drivers/char/mxser.c~mxser-remove-commented-crap drivers/char/mxser.c
--- a/drivers/char/mxser.c~mxser-remove-commented-crap
+++ a/drivers/char/mxser.c
@@ -1938,14 +1938,6 @@ static irqreturn_t mxser_interrupt(int i
 				inb(info->base + UART_MSR);
 				continue;
 			}
-			/* above add by Victor Yu. 09-13-2002 */
-			/*
-			   if (info->tty->flip.count < TTY_FLIPBUF_SIZE / 4) {
-			   info->IER |= MOXA_MUST_RECV_ISR;
-			   outb(info->IER, info->base + UART_IER);
-			   }
-			 */
-
 
 			/* mask by Victor Yu. 09-13-2002
 			   if ( !info->tty ||
@@ -2599,19 +2591,8 @@ static int mxser_change_speed(struct mxs
 		info->IER |= UART_IER_MSI;
 		if ((info->type == PORT_16550A) || (info->IsMoxaMustChipFlag)) {
 			info->MCR |= UART_MCR_AFE;
-			/* status = mxser_get_msr(info->base, 0, info->port); */
-/*
-	save_flags(flags);
-	cli();
-	status = inb(baseaddr + UART_MSR);
-	restore_flags(flags);
-*/
-			/* mxser_check_modem_status(info, status); */
 		} else {
-			/* status = mxser_get_msr(info->base, 0, info->port); */
-			/* MX_LOCK(&info->slock); */
 			status = inb(info->base + UART_MSR);
-			/* MX_UNLOCK(&info->slock); */
 			if (info->tty->hw_stopped) {
 				if (status & UART_MSR_CTS) {
 					info->tty->hw_stopped = 0;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
pata_cs5536-mwdma-fix.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-scsi-misc.patch
initio-fix-conflict-when-loading-driver.patch
isd200-sort-out-usb-ide-dependancy-mess.patch
usb_serial-stop-passing-null-to-functions-that-expect-data.patch
ark3116-update-termios-handling.patch
usb-serial-kill-another-case-we-pass-null-and-shouldnt.patch
ch341-fix-termios-handling.patch
digi_acceleport-fix-termios-and-also-readability-a-bit.patch
empeg-clean-up-and-handle-speeds.patch
ir_usb-termios-handling.patch
keyspan-termios-tidy.patch
kobil_sct-termios-encoding-fixups.patch
option-termios-handling.patch
sierra-termios.patch
usb-serial-handle-null-termios-methods-as-no-hardware-changing-support.patch
whiteheat-clean-up-cant-happen-checks-and-encode-baud.patch
cp2101-convert-to-new-termios.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
io_edgeport-cleanups-and-tty-speed-reporting.patch
tty-kill-tty_flipbuf_size.patch
