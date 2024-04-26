Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D152D2F36
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101560; cv=none; b=J09zAEHPGtsOTe8TWsMnSVjpAO8RzuTNnkjZmmLqHyRiJPbg+VaToGnGLTehs5qDeXoCzGk4XsdvJgwbRmOYBMgeYtkWfI3EN4EL72f5zcebxguuLiNJpVfelg0/wUm0OGLxd94AM7uzNGm/Ok4blY5kHGz46L6yhom/ziRw4I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101560; c=relaxed/simple;
	bh=t98vXLeLR4hjvOaHw+NSOJjnlKw+DZaiKfS/4qsFeJA=;
	h=Date:To:From:Subject:Message-Id; b=sUagb6s0ND5GkhR+uoumSHSa1fKH6rfq64qKBdvIAe5QALeKSkvDBEAF0esV/uFo999Bn1phdmbloz7QUK6qxxeTZR9s+4zVg4TT82jTNWXknZ6ZxR8ab2g3MzTQXDDc1z3jjJWiHBM8lh3Zq/LoRJSAs8PUCCAZZmsp53n+R/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LORgHdww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LORgHdww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4819C113CD;
	Fri, 26 Apr 2024 03:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101560;
	bh=t98vXLeLR4hjvOaHw+NSOJjnlKw+DZaiKfS/4qsFeJA=;
	h=Date:To:From:Subject:From;
	b=LORgHdwwAlQRP6Xptfg0dnBcLyKQh0PG+OrjbPJ1G6KRKAxyP6YZnEIwEbKeLKvKr
	 xbG2vJ37gCBlj+plXL365OVUwLM++p/MIJB7rsAM6px4H/IRuV4J5cKj12swTvdNLB
	 qszk/29JmKq7HXA2K1af3FzW5dcMSpEBy1WVCjXo=
Date: Thu, 25 Apr 2024 20:19:20 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,hannes@cmpxchg.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-consolidate-free-page-accounting-fix-3.patch removed from -mm tree
Message-Id: <20240426031920.A4819C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: consolidate free page accounting fix 3
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-consolidate-free-page-accounting-fix-3.patch

This patch was dropped because it was folded into mm-page_alloc-consolidate-free-page-accounting.patch

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

mm-page_alloc-consolidate-free-page-accounting.patch
mm-record-the-migration-reason-for-struct-migration_target_control.patch
mm-hugetlb-make-the-hugetlb-migration-strategy-consistent.patch
docs-hugetlbpagerst-add-hugetlb-migration-description.patch
mm-factor-out-the-numa-mapping-rebuilding-into-a-new-helper.patch
mm-support-multi-size-thp-numa-balancing.patch
mm-support-multi-size-thp-numa-balancing-v3.patch
mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics.patch
mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics-v2.patch
mm-page_alloc-use-the-correct-thp-order-for-thp-pcp.patch
mm-set-pageblock_order-to-hpage_pmd_order-in-case-with-config_hugetlb_page-but-thp-enabled.patch
mm-page_alloc-allowing-mthp-compaction-to-capture-the-freed-page-directly.patch

