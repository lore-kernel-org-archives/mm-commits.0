From: akpm@linux-foundation.org
Subject: [withdrawn]
 mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch removed from -mm
 tree
Date: Tue, 07 Nov 2017 11:59:16 -0800
Message-ID: <5a021094.FAGHw8Shk0/nABUg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54660 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754350AbdKGT7R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Nov 2017 14:59:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, 00moses.alexander00@gmail.com, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: remove hugepages_treat_as_movable sysctl
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, hugetlb: remove hugepages_treat_as_movable sysctl

hugepages_treat_as_movable has been introduced by 396faf0303d2 ("Allow
huge page allocations to use GFP_HIGH_MOVABLE") to allow hugetlb
allocations from ZONE_MOVABLE even when hugetlb pages were not
migrateable.  The purpose of the movable zone was different at the time. 
It aimed at reducing memory fragmentation and hugetlb pages being long
lived and large werre not contributing to the fragmentation so it was
acceptable to use the zone back then.

Things have changed though and the primary purpose of the zone became
migratability guarantee.  If we allow non migrateable hugetlb pages to be
in ZONE_MOVABLE memory hotplug might fail to offline the memory.

Remove the knob and only rely on hugepage_migration_supported to allow
movable zones.

Mel said:

: Primarily it was aimed at allowing the hugetlb pool to safely shrink with
: the ability to grow it again.  The use case was for batched jobs, some of
: which needed huge pages and others that did not but didn't want the memory
: useless pinned in the huge pages pool.
: 
: I suspect that more users rely on THP than hugetlbfs for flexible use of
: huge pages with fallback options so I think that removing the option
: should be ok.

Link: http://lkml.kernel.org/r/20171003072619.8654-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Alexandru Moise <00moses.alexander00@gmail.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Alexandru Moise <00moses.alexander00@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   25 -------------------------
 include/linux/hugetlb.h     |    1 -
 kernel/sysctl.c             |    7 -------
 mm/hugetlb.c                |    4 +---
 4 files changed, 1 insertion(+), 36 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-hugetlb-drop-hugepages_treat_as_movable-sysctl Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-hugetlb-drop-hugepages_treat_as_movable-sysctl
+++ a/Documentation/sysctl/vm.txt
@@ -30,7 +30,6 @@ Currently, these files are in /proc/sys/
 - dirty_writeback_centisecs
 - drop_caches
 - extfrag_threshold
-- hugepages_treat_as_movable
 - hugetlb_shm_group
 - laptop_mode
 - legacy_va_layout
@@ -267,30 +266,6 @@ any throttling.
 
 ==============================================================
 
-hugepages_treat_as_movable
-
-This parameter controls whether we can allocate hugepages from ZONE_MOVABLE
-or not. If set to non-zero, hugepages can be allocated from ZONE_MOVABLE.
-ZONE_MOVABLE is created when kernel boot parameter kernelcore= is specified,
-so this parameter has no effect if used without kernelcore=.
-
-Hugepage migration is now available in some situations which depend on the
-architecture and/or the hugepage size. If a hugepage supports migration,
-allocation from ZONE_MOVABLE is always enabled for the hugepage regardless
-of the value of this parameter.
-IOW, this parameter affects only non-migratable hugepages.
-
-Assuming that hugepages are not migratable in your system, one usecase of
-this parameter is that users can make hugepage pool more extensible by
-enabling the allocation from ZONE_MOVABLE. This is because on ZONE_MOVABLE
-page reclaim/migration/compaction work more and you can get contiguous
-memory more likely. Note that using ZONE_MOVABLE for non-migratable
-hugepages can do harm to other features like memory hotremove (because
-memory hotremove expects that memory blocks on ZONE_MOVABLE are always
-removable,) so it's a trade-off responsible for the users.
-
-==============================================================
-
 hugetlb_shm_group
 
 hugetlb_shm_group contains group id that is allowed to create SysV
diff -puN include/linux/hugetlb.h~mm-hugetlb-drop-hugepages_treat_as_movable-sysctl include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-drop-hugepages_treat_as_movable-sysctl
+++ a/include/linux/hugetlb.h
@@ -129,7 +129,6 @@ u32 hugetlb_fault_mutex_hash(struct hsta
 
 pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud);
 
-extern int hugepages_treat_as_movable;
 extern int sysctl_hugetlb_shm_group;
 extern struct list_head huge_boot_pages;
 
diff -puN kernel/sysctl.c~mm-hugetlb-drop-hugepages_treat_as_movable-sysctl kernel/sysctl.c
--- a/kernel/sysctl.c~mm-hugetlb-drop-hugepages_treat_as_movable-sysctl
+++ a/kernel/sysctl.c
@@ -1379,13 +1379,6 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	 },
-	 {
-		.procname	= "hugepages_treat_as_movable",
-		.data		= &hugepages_treat_as_movable,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
 	{
 		.procname	= "nr_overcommit_hugepages",
 		.data		= NULL,
diff -puN mm/hugetlb.c~mm-hugetlb-drop-hugepages_treat_as_movable-sysctl mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-drop-hugepages_treat_as_movable-sysctl
+++ a/mm/hugetlb.c
@@ -36,8 +36,6 @@
 #include <linux/userfaultfd_k.h>
 #include "internal.h"
 
-int hugepages_treat_as_movable;
-
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
@@ -926,7 +924,7 @@ retry_cpuset:
 /* Movability of hugepages depends on migration support. */
 static inline gfp_t htlb_alloc_mask(struct hstate *h)
 {
-	if (hugepages_treat_as_movable || hugepage_migration_supported(h))
+	if (hugepage_migration_supported(h))
 		return GFP_HIGHUSER_MOVABLE;
 	else
 		return GFP_HIGHUSER;
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages.patch
mm-distinguish-cma-and-movable-isolation-in-has_unmovable_pages.patch
mm-page_alloc-fail-has_unmovable_pages-when-seeing-reserved-pages.patch
mm-memory_hotplug-do-not-fail-offlining-too-early.patch
mm-memory_hotplug-remove-timeout-from-__offline_memory.patch
mm-arch-remove-empty_bad_page.patch
mm-sparse-do-not-swamp-log-with-huge-vmemmap-allocation-failures.patch
mm-do-not-rely-on-preempt_count-in-print_vma_addr-was-re-mm-use-in_atomic-in-print_vma_addr.patch
fs-elf-drop-map_fixed-usage-from-elf_map.patch

