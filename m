Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA12BA56
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 05:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706247878; cv=none; b=vFed/BoYohtzspxqPca0IVC4wiuARD6Ts7ngxw/2z3of+UXOSku0GqnJ0rajbA/6y/Bwfcj+3eVQMSBS3O48tsPXTVBDQmar04M1G+cFuxh6KdLvgInK/1tedx0dZN9pr4rRkTlqA/L2D09hmWyVHuWcoNZR0LCzVpmWMca0THM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706247878; c=relaxed/simple;
	bh=J9ZLn3Yf2H5v86+T0yxBR3zUICR8EjRvsn80FgPHrEI=;
	h=Date:To:From:Subject:Message-Id; b=i+Z+RgV60Ps+zZt5L7tohh07/TZWWUouzvt9r9B/2Zk5aqiLTQbfshYLXXuSB4zU7SvSvr3Ix4PmIdu9i3YFuXbHLdKXKRdTHMT9fcTDU2KL2aq+qi5VR+xrqXkN7iCQrA6SkpJA+/hOEsShAo0qt7GY4YXcYsnrND7CbOuAVw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jqQdtygT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jqQdtygT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56831C433C7;
	Fri, 26 Jan 2024 05:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706247878;
	bh=J9ZLn3Yf2H5v86+T0yxBR3zUICR8EjRvsn80FgPHrEI=;
	h=Date:To:From:Subject:From;
	b=jqQdtygTZtA/R4c5IEIcy8ShGnnS/yBjTrCgD/UGQ6RuEeD1ZBhhZDA1wxOodfmWR
	 8LoZDUVPNqaY7gvb1ghLblFgqDqo3xX0VF6b6ua9MpuqpualWRrObcE2B1d2eGxba9
	 ff/G5cB9iX2zMV+mGsX7l9LvD9iIRFglSTWUnLbo=
Date: Thu, 25 Jan 2024 21:44:34 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,willy@infradead.org,vishal.moola@gmail.com,vbabka@suse.cz,shikemeng@huaweicloud.com,ryan.roberts@arm.com,mgorman@techsingularity.net,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,hannes@cmpxchg.org,fengwei.yin@intel.com,david@redhat.com,baolin.wang@linux.alibaba.com,a.manzanares@samsung.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-optimize-0-order-folio-compaction-with-free-page-split.patch added to mm-unstable branch
Message-Id: <20240126054437.56831C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/compaction: optimize >0 order folio compaction with free page split.
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
Subject: mm/compaction: optimize >0 order folio compaction with free page split.
Date: Mon, 22 Jan 2024 22:46:35 -0500

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

Link: https://lkml.kernel.org/r/20240123034636.1095672-4-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
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
@@ -1831,9 +1831,43 @@ static struct folio *compaction_alloc(st
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
@@ -1841,6 +1875,7 @@ static struct folio *compaction_alloc(st
 	dst = list_first_entry(&cc->freepages[order].pages, struct folio, lru);
 	cc->freepages[order].nr_pages--;
 	list_del(&dst->lru);
+done:
 	post_alloc_hook(&dst->page, order, __GFP_MOVABLE);
 	if (order)
 		prep_compound_page(&dst->page, order);
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-compaction-enable-compacting-0-order-folios.patch
mm-compaction-add-support-for-0-order-folio-memory-compaction.patch
mm-compaction-optimize-0-order-folio-compaction-with-free-page-split.patch

