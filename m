From: akpm@osdl.org
Subject: - cleanup-arch-i386-kernel-smpbootcsmp_tune_scheduling.patch removed from -mm tree
Date: Wed, 06 Dec 2006 14:24:08 -0800
Message-ID: <200612062224.kB6MO85t018590@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48870 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937747AbWLFW3N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 17:29:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     cleanup arch/i386/kernel/smpboot.c:smp_tune_scheduling()
has been removed from the -mm tree.  Its filename was
     cleanup-arch-i386-kernel-smpbootcsmp_tune_scheduling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cleanup arch/i386/kernel/smpboot.c:smp_tune_scheduling()
From: Adrian Bunk <bunk@stusta.de>

- remove the write-only local variable "bandwidth"
- don't set "max_cache_size" in the (cachesize < 0) case:
  that's already handled in kernel/sched.c:measure_migration_cost()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/smpboot.c |   29 +++++------------------------
 1 files changed, 5 insertions(+), 24 deletions(-)

diff -puN arch/i386/kernel/smpboot.c~cleanup-arch-i386-kernel-smpbootcsmp_tune_scheduling arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~cleanup-arch-i386-kernel-smpbootcsmp_tune_scheduling
+++ a/arch/i386/kernel/smpboot.c
@@ -1130,34 +1130,15 @@ exit:
 }
 #endif
 
-static void smp_tune_scheduling (void)
+static void smp_tune_scheduling(void)
 {
 	unsigned long cachesize;       /* kB   */
-	unsigned long bandwidth = 350; /* MB/s */
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
 
-	if (!cpu_khz) {
-		/*
-		 * this basically disables processor-affinity
-		 * scheduling on SMP without a TSC.
-		 */
-		return;
-	} else {
+	if (cpu_khz) {
 		cachesize = boot_cpu_data.x86_cache_size;
-		if (cachesize == -1) {
-			cachesize = 16; /* Pentiums, 2x8kB cache */
-			bandwidth = 100;
-		}
-		max_cache_size = cachesize * 1024;
+
+		if (cachesize > 0)
+			max_cache_size = cachesize * 1024;
 	}
 }
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
make-drivers-acpi-baycdrive_bays-static.patch
make-drivers-acpi-eccec_ecdt-static.patch
drivers-acpi-oslc-fix-a-null-check.patch
git-alsa.patch
git-dvb.patch
git-gfs2-nmw.patch
fs-dlm-lowcomms-tcpc-remove-2-functions.patch
git-mtd.patch
remove-mtd-jffs2-userh.patch
git-net.patch
net-uninline-skb_put-fix.patch
dont-export-device-ids-to-userspace.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
make-mm-thrashcglobal_faults-static.patch
acx1xx-wireless-driver.patch
arch-frv-kernel-futexc-must-include-linux-uaccessh.patch
fix-v850-compilation.patch
drivers-edac-make-code-static.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
ext4_ext_split-remove-dead-code.patch
the-scheduled-removal-of-some-oss-options.patch
make-mm-shmemcshmem_xattr_security_handler-static.patch
remove-kernel-lockdepclockdep_internal.patch
make-kernel-signalckill_proc_info-static.patch
make-ecryptfs_version_str_map-static.patch
make-fs-jbd-transactionc__journal_temp_unlink_buffer-static.patch
make-fs-jbd2-transactionc__jbd2_journal_temp_unlink_buffer-static.patch
fs-lockd-hostc-make-2-functions-static.patch
make-fs-proc-basecproc_pid_instantiate-static.patch
better-config_w1_slave_ds2433_crc-handling.patch
fs-sysv-doc-cleanup.patch
proper-prototype-for-remove_inode_dquot_ref.patch
remove-drivers-char-riscom8cbaud_table.patch
arch-i386-kernel-rebootc-should-include-linux-rebooth.patch
remove-export_unused_symboled-symbols.patch
include-asm-cris-extern-inline-static-inline.patch
include-asm-h8300-extern-inline-static-inline.patch
remove-nfsd_optimize_space.patch
maintainers-remove-the-non-existing-sun3-list.patch
cleanup-include-asm-generic-atomich.patch
cleanup-include-asm-generic-atomich-fix.patch
paride-remove-parport-ifdefs.patch
remove-drivers-block-paride-jumbo.patch
cleanup-asm-setuph-userspace-visibility-v2.patch
make-ext2_get_blocks-static.patch
generic-bug-implementation-include-linux-bugh-must-always-include-linux-moduleh.patch
fsstack-introduce-fsstack_copy_attrinode_-fs-stackc-should-include-linux-fs_stackh.patch
i4l-remove-the-broken-hisax_amd7930-option.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
make-drivers-md-dm-snapcksnapd-static.patch
gtod-persistent-clock-support-core-remove-kernel-timercwall_jiffies.patch
gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-make-kernel-timerc__next_timer_interrupt-static.patch
updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch
updated-i386-convert-to-clock-event-devices-remove-arch-i386-kernel-time_hpetchpet_reenable.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slab-cache-shrinker-statistics.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

