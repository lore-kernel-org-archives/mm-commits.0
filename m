From: akpm@osdl.org
Subject: + git-mmc-fixup.patch added to -mm tree
Date: Wed, 06 Dec 2006 13:49:44 -0800
Message-ID: <200612062149.kB6LniJk017540@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:44907 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937682AbWLFVt6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 16:49:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, drzeus@drzeus.cx


The patch titled
     git-mmc-fixup
has been added to the -mm tree.  Its filename is
     git-mmc-fixup.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-mmc-fixup
From: Andrew Morton <akpm@osdl.org>

Ghastly hacks to make it compile.  Broken.

Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/mmc/tifm_sd.c |  166 ----------------------------------------
 1 file changed, 166 deletions(-)

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
@@ -523,17 +519,9 @@ err_out:
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
@@ -630,11 +618,7 @@ err_out:
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
@@ -702,29 +686,15 @@ static void tifm_sd_terminate(struct tif
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
@@ -822,149 +792,13 @@ static struct mmc_host_ops tifm_sd_ops =
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
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
add-bottom_half.h.patch
drm-sis-linkage-fix.patch
revert-generic_file_buffered_write-handle-zero-length-iovec-segments.patch
revert-generic_file_buffered_write-deadlock-on-vectored-write.patch
generic_file_buffered_write-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
fs-prepare_write-fixes-fuse-fix.patch
fs-prepare_write-fixes-fat-fix.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
acpi-dont-select-pm.patch
implementation-of-acpi_video_get_next_level.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register.patch
acpi-asus-s3-resume-fix.patch
sony_apci-resume.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-alsa-fixup.patch
git-alsa-arm-fix.patch
git-cpufreq-prep.patch
git-cpufreq.patch
git-cpufreq-fixup.patch
platform_driver_probe-can-save-codespace-save-codespace.patch
git-dvb.patch
git-dvb-fixup.patch
git-gfs2-nmw.patch
git-ia64.patch
git-ieee1394-fixup.patch
git-input.patch
git-input-fixup.patch
git-input-vs-git-alsa.patch
kbuild-fix-rr-is-now-default.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
pata_via-suspend-resume-support-fix.patch
pata_it8213-add-new-driver-for-the-it8213-card-tidy.patch
git-lxdialog-fixup.patch
git-mmc-fixup.patch
git-mtd.patch
git-mtd-ssfdc-build-fix.patch
git-ubi.patch
git-netdev-all.patch
libphy-dont-do-that.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-net.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
pci-fix-multiple-problems-with-via-hardware.patch
fix-gregkh-pci-pci-enable-disable-device-is-nestable.patch
git-s390.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-in2000-scsi_cmnd-convertion.patch
aic79xx-wrong-max-memory-at-driver-init.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver-fix.patch
nokia-e70-is-an-unusual-device.patch
pre-x86_64-mm-i386-reloc-abssym.patch
post-x86_64-mm-i386-reloc-abssym.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
x86_64-fix-boot-hang-due-to-nmi-watchdog-init-code-tidy.patch
x86_64-fix-boot-hang-due-to-nmi-watchdog-init-code-tidy-tidy-2.patch
touchkit-ps-2-touchscreen-driver.patch
get-rid-of-zone_table.patch
new-scheme-to-preempt-swap-token-tidy.patch
balance_pdgat-cleanup.patch
leak-tracking-for-kmalloc_node-fix.patch
add-numa-node-information-to-struct-device-tidy.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
slab-deprecate-kmem_cache-t.patch
mm-make-compound-page-destructor-handling-explicit-tidy.patch
congestion-wait-dont-wait-when-there-are-no-pages-under-writeback.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
radix-tree-rcu-lockless-readside.patch
acx1xx-wireless-driver.patch
swsusp-add-resume_offset-command-line-parameter-rev-2.patch
add-include-linux-freezerh-and-move-definitions-from-ueagle-fix.patch
add-include-linux-freezerh-and-move-definitions-from-ucb1400_ts-fix.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
convert-pm_sem-to-a-mutex-fix.patch
cciss-set-sector_size-to-2048-for-performance-tidy.patch
deprecate-smbfs-in-favour-of-cifs.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
lockdep-annotate-nfs-nfsd-in-kernel-sockets-tidy.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
probe_kernel_address-needs-to-do-set_fs.patch
slab-use-probe_kernel_address.patch
exar-quad-port-serial-fix.patch
vfs_getattr-remove-dead-code.patch
ext3-uninline-large-functions.patch
ext4-uninline-large-functions.patch
sleep-profiling-fixes.patch
sleep-profiling-fix.patch
debug-workqueue-locking-sanity-fix.patch
pcengines-wrap-led-support-fix.patch
driver-base-memoryc-remove-warnings-of.patch
remove-kernel-syscalls-x86_64-fix.patch
protect-ext2-ioctl-modifying-append_only-immutable-etc-with-i_mutex.patch
remove-hash_highmem.patch
elf-fix-kcore-note-size-calculation-fix.patch
reiserfs-add-missing-d-cache-flushing-tweak.patch
up-smp_call_function_single-should-disable-interrupts.patch
up-smp_call_function_single-should-disable-interrupts-fix.patch
smp_call_function_single-check-that-local-interrupts-are-enabled.patch
hotplug-cpu-clean-up-hotcpu_notifier-use-vs-gregkh-driver-cpu-topology-consider-sysfs_create_group-return-value.patch
add-return-value-checking-of-get_user-in-fix.patch
handle-per-subsystem-mutexes-for-config_hotplug_cpu-not-set-tidy.patch
dz-fixes-to-make-it-work-fix.patch
ext4-balloc-fix-_with_rsv-freeze-fix.patch
ide_scsi-allow-it-to-be-used-for-non-cd-only-fix.patch
make-8250_pnp-serial-driver-work-after-tidy.patch
gcc-4-1-0-is-bust.patch
cleanup-include-asm-generic-atomich-fix.patch
struct-seq_operations-and-struct-file_operations-constification-fix.patch
struct-seq_operations-and-struct-file_operations-constification-fix-2.patch
touch_atime-cleanup.patch
ocfs2-relative-atime-support-tweaks.patch
io-accounting-core-statistics.patch
clean-up-__set_page_dirty_nobuffers.patch
io-accounting-write-accounting.patch
io-accounting-write-cancel-accounting.patch
io-accounting-read-accounting-2.patch
io-accounting-read-accounting-nfs-fix.patch
io-accounting-read-accounting-cifs-fix.patch
io-accounting-direct-io.patch
io-accounting-report-in-procfs.patch
cleanup-taskstatsh.patch
io-accounting-via-taskstats.patch
getdelays-various-fixes.patch
io-accounting-add-to-getdelays.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
tty-signal-tty-locking-post-viro-trainwreck.patch
tty-signal-tty-locking-post-viro-trainwreck-fix.patch
tty-signal-tty-locking-post-viro-trainwreck-fix-fix.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait-fix.patch
bug-test-1.patch
net-use-bitrev8-tidy.patch
fsstack-introduce-fsstack_copy_attrinode_-tidy.patch
ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix-fix.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-fix.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-vs-git-cryptodev.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-ppc-fix.patch
add-process_session-helper-routine-deprecate-old-field-tidy.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings-2.patch
mxser-session-warning-fix.patch
tty-switch-to-ktermios-and-new-framework-warning-fix.patch
tty-switch-to-ktermios-and-new-framework-irda-fix.patch
tty-switch-to-ktermios-bluetooth-fix.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2-fix.patch
drivers-isdn-handcrafted-min-max-macro-removal-fix.patch
fault-injection-capabilities-infrastructure-tidy.patch
fault-injection-capabilities-infrastructure-tweaks.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sched-add-option-to-serialize-load-balancing-fix.patch
kernel-schedc-whitespace-cleanups-more.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3.patch
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
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs-fix.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options-tidy.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking-fix.patch
updated-hrtimers-state-tracking.patch
updated-i386-convert-to-clock-event-devices.patch
updated-i386-convert-to-clock-event-devices-fix.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
round_jiffies-infrastructure-fix.patch
clocksource-small-cleanup-2-fix.patch
kvm-make-the-vcpu-execution-loop-an-arch-operation-build-fix.patch
kvm-make-__set_efer-an-arch-operation-build-fix.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
x86-kmap_atomic-debugging.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

