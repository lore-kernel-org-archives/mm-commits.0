Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A9E80BF0
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104178; cv=none; b=XhPR6dZoYbFO68nNllDpYqLeqKIBuwe+S9Cph5FjqHqu6j3drj+C4d3Su/x/+wP9omQC0hllf0tBzpcXVCofYoTSxNqlYZ7x78IMNNL7inY3oorUEom1GD87zqmVxKx0ZIOpTBEbOeVomMdCucRq52qC5ILczYjcha6Hc5xBlyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104178; c=relaxed/simple;
	bh=TkJzYlkJ8Wd2NfkfUyS2IPxi1KtRAdKGojrhO2bCwEc=;
	h=Date:To:From:Subject:Message-Id; b=JwltFLBPzUlfpOaev5ahV5bz6yUL2sDIHfPE8+0z0kNUNemqtkJAi954Q9vv9y6pQ2tIsRFatb5inQdqM3LyhzlnpOKYVsaj8SxQLerwPurKBgxhQ4M2imnDacnvlJThOx7cp8wo8rmf+Wkc1gQ1CjiD3Sl3CrYDR6UXdDWQk20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2WM0QDR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2WM0QDR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD47FC113CD;
	Fri, 26 Apr 2024 04:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104178;
	bh=TkJzYlkJ8Wd2NfkfUyS2IPxi1KtRAdKGojrhO2bCwEc=;
	h=Date:To:From:Subject:From;
	b=2WM0QDR9psEhpRDexTzzPZwN5l6e9pgdDBie/o/RLGCp5UFug7ga5rk4ny9hEjwXH
	 aHv11T4YiA13Fzthmmfeoilj/eIluk0zNdmFuxt8FNHRIoX+8/hBbuFkU5HMusPh7x
	 nL5YO6ao6Vkjihqm8nOEgrbHJhqdxrBIN8Gd4oIQ=
Date: Thu, 25 Apr 2024 21:02:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,mgorman@techsingularity.net,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-set-pageblock_order-to-hpage_pmd_order-in-case-with-config_hugetlb_page-but-thp-enabled.patch removed from -mm tree
Message-Id: <20240426040258.AD47FC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: set pageblock_order to HPAGE_PMD_ORDER in case with !CONFIG_HUGETLB_PAGE but THP enabled
has been removed from the -mm tree.  Its filename was
     mm-set-pageblock_order-to-hpage_pmd_order-in-case-with-config_hugetlb_page-but-thp-enabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: set pageblock_order to HPAGE_PMD_ORDER in case with !CONFIG_HUGETLB_PAGE but THP enabled
Date: Fri, 5 Apr 2024 20:24:16 +0800

As Vlastimil suggested in previous discussion[1], it doesn't make sense to
set pageblock_order as MAX_PAGE_ORDER when hugetlbfs is not enabled and
THP is enabled.  Instead, it should be set to HPAGE_PMD_ORDER.

[1] https://lore.kernel.org/all/76457ec5-d789-449b-b8ca-dcb6ceb12445@suse.cz/
Link: https://lkml.kernel.org/r/3d57d253070035bdc0f6d6e5681ce1ed0e1934f7.1712286863.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pageblock-flags.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/include/linux/pageblock-flags.h~mm-set-pageblock_order-to-hpage_pmd_order-in-case-with-config_hugetlb_page-but-thp-enabled
+++ a/include/linux/pageblock-flags.h
@@ -28,7 +28,7 @@ enum pageblock_bits {
 	NR_PAGEBLOCK_BITS
 };
 
-#ifdef CONFIG_HUGETLB_PAGE
+#if defined(CONFIG_HUGETLB_PAGE)
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 
@@ -45,7 +45,11 @@ extern unsigned int pageblock_order;
 
 #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 
-#else /* CONFIG_HUGETLB_PAGE */
+#elif defined(CONFIG_TRANSPARENT_HUGEPAGE)
+
+#define pageblock_order		min_t(unsigned int, HPAGE_PMD_ORDER, MAX_PAGE_ORDER)
+
+#else /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 /* If huge pages are not used, group by MAX_ORDER_NR_PAGES */
 #define pageblock_order		MAX_PAGE_ORDER
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-page_alloc-allowing-mthp-compaction-to-capture-the-freed-page-directly.patch

