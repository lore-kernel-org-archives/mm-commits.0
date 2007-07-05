From: akpm@linux-foundation.org
Subject: + synclink-remove-bogus-no-change-termios-optimisation.patch added to -mm tree
Date: Thu, 05 Jul 2007 12:01:36 -0700
Message-ID: <200707051901.l65J1aq0013192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44886 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753829AbXGETCV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 15:02:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, paulkf@microgate.com


The patch titled
     synclink: remove bogus 'no change' termios optimisation from synclink drivers
has been added to the -mm tree.  Its filename is
     synclink-remove-bogus-no-change-termios-optimisation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: synclink: remove bogus 'no change' termios optimisation from synclink drivers
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Again this check is wrong now, and un-needed

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink.c    |    8 --------
 drivers/char/synclink_gt.c |    8 --------
 drivers/char/synclinkmp.c  |    8 --------
 3 files changed, 24 deletions(-)

diff -puN drivers/char/synclink.c~synclink-remove-bogus-no-change-termios-optimisation drivers/char/synclink.c
--- a/drivers/char/synclink.c~synclink-remove-bogus-no-change-termios-optimisation
+++ a/drivers/char/synclink.c
@@ -160,8 +160,6 @@ typedef struct _DMABUFFERENTRY
 
 #define IO_PIN_SHUTDOWN_LIMIT 100
 
-#define RELEVANT_IFLAG(iflag) (iflag & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
-
 struct	_input_signal_events {
 	int	ri_up;	
 	int	ri_down;
@@ -3064,12 +3062,6 @@ static void mgsl_set_termios(struct tty_
 		printk("%s(%d):mgsl_set_termios %s\n", __FILE__,__LINE__,
 			tty->driver->name );
 	
-	/* just return if nothing has changed */
-	if ((tty->termios->c_cflag == old_termios->c_cflag)
-	    && (RELEVANT_IFLAG(tty->termios->c_iflag) 
-		== RELEVANT_IFLAG(old_termios->c_iflag)))
-	  return;
-
 	mgsl_change_params(info);
 
 	/* Handle transition to B0 status */
diff -puN drivers/char/synclink_gt.c~synclink-remove-bogus-no-change-termios-optimisation drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink-remove-bogus-no-change-termios-optimisation
+++ a/drivers/char/synclink_gt.c
@@ -144,8 +144,6 @@ MODULE_PARM_DESC(dosyncppp, "Enable sync
 /*
  * tty support and callbacks
  */
-#define RELEVANT_IFLAG(iflag) (iflag & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
-
 static struct tty_driver *serial_driver;
 
 static int  open(struct tty_struct *tty, struct file * filp);
@@ -823,12 +821,6 @@ static void set_termios(struct tty_struc
 
 	DBGINFO(("%s set_termios\n", tty->driver->name));
 
-	/* just return if nothing has changed */
-	if ((tty->termios->c_cflag == old_termios->c_cflag)
-	    && (RELEVANT_IFLAG(tty->termios->c_iflag)
-		== RELEVANT_IFLAG(old_termios->c_iflag)))
-		return;
-
 	change_params(info);
 
 	/* Handle transition to B0 status */
diff -puN drivers/char/synclinkmp.c~synclink-remove-bogus-no-change-termios-optimisation drivers/char/synclinkmp.c
--- a/drivers/char/synclinkmp.c~synclink-remove-bogus-no-change-termios-optimisation
+++ a/drivers/char/synclinkmp.c
@@ -135,8 +135,6 @@ typedef struct _SCADESC_EX
 
 #define IO_PIN_SHUTDOWN_LIMIT 100
 
-#define RELEVANT_IFLAG(iflag) (iflag & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
-
 struct	_input_signal_events {
 	int	ri_up;
 	int	ri_down;
@@ -927,12 +925,6 @@ static void set_termios(struct tty_struc
 		printk("%s(%d):%s set_termios()\n", __FILE__,__LINE__,
 			tty->driver->name );
 
-	/* just return if nothing has changed */
-	if ((tty->termios->c_cflag == old_termios->c_cflag)
-	    && (RELEVANT_IFLAG(tty->termios->c_iflag)
-		== RELEVANT_IFLAG(old_termios->c_iflag)))
-	  return;
-
 	change_params(info);
 
 	/* Handle transition to B0 status */
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
