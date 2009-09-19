From: akpm@linux-foundation.org
Subject: + sched-fix-raciness-in-runqueue_is_locked.patch added to -mm tree
Date: Sat, 19 Sep 2009 11:55:44 -0700
Message-ID: <200909191855.n8JItiko022148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751011AbZISSzu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 19 Sep 2009 14:55:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, rostedt@goodmis.org


The patch titled
     sched(): fix raciness in runqueue_is_locked()
has been added to the -mm tree.  Its filename is
     sched-fix-raciness-in-runqueue_is_locked.patch

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
Subject: sched(): fix raciness in runqueue_is_locked()
From: Andrew Morton <akpm@linux-foundation.org>

runqueue_is_locked() is unavoidably racy due to a poor interface design. 
It does

	cpu = get_cpu()
	ret = some_perpcu_thing(cpu);
	put_cpu(cpu);
	return ret;

Its return value is unreliable.

Fix.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 kernel/sched.c        |   10 ++--------
 kernel/trace/trace.c  |    8 +++++++-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff -puN kernel/trace/trace.c~sched-fix-raciness-in-runqueue_is_locked kernel/trace/trace.c
--- a/kernel/trace/trace.c~sched-fix-raciness-in-runqueue_is_locked
+++ a/kernel/trace/trace.c
@@ -274,12 +274,18 @@ unsigned long trace_flags = TRACE_ITER_P
  */
 void trace_wake_up(void)
 {
+	int cpu;
+
+	if (trace_flags & TRACE_ITER_BLOCK)
+		return;
 	/*
 	 * The runqueue_is_locked() can fail, but this is the best we
 	 * have for now:
 	 */
-	if (!(trace_flags & TRACE_ITER_BLOCK) && !runqueue_is_locked())
+	cpu = get_cpu();
+ 	if (!runqueue_is_locked(cpu))
 		wake_up(&trace_wait);
+	put_cpu();
 }
 
 static int __init set_buf_size(char *str)
diff -puN kernel/sched.c~sched-fix-raciness-in-runqueue_is_locked kernel/sched.c
--- a/kernel/sched.c~sched-fix-raciness-in-runqueue_is_locked
+++ a/kernel/sched.c
@@ -715,15 +715,9 @@ inline void update_rq_clock(struct rq *r
  * This interface allows printk to be called with the runqueue lock
  * held and know whether or not it is OK to wake up the klogd.
  */
-int runqueue_is_locked(void)
+int runqueue_is_locked(int cpu)
 {
-	int cpu = get_cpu();
-	struct rq *rq = cpu_rq(cpu);
-	int ret;
-
-	ret = spin_is_locked(&rq->lock);
-	put_cpu();
-	return ret;
+	return spin_is_locked(&cpu_rq(cpu)->lock);
 }
 
 /*
diff -puN include/linux/sched.h~sched-fix-raciness-in-runqueue_is_locked include/linux/sched.h
--- a/include/linux/sched.h~sched-fix-raciness-in-runqueue_is_locked
+++ a/include/linux/sched.h
@@ -254,7 +254,7 @@ extern asmlinkage void schedule_tail(str
 extern void init_idle(struct task_struct *idle, int cpu);
 extern void init_idle_bootup_task(struct task_struct *idle);
 
-extern int runqueue_is_locked(void);
+extern int runqueue_is_locked(int cpu);
 extern void task_rq_unlock_wait(struct task_struct *p);
 
 extern cpumask_var_t nohz_cpu_mask;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode-fix.patch
drivers-mfd-ab3100-corec-fiw-warning-and-powerpc-build-error.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
hwmon-driver-for-acpi-40-power-meters.patch
drivers-md-dm-log-userspace-basec-fix-warning.patch
drivers-dma-ioat-dma_v3c-fix-warnings.patch
drivers-dma-ioat-dma_v2c-fix-warnings.patch
video-initial-support-for-adv7180.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
checkincludespl-add-option-to-remove-duplicates-in-place.patch
net-fix-config_net=n-build-on-sparc64.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
include-linux-credh-fix-build.patch
serial167-fix-read-buffer-overflow.patch
sched-fix-raciness-in-runqueue_is_locked.patch
st-fix-test-of-value-range-in-st_set_options.patch
drivers-usb-serial-sierrac-fix-config_pm=n-build.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls.patch
vfs-optimize-touch_time-too.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
drivers-net-wireless-ath-ar9170-phyc-fix-uninitialised-variable.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
revert-hugetlb-restore-interleaving-of-bootmem-huge-pages-2631.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
revert-proc-kcore-work-around-a-bug.patch
arches-drop-superfluous-casts-in-nr_free_pages-callers-checkpatch-fixes.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix.patch
page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp-checkpatch-fixes.patch
mm-zero_page-without-pte_special-mips-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-convert-to-use-arch_gettimeoffset-fix.patch
cpuidle-fix-the-menu-governor-to-boost-io-performance.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix.patch
kernel-smpc-relocate-some-code.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support-cleanup.patch
sdio-add-mmc_quirk_lenient_fn0-fix.patch
at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver-checkpatch-fixes.patch
mmc-core-sdio-suspend-resume-support-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
walk-system-ram-range-fix-2.patch
kcore-register-vmemmap-range-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
drivers-video-add-kmalloc-null-tests-fix.patch
drivers-video-tmiofbc-fix-uninitialised-return-value.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch
page-types-add-feature-for-walking-process-address-space-checkpatch-fixes.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

