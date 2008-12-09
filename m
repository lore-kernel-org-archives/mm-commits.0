From: akpm@linux-foundation.org
Subject: - drivers-net-e1000e-ich8lanc-fix-locking.patch removed from -mm tree
Date: Tue, 09 Dec 2008 15:57:14 -0800
Message-ID: <200812092357.mB9NvE5M003712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756059AbYLIX5a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Dec 2008 18:57:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, frederik.deweerdt@xprog.eu, jesse.brandeburg@intel.com, stable@kernel.org, tglx@linutronix.de, zdenek.kabelac@gmail.com, mm-commits@vge


The patch titled
     drivers/net/e1000e/ich8lan.c: fix locking
has been removed from the -mm tree.  Its filename was
     drivers-net-e1000e-ich8lanc-fix-locking.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/e1000e/ich8lan.c: fix locking
From: Andrew Morton <akpm@linux-foundation.org>

=====================================
[ BUG: bad unlock balance detected! ]
-------------------------------------

A regression added by 717d438d1fde94decef874b9808379d1f4523453 ("e1000e:
debug contention on NVM SWFLAG").

Reported-by: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Cc: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000e/ich8lan.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/net/e1000e/ich8lan.c~drivers-net-e1000e-ich8lanc-fix-locking drivers/net/e1000e/ich8lan.c
--- a/drivers/net/e1000e/ich8lan.c~drivers-net-e1000e-ich8lanc-fix-locking
+++ a/drivers/net/e1000e/ich8lan.c
@@ -400,6 +400,7 @@ static s32 e1000_acquire_swflag_ich8lan(
 {
 	u32 extcnf_ctrl;
 	u32 timeout = PHY_CFG_TIMEOUT;
+	s32 ret = 0;
 
 	might_sleep();
 
@@ -427,11 +428,11 @@ static s32 e1000_acquire_swflag_ich8lan(
 		extcnf_ctrl &= ~E1000_EXTCNF_CTRL_SWFLAG;
 		ew32(EXTCNF_CTRL, extcnf_ctrl);
 		nvm_owner = -1;
-		mutex_unlock(&nvm_mutex);
-		return -E1000_ERR_CONFIG;
+		ret = -E1000_ERR_CONFIG;
 	}
 
-	return 0;
+	mutex_unlock(&nvm_mutex);
+	return ret;
 }
 
 /**
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-backing-devc-remove-recently-added-warn_on.patch
revert-percpu-counter-clean-up-percpu_counter_sum_and_set.patch
revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch
ksym_symbol_len-fixes.patch
drivers-video-mb862xx-mb862xxfbc-fix-printk.patch
mm-remove-the-might_sleep-from-lock_page.patch
make-linx-next-apply.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
pci-uninline-pci_ioremap_bar.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-mmapc-fix-coding-style-fix.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
binfmtsh-include-listh-fix.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes-checkpatch-fixes.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
edac-x38-use-the-architectures-readq-function-fix-fix.patch
parport-ieee1284-use-del_timer_sync-in-parport_wait_event-checkpatch-fixes.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
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
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch
drivers-net-e1000e-ich8lanc-fix-locking.patch

