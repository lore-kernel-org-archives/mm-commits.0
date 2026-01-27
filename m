Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF57E3191C4
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486694; cv=none; b=Sw9/5452TdJG1RDFcTzcvQ4XcQi0PP5sAmuBeDB9K7uqxFscEvui2gbpLHB/pr5PXY+1QnUUEgEJe4/Q+hbCpYI00siIBEW2wLpsDYLcgz2vgkvAnJ1FjvZ5cyBWwTA89a9R7/KeJGALFEtBgYNchv5XHf27T6A0e3R1tNmQDRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486694; c=relaxed/simple;
	bh=KG+R7qLoz8ti44CTfniZ501WcbSMj4sM9dKja4qxkcQ=;
	h=Date:To:From:Subject:Message-Id; b=FE6B9RpibIXRVy3kZDFqBkqN8EJAK1JJEkEawr1UdqJ8M1qFuMGC0HyQjDnu5wP40xZYK2fbfjX0M3h/awO58MhxU8kd0KkQSrFVjzMy56mMowdlG3UoBUpHENLRawjr4xx7AvdKUfeKEg+OdnwxNhPiQviQqemh1EM8SdwTLfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CZpH0NGE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CZpH0NGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6A7C116C6;
	Tue, 27 Jan 2026 04:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486694;
	bh=KG+R7qLoz8ti44CTfniZ501WcbSMj4sM9dKja4qxkcQ=;
	h=Date:To:From:Subject:From;
	b=CZpH0NGEEWsHZ6nQ8HrkgmTVqGbsJyxn6K+NNPyIylBqzVH9KkVndq3JzX1OH7W7m
	 qOZJDVYhqiFakz+tSkyEKAhK8ab1Vm98WeNjqpa9gtfpwRWZL0CpY4a5FlHOPhC+Hp
	 CL+CFYrzYSa1uWHD5mSZga3vZhnhybzqOzdGA4GI=
Date: Mon, 26 Jan 2026 20:04:54 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,claudiu.beznea.uj@bp.renesas.com,broonie@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page.patch removed from -mm tree
Message-Id: <20260127040454.9C6A7C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: debug_vm_pgtable: add debug_vm_pgtable_free_huge_page()
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: debug_vm_pgtable: add debug_vm_pgtable_free_huge_page()
Date: Fri, 9 Jan 2026 17:31:31 +0800

Patch series "mm: hugetlb: allocate frozen gigantic folio", v6.

Introduce alloc_contig_frozen_pages() and cma_alloc_frozen_compound()
which avoid atomic operation about page refcount, and then convert to
allocate frozen gigantic folio by the new helpers in hugetlb to cleanup
the alloc_gigantic_folio().


This patch (of 6):

Add a new helper to free huge page to be consistency to
debug_vm_pgtable_alloc_huge_page(), and use HPAGE_PUD_ORDER instead of
open-code.

Also move the free_contig_range() under CONFIG_ALLOC_CONTIG since all
caller are built with CONFIG_ALLOC_CONTIG.

Link: https://lkml.kernel.org/r/20260109093136.1491549-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h   |    2 +-
 mm/debug_vm_pgtable.c |   38 +++++++++++++++++---------------------
 mm/page_alloc.c       |    2 +-
 3 files changed, 19 insertions(+), 23 deletions(-)

--- a/include/linux/gfp.h~mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page
+++ a/include/linux/gfp.h
@@ -444,8 +444,8 @@ extern struct page *alloc_contig_pages_n
 					      int nid, nodemask_t *nodemask);
 #define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_noprof(__VA_ARGS__))
 
-#endif
 void free_contig_range(unsigned long pfn, unsigned long nr_pages);
+#endif
 
 #ifdef CONFIG_CONTIG_ALLOC
 static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page
+++ a/mm/debug_vm_pgtable.c
@@ -971,22 +971,26 @@ static unsigned long __init get_random_v
 	return random_vaddr;
 }
 
