Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B753E380
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 19:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711568185; cv=none; b=OpvBw8szGAIaFV8hKvnBfdnOyRaGiy08813LZxaCcfG2LHsIOECP+JbuI6hHIC4ar7LIyG5BIcPAgKfVi48vJ8udEtc2WNdxXSb3wNFlVEc1Mm5hCcOSFGzKH/TUMrx0x14QZG4hPb6i7ebZNHB25O6/yNhK3QI2ei1DmkDXg2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711568185; c=relaxed/simple;
	bh=4ldATXPQNAHlHMPq1lhb5vT7w8jhsLzL0V2WbeRPilY=;
	h=Date:To:From:Subject:Message-Id; b=KVNItablRa1hptPFRbgCI5Q+6M08OLIZB0oIoaIC3HgkBKCOgY154tkMOfA35RfQbLqsbKfzv+Es7XiNih9PXYSLEPn8r71oqD3kaNekc127Amh8xD3tLlILviIqPqJb3u8dkRHagqdmQV93wgBlu4GnHzmNw3F+7mla59owvgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PN8KMWJz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PN8KMWJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A458C433C7;
	Wed, 27 Mar 2024 19:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711568185;
	bh=4ldATXPQNAHlHMPq1lhb5vT7w8jhsLzL0V2WbeRPilY=;
	h=Date:To:From:Subject:From;
	b=PN8KMWJz8fi2QVFquELWelaCk97rL1VpUChemhLHh7k88BHBPbZz+a0IoACrtjAkY
	 HBl6RwHmv/8y7DPb2eIT8UNaz5rZfHEQsnh1wyA8Bq0Mq36C5VhQouBOhVMPb0Duwh
	 +fiGmxppyzr5LUjsoxABj96Ae7ye4Dio18psW5PI=
Date: Wed, 27 Mar 2024 12:36:24 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,mgorman@techsingularity.net,hannes@cmpxchg.org,david@redhat.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-change-move_freepages-to-__move_freepages_block.patch added to mm-unstable branch
Message-Id: <20240327193625.3A458C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: change move_freepages() to __move_freepages_block()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-change-move_freepages-to-__move_freepages_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-change-move_freepages-to-__move_freepages_block.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: page_alloc: change move_freepages() to __move_freepages_block()

The function is now supposed to be called only on a single pageblock and
checks start_pfn and end_pfn accordingly.  Rename it to make this more
obvious and drop the end_pfn parameter which can be determined trivially
and none of the callers use it for anything else.

Also make the (now internal) end_pfn exclusive, which is more common.

Link: https://lkml.kernel.org/r/81b1d642-2ec0-49f5-89fc-19a3828419ff@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-change-move_freepages-to-__move_freepages_block
+++ a/mm/page_alloc.c
@@ -1566,18 +1566,18 @@ static inline struct page *__rmqueue_cma
  * Change the type of a block and move all its free pages to that
  * type's freelist.
  */
