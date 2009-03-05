From: akpm@linux-foundation.org
Subject: [merged] arch-x86-kernel-cpu-mcheck-mce_amd_64c-avoid-using-work_on_cpu.patch removed from -mm tree
Date: Thu, 05 Mar 2009 11:56:23 -0800
Message-ID: <200903051956.n25JuNxc027250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754862AbZCET4q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 14:56:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     arch/x86/kernel/cpu/mcheck/mce_amd_64.c: avoid using work_on_cpu()
has been removed from the -mm tree.  Its filename was
     arch-x86-kernel-cpu-mcheck-mce_amd_64c-avoid-using-work_on_cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/kernel/cpu/mcheck/mce_amd_64.c: avoid using work_on_cpu()
From: Andrew Morton <akpm@linux-foundation.org>

Atttempting to rid us of the problematic work_on_cpu().  Just use
smp_call_fuction_single() here.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |   40 +++++++++++++---------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff -puN arch/x86/kernel/cpu/mcheck/mce_amd_64.c~arch-x86-kernel-cpu-mcheck-mce_amd_64c-avoid-using-work_on_cpu arch/x86/kernel/cpu/mcheck/mce_amd_64.c
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c~arch-x86-kernel-cpu-mcheck-mce_amd_64c-avoid-using-work_on_cpu
+++ a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -90,7 +90,8 @@ struct thresh_restart {
 };
 
 /* must be called with correct cpu affinity */
-static long threshold_restart_bank(void *_tr)
+/* Called via smp_call_function_single() */
+static void threshold_restart_bank(void *_tr)
 {
 	struct thresh_restart *tr = _tr;
 	u32 mci_misc_hi, mci_misc_lo;
@@ -117,7 +118,6 @@ static long threshold_restart_bank(void 
 
 	mci_misc_hi |= MASK_COUNT_EN_HI;
 	wrmsr(tr->b->address, mci_misc_lo, mci_misc_hi);
-	return 0;
 }
 
 /* cpu init entry point, called from mce.c with preempt off */
@@ -283,7 +283,7 @@ static ssize_t store_interrupt_enable(st
 	tr.b = b;
 	tr.reset = 0;
 	tr.old_limit = 0;
-	work_on_cpu(b->cpu, threshold_restart_bank, &tr);
+	smp_call_function_single(b->cpu, threshold_restart_bank, &tr, 1);
 
 	return end - buf;
 }
@@ -305,23 +305,32 @@ static ssize_t store_threshold_limit(str
 	tr.b = b;
 	tr.reset = 0;
 
-	work_on_cpu(b->cpu, threshold_restart_bank, &tr);
+	smp_call_function_single(b->cpu, threshold_restart_bank, &tr, 1);
 
 	return end - buf;
 }
 
-static long local_error_count(void *_b)
+struct threshold_block_cross_cpu {
+	struct threshold_block *tb;
+	long retval;
+};
+
+static void local_error_count_handler(void *_tbcc)
 {
-	struct threshold_block *b = _b;
+	struct threshold_block_cross_cpu *tbcc = _tbcc;
+	struct threshold_block *b = tbcc->tb;
 	u32 low, high;
 
 	rdmsr(b->address, low, high);
-	return (high & 0xFFF) - (THRESHOLD_MAX - b->threshold_limit);
+	tbcc->retval = (high & 0xFFF) - (THRESHOLD_MAX - b->threshold_limit);
 }
 
 static ssize_t show_error_count(struct threshold_block *b, char *buf)
 {
-	return sprintf(buf, "%lx\n", work_on_cpu(b->cpu, local_error_count, b));
+	struct threshold_block_cross_cpu tbcc = { .tb = b, };
+
+	smp_call_function_single(b->cpu, local_error_count_handler, &tbcc, 1);
+	return sprintf(buf, "%lx\n", tbcc.retval);
 }
 
 static ssize_t store_error_count(struct threshold_block *b,
@@ -329,7 +338,7 @@ static ssize_t store_error_count(struct 
 {
 	struct thresh_restart tr = { .b = b, .reset = 1, .old_limit = 0 };
 
-	work_on_cpu(b->cpu, threshold_restart_bank, &tr);
+	smp_call_function_single(b->cpu, threshold_restart_bank, &tr, 1);
 	return 1;
 }
 
@@ -398,7 +407,7 @@ static __cpuinit int allocate_threshold_
 	if ((bank >= NR_BANKS) || (block >= NR_BLOCKS))
 		return 0;
 
-	if (rdmsr_safe(address, &low, &high))
+	if (rdmsr_safe_on_cpu(cpu, address, &low, &high))
 		return 0;
 
 	if (!(high & MASK_VALID_HI)) {
@@ -462,12 +471,11 @@ out_free:
 	return err;
 }
 
-static __cpuinit long local_allocate_threshold_blocks(void *_bank)
+static __cpuinit long
+local_allocate_threshold_blocks(int cpu, unsigned int bank)
 {
-	unsigned int *bank = _bank;
-
-	return allocate_threshold_blocks(smp_processor_id(), *bank, 0,
-					 MSR_IA32_MC0_MISC + *bank * 4);
+	return allocate_threshold_blocks(cpu, bank, 0,
+					 MSR_IA32_MC0_MISC + bank * 4);
 }
 
 /* symlinks sibling shared banks to first core.  first core owns dir/files. */
@@ -530,7 +538,7 @@ static __cpuinit int threshold_create_ba
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
 
-	err = work_on_cpu(cpu, local_allocate_threshold_blocks, &bank);
+	err = local_allocate_threshold_blocks(cpu, bank);
 	if (err)
 		goto out_free;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
git-acpi-vs-git-cpufreq.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
arch-x86-mm-iomap_32c-fix-warning.patch
kernel-auditscc-fix-warning.patch
early-platform-driver-v3.patch
sysfs-dont-block-indefinitely-for-unmapped-files.patch
drivers-gpu-drm-drm_infoc-fix-warnings.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
leds-add-bd2802gu-led-driver.patch
mmc-add-extended-csd-register-to-debugfs.patch
mtd-rbtx4939-add-mtd-support.patch
mtd-flex-onenand-support-fix.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2-checkpatch-fixes.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
vfs-simple_set_mnt-should-return-void.patch
libfs-make-simple_read_from_buffer-conventional-fix.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
mtd_dataflash-fix-probing-of-at45db321c-chips-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
ia64-fix-pci-dma-flag-propagation-on-sn-altix-with-pics.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
do_pipe-drop-its-last-user-in-arch-alpha-checkpatch-fixes.patch
alpha-convert-u64-to-unsigned-long-long-fix.patch
alpha-convert-u64-to-unsigned-long-long-fix-2.patch
alpha-convert-u64-to-unsigned-long-long-fix-3-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
ubd-stop-defintining-major_nr-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
flat-fix-data-sections-alignment-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
rtc-v3020-add-ability-to-access-v3020-chip-with-gpios-fix.patch
rtc-test-before-subtraction-on-unsigned-fix.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
cirrusfb-convert-printks-to-dev_foo-fix.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
cirrusfb-fix-clock-doubling-fix.patch
fbdev-uninline-lock_fb_info.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-checkpatch-fixes.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-simplification.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix-checkpatch-fixes.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes-cleanup.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
nilfs2-segment-buffer-fix.patch
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
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

