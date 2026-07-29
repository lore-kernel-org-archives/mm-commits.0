Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD281392C34
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298482; cv=none; b=MT9afFwdWXlkieKIbZjAzGBYZu2ZGgJy2SuaEiHiMWMvB0i3qrPY+9aAlb9U5EXVyW4h42/mWGaIa7zmFVlcjzO/dSncx31LMe2Scd23P1lsqrBGltFH2wkXnzr7q6XltIBeKn5GTSyIRyJj+du32QKB8l2jSGKw/IfHaiO6kEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298482; c=relaxed/simple;
	bh=upSwjptCKRdiuLYc9Q6NFlJPuNeVcLaqyVgmMK/cAkQ=;
	h=Date:To:From:Subject:Message-Id; b=iVjEozy0j6YgM1VA1lMaBsPWslzMmc89dirvvpNIgZ1dQL/9cDzx9ipZ4YNjCn/dtBnT8s2XVHNl/lbMluq7pvP3Sh/or/UlhFOdu19NZElj/WaSkFWLapa421N4ebhS+AqYkXtbkWp6riOWMU2z/pUEi9eVQLCoEw10Ka5+0Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0C2AFEH2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0C2AFEH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA851F000E9;
	Wed, 29 Jul 2026 04:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298480;
	bh=hNjGmQMAnB8PxjF7491Cw+L8mWyHdtKWNdMoEm5zMtg=;
	h=Date:To:From:Subject;
	b=0C2AFEH2EhO/xJU1NvYgAZrjs1PRDMydxGLShhoBsoqNaXmDLRc5fzfnYQtM7KRaD
	 XgOreXfAiIKDJfhNV9sTqb3q0p7PXwYA2fivruDkSMoGXlzHeo9171CFC8HT0FewNT
	 I+Pv/qTWN/DQ2nPboaDiRUU8FU2dQMxL+nSQu4zk=
Date: Tue, 28 Jul 2026 21:14:40 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,osalvador@kernel.org,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,fvdl@google.com,david@kernel.org,aneesh.kumar@linux.ibm.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_init-fold-__init_page_from_nid-into-__init_deferred_page.patch removed from -mm tree
Message-Id: <20260729041440.9EA851F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: fold __init_page_from_nid() into __init_deferred_page()
has been removed from the -mm tree.  Its filename was
     mm-mm_init-fold-__init_page_from_nid-into-__init_deferred_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/mm_init: fold __init_page_from_nid() into __init_deferred_page()
Date: Fri, 12 Jun 2026 11:59:03 +0800

__init_page_from_nid() no longer has external users and is only used
locally in mm/mm_init.c under CONFIG_DEFERRED_STRUCT_PAGE_INIT.

Fold it into its sole caller __init_deferred_page() and remove the
separate helper declaration.

Link: https://lore.kernel.org/20260612035903.2468601-20-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    1 -
 mm/mm_init.c  |   42 ++++++++++++++++--------------------------
 2 files changed, 16 insertions(+), 27 deletions(-)

--- a/mm/internal.h~mm-mm_init-fold-__init_page_from_nid-into-__init_deferred_page
+++ a/mm/internal.h
@@ -1760,7 +1760,6 @@ static inline bool pte_needs_soft_dirty_
 
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid);
-void __meminit __init_page_from_nid(unsigned long pfn, int nid);
 
 /* shrinker related functions */
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
--- a/mm/mm_init.c~mm-mm_init-fold-__init_page_from_nid-into-__init_deferred_page
+++ a/mm/mm_init.c
@@ -688,31 +688,6 @@ static __meminit void pageblock_migratet
 }
 #endif
 
-/*
- * Initialize a reserved page unconditionally, finding its zone first.
- */
-void __meminit __init_page_from_nid(unsigned long pfn, int nid)
-{
-	pg_data_t *pgdat;
-	int zid;
-
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
-	if (pageblock_aligned(pfn)) {
-		enum migratetype mt =
-			kho_scratch_migratetype(pfn, MIGRATE_MOVABLE);
-		init_pageblock_migratetype(pfn_to_page(pfn), mt, false);
-	}
-}
-
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat)
 {
@@ -771,10 +746,25 @@ defer_init(int nid, unsigned long pfn, u
 
 static void __meminit __init_deferred_page(unsigned long pfn, int nid)
 {
+	pg_data_t *pgdat = NODE_DATA(nid);
+	int zid;
+
 	if (early_page_initialised(pfn, nid))
 		return;
 
-	__init_page_from_nid(pfn, nid);
+	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
+		struct zone *zone = &pgdat->node_zones[zid];
+
+		if (zone_spans_pfn(zone, pfn))
+			break;
+	}
+	__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
+
+	if (pageblock_aligned(pfn)) {
+		enum migratetype mt =
+			kho_scratch_migratetype(pfn, MIGRATE_MOVABLE);
+		init_pageblock_migratetype(pfn_to_page(pfn), mt, false);
+	}
 }
 #else
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat) {}
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

selftests-mm-remove-obsolete-hugetlb-vmemmap-test.patch

