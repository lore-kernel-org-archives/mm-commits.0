From: akpm@osdl.org
Subject: + mips-remove-smp_tune_scheduling.patch added to -mm tree
Date: Thu, 11 Jan 2007 13:17:44 -0800
Message-ID: <200701112117.l0BLHiEP003289@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35774 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154AbXAKVVG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 16:21:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, ralf@linux-mips.org


The patch titled
     MIPS: remove smp_tune_scheduling()
has been added to the -mm tree.  Its filename is
     mips-remove-smp_tune_scheduling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MIPS: remove smp_tune_scheduling()
From: Adrian Bunk <bunk@stusta.de>

Since smp_tune_scheduling() didn't do anything we can simply remove it.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/mips/kernel/smp.c |   28 ----------------------------
 1 files changed, 28 deletions(-)

diff -puN arch/mips/kernel/smp.c~mips-remove-smp_tune_scheduling arch/mips/kernel/smp.c
--- a/arch/mips/kernel/smp.c~mips-remove-smp_tune_scheduling
+++ a/arch/mips/kernel/smp.c
@@ -51,33 +51,6 @@ int __cpu_logical_map[NR_CPUS];		/* Map 
 EXPORT_SYMBOL(phys_cpu_present_map);
 EXPORT_SYMBOL(cpu_online_map);
 
-static void smp_tune_scheduling (void)
-{
-	struct cache_desc *cd = &current_cpu_data.scache;
-	unsigned long cachesize;       /* kB   */
-	unsigned long cpu_khz;
-
-	/*
-	 * Crude estimate until we actually meassure ...
-	 */
-	cpu_khz = loops_per_jiffy * 2 * HZ / 1000;
-
-	/*
-	 * Rough estimation for SMP scheduling, this is the number of
-	 * cycles it takes for a fully memory-limited process to flush
-	 * the SMP-local cache.
-	 *
-	 * (For a P5 this pretty much means we will choose another idle
-	 *  CPU almost always at wakeup time (this is due to the small
-	 *  L1 cache), on PIIs it's around 50-100 usecs, depending on
-	 *  the cache size)
-	 */
-	if (!cpu_khz)
-		return;
-
-	cachesize = cd->linesz * cd->sets * cd->ways;
-}
-
 extern void __init calibrate_delay(void);
 extern ATTRIB_NORET void cpu_idle(void);
 
@@ -245,7 +218,6 @@ void __init smp_prepare_cpus(unsigned in
 {
 	init_new_context(current, &init_mm);
 	current_thread_info()->cpu = 0;
-	smp_tune_scheduling();
 	plat_prepare_cpus(max_cpus);
 #ifndef CONFIG_HOTPLUG_CPU
 	cpu_present_map = cpu_possible_map;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-alsa.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-libata-all.patch
git-mtd.patch
drivers-mtd-ubi-vtblc-make-2-functions-static.patch
git-netdev-all.patch
net-irda-proper-prototypes.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
make-isa_bridge-alpha-only.patch
git-scsi-rc-fixes.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
x86_64-re-add-a-newline-to-restore_context.patch
lumpy-reclaim-cleanup.patch
remove-include-linux-byteorder-pdp_endianh.patch
toshiba-tc86c001-ide-driver-take-2-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch
schedule-obsolete-oss-drivers-for-removal-3rd-round.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i386-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
fbdev-driver-for-s3-trio-virge-cleanups.patch
remove-broken-video-drivers-v4.patch
remove-bogus-con_is_present-prototypes.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
cpu_freq_table-shouldnt-be-a-def_tristate.patch
drivers-char-drm-drm_mmc-remove-unused-exports.patch
make-hdlc_setup-static-again.patch
voyager-remove-smp_tune_scheduling-fixme.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
net-wanrouter-wanmainc-cleanups.patch
more-ftape-removal.patch
cleanup-linux-byteorder-swabbh.patch
mips-remove-smp_tune_scheduling.patch
