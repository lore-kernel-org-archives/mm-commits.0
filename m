From: akpm@linux-foundation.org
Subject: + serial-remove-termios-checks-from-various-old-char-serial.patch added to -mm tree
Date: Thu, 05 Jul 2007 12:16:22 -0700
Message-ID: <200707051916.l65JGMv4013918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50635 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774AbXGETRH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 15:17:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     serial: remove termios checks from various old char serial drivers
has been added to the -mm tree.  Its filename is
     serial-remove-termios-checks-from-various-old-char-serial.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: remove termios checks from various old char serial drivers
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c  |    4 ----
 drivers/char/esp.c       |    7 -------
 drivers/char/istallion.c |    3 ---
 drivers/char/mxser.c     |   16 +++++-----------
 drivers/char/mxser_new.c |   20 +++++++-------------
 5 files changed, 12 insertions(+), 38 deletions(-)

diff -puN drivers/char/cyclades.c~serial-remove-termios-checks-from-various-old-char-serial drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~serial-remove-termios-checks-from-various-old-char-serial
+++ a/drivers/char/cyclades.c
@@ -4127,10 +4127,6 @@ static void cy_set_termios(struct tty_st
 	printk(KERN_DEBUG "cyc:cy_set_termios ttyC%d\n", info->line);
 #endif
 
-	if (tty->termios->c_cflag == old_termios->c_cflag &&
-			(tty->termios->c_iflag & (IXON | IXANY)) ==
-			(old_termios->c_iflag & (IXON | IXANY)))
-		return;
 	set_line_char(info);
 
 	if ((old_termios->c_cflag & CRTSCTS) &&
diff -puN drivers/char/esp.c~serial-remove-termios-checks-from-various-old-char-serial drivers/char/esp.c
--- a/drivers/char/esp.c~serial-remove-termios-checks-from-various-old-char-serial
+++ a/drivers/char/esp.c
@@ -1121,8 +1121,6 @@ static void change_speed(struct esp_stru
 	/*
 	 * Set up parity check flag
 	 */
-#define RELEVANT_IFLAG(iflag) (iflag & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
-
 	info->read_status_mask = UART_LSR_OE | UART_LSR_THRE | UART_LSR_DR;
 	if (I_INPCK(info->tty))
 		info->read_status_mask |= UART_LSR_FE | UART_LSR_PE;
@@ -1920,11 +1918,6 @@ static void rs_set_termios(struct tty_st
 	struct esp_struct *info = (struct esp_struct *)tty->driver_data;
 	unsigned long flags;
 
-	if (   (tty->termios->c_cflag == old_termios->c_cflag)
-	    && (   RELEVANT_IFLAG(tty->termios->c_iflag) 
-		== RELEVANT_IFLAG(old_termios->c_iflag)))
-		return;
-
 	change_speed(info);
 
 	spin_lock_irqsave(&info->lock, flags);
diff -puN drivers/char/istallion.c~serial-remove-termios-checks-from-various-old-char-serial drivers/char/istallion.c
--- a/drivers/char/istallion.c~serial-remove-termios-checks-from-various-old-char-serial
+++ a/drivers/char/istallion.c
@@ -1753,9 +1753,6 @@ static void stli_settermios(struct tty_s
 		return;
 
 	tiosp = tty->termios;
-	if ((tiosp->c_cflag == old->c_cflag) &&
-	    (tiosp->c_iflag == old->c_iflag))
-		return;
 
 	stli_mkasyport(portp, &aport, tiosp);
 	stli_cmdwait(brdp, portp, A_SETPORT, &aport, sizeof(asyport_t), 0);
diff -puN drivers/char/mxser.c~serial-remove-termios-checks-from-various-old-char-serial drivers/char/mxser.c
--- a/drivers/char/mxser.c~serial-remove-termios-checks-from-various-old-char-serial
+++ a/drivers/char/mxser.c
@@ -90,8 +90,6 @@
 #define UART_MCR_AFE		0x20
 #define UART_LSR_SPECIAL	0x1E
 
-#define RELEVANT_IFLAG(iflag)	(iflag & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK|\
-					  IXON|IXOFF))
 
 #define IRQ_T(info) ((info->flags & ASYNC_SHARE_IRQ) ? IRQF_SHARED : IRQF_DISABLED)
 
@@ -1729,16 +1727,12 @@ static void mxser_set_termios(struct tty
 	struct mxser_struct *info = tty->driver_data;
 	unsigned long flags;
 
-	if ((tty->termios->c_cflag != old_termios->c_cflag) ||
-			(RELEVANT_IFLAG(tty->termios->c_iflag) != RELEVANT_IFLAG(old_termios->c_iflag))) {
+	mxser_change_speed(info, old_termios);
 
-		mxser_change_speed(info, old_termios);
-
-		if ((old_termios->c_cflag & CRTSCTS) &&
-				!(tty->termios->c_cflag & CRTSCTS)) {
-			tty->hw_stopped = 0;
-			mxser_start(tty);
-		}
+	if ((old_termios->c_cflag & CRTSCTS) &&
+			!(tty->termios->c_cflag & CRTSCTS)) {
+		tty->hw_stopped = 0;
+		mxser_start(tty);
 	}
 
 /* Handle sw stopped */
diff -puN drivers/char/mxser_new.c~serial-remove-termios-checks-from-various-old-char-serial drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~serial-remove-termios-checks-from-various-old-char-serial
+++ a/drivers/char/mxser_new.c
@@ -72,8 +72,6 @@
 #define UART_MCR_AFE		0x20
 #define UART_LSR_SPECIAL	0x1E
 
-#define RELEVANT_IFLAG(iflag)	(iflag & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK|\
-					  IXON|IXOFF))
 
 #define C168_ASIC_ID    1
 #define C104_ASIC_ID    2
@@ -1990,18 +1988,14 @@ static void mxser_set_termios(struct tty
 	struct mxser_port *info = tty->driver_data;
 	unsigned long flags;
 
-	if ((tty->termios->c_cflag != old_termios->c_cflag) ||
-			(RELEVANT_IFLAG(tty->termios->c_iflag) != RELEVANT_IFLAG(old_termios->c_iflag))) {
-
-		spin_lock_irqsave(&info->slock, flags);
-		mxser_change_speed(info, old_termios);
-		spin_unlock_irqrestore(&info->slock, flags);
+	spin_lock_irqsave(&info->slock, flags);
+	mxser_change_speed(info, old_termios);
+	spin_unlock_irqrestore(&info->slock, flags);
 
-		if ((old_termios->c_cflag & CRTSCTS) &&
-				!(tty->termios->c_cflag & CRTSCTS)) {
-			tty->hw_stopped = 0;
-			mxser_start(tty);
-		}
+	if ((old_termios->c_cflag & CRTSCTS) &&
+			!(tty->termios->c_cflag & CRTSCTS)) {
+		tty->hw_stopped = 0;
+		mxser_start(tty);
 	}
 
 	/* Handle sw stopped */
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
powerpc-enable-arbitary-speed-tty-ioctls-and-split.patch
nozomi-remove-termios-checks-from-various-old-char-serial-drivers.patch
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
visor-and-whiteheat-remove-bogus-termios-change-checks.patch
mos7720-remove-bogus-no-termios-change-check.patch
io_-remove-bogus-termios-no-change-checks.patch
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
serial-remove-termios-checks-from-various-old-char-serial.patch
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