-static void __init destroy_args(struct pgtable_debug_args *args)
+static void __init
+debug_vm_pgtable_free_huge_page(struct pgtable_debug_args *args,
+		unsigned long pfn, int order)
 {
-	struct page *page = NULL;
+#ifdef CONFIG_CONTIG_ALLOC
+	if (args->is_contiguous_page) {
+		free_contig_range(pfn, 1 << order);
+		return;
+	}
+#endif
+	__free_pages(pfn_to_page(pfn), order);
+}
 
+static void __init destroy_args(struct pgtable_debug_args *args)
+{
 	/* Free (huge) page */
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    has_transparent_pud_hugepage() &&
 	    args->pud_pfn != ULONG_MAX) {
-		if (args->is_contiguous_page) {
-			free_contig_range(args->pud_pfn,
-					  (1 << (HPAGE_PUD_SHIFT - PAGE_SHIFT)));
-		} else {
-			page = pfn_to_page(args->pud_pfn);
-			__free_pages(page, HPAGE_PUD_SHIFT - PAGE_SHIFT);
-		}
-
+		debug_vm_pgtable_free_huge_page(args, args->pud_pfn, HPAGE_PUD_ORDER);
 		args->pud_pfn = ULONG_MAX;
 		args->pmd_pfn = ULONG_MAX;
 		args->pte_pfn = ULONG_MAX;
@@ -995,20 +999,13 @@ static void __init destroy_args(struct p
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    has_transparent_hugepage() &&
 	    args->pmd_pfn != ULONG_MAX) {
-		if (args->is_contiguous_page) {
-			free_contig_range(args->pmd_pfn, (1 << HPAGE_PMD_ORDER));
-		} else {
-			page = pfn_to_page(args->pmd_pfn);
-			__free_pages(page, HPAGE_PMD_ORDER);
-		}
-
+		debug_vm_pgtable_free_huge_page(args, args->pmd_pfn, HPAGE_PMD_ORDER);
 		args->pmd_pfn = ULONG_MAX;
 		args->pte_pfn = ULONG_MAX;
 	}
 
 	if (args->pte_pfn != ULONG_MAX) {
-		page = pfn_to_page(args->pte_pfn);
-		__free_page(page);
+		__free_page(pfn_to_page(args->pte_pfn));
 
 		args->pte_pfn = ULONG_MAX;
 	}
@@ -1242,8 +1239,7 @@ static int __init init_args(struct pgtab
 	 */
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    has_transparent_pud_hugepage()) {
-		page = debug_vm_pgtable_alloc_huge_page(args,
-				HPAGE_PUD_SHIFT - PAGE_SHIFT);
+		page = debug_vm_pgtable_alloc_huge_page(args, HPAGE_PUD_ORDER);
 		if (page) {
 			args->pud_pfn = page_to_pfn(page);
 			args->pmd_pfn = args->pud_pfn;
--- a/mm/page_alloc.c~mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page
+++ a/mm/page_alloc.c
@@ -7255,7 +7255,6 @@ retry:
 	}
 	return NULL;
 }
-#endif /* CONFIG_CONTIG_ALLOC */
 
 void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 {
@@ -7282,6 +7281,7 @@ void free_contig_range(unsigned long pfn
 	WARN(count != 0, "%lu pages are still in use!\n", count);
 }
 EXPORT_SYMBOL(free_contig_range);
+#endif /* CONFIG_CONTIG_ALLOC */
 
 /*
  * Effectively disable pcplists for the zone by setting the high limit to 0
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-page_isolation-introduce-page_is_unmovable.patch
mm-page_alloc-optimize-pfn_range_valid_contig.patch
mm-hugetlb-optimize-replace_free_hugepage_folios.patch
mm-hugetlb_cma-optimize-hugetlb_cma_alloc_frozen_folio.patch
mm-hugetlb_cma-mark-hugetlb_cma_only-as-__ro_after_init.patch

