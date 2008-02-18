From: akpm@linux-foundation.org
Subject: + revert-sh-use-ctrl_in-out-for-on-chip-pci-access.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:08:20 -0800
Message-ID: <200802181009.m1IA9HhE019378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49089 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754354AbYBRKJe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:09:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, adrian@newgolddream.dyndns.info, damm@igel.co.jp, lethal@linux-sh.org, magnus.damm@gmail.com, matsu@igel.co.jp


The patch titled
     revert "sh: use ctrl_in/out for on chip pci access"
has been added to the -mm tree.  Its filename is
     revert-sh-use-ctrl_in-out-for-on-chip-pci-access.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "sh: use ctrl_in/out for on chip pci access"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

commit e036eaa681a17f71b64f6d9040fe605555623919
Author: Magnus Damm <magnus.damm@gmail.com>
Date:   Thu Feb 14 13:52:43 2008 +0900

    sh: use ctrl_in/out for on chip pci access
    
    This patch makes sure ctrl_inN/outN are used instead of inN/outN for on chip
    pci registers. Without this patch addresses may be adjusted using the value
    in generic_io_base. This patch makes it possible to set generic_io_base and
    have pci without reading and writing all over the place.

Because it broke Adrian's machine.

Cc: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Magnus Damm <damm@igel.co.jp>
Cc: Katsuya MATSUBARA <matsu@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/drivers/pci/fixups-lboxre2.c    |    4 +-
 arch/sh/drivers/pci/fixups-rts7751r2d.c |    4 +-
 arch/sh/drivers/pci/ops-dreamcast.c     |   44 +++++++++++-----------
 arch/sh/drivers/pci/pci-sh4.h           |    4 +-
 arch/sh/drivers/pci/pci-sh7751.c        |   16 ++++----
 arch/sh/drivers/pci/pci-sh7780.c        |    2 -
 6 files changed, 37 insertions(+), 37 deletions(-)

