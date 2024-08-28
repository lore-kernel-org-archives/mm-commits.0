Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA4011CA0
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 00:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724806379; cv=none; b=jvxfEcF10vWRvG260ITIrWCaqB+qsJW74YWhU2THZdgPi+hEzxECc+DM2TPKDzIfKOTGn2r45TVjDfvFjOkfw/zp4ehEyuQlTe/WNRyMnXWeZDj4XiWz3FGXGCekmghhddswu2o3nX8QoJ1BoFlgU1vKeWMdVaxBTsh/RDMXuDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724806379; c=relaxed/simple;
	bh=Z3F3AVKvrr4J5z9bb0x3rRhj7K4PTIVEsiNfYNNoeHU=;
	h=Date:To:From:Subject:Message-Id; b=h2x9UnBwwvX2dbH2Zpne4H0dkizvlrCCPNhhO3eNMO3255tw4rGBpeUpPHNDGrIT/Qmn9hn7YnQgVDlHfsfzRDzBKrD5R9njKXnzm+qUJdzm5MpxJKzXu7FeWp7LyxDdok1mvcaG76JXyqADA1mRiKGg29qN+fQUsoSvdnXRges=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UzPnHT6J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UzPnHT6J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F103C4AF0E;
	Wed, 28 Aug 2024 00:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724806379;
	bh=Z3F3AVKvrr4J5z9bb0x3rRhj7K4PTIVEsiNfYNNoeHU=;
	h=Date:To:From:Subject:From;
	b=UzPnHT6JBtQkG+ytcMpvXGPnZsqzvQWFzXZ18w1JNa8koMrZrQmORFjGJ3slD1rhA
	 eLY4/TXdzkn1E6p0mdM187Z9OSHL0PTsgBhnElPSq6nSo08YHGc6fIIclkR5B6dw7x
	 DvDT+6nttWg96NWTRR3bX3zmEcqQmGc0ESdQ+1mM=
Date: Tue, 27 Aug 2024 17:52:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-convert-to-migrate_device_coherent_folio.patch added to mm-unstable branch
Message-Id: <20240828005259.3F103C4AF0E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate_device: convert to migrate_device_coherent_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate_device-convert-to-migrate_device_coherent_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-convert-to-migrate_device_coherent_folio.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: migrate_device: convert to migrate_device_coherent_folio()
Date: Mon, 26 Aug 2024 14:58:09 +0800

Patch series "mm: finish isolate/putback_lru_page()".

Convert to use more folios in migrate_device.c, then we could remove
isolate_lru_page() and putback_lru_page().  


This patch (of 6):

Save a few calls to compound_head() and use folio throughout.

Link: https://lkml.kernel.org/r/20240826065814.1336616-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240826065814.1336616-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c            |    2 +-
 mm/internal.h       |    2 +-
 mm/migrate_device.c |   30 +++++++++++++++---------------
 3 files changed, 17 insertions(+), 17 deletions(-)

--- a/mm/gup.c~mm-migrate_device-convert-to-migrate_device_coherent_folio
+++ a/mm/gup.c
@@ -2335,7 +2335,7 @@ static int migrate_longterm_unpinnable_f
 			folio_get(folio);
 			gup_put_folio(folio, 1, FOLL_PIN);
 
-			if (migrate_device_coherent_page(&folio->page)) {
+			if (migrate_device_coherent_folio(folio)) {
 				ret = -EBUSY;
 				goto err;
 			}
--- a/mm/internal.h~mm-migrate_device-convert-to-migrate_device_coherent_folio
+++ a/mm/internal.h
@@ -1208,7 +1208,7 @@ int numa_migrate_check(struct folio *fol
 		      int *last_cpupid);
 
 void free_zone_device_folio(struct folio *folio);
-int migrate_device_coherent_page(struct page *page);
+int migrate_device_coherent_folio(struct folio *folio);
 
 /*
  * mm/gup.c
--- a/mm/migrate_device.c~mm-migrate_device-convert-to-migrate_device_coherent_folio
+++ a/mm/migrate_device.c
@@ -708,7 +708,7 @@ static void __migrate_device_pages(unsig
 
 			/*
 			 * The only time there is no vma is when called from
-			 * migrate_device_coherent_page(). However this isn't
+			 * migrate_device_coherent_folio(). However this isn't
 			 * called if the page could not be unmapped.
 			 */
 			VM_BUG_ON(!migrate);
@@ -921,38 +921,38 @@ int migrate_device_range(unsigned long *
 EXPORT_SYMBOL(migrate_device_range);
 
 /*
- * Migrate a device coherent page back to normal memory. The caller should have
- * a reference on page which will be copied to the new page if migration is
+ * Migrate a device coherent folio back to normal memory. The caller should have
+ * a reference on folio which will be copied to the new folio if migration is
  * successful or dropped on failure.
  */
-int migrate_device_coherent_page(struct page *page)
+int migrate_device_coherent_folio(struct folio *folio)
 {
 	unsigned long src_pfn, dst_pfn = 0;
-	struct page *dpage;
+	struct folio *dfolio;
 
-	WARN_ON_ONCE(PageCompound(page));
+	WARN_ON_ONCE(folio_test_large(folio));
 
-	lock_page(page);
-	src_pfn = migrate_pfn(page_to_pfn(page)) | MIGRATE_PFN_MIGRATE;
+	folio_lock(folio);
+	src_pfn = migrate_pfn(folio_pfn(folio)) | MIGRATE_PFN_MIGRATE;
 
 	/*
 	 * We don't have a VMA and don't need to walk the page tables to find
-	 * the source page. So call migrate_vma_unmap() directly to unmap the
-	 * page as migrate_vma_setup() will fail if args.vma == NULL.
+	 * the source folio. So call migrate_vma_unmap() directly to unmap the
+	 * folio as migrate_vma_setup() will fail if args.vma == NULL.
 	 */
 	migrate_device_unmap(&src_pfn, 1, NULL);
 	if (!(src_pfn & MIGRATE_PFN_MIGRATE))
 		return -EBUSY;
 
-	dpage = alloc_page(GFP_USER | __GFP_NOWARN);
-	if (dpage) {
-		lock_page(dpage);
-		dst_pfn = migrate_pfn(page_to_pfn(dpage));
+	dfolio = folio_alloc(GFP_USER | __GFP_NOWARN, 0);
+	if (dfolio) {
+		folio_lock(dfolio);
+		dst_pfn = migrate_pfn(folio_pfn(dfolio));
 	}
 
 	migrate_device_pages(&src_pfn, &dst_pfn, 1);
 	if (src_pfn & MIGRATE_PFN_MIGRATE)
-		copy_highpage(dpage, page);
+		folio_copy(dfolio, folio);
 	migrate_device_finalize(&src_pfn, &dst_pfn, 1);
 
 	if (src_pfn & MIGRATE_PFN_MIGRATE)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch
mm-remove-migration-for-hugepage-in-isolate_single_pageblock.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
mm-memory-failure-add-unmap_poisoned_folio.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch
mm-migrate-add-isolate_folio_to_list.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch
mm-migrate_device-convert-to-migrate_device_coherent_folio.patch
mm-migrate_device-use-a-folio-in-migrate_device_range.patch
mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch
mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch
mm-remove-isolate_lru_page.patch
mm-remove-isolate_lru_page-fix.patch
mm-remove-putback_lru_page.patch

