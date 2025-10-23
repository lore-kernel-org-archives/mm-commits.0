Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B4B2C11D5
	for <mm-commits@vger.kernel.org>; Thu, 23 Oct 2025 20:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761250201; cv=none; b=bWvHTl1cGJ3M/LvrKk5FJZ8c0oUMfWOKI/RE+6c0mRS01Meze9wJ4VDjdPuEv0ISKMEQ3j0Gp/X2RXazaNy0pGs0qIqcj2G2MfFsxpaLfF2u5w1PHjanNYSBcxCAIfYXSifvNshWcXQg2Inj9rWEkzJKFVISLroR++JEQDB6sk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761250201; c=relaxed/simple;
	bh=yxTuWwiXjanZqx2AV8ZcKwawCEbgxKY3zVmAXHyGCvc=;
	h=Date:To:From:Subject:Message-Id; b=XDWJAOQ4TRWSz3OsteLCPssdIgDi/FeXLpHp43LX6gE8RLrIokPXiLmFA6cjh5PziwpKTk3n4bPow2PVgdj/kZFfviiT6doq1roSaDVGKX0V8uqYRf8k0eMsmnYp5b1LjUW3/atBJriB7mIH/dR0Y9TMO2P+wpAJVDTbRLIQ3LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CQ6XfQ2G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CQ6XfQ2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5705FC4CEE7;
	Thu, 23 Oct 2025 20:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761250201;
	bh=yxTuWwiXjanZqx2AV8ZcKwawCEbgxKY3zVmAXHyGCvc=;
	h=Date:To:From:Subject:From;
	b=CQ6XfQ2GyUui2meHcrykS80NcK4jx75cdPpGvR+NONuy54VV5XgFdAedkyyEq0x9R
	 19jbE8gMQicTPVEK3wBgg2fhu4jG+4p/Ya1NhYC9EOaOFHyGcIpiEbtuHU+sWcls3a
	 l7Q6rH1Ubcf5qfp/ZnlxB3MugclAYD0rV3rPjmKk=
Date: Thu, 23 Oct 2025 13:10:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page.patch added to mm-new branch
Message-Id: <20251023201001.5705FC4CEE7@smtp.kernel.org>
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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: debug_vm_pgtable: add debug_vm_pgtable_free_huge_page()
Date: Thu, 23 Oct 2025 19:59:35 +0800

Patch series "mm: hugetlb: allocate frozen gigantic folio", v4.

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

Link: https://lkml.kernel.org/r/20251023115940.3573158-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20251023115940.3573158-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
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
@@ -958,22 +958,26 @@ static unsigned long __init get_random_v
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
@@ -982,20 +986,13 @@ static void __init destroy_args(struct p
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
@@ -1227,8 +1224,7 @@ static int __init init_args(struct pgtab
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
@@ -7151,7 +7151,6 @@ struct page *alloc_contig_pages_noprof(u
 	}
 	return NULL;
 }
-#endif /* CONFIG_CONTIG_ALLOC */
 
 void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 {
@@ -7178,6 +7177,7 @@ void free_contig_range(unsigned long pfn
 	WARN(count != 0, "%lu pages are still in use!\n", count);
 }
 EXPORT_SYMBOL(free_contig_range);
+#endif /* CONFIG_CONTIG_ALLOC */
 
 /*
  * Effectively disable pcplists for the zone by setting the high limit to 0
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-mprotect-always-skip-dma-pinned-folio-in-prot_numa_skip.patch
mm-mprotect-avoid-unnecessary-struct-page-accessing-if-pte_protnone.patch
mm-huge_memory-use-folio_skip_prot_numa-for-pmd-folio.patch
mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page.patch
mm-page_alloc-add-__split_page.patch
mm-cma-add-__cma_release.patch
mm-page_alloc-add-alloc_contig_frozen_rangepages.patch
mm-cma-add-cma_alloc_frozen_compound.patch
mm-hugetlb-allocate-frozen-pages-in-alloc_gigantic_folio.patch

