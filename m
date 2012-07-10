From: akpm@linux-foundation.org
Subject: [folded] include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures-fix.patch removed from -mm tree
Date: Tue, 10 Jul 2012 16:11:25 -0700
Message-ID: <20120710235758.2A7E020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:49695 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab2GJX6A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jul 2012 19:58:00 -0400
Received: by eeil10 with SMTP id l10so7144eei.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jul 2012 16:57:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures-fix
has been removed from the -mm tree.  Its filename was
     include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures-fix.patch

This patch was dropped because it was folded into include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures-fix



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/uptime.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/uptime.c~include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures-fix fs/proc/uptime.c
--- a/fs/proc/uptime.c~include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures-fix
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
include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures.patch
include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures-fix-fix.patch
include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures-fix-fix-fix.patch
include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures-fix-fix-fix-fix.patch
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

