From: akpm@osdl.org
Subject: - git-mmc-fixup.patch removed from -mm tree
Date: Mon, 18 Dec 2006 14:48:33 -0800
Message-ID: <200612182248.kBIMmXwP014958@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53929 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723AbWLRWsm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 17:48:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, drzeus@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     git-mmc-fixup
has been removed from the -mm tree.  Its filename was
     git-mmc-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-mmc-fixup
From: Andrew Morton <akpm@osdl.org>

Ghastly hacks to make it compile.  Broken.

Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/mmc/at91_mci.c |   12 --
 drivers/mmc/tifm_sd.c  |  174 ---------------------------------------
 2 files changed, 1 insertion(+), 185 deletions(-)

diff -puN drivers/mmc/tifm_sd.c~git-mmc-fixup drivers/mmc/tifm_sd.c
--- a/drivers/mmc/tifm_sd.c~git-mmc-fixup
+++ a/drivers/mmc/tifm_sd.c
@@ -99,13 +99,9 @@ struct tifm_sd {
 	struct tasklet_struct finish_tasklet;
 	struct timer_list     timer;
 	struct mmc_request    *req;
-<<<<<<< HEAD/drivers/mmc/tifm_sd.c
 	struct work_struct    cmd_handler;
 	struct delayed_work   abort_handler;
-	wait_queue_head_t     can_eject;
-=======
 	wait_queue_head_t     notify;
->>>>>>> /drivers/mmc/tifm_sd.c
 
 	size_t                written_blocks;
 	size_t                buffer_size;
@@ -415,15 +411,9 @@ static void tifm_sd_prepare_data(struct 
 	dev_dbg(&sock->dev, "setting dma for %d blocks\n",
 		cmd->data->blocks);
 	writel(TIFM_FIFO_INT_SETALL,
-<<<<<<< HEAD/drivers/mmc/tifm_sd.c
-		sock->addr + SOCK_DMA_FIFO_INT_ENABLE_CLEAR);
-	writel(ilog2(cmd->data->blksz) - 2,
-			sock->addr + SOCK_FIFO_PAGE_SIZE);
-=======
 	       sock->addr + SOCK_DMA_FIFO_INT_ENABLE_CLEAR);
-	writel(long_log2(cmd->data->blksz) - 2,
+	writel(ilog2(cmd->data->blksz) - 2,
 	       sock->addr + SOCK_FIFO_PAGE_SIZE);
->>>>>>> /drivers/mmc/tifm_sd.c
 	writel(TIFM_FIFO_ENABLE, sock->addr + SOCK_FIFO_CONTROL);
 	writel(TIFM_FIFO_INTMASK, sock->addr + SOCK_DMA_FIFO_INT_ENABLE_SET);
 
@@ -529,17 +519,9 @@ err_out:
 	mmc_request_done(mmc, mrq);
 }
 
-<<<<<<< HEAD/drivers/mmc/tifm_sd.c
 static void tifm_sd_end_cmd(struct work_struct *work)
-=======
-static void tifm_sd_end_cmd(unsigned long data)
->>>>>>> /drivers/mmc/tifm_sd.c
 {
-<<<<<<< HEAD/drivers/mmc/tifm_sd.c
 	struct tifm_sd *host = container_of(work, struct tifm_sd, cmd_handler);
-=======
-	struct tifm_sd *host = (struct tifm_sd*)data;
->>>>>>> /drivers/mmc/tifm_sd.c
 	struct tifm_dev *sock = host->dev;
 	struct mmc_host *mmc = tifm_get_drvdata(sock);
 	struct mmc_request *mrq;
@@ -636,11 +618,7 @@ err_out:
 	mmc_request_done(mmc, mrq);
 }
 
-<<<<<<< HEAD/drivers/mmc/tifm_sd.c
 static void tifm_sd_end_cmd_nodma(struct work_struct *work)
-=======
-static void tifm_sd_end_cmd_nodma(unsigned long data)
->>>>>>> /drivers/mmc/tifm_sd.c
 {
 	struct tifm_sd *host = container_of(work, struct tifm_sd, cmd_handler);
 	struct tifm_dev *sock = host->dev;
@@ -708,29 +686,15 @@ static void tifm_sd_terminate(struct tif
 	spin_unlock_irqrestore(&sock->lock, flags);
 }
 
-<<<<<<< HEAD/drivers/mmc/tifm_sd.c
 static void tifm_sd_abort(struct work_struct *work)
-=======
-static void tifm_sd_abort(unsigned long data)
->>>>>>> /drivers/mmc/tifm_sd.c
 {
-<<<<<<< HEAD/drivers/mmc/tifm_sd.c
 	struct tifm_sd *host =
 		container_of(work, struct tifm_sd, abort_handler.work);
 
-=======
-	struct tifm_sd *host = (struct tifm_sd*)data;
-
->>>>>>> /drivers/mmc/tifm_sd.c
 	printk(KERN_ERR DRIVER_NAME
-<<<<<<< HEAD/drivers/mmc/tifm_sd.c
-		": card failed to respond for a long period of time");
-	tifm_eject(host->dev);
-=======
 	       ": card failed to respond for a long period of time\n");
 	tifm_sd_terminate(host);
 	tifm_eject(host->dev);
->>>>>>> /drivers/mmc/tifm_sd.c
 }
 
 static void tifm_sd_ios(struct mmc_host *mmc, struct mmc_ios *ios)
@@ -828,149 +792,13 @@ static struct mmc_host_ops tifm_sd_ops =
 	.get_ro  = tifm_sd_ro
 };
 
-<<<<<<< HEAD/drivers/mmc/tifm_sd.c
 static void tifm_sd_register_host(struct work_struct *work)
-=======
-static int tifm_sd_initialize_host(struct tifm_sd *host)
->>>>>>> /drivers/mmc/tifm_sd.c
 {
-<<<<<<< HEAD/drivers/mmc/tifm_sd.c
-	struct tifm_sd *host = container_of(work, struct tifm_sd, cmd_handler);
-=======
-	int rc;
-	unsigned int host_status = 0;
->>>>>>> /drivers/mmc/tifm_sd.c
-	struct tifm_dev *sock = host->dev;
-
-<<<<<<< HEAD/drivers/mmc/tifm_sd.c
-	spin_lock_irqsave(&sock->lock, flags);
-	host->flags |= HOST_REG;
-	PREPARE_WORK(&host->cmd_handler,
-			no_dma ? tifm_sd_end_cmd_nodma : tifm_sd_end_cmd);
-	spin_unlock_irqrestore(&sock->lock, flags);
-	dev_dbg(&sock->dev, "adding host\n");
-	mmc_add_host(mmc);
-=======
-	writel(0, sock->addr + SOCK_MMCSD_INT_ENABLE);
-	mmiowb();
-	host->clk_div = 61;
-	host->clk_freq = 20000000;
-	writel(TIFM_MMCSD_RESET, sock->addr + SOCK_MMCSD_SYSTEM_CONTROL);
-	writel(host->clk_div | TIFM_MMCSD_POWER,
-	       sock->addr + SOCK_MMCSD_CONFIG);
-
-	/* wait up to 0.51 sec for reset */
-	for (rc = 2; rc <= 256; rc <<= 1) {
-		if (1 & readl(sock->addr + SOCK_MMCSD_SYSTEM_STATUS)) {
-			rc = 0;
-			break;
-		}
-		msleep(rc);
-        }
-
-	if (rc) {
-		printk(KERN_ERR DRIVER_NAME
-		       ": controller failed to reset\n");
-		return -ENODEV;
-	}
-
-	writel(0, sock->addr + SOCK_MMCSD_NUM_BLOCKS);
-	writel(host->clk_div | TIFM_MMCSD_POWER,
-	       sock->addr + SOCK_MMCSD_CONFIG);
-	writel(TIFM_MMCSD_RXDE, sock->addr + SOCK_MMCSD_BUFFER_CONFIG);
-
-	// command timeout fixed to 64 clocks for now
-	writel(64, sock->addr + SOCK_MMCSD_COMMAND_TO);
-	writel(TIFM_MMCSD_INAB, sock->addr + SOCK_MMCSD_COMMAND);
-
-	/* INAB should take much less than reset */
-	for (rc = 1; rc <= 16; rc <<= 1) {
-		host_status = readl(sock->addr + SOCK_MMCSD_STATUS);
-		writel(host_status, sock->addr + SOCK_MMCSD_STATUS);
-		if (!(host_status & TIFM_MMCSD_ERRMASK)
-		    && (host_status & TIFM_MMCSD_EOC)) {
-			rc = 0;
-			break;
-		}
-		msleep(rc);
-        }
-
-	if (rc) {
-		printk(KERN_ERR DRIVER_NAME
-		       ": card not ready - probe failed on initialization\n");
-		return -ENODEV;
-	}
-
-	writel(TIFM_MMCSD_DATAMASK | TIFM_MMCSD_ERRMASK,
-	       sock->addr + SOCK_MMCSD_INT_ENABLE);
-	mmiowb();
-
-	return 0;
->>>>>>> /drivers/mmc/tifm_sd.c
 }
 
 static int tifm_sd_probe(struct tifm_dev *sock)
 {
-	struct mmc_host *mmc;
-	struct tifm_sd *host;
-	int rc = -EIO;
-
-	if (!(TIFM_SOCK_STATE_OCCUPIED
-	      & readl(sock->addr + SOCK_PRESENT_STATE))) {
-		printk(KERN_WARNING DRIVER_NAME ": card gone, unexpectedly\n");
-		return rc;
-	}
-
-	mmc = mmc_alloc_host(sizeof(struct tifm_sd), &sock->dev);
-	if (!mmc)
-		return -ENOMEM;
-
-	host = mmc_priv(mmc);
-	tifm_set_drvdata(sock, mmc);
-	host->dev = sock;
-<<<<<<< HEAD/drivers/mmc/tifm_sd.c
-	host->clk_div = 61;
-	init_waitqueue_head(&host->can_eject);
-	INIT_WORK(&host->cmd_handler, tifm_sd_register_host);
-	INIT_DELAYED_WORK(&host->abort_handler, tifm_sd_abort);
-=======
-	host->timeout_jiffies = msecs_to_jiffies(1000);
->>>>>>> /drivers/mmc/tifm_sd.c
-
-	init_waitqueue_head(&host->notify);
-	tasklet_init(&host->finish_tasklet,
-		     no_dma ? tifm_sd_end_cmd_nodma : tifm_sd_end_cmd,
-		     (unsigned long)host);
-	setup_timer(&host->timer, tifm_sd_abort, (unsigned long)host);
-
-	tifm_sd_ops.request = no_dma ? tifm_sd_request_nodma : tifm_sd_request;
-	mmc->ops = &tifm_sd_ops;
-	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_MULTIWRITE;
-	mmc->f_min = 20000000 / 60;
-	mmc->f_max = 24000000;
-	mmc->max_hw_segs = 1;
-	mmc->max_phys_segs = 1;
-	// limited by DMA counter - it's safer to stick with
-	// block counter has 11 bits though
-	mmc->max_blk_count = 256;
-	// 2k maximum hw block length
-	mmc->max_blk_size = 2048;
-	mmc->max_req_size = mmc->max_blk_size * mmc->max_blk_count;
-	mmc->max_seg_size = mmc->max_req_size;
-
-	sock->signal_irq = tifm_sd_signal_irq;
-	rc = tifm_sd_initialize_host(host);
-
-	if (!rc)
-		rc = mmc_add_host(mmc);
-	if (rc)
-		goto out_free_mmc;
-
 	return 0;
-out_free_mmc:
-	mmc_free_host(mmc);
-	return rc;
 }
 
 static void tifm_sd_remove(struct tifm_dev *sock)
