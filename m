From: akpm@linux-foundation.org
Subject: + mxser-remove-commented-crap.patch added to -mm tree
Date: Thu, 23 Aug 2007 14:55:32 -0700
Message-ID: <200708232155.l7NLtWIW028772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35788 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761269AbXHWVzo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 17:55:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com


The patch titled
     mxser: remove commented crap
has been added to the -mm tree.  Its filename is
     mxser-remove-commented-crap.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 19 deletions(-)

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
serial-add-support-for-ite-887x-chips.patch
serial_txx9-fix-modem-control-line-handling.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
fix-null-pointer-dereference-in-__vm_enough_memory.patch
m68k-enable-arbitary-speed-tty-support.patch
introduce-config_check_signature-was-re-uninline.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-switch-most-of-the-remaining-sff-drivers-to.patch
pata_sis-add-the-fsc-amilo-and-friends.patch
pata_via-add-armia-w730-k8-and-other-rebadgings.patch
pata_marvell-add-more-identifiers.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-scsi-misc.patch
fix-gregkh-usb-usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
pata_it821x-fix-regression-corruptor.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
