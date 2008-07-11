From: akpm@linux-foundation.org
Subject: - linux-next-git-rejects.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:19:28 -0700
Message-ID: <200807112319.m6BNJSGV009792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754261AbYGKXUA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:20:00 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m6BNJS96016628
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 11 Jul 2008 16:19:29 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                |    7 -
 drivers/ide/ide.c          |    7 -
 drivers/mmc/host/sdhci.c   |  132 -----------------------------------
 drivers/usb/core/hcd.c     |   10 --
 drivers/usb/core/hub.c     |   19 -----
 fs/proc/task_mmu.c         |   30 -------
 include/linux/securebits.h |    7 -
 kernel/softlockup.c        |    3 
 8 files changed, 215 deletions(-)

diff -puN arch/x86/Kconfig~linux-next-git-rejects arch/x86/Kconfig
diff -puN drivers/char/tty_io.c~linux-next-git-rejects drivers/char/tty_io.c
diff -puN drivers/media/video/Kconfig~linux-next-git-rejects drivers/media/video/Kconfig
diff -puN drivers/usb/core/hub.c~linux-next-git-rejects drivers/usb/core/hub.c
--- a/drivers/usb/core/hub.c~linux-next-git-rejects
+++ a/drivers/usb/core/hub.c
@@ -711,14 +711,6 @@ enum hub_quiescing_type {
 	HUB_DISCONNECT, HUB_PRE_RESET, HUB_SUSPEND
 };
 
