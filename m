From: akpm@linux-foundation.org
Subject: + xfs-clean-up-shrinker-games.patch added to -mm tree
Date: Mon, 02 Apr 2007 23:02:57 -0700
Message-ID: <200704030602.l3362wkC018895@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34583 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbXDCGDK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 3 Apr 2007 02:03:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dgc@sgi.com, rusty@rustcorp.com.au


The patch titled
     xfs clean up shrinker games
has been added to the -mm tree.  Its filename is
     xfs-clean-up-shrinker-games.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1837,7 +1837,7 @@ xfs_buf_init(void)
 	if (!xfsdatad_workqueue)
 		goto out_destroy_xfslogd_workqueue;
 
-	xfs_buf_shake = kmem_shake_register(xfsbufd_wakeup);
+	xfs_buf_shake = set_shrinker(DEFAULT_SEEKS, xfsbufd_wakeup);
 	if (!xfs_buf_shake)
 		goto out_destroy_xfsdatad_workqueue;
 
@@ -1859,7 +1859,7 @@ xfs_buf_init(void)
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

origin.patch
revert-driver-core-do-not-wait-unnecessarily-in-driver_unregister.patch
slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-avr32.patch
git-avr32-fixup.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
git-libata-all-ipr-fix.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_acpi-restore-driver-fix.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
vioc-warning-fix.patch
vioc-cast-warning-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net.patch
git-net-fixup.patch
git-net-vs-git-netdev-all.patch
git-parisc.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-s390.patch
git-scsi-misc.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-git-net.patch
git-wireless-vs-git-net-2.patch
fix-x86_64-mm-sched-clock-share.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation-tidy.patch
xfs-clean-up-shrinker-games.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
slab-mark-set_up_list3s-__init.patch
driver_bfin_serial_core-update.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
parport-dev-driver-model-support-powerpc-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy.patch
add-support-for-deferrable-timers-respun-tidy.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc-fix.patch
fix-kevents-childs-priority-greediness-fix.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
utrace-x86_64-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls-x86_64-fix.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
