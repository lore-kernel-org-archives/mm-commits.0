From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 15 Jun 2009 11:55:45 -0700
Message-ID: <200906151855.n5FItj2v017731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759992AbZFOSzp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 14:55:45 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n5FItkgq016248
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 15 Jun 2009 11:55:47 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/platform/523x/config.c      |    7 -------
 arch/m68knommu/platform/527x/config.c      |    4 ----
 arch/m68knommu/platform/528x/config.c      |    7 -------
 arch/m68knommu/platform/532x/config.c      |   11 -----------
 arch/m68knommu/platform/coldfire/vectors.c |   19 -------------------
 fs/ext4/super.c                            |    4 ----
 fs/gfs2/log.c                              |    5 -----
 fs/gfs2/super.c                            |    4 ----
 fs/reiserfs/super.c                        |    6 ------
 9 files changed, 67 deletions(-)

diff -puN arch/m68knommu/platform/523x/config.c~linux-next-git-rejects arch/m68knommu/platform/523x/config.c
--- a/arch/m68knommu/platform/523x/config.c~linux-next-git-rejects
+++ a/arch/m68knommu/platform/523x/config.c
@@ -99,14 +99,7 @@ static void m523x_cpu_reset(void)
 
 void __init config_BSP(char *commandp, int size)
 {
-<<<<<<< HEAD:arch/m68knommu/platform/523x/config.c
-	mcf_disableall();
 	mach_reset = m523x_cpu_reset;
-	m523x_uarts_init();
-	m523x_fec_init();
-=======
-	mach_reset = m523x_cpu_reset;
->>>>>>> FETCH_HEAD:arch/m68knommu/platform/523x/config.c
 }
 
 /***************************************************************************/