-static int move_freepages(struct zone *zone, unsigned long start_pfn,
-			  unsigned long end_pfn, int old_mt, int new_mt)
+static int __move_freepages_block(struct zone *zone, unsigned long start_pfn,
+				  int old_mt, int new_mt)
 {
 	struct page *page;
-	unsigned long pfn;
+	unsigned long pfn, end_pfn;
 	unsigned int order;
 	int pages_moved = 0;
 
 	VM_WARN_ON(start_pfn & (pageblock_nr_pages - 1));
-	VM_WARN_ON(start_pfn + pageblock_nr_pages - 1 != end_pfn);
+	end_pfn = pageblock_end_pfn(start_pfn);
 
-	for (pfn = start_pfn; pfn <= end_pfn;) {
+	for (pfn = start_pfn; pfn < end_pfn;) {
 		page = pfn_to_page(pfn);
 		if (!PageBuddy(page)) {
 			pfn++;
@@ -1603,14 +1603,13 @@ static int move_freepages(struct zone *z
 
 static bool prep_move_freepages_block(struct zone *zone, struct page *page,
 				      unsigned long *start_pfn,
-				      unsigned long *end_pfn,
 				      int *num_free, int *num_movable)
 {
 	unsigned long pfn, start, end;
 
 	pfn = page_to_pfn(page);
 	start = pageblock_start_pfn(pfn);
-	end = pageblock_end_pfn(pfn) - 1;
+	end = pageblock_end_pfn(pfn);
 
 	/*
 	 * The caller only has the lock for @zone, don't touch ranges
@@ -1621,16 +1620,15 @@ static bool prep_move_freepages_block(st
 	 */
 	if (!zone_spans_pfn(zone, start))
 		return false;
-	if (!zone_spans_pfn(zone, end))
+	if (!zone_spans_pfn(zone, end - 1))
 		return false;
 
 	*start_pfn = start;
-	*end_pfn = end;
 
 	if (num_free) {
 		*num_free = 0;
 		*num_movable = 0;
-		for (pfn = start; pfn <= end;) {
+		for (pfn = start; pfn < end;) {
 			page = pfn_to_page(pfn);
 			if (PageBuddy(page)) {
 				int nr = 1 << buddy_order(page);
@@ -1656,13 +1654,12 @@ static bool prep_move_freepages_block(st
 static int move_freepages_block(struct zone *zone, struct page *page,
 				int old_mt, int new_mt)
 {
-	unsigned long start_pfn, end_pfn;
+	unsigned long start_pfn;
 
-	if (!prep_move_freepages_block(zone, page, &start_pfn, &end_pfn,
-				       NULL, NULL))
+	if (!prep_move_freepages_block(zone, page, &start_pfn, NULL, NULL))
 		return -1;
 
-	return move_freepages(zone, start_pfn, end_pfn, old_mt, new_mt);
+	return __move_freepages_block(zone, start_pfn, old_mt, new_mt);
 }
 
 #ifdef CONFIG_MEMORY_ISOLATION
@@ -1733,10 +1730,9 @@ static void split_large_buddy(struct zon
 bool move_freepages_block_isolate(struct zone *zone, struct page *page,
 				  int migratetype)
 {
-	unsigned long start_pfn, end_pfn, pfn;
+	unsigned long start_pfn, pfn;
 
-	if (!prep_move_freepages_block(zone, page, &start_pfn, &end_pfn,
-				       NULL, NULL))
+	if (!prep_move_freepages_block(zone, page, &start_pfn, NULL, NULL))
 		return false;
 
 	/* No splits needed if buddies can't span multiple blocks */
@@ -1767,8 +1763,9 @@ bool move_freepages_block_isolate(struct
 		return true;
 	}
 move:
-	move_freepages(zone, start_pfn, end_pfn,
-		       get_pfnblock_migratetype(page, start_pfn), migratetype);
+	__move_freepages_block(zone, start_pfn,
+			       get_pfnblock_migratetype(page, start_pfn),
+			       migratetype);
 	return true;
 }
 #endif /* CONFIG_MEMORY_ISOLATION */
@@ -1868,7 +1865,7 @@ steal_suitable_fallback(struct zone *zon
 			unsigned int alloc_flags, bool whole_block)
 {
 	int free_pages, movable_pages, alike_pages;
-	unsigned long start_pfn, end_pfn;
+	unsigned long start_pfn;
 	int block_type;
 
 	block_type = get_pageblock_migratetype(page);
@@ -1901,8 +1898,8 @@ steal_suitable_fallback(struct zone *zon
 		goto single_page;
 
 	/* moving whole block can fail due to zone boundary conditions */
-	if (!prep_move_freepages_block(zone, page, &start_pfn, &end_pfn,
-				       &free_pages, &movable_pages))
+	if (!prep_move_freepages_block(zone, page, &start_pfn, &free_pages,
+				       &movable_pages))
 		goto single_page;
 
 	/*
@@ -1932,7 +1929,7 @@ steal_suitable_fallback(struct zone *zon
 	 */
 	if (free_pages + alike_pages >= (1 << (pageblock_order-1)) ||
 			page_group_by_mobility_disabled) {
-		move_freepages(zone, start_pfn, end_pfn, block_type, start_type);
+		__move_freepages_block(zone, start_pfn, block_type, start_type);
 		return __rmqueue_smallest(zone, order, start_type);
 	}
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-change-move_freepages-to-__move_freepages_block.patch
mm-slab-move-memcg-charging-to-post-alloc-hook.patch
mm-slab-move-slab_memcg-hooks-to-mm-memcontrolc.patch

