From: akpm@linux-foundation.org
Subject: + pl2303-remove-bogus-checks-and-fix-speed-support-to-use.patch added to -mm tree
Date: Thu, 05 Jul 2007 12:03:46 -0700
Message-ID: <200707051903.l65J3kvT013283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55396 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759145AbXGETE3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 15:04:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com


The patch titled
     pl2303: remove bogus checks and fix speed support to use tty_get_baud_rate()
has been added to the -mm tree.  Its filename is
     pl2303-remove-bogus-checks-and-fix-speed-support-to-use.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pl2303: remove bogus checks and fix speed support to use tty_get_baud_rate()
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/pl2303.c |   33 +--------------------------------
 1 files changed, 1 insertion(+), 32 deletions(-)

diff -puN drivers/usb/serial/pl2303.c~pl2303-remove-bogus-checks-and-fix-speed-support-to-use drivers/usb/serial/pl2303.c
--- a/drivers/usb/serial/pl2303.c~pl2303-remove-bogus-checks-and-fix-speed-support-to-use
+++ a/drivers/usb/serial/pl2303.c
@@ -484,15 +484,6 @@ static void pl2303_set_termios(struct us
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	cflag = port->tty->termios->c_cflag;
-	/* check that they really want us to change something */
-	if (old_termios) {
-		if ((cflag == old_termios->c_cflag) &&
-		    (RELEVANT_IFLAG(port->tty->termios->c_iflag) ==
-		     RELEVANT_IFLAG(old_termios->c_iflag))) {
-			dbg("%s - nothing to change...", __FUNCTION__);
-			return;
-		}
-	}
 
 	buf = kzalloc(7, GFP_KERNEL);
 	if (!buf) {
@@ -517,29 +508,7 @@ static void pl2303_set_termios(struct us
 		dbg("%s - data bits = %d", __FUNCTION__, buf[6]);
 	}
 
-	baud = 0;
-	switch (cflag & CBAUD) {
-		case B0:	baud = 0;	break;
-		case B75:	baud = 75;	break;
-		case B150:	baud = 150;	break;
-		case B300:	baud = 300;	break;
-		case B600:	baud = 600;	break;
-		case B1200:	baud = 1200;	break;
-		case B1800:	baud = 1800;	break;
-		case B2400:	baud = 2400;	break;
-		case B4800:	baud = 4800;	break;
-		case B9600:	baud = 9600;	break;
-		case B19200:	baud = 19200;	break;
-		case B38400:	baud = 38400;	break;
-		case B57600:	baud = 57600;	break;
-		case B115200:	baud = 115200;	break;
-		case B230400:	baud = 230400;	break;
-		case B460800:	baud = 460800;	break;
-		default:
-			dev_err(&port->dev, "pl2303 driver does not support"
-				" the baudrate requested (fix it)\n");
-			break;
-	}
+	baud = tty_get_baud_rate(port->tty);;
 	dbg("%s - baud = %d", __FUNCTION__, baud);
 	if (baud) {
 		buf[0] = baud & 0xff;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
powerpc-enable-arbitary-speed-tty-ioctls-and-split.patch
ia64-arbitary-speed-tty-ioctl-support.patch
git-libata-all.patch
libata-add-ich8m-pciids-to-ata_piix.patch
libata-add-irq_flags-to-struct-pata_platform_info.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
pata_pdc202xx_old-correct-cable-detect-logic.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
rfcomm-hangup-ttys-before-releasing-rfcomm_dev.patch
fix-gregkh-pci-pci-syscallc-switch-to-refcounting-api.patch
add-pci_try_set_mwi.patch
git-scsi-misc.patch
ppa-coding-police-and-printk-levels.patch
mos7840c-turn-this-into-a-serial-driver.patch
pl2303-remove-bogus-checks-and-fix-speed-support-to-use.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh-fix.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
h8300-enable-arbitary-speed-tty-port-setup.patch
arm26-enable-arbitary-speed-tty-ioctls-and-split.patch
m32r-enable-arbitary-speed-tty-rate-setting.patch
etrax-enable-arbitary-speed-setting-on-tty-ports.patch
v850-enable-arbitary-speed-tty-ioctls.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
update-zilog-timeout.patch
edd-switch-to-pci_get-based-api.patch
mpu401-warning-fixes.patch
char-tty_ioctl-use-wait_event_interruptible_timeout.patch
char-tty_ioctl-little-whitespace-cleanup.patch
intel-rng-undo-mess-made-by-an-80-column-extremist.patch
improve-behaviour-of-spurious-irq-detect.patch
audit-add-tty-input-auditing.patch
audit-add-tty-input-auditing-fix.patch
audit-add-tty-input-auditing-fix-2.patch
revert-vanishing-ioctl-handler-debugging.patch
amiserial-remove-incorrect-no-termios-change-check.patch
genericserial-remove-bogus-optimisation-check-and-dead-code-paths.patch
synclink-remove-bogus-no-change-termios-optimisation.patch
68360serial-remove-broken-optimisation.patch
i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
stallion-remove-unneeded-lock_kernel.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
driver-edac-add-mips-and-ppc-visibility.patch
driver-edac-mod-race-fix-i82875p.patch
driver-edac-fix-ignored-return-i82875p.patch
include-linux-pci_id-h-add-amd-northbridge-defines.patch
