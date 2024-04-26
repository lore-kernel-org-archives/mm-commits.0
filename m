Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57007604D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103966; cv=none; b=rn+YZxtNCaJ/roShgZKHmEyIj1SzJNI4qhEIw7mKslbQy70t2ZYIn2t+8RWUfesIoWWyF/gSG3DZsUJWQgmRMhYpAfDGrDQwun1sx/MkPRAGOnf94X4xc4Ur4RegWOXgxHONk6DZPUFUw/2n890KlzV6v3NtMrm6v3SzfMzCHZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103966; c=relaxed/simple;
	bh=5yYksGi1NNIsEAJEOwI3W2cs1BYe2kvVtrIOk5VLC8U=;
	h=Date:To:From:Subject:Message-Id; b=lW7CHeyuUeDrA+5H1wDYa1GSW0FlyQiVRbbw2TNwLCg2Hrl9xFuXonai4LpZ7tjXhuOIzixPuOxyjhVQ8WFzbM4fhqY34o+t9t6mWWe+fW2PbVryTFyjwDLgpc4V+y8YUuFQ7kWiUinYEAIRrGb/CwJtmFZ+YxhUZjVdCq0vEY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p6qAGIjZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p6qAGIjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA666C113CD;
	Fri, 26 Apr 2024 03:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103966;
	bh=5yYksGi1NNIsEAJEOwI3W2cs1BYe2kvVtrIOk5VLC8U=;
	h=Date:To:From:Subject:From;
	b=p6qAGIjZKFthJTxBfkTrzGtnMvbz6fAp1gJT3VRZFmtNCvIb66xaeKY6TKDoY6PS/
	 PWOyC2C89KP44oqrhrekbEMArNnHy4G+4ZnV0Jlry6kgCQGJNcfVsfpyOfnNSu/wP2
	 qW/BFxZ4qcUhBovcdreoDO08l1blUhAFn5aKHacs=
Date: Thu, 25 Apr 2024 20:59:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,mgorman@techsingularity.net,hannes@cmpxchg.org,david@redhat.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-change-move_freepages-to-__move_freepages_block.patch removed from -mm tree
Message-Id: <20240426035926.AA666C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: change move_freepages() to __move_freepages_block()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-change-move_freepages-to-__move_freepages_block.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1560,18 +1560,18 @@ static inline struct page *__rmqueue_cma
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
@@ -1597,14 +1597,13 @@ static int move_freepages(struct zone *z
 
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
@@ -1615,16 +1614,15 @@ static bool prep_move_freepages_block(st
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
@@ -1650,13 +1648,12 @@ static bool prep_move_freepages_block(st
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
@@ -1727,10 +1724,9 @@ static void split_large_buddy(struct zon
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
@@ -1761,8 +1757,9 @@ bool move_freepages_block_isolate(struct
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
@@ -1862,7 +1859,7 @@ steal_suitable_fallback(struct zone *zon
 			unsigned int alloc_flags, bool whole_block)
 {
 	int free_pages, movable_pages, alike_pages;
-	unsigned long start_pfn, end_pfn;
+	unsigned long start_pfn;
 	int block_type;
 
 	block_type = get_pageblock_migratetype(page);
@@ -1895,8 +1892,8 @@ steal_suitable_fallback(struct zone *zon
 		goto single_page;
 
 	/* moving whole block can fail due to zone boundary conditions */
-	if (!prep_move_freepages_block(zone, page, &start_pfn, &end_pfn,
-				       &free_pages, &movable_pages))
+	if (!prep_move_freepages_block(zone, page, &start_pfn, &free_pages,
+				       &movable_pages))
 		goto single_page;
 
 	/*
@@ -1926,7 +1923,7 @@ steal_suitable_fallback(struct zone *zon
 	 */
 	if (free_pages + alike_pages >= (1 << (pageblock_order-1)) ||
 			page_group_by_mobility_disabled) {
-		move_freepages(zone, start_pfn, end_pfn, block_type, start_type);
+		__move_freepages_block(zone, start_pfn, block_type, start_type);
 		return __rmqueue_smallest(zone, order, start_type);
 	}
 
_

Patches currently in -mm which might be from vbabka@suse.cz are


