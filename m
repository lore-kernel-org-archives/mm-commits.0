Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8360A1D63EE
	for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 23:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738193161; cv=none; b=HAUQhmDG2BWRFyhDSgI8aLXPuSkQQsuSw6tGIymDikC0WgiN4R8/n76LPRjj2LUj0VbmwV8uBHxhsR9ffMsVtoBGvwMjdT+6fcO3qS61MFnCnEj8amBLHjeFkr9f7aqr25iAbyvs9Lx4l6NYusPmLb2RvDCFo51tqetWz2+0yXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738193161; c=relaxed/simple;
	bh=8Bf8yWfK/MAgdeNmabeOm0S2mJ4AQELrXZ9QoMa4XuM=;
	h=Date:To:From:Subject:Message-Id; b=Myl89dq+o1UHqyWQPJDQ2yNv+MkpeAZJg9V1xQ8G6cxqu4aPmxqy67/9B4lp3wisJQ/dZI2cLlh5X8vrXYuWbh+R9JELfHyv+7f2BMKWiBflGL7FwiGwxHtOA2KOuRbPrp+cq9gA9suvwY8MiGGzW7SN2Gfa6Y2wbwLZztzcygg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=axzN27Dt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="axzN27Dt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45546C4CED1;
	Wed, 29 Jan 2025 23:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738193161;
	bh=8Bf8yWfK/MAgdeNmabeOm0S2mJ4AQELrXZ9QoMa4XuM=;
	h=Date:To:From:Subject:From;
	b=axzN27DtTYrdOpfmYzWGJt+zZL6RdqRxFATG5XvgC/gDt7WwLS+yf84UbeFsumygg
	 UNxMe5OwANY8OTUiVPhxrrKJreIoYaQDFNdPetEOdEtPDOA+O2Bsd9sSGdl6AfsNA2
	 4Aj0bRQgDAAz3btMfsyempEh1C6/y/ZFOzM73rO8=
Date: Wed, 29 Jan 2025 15:26:00 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yaozhenguo1@gmail.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-set-migratetype-for-bootmem-folios.patch added to mm-unstable branch
Message-Id: <20250129232601.45546C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: set migratetype for bootmem folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-set-migratetype-for-bootmem-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-set-migratetype-for-bootmem-folios.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/hugetlb: set migratetype for bootmem folios
Date: Wed, 29 Jan 2025 22:41:41 +0000

The pageblocks that back memblock allocated hugetlb folios might not have
the migrate type set, in the CONFIG_DEFERRED_STRUCT_PAGE_INIT case.

memblock allocated hugetlb folios might be given to the buddy allocator
eventually (if nr_hugepages is lowered), so make sure that the migrate
type for the pageblocks contained in them is set when initializing them. 
Set it to the default that memmap init also uses (MIGRATE_MOVABLE).

Link: https://lkml.kernel.org/r/20250129224157.2046079-13-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-set-migratetype-for-bootmem-folios
+++ a/mm/hugetlb.c
@@ -36,6 +36,7 @@
 #include <linux/memory.h>
 #include <linux/mm_inline.h>
 #include <linux/padata.h>
+#include <linux/page-isolation.h>
 
 #include <asm/page.h>
 #include <asm/pgalloc.h>
@@ -3258,6 +3259,26 @@ static void __init hugetlb_folio_init_vm
 	prep_compound_head((struct page *)folio, huge_page_order(h));
 }
 
+/*
+ * memblock-allocated pageblocks might not have the migrate type set
+ * if marked with the 'noinit' flag. Set it to the default (MIGRATE_MOVABLE)
+ * here.
+ *
+ * Note that this will not write the page struct, it is ok (and necessary)
+ * to do this on vmemmap optimized folios.
+ */
+static void __init hugetlb_bootmem_init_migratetype(struct folio *folio,
+							  struct hstate *h)
+{
+	unsigned long nr_pages = pages_per_huge_page(h), i;
+
+	WARN_ON_ONCE(!pageblock_aligned(folio_pfn(folio)));
+
+	for (i = 0; i < nr_pages; i += pageblock_nr_pages)
+		set_pageblock_migratetype(folio_page(folio, i),
+					  MIGRATE_MOVABLE);
+}
+
 static void __init prep_and_add_bootmem_folios(struct hstate *h,
 					struct list_head *folio_list)
 {
@@ -3279,6 +3300,7 @@ static void __init prep_and_add_bootmem_
 					HUGETLB_VMEMMAP_RESERVE_PAGES,
 					pages_per_huge_page(h));
 		}
+		hugetlb_bootmem_init_migratetype(folio, h);
 		/* Subdivide locks to achieve better parallel performance */
 		spin_lock_irqsave(&hugetlb_lock, flags);
 		__prep_account_new_huge_page(h, folio_nid(folio));
_

Patches currently in -mm which might be from fvdl@google.com are

mm-cma-export-total-and-free-number-of-pages-for-cma-areas.patch
mm-cma-support-multiple-contiguous-ranges-if-requested.patch
mm-cma-introduce-cma_intersects-function.patch
mm-hugetlb-use-cma_declare_contiguous_multi.patch
mm-hugetlb-fix-round-robin-bootmem-allocation.patch
mm-hugetlb-remove-redundant-__clearpagereserved.patch
mm-hugetlb-use-online-nodes-for-bootmem-allocation.patch
mm-hugetlb-convert-cmdline-parameters-from-setup-to-early.patch
x86-mm-make-register_page_bootmem_memmap-handle-pte-mappings.patch
mm-bootmem_info-export-register_page_bootmem_memmap.patch
mm-sparse-allow-for-alternate-vmemmap-section-init-at-boot.patch
mm-hugetlb-set-migratetype-for-bootmem-folios.patch
mm-define-__init_reserved_page_zone-function.patch
mm-hugetlb-check-bootmem-pages-for-zone-intersections.patch
mm-sparse-add-vmemmap__hvo-functions.patch
mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-move-huge_boot_pages-list-init-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-add-pre-hvo-framework.patch
mm-hugetlb_vmemmap-fix-hugetlb_vmemmap_restore_folios-definition.patch
mm-hugetlb-do-pre-hvo-for-bootmem-allocated-pages.patch
x86-setup-call-hugetlb_bootmem_alloc-early.patch
x86-mm-set-arch_want_sparsemem_vmemmap_preinit.patch
mm-cma-simplify-zone-intersection-check.patch
mm-cma-introduce-a-cma-validate-function.patch
mm-cma-introduce-interface-for-early-reservations.patch
mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch
mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch
mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file.patch

