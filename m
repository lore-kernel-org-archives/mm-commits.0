From: akpm@linux-foundation.org
Subject: [merged] metag-fix-mm-hugetlbc-build-breakage.patch removed from
 -mm tree
Date: Tue, 25 Jun 2013 12:22:40 -0700
Message-ID: <51c9ee00.v9baVca29VIJhtbX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3FYTWl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 15:22:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, gerald.schaefer@de.ibm.com, james.hogan@imgtec.com

Subject: [merged] metag-fix-mm-hugetlbc-build-breakage.patch removed from -mm tree
To: james.hogan@imgtec.com,gerald.schaefer@de.ibm.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 12:22:40 -0700


The patch titled
     Subject: metag: fix mm/hugetlb.c build breakage
has been removed from the -mm tree.  Its filename was
     metag-fix-mm-hugetlbc-build-breakage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: James Hogan <james.hogan@imgtec.com>
Subject: metag: fix mm/hugetlb.c build breakage

Commit 106c992a5ebef ("mm/hugetlb: add more arch-defined huge_pte
functions") merged in v3.10-rc1.

The above commit added an include of <asm-generic/hugetlb.h> to each
architecture's <asm/hugetlb.h> (except s390).  Unfortunately metag was
missed which resulted in build errors when hugetlbfs is enabled (see
below).  Add the include for metag too to fix the build errors.

mm/hugetlb.c In function 'make_huge_pte':
mm/hugetlb.c +2250 : error: implicit declaration of function 'huge_pte_mkwrite'
mm/hugetlb.c +2250 : error: implicit declaration of function 'huge_pte_mkdirty'
mm/hugetlb.c +2250 : error: implicit declaration of function 'mk_huge_pte'
mm/hugetlb.c +2251 : error: incompatible types in assignment
mm/hugetlb.c +2254 : error: incompatible type for argument 1 of 'huge_pte_wrprotect'
mm/hugetlb.c In function 'set_huge_ptep_writable':
mm/hugetlb.c +2268 : error: incompatible types in assignment
mm/hugetlb.c In function '__unmap_hugepage_range':
mm/hugetlb.c +2383 : error: implicit declaration of function 'huge_pte_clear'
mm/hugetlb.c +2407 : error: implicit declaration of function 'huge_pte_dirty'
mm/hugetlb.c In function 'hugetlb_fault':
mm/hugetlb.c +2860 : error: implicit declaration of function 'huge_pte_write'
mm/hugetlb.c +2895 : error: incompatible types in assignment
mm/hugetlb.c In function 'hugetlb_change_protection':
mm/hugetlb.c +3047 : error: implicit declaration of function 'huge_pte_modify'
mm/hugetlb.c +3047 : error: incompatible type for argument 1 of 'pte_mkhuge'
make[1]: *** [mm/hugetlb.o] Error 1
make: *** [mm/hugetlb.o] Error 2

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/metag/include/asm/hugetlb.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/metag/include/asm/hugetlb.h~metag-fix-mm-hugetlbc-build-breakage arch/metag/include/asm/hugetlb.h
--- a/arch/metag/include/asm/hugetlb.h~metag-fix-mm-hugetlbc-build-breakage
+++ a/arch/metag/include/asm/hugetlb.h
@@ -2,6 +2,7 @@
 #define _ASM_METAG_HUGETLB_H
 
 #include <asm/page.h>
+#include <asm-generic/hugetlb.h>
 
 
 static inline int is_hugepage_only_range(struct mm_struct *mm,
_

Patches currently in -mm which might be from james.hogan@imgtec.com are

linux-next.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
drivers-mtd-chips-gen_probec-refactor-call-to-request_module.patch
mm-arc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-metag-prepare-for-killing-free_all_bootmem_node.patch
mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers.patch

