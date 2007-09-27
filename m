From: akpm@linux-foundation.org
Subject: - git-net-sky2-fixups.patch removed from -mm tree
Date: Wed, 26 Sep 2007 18:43:30 -0700
Message-ID: <200709270143.l8R1hULp013968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39891 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752555AbXI0But (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 21:50:49 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l8R1okNS007339
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2007 18:50:47 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-net-sky2-fixups
has been removed from the -mm tree.  Its filename was
     git-net-sky2-fixups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-net-sky2-fixups
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sky2.c |  131 -------------------------------------------
 drivers/net/sky2.h |    6 -
 2 files changed, 137 deletions(-)

diff -puN drivers/net/sky2.c~git-net-sky2-fixups drivers/net/sky2.c
--- a/drivers/net/sky2.c~git-net-sky2-fixups
+++ a/drivers/net/sky2.c
@@ -119,11 +119,8 @@ static const struct pci_device_id sky2_i
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4351) }, /* 88E8036 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4352) }, /* 88E8038 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4353) }, /* 88E8039 */
-<<<<<<< HEAD/drivers/net/sky2.c
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4354) }, /* 88E8040 */
-=======
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4356) }, /* 88E8033 */
->>>>>>> /drivers/net/sky2.c
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4356) }, /* 88EC033 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x435A) }, /* 88E8048 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4360) }, /* 88E8052 */
@@ -226,13 +223,9 @@ static void sky2_power_on(struct sky2_hw
 	else
 		sky2_write8(hw, B2_Y2_CLK_GATE, 0);
 
-<<<<<<< HEAD/drivers/net/sky2.c
-	if (hw->flags & SKY2_HW_ADV_POWER_CTL) {
-=======
 	if (hw->chip_id == CHIP_ID_YUKON_EC_U ||
 	    hw->chip_id == CHIP_ID_YUKON_EX) {
 		struct pci_dev *pdev = hw->pdev;
->>>>>>> /drivers/net/sky2.c
 		u32 reg;
 
 		pci_write_config_dword(pdev, PCI_DEV_REG3, 0);
@@ -346,12 +339,8 @@ static void sky2_phy_init(struct sky2_hw
 
 	ctrl = gm_phy_read(hw, port, PHY_MARV_PHY_CTRL);
 	if (sky2_is_copper(hw)) {
-<<<<<<< HEAD/drivers/net/sky2.c
-		if (!(hw->flags & SKY2_HW_GIGABIT)) {
-=======
 		if (hw->chip_id == CHIP_ID_YUKON_FE ||
 		    hw->chip_id == CHIP_ID_YUKON_FE_P) {
->>>>>>> /drivers/net/sky2.c
 			/* enable automatic crossover */
 			ctrl |= PHY_M_PC_MDI_XMODE(PHY_M_PC_ENA_AUTO) >> 1;
 		} else {
@@ -470,11 +459,7 @@ static void sky2_phy_init(struct sky2_hw
 
 	gma_write16(hw, port, GM_GP_CTRL, reg);
 
-<<<<<<< HEAD/drivers/net/sky2.c
-	if (hw->flags & SKY2_HW_GIGABIT)
-=======
 	if (sky2_is_gigabit(hw))
->>>>>>> /drivers/net/sky2.c
 		gm_phy_write(hw, port, PHY_MARV_1000T_CTRL, ct1000);
 
 	gm_phy_write(hw, port, PHY_MARV_AUNE_ADV, adv);
@@ -498,25 +483,6 @@ static void sky2_phy_init(struct sky2_hw
 		gm_phy_write(hw, port, PHY_MARV_FE_LED_PAR, ctrl);
 		break;
 
-<<<<<<< HEAD/drivers/net/sky2.c
-	case CHIP_ID_YUKON_FE_P:
-		/* Enable Link Partner Next Page */
-		ctrl = gm_phy_read(hw, port, PHY_MARV_PHY_CTRL);
-		ctrl |= PHY_M_PC_ENA_LIP_NP;
-
-		/* disable Energy Detect and enable scrambler */
-		ctrl &= ~(PHY_M_PC_ENA_ENE_DT | PHY_M_PC_DIS_SCRAMB);
-		gm_phy_write(hw, port, PHY_MARV_PHY_CTRL, ctrl);
-
-		/* set LED2 -> ACT, LED1 -> LINK, LED0 -> SPEED */
-		ctrl = PHY_M_FELP_LED2_CTRL(LED_PAR_CTRL_ACT_BL) |
-			PHY_M_FELP_LED1_CTRL(LED_PAR_CTRL_LINK) |
-			PHY_M_FELP_LED0_CTRL(LED_PAR_CTRL_SPEED);
-
-		gm_phy_write(hw, port, PHY_MARV_FE_LED_PAR, ctrl);
-		break;
-
-=======
 	case CHIP_ID_YUKON_FE_P:
 		/* Enable Link Partner Next Page */
 		ctrl |= PHY_M_PC_ENA_LIP_NP;
@@ -533,7 +499,6 @@ static void sky2_phy_init(struct sky2_hw
 		gm_phy_write(hw, port, PHY_MARV_FE_LED_PAR, ctrl);
 		break;
 
->>>>>>> /drivers/net/sky2.c
 	case CHIP_ID_YUKON_XL:
 		pg = gm_phy_read(hw, port, PHY_MARV_EXT_ADR);
 
@@ -1777,21 +1742,12 @@ static u16 sky2_phy_speed(const struct s
 	if (hw->flags & SKY2_HW_FIBRE_PHY)
 		return SPEED_1000;
 
-<<<<<<< HEAD/drivers/net/sky2.c
-	if (!(hw->flags & SKY2_HW_GIGABIT)) {
-		if (aux & PHY_M_PS_SPEED_100)
-			return SPEED_100;
-		else
-			return SPEED_10;
-	}
-=======
 	if (!sky2_is_gigabit(hw)) {
 		if (aux & PHY_M_PS_SPEED_100)
 			return SPEED_100;
 		else
 			return SPEED_10;
 	}
->>>>>>> /drivers/net/sky2.c
 
 	switch (aux & PHY_M_PS_SPEED_MSK) {
 	case PHY_M_PS_SPEED_1000:
@@ -2555,40 +2511,9 @@ static int sky2_rx_hung(struct net_devic
 static void sky2_watchdog(unsigned long arg)
 {
 	struct sky2_hw *hw = (struct sky2_hw *) arg;
-	struct net_device *dev;
 
-<<<<<<< HEAD/drivers/net/sky2.c
-	/* Check for lost IRQ once a second */
-	if (sky2_read32(hw, B0_ISRC)) {
-		dev = hw->dev[0];
-		if (__netif_rx_schedule_prep(dev))
-			__netif_rx_schedule(dev);
-	} else {
-		int i, active = 0;
-
-		for (i = 0; i < hw->ports; i++) {
-			dev = hw->dev[i];
-			if (!netif_running(dev))
-				continue;
-			++active;
-
-			/* For chips with Rx FIFO, check if stuck */
-			if ((hw->flags & SKY2_HW_RAMBUFFER) &&
-			     sky2_rx_hung(dev)) {
-				pr_info(PFX "%s: receiver hang detected\n",
-					dev->name);
-				schedule_work(&hw->restart_work);
-				return;
-			}
-		}
-
-		if (active == 0)
-			return;
-	}
-=======
 	if (sky2_read32(hw, B0_ISRC))
 		napi_schedule(&hw->napi);
->>>>>>> /drivers/net/sky2.c
 
 	mod_timer(&hw->watchdog_timer, round_jiffies(jiffies + HZ));
 }
@@ -2727,57 +2652,8 @@ static int __devinit sky2_init(struct sk
 	sky2_write8(hw, B0_CTST, CS_RST_CLR);
 
 	hw->chip_id = sky2_read8(hw, B2_CHIP_ID);
-<<<<<<< HEAD/drivers/net/sky2.c
-	hw->chip_rev = (sky2_read8(hw, B2_MAC_CFG) & CFG_CHIP_R_MSK) >> 4;
-
-	switch(hw->chip_id) {
-	case CHIP_ID_YUKON_XL:
-		hw->flags = SKY2_HW_GIGABIT
-			| SKY2_HW_NEWER_PHY
-			| SKY2_HW_RAMBUFFER;
-		break;
-
-	case CHIP_ID_YUKON_EC_U:
-		hw->flags = SKY2_HW_GIGABIT
-			| SKY2_HW_NEWER_PHY
-			| SKY2_HW_ADV_POWER_CTL;
-		break;
-
-	case CHIP_ID_YUKON_EX:
-		hw->flags = SKY2_HW_GIGABIT
-			| SKY2_HW_NEWER_PHY
-			| SKY2_HW_NEW_LE
-			| SKY2_HW_ADV_POWER_CTL;
-
-		/* New transmit checksum */
-		if (hw->chip_rev != CHIP_REV_YU_EX_B0)
-			hw->flags |= SKY2_HW_AUTO_TX_SUM;
-		break;
-
-	case CHIP_ID_YUKON_EC:
-		/* This rev is really old, and requires untested workarounds */
-		if (hw->chip_rev == CHIP_REV_YU_EC_A1) {
-			dev_err(&hw->pdev->dev, "unsupported revision Yukon-EC rev A1\n");
-			return -EOPNOTSUPP;
-		}
-		hw->flags = SKY2_HW_GIGABIT | SKY2_HW_RAMBUFFER;
-		break;
-
-	case CHIP_ID_YUKON_FE:
-		hw->flags = SKY2_HW_RAMBUFFER;
-		break;
-
-	case CHIP_ID_YUKON_FE_P:
-		hw->flags = SKY2_HW_NEWER_PHY
-			| SKY2_HW_NEW_LE
-			| SKY2_HW_AUTO_TX_SUM
-			| SKY2_HW_ADV_POWER_CTL;
-		break;
-	default:
-=======
 	if (hw->chip_id < CHIP_ID_YUKON_XL ||
 	    hw->chip_id > CHIP_ID_YUKON_FE_P) {
->>>>>>> /drivers/net/sky2.c
 		dev_err(&hw->pdev->dev, "unsupported chip type 0x%x\n",
 			hw->chip_id);
 		return -EOPNOTSUPP;
@@ -4344,15 +4220,8 @@ static int sky2_resume(struct pci_dev *p
 	pci_enable_wake(pdev, PCI_D0, 0);
 
 	/* Re-enable all clocks */
-<<<<<<< HEAD/drivers/net/sky2.c
-	if (hw->chip_id == CHIP_ID_YUKON_EX ||
-	    hw->chip_id == CHIP_ID_YUKON_EC_U ||
-	    hw->chip_id == CHIP_ID_YUKON_FE_P)
-		sky2_pci_write32(hw, PCI_DEV_REG3, 0);
-=======
 	if (hw->chip_id == CHIP_ID_YUKON_EX || hw->chip_id == CHIP_ID_YUKON_EC_U)
 		pci_write_config_dword(pdev, PCI_DEV_REG3, 0);
->>>>>>> /drivers/net/sky2.c
 
 	sky2_reset(hw);
 
diff -puN drivers/net/sky2.h~git-net-sky2-fixups drivers/net/sky2.h
--- a/drivers/net/sky2.h~git-net-sky2-fixups
+++ a/drivers/net/sky2.h
@@ -429,15 +429,9 @@ enum {
 	CHIP_ID_YUKON_EX   = 0xb5, /* Chip ID for YUKON-2 Extreme */
 	CHIP_ID_YUKON_EC   = 0xb6, /* Chip ID for YUKON-2 EC */
  	CHIP_ID_YUKON_FE   = 0xb7, /* Chip ID for YUKON-2 FE */
-<<<<<<< HEAD/drivers/net/sky2.h
- 	CHIP_ID_YUKON_FE_P = 0xb8, /* Chip ID for YUKON-2 FE+ */
-};
-enum yukon_ec_rev {
-=======
 	CHIP_ID_YUKON_FE_P = 0xb8, /* Chip ID for YUKON-2 FE+ */
 };
 enum yukon_ec_rev {
->>>>>>> /drivers/net/sky2.h
 	CHIP_REV_YU_EC_A1    = 0,  /* Chip Rev. for Yukon-EC A1/A0 */
 	CHIP_REV_YU_EC_A2    = 1,  /* Chip Rev. for Yukon-EC A2 */
 	CHIP_REV_YU_EC_A3    = 2,  /* Chip Rev. for Yukon-EC A3 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-oops-in-platform-uevent.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
acpi-add-reboot-mechanism.patch
acpi-suppress-uninitialized-var-warning.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
powerpc-proper-defconfig-for-crosscompiles-fix.patch
git-dvb.patch
git-dvb-fixup-2.patch
git-dvb-build-fix.patch
git-hwmon-fixup.patch
drivers-hid-hid-debugc-add-kern_debug-prefix-fix-typo-constify-fix.patch
git-infiniband.patch
infiniband-work-around-gcc-slub-problem.patch
git-input.patch
git-input-fixup.patch
adbhid-produce-all-capslock-key-events.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers-fix.patch
git-jg-misc-fix.patch
git-jg-warning-fixes.patch
git-kbuild.patch
git-kbuild-fixup.patch
git-kvm.patch
git-libata-all.patch
ide-arm-hack.patch
git-mips.patch
git-mmc.patch
git-mmc-fixup2.patch
mmc-fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
git-mtd.patch
git-mtd-vs-powerpc.patch
git-net.patch
git-net-fixup.patch
git-net-fix-wireless-kconfig.patch
net-atm-lecc-printk-warning-fix.patch
git-backlight.patch
git-backlight-dependency-fix.patch
revert-git-battery.patch
git-net-vs-git-nfs.patch
git-nfs-vs-git-unionfs.patch
git-nfsd.patch
git-ocfs2.patch
git-r8169-fixup.patch
revert-gregkh-pci-pci_bridge-device.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
fix-ide-legacy-mode-resources-fix.patch
git-s390.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
git-scsi-misc-arcmsr-build-fix.patch
advansys-printk-fix.patch
git-block.patch
git-block-fixup.patch
git-unionfs.patch
git-unionfs-fix-2.patch
fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
net-add-ath5k-wireless-driver-fix.patch
revert-x86_64-mm-cpa-einval.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix-2.patch
asm-i386-ioh-fix-constness.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft-fix.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-fix.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-fix.patch
git-xfs.patch
git-kgdb-fixup.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
git-nfs-vs-nfs-convert-to-new-aops.patch
git-nfs-vs-nfs-convert-to-new-aops-fix.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2-3.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
mm-mempolicyc-cleanups-fix.patch
mm-bdi-init-hooks.patch
mm-per-device-dirty-threshold-warning-fix.patch
mm-dirty-balancing-for-tasks-warning-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix-2.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-do-not-take-callback_mutex-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
uml-clocksource-support-fix.patch
uml-tickless-support-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
pie-executable-randomization-fix-2.patch
i386-and-x86_64-randomize-brk-fix.patch
binfmt_flat-warning-fixes.patch
console-events-and-accessibility-fix.patch
track-accurate-idle-time-with-tick_schedidle_sleeptime-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch
keys-make-request_key-and-co-fundamentally-asynchronous-vs-git-mmc.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished-fix.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
kernel-printkc-concerns-about-the-console-handover.patch
userc-ifdef-mq_bytes-fix.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ext2-reservations-fix-for-percpu_counter-changes.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
intel-fb-support-for-interlaced-video-modes.patch
export-font_vga_8x16.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
md-software-raid-autodetect-dev-list-not-array-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
powerpc-lock-bitops-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
rework-proc-locks-via-seq_files-and-seq_list-helpers-fix.patch
rework-proc-locks-via-seq_files-and-seq_list-helpers-fix-2.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
