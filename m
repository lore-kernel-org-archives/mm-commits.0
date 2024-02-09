Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE4F21344
	for <mm-commits@vger.kernel.org>; Fri,  9 Feb 2024 22:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707516341; cv=none; b=ZbgS/qcte0BfoGEXeDtktmLAEgNyVjKmCceZunJ2RUV5S2MsGO/tBsZZ3cd2EK1JsIImNLhlwqznJ04p/awYV+dA9wubRIVmhs20xE8rbs5OzxTLJ4ZK9/wz4Kl/86bhwf8WDy4QB9Cqsy48vTjM7cXqsfOfLH3AyXmFHGDBr/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707516341; c=relaxed/simple;
	bh=R3V7UT4yHwWw9BVDsq99imKa/ecjD5J8W9QOrgdz8OM=;
	h=Date:To:From:Subject:Message-Id; b=MAfnhkqGzYVZL5jAzM7t5/OzCLK7grXLYz80//q7SadmlzL6hz7mzzYpT+nv8tGl8cfNOTYIRH0SR87i7F3qkie/3hShsMv84D5ZbewlGWLIYDFAMqGISp5RwhmWfMH6lHx3dfH0Gc1JGOrZPo1cG+iZ3N2GvWqVt89izwoJmmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PHXt+yp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PHXt+yp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F88C433F1;
	Fri,  9 Feb 2024 22:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707516341;
	bh=R3V7UT4yHwWw9BVDsq99imKa/ecjD5J8W9QOrgdz8OM=;
	h=Date:To:From:Subject:From;
	b=PHXt+yp/h+hI7WbiEChj1GeSdm5X4IkWsRjutWjLevHa89IU+gF6ytrUaeONNyfom
	 NrLbdfdtXLC0YE7tsRTfI4tPFXktvC6IZTWhQ4UU0f2OoTvzpL1CiapwtqW6B61nYq
	 uvGrty2lTbS4gigSywAsEg6CZVdnHnnx7tsMEGtA=
Date: Fri, 09 Feb 2024 14:05:40 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,willy@infradead.org,vishal.moola@gmail.com,vbabka@suse.cz,shikemeng@huaweicloud.com,ryan.roberts@arm.com,mgorman@techsingularity.net,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,hannes@cmpxchg.org,fengwei.yin@intel.com,david@redhat.com,baolin.wang@linux.alibaba.com,a.manzanares@samsung.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-compaction-optimize-0-order-folio-compaction-with-free-page-split.patch removed from -mm tree
Message-Id: <20240209220541.37F88C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/compaction: optimize >0 order folio compaction with free page split.
has been removed from the -mm tree.  Its filename was
     mm-compaction-optimize-0-order-folio-compaction-with-free-page-split.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/compaction: optimize >0 order folio compaction with free page split.
Date: Fri, 2 Feb 2024 11:15:54 -0500

During migration in a memory compaction, free pages are placed in an array
of page lists based on their order.  But the desired free page order
(i.e., the order of a source page) might not be always present, thus
leading to migration failures and premature compaction termination.  Split
a high order free pages when source migration page has a lower order to
increase migration successful rate.

Note: merging free pages when a migration fails and a lower order free
page is returned via compaction_free() is possible, but there is too much
work.  Since the free pages are not buddy pages, it is hard to identify
these free pages using existing PFN-based page merging algorithm.

Link: https://lkml.kernel.org/r/20240202161554.565023-4-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
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

 mm/compaction.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-optimize-0-order-folio-compaction-with-free-page-split
+++ a/mm/compaction.c
@@ -1832,9 +1832,43 @@ static struct folio *compaction_alloc(st
 	struct compact_control *cc = (struct compact_control *)data;
 	struct folio *dst;
 	int order = folio_order(src);
+	bool has_isolated_pages = false;
 
+again:
 	if (!cc->freepages[order].nr_pages) {
-		isolate_freepages(cc);
+		int i;
+
+		for (i = order + 1; i < NR_PAGE_ORDERS; i++) {
+			if (cc->freepages[i].nr_pages) {
+				struct page *freepage =
+					list_first_entry(&cc->freepages[i].pages,
+							 struct page, lru);
+
+				int start_order = i;
+				unsigned long size = 1 << start_order;
+
+				list_del(&freepage->lru);
+				cc->freepages[i].nr_pages--;
+
+				while (start_order > order) {
+					start_order--;
+					size >>= 1;
+
+					list_add(&freepage[size].lru,
+						&cc->freepages[start_order].pages);
+					cc->freepages[start_order].nr_pages++;
+					set_page_private(&freepage[size], start_order);
+				}
+				dst = (struct folio *)freepage;
+				goto done;
+			}
+		}
+		if (!has_isolated_pages) {
+			isolate_freepages(cc);
+			has_isolated_pages = true;
+			goto again;
+		}
+
 		if (!cc->freepages[order].nr_pages)
 			return NULL;
 	}
@@ -1842,6 +1876,7 @@ static struct folio *compaction_alloc(st
 	dst = list_first_entry(&cc->freepages[order].pages, struct folio, lru);
 	cc->freepages[order].nr_pages--;
 	list_del(&dst->lru);
+done:
 	post_alloc_hook(&dst->page, order, __GFP_MOVABLE);
 	if (order)
 		prep_compound_page(&dst->page, order);
_

Patches currently in -mm which might be from ziy@nvidia.com are


