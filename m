Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299AA3B058E
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 04:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787890873; cv=none; b=gKPgTcxGSVe7Q/y4Six2Ly8W5hZKD3q0XfGriuvtyvbAqkYz8rmgy8q67Jpvqeq217Pkm0CQq5nBS//VGRV7bV2BMpV7+tcjp0W/vPYayPInhcFA8y+idR8NmuSh5Gpwh0/Xl6aZeC0LwoEEa16O100VoleawBF66lqAHKiLQIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787890873; c=relaxed/simple;
	bh=rw6wFrgNd1HbEW3XdpHBz7cETOkh1Ct2EWG4ifiVdM8=;
	h=Date:To:From:Subject:Message-Id; b=YX4B6JEiyEnLGqCj7jqqJEyJR+uTYqjPtL+Q3Vb0eiMS/zsupv6MhDBOCBN6daO7cDCMtw1az+wtww25x9w2G/RRxRlF6yF8hu4QXQZm+YeAyFcufcwpRfca3cdRJX1Hg8qzZhkwqysQom3bsDwCccoa0gfRkvZXA0AitzVLxok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LQm3jd5S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LQm3jd5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB4D1F000E9;
	Fri, 28 Aug 2026 04:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787890871;
	bh=nIVvZlg0CdFoSxZH+Oj6p0ZJPovRq6LAT5v/dqCnuY4=;
	h=Date:To:From:Subject;
	b=LQm3jd5St1K/ZbRGyRXCA1fpU3+WG2w1dHLXQR6Lezt8bWbllkXSfqe5L5/ST7t3B
	 8V1quCO87s7kYQ7nN345yuiynkcaywu4SRW8vEtamVsaQKSWHnsW36eo5S9hUYgXWN
	 /G/UA8qhDEYgvdYrcUUClAKSmMn0bOawIAOix/gk=
Date: Thu, 27 Aug 2026 21:21:11 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-rename-hvo-order-macros.patch added to mm-new branch
Message-Id: <20260828042111.9BB4D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse-vmemmap: rename HVO order macros
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-vmemmap-rename-hvo-order-macros.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-vmemmap-rename-hvo-order-macros.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse-vmemmap: rename HVO order macros
Date: Tue, 25 Aug 2026 16:45:53 +0800

The macros VMEMMAP_TAIL_MIN_ORDER and NR_VMEMMAP_TAILS describe the order
range where HVO can be applied, but their names tie that range to the
tail-page cache implementation.

Rename them with a VMEMMAP_OPTIMIZATION prefix and use the new names in
the HVO paths.  This makes the code describe the optimization requirements
rather than the tail-page cache implementation detail.

No functional change intended.

Link: https://lore.kernel.org/20260825084608.47437-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
@@ -3348,7 +3348,7 @@ void __init hugetlb_bootmem_struct_page_
 	struct zone *zone;
 
 	for_each_zone(zone) {
-		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
+		for (int i = 0; i < VMEMMAP_OPTIMIZATION_NR_ORDERS; i++) {
 			struct page *tail, *p;
 			unsigned int order;
 
@@ -3356,7 +3356,7 @@ void __init hugetlb_bootmem_struct_page_
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

mm-sparse-relax-struct-mem_section-size-constraints.patch
mm-sparse-vmemmap-rename-hvo-order-macros.patch
mm-mm_init-skip-initializing-shared-vmemmap-tail-pages.patch
mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation.patch
mm-sparse-vmemmap-support-section-based-vmemmap-accounting.patch
mm-mm_init-factor-out-pfn_to_zone.patch
mm-sparse-vmemmap-move-helpers-ahead-of-future-callers.patch
mm-sparse-vmemmap-support-section-based-vmemmap-optimization.patch
mm-sparse-initialize-memory-sections-earlier.patch
mm-hugetlb-switch-hugetlb-to-section-based-vmemmap-optimization.patch
mm-sparse-vmemmap-remove-sparsemem_vmemmap_preinit-support.patch
mm-sparse-inline-usemap-allocation-into-sparse_init_nid.patch
mm-sparse-remove-section_map_size.patch
mm-hugetlb-remove-huge_bootmem_hvo.patch
mm-hugetlb-remove-huge_bootmem_cma.patch
mm-hugetlb-localize-struct-huge_bootmem_page.patch
mm-hugetlb-localize-huge_bootmem_zones_valid.patch

