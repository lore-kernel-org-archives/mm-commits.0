From: akpm@linux-foundation.org
Subject: - amiserial-remove-incorrect-no-termios-change-check.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:59:06 -0700
Message-ID: <200707162059.l6GKx6U6002400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43954 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759292AbXGPVP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:15:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     amiserial: remove incorrect 'no termios change' check
has been removed from the -mm tree.  Its filename was
     amiserial-remove-incorrect-no-termios-change-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: amiserial: remove incorrect 'no termios change' check
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Lots of serial drivers check and optimise for setting the termios values to
the ones they were before.  This is pointless and the check is wrong
anyway.  Remove the checks on the serial drivers.  If we ever do need such
a check put it back in the tty layer instead _once_!

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/amiserial.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/char/amiserial.c~amiserial-remove-incorrect-no-termios-change-check drivers/char/amiserial.c
--- a/drivers/char/amiserial.c~amiserial-remove-incorrect-no-termios-change-check
+++ a/drivers/char/amiserial.c
@@ -738,6 +738,7 @@ static void change_speed(struct async_st
 	}
 	/* If the quotient is zero refuse the change */
 	if (!quot && old_termios) {
+		/* FIXME: Will need updating for new tty in the end */
 		info->tty->termios->c_cflag &= ~CBAUD;
 		info->tty->termios->c_cflag |= (old_termios->c_cflag & CBAUD);
 		baud = tty_get_baud_rate(info->tty);
@@ -783,7 +784,6 @@ static void change_speed(struct async_st
 	/*
 	 * Set up parity check flag
 	 */
-#define RELEVANT_IFLAG(iflag) (iflag & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
 
 	info->read_status_mask = UART_LSR_OE | UART_LSR_DR;
 	if (I_INPCK(info->tty))
@@ -1367,11 +1367,6 @@ static void rs_set_termios(struct tty_st
 	unsigned long flags;
 	unsigned int cflag = tty->termios->c_cflag;
 
-	if (   (cflag == old_termios->c_cflag)
-	    && (   RELEVANT_IFLAG(tty->termios->c_iflag) 
-		== RELEVANT_IFLAG(old_termios->c_iflag)))
-	  return;
-
 	change_speed(info, old_termios);
 
 	/* Handle transition to B0 status */
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-powerpc.patch
git-ia64.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch
ata-use-iomap_name.patch
sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
sb1250-duartc-sb1250-duart-serial-support.patch
mbcs-remove-lots-of-global-symbols.patch
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
