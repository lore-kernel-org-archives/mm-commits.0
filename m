From: akpm@linux-foundation.org
Subject: - scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:43:33 -0700
Message-ID: <200807301943.m6UJhY4d012791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752531AbYG3To0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:44:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch

This patch was dropped because it was folded into scsi-gdthc-use-unaligned-access-helpers.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: spaces required around that '=' (ctx:VxW)
#59: FILE: drivers/scsi/gdth.c:2522:
+		blockcnt= scp->cmnd[4]==0 ? 0x100 : scp->cmnd[4];
 		        ^

ERROR: spaces required around that '==' (ctx:VxV)
#59: FILE: drivers/scsi/gdth.c:2522:
+		blockcnt= scp->cmnd[4]==0 ? 0x100 : scp->cmnd[4];
 		                      ^

total: 2 errors, 0 warnings, 43 lines checked

./patches/scsi-gdthc-use-unaligned-access-helpers.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/gdth.c~scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes
+++ a/drivers/scsi/gdth.c
@@ -2519,7 +2519,7 @@ static int gdth_fill_cache_cmd(gdth_ha_s
         } else {
 		blockno = get_unaligned_be32(&scp->cmnd[2]);
 		blockno &= 0x001fffffUL;
-		blockcnt= scp->cmnd[4]==0 ? 0x100 : scp->cmnd[4];
+		blockcnt = scp->cmnd[4] == 0 ? 0x100 : scp->cmnd[4];
         }
         if (mode64) {
             cmdp->u.cache64.BlockNo = blockno;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
pci-make-pci_register_driver-a-macro.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-serio-xilinx_ps2c-fix-warning.patch
git-jg-misc.patch
git-mtd.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
drivers-mtd-nand-nandsimc-fix-printk-warnings.patch
git-ubi-git-rejects.patch
bridge-send-correct-mtu-value-in-pmtu.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
sched-type-fix.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
git-block-git-rejects.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
git-xtensa.patch
drivers-telephony-ixjc-depends-on-pnp.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
hwmon-adc124s501-generic-driver.patch
drivers-net-netxen-netxen_nic_hwc-fix-printk-warnings.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works-comment.patch
ftrace-disable-function-tracing-bringing-up-new-cpu-fix.patch
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
eink_apollofb-new-driver-for-apollo-eink-controller.patch
devpts-switch-to-ida-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
w1-feature-enable-hardware-strong-pullup-checkpatch-fixes.patch
w1-ds2490c-add-support-for-strong-pullup-checkpatch-fixes.patch
w1-ds2490c-optimize-ds_set_pullup-checkpatch-fixes.patch
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

