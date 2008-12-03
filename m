From: akpm@linux-foundation.org
Subject: - quota-cleanup-use-inode-i_blkbits-to-get-block-bits-fix.patch removed from -mm tree
Date: Wed, 03 Dec 2008 12:44:44 -0800
Message-ID: <200812032044.mB3Kiij2004742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335AbYLCUpq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 15:45:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cmm@us.ibm.com, hch@lst.de, jack@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     quota-cleanup-use-inode-i_blkbits-to-get-block-bits-fix
has been removed from the -mm tree.  Its filename was
     quota-cleanup-use-inode-i_blkbits-to-get-block-bits-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota-cleanup-use-inode-i_blkbits-to-get-block-bits-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@ucw.cz>
Cc: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/quotaops.h |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff -puN include/linux/quotaops.h~quota-cleanup-use-inode-i_blkbits-to-get-block-bits-fix include/linux/quotaops.h
--- a/include/linux/quotaops.h~quota-cleanup-use-inode-i_blkbits-to-get-block-bits-fix
+++ a/include/linux/quotaops.h
@@ -410,39 +410,33 @@ static inline void vfs_dq_free_space(str
 
 static inline int vfs_dq_prealloc_block_nodirty(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_prealloc_space_nodirty(inode,
-			nr << inode->i_blkbits);
+	return vfs_dq_prealloc_space_nodirty(inode, nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_prealloc_block(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_prealloc_space(inode,
-			nr << inode->i_blkbits);
+	return vfs_dq_prealloc_space(inode, nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_alloc_block_nodirty(struct inode *inode, qsize_t nr)
 {
- 	return vfs_dq_alloc_space_nodirty(inode,
-			nr << inode->i_blkbits);
+ 	return vfs_dq_alloc_space_nodirty(inode, nr << inode->i_blkbits);
 }
 
 
 static inline int vfs_dq_alloc_block(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_alloc_space(inode,
-			nr << inode->i_blkbits);
+	return vfs_dq_alloc_space(inode, nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_reserve_block(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_reserve_space(inode,
-			nr << inode->i_blkbits);
+	return vfs_dq_reserve_space(inode, nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_claim_block(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_claim_space(inode,
-			nr << inode->i_blkbits);
+	return vfs_dq_claim_space(inode, nr << inode->i_blkbits);
 }
 
 static inline
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-backing-devc-remove-recently-added-warn_on.patch
ksym_symbol_len-fixes.patch
mm-remove-the-might_sleep-from-lock_page.patch
make-linx-next-apply.patch
linux-next.patch
next-remove-localversion.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
netdev-smc911x-fix-for-driver-resume-cleanup.patch
backlight-catch-invalid-input.patch
pci-uninline-pci_ioremap_bar.patch
drivers-char-cycladesc-cy_pci_probe-fix-error-path.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
binfmtsh-include-listh-fix.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
quota-cleanup-use-inode-i_blkbits-to-get-block-bits-fix.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
parport-ieee1284-use-del_timer_sync-in-parport_wait_event-checkpatch-fixes.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
ldisc-n_tty-export-all-n_tty-ldisc-methods-fix.patch
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

