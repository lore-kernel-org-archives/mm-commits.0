Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF40EB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jul 2023 23:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbjGJXbl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jul 2023 19:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbjGJXbj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2023 19:31:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21A398
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 16:31:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9181A6126D
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 23:31:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8717C433C8;
        Mon, 10 Jul 2023 23:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689031897;
        bh=lbihwK/G0v6EuFsqsUR3w0F8qDLZu5uZjPIgRx29s1g=;
        h=Date:To:From:Subject:From;
        b=Y8ba/qOOJW7Zs3P//j8suObnTX2hZMIpTE9VturKgbSnEKxgqeN0uobvE0gKuCshy
         tCom5X7T8Yc9hwiS5YaO3V1DHTgJvESIw5Ki2o5MsQFvuHPlopyANZHwLogy1T1PLG
         nMEGqUu+Ihe/D/5UitaKt5MfZjob/y9NCXZJPmAk=
Date:   Mon, 10 Jul 2023 16:31:36 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        fengwei.yin@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + rmap-add-folio_add_file_rmap_range.patch added to mm-unstable branch
Message-Id: <20230710233136.E8717C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rmap: add folio_add_file_rmap_range()
has been added to the -mm mm-unstable branch.  Its filename is
     rmap-add-folio_add_file_rmap_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rmap-add-folio_add_file_rmap_range.patch

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
From: Yin Fengwei <fengwei.yin@intel.com>
Subject: rmap: add folio_add_file_rmap_range()
Date: Mon, 10 Jul 2023 21:43:36 +0100

folio_add_file_rmap_range() allows to add pte mapping to a specific range
of file folio.  Comparing to page_add_file_rmap(), it batched updates
__lruvec_stat for large folio.

Link: https://lkml.kernel.org/r/20230710204339.3554919-36-willy@infradead.org
Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +
 mm/rmap.c            |   60 +++++++++++++++++++++++++++++++----------
 2 files changed, 48 insertions(+), 14 deletions(-)

--- a/include/linux/rmap.h~rmap-add-folio_add_file_rmap_range
+++ a/include/linux/rmap.h
@@ -198,6 +198,8 @@ void folio_add_new_anon_rmap(struct foli
 		unsigned long address);
 void page_add_file_rmap(struct page *, struct vm_area_struct *,
 		bool compound);
+void folio_add_file_rmap_range(struct folio *, struct page *, unsigned int nr,
+		struct vm_area_struct *, bool compound);
 void page_remove_rmap(struct page *, struct vm_area_struct *,
 		bool compound);
 
--- a/mm/rmap.c~rmap-add-folio_add_file_rmap_range
+++ a/mm/rmap.c
@@ -1306,31 +1306,39 @@ void folio_add_new_anon_rmap(struct foli
 }
 
 /**
- * page_add_file_rmap - add pte mapping to a file page
- * @page:	the page to add the mapping to
+ * folio_add_file_rmap_range - add pte mapping to page range of a folio
+ * @folio:	The folio to add the mapping to
+ * @page:	The first page to add
+ * @nr_pages:	The number of pages which will be mapped
  * @vma:	the vm area in which the mapping is added
  * @compound:	charge the page as compound or small page
  *
+ * The page range of folio is defined by [first_page, first_page + nr_pages)
+ *
  * The caller needs to hold the pte lock.
  */
-void page_add_file_rmap(struct page *page, struct vm_area_struct *vma,
-		bool compound)
+void folio_add_file_rmap_range(struct folio *folio, struct page *page,
+			unsigned int nr_pages, struct vm_area_struct *vma,
+			bool compound)
 {
-	struct folio *folio = page_folio(page);
 	atomic_t *mapped = &folio->_nr_pages_mapped;
-	int nr = 0, nr_pmdmapped = 0;
-	bool first;
+	unsigned int nr_pmdmapped = 0, first;
+	int nr = 0;
 
-	VM_BUG_ON_PAGE(compound && !PageTransHuge(page), page);
+	VM_WARN_ON_FOLIO(compound && !folio_test_pmd_mappable(folio), folio);
 
 	/* Is page being mapped by PTE? Is this its first map to be added? */
 	if (likely(!compound)) {
-		first = atomic_inc_and_test(&page->_mapcount);
-		nr = first;
-		if (first && folio_test_large(folio)) {
-			nr = atomic_inc_return_relaxed(mapped);
-			nr = (nr < COMPOUND_MAPPED);
-		}
+		do {
+			first = atomic_inc_and_test(&page->_mapcount);
+			if (first && folio_test_large(folio)) {
+				first = atomic_inc_return_relaxed(mapped);
+				first = (first < COMPOUND_MAPPED);
+			}
+
+			if (first)
+				nr++;
+		} while (page++, --nr_pages > 0);
 	} else if (folio_test_pmd_mappable(folio)) {
 		/* That test is redundant: it's for safety or to optimize out */
 
@@ -1360,6 +1368,30 @@ void page_add_file_rmap(struct page *pag
 }
 
 /**
+ * page_add_file_rmap - add pte mapping to a file page
+ * @page:	the page to add the mapping to
+ * @vma:	the vm area in which the mapping is added
+ * @compound:	charge the page as compound or small page
+ *
+ * The caller needs to hold the pte lock.
+ */
+void page_add_file_rmap(struct page *page, struct vm_area_struct *vma,
+		bool compound)
+{
+	struct folio *folio = page_folio(page);
+	unsigned int nr_pages;
+
+	VM_WARN_ON_ONCE_PAGE(compound && !PageTransHuge(page), page);
+
+	if (likely(!compound))
+		nr_pages = 1;
+	else
+		nr_pages = folio_nr_pages(folio);
+
+	folio_add_file_rmap_range(folio, page, nr_pages, vma, compound);
+}
+
+/**
  * page_remove_rmap - take down pte mapping from a page
  * @page:	page to remove mapping from
  * @vma:	the vm area from which the mapping is removed
_

Patches currently in -mm which might be from fengwei.yin@intel.com are

filemap-add-filemap_map_folio_range.patch
rmap-add-folio_add_file_rmap_range.patch
mm-convert-do_set_pte-to-set_pte_range.patch
filemap-batch-pte-mappings.patch

