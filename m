From: akpm@linux-foundation.org
Subject: +
 mm-migrate-change-migration-reason-mr_cma-as-mr_contig_range.patch added to -mm tree
Date: Thu, 08 Feb 2018 15:23:29 -0800
Message-ID: <5a7cdbf1.KtjBOZS3DcgTK8LK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48498 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752059AbeBHXXa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Feb 2018 18:23:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khandual@linux.vnet.ibm.com, akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: rename migration reason MR_CMA to MR_CONTIG_RANGE
has been added to the -mm tree.  Its filename is
     mm-migrate-change-migration-reason-mr_cma-as-mr_contig_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-change-migration-reason-mr_cma-as-mr_contig_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-change-migration-reason-mr_cma-as-mr_contig_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: mm/migrate: rename migration reason MR_CMA to MR_CONTIG_RANGE

alloc_contig_range() initiates compaction and eventual migration for the
purpose of either CMA or HugeTLB allocations.  At present, the reason code
remains the same MR_CMA for either of these cases.  Let's make it
MR_CONTIG_RANGE which will appropriately reflect the reason code in both
these cases.

Link: http://lkml.kernel.org/r/20180202091518.18798-1-khandual@linux.vnet.ibm.com
Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mmu_context_iommu.c |    2 +-
 include/linux/migrate.h             |    2 +-
 include/trace/events/migrate.h      |    2 +-
 mm/page_alloc.c                     |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/mm/mmu_context_iommu.c~mm-migrate-change-migration-reason-mr_cma-as-mr_contig_range arch/powerpc/mm/mmu_context_iommu.c
--- a/arch/powerpc/mm/mmu_context_iommu.c~mm-migrate-change-migration-reason-mr_cma-as-mr_contig_range
+++ a/arch/powerpc/mm/mmu_context_iommu.c
@@ -112,7 +112,7 @@ static int mm_iommu_move_page_from_cma(s
 	put_page(page); /* Drop the gup reference */
 
 	ret = migrate_pages(&cma_migrate_pages, new_iommu_non_cma_page,
-				NULL, 0, MIGRATE_SYNC, MR_CMA);
+				NULL, 0, MIGRATE_SYNC, MR_CONTIG_RANGE);
 	if (ret) {
 		if (!list_empty(&cma_migrate_pages))
 			putback_movable_pages(&cma_migrate_pages);
diff -puN include/linux/migrate.h~mm-migrate-change-migration-reason-mr_cma-as-mr_contig_range include/linux/migrate.h
--- a/include/linux/migrate.h~mm-migrate-change-migration-reason-mr_cma-as-mr_contig_range
+++ a/include/linux/migrate.h
@@ -25,7 +25,7 @@ enum migrate_reason {
 	MR_SYSCALL,		/* also applies to cpusets */
 	MR_MEMPOLICY_MBIND,
 	MR_NUMA_MISPLACED,
-	MR_CMA,
+	MR_CONTIG_RANGE,
 	MR_TYPES
 };
 
diff -puN include/trace/events/migrate.h~mm-migrate-change-migration-reason-mr_cma-as-mr_contig_range include/trace/events/migrate.h
--- a/include/trace/events/migrate.h~mm-migrate-change-migration-reason-mr_cma-as-mr_contig_range
+++ a/include/trace/events/migrate.h
@@ -20,7 +20,7 @@
 	EM( MR_SYSCALL,		"syscall_or_cpuset")		\
 	EM( MR_MEMPOLICY_MBIND,	"mempolicy_mbind")		\
 	EM( MR_NUMA_MISPLACED,	"numa_misplaced")		\
-	EMe(MR_CMA,		"cma")
+	EMe(MR_CONTIG_RANGE,	"contig_range")
 
 /*
  * First define the enums in the above macros to be exported to userspace
diff -puN mm/page_alloc.c~mm-migrate-change-migration-reason-mr_cma-as-mr_contig_range mm/page_alloc.c
--- a/mm/page_alloc.c~mm-migrate-change-migration-reason-mr_cma-as-mr_contig_range
+++ a/mm/page_alloc.c
@@ -7597,7 +7597,7 @@ static int __alloc_contig_migrate_range(
 		cc->nr_migratepages -= nr_reclaimed;
 
 		ret = migrate_pages(&cc->migratepages, alloc_migrate_target,
-				    NULL, 0, cc->mode, MR_CMA);
+				    NULL, 0, cc->mode, MR_CONTIG_RANGE);
 	}
 	if (ret < 0) {
 		putback_movable_pages(&cc->migratepages);
_

Patches currently in -mm which might be from khandual@linux.vnet.ibm.com are

mm-migrate-change-migration-reason-mr_cma-as-mr_contig_range.patch

