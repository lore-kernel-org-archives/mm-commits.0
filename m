From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-cpu-mcheck-mce_amd_64c-avoid-using-work_on_cpu.patch added to -mm tree
Date: Tue, 03 Feb 2009 02:58:20 -0800
Message-ID: <200902031058.n13AwKIC016640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751982AbZBCK6t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 05:58:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de


The patch titled
     arch/x86/kernel/cpu/mcheck/mce_amd_64.c: avoid using work_on_cpu()
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-cpu-mcheck-mce_amd_64c-avoid-using-work_on_cpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |   47 ++++++++++++++--------
 1 file changed, 31 insertions(+), 16 deletions(-)

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
 
@@ -386,6 +395,13 @@ static struct kobj_type threshold_ktype 
 	.default_attrs = default_attrs,
 };
 
+struct rdmsr_safe_on_cpu_cross_cpu {
+	unsigned msr;
+	u32 *low;
+	u32 *high;
+	int retval;
+};
+
 static __cpuinit int allocate_threshold_blocks(unsigned int cpu,
 					       unsigned int bank,
 					       unsigned int block,
@@ -398,7 +414,7 @@ static __cpuinit int allocate_threshold_
 	if ((bank >= NR_BANKS) || (block >= NR_BLOCKS))
 		return 0;
 
-	if (rdmsr_safe(address, &low, &high))
+	if (rdmsr_safe_on_cpu(cpu, address, &low, &high))
 		return 0;
 
 	if (!(high & MASK_VALID_HI)) {
@@ -462,12 +478,11 @@ out_free:
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
@@ -530,7 +545,7 @@ static __cpuinit int threshold_create_ba
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
 
-	err = work_on_cpu(cpu, local_allocate_threshold_blocks, &bank);
+	err = local_allocate_threshold_blocks(cpu, bank);
 	if (err)
 		goto out_free;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kernel-asyncc-fix-printk-warnings.patch
revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
hp-wmi-fix-error-path-in-hp_wmi_bios_setup.patch
wait-prevent-exclusive-waiter-starvation-checkpatch-fixes.patch
i-need-old-gcc.patch
linux-next.patch
next-remove-localversion.patch
kvm-unbork.patch
fix-sparseirq-use-kstat_irqs_cpu-on-non-x86-architectures-too.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
kernel-auditscc-fix-warning.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix.patch
early-platform-driver-v3-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage-checkpatch-fixes.patch
mtd-rbtx4939-add-mtd-support-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-ata-sata_silc-needs-dmih.patch
net-dont-use-in_atomic-in-gfp_any.patch
documentation-connector-cn_testc-dont-use-gfp_any.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
mm-unify-some-pmd_-functions-fix-s390.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
do_pipe-drop-its-last-user-in-arch-alpha-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-mcheck-mce_amd_64c-avoid-using-work_on_cpu.patch
work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
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
w1-build-fix.patch

