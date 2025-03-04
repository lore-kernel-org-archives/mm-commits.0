Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E845415DBC1
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 02:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741056547; cv=none; b=kWV5r7rod3iTVyvzhHaNPJquMRLP10/S2clNcpAPWzjEcz//M6lP6pGi3Cv1IKLRnYomSv3QYXdQ7MJANXM2CSGR/RK7otevv5L63fURPse4/L8PTstkxecb6ovvq8lMrpjIc55Ij3KR3Zg/Trcmq5M/LcTz8Q0Ko3/ZLVIjdw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741056547; c=relaxed/simple;
	bh=Xfvz5E+Zp8Tr+WQ4pWgcnrX5IoYRlHz2L0vENPcU688=;
	h=Date:To:From:Subject:Message-Id; b=tkUUpB/QOwqFnCtbhQen6PIfM64VTPAey60zqlP7CElkXV/iik44dhcAkKm8ZSOSXotij849xc7k8LB881Npq3m9aQt7QA3DLWET7hSjw+5QPbJ6RLaQ6rHEzjTVqCEHLqfvc6p9MdkXYl3kzV2U4ScdnxZnxzRdmbYmVwYfSTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nUwCZF7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nUwCZF7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B35EC4CEE4;
	Tue,  4 Mar 2025 02:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741056546;
	bh=Xfvz5E+Zp8Tr+WQ4pWgcnrX5IoYRlHz2L0vENPcU688=;
	h=Date:To:From:Subject:From;
	b=nUwCZF7xsvnJh4uJxXnKkQEevyHr7ejt7yGKHXvcQGzEvStiP8CTc8/AZ3ppuBGZc
	 2Mbr15oSVlhsdKE3kOpRkbf2ZHKKF/Bbzvb5UrHPHh60xbtJedzPiw6CJ9JylXC5mB
	 qQMKTWfbyXWTB2fXK5K1dqkdkUHiasEUw78y2xLE=
Date: Mon, 03 Mar 2025 18:49:05 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-define-__init_reserved_page_zone-function.patch added to mm-unstable branch
Message-Id: <20250304024906.5B35EC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: define __init_reserved_page_zone function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-define-__init_reserved_page_zone-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-define-__init_reserved_page_zone-function.patch

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
Subject: mm: define __init_reserved_page_zone function
Date: Fri, 28 Feb 2025 18:29:13 +0000

Sometimes page structs must be unconditionally initialized as reserved,
regardless of DEFERRED_STRUCT_PAGE_INIT.

Define a function, __init_reserved_page_zone, containing code that already
did all of the work in init_reserved_page, and make it available for use.

Link: https://lkml.kernel.org/r/20250228182928.2645936-13-fvdl@google.com
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

 mm/internal.h |    1 +
 mm/mm_init.c  |   38 +++++++++++++++++++++++---------------
 2 files changed, 24 insertions(+), 15 deletions(-)

--- a/mm/internal.h~mm-define-__init_reserved_page_zone-function
+++ a/mm/internal.h
@@ -1447,6 +1447,7 @@ static inline bool pte_needs_soft_dirty_
 
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid);
+void __meminit __init_reserved_page_zone(unsigned long pfn, int nid);
 
 /* shrinker related functions */
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
--- a/mm/mm_init.c~mm-define-__init_reserved_page_zone-function
+++ a/mm/mm_init.c
@@ -650,6 +650,28 @@ static inline void fixup_hashdist(void)
 static inline void fixup_hashdist(void) {}
 #endif /* CONFIG_NUMA */
 
+/*
+ * Initialize a reserved page unconditionally, finding its zone first.
+ */
+void __meminit __init_reserved_page_zone(unsigned long pfn, int nid)
+{
+	pg_data_t *pgdat;
+	int zid;
+
+	pgdat = NODE_DATA(nid);
+
+	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
+		struct zone *zone = &pgdat->node_zones[zid];
+
+		if (zone_spans_pfn(zone, pfn))
+			break;
+	}
+	__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
+
+	if (pageblock_aligned(pfn))
+		set_pageblock_migratetype(pfn_to_page(pfn), MIGRATE_MOVABLE);
+}
+
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat)
 {
@@ -708,24 +730,10 @@ defer_init(int nid, unsigned long pfn, u
 
 static void __meminit init_reserved_page(unsigned long pfn, int nid)
 {
-	pg_data_t *pgdat;
-	int zid;
-
 	if (early_page_initialised(pfn, nid))
 		return;
 
-	pgdat = NODE_DATA(nid);
-
-	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
-		struct zone *zone = &pgdat->node_zones[zid];
-
-		if (zone_spans_pfn(zone, pfn))
-			break;
-	}
-	__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
-
-	if (pageblock_aligned(pfn))
-		set_pageblock_migratetype(pfn_to_page(pfn), MIGRATE_MOVABLE);
+	__init_reserved_page_zone(pfn, nid);
 }
 #else
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat) {}
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

