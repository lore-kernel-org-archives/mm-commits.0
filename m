Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88CE2576
	for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 00:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739923464; cv=none; b=Mp3qjRGfrM5xIhvbn84vNWXGGwGr31AGYO0Rx72yXSW/Hkh1DYwYa7In4ANdbVVMrlMYa4IgFQ8pHgruh/HN3HDHV3QI4mEYNMotT9WilMYGhGT6+v+jsziMyBCjK8T1/sQbiSDhDOxWO06uX04bqqSkli3d+S/LvTOfhv4tKyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739923464; c=relaxed/simple;
	bh=yYeSzXpk8w+ei1mRMqFuenyu3A6x/DgV7E7bsIOXONc=;
	h=Date:To:From:Subject:Message-Id; b=SImQdkiosN2zK1eUDi6rjjkv4XV8z4FnTFQTkx4z6zVAgUIdx2AsYRpH4AzUsheud2pW5g1i6+uZfUlD91Dx0pPNH1WbobW3wKd+KW+7TZ1MpjTYhy94zfvY0p/4EmmuhXGRrT06RmgNUZ4Nz89QrRSpP55bHoDBjHamW6aL8Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bMXGqE7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bMXGqE7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3704C4CEE2;
	Wed, 19 Feb 2025 00:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739923464;
	bh=yYeSzXpk8w+ei1mRMqFuenyu3A6x/DgV7E7bsIOXONc=;
	h=Date:To:From:Subject:From;
	b=bMXGqE7sIaV4AVcQS+5dAvtM67CZFQFV2fX96b6RW+VkhxnSqrZ1y7yR1pJyAGV+O
	 4CQ62w3dmwh0UEObiU50AAFLyi4oRJ49Uctfc6DcJdc/bCkATNnFi2W/rBVA5coQBk
	 05KnX9FCtwev6MPqVj/vsh9g8jby9+LLd5q2Vzds=
Date: Tue, 18 Feb 2025 16:04:24 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-set-migratetype-for-bootmem-folios.patch added to mm-unstable branch
Message-Id: <20250219000424.A3704C4CEE2@smtp.kernel.org>
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
Date: Tue, 18 Feb 2025 18:16:39 +0000

The pageblocks that back memblock allocated hugetlb folios might not have
the migrate type set, in the CONFIG_DEFERRED_STRUCT_PAGE_INIT case.

memblock allocated hugetlb folios might be given to the buddy allocator
eventually (if nr_hugepages is lowered), so make sure that the migrate
type for the pageblocks contained in them is set when initializing them. 
Set it to the default that memmap init also uses (MIGRATE_MOVABLE).

Link: https://lkml.kernel.org/r/20250218181656.207178-12-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-set-migratetype-for-bootmem-folios
+++ a/mm/hugetlb.c
@@ -3254,6 +3254,26 @@ static void __init hugetlb_folio_init_vm
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
@@ -3275,6 +3295,7 @@ static void __init prep_and_add_bootmem_
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

