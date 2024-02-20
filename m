Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EF911CA1
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 02:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708394919; cv=none; b=hJf7Tt4FJtdFJMG6/pf7NRMihDGoBx+QJzzLG2ljp15daRZKka2s0hF4wRsUd2JdRp95PF3jiYNdTXkFM1UpdtuWFVmRfi4cGmJMcy8sPYbak8IpnIH230b08pgGrmw9LfURHq1EgFNepXDZ3ByVtoqc11nByS6f8WiO8y4n314=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708394919; c=relaxed/simple;
	bh=n1Vzo17LxLmL84kg0wBa65Kn9/PEv6pV+6G8X+WptDs=;
	h=Date:To:From:Subject:Message-Id; b=AanofhTFTyuZl70yuM1q1M8fHQRKVHGup1KWh0QadVm5yna29HOcx+zePOKn5RswXA0uQ63ieuFuo/Np9IOlqr3haVhhSdltYwVkzTAHpZtcVYk1M/ZPKFCOuYMM/uUcE/6r13rpirWj9R/uTLxsLHwEpIXv2zui/lRTudCT0/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z1EW5SNf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z1EW5SNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6473C433F1;
	Tue, 20 Feb 2024 02:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708394919;
	bh=n1Vzo17LxLmL84kg0wBa65Kn9/PEv6pV+6G8X+WptDs=;
	h=Date:To:From:Subject:From;
	b=z1EW5SNfw3gew5Ey49GicKHzASzHzynA05qTGbwmPJr5Dn38fOEQzsDUnMzmdp/s9
	 xrmbfJKN0OBqRaQHXWjP33TcLV8DaDFIjs34r06uClo55gouMOnTrjHlxYolC59tgI
	 lruHAm1YbtJjTBopVqkbXq78eQ1hUiUhR8Ggxa6Y=
Date: Mon, 19 Feb 2024 18:08:38 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,willy@infradead.org,vishal.moola@gmail.com,vbabka@suse.cz,shikemeng@huaweicloud.com,ryan.roberts@arm.com,mgorman@techsingularity.net,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,hannes@cmpxchg.org,fengwei.yin@intel.com,david@redhat.com,baolin.wang@linux.alibaba.com,a.manzanares@samsung.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-enable-compacting-0-order-folios.patch added to mm-unstable branch
Message-Id: <20240220020838.E6473C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/compaction: enable compacting >0 order folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-enable-compacting-0-order-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-enable-compacting-0-order-folios.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/compaction: enable compacting >0 order folios
Date: Fri, 16 Feb 2024 12:04:30 -0500

migrate_pages() supports >0 order folio migration and during compaction,
even if compaction_alloc() cannot provide >0 order free pages,
migrate_pages() can split the source page and try to migrate the base
pages from the split.  It can be a baseline and start point for adding
support for compacting >0 order folios.

Link: https://lkml.kernel.org/r/20240216170432.1268753-3-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Yu Zhao <yuzhao@google.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   66 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 52 insertions(+), 14 deletions(-)

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
@@ -947,7 +962,22 @@ isolate_migratepages_block(struct compac
 			valid_page = page;
 		}
 
-		if (PageHuge(page) && cc->alloc_contig) {
+		if (PageHuge(page)) {
+			/*
+			 * skip hugetlbfs if we are not compacting for pages
+			 * bigger than its order. THPs and other compound pages
+			 * are handled below.
+			 */
+			if (!cc->alloc_contig) {
+				const unsigned int order = compound_order(page);
+
+				if (order <= MAX_PAGE_ORDER) {
+					low_pfn += (1UL << order) - 1;
+					nr_scanned += (1UL << order) - 1;
+				}
+				goto isolate_fail;
+			}
+			/* for alloc_contig case */
 			if (locked) {
 				unlock_page_lruvec_irqrestore(locked, flags);
 				locked = NULL;
@@ -1008,21 +1038,24 @@ isolate_migratepages_block(struct compac
 		}
 
 		/*
-		 * Regardless of being on LRU, compound pages such as THP and
-		 * hugetlbfs are not to be compacted unless we are attempting
-		 * an allocation much larger than the huge page size (eg CMA).
-		 * We can potentially save a lot of iterations if we skip them
-		 * at once. The check is racy, but we can consider only valid
-		 * values and the only danger is skipping too much.
+		 * Regardless of being on LRU, compound pages such as THP
+		 * (hugetlbfs is handled above) are not to be compacted unless
+		 * we are attempting an allocation larger than the compound
+		 * page size. We can potentially save a lot of iterations if we
+		 * skip them at once. The check is racy, but we can consider
+		 * only valid values and the only danger is skipping too much.
 		 */
 		if (PageCompound(page) && !cc->alloc_contig) {
 			const unsigned int order = compound_order(page);
 
-			if (likely(order <= MAX_PAGE_ORDER)) {
-				low_pfn += (1UL << order) - 1;
-				nr_scanned += (1UL << order) - 1;
+			/* Skip based on page order and compaction target order. */
+			if (skip_isolation_on_order(order, cc->order)) {
+				if (order <= MAX_PAGE_ORDER) {
+					low_pfn += (1UL << order) - 1;
+					nr_scanned += (1UL << order) - 1;
+				}
+				goto isolate_fail;
 			}
-			goto isolate_fail;
 		}
 
 		/*
@@ -1165,10 +1198,11 @@ isolate_migratepages_block(struct compac
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
@@ -1788,6 +1822,10 @@ static struct folio *compaction_alloc(st
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

mm-page_alloc-remove-unused-fpi_flags-in-free_pages_prepare.patch
mm-compaction-enable-compacting-0-order-folios.patch
mm-compaction-add-support-for-0-order-folio-memory-compaction.patch
mm-compaction-optimize-0-order-folio-compaction-with-free-page-split.patch

