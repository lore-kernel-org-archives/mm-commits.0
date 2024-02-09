Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61D41A70A
	for <mm-commits@vger.kernel.org>; Fri,  9 Feb 2024 22:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707516339; cv=none; b=koeM30Dj2N79YTmrxbvdHtD/SP4ZzRANtcLEpbaRn3pD94Gx25Kp0hzi0Mx97fauS/JrwOY1G/yJDtiIhqNc2WqJ3wZbHJfEsQE4906WyZ1JoT3xcq3B+Jf4dGYV10Khu2Qer+MuhZVpHZ4c50VcN340jlHHGNuw69QhNOETBqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707516339; c=relaxed/simple;
	bh=iZHZ+oF9G4yP1uufrGsDDFCPB78Xi+3TBuWKuPjdNts=;
	h=Date:To:From:Subject:Message-Id; b=R5SYD2i+ptfoKQO0VWoWvcz620u9KEAoAiz0WJjpT5+P3vZShBc3S02R0rNimoL8pT/RfuH2k2XcziNUxD9mauiEgirZiZCF60fKJ0IGgdMmGs6kV7WTEop9/sbFTNkj5jdAgSDJEXHfLLsmOHxiNSsW2j/1m+ecR4NzG/P+7wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PTCVeKsK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PTCVeKsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BCCC433F1;
	Fri,  9 Feb 2024 22:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707516338;
	bh=iZHZ+oF9G4yP1uufrGsDDFCPB78Xi+3TBuWKuPjdNts=;
	h=Date:To:From:Subject:From;
	b=PTCVeKsKpNjyoc2E1xteJ66e91h9ykPrgcwNSD2ZqNtp4gNH9G41zXXN2/nNC1WOC
	 gWZwKmaHGrxeEf7WGXpgY8+4UgMogpy0dE98qBYx2ef/yMGITt2fyWLin4+cD90tAf
	 8Jf8e4ncDvaoi5wQ3LVpUg7LA3VbcoRBtTfQhNXc=
Date: Fri, 09 Feb 2024 14:05:37 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,willy@infradead.org,vishal.moola@gmail.com,vbabka@suse.cz,shikemeng@huaweicloud.com,ryan.roberts@arm.com,mgorman@techsingularity.net,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,hannes@cmpxchg.org,fengwei.yin@intel.com,david@redhat.com,baolin.wang@linux.alibaba.com,a.manzanares@samsung.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-compaction-enable-compacting-0-order-folios.patch removed from -mm tree
Message-Id: <20240209220538.56BCCC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/compaction: enable compacting >0 order folios.
has been removed from the -mm tree.  Its filename was
     mm-compaction-enable-compacting-0-order-folios.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/compaction: enable compacting >0 order folios.
Date: Fri, 2 Feb 2024 11:15:52 -0500

Patch series "Enable >0 order folio memory compaction", v3.

This patchset enables >0 order folio memory compaction, which is one of
the prerequisitions for large folio support[1].  It includes the fix[4]
for V2 and is on top of mm-everything-2024-01-29-07-19.

I am aware of that split free pages is necessary for folio migration in
compaction, since if >0 order free pages are never split and no order-0
free page is scanned, compaction will end prematurely due to migration
returns -ENOMEM.  Free page split becomes a must instead of an
optimization.

lkp ncompare results for default LRU (-no-mglru) and CONFIG_LRU_GEN are
shown at the bottom (on a 8-CPU (Intel Xeon E5-2650 v4 @ 2.20GHz) 16G VM).
In sum, most of vm-scalability applications do not see performance
change, and the others see ~4% to ~26% performance boost under default LRU
and ~2% to ~6% performance boost under CONFIG_LRU_GEN.


This patch (of 3):

migrate_pages() supports >0 order folio migration and during compaction,
even if compaction_alloc() cannot provide >0 order free pages,
migrate_pages() can split the source page and try to migrate the base
pages from the split.  It can be a baseline and start point for adding
support for compacting >0 order folios.

Link: https://lkml.kernel.org/r/20240202161554.565023-1-zi.yan@sent.com
Link: https://lkml.kernel.org/r/20240202161554.565023-2-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   43 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 8 deletions(-)

--- a/mm/compaction.c~mm-compaction-enable-compacting-0-order-folios
+++ a/mm/compaction.c
@@ -816,6 +816,21 @@ static bool too_many_isolated(struct com
 	return too_many;
 }
 
+/*
+ * 1. if the page order is larger than or equal to target_order (i.e.,
+ * cc->order and when it is not -1 for global compaction), skip it since
+ * target_order already indicates no free page with larger than target_order
+ * exists and later migrating it will most likely fail;
+ *
+ * 2. compacting > pageblock_order pages does not improve memory fragmentation,
+ * skip them;
+ */
+static bool skip_isolation_on_order(int order, int target_order)
+{
+	return (target_order != -1 && order >= target_order) ||
+		order >= pageblock_order;
+}
+
 /**
  * isolate_migratepages_block() - isolate all migrate-able pages within
  *				  a single pageblock
@@ -1010,7 +1025,7 @@ isolate_migratepages_block(struct compac
 		/*
 		 * Regardless of being on LRU, compound pages such as THP and
 		 * hugetlbfs are not to be compacted unless we are attempting
-		 * an allocation much larger than the huge page size (eg CMA).
+		 * an allocation larger than the compound page size.
 		 * We can potentially save a lot of iterations if we skip them
 		 * at once. The check is racy, but we can consider only valid
 		 * values and the only danger is skipping too much.
@@ -1018,11 +1033,18 @@ isolate_migratepages_block(struct compac
 		if (PageCompound(page) && !cc->alloc_contig) {
 			const unsigned int order = compound_order(page);
 
-			if (likely(order <= MAX_PAGE_ORDER)) {
-				low_pfn += (1UL << order) - 1;
-				nr_scanned += (1UL << order) - 1;
+			/*
+			 * Skip based on page order and compaction target order
+			 * and skip hugetlbfs pages.
+			 */
+			if (skip_isolation_on_order(order, cc->order) ||
+			    PageHuge(page)) {
+				if (order <= MAX_PAGE_ORDER) {
+					low_pfn += (1UL << order) - 1;
+					nr_scanned += (1UL << order) - 1;
+				}
+				goto isolate_fail;
 			}
-			goto isolate_fail;
 		}
 
 		/*
@@ -1165,10 +1187,11 @@ isolate_migratepages_block(struct compac
 			}
 
 			/*
-			 * folio become large since the non-locked check,
-			 * and it's on LRU.
+			 * Check LRU folio order under the lock
 			 */
-			if (unlikely(folio_test_large(folio) && !cc->alloc_contig)) {
+			if (unlikely(skip_isolation_on_order(folio_order(folio),
+							     cc->order) &&
+				     !cc->alloc_contig)) {
 				low_pfn += folio_nr_pages(folio) - 1;
 				nr_scanned += folio_nr_pages(folio) - 1;
 				folio_set_lru(folio);
@@ -1786,6 +1809,10 @@ static struct folio *compaction_alloc(st
 	struct compact_control *cc = (struct compact_control *)data;
 	struct folio *dst;
 
+	/* this makes migrate_pages() split the source page and retry */
+	if (folio_test_large(src) > 0)
+		return NULL;
+
 	if (list_empty(&cc->freepages)) {
 		isolate_freepages(cc);
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-compaction-add-support-for-0-order-folio-memory-compaction.patch
mm-compaction-optimize-0-order-folio-compaction-with-free-page-split.patch

