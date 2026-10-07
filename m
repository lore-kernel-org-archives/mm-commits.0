Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0042D47F4
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334151; cv=none; b=ivNWdZWRg7vnw073SMEwWeILfX6zJBDgmfOc2zAnm2DUuCWmeWDEse7c5J/ecbpQw0jwuAGgUt0fJl5D3l+cNx765RTKQzpWqTBeQMfATu7EhlA6+usIqLOAnDPaHwHgrj4NFsG12Qo336tPdpK2TWZZHRSgTrSzu5lADFVHPYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334151; c=relaxed/simple;
	bh=p7ZhDfJcSMZaXE7Tw6Ky2ELqO+ZE1GKQS/nacOHRfQY=;
	h=Date:To:From:Subject:Message-Id; b=O1XqEqmBAr1pDPUaYj8HZt+w+05QKxsLEB6BNMqb117NQNeGsLYLgMRw9PRuPYOalBZkAM1aCFvQZKSDoWAD3wUPdUyQm9kSgxZR5CiaNc2VkO5JzaaMZb++8lWjJH6oD3Euz3Ob+Xn2K9hScFL6cSgrx1B4G7cLyIrVqJ7X5bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RT+81KWr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RT+81KWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01D71F0089B;
	Wed,  7 Oct 2026 00:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334147;
	bh=bVMk4/YVWqRQq0uYm5FvXQgJrMNX9cbnzuHSlICy/UQ=;
	h=Date:To:From:Subject;
	b=RT+81KWrEBkh5dmlijgf82KWp7hIHH+QlGrFKghoTwp5jiiPgM6XIOv4WE9Rkk3Wi
	 RXbs02eNpcycRNOoeuQqIrcIYbY/RUsXZ/B/UteX8//3JxJIShiTazAHImt3tds0lg
	 g9yJoAg7EX3JWmdtkdRrDERe2bnnD319BDuRtgI0=
Date: Tue, 06 Oct 2026 17:49:07 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david.laight.linux@gmail.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-vmemmap-rename-hvo-order-macros.patch removed from -mm tree
Message-Id: <20261007004907.C01D71F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: rename HVO order macros
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-rename-hvo-order-macros.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse-vmemmap: rename HVO order macros
Date: Thu, 10 Sep 2026 14:32:41 +0800

The macros VMEMMAP_TAIL_MIN_ORDER and NR_VMEMMAP_TAILS describe the order
range where HVO can be applied, but their names tie that range to the
tail-page cache implementation.

Rename them with a VMEMMAP_OPTIMIZATION prefix and use the new names in
the HVO paths.  This makes the code describe the optimization requirements
rather than the tail-page cache implementation detail.

No functional change intended.

Link: https://lore.kernel.org/20260910063256.64386-3-songmuchun@bytedance.com
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

 include/linux/mmzone.h |   17 +++++++++--------
 mm/hugetlb.c           |    4 ++--
 mm/hugetlb_vmemmap.c   |    2 +-
 mm/sparse-vmemmap.c    |    4 ++--
 4 files changed, 14 insertions(+), 13 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-vmemmap-rename-hvo-order-macros
+++ a/include/linux/mmzone.h
@@ -107,13 +107,14 @@
 	 is_power_of_2(sizeof(struct page)) ? \
 	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
 
-/*
- * vmemmap optimization (like HVO) is only possible for page orders that fill
- * two or more pages with struct pages.
- */
-#define VMEMMAP_TAIL_MIN_ORDER (ilog2(2 * PAGE_SIZE / sizeof(struct page)))
-#define __NR_VMEMMAP_TAILS (MAX_FOLIO_ORDER - VMEMMAP_TAIL_MIN_ORDER + 1)
-#define NR_VMEMMAP_TAILS (__NR_VMEMMAP_TAILS > 0 ? __NR_VMEMMAP_TAILS : 0)
+/* The number of struct pages covered by the retained vmemmap pages with HVO enabled. */
+#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	(PAGE_SIZE / sizeof(struct page))
+#define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
+
+#define __VMEMMAP_OPTIMIZATION_NR_ORDERS	\
+	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
+#define VMEMMAP_OPTIMIZATION_NR_ORDERS		\
+	(__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 ? __VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
 
 enum migratetype {
 	MIGRATE_UNMOVABLE,
@@ -1158,7 +1159,7 @@ struct zone {
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-	struct page *vmemmap_tails[NR_VMEMMAP_TAILS];
+	struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
 #endif
 } ____cacheline_internodealigned_in_smp;
 
--- a/mm/hugetlb.c~mm-sparse-vmemmap-rename-hvo-order-macros
+++ a/mm/hugetlb.c
@@ -3357,7 +3357,7 @@ void __init hugetlb_bootmem_struct_page_
 	struct zone *zone;
 
 	for_each_zone(zone) {
-		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
+		for (int i = 0; i < VMEMMAP_OPTIMIZATION_NR_ORDERS; i++) {
 			struct page *tail, *p;
 			unsigned int order;
 
@@ -3365,7 +3365,7 @@ void __init hugetlb_bootmem_struct_page_
 			if (!tail)
 				continue;
 
-			order = i + VMEMMAP_TAIL_MIN_ORDER;
+			order = i + VMEMMAP_OPTIMIZATION_MIN_ORDER;
 			p = page_to_virt(tail);
 			/*
 			 * prep_and_add_bootmem_folios() can access pageblock
--- a/mm/hugetlb_vmemmap.c~mm-sparse-vmemmap-rename-hvo-order-macros
+++ a/mm/hugetlb_vmemmap.c
@@ -494,7 +494,7 @@ static bool vmemmap_should_optimize_foli
 
 static struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
 {
-	const unsigned int idx = order - VMEMMAP_TAIL_MIN_ORDER;
+	const unsigned int idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
 	struct page *tail, *p;
 	int node = zone_to_nid(zone);
 
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-rename-hvo-order-macros
+++ a/mm/sparse-vmemmap.c
@@ -329,12 +329,12 @@ static __meminit struct page *vmemmap_ge
 	unsigned int idx;
 	int node = zone_to_nid(zone);
 
-	if (WARN_ON_ONCE(order < VMEMMAP_TAIL_MIN_ORDER))
+	if (WARN_ON_ONCE(order < VMEMMAP_OPTIMIZATION_MIN_ORDER))
 		return NULL;
 	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
 		return NULL;
 
-	idx = order - VMEMMAP_TAIL_MIN_ORDER;
+	idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
 	tail = zone->vmemmap_tails[idx];
 	if (tail)
 		return tail;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


