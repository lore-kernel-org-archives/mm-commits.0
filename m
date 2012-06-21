From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch added to -mm tree
Date: Thu, 21 Jun 2012 14:59:07 -0700
Message-ID: <20120621224513.3B8311E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:65119 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759742Ab2FUWpP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 18:45:15 -0400
Received: by vbnl22 with SMTP id l22so133180vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 15:45:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, hpa@zytor.com, tglx@linutronix.de, zheng.z.yan@intel.com


The patch titled
     Subject: arch/x86/kernel/cpu/perf_event_intel_uncore.h: make UNCORE_PMU_HRTIMER_INTERVAL 64-bit
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/x86/kernel/cpu/perf_event_intel_uncore.h: make UNCORE_PMU_HRTIMER_INTERVAL 64-bit

i386 allmodconfig:

arch/x86/kernel/cpu/perf_event_intel_uncore.c: In function 'uncore_pmu_hrtimer':
arch/x86/kernel/cpu/perf_event_intel_uncore.c:728: warning: integer overflow in expression
arch/x86/kernel/cpu/perf_event_intel_uncore.c: In function 'uncore_pmu_start_hrtimer':
arch/x86/kernel/cpu/perf_event_intel_uncore.c:735: warning: integer overflow in expression

Cc: Zheng Yan <zheng.z.yan@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/perf_event_intel_uncore.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/cpu/perf_event_intel_uncore.h~arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit arch/x86/kernel/cpu/perf_event_intel_uncore.h
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h~arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit
+++ a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -7,7 +7,7 @@
 #define UNCORE_PMU_NAME_LEN		32
 #define UNCORE_BOX_HASH_SIZE		8
 
-#define UNCORE_PMU_HRTIMER_INTERVAL	(60 * NSEC_PER_SEC)
+#define UNCORE_PMU_HRTIMER_INTERVAL	(60LL * NSEC_PER_SEC)
 
 #define UNCORE_FIXED_EVENT		0xffff
 #define UNCORE_PMC_IDX_MAX_GENERIC	8
_
Subject: Subject: arch/x86/kernel/cpu/perf_event_intel_uncore.h: make UNCORE_PMU_HRTIMER_INTERVAL 64-bit

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
drivers-gpio-devresc-export-devm_gpio_request_one-to-modules.patch
fs-jbd2-commitc-use-new-kmap_atomic-api.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
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
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch

