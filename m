From: akpm@linux-foundation.org
Subject: + revert-acpi-idle-mark_tsc_unstable-at-init-time-not-run-time.patch added to -mm tree
Date: Mon, 11 May 2009 11:44:51 -0700
Message-ID: <200905111844.n4BIipYk026683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751695AbZEKSvW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 14:51:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, elendil@planet.nl, johnstul@us.ibm.com, len.brown@intel.com, lenb@kernel.org, mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de


The patch titled
     revert "ACPI: idle: mark_tsc_unstable() at init-time, not run-time"
has been added to the -mm tree.  Its filename is
     revert-acpi-idle-mark_tsc_unstable-at-init-time-not-run-time.patch

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
Subject: revert "ACPI: idle: mark_tsc_unstable() at init-time, not run-time"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

: commit a71e4917dc0ebbcb5a0ecb7ca3486643c1c9a6e2
: Author:     Len Brown <len.brown@intel.com>
: AuthorDate: Tue Apr 21 00:50:11 2009 -0400
: Commit:     Len Brown <len.brown@intel.com>
: CommitDate: Wed Apr 22 19:22:18 2009 -0400
: 
:     ACPI: idle: mark_tsc_unstable() at init-time, not run-time

Due to the following report, from Frans Pop:

: I'm seeing the same issue with 2.6.30-rc5 (not tested previous RCs on that 
: box) on a system for which TSC has always been usable.
: 
: $ dmesg | grep TSC
: Fast TSC calibration using PIT
: checking TSC synchronization [CPU#0 -> CPU#1]: passed.
: Marking TSC unstable due to TSC halts in idle
: 
: The last line is new with 2.6.30. After reverting a71e4917dc0 the TSC 
: works fine again.
: 
: The system has a Intel D945GCZ mainboard with dual core Pentium D 
: (3.20GHz) processor running x86_64 and Debian Lenny.

Reported-by: Frans Pop <elendil@planet.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN drivers/acpi/processor_idle.c~revert-acpi-idle-mark_tsc_unstable-at-init-time-not-run-time drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~revert-acpi-idle-mark_tsc_unstable-at-init-time-not-run-time
+++ a/drivers/acpi/processor_idle.c
@@ -607,11 +607,6 @@ static int acpi_processor_power_verify(s
 	for (i = 1; i < ACPI_PROCESSOR_MAX_POWER; i++) {
 		struct acpi_processor_cx *cx = &pr->power.states[i];
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
-		/* TSC could halt in idle, so notify users */
-		if (tsc_halts_in_c(cx->type))
-			mark_tsc_unstable("TSC halts in idle");;
-#endif
 		switch (cx->type) {
 		case ACPI_STATE_C1:
 			cx->valid = 1;
@@ -900,6 +895,11 @@ static int acpi_idle_enter_simple(struct
 	kt2 = ktime_get_real();
 	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
 
+#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
+	/* TSC could halt in idle, so notify users */
+	if (tsc_halts_in_c(cx->type))
+		mark_tsc_unstable("TSC halts in idle");;
+#endif
 	sleep_ticks = us_to_pm_timer_ticks(idle_time);
 
 	/* Tell the scheduler how much we idled: */
@@ -1013,6 +1013,11 @@ static int acpi_idle_enter_bm(struct cpu
 	kt2 = ktime_get_real();
 	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
 
+#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
+	/* TSC could halt in idle, so notify users */
+	if (tsc_halts_in_c(ACPI_STATE_C3))
+		mark_tsc_unstable("TSC halts in idle");
+#endif
 	sleep_ticks = us_to_pm_timer_ticks(idle_time);
 	/* Tell the scheduler how much we idled: */
 	sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read-fix.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
alpha-unbreak-percpu-again.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
revert-acpi-idle-mark_tsc_unstable-at-init-time-not-run-time.patch
fs-sysfs-filec-use-create_singlethread_workqueue.patch
leds-of_register_platform_driver-doesnt-exist-on-sparc64.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-madvisec-dont-open-code-is_vm_hugetlb_page.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
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