-<<<<<<< HEAD:drivers/usb/core/hub.c
-		/* Was the power session lost while we were suspended? */
-		status = hub_port_status(hub, port1, &portstatus, &portchange);
-
-		/* If the device is gone, khubd will handle it later */
-		if (status == 0 && !(portstatus & USB_PORT_STAT_CONNECTION))
-			continue;
-=======
 static void hub_quiesce(struct usb_hub *hub, enum hub_quiescing_type type)
 {
 	struct usb_device *hdev = hub->hdev;
@@ -726,7 +718,6 @@ static void hub_quiesce(struct usb_hub *
 
 	/* khubd and related activity won't re-trigger */
 	hub->quiescing = 1;
->>>>>>> FETCH_HEAD:drivers/usb/core/hub.c
 
 	if (type != HUB_SUSPEND) {
 		/* Disconnect all the children */
@@ -3089,16 +3080,6 @@ static void hub_events(void)
 			}
 		}
 
-<<<<<<< HEAD:drivers/usb/core/hub.c
-		hub->activating = 0;
-
-		/* If this is a root hub, tell the HCD it's okay to
-		 * re-enable port-change interrupts now. */
-		if (!hdev->parent && !hub->busy_bits[0])
-			usb_enable_root_hub_irq(hdev->bus);
-
-=======
->>>>>>> FETCH_HEAD:drivers/usb/core/hub.c
 loop_autopm:
 		/* Allow autosuspend if we're not going to run again */
 		if (list_empty(&hub->event_list))
diff -puN MAINTAINERS~linux-next-git-rejects MAINTAINERS
--- a/MAINTAINERS~linux-next-git-rejects
+++ a/MAINTAINERS
@@ -2857,17 +2857,10 @@ W:	http://0pointer.de/lennart/tchibo.htm
 S:	Maintained
 
 MULTIFUNCTION DEVICES (MFD)
-<<<<<<< HEAD:MAINTAINERS
-P:	Samuel Ortiz
-M:	sameo@openedhand.com
-L:	linux-kernel@vger.kernel.org
-S:	Supported
-=======
 P:     Samuel Ortiz
 M:     sameo@openedhand.com
 L:     linux-kernel@vger.kernel.org
 S:     Supported
->>>>>>> FETCH_HEAD:MAINTAINERS
 
 MULTIMEDIA CARD (MMC), SECURE DIGITAL (SD) AND SDIO SUBSYSTEM
 P:	Pierre Ossman
diff -puN drivers/ide/ide.c~linux-next-git-rejects drivers/ide/ide.c
--- a/drivers/ide/ide.c~linux-next-git-rejects
+++ a/drivers/ide/ide.c
@@ -232,14 +232,7 @@ void ide_unregister(ide_hwif_t *hwif)
 
 	if (hwif->dma_base)
 		ide_release_dma_engine(hwif);
-<<<<<<< HEAD:drivers/ide/ide.c
-
-	spin_lock_irq(&ide_lock);
-	/* restore hwif data to pristine status */
-	ide_init_port_data(hwif, hwif->index);
-=======
 abort:
->>>>>>> FETCH_HEAD:drivers/ide/ide.c
 	spin_unlock_irq(&ide_lock);
 
 	mutex_unlock(&ide_cfg_mtx);
diff -puN drivers/mmc/host/sdhci.c~linux-next-git-rejects drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~linux-next-git-rejects
+++ a/drivers/mmc/host/sdhci.c
@@ -32,138 +32,6 @@
 
 static unsigned int debug_quirks = 0;
 
-<<<<<<< HEAD:drivers/mmc/host/sdhci.c
-/*
- * Different quirks to handle when the hardware deviates from a strict
- * interpretation of the SDHCI specification.
- */
-
-/* Controller doesn't honor resets unless we touch the clock register */
-#define SDHCI_QUIRK_CLOCK_BEFORE_RESET			(1<<0)
-/* Controller has bad caps bits, but really supports DMA */
-#define SDHCI_QUIRK_FORCE_DMA				(1<<1)
-/* Controller doesn't like to be reset when there is no card inserted. */
-#define SDHCI_QUIRK_NO_CARD_NO_RESET			(1<<2)
-/* Controller doesn't like clearing the power reg before a change */
-#define SDHCI_QUIRK_SINGLE_POWER_WRITE			(1<<3)
-/* Controller has flaky internal state so reset it on each ios change */
-#define SDHCI_QUIRK_RESET_CMD_DATA_ON_IOS		(1<<4)
-/* Controller has an unusable DMA engine */
-#define SDHCI_QUIRK_BROKEN_DMA				(1<<5)
-/* Controller can only DMA from 32-bit aligned addresses */
-#define SDHCI_QUIRK_32BIT_DMA_ADDR			(1<<6)
-/* Controller can only DMA chunk sizes that are a multiple of 32 bits */
-#define SDHCI_QUIRK_32BIT_DMA_SIZE			(1<<7)
-/* Controller needs to be reset after each request to stay stable */
-#define SDHCI_QUIRK_RESET_AFTER_REQUEST			(1<<8)
-/* Controller needs voltage and power writes to happen separately */
-#define SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER		(1<<9)
-/* Controller has an off-by-one issue with timeout value */
-#define SDHCI_QUIRK_INCR_TIMEOUT_CONTROL		(1<<10)
-
-static const struct pci_device_id pci_ids[] __devinitdata = {
-	{
-		.vendor		= PCI_VENDOR_ID_RICOH,
-		.device		= PCI_DEVICE_ID_RICOH_R5C822,
-		.subvendor	= PCI_VENDOR_ID_IBM,
-		.subdevice	= PCI_ANY_ID,
-		.driver_data	= SDHCI_QUIRK_CLOCK_BEFORE_RESET |
-				  SDHCI_QUIRK_FORCE_DMA,
-	},
-
-	{
-		.vendor		= PCI_VENDOR_ID_RICOH,
-		.device		= PCI_DEVICE_ID_RICOH_R5C822,
-		.subvendor	= PCI_VENDOR_ID_SAMSUNG,
-		.subdevice	= PCI_ANY_ID,
-		.driver_data	= SDHCI_QUIRK_FORCE_DMA |
-				  SDHCI_QUIRK_NO_CARD_NO_RESET,
-	},
-
-	{
-		.vendor		= PCI_VENDOR_ID_RICOH,
-		.device		= PCI_DEVICE_ID_RICOH_R5C822,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.driver_data	= SDHCI_QUIRK_FORCE_DMA,
-	},
-
-	{
-		.vendor		= PCI_VENDOR_ID_TI,
-		.device		= PCI_DEVICE_ID_TI_XX21_XX11_SD,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.driver_data	= SDHCI_QUIRK_FORCE_DMA,
-	},
-
-	{
-		.vendor		= PCI_VENDOR_ID_ENE,
-		.device		= PCI_DEVICE_ID_ENE_CB712_SD,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.driver_data	= SDHCI_QUIRK_SINGLE_POWER_WRITE |
-				  SDHCI_QUIRK_BROKEN_DMA,
-	},
-
-	{
-		.vendor		= PCI_VENDOR_ID_ENE,
-		.device		= PCI_DEVICE_ID_ENE_CB712_SD_2,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.driver_data	= SDHCI_QUIRK_SINGLE_POWER_WRITE |
-				  SDHCI_QUIRK_BROKEN_DMA,
-	},
-
-	{
-		.vendor         = PCI_VENDOR_ID_ENE,
-		.device         = PCI_DEVICE_ID_ENE_CB714_SD,
-		.subvendor      = PCI_ANY_ID,
-		.subdevice      = PCI_ANY_ID,
-		.driver_data    = SDHCI_QUIRK_SINGLE_POWER_WRITE |
-				  SDHCI_QUIRK_RESET_CMD_DATA_ON_IOS |
-				  SDHCI_QUIRK_BROKEN_DMA,
-	},
-
-	{
-		.vendor         = PCI_VENDOR_ID_ENE,
-		.device         = PCI_DEVICE_ID_ENE_CB714_SD_2,
-		.subvendor      = PCI_ANY_ID,
-		.subdevice      = PCI_ANY_ID,
-		.driver_data    = SDHCI_QUIRK_SINGLE_POWER_WRITE |
-				  SDHCI_QUIRK_RESET_CMD_DATA_ON_IOS |
-				  SDHCI_QUIRK_BROKEN_DMA,
-	},
-
-	{
-		.vendor         = PCI_VENDOR_ID_MARVELL,
-		.device         = PCI_DEVICE_ID_MARVELL_CAFE_SD,
-		.subvendor      = PCI_ANY_ID,
-		.subdevice      = PCI_ANY_ID,
-		.driver_data    = SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER |
-				  SDHCI_QUIRK_INCR_TIMEOUT_CONTROL,
-	},
-
-	{
-		.vendor         = PCI_VENDOR_ID_JMICRON,
-		.device         = PCI_DEVICE_ID_JMICRON_JMB38X_SD,
-		.subvendor      = PCI_ANY_ID,
-		.subdevice      = PCI_ANY_ID,
-		.driver_data    = SDHCI_QUIRK_32BIT_DMA_ADDR |
-				  SDHCI_QUIRK_32BIT_DMA_SIZE |
-				  SDHCI_QUIRK_RESET_AFTER_REQUEST,
-	},
-
-	{	/* Generic SD host controller */
-		PCI_DEVICE_CLASS((PCI_CLASS_SYSTEM_SDHCI << 8), 0xFFFF00)
-	},
-
-	{ /* end: all zeroes */ },
-};
-
-MODULE_DEVICE_TABLE(pci, pci_ids);
-
-=======
->>>>>>> FETCH_HEAD:drivers/mmc/host/sdhci.c
 static void sdhci_prepare_data(struct sdhci_host *, struct mmc_data *);
 static void sdhci_finish_data(struct sdhci_host *);
 
diff -puN drivers/usb/core/hcd.c~linux-next-git-rejects drivers/usb/core/hcd.c
--- a/drivers/usb/core/hcd.c~linux-next-git-rejects
+++ a/drivers/usb/core/hcd.c
@@ -1709,21 +1709,11 @@ irqreturn_t usb_hcd_irq (int irq, void *
 		rc = IRQ_NONE;
 	} else {
 		set_bit(HCD_FLAG_SAW_IRQ, &hcd->flags);
-<<<<<<< HEAD:drivers/usb/core/hcd.c
 
 		if (unlikely(hcd->state == HC_STATE_HALT))
 			usb_hc_died(hcd);
 		rc = IRQ_HANDLED;
 	}
-
-=======
-
-		if (unlikely(hcd->state == HC_STATE_HALT))
-			usb_hc_died(hcd);
-		rc = IRQ_HANDLED;
-	}
-
->>>>>>> FETCH_HEAD:drivers/usb/core/hcd.c
 	local_irq_restore(flags);
 	return rc;
 }
