From: akpm@linux-foundation.org
Subject: + resource-make-sure-requested-range-intersects-root-range-fix.patch added to -mm tree
Date: Tue, 10 Jul 2012 14:34:12 -0700
Message-ID: <20120710213413.6EB8220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:50925 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab2GJVeP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jul 2012 17:34:15 -0400
Received: by eaao13 with SMTP id o13so21090eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jul 2012 14:34:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jbarnes@virtuousgeek.org, linuxram@us.ibm.com, octavian.purdila@intel.com


The patch titled
     Subject: resource-make-sure-requested-range-intersects-root-range-fix
has been added to the -mm tree.  Its filename is
     resource-make-sure-requested-range-intersects-root-range-fix.patch

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
Subject: resource-make-sure-requested-range-intersects-root-range-fix

add a dump_stack()

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Octavian Purdila <octavian.purdila@intel.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/resource.c~resource-make-sure-requested-range-intersects-root-range-fix kernel/resource.c
--- a/kernel/resource.c~resource-make-sure-requested-range-intersects-root-range-fix
+++ a/kernel/resource.c
@@ -792,13 +792,15 @@ void __init reserve_region_with_split(st
 		const char *name)
 {
 	write_lock(&resource_lock);
-	if (start > root->end || end < root->start)
+	if (start > root->end || end < root->start) {
 		pr_err("Requested range (0x%llx-0x%llx) not in root range (0x%llx-0x%llx)\n",
 		       (unsigned long long)start, (unsigned long long)end,
 		       (unsigned long long)root->start,
 		       (unsigned long long)root->end);
-	else
+		dump_stack();
+	} else {
 		__reserve_region_with_split(root, start, end, name);
+	}
 	write_unlock(&resource_lock);
 }
 
_
Subject: Subject: resource-make-sure-requested-range-intersects-root-range-fix

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
include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures-fix.patch
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