diff -puN arch/sh/drivers/pci/fixups-lboxre2.c~revert-sh-use-ctrl_in-out-for-on-chip-pci-access arch/sh/drivers/pci/fixups-lboxre2.c
--- a/arch/sh/drivers/pci/fixups-lboxre2.c~revert-sh-use-ctrl_in-out-for-on-chip-pci-access
+++ a/arch/sh/drivers/pci/fixups-lboxre2.c
@@ -18,7 +18,7 @@ int pci_fixup_pcic(void)
 {
 	unsigned long bcr1, mcr;
 
-	bcr1 = ctrl_inl(SH7751_BCR1);
+	bcr1 = inl(SH7751_BCR1);
 	bcr1 |= 0x40080000;	/* Enable Bit 19 BREQEN, set PCIC to slave */
 	pci_write_reg(bcr1, SH4_PCIBCR1);
 
@@ -28,7 +28,7 @@ int pci_fixup_pcic(void)
 	pci_write_reg(0xfb900047, SH7751_PCICONF1);
 	pci_write_reg(0xab000001, SH7751_PCICONF4);
 
-	mcr = ctrl_inl(SH7751_MCR);
+	mcr = inl(SH7751_MCR);
 	mcr = (mcr & PCIMCR_MRSET_OFF) & PCIMCR_RFSH_OFF;
 	pci_write_reg(mcr, SH4_PCIMCR);
 
diff -puN arch/sh/drivers/pci/fixups-rts7751r2d.c~revert-sh-use-ctrl_in-out-for-on-chip-pci-access arch/sh/drivers/pci/fixups-rts7751r2d.c
--- a/arch/sh/drivers/pci/fixups-rts7751r2d.c~revert-sh-use-ctrl_in-out-for-on-chip-pci-access
+++ a/arch/sh/drivers/pci/fixups-rts7751r2d.c
@@ -19,7 +19,7 @@ int pci_fixup_pcic(void)
 {
 	unsigned long bcr1, mcr;
 
-	bcr1 = ctrl_inl(SH7751_BCR1);
+	bcr1 = inl(SH7751_BCR1);
 	bcr1 |= 0x40080000;	/* Enable Bit 19 BREQEN, set PCIC to slave */
 	pci_write_reg(bcr1, SH4_PCIBCR1);
 
@@ -30,7 +30,7 @@ int pci_fixup_pcic(void)
 	pci_write_reg(0xfb900047, SH7751_PCICONF1);
 	pci_write_reg(0xab000001, SH7751_PCICONF4);
 
-	mcr = ctrl_inl(SH7751_MCR);
+	mcr = inl(SH7751_MCR);
 	mcr = (mcr & PCIMCR_MRSET_OFF) & PCIMCR_RFSH_OFF;
 	pci_write_reg(mcr, SH4_PCIMCR);
 
diff -puN arch/sh/drivers/pci/ops-dreamcast.c~revert-sh-use-ctrl_in-out-for-on-chip-pci-access arch/sh/drivers/pci/ops-dreamcast.c
--- a/arch/sh/drivers/pci/ops-dreamcast.c~revert-sh-use-ctrl_in-out-for-on-chip-pci-access
+++ a/arch/sh/drivers/pci/ops-dreamcast.c
@@ -83,9 +83,9 @@ static int gapspci_read(struct pci_bus *
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
 	switch (size) {
-		case 1: *val = ctrl_inb(GAPSPCI_BBA_CONFIG+where); break;
-		case 2: *val = ctrl_inw(GAPSPCI_BBA_CONFIG+where); break;
-		case 4: *val = ctrl_inl(GAPSPCI_BBA_CONFIG+where); break;
+		case 1: *val = inb(GAPSPCI_BBA_CONFIG+where); break;
+		case 2: *val = inw(GAPSPCI_BBA_CONFIG+where); break;
+		case 4: *val = inl(GAPSPCI_BBA_CONFIG+where); break;
 	}	
 
         return PCIBIOS_SUCCESSFUL;
@@ -97,9 +97,9 @@ static int gapspci_write(struct pci_bus 
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
 	switch (size) {
-		case 1: ctrl_outb(( u8)val, GAPSPCI_BBA_CONFIG+where); break;
-		case 2: ctrl_outw((u16)val, GAPSPCI_BBA_CONFIG+where); break;
-		case 4: ctrl_outl((u32)val, GAPSPCI_BBA_CONFIG+where); break;
+		case 1: outb(( u8)val, GAPSPCI_BBA_CONFIG+where); break;
+		case 2: outw((u16)val, GAPSPCI_BBA_CONFIG+where); break;
+		case 4: outl((u32)val, GAPSPCI_BBA_CONFIG+where); break;
 	}
 
         return PCIBIOS_SUCCESSFUL;
@@ -127,36 +127,36 @@ int __init gapspci_init(void)
 	 */
 
 	for (i=0; i<16; i++)
-		idbuf[i] = ctrl_inb(GAPSPCI_REGS+i);
+		idbuf[i] = inb(GAPSPCI_REGS+i);
 
 	if (strncmp(idbuf, "GAPSPCI_BRIDGE_2", 16))
 		return -ENODEV;
 
-	ctrl_outl(0x5a14a501, GAPSPCI_REGS+0x18);
+	outl(0x5a14a501, GAPSPCI_REGS+0x18);
 
 	for (i=0; i<1000000; i++)
 		;
 
-	if (ctrl_inl(GAPSPCI_REGS+0x18) != 1)
+	if (inl(GAPSPCI_REGS+0x18) != 1)
 		return -EINVAL;
 
-	ctrl_outl(0x01000000, GAPSPCI_REGS+0x20);
-	ctrl_outl(0x01000000, GAPSPCI_REGS+0x24);
+	outl(0x01000000, GAPSPCI_REGS+0x20);
+	outl(0x01000000, GAPSPCI_REGS+0x24);
 
-	ctrl_outl(GAPSPCI_DMA_BASE, GAPSPCI_REGS+0x28);
-	ctrl_outl(GAPSPCI_DMA_BASE+GAPSPCI_DMA_SIZE, GAPSPCI_REGS+0x2c);
+	outl(GAPSPCI_DMA_BASE, GAPSPCI_REGS+0x28);
+	outl(GAPSPCI_DMA_BASE+GAPSPCI_DMA_SIZE, GAPSPCI_REGS+0x2c);
 
-	ctrl_outl(1, GAPSPCI_REGS+0x14);
-	ctrl_outl(1, GAPSPCI_REGS+0x34);
+	outl(1, GAPSPCI_REGS+0x14);
+	outl(1, GAPSPCI_REGS+0x34);
 
 	/* Setting Broadband Adapter */
-	ctrl_outw(0xf900, GAPSPCI_BBA_CONFIG+0x06);
-	ctrl_outl(0x00000000, GAPSPCI_BBA_CONFIG+0x30);
-	ctrl_outb(0x00, GAPSPCI_BBA_CONFIG+0x3c);
-	ctrl_outb(0xf0, GAPSPCI_BBA_CONFIG+0x0d);
-	ctrl_outw(0x0006, GAPSPCI_BBA_CONFIG+0x04);
-	ctrl_outl(0x00002001, GAPSPCI_BBA_CONFIG+0x10);
-	ctrl_outl(0x01000000, GAPSPCI_BBA_CONFIG+0x14);
+	outw(0xf900, GAPSPCI_BBA_CONFIG+0x06);
+	outl(0x00000000, GAPSPCI_BBA_CONFIG+0x30);
+	outb(0x00, GAPSPCI_BBA_CONFIG+0x3c);
+	outb(0xf0, GAPSPCI_BBA_CONFIG+0x0d);
+	outw(0x0006, GAPSPCI_BBA_CONFIG+0x04);
+	outl(0x00002001, GAPSPCI_BBA_CONFIG+0x10);
+	outl(0x01000000, GAPSPCI_BBA_CONFIG+0x14);
 
 	return 0;
 }
diff -puN arch/sh/drivers/pci/pci-sh4.h~revert-sh-use-ctrl_in-out-for-on-chip-pci-access arch/sh/drivers/pci/pci-sh4.h
--- a/arch/sh/drivers/pci/pci-sh4.h~revert-sh-use-ctrl_in-out-for-on-chip-pci-access
+++ a/arch/sh/drivers/pci/pci-sh4.h
@@ -170,11 +170,11 @@ struct sh4_pci_address_map {
 
 static inline void pci_write_reg(unsigned long val, unsigned long reg)
 {
-	ctrl_outl(val, PCI_REG(reg));
+	outl(val, PCI_REG(reg));
 }
 
 static inline unsigned long pci_read_reg(unsigned long reg)
 {
-	return ctrl_inl(PCI_REG(reg));
+	return inl(PCI_REG(reg));
 }
 #endif /* __PCI_SH4_H */
diff -puN arch/sh/drivers/pci/pci-sh7751.c~revert-sh-use-ctrl_in-out-for-on-chip-pci-access arch/sh/drivers/pci/pci-sh7751.c
--- a/arch/sh/drivers/pci/pci-sh7751.c~revert-sh-use-ctrl_in-out-for-on-chip-pci-access
+++ a/arch/sh/drivers/pci/pci-sh7751.c
@@ -58,7 +58,7 @@ static int __init __area_sdram_check(uns
 {
 	u32 word;
 
-	word = ctrl_inl(SH7751_BCR1);
+	word = inl(SH7751_BCR1);
 	/* check BCR for SDRAM in area */
 	if (((word >> area) & 1) == 0) {
 		printk("PCI: Area %d is not configured for SDRAM. BCR1=0x%x\n",
@@ -67,7 +67,7 @@ static int __init __area_sdram_check(uns
 	}
 	pci_write_reg(word, SH4_PCIBCR1);
 
-	word = (u16)ctrl_inw(SH7751_BCR2);
+	word = (u16)inw(SH7751_BCR2);
 	/* check BCR2 for 32bit SDRAM interface*/
 	if (((word >> (area << 1)) & 0x3) != 0x3) {
 		printk("PCI: Area %d is not 32 bit SDRAM. BCR2=0x%x\n",
@@ -85,9 +85,9 @@ int __init sh7751_pcic_init(struct sh4_p
 	u32 word;
 
 	/* Set the BCR's to enable PCI access */
-	reg = ctrl_inl(SH7751_BCR1);
+	reg = inl(SH7751_BCR1);
 	reg |= 0x80000;
-	ctrl_outl(reg, SH7751_BCR1);
+	outl(reg, SH7751_BCR1);
 
 	/* Turn the clocks back on (not done in reset)*/
 	pci_write_reg(0, SH4_PCICLKR);
@@ -179,13 +179,13 @@ int __init sh7751_pcic_init(struct sh4_p
 		return 0;
 
 	/* configure the wait control registers */
-	word = ctrl_inl(SH7751_WCR1);
+	word = inl(SH7751_WCR1);
 	pci_write_reg(word, SH4_PCIWCR1);
-	word = ctrl_inl(SH7751_WCR2);
+	word = inl(SH7751_WCR2);
 	pci_write_reg(word, SH4_PCIWCR2);
-	word = ctrl_inl(SH7751_WCR3);
+	word = inl(SH7751_WCR3);
 	pci_write_reg(word, SH4_PCIWCR3);
-	word = ctrl_inl(SH7751_MCR);
+	word = inl(SH7751_MCR);
 	pci_write_reg(word, SH4_PCIMCR);
 
 	/* NOTE: I'm ignoring the PCI error IRQs for now..
diff -puN arch/sh/drivers/pci/pci-sh7780.c~revert-sh-use-ctrl_in-out-for-on-chip-pci-access arch/sh/drivers/pci/pci-sh7780.c
--- a/arch/sh/drivers/pci/pci-sh7780.c~revert-sh-use-ctrl_in-out-for-on-chip-pci-access
+++ a/arch/sh/drivers/pci/pci-sh7780.c
@@ -52,7 +52,7 @@ static int __init sh7780_pci_init(void)
 
 	pr_debug("PCI: Starting intialization.\n");
 
-	ctrl_outl(0x00000001, SH7780_PCI_VCR2); /* Enable PCIC */
+	outl(0x00000001, SH7780_PCI_VCR2); /* Enable PCIC */
 
 	/* check for SH7780/SH7780R hardware */
 	id = pci_read_reg(SH7780_PCIVID);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-send-a-single-notification-on-device-state-changes.patch
softlockup-workaround.patch
git-acpi-powerpc-kconfig-fix.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-agpgart-make-ia64-compile.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
git-dvb.patch
git-dvb-someone-broke-the-gpio-includes.patch
git-hwmon.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
git-md-accel.patch
git-ubi.patch
git-net.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
git-nfsd-fix.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
git-sched.patch
git-sched-git-rejects.patch
tracing-is-borked-on-powerpc.patch
scsi-aic94xx-cleanups.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-block-git-rejects.patch
git-sparc64.patch
git-unionfs.patch
git-unionfs-git-rejects.patch
unionfs-is-broken.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
git-xtensa.patch
add-rcu_assign_index-if-ever-needed-fix.patch
revert-sh-use-ctrl_in-out-for-on-chip-pci-access.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
procfs-task-exe-symlink-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
