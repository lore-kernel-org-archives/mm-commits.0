From: akpm@linux-foundation.org
Subject: - drivers-input-serio-xilinx_ps2c-fix-warning.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:33:04 -0700
Message-ID: <200808122033.m7CKX4qk011761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751199AbYHLUdi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:33:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     drivers/input/serio/xilinx_ps2.c: fix warning
has been removed from the -mm tree.  Its filename was
     drivers-input-serio-xilinx_ps2c-fix-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/input/serio/xilinx_ps2.c: fix warning
From: Andrew Morton <akpm@linux-foundation.org>

drivers/input/serio/xilinx_ps2.c:272: warning: cast from pointer to integer of different size

Also, it is fishy that phys_addr has a 32-bit type.

Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/xilinx_ps2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/input/serio/xilinx_ps2.c~drivers-input-serio-xilinx_ps2c-fix-warning drivers/input/serio/xilinx_ps2.c
--- a/drivers/input/serio/xilinx_ps2.c~drivers-input-serio-xilinx_ps2c-fix-warning
+++ a/drivers/input/serio/xilinx_ps2.c
@@ -269,8 +269,8 @@ static int xps2_setup(struct device *dev
 	 * we have the PS2 in a good state */
 	out_be32(drvdata->base_address + XPS2_SRST_OFFSET, XPS2_SRST_RESET);
 
-	dev_info(dev, "Xilinx PS2 at 0x%08X mapped to 0x%08X, irq=%d\n",
-		drvdata->phys_addr, (u32)drvdata->base_address, drvdata->irq);
+	dev_info(dev, "Xilinx PS2 at 0x%08X mapped to 0x%p, irq=%d\n",
+		drvdata->phys_addr, drvdata->base_address, drvdata->irq);
 
 	serio = &drvdata->serio;
 	serio->id.type = SERIO_8042;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-eventpollc-fix-sys_epoll_create1-comment.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
git-jg-misc.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-checkpatch-fixes.patch
scsi-gdthc-use-unaligned-access-helpers.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
hwmon-adc124s501-generic-driver.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
scsi-megaraid_sas-add-the-new-controllers-support.patch
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
h8300-generic_bug-support-checkpatch-fixes.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
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

