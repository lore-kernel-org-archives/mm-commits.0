Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3146011CA1
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 02:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708394924; cv=none; b=P9x+sXBIh0ISxOgDMylQw+765kk1xjvHyqmnORlX9+sK6aM7nKj4ZRJE1kx1zEVYt0xvWvQs08pgGiTELkOukshN8NsOQYHIswCjhmrViYtBcTO9Kakyq6ued9yGEdsDtuH+wRPJ9a32WKp4Q5VA5GecKYBhCOcb6djKxvAcCYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708394924; c=relaxed/simple;
	bh=Qu7CXiqsiZ/HOImbjpE3CMJbsPMkUAM5q10PglG76Vg=;
	h=Date:To:From:Subject:Message-Id; b=RSkmDbu0grcmj7XDEGLbjDDDWv1eIJEgUicbrDbLWAMTKOaWNNrYEsno5OGP4XNs18l5sa5MLqopKLNCI/vXNcS8vI6+72Icfxze8hz1h8EhqN9pKHu9Qyo/AuWxSYFj3/AcDo/tl1LawWrHfa8ORFJXdpxK/F1kIfpLfX5E1Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2m+J1sxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2m+J1sxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1676C433F1;
	Tue, 20 Feb 2024 02:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708394924;
	bh=Qu7CXiqsiZ/HOImbjpE3CMJbsPMkUAM5q10PglG76Vg=;
	h=Date:To:From:Subject:From;
	b=2m+J1sxWHYxtlgpV/OlvY9Sv6rb/7Jc7J1np/wCIpB78SsIxlsY5SUYRCUBrPUM5v
	 drWqgCtckHgdLTjkE0tAlMPdNkxPb5Ft12m0RfE1/Z/5hrHbLG1u2fahk7PYeAsCvH
	 e0B056JmmA2DVhUoC+Uow3ezIC4HCUxHByJ63Ku0=
Date: Mon, 19 Feb 2024 18:08:43 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,willy@infradead.org,vishal.moola@gmail.com,vbabka@suse.cz,shikemeng@huaweicloud.com,ryan.roberts@arm.com,mgorman@techsingularity.net,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,hannes@cmpxchg.org,fengwei.yin@intel.com,david@redhat.com,baolin.wang@linux.alibaba.com,a.manzanares@samsung.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-optimize-0-order-folio-compaction-with-free-page-split.patch added to mm-unstable branch
Message-Id: <20240220020843.F1676C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/compaction: optimize >0 order folio compaction with free page split
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-optimize-0-order-folio-compaction-with-free-page-split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-optimize-0-order-folio-compaction-with-free-page-split.patch

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
Subject: mm/compaction: optimize >0 order folio compaction with free page split
Date: Fri, 16 Feb 2024 12:04:32 -0500

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

Link: https://lkml.kernel.org/r/20240216170432.1268753-5-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Yu Zhao <yuzhao@google.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

--- a/mm/compaction.c~mm-compaction-optimize-0-order-folio-compaction-with-free-page-split
+++ a/mm/compaction.c
@@ -1832,15 +1832,40 @@ static struct folio *compaction_alloc(st
 	struct compact_control *cc = (struct compact_control *)data;
 	struct folio *dst;
 	int order = folio_order(src);
+	bool has_isolated_pages = false;
+	int start_order;
+	struct page *freepage;
+	unsigned long size;
 
-	if (list_empty(&cc->freepages[order])) {
-		isolate_freepages(cc);
-		if (list_empty(&cc->freepages[order]))
+again:
+	for (start_order = order; start_order < NR_PAGE_ORDERS; start_order++)
+		if (!list_empty(&cc->freepages[start_order]))
+			break;
+
+	/* no free pages in the list */
+	if (start_order == NR_PAGE_ORDERS) {
+		if (has_isolated_pages)
 			return NULL;
+		isolate_freepages(cc);
+		has_isolated_pages = true;
+		goto again;
+	}
+
+	freepage = list_first_entry(&cc->freepages[start_order], struct page,
+				lru);
+	size = 1 << start_order;
+
+	list_del(&freepage->lru);
+
+	while (start_order > order) {
+		start_order--;
+		size >>= 1;
+
+		list_add(&freepage[size].lru, &cc->freepages[start_order]);
+		set_page_private(&freepage[size], start_order);
 	}
+	dst = (struct folio *)freepage;
 
-	dst = list_first_entry(&cc->freepages[order], struct folio, lru);
-	list_del(&dst->lru);
 	post_alloc_hook(&dst->page, order, __GFP_MOVABLE);
 	if (order)
 		prep_compound_page(&dst->page, order);
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_alloc-remove-unused-fpi_flags-in-free_pages_prepare.patch
mm-compaction-enable-compacting-0-order-folios.patch
mm-compaction-add-support-for-0-order-folio-memory-compaction.patch
mm-compaction-optimize-0-order-folio-compaction-with-free-page-split.patch

