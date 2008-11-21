From: akpm@linux-foundation.org
Subject: - w1-add-1-wire-master-driver-for-imx27-imx31-fix.patch removed from -mm tree
Date: Fri, 21 Nov 2008 15:51:07 -0800
Message-ID: <200811212351.mALNp8XM004107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753669AbYKUXvz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 18:51:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, l.fu@pengutronix.de, rmk@arm.linux.org.uk, s.hauer@pengutronix.de, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     w1-add-1-wire-master-driver-for-imx27-imx31-fix
has been removed from the -mm tree.  Its filename was
     w1-add-1-wire-master-driver-for-imx27-imx31-fix.patch

This patch was dropped because it was folded into w1-add-1-wire-master-driver-for-imx27-imx31.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1-add-1-wire-master-driver-for-imx27-imx31-fix
From: Andrew Morton <akpm@linux-foundation.org>

- coding-style fixes

- remove unneeded casts of void*

Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Luotao Fu <l.fu@pengutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/mxc_w1.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/w1/masters/mxc_w1.c~w1-add-1-wire-master-driver-for-imx27-imx31-fix drivers/w1/masters/mxc_w1.c
--- a/drivers/w1/masters/mxc_w1.c~w1-add-1-wire-master-driver-for-imx27-imx31-fix
+++ a/drivers/w1/masters/mxc_w1.c
@@ -59,8 +59,7 @@ static u8 mxc_w1_ds2_reset_bus(void *dat
 {
 	u8 reg_val, rc = 1;
 	unsigned int timeout_cnt = 0;
-
-	struct mxc_w1_device *dev = (struct mxc_w1_device *)data;
+	struct mxc_w1_device *dev = data;
 
 	__raw_writeb(0x80, (dev->regs + MXC_W1_CONTROL));
 
@@ -87,8 +86,7 @@ static u8 mxc_w1_ds2_reset_bus(void *dat
 static u8 mxc_w1_ds2_touch_bit(void *data, u8 bit)
 {
 	unsigned int timeout_cnt = 400;
-
-	struct mxc_w1_device *mdev = (struct mxc_w1_device *)data;
+	struct mxc_w1_device *mdev = data;
 	void __iomem *ctrl_addr = mdev->regs + MXC_W1_CONTROL;
 
 	__raw_writeb((1 << (5 - bit)), ctrl_addr);
@@ -137,7 +135,7 @@ static int __devinit mxc_w1_probe(struct
 
 	mdev->regs = ioremap(res->start, resource_size(res));
 	if (!mdev->regs) {
-		printk(KERN_ERR"Cannot map frame buffer registers\n");
+		printk(KERN_ERR "Cannot map frame buffer registers\n");
 		goto failed_ioremap;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
input-ad7879-fix-workaroud-build-error-reported-by-andrew-morton.patch
pci-uninline-pci_ioremap_bar.patch
pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes.patch
vfs-lseekfd-0-seek_cur-race-condition-fix.patch
bdi-register-sysfs-bdi-device-only-once-per-queue-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
netdev-smc911x-fix-for-driver-resume-cleanup.patch
kernel-profilec-fix-section-mismatch-warning-fix.patch
usb-serial-console-add-device-function-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take-2-checkpatch-fixes.patch
binfmtsh-include-listh-fix.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix-2.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch
quota-cleanup-use-inode-i_blkbits-to-get-block-bits-fix.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
w1-add-1-wire-master-driver-for-imx27-imx31-fix.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
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

