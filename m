From: akpm@linux-foundation.org
Subject: + git-x86-fix-rejects.patch added to -mm tree
Date: Sun, 24 Feb 2008 16:42:45 -0800
Message-ID: <200802250042.m1P0gjB5006015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752117AbYBYAnw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:43:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, avi@qumranet.com, lenb@kernel.org, mingo@elte.hu


The patch titled
     git-x86-fix-rejects
has been added to the -mm tree.  Its filename is
     git-x86-fix-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-x86-fix-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Three trees are independently patching this file.  In this case git-acpi is
causing git-x86 to throw a trivial reject.

Cc: Len Brown <lenb@kernel.org>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup_64.c |  120 -----------------------------------
 1 file changed, 120 deletions(-)

diff -puN arch/x86/kernel/setup_64.c~git-x86-fix-rejects arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~git-x86-fix-rejects
+++ a/arch/x86/kernel/setup_64.c
@@ -1286,126 +1286,6 @@ static __init int setup_disablecpuid(cha
 }
 __setup("clearcpuid=", setup_disablecpuid);
 
-/*
- *	Get CPU information for use by the procfs.
- */
-
-static int show_cpuinfo(struct seq_file *m, void *v)
-{
-	struct cpuinfo_x86 *c = v;
-	int cpu = 0, i;
-
-#ifdef CONFIG_SMP
-	cpu = c->cpu_index;
-#endif
-
-	seq_printf(m, "processor\t: %u\n"
-		   "vendor_id\t: %s\n"
-		   "cpu family\t: %d\n"
-		   "model\t\t: %d\n"
-		   "model name\t: %s\n",
-		   (unsigned)cpu,
-		   c->x86_vendor_id[0] ? c->x86_vendor_id : "unknown",
-		   c->x86,
-		   (int)c->x86_model,
-		   c->x86_model_id[0] ? c->x86_model_id : "unknown");
-
-	if (c->x86_mask || c->cpuid_level >= 0)
-		seq_printf(m, "stepping\t: %d\n", c->x86_mask);
-	else
-		seq_printf(m, "stepping\t: unknown\n");
-
-	if (cpu_has(c, X86_FEATURE_TSC)) {
-		unsigned int freq = cpufreq_quick_get((unsigned)cpu);
-
-		if (!freq)
-			freq = cpu_khz;
-		seq_printf(m, "cpu MHz\t\t: %u.%03u\n",
-			   freq / 1000, (freq % 1000));
-	}
-
-	/* Cache size */
-	if (c->x86_cache_size >= 0)
-		seq_printf(m, "cache size\t: %d KB\n", c->x86_cache_size);
-
-#ifdef CONFIG_SMP
-	if (smp_num_siblings * c->x86_max_cores > 1) {
-		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
-		seq_printf(m, "siblings\t: %d\n",
-			       cpus_weight(per_cpu(cpu_core_map, cpu)));
-		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
-		seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
-	}
-#endif
-
-	seq_printf(m,
-		   "fpu\t\t: yes\n"
-		   "fpu_exception\t: yes\n"
-		   "cpuid level\t: %d\n"
-		   "wp\t\t: yes\n"
-		   "flags\t\t:",
-		   c->cpuid_level);
-
-	for (i = 0; i < 32*NCAPINTS; i++)
-		if (cpu_has(c, i) && x86_cap_flags[i] != NULL)
-			seq_printf(m, " %s", x86_cap_flags[i]);
-
-	seq_printf(m, "\nbogomips\t: %lu.%02lu\n",
-		   c->loops_per_jiffy/(500000/HZ),
-		   (c->loops_per_jiffy/(5000/HZ)) % 100);
-
-	if (c->x86_tlbsize > 0)
-		seq_printf(m, "TLB size\t: %d 4K pages\n", c->x86_tlbsize);
-	seq_printf(m, "clflush size\t: %d\n", c->x86_clflush_size);
-	seq_printf(m, "cache_alignment\t: %d\n", c->x86_cache_alignment);
-
-	seq_printf(m, "address sizes\t: %u bits physical, %u bits virtual\n",
-		   c->x86_phys_bits, c->x86_virt_bits);
-
-	seq_printf(m, "power management:");
-	for (i = 0; i < 32; i++) {
-		if (c->x86_power & (1 << i)) {
-			if (i < ARRAY_SIZE(x86_power_flags) &&
-			    x86_power_flags[i])
-				seq_printf(m, "%s%s",
-					   x86_power_flags[i][0]?" ":"",
-					   x86_power_flags[i]);
-			else
-				seq_printf(m, " [%d]", i);
-		}
-	}
-
-	seq_printf(m, "\n\n");
-
-	return 0;
-}
-
-static void *c_start(struct seq_file *m, loff_t *pos)
-{
-	if (*pos == 0)	/* just in case, cpu 0 is not the first */
-		*pos = first_cpu(cpu_online_map);
-	if ((*pos) < NR_CPUS && cpu_online(*pos))
-		return &cpu_data(*pos);
-	return NULL;
-}
-
-static void *c_next(struct seq_file *m, void *v, loff_t *pos)
-{
-	*pos = next_cpu(*pos, cpu_online_map);
-	return c_start(m, pos);
-}
-
-static void c_stop(struct seq_file *m, void *v)
-{
-}
-
-const struct seq_operations cpuinfo_op = {
-	.start = c_start,
-	.next =	c_next,
-	.stop =	c_stop,
-	.show =	show_cpuinfo,
-};
-
 #ifdef CONFIG_X86_TRAMPOLINE
 /*
  * Currently trivial. Write the real->protected mode
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-fix-git-conflicts.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
git-drm.patch
git-dvb.patch
git-hwmon.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
git-md-accel.patch
git-ubi.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
git-sched.patch
tracing-is-borked-on-powerpc.patch
scsi-aic94xx-cleanups.patch
git-block-git-rejects.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
git-x86.patch
git-x86-fixup.patch
git-x86-fix-rejects.patch
documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
add-rcu_assign_index-if-ever-needed-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
procfs-task-exe-symlink-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
