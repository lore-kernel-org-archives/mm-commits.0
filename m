Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 494ADC001DC
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jul 2023 17:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjGTRN6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jul 2023 13:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjGTRN5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jul 2023 13:13:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42ADDB4
        for <mm-commits@vger.kernel.org>; Thu, 20 Jul 2023 10:13:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB79561B8F
        for <mm-commits@vger.kernel.org>; Thu, 20 Jul 2023 17:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27ECCC433C8;
        Thu, 20 Jul 2023 17:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689873235;
        bh=Hn7+e3/a1dBPMFEEe3zh/jd7nYUzPkxK8/85I9M8508=;
        h=Date:To:From:Subject:From;
        b=siAME0Kcm8UFjMeWUYGMzITNIdpM7iHiC4TNbyX278cl6fQK2JCv+yclzZvBv/feX
         vPs892B61qoyeTZ+cj10sIvS+dOgZ6V4TIED7iUxODh9PjFrm+hZQj2Dxzm2QbY+G1
         0MLLbUN1vf9COhOan8/4ZwLovTTXdPZS66KJcWro=
Date:   Thu, 20 Jul 2023 10:13:54 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, shy828301@gmail.com,
        fengwei.yin@intel.com, david@redhat.com, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-implement-folio_remove_rmap_range.patch added to mm-unstable branch
Message-Id: <20230720171355.27ECCC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: implement folio_remove_rmap_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-implement-folio_remove_rmap_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-implement-folio_remove_rmap_range.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: implement folio_remove_rmap_range()
Date: Thu, 20 Jul 2023 12:29:54 +0100

Like page_remove_rmap() but batch-removes the rmap for a range of pages
belonging to a folio.  This can provide a small speedup due to less
manipuation of the various counters.  But more crucially, if removing the
rmap for all pages of a folio in a batch, there is no need to (spuriously)
add it to the deferred split list, which saves significant cost when there
is contention for the split queue lock.

All contained pages are accounted using the order-0 folio (or base page)
scheme.

page_remove_rmap() is refactored so that it forwards to
folio_remove_rmap_range() for !compound cases, and both functions now
share a common epilogue function. The intention here is to avoid
duplication of code.

Link: https://lkml.kernel.org/r/20230720112955.643283-3-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 
 mm/rmap.c            |  125 +++++++++++++++++++++++++++++++----------
 2 files changed, 97 insertions(+), 30 deletions(-)

--- a/include/linux/rmap.h~mm-implement-folio_remove_rmap_range
+++ a/include/linux/rmap.h
@@ -200,6 +200,8 @@ void page_add_file_rmap(struct page *, s
 		bool compound);
 void page_remove_rmap(struct page *, struct vm_area_struct *,
 		bool compound);
+void folio_remove_rmap_range(struct folio *folio, struct page *page,
+		int nr, struct vm_area_struct *vma);
 
 void hugepage_add_anon_rmap(struct page *, struct vm_area_struct *,
 		unsigned long address, rmap_t flags);
