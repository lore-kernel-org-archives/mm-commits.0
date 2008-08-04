From: akpm@linux-foundation.org
Subject: - drivers-mtd-nand-nandsimc-fix-printk-warnings.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:06:57 -0700
Message-ID: <200808042006.m74K6vAt027736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759589AbYHDUHA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:07:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/mtd/nand/nandsim.c: fix printk warnings
has been removed from the -mm tree.  Its filename was
     drivers-mtd-nand-nandsimc-fix-printk-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/mtd/nand/nandsim.c: fix printk warnings
From: Andrew Morton <akpm@linux-foundation.org>

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/nandsim.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/mtd/nand/nandsim.c~drivers-mtd-nand-nandsimc-fix-printk-warnings drivers/mtd/nand/nandsim.c
--- a/drivers/mtd/nand/nandsim.c~drivers-mtd-nand-nandsimc-fix-printk-warnings
+++ a/drivers/mtd/nand/nandsim.c
@@ -586,7 +586,8 @@ static int init_nandsim(struct mtd_info 
 	if (ns->busw == 16)
 		NS_WARN("16-bit flashes support wasn't tested\n");
 
-	printk("flash size: %llu MiB\n",        ns->geom.totsz >> 20);
+	printk("flash size: %llu MiB\n",
+			(unsigned long long)ns->geom.totsz >> 20);
 	printk("page size: %u bytes\n",         ns->geom.pgsz);
 	printk("OOB area size: %u bytes\n",     ns->geom.oobsz);
 	printk("sector size: %u KiB\n",         ns->geom.secsz >> 10);
@@ -595,8 +596,9 @@ static int init_nandsim(struct mtd_info 
 	printk("bus width: %u\n",               ns->busw);
 	printk("bits in sector size: %u\n",     ns->geom.secshift);
 	printk("bits in page size: %u\n",       ns->geom.pgshift);
-	printk("bits in OOB size: %u\n",        ns->geom.oobshift);
-	printk("flash size with OOB: %llu KiB\n", ns->geom.totszoob >> 10);
+	printk("bits in OOB size: %u\n",	ns->geom.oobshift);
+	printk("flash size with OOB: %llu KiB\n",
+			(unsigned long long)ns->geom.totszoob >> 10);
 	printk("page address bytes: %u\n",      ns->geom.pgaddrbytes);
 	printk("sector address bytes: %u\n",    ns->geom.secaddrbytes);
 	printk("options: %#x\n",                ns->options);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
drivers-media-video-vinoc-needs-v4l2-ioctlh.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-serio-xilinx_ps2c-fix-warning.patch
git-jg-misc.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
sched-type-fix.patch
scsi-gdthc-use-unaligned-access-helpers.patch
git-block-git-rejects.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
usb-hubc-fix-build-with-config_pm=n.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
hwmon-adc124s501-generic-driver.patch
drivers-net-netxen-netxen_nic_hwc-fix-printk-warnings.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
devpts-switch-to-ida-checkpatch-fixes.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
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

