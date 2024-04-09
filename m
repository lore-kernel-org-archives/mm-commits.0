Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2E5156F5D
	for <mm-commits@vger.kernel.org>; Tue,  9 Apr 2024 19:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712691035; cv=none; b=Vu2leb0iBO9hCYysrk4YrazbpdYr239s9RrCOmhlcE2AFvkzMASzI5PsPnauUAL8aq+pJtzjK7Cxz3wGBqGYPCQzlY9rHuKPlwqj9w7jCXuHjZTD8s2p/Bi3FyHFov8be8vmbOQwdDDrRiATZXioEwU//GIDEy5Aa2dA0q9ghyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712691035; c=relaxed/simple;
	bh=E1fKzGlzsZuMh0H7HquqgS4kjxRoSwRV2NKNZ8TdgXA=;
	h=Date:To:From:Subject:Message-Id; b=qcVgCR+ifwMZjQozAgBxolS5B1ucJP3+wBn7+lYbLt08+lj8QfTHVwZXrcu5KfNRXXTHRjqLCXe7m9ZGzcFvsAJOb2dTYlsspX3AqBfGymHInaKXnyqST+gWFOrI0nQnyNQxApdeCF8/LdVNbdEEKsPMWfbNDS9IdJolywLOfkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bp10iNgK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bp10iNgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3A6C433F1;
	Tue,  9 Apr 2024 19:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712691035;
	bh=E1fKzGlzsZuMh0H7HquqgS4kjxRoSwRV2NKNZ8TdgXA=;
	h=Date:To:From:Subject:From;
	b=bp10iNgKbPtFqWcDHfxxipvNlpQZmA3Go3OTUg7CLy9oscyRoOh2wC0U3ttAD31Yv
	 jgA0SpnBte+srGgchqk260cnQijz5z3JwQ6BaXN464gNKTIHxRWsWtnrPLFyQ/6mO+
	 8+4wMTUoha3GoXGQ5inoRRNY4JZWWGhgetBlmzXA=
Date: Tue, 09 Apr 2024 12:30:34 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,hannes@cmpxchg.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-consolidate-free-page-accounting-fix-3.patch added to mm-unstable branch
Message-Id: <20240409193035.4F3A6C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: consolidate free page accounting fix 3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-consolidate-free-page-accounting-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-consolidate-free-page-accounting-fix-3.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: page_alloc: consolidate free page accounting fix 3
Date: Tue, 9 Apr 2024 15:48:04 +0800

If the released page is captured by compaction, now the free page accounting
is not correspondingly decreased, which can make the watermark checks false
positive and result in depleted reserves etc. And I can see the false positive
watermark checks in thpcompact benchmark, that led to a slight regression:

thpcompact Percentage Faults Huge
                           k6.9-rc2-base        base + patch10 + 2 fixes
Percentage huge-1        78.18 (   0.00%)       71.92 (  -8.01%)
Percentage huge-3        86.70 (   0.00%)       86.07 (  -0.73%)
Percentage huge-5        90.26 (   0.00%)       78.02 ( -13.57%)
Percentage huge-7        92.34 (   0.00%)       78.67 ( -14.81%)
Percentage huge-12       91.18 (   0.00%)       81.04 ( -11.12%)
Percentage huge-18       89.00 (   0.00%)       79.57 ( -10.60%)
Percentage huge-24       90.52 (   0.00%)       80.07 ( -11.54%)
Percentage huge-30       94.44 (   0.00%)       96.28 (   1.95%)
Percentage huge-32       93.09 (   0.00%)       99.39 (   6.77%)

After the fix, the regression is gone.

Link: https://lkml.kernel.org/r/a2a48baca69f103aa431fd201f8a06e3b95e203d.1712648441.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-consolidate-free-page-accounting-fix-3
+++ a/mm/page_alloc.c
@@ -805,8 +805,10 @@ static inline void __free_one_page(struc
 	while (order < MAX_PAGE_ORDER) {
 		int buddy_mt = migratetype;
 
-		if (compaction_capture(capc, page, order, migratetype))
+		if (compaction_capture(capc, page, order, migratetype)) {
+			account_freepages(zone, -(1 << order), migratetype);
 			return;
+		}
 
 		buddy = find_buddy_page_pfn(page, pfn, order, &buddy_pfn);
 		if (!buddy)
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-page_alloc-fix-freelist-movement-during-block-conversion-fix.patch
mm-page_alloc-consolidate-free-page-accounting-fix-3.patch
mm-record-the-migration-reason-for-struct-migration_target_control.patch
mm-hugetlb-make-the-hugetlb-migration-strategy-consistent.patch
docs-hugetlbpagerst-add-hugetlb-migration-description.patch
mm-factor-out-the-numa-mapping-rebuilding-into-a-new-helper.patch
mm-support-multi-size-thp-numa-balancing.patch
mm-support-multi-size-thp-numa-balancing-v3.patch
mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics.patch
mm-page_alloc-use-the-correct-thp-order-for-thp-pcp.patch
mm-set-pageblock_order-to-hpage_pmd_order-in-case-with-config_hugetlb_page-but-thp-enabled.patch