--- a/mm/rmap.c~mm-implement-folio_remove_rmap_range
+++ a/mm/rmap.c
@@ -1348,6 +1348,94 @@ void page_add_file_rmap(struct page *pag
 }
 
 /**
+ * __remove_rmap_finish - common operations when taking down a mapping.
+ * @folio:	Folio containing all pages taken down.
+ * @vma:	The VM area containing the range.
+ * @compound:	True if pages were taken down from PMD or false if from PTE(s).
+ * @nr_unmapped: Number of pages within folio that are now unmapped.
+ * @nr_mapped:	Number of pages within folio that are still mapped.
+ */
+static void __remove_rmap_finish(struct folio *folio,
+				struct vm_area_struct *vma, bool compound,
+				int nr_unmapped, int nr_mapped)
+{
+	enum node_stat_item idx;
+
+	if (nr_unmapped) {
+		idx = folio_test_anon(folio) ? NR_ANON_MAPPED : NR_FILE_MAPPED;
+		__lruvec_stat_mod_folio(folio, idx, -nr_unmapped);
+
+		/*
+		 * Queue large anon folio for deferred split if at least one
+		 * page of the folio is unmapped and at least one page is still
+		 * mapped.
+		 */
+		if (folio_test_large(folio) &&
+		    folio_test_anon(folio) && nr_mapped)
+			deferred_split_folio(folio);
+	}
+
+	/*
+	 * It would be tidy to reset folio_test_anon mapping when fully
+	 * unmapped, but that might overwrite a racing page_add_anon_rmap
+	 * which increments mapcount after us but sets mapping before us:
+	 * so leave the reset to free_pages_prepare, and remember that
+	 * it's only reliable while mapped.
+	 */
+
+	munlock_vma_folio(folio, vma, compound);
+}
+
+/**
+ * folio_remove_rmap_range - Take down PTE mappings from a range of pages.
+ * @folio:	Folio containing all pages in range.
+ * @page:	First page in range to unmap.
+ * @nr:		Number of pages to unmap.
+ * @vma:	The VM area containing the range.
+ *
+ * All pages in the range must belong to the same VMA & folio. They must be
+ * mapped with PTEs, not a PMD.
+ *
+ * Context: Caller holds the pte lock.
+ */
+void folio_remove_rmap_range(struct folio *folio, struct page *page,
+					int nr, struct vm_area_struct *vma)
+{
+	atomic_t *mapped = &folio->_nr_pages_mapped;
+	int nr_unmapped = 0;
+	int nr_mapped = 0;
+	bool last;
+
+	if (unlikely(folio_test_hugetlb(folio))) {
+		VM_WARN_ON_FOLIO(1, folio);
+		return;
+	}
+
+	VM_WARN_ON_ONCE(page < &folio->page ||
+			page + nr > (&folio->page + folio_nr_pages(folio)));
+
+	if (!folio_test_large(folio)) {
+		/* Is this the page's last map to be removed? */
+		last = atomic_add_negative(-1, &page->_mapcount);
+		nr_unmapped = last;
+	} else {
+		for (; nr != 0; nr--, page++) {
+			/* Is this the page's last map to be removed? */
+			last = atomic_add_negative(-1, &page->_mapcount);
+			if (last)
+				nr_unmapped++;
+		}
+
+		/* Pages still mapped if folio mapped entirely */
+		nr_mapped = atomic_sub_return_relaxed(nr_unmapped, mapped);
+		if (nr_mapped >= COMPOUND_MAPPED)
+			nr_unmapped = 0;
+	}
+
+	__remove_rmap_finish(folio, vma, false, nr_unmapped, nr_mapped);
+}
+
+/**
  * page_remove_rmap - take down pte mapping from a page
  * @page:	page to remove mapping from
  * @vma:	the vm area from which the mapping is removed
@@ -1373,15 +1461,13 @@ void page_remove_rmap(struct page *page,
 		return;
 	}
 
-	/* Is page being unmapped by PTE? Is this its last map to be removed? */
+	/* Is page being unmapped by PTE? */
 	if (likely(!compound)) {
-		last = atomic_add_negative(-1, &page->_mapcount);
-		nr = last;
-		if (last && folio_test_large(folio)) {
-			nr = atomic_dec_return_relaxed(mapped);
-			nr = (nr < COMPOUND_MAPPED);
-		}
-	} else if (folio_test_pmd_mappable(folio)) {
+		folio_remove_rmap_range(folio, page, 1, vma);
+		return;
+	}
+
+	if (folio_test_pmd_mappable(folio)) {
 		/* That test is redundant: it's for safety or to optimize out */
 
 		last = atomic_add_negative(-1, &folio->_entire_mapcount);
@@ -1409,29 +1495,8 @@ void page_remove_rmap(struct page *page,
 			idx = NR_FILE_PMDMAPPED;
 		__lruvec_stat_mod_folio(folio, idx, -nr_pmdmapped);
 	}
-	if (nr) {
-		idx = folio_test_anon(folio) ? NR_ANON_MAPPED : NR_FILE_MAPPED;
-		__lruvec_stat_mod_folio(folio, idx, -nr);
-
-		/*
-		 * Queue anon large folio for deferred split if at least one
-		 * page of the folio is unmapped and at least one page
-		 * is still mapped.
-		 */
-		if (folio_test_large(folio) && folio_test_anon(folio))
-			if (!compound || nr < nr_pmdmapped)
-				deferred_split_folio(folio);
-	}
 
-	/*
-	 * It would be tidy to reset folio_test_anon mapping when fully
-	 * unmapped, but that might overwrite a racing page_add_anon_rmap
-	 * which increments mapcount after us but sets mapping before us:
-	 * so leave the reset to free_pages_prepare, and remember that
-	 * it's only reliable while mapped.
-	 */
-
-	munlock_vma_folio(folio, vma, compound);
+	__remove_rmap_finish(folio, vma, compound, nr, nr_pmdmapped - nr);
 }
 
 /*
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-allow-deferred-splitting-of-arbitrary-large-anon-folios.patch
mm-implement-folio_remove_rmap_range.patch
mm-batch-zap-large-anonymous-folio-pte-mappings.patch

