Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66E1136347
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 02:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741056544; cv=none; b=dpGGtciLhD5JyASYQF3WFlCOeFm/F9jXhDxM06SPgrZFkWQ+T54GQfWGg2JV6ibqzJ9kJ0ocgw4PWXWLxOHcQFGu3YGeUdISdNYTpqBSInI2WTa1Gg0dySqGsvbZ6O7S6VcPDrGS6aIgAL8Io/YC31ZidIMvaMxPBAQ3FTPxkmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741056544; c=relaxed/simple;
	bh=gpunTNUuJMpDw17pt7lrhNi/1nvDm0WAop6SWAyZFL0=;
	h=Date:To:From:Subject:Message-Id; b=WwdMMcVCnhLH8qy/InpOkuTTiqASbz4jWYHD1Weu0umvVMTdSw0Y5EpbN633uylMAr/0TaApiH3PhV/3cMQ+tkJgAlMXVwCf7FCjVg2OnQfgles9bzlcZK3ByRJ3R0YAOUlvSmez+Ma3+/iGmNaS9NKdljysQhdjV+/4uXOyKv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qbWBH9jb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qbWBH9jb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32381C4CEE4;
	Tue,  4 Mar 2025 02:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741056544;
	bh=gpunTNUuJMpDw17pt7lrhNi/1nvDm0WAop6SWAyZFL0=;
	h=Date:To:From:Subject:From;
	b=qbWBH9jbGRxUlOfPEandxDLJypoQc1hb4mB53gL2dDff0PmQq7nMZTJeZ9JY9fnnB
	 YUTjsQeAH5osAv87udbg8yylXHFhIxuTWT5QwsJ96+1ZDaFl6iW5SzooJQXU0eMdgJ
	 HtO/AjC7yTnIuzs5KFqrVvlCdwUH2vwLzEU1CFSE=
Date: Mon, 03 Mar 2025 18:49:03 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-set-migratetype-for-bootmem-folios.patch added to mm-unstable branch
Message-Id: <20250304024904.32381C4CEE4@smtp.kernel.org>
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
Date: Fri, 28 Feb 2025 18:29:12 +0000

The pageblocks that back memblock allocated hugetlb folios might not have
the migrate type set, in the CONFIG_DEFERRED_STRUCT_PAGE_INIT case.

memblock allocated hugetlb folios might be given to the buddy allocator
eventually (if nr_hugepages is lowered), so make sure that the migrate
type for the pageblocks contained in them is set when initializing them. 
Set it to the default that memmap init also uses (MIGRATE_MOVABLE).

Link: https://lkml.kernel.org/r/20250228182928.2645936-12-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-set-migratetype-for-bootmem-folios
+++ a/mm/hugetlb.c
@@ -3262,6 +3262,26 @@ static void __init hugetlb_folio_init_vm
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
@@ -3283,6 +3303,7 @@ static void __init prep_and_add_bootmem_
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
x86-mm-set-arch_want_hugetlb_vmemmap_preinit.patch
mm-cma-simplify-zone-intersection-check.patch
mm-cma-introduce-a-cma-validate-function.patch
mm-cma-introduce-interface-for-early-reservations.patch
mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch
mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch
mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file.patch

