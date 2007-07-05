From: akpm@linux-foundation.org
Subject: + mos7840c-turn-this-into-a-serial-driver.patch added to -mm tree
Date: Thu, 05 Jul 2007 12:03:17 -0700
Message-ID: <200707051903.l65J3HC3013280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51565 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759628AbXGETIF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 15:08:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com


The patch titled
     mos7840.c: turn this into a serial driver
has been added to the -mm tree.  Its filename is
     mos7840c-turn-this-into-a-serial-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mos7840.c: turn this into a serial driver
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The MOS driver is "interesting", in a bad kind of 'how the hell did this
get merged' kind of way

- Remove the bogus termios change check
- Remove the duplicate code for half the ioctls
- Remove the supporting code to duplicate the ioctl code

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/mos7840.c |   72 ---------------------------------
 1 files changed, 72 deletions(-)

diff -puN drivers/usb/serial/mos7840.c~mos7840c-turn-this-into-a-serial-driver drivers/usb/serial/mos7840.c
--- a/drivers/usb/serial/mos7840.c~mos7840c-turn-this-into-a-serial-driver
+++ a/drivers/usb/serial/mos7840.c
@@ -2189,16 +2189,6 @@ static void mos7840_set_termios(struct u
 		return;
 	}
 
-	/* check that they really want us to change something */
-	if (old_termios) {
-		if ((cflag == old_termios->c_cflag) &&
-		    (RELEVANT_IFLAG(tty->termios->c_iflag) ==
-		     RELEVANT_IFLAG(old_termios->c_iflag))) {
-			dbg("%s\n", "Nothing to change");
-			return;
-		}
-	}
-
 	dbg("%s - clfag %08x iflag %08x", __FUNCTION__,
 	    tty->termios->c_cflag, RELEVANT_IFLAG(tty->termios->c_iflag));
 
@@ -2258,30 +2248,6 @@ static int mos7840_get_lsr_info(struct m
 }
 
 /*****************************************************************************
- * mos7840_get_bytes_avail - get number of bytes available
- *
- * Purpose: Let user call ioctl to get the count of number of bytes available.
- *****************************************************************************/
-
-static int mos7840_get_bytes_avail(struct moschip_port *mos7840_port,
-				   unsigned int __user *value)
-{
-	unsigned int result = 0;
-	struct tty_struct *tty = mos7840_port->port->tty;
-
-	if (!tty)
-		return -ENOIOCTLCMD;
-
-	result = tty->read_cnt;
-
-	dbg("%s(%d) = %d", __FUNCTION__, mos7840_port->port->number, result);
-	if (copy_to_user(value, &result, sizeof(int)))
-		return -EFAULT;
-
-	return -ENOIOCTLCMD;
-}
-
-/*****************************************************************************
  * mos7840_set_modem_info
  *      function to set modem info
  *****************************************************************************/
@@ -2429,8 +2395,6 @@ static int mos7840_ioctl(struct usb_seri
 	struct async_icount cprev;
 	struct serial_icounter_struct icount;
 	int mosret = 0;
-	int retval;
-	struct tty_ldisc *ld;
 
 	if (mos7840_port_paranoia_check(port, __FUNCTION__)) {
 		dbg("%s", "Invalid port \n");
@@ -2449,42 +2413,6 @@ static int mos7840_ioctl(struct usb_seri
 	switch (cmd) {
 		/* return number of bytes available */
 
-	case TIOCINQ:
-		dbg("%s (%d) TIOCINQ", __FUNCTION__, port->number);
-		return mos7840_get_bytes_avail(mos7840_port, argp);
-
-	case TIOCOUTQ:
-		dbg("%s (%d) TIOCOUTQ", __FUNCTION__, port->number);
-		return put_user(tty->driver->chars_in_buffer ?
-				tty->driver->chars_in_buffer(tty) : 0,
-				(int __user *)arg);
-
-	case TCFLSH:
-		retval = tty_check_change(tty);
-		if (retval)
-			return retval;
-
-		ld = tty_ldisc_ref(tty);
-		switch (arg) {
-		case TCIFLUSH:
-			if (ld && ld->flush_buffer)
-				ld->flush_buffer(tty);
-			break;
-		case TCIOFLUSH:
-			if (ld && ld->flush_buffer)
-				ld->flush_buffer(tty);
-			/* fall through */
-		case TCOFLUSH:
-			if (tty->driver->flush_buffer)
-				tty->driver->flush_buffer(tty);
-			break;
-		default:
-			tty_ldisc_deref(ld);
-			return -EINVAL;
-		}
-		tty_ldisc_deref(ld);
-		return 0;
-
 	case TIOCSERGETLSR:
 		dbg("%s (%d) TIOCSERGETLSR", __FUNCTION__, port->number);
 		return mos7840_get_lsr_info(mos7840_port, argp);
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
