From: akpm@osdl.org
Subject: - smc911-workqueue-fixes.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:54:01 -0800
Message-ID: <200612230754.kBN7s1Jd010177@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49672 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbWLWHyJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:54:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, jeff@garzik.org, vitalywool@gmail.com, mm-commits@vger.kernel.org


The patch titled
     smc911 workqueue fixes
has been removed from the -mm tree.  Its filename was
     smc911-workqueue-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: smc911 workqueue fixes
From: Andrew Morton <akpm@osdl.org>

Teach this driver about the workqueue changes.

Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/smc911x.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff -puN drivers/net/smc911x.c~smc911-workqueue-fixes drivers/net/smc911x.c
--- a/drivers/net/smc911x.c~smc911-workqueue-fixes
+++ a/drivers/net/smc911x.c
@@ -148,6 +148,8 @@ struct smc911x_local {
 	int tx_throttle;
 	spinlock_t lock;
 
+	struct net_device *netdev;
+
 #ifdef SMC_USE_DMA
 	/* DMA needs the physical address of the chip */
 	u_long physaddr;
@@ -948,10 +950,11 @@ static void smc911x_phy_check_media(stru
  * of autonegotiation.)  If the RPC ANEG bit is cleared, the selection
  * is controlled by the RPC SPEED and RPC DPLX bits.
  */
-static void smc911x_phy_configure(void *data)
+static void smc911x_phy_configure(struct work_struct *work)
 {
-	struct net_device *dev = data;
-	struct smc911x_local *lp = netdev_priv(dev);
+	struct smc911x_local *lp = container_of(work, struct smc911x_local,
+						phy_configure);
+	struct net_device *dev = lp->netdev;
 	unsigned long ioaddr = dev->base_addr;
 	int phyaddr = lp->mii.phy_id;
 	int my_phy_caps; /* My PHY capabilities */
@@ -1495,6 +1498,8 @@ static void smc911x_set_multicast_list(s
 static int
 smc911x_open(struct net_device *dev)
 {
+	struct smc911x_local *lp = netdev_priv(dev);
+
 	DBG(SMC_DEBUG_FUNC, "%s: --> %s\n", dev->name, __FUNCTION__);
 
 	/*
@@ -1511,7 +1516,7 @@ smc911x_open(struct net_device *dev)
 	smc911x_reset(dev);
 
 	/* Configure the PHY, initialize the link state */
-	smc911x_phy_configure(dev);
+	smc911x_phy_configure(&lp->phy_configure);
 
 	/* Turn on Tx + Rx */
 	smc911x_enable(dev);
@@ -2060,7 +2065,7 @@ static int __init smc911x_probe(struct n
 	dev->poll_controller = smc911x_poll_controller;
 #endif
 
-	INIT_WORK(&lp->phy_configure, smc911x_phy_configure, dev);
+	INIT_WORK(&lp->phy_configure, smc911x_phy_configure);
 	lp->mii.phy_id_mask = 0x1f;
 	lp->mii.reg_num_mask = 0x1f;
 	lp->mii.force_media = 0;
@@ -2154,6 +2159,7 @@ static int smc911x_drv_probe(struct plat
 {
 	struct net_device *ndev;
 	struct resource *res;
+	struct smc911x_local *lp;
 	unsigned int *addr;
 	int ret;
 
@@ -2183,6 +2189,8 @@ static int smc911x_drv_probe(struct plat
 
 	ndev->dma = (unsigned char)-1;
 	ndev->irq = platform_get_irq(pdev, 0);
+	lp = netdev_priv(ndev);
+	lp->netdev = ndev;
 
 	addr = ioremap(res->start, SMC911X_IO_EXTENT);
 	if (!addr) {
@@ -2204,7 +2212,6 @@ out:
 	}
 #ifdef SMC_USE_DMA
 	else {
-		struct smc911x_local *lp = netdev_priv(ndev);
 		lp->physaddr = res->start;
 		lp->dev = &pdev->dev;
 	}
@@ -2275,7 +2282,7 @@ static int smc911x_drv_resume(struct pla
 			smc911x_reset(ndev);
 			smc911x_enable(ndev);
 			if (lp->phy_type != 0)
-				smc911x_phy_configure(ndev);
+				smc911x_phy_configure(&lp->phy_configure);
 			netif_device_attach(ndev);
 		}
 	}
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
down_write-preserve-local-irqs.patch
shrink_all_memory-fix-lru_pages-handling.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-agpgart.patch
cifs-sprintf-fix.patch
git-cpufreq.patch
git-dvb.patch
git-gfs2-nmw.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-input.patch
git-libata-all.patch
git-libata-all-fixup.patch
git-lxdialog-fixup.patch
git-mmc.patch
git-mtd.patch
git-ubi.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
driver-for-silan-sc92031-netdev.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-qla3xxx-fixup.patch
nokia-e70-is-an-unusual-device.patch
git-wireless.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
revert-x86_64-mm-copy-user-nocache.patch
add-memcpy_uncached_read.patch
touchkit-ps-2-touchscreen-driver.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
avoid-excessive-sorting-of-early_node_map-tidy.patch
proc-zoneinfo-fix-vm-stats-display.patch
swsusp-change-code-ordering-in-userc-sanity.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
ecryptfs-public-key-packet-management-slab-fix.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
spi-controller-driver-for-omap-microwire-tidy.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i386-drivers.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
sched-improve-efficiency-of-sched_fork-tidy.patch
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

