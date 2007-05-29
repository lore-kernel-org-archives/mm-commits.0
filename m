From: akpm@linux-foundation.org
Subject: - xfs-clean-up-shrinker-games.patch removed from -mm tree
Date: Tue, 29 May 2007 11:56:19 -0700
Message-ID: <200705291856.l4TIuIwQ008639@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764512AbXE2S46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:56:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dgc@sgi.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     xfs clean up shrinker games
has been removed from the -mm tree.  Its filename was
     xfs-clean-up-shrinker-games.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: xfs clean up shrinker games
From: Andrew Morton <akpm@linux-foundation.org>

Strip away lots of needless wrapping and type obfuscation in XFS's handling of
cache shrinker registration.

Cc: David Chinner <dgc@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/kmem.h    |   19 -------------------
 fs/xfs/linux-2.6/xfs_buf.c |    6 +++---
 fs/xfs/quota/xfs_qm.c      |    6 +++---
 3 files changed, 6 insertions(+), 25 deletions(-)

diff -puN fs/xfs/linux-2.6/kmem.h~xfs-clean-up-shrinker-games fs/xfs/linux-2.6/kmem.h
--- a/fs/xfs/linux-2.6/kmem.h~xfs-clean-up-shrinker-games
+++ a/fs/xfs/linux-2.6/kmem.h
@@ -100,25 +100,6 @@ kmem_zone_destroy(kmem_zone_t *zone)
 extern void *kmem_zone_alloc(kmem_zone_t *, unsigned int __nocast);
 extern void *kmem_zone_zalloc(kmem_zone_t *, unsigned int __nocast);
 
-/*
- * Low memory cache shrinkers
- */
-
-typedef struct shrinker *kmem_shaker_t;
-typedef int (*kmem_shake_func_t)(int, gfp_t);
-
-static inline kmem_shaker_t
-kmem_shake_register(kmem_shake_func_t sfunc)
-{
-	return set_shrinker(DEFAULT_SEEKS, sfunc);
-}
-
-static inline void
-kmem_shake_deregister(kmem_shaker_t shrinker)
-{
-	remove_shrinker(shrinker);
-}
-
 static inline int
 kmem_shake_allow(gfp_t gfp_mask)
 {
diff -puN fs/xfs/linux-2.6/xfs_buf.c~xfs-clean-up-shrinker-games fs/xfs/linux-2.6/xfs_buf.c
--- a/fs/xfs/linux-2.6/xfs_buf.c~xfs-clean-up-shrinker-games
+++ a/fs/xfs/linux-2.6/xfs_buf.c
@@ -35,7 +35,7 @@
 #include <linux/freezer.h>
 
 static kmem_zone_t *xfs_buf_zone;
-static kmem_shaker_t xfs_buf_shake;
+static struct shrinker *xfs_buf_shake;
 STATIC int xfsbufd(void *);
 STATIC int xfsbufd_wakeup(int, gfp_t);
 STATIC void xfs_buf_delwri_queue(xfs_buf_t *, int);
@@ -1841,7 +1841,7 @@ xfs_buf_init(void)
 	if (!xfsdatad_workqueue)
 		goto out_destroy_xfslogd_workqueue;
 
-	xfs_buf_shake = kmem_shake_register(xfsbufd_wakeup);
+	xfs_buf_shake = set_shrinker(DEFAULT_SEEKS, xfsbufd_wakeup);
 	if (!xfs_buf_shake)
 		goto out_destroy_xfsdatad_workqueue;
 
@@ -1863,7 +1863,7 @@ xfs_buf_init(void)
 void
 xfs_buf_terminate(void)
 {
-	kmem_shake_deregister(xfs_buf_shake);
+	remove_shrinker(xfs_buf_shake);
 	destroy_workqueue(xfsdatad_workqueue);
 	destroy_workqueue(xfslogd_workqueue);
 	kmem_zone_destroy(xfs_buf_zone);
diff -puN fs/xfs/quota/xfs_qm.c~xfs-clean-up-shrinker-games fs/xfs/quota/xfs_qm.c
--- a/fs/xfs/quota/xfs_qm.c~xfs-clean-up-shrinker-games
+++ a/fs/xfs/quota/xfs_qm.c
@@ -62,7 +62,7 @@ uint		ndquot;
 
 kmem_zone_t	*qm_dqzone;
 kmem_zone_t	*qm_dqtrxzone;
-static kmem_shaker_t	xfs_qm_shaker;
+static struct shrinker *xfs_qm_shaker;
 
 static cred_t	xfs_zerocr;
 static xfs_inode_t	xfs_zeroino;
@@ -150,7 +150,7 @@ xfs_Gqm_init(void)
 	} else
 		xqm->qm_dqzone = qm_dqzone;
 
-	xfs_qm_shaker = kmem_shake_register(xfs_qm_shake);
+	xfs_qm_shaker = set_shrinker(DEFAULT_SEEKS, xfs_qm_shake);
 
 	/*
 	 * The t_dqinfo portion of transactions.
@@ -182,7 +182,7 @@ xfs_qm_destroy(
 
 	ASSERT(xqm != NULL);
 	ASSERT(xqm->qm_nrefs == 0);
-	kmem_shake_deregister(xfs_qm_shaker);
+	remove_shrinker(xfs_qm_shaker);
 	hsize = xqm->qm_dqhashmask + 1;
 	for (i = 0; i < hsize; i++) {
 		xfs_qm_list_destroy(&(xqm->qm_usr_dqhtable[i]));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slub-more-documentation-fix.patch
ntfs_init_locked_inode-fix-array-indexing.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm-master.patch
git-cpufreq-fix.patch
8xx-mpc885ads-pcmcia-support.patch
fix-gregkh-driver-dmi-based-module-autoloading.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
driver-core-check-return-code-of-sysfs_create_link.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-input.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
git-leds-fixup.patch
git-mips-fixup.patch
git-mtd.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
git-ubi.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
pci-x-pci-express-read-control-interfaces-fix.patch
git-pciseg.patch
sh-support-older-gccs.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-unionfs.patch
fix-gregkh-usb-usb-ehci-cpufreq-fix.patch
git-watchdog.patch
git-wireless.patch
x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
x86_64-fix-smp_call_function_single-return-value.patch
git-xfs.patch
git-cryptodev.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-add-proc-pid-pagemap-interface.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch
freezer-run-show_state-when-freezing-times-out.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty-fix.patch
mpu401-warning-fixes.patch
procfs-directory-entry-cleanup-fix.patch
vdso-print-fatal-signals.patch
reduce-cpusetc-write_lock_irq-to-read_lock-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-borkages.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-warning-fixes.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
reiser4.patch
reiser4-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