diff -puN drivers/mmc/at91_mci.c~git-mmc-fixup drivers/mmc/at91_mci.c
--- a/drivers/mmc/at91_mci.c~git-mmc-fixup
+++ a/drivers/mmc/at91_mci.c
@@ -340,7 +340,6 @@ static void at91_mci_handle_transmitted(
  */
 static void at91_mci_enable(struct at91mci_host *host)
 {
-<<<<<<< HEAD/drivers/mmc/at91_mci.c
 	at91_mci_write(host, AT91_MCI_CR, AT91_MCI_MCIEN);
 	at91_mci_write(host, AT91_MCI_IDR, 0xffffffff);
 	at91_mci_write(host, AT91_MCI_DTOR, AT91_MCI_DTOMUL_1M | AT91_MCI_DTOCYC);
@@ -348,13 +347,6 @@ static void at91_mci_enable(struct at91m
 
 	/* use Slot A or B (only one at same time) */
 	at91_mci_write(host, AT91_MCI_SDCR, host->board->slot_b);
-=======
-	at91_mci_write(host, AT91_MCI_CR, AT91_MCI_MCIEN);
-	at91_mci_write(host, AT91_MCI_IDR, 0xffffffff);
-	at91_mci_write(host, AT91_MCI_DTOR, AT91_MCI_DTOMUL_1M | AT91_MCI_DTOCYC);
-	at91_mci_write(host, AT91_MCI_MR, AT91_MCI_PDCMODE | 0x34a);
-	at91_mci_write(host, AT91_MCI_SDCR, 0);
->>>>>>> /drivers/mmc/at91_mci.c
 }
 
 /*
@@ -769,11 +761,7 @@ static irqreturn_t at91_mmc_det_irq(int 
 			present ? "insert" : "remove");
 		if (!present) {
 			pr_debug("****** Resetting SD-card bus width ******\n");
-<<<<<<< HEAD/drivers/mmc/at91_mci.c
 			at91_mci_write(host, AT91_MCI_SDCR, at91_mci_read(host, AT91_MCI_SDCR) & ~AT91_MCI_SDCBUS);
-=======
-			at91_mci_write(host, AT91_MCI_SDCR, 0);
->>>>>>> /drivers/mmc/at91_mci.c
 		}
 		mmc_detect_change(host->mmc, msecs_to_jiffies(100));
 	}
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
try_to_free_buffers-dont-clear-pte-dirty-bits.patch
rtc-warning-fix.patch
fix-vm_events_fold_cpu-build-breakage-fix.patch
smc911-workqueue-fixes.patch
build-compileh-earlier.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
acpi-dont-select-pm.patch
implementation-of-acpi_video_get_next_level.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
arm-systemh-build-fix.patch
cifs-sprintf-fix.patch
git-drm.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-libata-all.patch
git-lxdialog-fixup.patch
git-mmc.patch
git-mmc-fixup.patch
git-mmc-tifm_sd-warning-fix.patch
git-mtd.patch
git-ubi.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
driver-for-silan-sc92031-netdev-include-fix.patch
driver-for-silan-sc92031-netdev-fix-more.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
pci-legacy-resource-fix-tidy.patch
pci-disable-multithreaded-probing.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver-fix.patch
git-qla3xxx-fixup.patch
funsoft-is-bust-on-sparc.patch
nokia-e70-is-an-unusual-device.patch
fix-gregkh-usb-usb-ehci-hcd-add-shadow-budget-code.patch
git-wireless.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
revert-x86_64-mm-copy-user-nocache.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
add-memcpy_uncached_read-fix.patch
add-memcpy_uncached_read-tidy.patch
touchkit-ps-2-touchscreen-driver.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-2.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-3.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
nfs-fix-nr_file_dirty-underflow-tidy.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
ecryptfs-public-key-packet-management-slab-fix.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i386-drivers.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

