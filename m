From: akpm@linux-foundation.org
Subject: - mm-clean-up-and-kernelify-shrinker-registration-vs-git-nfs.patch removed from -mm tree
Date: Tue, 17 Jul 2007 01:04:56 -0700
Message-ID: <200707170804.l6H84u6l006720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53477 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754130AbXGQIFu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 04:05:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dgc@sgi.com, rusty@rustcorp.com.au, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     mm-clean-up-and-kernelify-shrinker-registration-vs-git-nfs
has been removed from the -mm tree.  Its filename was
     mm-clean-up-and-kernelify-shrinker-registration-vs-git-nfs.patch

This patch was dropped because it was folded into mm-clean-up-and-kernelify-shrinker-registration.patch

------------------------------------------------------
Subject: mm-clean-up-and-kernelify-shrinker-registration-vs-git-nfs
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Chinner <dgc@sgi.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/auth.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN net/sunrpc/auth.c~mm-clean-up-and-kernelify-shrinker-registration-vs-git-nfs net/sunrpc/auth.c
--- a/net/sunrpc/auth.c~mm-clean-up-and-kernelify-shrinker-registration-vs-git-nfs
+++ a/net/sunrpc/auth.c
@@ -534,17 +534,18 @@ rpcauth_uptodatecred(struct rpc_task *ta
 		test_bit(RPCAUTH_CRED_UPTODATE, &cred->cr_flags) != 0;
 }
 
-
-static struct shrinker *rpc_cred_shrinker;
+static struct shrinker rpc_cred_shrinker = {
+	.shrink = rpcauth_cache_shrinker,
+	.seeks = DEFAULT_SEEKS,
+};
 
 void __init rpcauth_init_module(void)
 {
 	rpc_init_authunix();
-	rpc_cred_shrinker = set_shrinker(DEFAULT_SEEKS, rpcauth_cache_shrinker);
+	register_shrinker(&rpc_cred_shrinker);
 }
 
 void __exit rpcauth_remove_module(void)
 {
-	if (rpc_cred_shrinker != NULL)
-		remove_shrinker(rpc_cred_shrinker);
+	unregister_shrinker(&rpc_cred_shrinker);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sysctlc-add-text-telling-people-to-use-ctl_unnumbered-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
mm-clean-up-and-kernelify-shrinker-registration-vs-git-nfs.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
file-capabilities-clear-caps-cleanup-fix.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
i386-speedup-touch_nmi_watchdog.patch
x86_64-speedup-touch_nmi_watchdog.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support.patch
spi-master-driver-for-xilinx-virtex.patch
isdn-capi-warning-fixes.patch
i2o_cfg_passthru-cleanup.patch
knfsd-exportfs-add-exportfsh-header.patch
knfsd-exportfs-remove-iget-abuse.patch
nfsd-warning-fix.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
rtc-add-rtc-m41t80-driver-take-2.patch
rtc-add-support-for-the-st-m48t59-rtc.patch
rtc-add-support-for-the-st-m48t59-rtc-vs-git-acpi.patch
rtc-driver-for-ds1216-chips-fix.patch
lguest-the-host-code.patch
lguest-the-net-driver.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver-fix.patch
containersv10-basic-container-framework-fix.patch
containersv10-basic-container-framework-fix-2.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
add-containerstats-v3-fix.patch
lockstat-core-infrastructure.patch
lockdep-various-fixes.patch
lockstat-measure-lock-bouncing.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
