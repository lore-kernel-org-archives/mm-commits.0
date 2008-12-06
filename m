From: akpm@linux-foundation.org
Subject: - xfs-linux-next-i386-hackfix.patch removed from -mm tree
Date: Sat, 06 Dec 2008 15:59:56 -0800
Message-ID: <200812062359.mB6NxuTu018026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753455AbYLGAFG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 19:05:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@fromorbit.com, lachlan@sgi.com, tes@sgi.com, mm-commits@vger.kernel.org


The patch titled
     xfs: linux-next i386 hackfix
has been removed from the -mm tree.  Its filename was
     xfs-linux-next-i386-hackfix.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xfs: linux-next i386 hackfix
From: Andrew Morton <akpm@linux-foundation.org>

In file included from fs/xfs/linux-2.6/xfs_file.c:39:
fs/xfs/linux-2.6/xfs_ioctl32.h:50: error: expected specifier-qualifier-list before 'compat_time_t'
fs/xfs/linux-2.6/xfs_ioctl32.h:79: error: expected specifier-qualifier-list before 'compat_uptr_t'
fs/xfs/linux-2.6/xfs_ioctl32.h:94: error: expected specifier-qualifier-list before 'compat_uptr_t'
fs/xfs/linux-2.6/xfs_ioctl32.h:131: error: expected specifier-qualifier-list before 'compat_uptr_t'
fs/xfs/linux-2.6/xfs_ioctl32.h:142: error: expected specifier-qualifier-list before 'compat_uptr_t'
fs/xfs/linux-2.6/xfs_ioctl32.h:152: error: expected specifier-qualifier-list before 'compat_uptr_t'
fs/xfs/linux-2.6/xfs_ioctl32.h:161: error: expected specifier-qualifier-list before 'compat_uptr_t'
make[1]: *** [fs/xfs/linux-2.6/xfs_file.o] Error 1

Cc: Timothy Shimmin <tes@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_ioctl32.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/xfs/linux-2.6/xfs_ioctl32.h~xfs-linux-next-i386-hackfix fs/xfs/linux-2.6/xfs_ioctl32.h
--- a/fs/xfs/linux-2.6/xfs_ioctl32.h~xfs-linux-next-i386-hackfix
+++ a/fs/xfs/linux-2.6/xfs_ioctl32.h
@@ -46,6 +46,7 @@ extern long xfs_file_compat_invis_ioctl(
 #define __compat_packed
 #endif
 
+#ifdef CONFIG_COMPAT
 typedef struct compat_xfs_bstime {
 	compat_time_t	tv_sec;		/* seconds		*/
 	__s32		tv_nsec;	/* and nanoseconds	*/
@@ -232,6 +233,7 @@ typedef struct compat_xfs_growfs_rt {
 #define XFS_IOC_FSGROWFSDATA_32 _IOW('X', 110, struct compat_xfs_growfs_data)
 #define XFS_IOC_FSGROWFSRT_32   _IOW('X', 112, struct compat_xfs_growfs_rt)
 
+#endif	/* CONFIG_COMPAT */
 #endif /* BROKEN_X86_ALIGNMENT */
 
 #endif /* __XFS_IOCTL32_H__ */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-backing-devc-remove-recently-added-warn_on.patch
ksym_symbol_len-fixes.patch
mm-remove-the-might_sleep-from-lock_page.patch
make-linx-next-apply.patch
linux-next.patch
next-remove-localversion.patch
xfs-linux-next-i386-hackfix.patch
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

