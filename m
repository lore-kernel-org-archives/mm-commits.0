Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FE4219FC
	for <mm-commits@vger.kernel.org>; Tue, 30 Dec 2025 18:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767118574; cv=none; b=GXKz856jcawFoPHxIGc4iOCZ1bVltCJC2Lq2krFHGLYTO+GoYibe1mFL8NugCGlFGVoMfu3zGKLI7nvIez2PMgJhb+/OX/djbNVBFybPHCokI0atd6P8zu3ofQ/9SUzb/gCILHH4hBLBfJsrCGQBGHDMfSwNG+BpdOBI7F+7BQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767118574; c=relaxed/simple;
	bh=dTDR0bVds/hfZljPIHVY6PebulQYycwF3cFQnuSrleY=;
	h=Date:To:From:Subject:Message-Id; b=KdL4AET53KHA8ovrpdake5edfyUrlvNZgHtO/A+gnOnBVri6bxtu4b6nI8YGaMTygoVtPA/SnwaL3tLutbF8Wb7ZxsdEBH9slKSvmLyJifF+r9TwJBxQaF6Qr7dmO2sjP1mjSPBodsIxdsa1Fvq41KKogBzWUvjQDdZoykwvjuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pXZBMppH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pXZBMppH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E0AC4CEFB;
	Tue, 30 Dec 2025 18:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767118573;
	bh=dTDR0bVds/hfZljPIHVY6PebulQYycwF3cFQnuSrleY=;
	h=Date:To:From:Subject:From;
	b=pXZBMppHmD5KmRtm7ov7DtCs9W7dDiy4bD2JcQtaQokymobOwFDOykAvgUdWN/1b0
	 KNh0VySYne0czVesbXU5WoEiiaj1LK6nqrD3UOXDXisukucF3pd6vr2dauHAEnjhXS
	 pOf7CIpeiQsMIFHbx8mGcDW3v2EmmTPLshQD8/lA=
Date: Tue, 30 Dec 2025 10:16:12 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page.patch added to mm-new branch
Message-Id: <20251230181613.81E0AC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: debug_vm_pgtable: add debug_vm_pgtable_free_huge_page()
has been added to the -mm mm-new branch.  Its filename is
     mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: debug_vm_pgtable: add debug_vm_pgtable_free_huge_page()
Date: Tue, 30 Dec 2025 15:24:17 +0800

Patch series "mm: hugetlb: allocate frozen gigantic folio", v4.

Introduce alloc_contig_frozen_pages() and cma_alloc_frozen_compound()
which avoid atomic operations on page refcounts, and then convert to
allocate frozen gigantic folios with the new helpers in hugetlb to cleanup
alloc_gigantic_folio().


This patch (of 6):

Add a new helper to free huge page to be consistency to
debug_vm_pgtable_alloc_huge_page(), and use HPAGE_PUD_ORDER instead of
open-code.

Also move the free_contig_range() under CONFIG_ALLOC_CONTIG since all
caller are built with CONFIG_ALLOC_CONTIG.

Link: https://lkml.kernel.org/r/20251230072422.265265-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20251230072422.265265-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h   |    2 +-
 mm/debug_vm_pgtable.c |   38 +++++++++++++++++---------------------
 mm/page_alloc.c       |    2 +-
 3 files changed, 19 insertions(+), 23 deletions(-)

--- a/include/linux/gfp.h~mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page
+++ a/include/linux/gfp.h
@@ -438,8 +438,8 @@ extern struct page *alloc_contig_pages_n
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
@@ -7248,7 +7248,6 @@ retry:
 	}
 	return NULL;
 }
-#endif /* CONFIG_CONTIG_ALLOC */
 
 void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 {
@@ -7275,6 +7274,7 @@ void free_contig_range(unsigned long pfn
 	WARN(count != 0, "%lu pages are still in use!\n", count);
 }
 EXPORT_SYMBOL(free_contig_range);
+#endif /* CONFIG_CONTIG_ALLOC */
 
 /*
  * Effectively disable pcplists for the zone by setting the high limit to 0
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page.patch
mm-page_alloc-add-__split_page.patch
mm-cma-kill-cma_pages_valid.patch
mm-page_alloc-add-alloc_contig_frozen_rangepages.patch
mm-cma-add-cma_alloc_frozen_compound.patch
mm-hugetlb-allocate-frozen-pages-for-gigantic-allocation.patch