diff -puN fs/proc/task_mmu.c~linux-next-git-rejects fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~linux-next-git-rejects
+++ a/fs/proc/task_mmu.c
@@ -688,35 +688,6 @@ static ssize_t pagemap_read(struct file 
 	pm.out = (u64 *)buf;
 	pm.end = (u64 *)(buf + count);
 
-<<<<<<< HEAD:fs/proc/task_mmu.c
-	pagemap_walk.pmd_entry = pagemap_pte_range;
-	pagemap_walk.pte_hole = pagemap_pte_hole;
-	pagemap_walk.mm = mm;
-	pagemap_walk.private = &pm;
-
-	src = *ppos;
-	svpfn = src / PM_ENTRY_BYTES;
-	start_vaddr = svpfn << PAGE_SHIFT;
-	end_vaddr = TASK_SIZE_OF(task);
-
-	/* watch out for wraparound */
-	if (svpfn > TASK_SIZE_OF(task) >> PAGE_SHIFT)
-		start_vaddr = end_vaddr;
-
-	/*
-	 * The odds are that this will stop walking way
-	 * before end_vaddr, because the length of the
-	 * user buffer is tracked in "pm", and the walk
-	 * will stop when we hit the end of the buffer.
-	 */
-	ret = walk_page_range(start_vaddr, end_vaddr, &pagemap_walk);
-	if (ret == PM_END_OF_BUFFER)
-		ret = 0;
-	/* don't need mmap_sem for these, but this looks cleaner */
-	*ppos += (char *)pm.out - buf;
-	if (!ret)
-		ret = (char *)pm.out - buf;
-=======
 	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
 		ret = -EIO;
 	} else {
@@ -744,7 +715,6 @@ static ssize_t pagemap_read(struct file 
 		if (!ret)
 			ret = (char *)pm.out - buf;
 	}
->>>>>>> FETCH_HEAD:fs/proc/task_mmu.c
 
 out_pages:
 	for (; pagecount; pagecount--) {
diff -puN include/linux/securebits.h~linux-next-git-rejects include/linux/securebits.h
--- a/include/linux/securebits.h~linux-next-git-rejects
+++ a/include/linux/securebits.h
@@ -12,16 +12,9 @@
 #define SECURE_NOROOT			0
 #define SECURE_NOROOT_LOCKED		1  /* make bit-0 immutable */
 
-<<<<<<< HEAD:include/linux/securebits.h
-/* When set, setuid to/from uid 0 does not trigger capability-"fixup".
-   When unset, to provide compatiblility with old programs relying on
-   set*uid to gain/lose privilege, transitions to/from uid 0 cause
-   capabilities to be gained/lost. */
-=======
 /* When set, setuid to/from uid 0 does not trigger capability-"fixes"
    to be compatible with old programs relying on set*uid to lose
    privileges. When unset, setuid doesn't change privileges. */
->>>>>>> FETCH_HEAD:include/linux/securebits.h
 #define SECURE_NO_SETUID_FIXUP		2
 #define SECURE_NO_SETUID_FIXUP_LOCKED	3  /* make bit-2 immutable */
 
diff -puN kernel/softlockup.c~linux-next-git-rejects kernel/softlockup.c
--- a/kernel/softlockup.c~linux-next-git-rejects
+++ a/kernel/softlockup.c
@@ -145,10 +145,7 @@ void softlockup_tick(void)
 			this_cpu, now - touch_timestamp,
 			current->comm, task_pid_nr(current));
 	print_modules();
-<<<<<<< HEAD:kernel/softlockup.c
-=======
 	print_irqtrace_events(current);
->>>>>>> FETCH_HEAD:kernel/softlockup.c
 	if (regs)
 		show_regs(regs);
 	else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
kvm-is-busted-on-ia64.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
pci-make-pci_register_driver-a-macro.patch
git-acpi.patch
arch-x86-kernel-smpbootc-fix-warning.patch
arch-x86-mm-pgtable_32c-remove-unused-variable-fixmaps.patch
git-arm.patch
git-thumb2.patch
git-pcmcia.patch
git-powerpc.patch
git-dvb.patch
drivers-media-video-cx18-cx18-av-firmwarec-fix-warning.patch
drivers-media-video-uvc-uvc_v4l2c-suppress-uninitialized-var-warning.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hid.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
git-input.patch
git-jg-misc.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
git-kvm.patch
git-leds.patch
git-async-tx.patch
git-mips.patch
mmc-sd-host-driver-for-ricoh-bay1controllers.patch
git-mtd.patch
git-ubifs.patch
git-net-next.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
git-ocfs2.patch
git-pci-next.patch
regulator-ti-bq24022-li-ion-charger-driver-fix.patch
git-s390.patch
git-scsi-misc.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
git-block.patch
pktcdvd-push-bkl-down-into-driver.patch
git-unionfs.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
watchdog-wdt501-pci-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
spufs-use-the-new-vm_ops-access-fix.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
mapping_set_error-add-unlikely.patch
huge-page-private-reservation-review-cleanups-fix.patch
vma-page-offset-has-no-callees-drop-it.patch
sync_file_range_write-may-and-will-block-document-that-fix.patch
vmallocinfo-add-numa-information-fix.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlb-override-default-huge-page-size-ia64-build.patch
linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-add-debugging-framework-fix.patch
bootmem-clean-up-free_all_bootmem_core-fix.patch
bootmem-free-reserve-helpers-fix.patch
revert-revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-factor-out-the-marking-of-a-pfn-range-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-v850-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-arm-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-mips-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-dvb.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-mtd-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fixes.patch
mmu-notifiers-add-mm_take_all_locks-operation-checkpatch-fixes.patch
mmu-notifier-core-checkpatch-fixes.patch
mmu-notifier-core-fix.patch
mmu-notifier-core-fix-2.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
security-protect-legacy-applications-from-executing-with-insufficient-privilege-checkpatch-fixes.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
build-kernel-profileo-only-when-requested-cleanups.patch
seq_file-fix-bug-when-seq_read-reads-nothing-fix.patch
exec-remove-some-includes-fix.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha.patch
spi-au1550_spi-improve-pio-transfer-mode-checkpatch-fixes.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes.patch
lcd-add-platform_lcd-driver-fix.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact-fix.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver-fix.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup.patch
ext3-handle-corrupted-orphan-list-at-mount-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix.patch
ext3-handle-deleting-corrupted-indirect-blocks-fix.patch
jbd-dont-abort-if-flushing-file-data-failed-fix.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
jbd2-fix-race-between-jbd2_journal_try_to_free_buffers-and-jbd2-commit-transaction-cleanup.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-pasemi_mac.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary-checkpatch-fixes.patch
tpm-increase-size-of-internal-tpm-response-buffers-checkpatch-fixes.patch
memstick-allow-set_param-method-to-return-an-error-code-checkpatch-fixes.patch
memstick-use-fully-asynchronous-request-processing-fix.patch
full-conversion-to-early_initcall-interface-remove-old-interface-cleanup.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
define-page_file_cache-function-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-units-fix.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-page-statistics-units-fix.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix.patch
resource-add-resource_size-fix.patch
resource-add-resource_type-and-ioresource_type_bits-fix.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