diff -puN arch/m68knommu/platform/527x/config.c~linux-next-git-rejects arch/m68knommu/platform/527x/config.c
--- a/arch/m68knommu/platform/527x/config.c~linux-next-git-rejects
+++ a/arch/m68knommu/platform/527x/config.c
@@ -192,10 +192,6 @@ static void m527x_cpu_reset(void)
 
 void __init config_BSP(char *commandp, int size)
 {
-<<<<<<< HEAD:arch/m68knommu/platform/527x/config.c
-	mcf_disableall();
-=======
->>>>>>> FETCH_HEAD:arch/m68knommu/platform/527x/config.c
 	mach_reset = m527x_cpu_reset;
 	m527x_uarts_init();
 	m527x_fec_init();
diff -puN arch/m68knommu/platform/528x/config.c~linux-next-git-rejects arch/m68knommu/platform/528x/config.c
--- a/arch/m68knommu/platform/528x/config.c~linux-next-git-rejects
+++ a/arch/m68knommu/platform/528x/config.c
@@ -22,13 +22,6 @@
 #include <asm/mcfsim.h>
 #include <asm/mcfuart.h>
 
-<<<<<<< HEAD:arch/m68knommu/platform/528x/config.c
-#ifdef CONFIG_MTD_PARTITIONS
-#include <linux/mtd/partitions.h>
-#endif
-
-=======
->>>>>>> FETCH_HEAD:arch/m68knommu/platform/528x/config.c
 /***************************************************************************/
 
 static struct mcf_platform_uart m528x_uart_platform[] = {
diff -puN arch/m68knommu/platform/532x/config.c~linux-next-git-rejects arch/m68knommu/platform/532x/config.c
--- a/arch/m68knommu/platform/532x/config.c~linux-next-git-rejects
+++ a/arch/m68knommu/platform/532x/config.c
@@ -133,17 +133,6 @@ void mcf_settimericr(unsigned int timer,
 /***************************************************************************/
 
 static void m532x_cpu_reset(void)
-<<<<<<< HEAD:arch/m68knommu/platform/532x/config.c
-{
-	local_irq_disable();
-	__raw_writeb(MCF_RCR_SWRESET, MCF_RCR);
-}
-
-/***************************************************************************/
-
-void __init config_BSP(char *commandp, int size)
-=======
->>>>>>> FETCH_HEAD:arch/m68knommu/platform/532x/config.c
 {
 	local_irq_disable();
 	__raw_writeb(MCF_RCR_SWRESET, MCF_RCR);
diff -puN arch/m68knommu/platform/coldfire/vectors.c~linux-next-git-rejects arch/m68knommu/platform/coldfire/vectors.c
--- a/arch/m68knommu/platform/coldfire/vectors.c~linux-next-git-rejects
+++ a/arch/m68knommu/platform/coldfire/vectors.c
@@ -78,23 +78,4 @@ void __init init_vectors(void)
 }
 
 /***************************************************************************/
-<<<<<<< HEAD:arch/m68knommu/platform/coldfire/vectors.c
 
-void enable_vector(unsigned int irq)
-{
-	/* Currently no action on ColdFire */
-}
-
-void disable_vector(unsigned int irq)
-{
-	/* Currently no action on ColdFire */
-}
-
-void ack_vector(unsigned int irq)
-{
-	/* Currently no action on ColdFire */
-}
-
-/***************************************************************************/
-=======
->>>>>>> FETCH_HEAD:arch/m68knommu/platform/coldfire/vectors.c
diff -puN fs/ext4/super.c~linux-next-git-rejects fs/ext4/super.c
--- a/fs/ext4/super.c~linux-next-git-rejects
+++ a/fs/ext4/super.c
@@ -580,11 +580,7 @@ static void ext4_put_super(struct super_
 	lock_super(sb);
 	lock_kernel();
 	if (sb->s_dirt)
-<<<<<<< HEAD:fs/ext4/super.c
 		ext4_commit_super(sb, 1);
-=======
-		ext4_write_super_locked(sb);
->>>>>>> FETCH_HEAD:fs/ext4/super.c
 
 	ext4_release_system_zone(sb);
 	ext4_mb_release(sb);
diff -puN fs/gfs2/log.c~linux-next-git-rejects fs/gfs2/log.c
--- a/fs/gfs2/log.c~linux-next-git-rejects
+++ a/fs/gfs2/log.c
@@ -769,11 +769,6 @@ void __gfs2_log_flush(struct gfs2_sbd *s
 		ai = NULL;
 	}
 	gfs2_log_unlock(sdp);
-<<<<<<< HEAD:fs/gfs2/log.c
-	trace_gfs2_log_flush(sdp, 0);
-=======
-
->>>>>>> FETCH_HEAD:fs/gfs2/log.c
 	up_write(&sdp->sd_log_flush_lock);
 
 	kfree(ai);
diff -puN fs/gfs2/super.c~linux-next-git-rejects fs/gfs2/super.c
--- a/fs/gfs2/super.c~linux-next-git-rejects
+++ a/fs/gfs2/super.c
@@ -787,11 +787,7 @@ restart:
 
 	/*  At this point, we're through participating in the lockspace  */
 	gfs2_sys_fs_del(sdp);
-<<<<<<< HEAD:fs/gfs2/super.c
-=======
-
 	unlock_kernel();
->>>>>>> FETCH_HEAD:fs/gfs2/super.c
 }
 
 /**
diff -puN fs/reiserfs/super.c~linux-next-git-rejects fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~linux-next-git-rejects
+++ a/fs/reiserfs/super.c
@@ -467,15 +467,12 @@ static void reiserfs_put_super(struct su
 	th.t_trans_id = 0;
 
 	lock_kernel();
-<<<<<<< HEAD:fs/reiserfs/super.c
-=======
 	/*
 	 * We didn't need to explicitly lock here before, because put_super
 	 * is called with the bkl held.
 	 * Now that we have our own lock, we must explicitly lock.
 	 */
 	reiserfs_write_lock(s);
->>>>>>> FETCH_HEAD:fs/reiserfs/super.c
 
 	if (s->s_dirt)
 		reiserfs_write_super(s);
@@ -1342,10 +1339,7 @@ static int reiserfs_remount(struct super
 
 out_ok:
 	replace_mount_options(s, new_opts);
-<<<<<<< HEAD:fs/reiserfs/super.c
-=======
 	reiserfs_write_unlock(s);
->>>>>>> FETCH_HEAD:fs/reiserfs/super.c
 	unlock_kernel();
 	return 0;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
ds_selftest-is-borked.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
jsm-clean-up-serial-jsm-correctly-support-4-8-port-boards.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
firmware_map-fix-hang-with-x86-32bit.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
pagemap-add-page-types-tool-fix.patch
videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
page-allocator-clean-up-functions-related-to-pages_min-checkpatch-fixes.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone-checkpatch-fixes.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
proc-merge-arrayc-into-basec-checkpatch-fixes.patch
gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes.patch
gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes-gpio-pca953x-get-platform_data-from-openfirmware-cleanups.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes.patch
fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-checkpatch-fixes.patch
documentation-changes-perl-is-needed-to-build-the-kernel-fix.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
char-moxa-prevent-opening-unavailable-ports.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation-fix.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

