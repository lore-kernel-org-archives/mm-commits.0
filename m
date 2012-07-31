From: akpm@linux-foundation.org
Subject: + mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix.patch added to -mm tree
Date: Tue, 31 Jul 2012 14:20:18 -0700
Message-ID: <20120731220722.896435C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:37989 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab2GaWHZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 18:07:25 -0400
Received: by wgbdt11 with SMTP id dt11so296023wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 15:07:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hughd@google.com, mgorman@suse.de, mhocko@suse.cz, stable@vger.kernel.org


The patch titled
     Subject: mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix.patch

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
Subject: mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix

name the args, lazy.  And fix CONFIG_HUGETLBFS=n build

Cc: <stable@vger.kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix
+++ a/include/linux/hugetlb.h
@@ -49,8 +49,9 @@ int follow_hugetlb_page(struct mm_struct
 void unmap_hugepage_range(struct vm_area_struct *,
 			  unsigned long, unsigned long, struct page *);
 void __unmap_hugepage_range_final(struct mmu_gather *tlb,
-			  struct vm_area_struct *,
-			  unsigned long, unsigned long, struct page *);
+			  struct vm_area_struct *vma,
+			  unsigned long start, unsigned long end,
+			  struct page *ref_page);
 void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 				unsigned long start, unsigned long end,
 				struct page *ref_page);
@@ -133,6 +134,13 @@ static inline void copy_huge_page(struct
 
 #define hugetlb_change_protection(vma, address, end, newprot)
 
+static inline void __unmap_hugepage_range_final(struct mmu_gather *tlb,
+			struct vm_area_struct *vma, unsigned long start,
+			unsigned long end, struct page *ref_page)
+{
+	BUG();
+}
+
 static inline void __unmap_hugepage_range(struct mmu_gather *tlb,
 			struct vm_area_struct *vma, unsigned long start,
 			unsigned long end, struct page *ref_page)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix-fix.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper-fix.patch
mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm-slab_commonc-fix-warning.patch
mm.patch
rbtree-performance-and-correctness-test-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

