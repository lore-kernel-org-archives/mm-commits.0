From: akpm@linux-foundation.org
Subject: - ide-stop-mapping-roms.patch removed from -mm tree
Date: Mon, 25 Jun 2007 02:21:38 -0700
Message-ID: <200706250921.l5P9Lci6031133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45147 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755AbXFYJYw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 05:24:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, sshtylyov@ru.mvista.com, mm-commits@vger.kernel.org


The patch titled
     ide: stop mapping ROMs
has been removed from the -mm tree.  Its filename was
     ide-stop-mapping-roms.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ide: stop mapping ROMs
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Various old IDE drivers go mapping ROM devices for no apparent reason and
without using the ROM mapping API we now have.  They don't actually use the
ROM they map and the new libata drivers are happy without it being mapped
so rather than port them lets just junk it for the next -rc1.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/pci/aec62xx.c      |    6 ------
 drivers/ide/pci/hpt34x.c       |   11 ++---------
 drivers/ide/pci/hpt366.c       |    8 --------
 drivers/ide/pci/pdc202xx_new.c |    7 -------
 drivers/ide/pci/pdc202xx_old.c |    8 --------
 5 files changed, 2 insertions(+), 38 deletions(-)

diff -puN drivers/ide/pci/aec62xx.c~ide-stop-mapping-roms drivers/ide/pci/aec62xx.c
--- a/drivers/ide/pci/aec62xx.c~ide-stop-mapping-roms
+++ a/drivers/ide/pci/aec62xx.c
@@ -174,12 +174,6 @@ static unsigned int __devinit init_chips
 {
 	int bus_speed = system_bus_clock();
 
-	if (dev->resource[PCI_ROM_RESOURCE].start) {
-		pci_write_config_dword(dev, PCI_ROM_ADDRESS, dev->resource[PCI_ROM_RESOURCE].start | PCI_ROM_ADDRESS_ENABLE);
-		printk(KERN_INFO "%s: ROM enabled at 0x%08lx\n", name,
-			(unsigned long)dev->resource[PCI_ROM_RESOURCE].start);
-	}
-
 	if (bus_speed <= 33)
 		pci_set_drvdata(dev, (void *) aec6xxx_33_base);
 	else
diff -puN drivers/ide/pci/hpt34x.c~ide-stop-mapping-roms drivers/ide/pci/hpt34x.c
--- a/drivers/ide/pci/hpt34x.c~ide-stop-mapping-roms
+++ a/drivers/ide/pci/hpt34x.c
@@ -120,17 +120,10 @@ static unsigned int __devinit init_chips
 	pci_write_config_byte(dev, HPT34X_PCI_INIT_REG, 0x00);
 	pci_read_config_word(dev, PCI_COMMAND, &cmd);
 
-	if (cmd & PCI_COMMAND_MEMORY) {
-		if (pci_resource_start(dev, PCI_ROM_RESOURCE)) {
-			pci_write_config_dword(dev, PCI_ROM_ADDRESS,
-				dev->resource[PCI_ROM_RESOURCE].start | PCI_ROM_ADDRESS_ENABLE);
-			printk(KERN_INFO "HPT345: ROM enabled at 0x%08lx\n",
-				(unsigned long)dev->resource[PCI_ROM_RESOURCE].start);
-		}
+	if (cmd & PCI_COMMAND_MEMORY)
 		pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0xF0);
-	} else {
+	else
 		pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x20);
-	}
 
 	/*
 	 * Since 20-23 can be assigned and are R/W, we correct them.
diff -puN drivers/ide/pci/hpt366.c~ide-stop-mapping-roms drivers/ide/pci/hpt366.c
--- a/drivers/ide/pci/hpt366.c~ide-stop-mapping-roms
+++ a/drivers/ide/pci/hpt366.c
@@ -993,14 +993,6 @@ static unsigned int __devinit init_chips
 	 */
 	*info = *(struct hpt_info *)pci_get_drvdata(dev);
 
-	/*
-	 * FIXME: Not portable. Also, why do we enable the ROM in the first place?
-	 * We don't seem to be using it.
-	 */
-	if (dev->resource[PCI_ROM_RESOURCE].start)
-		pci_write_config_dword(dev, PCI_ROM_ADDRESS,
-			dev->resource[PCI_ROM_RESOURCE].start | PCI_ROM_ADDRESS_ENABLE);
-
 	pci_write_config_byte(dev, PCI_CACHE_LINE_SIZE, (L1_CACHE_BYTES / 4));
 	pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x78);
 	pci_write_config_byte(dev, PCI_MIN_GNT, 0x08);
diff -puN drivers/ide/pci/pdc202xx_new.c~ide-stop-mapping-roms drivers/ide/pci/pdc202xx_new.c
--- a/drivers/ide/pci/pdc202xx_new.c~ide-stop-mapping-roms
+++ a/drivers/ide/pci/pdc202xx_new.c
@@ -372,13 +372,6 @@ static unsigned int __devinit init_chips
 	int f, r;
 	u8 pll_ctl0, pll_ctl1;
 
-	if (dev->resource[PCI_ROM_RESOURCE].start) {
-		pci_write_config_dword(dev, PCI_ROM_ADDRESS,
-			dev->resource[PCI_ROM_RESOURCE].start | PCI_ROM_ADDRESS_ENABLE);
-		printk(KERN_INFO "%s: ROM enabled at 0x%08lx\n", name,
-			(unsigned long)dev->resource[PCI_ROM_RESOURCE].start);
-	}
-
 #ifdef CONFIG_PPC_PMAC
 	apple_kiwi_init(dev);
 #endif
diff -puN drivers/ide/pci/pdc202xx_old.c~ide-stop-mapping-roms drivers/ide/pci/pdc202xx_old.c
--- a/drivers/ide/pci/pdc202xx_old.c~ide-stop-mapping-roms
+++ a/drivers/ide/pci/pdc202xx_old.c
@@ -316,14 +316,6 @@ static void pdc202xx_reset (ide_drive_t 
 static unsigned int __devinit init_chipset_pdc202xx(struct pci_dev *dev,
 							const char *name)
 {
-	/* This doesn't appear needed */
-	if (dev->resource[PCI_ROM_RESOURCE].start) {
-		pci_write_config_dword(dev, PCI_ROM_ADDRESS,
-			dev->resource[PCI_ROM_RESOURCE].start | PCI_ROM_ADDRESS_ENABLE);
-		printk(KERN_INFO "%s: ROM enabled at 0x%08lx\n", name,
-			(unsigned long)dev->resource[PCI_ROM_RESOURCE].start);
-	}
-
 	return dev->irq;
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
powerpc-enable-arbitary-speed-tty-ioctls-and-split.patch
ia64-arbitary-speed-tty-ioctl-support.patch
git-libata-all.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
hpt374-is-udma100-not-udma133.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
add-pci_try_set_mwi.patch
git-scsi-misc.patch
ppa-coding-police-and-printk-levels.patch
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
revert-vanishing-ioctl-handler-debugging.patch
i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
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
