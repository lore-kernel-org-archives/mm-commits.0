From: akpm@linux-foundation.org
Subject: + include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures-fix-fix-fix.patch added to -mm tree
Date: Fri, 29 Jun 2012 15:42:47 -0700
Message-ID: <20120629232904.CE13B5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:34970 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab2F2X3I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jun 2012 19:29:08 -0400
Received: by eaao13 with SMTP id o13so216342eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 29 Jun 2012 16:29:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures-fix-fix-fix
has been added to the -mm tree.  Its filename is
     include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures-fix-fix-fix.patch

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
Subject: include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures-fix-fix-fix


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |    4 ++--
 fs/select.c             |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/interface.c~include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures-fix-fix-fix drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures-fix-fix-fix
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
diff -puN fs/select.c~include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures-fix-fix-fix fs/select.c
--- a/fs/select.c~include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures-fix-fix-fix
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
_
Subject: Subject: include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures-fix-fix-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
drivers-gpio-devresc-export-devm_gpio_request_one-to-modules.patch
rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures.patch
include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures-fix.patch
include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures-fix-fix.patch
include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures-fix-fix-fix.patch
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
isolate_freepages-check-that-high_pfn-is-aligned-as-expected.patch
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
include-linux-aioh-cpp-c-conversions.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

