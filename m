From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 17 Jun 2013 12:32:25 -0700
Message-ID: <51bf6449.JJw8PTZbRPX+nxES%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab3FQTc0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jun 2013 15:32:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 17 Jun 2013 12:32:25 -0700


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-kirkwood/board-ts219.c   |    5 ---
 arch/mips/kernel/traps.c               |    6 ----
 arch/s390/include/asm/pgtable.h        |    4 --
 drivers/block/rbd.c                    |    4 --
 drivers/gpu/drm/i915/intel_display.c   |    7 ----
 drivers/gpu/drm/i915/intel_sdvo.c      |   10 ------
 drivers/net/wireless/ath/ath9k/Kconfig |   11 -------
 drivers/pinctrl/sh-pfc/pfc-r8a7779.c   |   33 -----------------------
 drivers/spi/spi-xilinx.c               |   22 ---------------
 fs/ecryptfs/file.c                     |    9 ------
 net/bluetooth/mgmt.c                   |    3 --
 sound/pci/hda/patch_via.c              |   11 -------
 12 files changed, 125 deletions(-)

diff -puN arch/arm/mach-kirkwood/board-ts219.c~linux-next-git-rejects arch/arm/mach-kirkwood/board-ts219.c
--- a/arch/arm/mach-kirkwood/board-ts219.c~linux-next-git-rejects
+++ a/arch/arm/mach-kirkwood/board-ts219.c
@@ -37,9 +37,4 @@ void __init qnap_dt_ts219_init(void)
 		qnap_ts219_ge00_data.phy_addr = MV643XX_ETH_PHY_ADDR(0);
 
 	kirkwood_ge00_init(&qnap_ts219_ge00_data);
-<<<<<<< HEAD
-
-	pm_power_off = qnap_tsx1x_power_off;
-=======
->>>>>>> linux-next/akpm-base
 }
diff -puN arch/mips/kernel/traps.c~linux-next-git-rejects arch/mips/kernel/traps.c
--- a/arch/mips/kernel/traps.c~linux-next-git-rejects
+++ a/arch/mips/kernel/traps.c
@@ -918,17 +918,11 @@ out_sigsegv:
 asmlinkage void do_tr(struct pt_regs *regs)
 {
 	u32 opcode, tcode = 0;
-<<<<<<< HEAD
-	u16 instr[2];
-	unsigned long epc = msk_isa16_mode(exception_epc(regs));
-
-=======
 	enum ctx_state prev_state;
 	u16 instr[2];
 	unsigned long epc = msk_isa16_mode(exception_epc(regs));
 
 	prev_state = exception_enter();
->>>>>>> linux-next/akpm-base
 	if (get_isa16_mode(regs->cp0_epc)) {
 		if (__get_user(instr[0], (u16 __user *)(epc + 0)) ||
 		    __get_user(instr[1], (u16 __user *)(epc + 2)))
diff -puN drivers/block/rbd.c~linux-next-git-rejects drivers/block/rbd.c
--- a/drivers/block/rbd.c~linux-next-git-rejects
+++ a/drivers/block/rbd.c
@@ -520,11 +520,7 @@ static const struct block_device_operati
 
 /*
  * Initialize an rbd client instance.  Success or not, this function
-<<<<<<< HEAD
- * consumes ceph_opts.
-=======
  * consumes ceph_opts.  Caller holds ctl_mutex.
->>>>>>> linux-next/akpm-base
  */
 static struct rbd_client *rbd_client_create(struct ceph_options *ceph_opts)
 {
diff -puN drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_display.c
--- a/drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_display.c
@@ -8256,12 +8256,6 @@ intel_modeset_check_state(struct drm_dev
 
 		active = dev_priv->display.get_pipe_config(crtc,
 							   &pipe_config);
-<<<<<<< HEAD
-
-		/* hw state is inconsistent with the pipe A quirk */
-		if (crtc->pipe == PIPE_A && dev_priv->quirks & QUIRK_PIPEA_FORCE)
-			active = crtc->active;
-=======
 		list_for_each_entry(encoder, &dev->mode_config.encoder_list,
 				    base.head) {
 			if (encoder->base.crtc != &crtc->base)
@@ -8269,7 +8263,6 @@ intel_modeset_check_state(struct drm_dev
 			if (encoder->get_config)
 				encoder->get_config(encoder, &pipe_config);
 		}
->>>>>>> linux-next/akpm-base
 
 		WARN(crtc->active != active,
 		     "crtc active state doesn't match with hw state "
diff -puN drivers/gpu/drm/i915/intel_sdvo.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_sdvo.c
--- a/drivers/gpu/drm/i915/intel_sdvo.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1881,18 +1881,8 @@ static void intel_sdvo_get_lvds_modes(st
 	 */
 	intel_ddc_get_modes(connector, &intel_sdvo->ddc);
 
-<<<<<<< HEAD
-	/*
-	 * Fetch modes from VBT. For SDVO prefer the VBT mode since some
-	 * SDVO->LVDS transcoders can't cope with the EDID mode. Since
-	 * drm_mode_probed_add adds the mode at the head of the list we add it
-	 * last.
-	 */
-	if (dev_priv->sdvo_lvds_vbt_mode != NULL) {
-=======
 	/* Fetch modes from VBT */
 	if (dev_priv->vbt.sdvo_lvds_vbt_mode != NULL) {
->>>>>>> linux-next/akpm-base
 		newmode = drm_mode_duplicate(connector->dev,
 					     dev_priv->vbt.sdvo_lvds_vbt_mode);
 		if (newmode != NULL) {
diff -puN drivers/net/wireless/ath/ath9k/Kconfig~linux-next-git-rejects drivers/net/wireless/ath/ath9k/Kconfig
--- a/drivers/net/wireless/ath/ath9k/Kconfig~linux-next-git-rejects
+++ a/drivers/net/wireless/ath/ath9k/Kconfig
@@ -84,17 +84,6 @@ config ATH9K_DFS_CERTIFIED
 	  developed. At this point enabling this option won't do anything
 	  except increase code size.
 
-<<<<<<< HEAD
-config ATH9K_MAC_DEBUG
-	bool "Atheros MAC statistics"
-	depends on ATH9K_DEBUGFS
-	default y
-	---help---
-	  This option enables collection of statistics for Rx/Tx status
-	  data and some other MAC related statistics
-
-=======
->>>>>>> linux-next/akpm-base
 config ATH9K_LEGACY_RATE_CONTROL
 	bool "Atheros ath9k rate control"
 	depends on ATH9K
diff -puN drivers/pinctrl/sh-pfc/pfc-r8a7779.c~linux-next-git-rejects drivers/pinctrl/sh-pfc/pfc-r8a7779.c
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7779.c~linux-next-git-rejects
+++ a/drivers/pinctrl/sh-pfc/pfc-r8a7779.c
@@ -2425,22 +2425,14 @@ static const unsigned int sdhi3_wp_mux[]
 /* - USB0 ------------------------------------------------------------------- */
 static const unsigned int usb0_pins[] = {
 	/* PENC */
-<<<<<<< HEAD
-	154,
-=======
 	RCAR_GP_PIN(4, 26),
->>>>>>> linux-next/akpm-base
 };
 static const unsigned int usb0_mux[] = {
 	USB_PENC0_MARK,
 };
 static const unsigned int usb0_ovc_pins[] = {
 	/* USB_OVC */
-<<<<<<< HEAD
-	150
-=======
 	RCAR_GP_PIN(4, 22),
->>>>>>> linux-next/akpm-base
 };
 static const unsigned int usb0_ovc_mux[] = {
 	USB_OVC0_MARK,
@@ -2448,22 +2440,14 @@ static const unsigned int usb0_ovc_mux[]
 /* - USB1 ------------------------------------------------------------------- */
 static const unsigned int usb1_pins[] = {
 	/* PENC */
-<<<<<<< HEAD
-	155,
-=======
 	RCAR_GP_PIN(4, 27),
->>>>>>> linux-next/akpm-base
 };
 static const unsigned int usb1_mux[] = {
 	USB_PENC1_MARK,
 };
 static const unsigned int usb1_ovc_pins[] = {
 	/* USB_OVC */
-<<<<<<< HEAD
-	152,
-=======
 	RCAR_GP_PIN(4, 24),
->>>>>>> linux-next/akpm-base
 };
 static const unsigned int usb1_ovc_mux[] = {
 	USB_OVC1_MARK,
@@ -2471,23 +2455,13 @@ static const unsigned int usb1_ovc_mux[]
 /* - USB2 ------------------------------------------------------------------- */
 static const unsigned int usb2_pins[] = {
 	/* PENC */
-<<<<<<< HEAD
-	156,
-=======
 	RCAR_GP_PIN(4, 28),
->>>>>>> linux-next/akpm-base
 };
 static const unsigned int usb2_mux[] = {
 	USB_PENC2_MARK,
 };
 static const unsigned int usb2_ovc_pins[] = {
 	/* USB_OVC */
-<<<<<<< HEAD
-	125,
-};
-static const unsigned int usb2_ovc_mux[] = {
-	USB_OVC2_MARK,
-=======
 	RCAR_GP_PIN(3, 29),
 };
 static const unsigned int usb2_ovc_mux[] = {
@@ -2596,7 +2570,6 @@ static const unsigned int vin3_sync_pins
 };
 static const unsigned int vin3_sync_mux[] = {
 	VI3_HSYNC_MARK, VI3_VSYNC_MARK,
->>>>>>> linux-next/akpm-base
 };
 
 static const struct sh_pfc_pin_group pinmux_groups[] = {
@@ -2728,8 +2701,6 @@ static const struct sh_pfc_pin_group pin
 	SH_PFC_PIN_GROUP(usb1_ovc),
 	SH_PFC_PIN_GROUP(usb2),
 	SH_PFC_PIN_GROUP(usb2_ovc),
-<<<<<<< HEAD
-=======
 	SH_PFC_PIN_GROUP(vin0_data8),
 	SH_PFC_PIN_GROUP(vin0_clk),
 	SH_PFC_PIN_GROUP(vin0_sync),
@@ -2742,7 +2713,6 @@ static const struct sh_pfc_pin_group pin
 	SH_PFC_PIN_GROUP(vin3_data8),
 	SH_PFC_PIN_GROUP(vin3_clk),
 	SH_PFC_PIN_GROUP(vin3_sync),
->>>>>>> linux-next/akpm-base
 };
 
 static const char * const du0_groups[] = {
@@ -2940,8 +2910,6 @@ static const char * const usb1_groups[]
 static const char * const usb2_groups[] = {
 	"usb2",
 	"usb2_ovc",
-<<<<<<< HEAD
-=======
 };
 
 static const char * const vin0_groups[] = {
@@ -2966,7 +2934,6 @@ static const char * const vin3_groups[]
 	"vin3_data8",
 	"vin3_clk",
 	"vin3_sync",
->>>>>>> linux-next/akpm-base
 };
 
 static const struct sh_pfc_function pinmux_functions[] = {
diff -puN drivers/spi/spi-xilinx.c~linux-next-git-rejects drivers/spi/spi-xilinx.c
--- a/drivers/spi/spi-xilinx.c~linux-next-git-rejects
+++ a/drivers/spi/spi-xilinx.c
@@ -281,7 +281,6 @@ static int xilinx_spi_txrx_bufs(struct s
 		cr = xspi->read_fn(xspi->regs + XSPI_CR_OFFSET) &
 							~XSPI_CR_TRANS_INHIBIT;
 		xspi->write_fn(cr, xspi->regs + XSPI_CR_OFFSET);
-<<<<<<< HEAD
 
 		wait_for_completion(&xspi->done);
 
@@ -301,27 +300,6 @@ static int xilinx_spi_txrx_bufs(struct s
 			sr = xspi->read_fn(xspi->regs + XSPI_SR_OFFSET);
 		}
 
-=======
-
-		wait_for_completion(&xspi->done);
-
-		/* A transmit has just completed. Process received data and
-		 * check for more data to transmit. Always inhibit the
-		 * transmitter while the Isr refills the transmit register/FIFO,
-		 * or make sure it is stopped if we're done.
-		 */
-		cr = xspi->read_fn(xspi->regs + XSPI_CR_OFFSET);
-		xspi->write_fn(cr | XSPI_CR_TRANS_INHIBIT,
-			       xspi->regs + XSPI_CR_OFFSET);
-
-		/* Read out all the data from the Rx FIFO */
-		sr = xspi->read_fn(xspi->regs + XSPI_SR_OFFSET);
-		while ((sr & XSPI_SR_RX_EMPTY_MASK) == 0) {
-			xspi->rx_fn(xspi);
-			sr = xspi->read_fn(xspi->regs + XSPI_SR_OFFSET);
-		}
-
->>>>>>> linux-next/akpm-base
 		/* See if there is more data to send */
 		if (!xspi->remaining_bytes > 0)
 			break;
diff -puN fs/ecryptfs/file.c~linux-next-git-rejects fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~linux-next-git-rejects
+++ a/fs/ecryptfs/file.c
@@ -295,16 +295,7 @@ static int ecryptfs_release(struct inode
 static int
 ecryptfs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
-<<<<<<< HEAD
-	int rc;
-
-	rc = filemap_write_and_wait(file->f_mapping);
-	if (rc)
-		return rc;
-
-=======
 	filemap_write_and_wait(file->f_mapping);
->>>>>>> linux-next/akpm-base
 	return vfs_fsync(ecryptfs_file_to_lower(file), datasync);
 }
 
diff -puN net/bluetooth/mgmt.c~linux-next-git-rejects net/bluetooth/mgmt.c
--- a/net/bluetooth/mgmt.c~linux-next-git-rejects
+++ a/net/bluetooth/mgmt.c
@@ -2744,10 +2744,7 @@ static int start_discovery(struct sock *
 		break;
 
 	case DISCOV_TYPE_LE:
-<<<<<<< HEAD
-=======
 	case DISCOV_TYPE_INTERLEAVED:
->>>>>>> linux-next/akpm-base
 		if (!test_bit(HCI_LE_ENABLED, &hdev->dev_flags)) {
 			err = cmd_status(sk, hdev->id, MGMT_OP_START_DISCOVERY,
 					 MGMT_STATUS_NOT_SUPPORTED);
diff -puN sound/pci/hda/patch_via.c~linux-next-git-rejects sound/pci/hda/patch_via.c
--- a/sound/pci/hda/patch_via.c~linux-next-git-rejects
+++ a/sound/pci/hda/patch_via.c
@@ -480,20 +480,9 @@ static int via_suspend(struct hda_codec
 	struct via_spec *spec = codec->spec;
 	vt1708_stop_hp_work(codec);
 
-<<<<<<< HEAD
-	if (spec->codec_type == VT1802) {
-		/* Fix pop noise on headphones */
-		int i;
-		for (i = 0; i < spec->gen.autocfg.hp_outs; i++)
-			snd_hda_codec_write(codec, spec->gen.autocfg.hp_pins[i],
-					    0, AC_VERB_SET_PIN_WIDGET_CONTROL,
-					    0x00);
-	}
-=======
 	/* Fix pop noise on headphones */
 	if (spec->codec_type == VT1802)
 		snd_hda_shutup_pins(codec);
->>>>>>> linux-next/akpm-base
 
 	return 0;
 }
diff -puN arch/s390/include/asm/pgtable.h~linux-next-git-rejects arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~linux-next-git-rejects
+++ a/arch/s390/include/asm/pgtable.h
@@ -719,11 +719,7 @@ static inline void pgste_set_key(pte_t *
 	 * The guest C/R information is still in the PGSTE, set real
 	 * key C/R to 0.
 	 */
-<<<<<<< HEAD
-	nkey = (pgste_val(pgste) & (RCP_ACC_BITS | RCP_FP_BIT)) >> 56;
-=======
 	nkey = (pgste_val(pgste) & (PGSTE_ACC_BITS | PGSTE_FP_BIT)) >> 56;
->>>>>>> linux-next/akpm-base
 	page_set_storage_key(address, nkey, 0);
 #endif
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
mm-remove-compressed-copy-from-zram-in-memory-fix-2-fix.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-tune-vm_committed_as-percpu_counter-batching-size-fix.patch
swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch
mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages-fix.patch
mm-correctly-update-zone-managed_pages-fix.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
include-linux-mmzoneh-cleanups.patch
drop_caches-add-some-documentation-and-info-messsge.patch
clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
rbtree-remove-unneeded-include-fix.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
ptrace-add-ability-to-get-set-signal-blocked-mask-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
wait-introduce-wait_event_commonwq-condition-state-timeout-checkpatch-fixes.patch
wait-introduce-prepare_to_wait_event-checkpatch-fixes.patch
dev-oldmem-remove-the-interface-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation-checkpatch-fixes.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

