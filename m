From: akpm@linux-foundation.org
Subject: - include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures.patch removed from -mm tree
Date: Tue, 10 Jul 2012 16:11:59 -0700
Message-ID: <20120710235831.B4FC020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:49912 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab2GJX6e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jul 2012 19:58:34 -0400
Received: by bkcjc3 with SMTP id jc3so24412bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jul 2012 16:58:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu, tglx@tglx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/time.h: make NSEC_PER_SEC 64-bit on 32-bit architectures	
has been removed from the -mm tree.  Its filename was
     include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures.patch

This patch was dropped because it's a PITA

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/time.h: make NSEC_PER_SEC 64-bit on 32-bit architectures	

Nanoseconds are usually represented with 64-bit types (s64 and sometimes
u64).  The 32-bit definition of NSEC_PER_SEC can lead to compile-time and
runtime arithmetic overflows on 32-bit systems.

So switch NSEC_PER_SEC to a 64-bit type using "LL".

And fix various fallouts I noticed.  Usually by casting to long rather than
switching to do_div(): it's probably safe to assume that the number of
nanoseconds per second won't be increasing soon.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@tglx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c   |    4 ++--
 fs/proc/uptime.c          |    4 ++--
 fs/select.c               |    4 ++--
 include/linux/time.h      |    2 +-
 kernel/events/core.c      |    2 +-
 kernel/time/clocksource.c |    2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff -puN include/linux/time.h~include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures include/linux/time.h
--- a/include/linux/time.h~include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures
+++ a/include/linux/time.h
@@ -37,7 +37,7 @@ extern struct timezone sys_tz;
 #define NSEC_PER_USEC	1000L
 #define NSEC_PER_MSEC	1000000L
 #define USEC_PER_SEC	1000000L
-#define NSEC_PER_SEC	1000000000L
+#define NSEC_PER_SEC	1000000000LL
 #define FSEC_PER_SEC	1000000000000000LL
 
 #define TIME_T_MAX	(time_t)((1UL << ((sizeof(time_t) << 3) - 1)) - 1)
diff -puN fs/proc/uptime.c~include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures fs/proc/uptime.c
--- a/fs/proc/uptime.c~include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures
+++ a/fs/proc/uptime.c
@@ -27,9 +27,9 @@ static int uptime_proc_show(struct seq_f
 	idle.tv_nsec = rem;
 	seq_printf(m, "%lu.%02lu %lu.%02lu\n",
 			(unsigned long) uptime.tv_sec,
-			(uptime.tv_nsec / (NSEC_PER_SEC / 100)),
+			(uptime.tv_nsec / ((long)NSEC_PER_SEC / 100)),
 			(unsigned long) idle.tv_sec,
-			(idle.tv_nsec / (NSEC_PER_SEC / 100)));
+			(idle.tv_nsec / ((long)NSEC_PER_SEC / 100)));
 	return 0;
 }
 
diff -puN kernel/events/core.c~include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures kernel/events/core.c
--- a/kernel/events/core.c~include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures
+++ a/kernel/events/core.c
@@ -5415,7 +5415,7 @@ static void perf_swevent_init_hrtimer(st
 	if (event->attr.freq) {
 		long freq = event->attr.sample_freq;
 
-		event->attr.sample_period = NSEC_PER_SEC / freq;
+		event->attr.sample_period = (long)NSEC_PER_SEC / freq;
 		hwc->sample_period = event->attr.sample_period;
 		local64_set(&hwc->period_left, hwc->sample_period);
 		event->attr.freq = 0;
diff -puN drivers/rtc/interface.c~include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures
+++ a/drivers/rtc/interface.c
@@ -564,7 +564,7 @@ enum hrtimer_restart rtc_pie_update_irq(
 	int count;
 	rtc = container_of(timer, struct rtc_device, pie_timer);
 
-	period = ktime_set(0, NSEC_PER_SEC/rtc->irq_freq);
+	period = ktime_set(0, (long)NSEC_PER_SEC / rtc->irq_freq);
 	count = hrtimer_forward_now(timer, period);
 
 	rtc_handle_legacy_irq(rtc, count, RTC_PF);
@@ -671,7 +671,7 @@ static int rtc_update_hrtimer(struct rtc
 		return -1;
 
 	if (enabled) {
-		ktime_t period = ktime_set(0, NSEC_PER_SEC / rtc->irq_freq);
+		ktime_t period = ktime_set(0, (long)NSEC_PER_SEC/rtc->irq_freq);
 
 		hrtimer_start(&rtc->pie_timer, period, HRTIMER_MODE_REL);
 	}
diff -puN fs/select.c~include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures fs/select.c
--- a/fs/select.c~include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures
+++ a/fs/select.c
@@ -55,11 +55,11 @@ static long __estimate_accuracy(struct t
 	if (task_nice(current) > 0)
 		divfactor = divfactor / 5;
 
-	if (tv->tv_sec > MAX_SLACK / (NSEC_PER_SEC/divfactor))
+	if (tv->tv_sec > MAX_SLACK / ((long)NSEC_PER_SEC / divfactor))
 		return MAX_SLACK;
 
 	slack = tv->tv_nsec / divfactor;
-	slack += tv->tv_sec * (NSEC_PER_SEC/divfactor);
+	slack += tv->tv_sec * ((long)NSEC_PER_SEC / divfactor);
 
 	if (slack > MAX_SLACK)
 		return MAX_SLACK;
diff -puN kernel/time/clocksource.c~include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures
+++ a/kernel/time/clocksource.c
@@ -678,7 +678,7 @@ void __clocksource_updatefreq_scale(stru
 		sec = 600;
 
 	clocks_calc_mult_shift(&cs->mult, &cs->shift, freq,
-			       NSEC_PER_SEC / scale, sec * scale);
+			       (long)NSEC_PER_SEC / scale, sec * scale);
 
 	/*
 	 * for clocksources that have large mults, to avoid overflow.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
sysfs-fail-dentry-revalidation-after-namespace-change-fix.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix-fix.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
tmpfs-implement-numa-node-interleaving-fix.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
drivers-gpio-gpio-tps65910c-fix-config_of_gpio=n-build.patch
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
include-linux-aioh-cpp-c-conversions.patch
resource-make-sure-requested-range-intersects-root-range-fix.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

