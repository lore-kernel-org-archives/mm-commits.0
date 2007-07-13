From: akpm@linux-foundation.org
Subject: - io_-remove-bogus-termios-no-change-checks.patch removed from -mm tree
Date: Fri, 13 Jul 2007 15:33:41 -0700
Message-ID: <200707132233.l6DMXfIU025098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53531 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762033AbXGMWpS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 18:45:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     io_*: remove bogus termios no change checks
has been removed from the -mm tree.  Its filename was
     io_-remove-bogus-termios-no-change-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: io_*: remove bogus termios no change checks
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/io_edgeport.c |    9 ---------
 drivers/usb/serial/io_ti.c       |    8 --------
 2 files changed, 17 deletions(-)

diff -puN drivers/usb/serial/io_edgeport.c~io_-remove-bogus-termios-no-change-checks drivers/usb/serial/io_edgeport.c
--- a/drivers/usb/serial/io_edgeport.c~io_-remove-bogus-termios-no-change-checks
+++ a/drivers/usb/serial/io_edgeport.c
@@ -1513,15 +1513,6 @@ static void edge_set_termios (struct usb
 	}
 
 	cflag = tty->termios->c_cflag;
-	/* check that they really want us to change something */
-	if (old_termios) {
-		if (cflag == old_termios->c_cflag &&
-		    tty->termios->c_iflag == old_termios->c_iflag) {
-			dbg("%s - nothing to change", __FUNCTION__);
-			return;
-		}
-	}
-
 	dbg("%s - clfag %08x iflag %08x", __FUNCTION__, 
 	    tty->termios->c_cflag, tty->termios->c_iflag);
 	if (old_termios) {
diff -puN drivers/usb/serial/io_ti.c~io_-remove-bogus-termios-no-change-checks drivers/usb/serial/io_ti.c
--- a/drivers/usb/serial/io_ti.c~io_-remove-bogus-termios-no-change-checks
+++ a/drivers/usb/serial/io_ti.c
@@ -2544,14 +2544,6 @@ static void edge_set_termios (struct usb
 	}
 
 	cflag = tty->termios->c_cflag;
-	/* check that they really want us to change something */
-	if (old_termios) {
-		if (cflag == old_termios->c_cflag &&
-		    tty->termios->c_iflag == old_termios->c_iflag) {
-			dbg ("%s - nothing to change", __FUNCTION__);
-			return;
-		}
-	}
 
 	dbg("%s - clfag %08x iflag %08x", __FUNCTION__, 
 	    tty->termios->c_cflag, tty->termios->c_iflag);
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
