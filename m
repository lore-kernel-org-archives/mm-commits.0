From: akpm@linux-foundation.org
Subject: - powerpc-replace-__function__-with-__func__-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:28:29 -0700
Message-ID: <200807301928.m6UJSTnt011832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754500AbYG3T2x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:28:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     powerpc-replace-__function__-with-__func__-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     powerpc-replace-__function__-with-__func__-checkpatch-fixes.patch

This patch was dropped because it was folded into powerpc-replace-__function__-with-__func__.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc-replace-__function__-with-__func__-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#22: FILE: arch/powerpc/kernel/lparcfg.c:508:
+^I         __func__, ppp_data.entitlement, ppp_data.weight);$

ERROR: code indent should use tabs where possible
#35: FILE: arch/powerpc/kernel/lparcfg.c:554:
+^I         __func__, mpp_data.entitled_mem, mpp_data.mem_weight);$

ERROR: code indent should use tabs where possible
#39: FILE: arch/powerpc/kernel/lparcfg.c:557:
+^I         __func__, new_entitled, new_weight);$

WARNING: line over 80 characters
#51: FILE: arch/powerpc/platforms/pseries/cmm.c:124:
+				pr_info("%s: Can not allocate new page list\n", __func__);

WARNING: line over 80 characters
#60: FILE: arch/powerpc/platforms/pseries/cmm.c:141:
+			pr_err("%s: Can not set page to loaned. rc=%ld\n", __func__, rc);

total: 3 errors, 2 warnings, 40 lines checked

./patches/powerpc-replace-__function__-with-__func__.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/lparcfg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/kernel/lparcfg.c~powerpc-replace-__function__-with-__func__-checkpatch-fixes arch/powerpc/kernel/lparcfg.c
--- a/arch/powerpc/kernel/lparcfg.c~powerpc-replace-__function__-with-__func__-checkpatch-fixes
+++ a/arch/powerpc/kernel/lparcfg.c
@@ -505,7 +505,7 @@ static ssize_t update_ppp(u64 *entitleme
 		return -EINVAL;
 
 	pr_debug("%s: current_entitled = %lu, current_weight = %u\n",
-	         __func__, ppp_data.entitlement, ppp_data.weight);
+		 __func__, ppp_data.entitlement, ppp_data.weight);
 
 	pr_debug("%s: new_entitled = %lu, new_weight = %u\n",
 		 __func__, new_entitled, new_weight);
@@ -554,7 +554,7 @@ static ssize_t update_mpp(u64 *entitleme
 	         __func__, mpp_data.entitled_mem, mpp_data.mem_weight);
 
 	pr_debug("%s: new_entitled = %lu, new_weight = %u\n",
-	         __func__, new_entitled, new_weight);
+		 __func__, new_entitled, new_weight);
 
 	rc = plpar_hcall_norets(H_SET_MPP, new_entitled, new_weight);
 	return rc;
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
powerpc-replace-__function__-with-__func__-checkpatch-fixes.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-serio-xilinx_ps2c-fix-warning.patch
git-jg-misc.patch
git-mtd.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
drivers-mtd-nand-nandsimc-fix-printk-warnings.patch
git-ubi-git-rejects.patch
bridge-send-correct-mtu-value-in-pmtu-checkpatch-fixes.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
sched-type-fix.patch
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

