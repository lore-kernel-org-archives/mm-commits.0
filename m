From: akpm@linux-foundation.org
Subject: - pl2303-remove-bogus-checks-and-fix-speed-support-to-use.patch removed from -mm tree
Date: Fri, 13 Jul 2007 15:33:35 -0700
Message-ID: <200707132233.l6DMXZew025089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51865 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936426AbXGMWp0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 18:45:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     pl2303: remove bogus checks and fix speed support to use tty_get_baud_rate()
has been removed from the -mm tree.  Its filename was
     pl2303-remove-bogus-checks-and-fix-speed-support-to-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-powerpc.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch
ata-use-iomap_name.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
git-scsi-misc.patch
ppa-coding-police-and-printk-levels.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
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
revert-vanishing-ioctl-handler-debugging.patch
amiserial-remove-incorrect-no-termios-change-check.patch
genericserial-remove-bogus-optimisation-check-and-dead-code-paths.patch
synclink-remove-bogus-no-change-termios-optimisation.patch
68360serial-remove-broken-optimisation.patch
serial-remove-termios-checks-from-various-old-char-serial.patch
ia64-arbitary-speed-tty-ioctl-support.patch
sb1250-duartc-sb1250-duart-serial-support.patch
i2o_cfg_passthru-cleanup.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
stallion-remove-unneeded-lock_kernel.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
driver-edac-add-mips-and-ppc-visibility.patch
driver-edac-mod-race-fix-i82875p.patch
driver-edac-fix-ignored-return-i82875p.patch
include-linux-pci_id-h-add-amd-northbridge-defines.patch
drivers-edac-fix-edac_device-semaphore-to-mutex.patch
drivers-edac-fix-e752x-reversed-csrows.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver.patch
drivers-edac-new-pasemi-driver-fix.patch
drivers-edac-fix-leaf-sysfs-attribute.patch
drivers-edac-fix-edac_mc-init-apis.patch
drivers-edac-fix-edac_device-init-apis.patch
drivers-edac-fix-edac_mc-sysfs-completion-code.patch
drivers-edac-fix-edac_device-sysfs-completion-code.patch
