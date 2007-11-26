From: akpm@linux-foundation.org
Subject: - git-x86-identify_cpu-fix.patch removed from -mm tree
Date: Mon, 26 Nov 2007 13:49:54 -0800
Message-ID: <200711262149.lAQLnsFo024796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56480 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756566AbXKZV6u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 16:58:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     git-x86-identify_cpu-fix
has been removed from the -mm tree.  Its filename was
     git-x86-identify_cpu-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-x86-identify_cpu-fix
From: Andrew Morton <akpm@linux-foundation.org>

nfi.  Might be due to bad reject fixings.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup_64.c |   68 +----------------------------------
 1 file changed, 2 insertions(+), 66 deletions(-)

diff -puN arch/x86/kernel/setup_64.c~git-x86-identify_cpu-fix arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~git-x86-identify_cpu-fix
+++ a/arch/x86/kernel/setup_64.c
@@ -894,7 +894,7 @@ struct cpu_model_info {
    below. */
 static void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
 {
-	u32 tfms, xlvl;
+	u32 tfms;
 
 	c->loops_per_jiffy = loops_per_jiffy;
 	c->x86_cache_size = -1;
@@ -950,7 +950,7 @@ static void __cpuinit early_identify_cpu
 void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 {
 	/* AMD-defined flags: level 0x80000001 */
-	xlvl = cpuid_eax(0x80000000);
+	u32 xlvl = cpuid_eax(0x80000000);
 	c->extended_cpuid_level = xlvl;
 	if ((xlvl & 0xffff0000) == 0x80000000) {
 		if (xlvl >= 0x80000001) {
@@ -977,70 +977,6 @@ void __cpuinit identify_cpu(struct cpuin
 
 }
 
-/*
- * This does the hard work of actually picking apart the CPU stuff...
- */
-void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
-{
-	int i;
-
-	early_identify_cpu(c);
-
-	init_scattered_cpuid_features(c);
-
-	c->apicid = phys_pkg_id(0);
-
-	/*
-	 * Vendor-specific initialization.  In this section we
-	 * canonicalize the feature flags, meaning if there are
-	 * features a certain CPU supports which CPUID doesn't
-	 * tell us, CPUID claiming incorrect flags, or other bugs,
-	 * we handle them here.
-	 *
-	 * At the end of this section, c->x86_capability better
-	 * indicate the features this CPU genuinely supports!
-	 */
-	switch (c->x86_vendor) {
-	case X86_VENDOR_AMD:
-		init_amd(c);
-		break;
-
-	case X86_VENDOR_INTEL:
-		init_intel(c);
-		break;
-
-	case X86_VENDOR_UNKNOWN:
-	default:
-		display_cacheinfo(c);
-		break;
-	}
-
-	select_idle_routine(c);
-	detect_ht(c); 
-
-	/*
-	 * On SMP, boot_cpu_data holds the common feature set between
-	 * all CPUs; so make sure that we indicate which features are
-	 * common between the CPUs.  The first time this routine gets
-	 * executed, c == &boot_cpu_data.
-	 */
-	if (c != &boot_cpu_data) {
-		/* AND the already accumulated flags with these */
-		for (i = 0 ; i < NCAPINTS ; i++)
-			boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
-	}
-
-#ifdef CONFIG_X86_MCE
-	mcheck_init(c);
-#endif
-	if (c != &boot_cpu_data)
-		mtrr_ap_init();
-#ifdef CONFIG_NUMA
-	numa_add_cpu(smp_processor_id());
-#endif
-}
- 
-
 void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 {
 	if (c->x86_model_id[0])
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
file-capabilities-allow-sigcont-within-session-v2.patch
pnp-increase-the-maximum-number-of-resources-fix.patch
fix-linux-kdh-usage-in-userspace-checkpatch-fixes.patch
revert-keyspan-init-termios-properly.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-add-reboot-mechanism.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
agk-dm-dm-ioctl-move-compat-code-fix.patch
revert-gregkh-driver-drm-convert-from-class_device-to-device-in-drivers-char-drm.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
git-drm-oops-fix.patch
intel-agp-enable-i915-recognition.patch
git-dvb.patch
ia64-slim-down-__clear_bit_unlock.patch
git-infiniband.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
git-mips-fixup.patch
git-mmc.patch
git-mtd.patch
git-netdev-all.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
bluetooth-uninlining.patch
git-nfsd.patch
drivers-pci-quirksc-coding-style-cleanup.patch
more-sanity-checks-for-dmar.patch
git-s390.patch
ips-trim-trailing-whitespace.patch
scsi-gdth-kill-unneeded-irq-argument.patch
bidi-support-scsi_data_buffer-broke-qla1280.patch
bidi-support-scsi_data_buffer-broke-lots-of-stuff.patch
libsas-convert-ata-bridge-to-use-new-eh-checkpatch-fixes.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
git-watchdog.patch
git-wireless.patch
git-ipwireless_cs.patch
git-x86.patch
git-x86-fixup.patch
git-cryptodev.patch
git-xtensa.patch
ia64-increase-datapatch-offset.patch
ia64-dont-assume-that-unwcheckpy-is-executable.patch
ia64-export-copy_page-to-modules.patch
isdn-validate-length-of-isdn_net_ioctl_cfgeaz.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
alpha-atomic_add_return-should-return-int.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
kernel-printkc-concerns-about-the-console-handover.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
genericizing-iova-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
remove-__attribute_used__-checkpatch-fixes.patch
read_current_time-cleanups.patch
read_current_time-cleanups-build-fix-fix.patch
sync_sb_inodes-propagate-errors.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
64-bit-i_version-afs-fixes.patch
ext4-add-block-bitmap-validation-fix.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
proc-detect-duplicate-names-on-registration-fix.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
w1-build-fix.patch
