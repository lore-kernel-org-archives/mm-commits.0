Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D8B296BB5
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334156; cv=none; b=A+Z2Dai9Zy5lPmy+QeYlGK6FuUNM/ZORQZUGB1Y77RlfYaqFlvsOxXKNPZ2D5WR672jkGducnwGZle5NSb5RgSbSrClzlWZBo8tDvSXkc263CjxZ/m5+JT5NW732W6UOPni41j30doHNgFzwlZW4Qi703DITdvEpMmLcq0ezUZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334156; c=relaxed/simple;
	bh=v9xY1D4SD1s+36kUKpxoIgtTmiQQCOU0GfEhOV1L5qE=;
	h=Date:To:From:Subject:Message-Id; b=PC2Pn6UWH/6Mb3BVCsor4HOtaKpjaqXxP9uTGyiDrnTPpKRD3S1IwBvZqSMILsBZ/KbQqgYWAP4+54tHcbCgfLRxHnK3xNHEu7xdPWlT29rWhVJ3JbM9FlZtu4gEKHxNXIwkth0GdIusqWR/ZBdKIQxgxb4ulxs9nkBd40ynf/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qZqxlogn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qZqxlogn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10851F0089C;
	Wed,  7 Oct 2026 00:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334155;
	bh=0y6rih0eWPbkVgiDo+PWPXuhghYNUIZiY6MKysZTM/o=;
	h=Date:To:From:Subject;
	b=qZqxlognXMpwkDizdXwpB7pjgxSSX7n1oMtAXpYbo05b0UcIN++IMK19HrOMUMHvx
	 NvzcN2hXZ6hPzWDSw9RunWQIVD7Iwy0BrtV94XnHbdMT5gQs6LMj71XOxR17i1TfSM
	 ku8OrekR59cBIlkNW71lEL4GDaev7YG6nLl5eHsU=
Date: Tue, 06 Oct 2026 17:49:14 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david.laight.linux@gmail.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_init-factor-out-pfn_to_zone.patch removed from -mm tree
Message-Id: <20261007004914.E10851F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: factor out pfn_to_zone()
has been removed from the -mm tree.  Its filename was
     mm-mm_init-factor-out-pfn_to_zone.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/mm_init: factor out pfn_to_zone()
Date: Thu, 10 Sep 2026 14:32:45 +0800

pfn_to_zone() in hugetlb_vmemmap.c duplicates the zone lookup logic in
__init_deferred_page().

Move it to mm_init.c, declare it in mm/mm_init.h, and reuse it from
__init_deferred_page() and HugeTLB early vmemmap initialization instead of
open-coding the zone walk there.

Link: https://lore.kernel.org/20260910063256.64386-7-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/hugetlb_vmemmap.c |   17 ++---------------
 mm/mm_init.c         |   28 ++++++++++++++++++----------
 mm/mm_init.h         |    1 +
 3 files changed, 21 insertions(+), 25 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-mm_init-factor-out-pfn_to_zone
+++ a/mm/hugetlb_vmemmap.c
@@ -19,6 +19,7 @@
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
 #include "internal.h"
+#include "mm_init.h"
 
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
@@ -744,20 +745,6 @@ static bool vmemmap_should_optimize_boot
 	return true;
 }
 
-static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn)
-{
-	struct zone *zone;
-	enum zone_type zone_type;
-
-	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
-		zone = &NODE_DATA(nid)->node_zones[zone_type];
-		if (zone_spans_pfn(zone, pfn))
-			return zone;
-	}
-
-	return NULL;
-}
-
 /*
  * Initialize memmap section for a gigantic page, HVO-style.
  */
@@ -787,7 +774,7 @@ void __init hugetlb_vmemmap_init_early(i
 		map = pfn_to_page(pfn);
 		start = (unsigned long)map;
 		end = start + hugetlb_vmemmap_size(m->hstate);
-		zone = pfn_to_zone(nid, pfn);
+		zone = pfn_to_zone(pfn, nid);
 
 		if (vmemmap_populate_hvo(start, end, huge_page_order(m->hstate),
 					 zone, HUGETLB_VMEMMAP_RESERVE_SIZE))
--- a/mm/mm_init.c~mm-mm_init-factor-out-pfn_to_zone
+++ a/mm/mm_init.c
@@ -692,6 +692,20 @@ static __meminit void pageblock_migratet
 	}
 }
 
+struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
+{
+	pg_data_t *pgdat = NODE_DATA(nid);
+
+	for (enum zone_type zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
+		struct zone *zone = &pgdat->node_zones[zone_type];
+
+		if (zone_spans_pfn(zone, pfn))
+			return zone;
+	}
+
+	return NULL;
+}
+
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat)
 {
@@ -750,20 +764,14 @@ defer_init(int nid, unsigned long pfn, u
 
 static void __meminit __init_deferred_page(unsigned long pfn, int nid)
 {
-	pg_data_t *pgdat = NODE_DATA(nid);
-	int zid;
+	struct zone *zone;
 
 	if (early_page_initialised(pfn, nid))
 		return;
 
-	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
-		struct zone *zone = &pgdat->node_zones[zid];
-
-		if (zone_spans_pfn(zone, pfn))
-			break;
-	}
-	__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
-
+	zone = pfn_to_zone(pfn, nid);
+	__init_single_page(pfn_to_page(pfn), pfn,
+			   zone ? zone_idx(zone) : MAX_NR_ZONES, nid);
 	if (pageblock_aligned(pfn)) {
 		enum migratetype mt =
 			kho_scratch_migratetype(pfn, MIGRATE_MOVABLE);
--- a/mm/mm_init.h~mm-mm_init-factor-out-pfn_to_zone
+++ a/mm/mm_init.h
@@ -39,6 +39,7 @@ void memmap_init_range(unsigned long siz
 		enum meminit_context context,
 		struct vmem_altmap *altmap, int migratetype,
 		bool isolate_pageblock);
+struct zone *pfn_to_zone(unsigned long pfn, int nid);
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 /* Free whole pageblock and set its migration type to MIGRATE_CMA. */
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


