Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F48CC63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbjBCGgE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232089AbjBCGfm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD697E691
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A0AC61DA7
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC2BC4339C;
        Fri,  3 Feb 2023 06:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406140;
        bh=hxIdUJaj1+meIQWZiKZPbRuD6q3BX/peq/aGK4FI/gY=;
        h=Date:To:From:Subject:From;
        b=KC812BH8YDYBE1WrPxNg2rEx7280RLavHQcieSpAjWFHundNk68AQ6dp26S/qoizx
         IPeSkB3u9ntiPXNqBs9SkvmG9hGcVuscO2XMgGLDiONHEwm2kPInNRXkEvUMC9RD4d
         wzI1Twtd5jnAUr9byYLjA2TrSO03cYXybv6adtX8=
Date:   Thu, 02 Feb 2023 22:35:39 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-folio_add_new_anon_rmap.patch removed from -mm tree
Message-Id: <20230203063540.7CC2BC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add folio_add_new_anon_rmap()
has been removed from the -mm tree.  Its filename was
     mm-add-folio_add_new_anon_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add folio_add_new_anon_rmap()
Date: Wed, 11 Jan 2023 14:28:54 +0000

In contrast to other rmap functions, page_add_new_anon_rmap() is always
called with a freshly allocated page.  That means it can't be called with
a tail page.  Turn page_add_new_anon_rmap() into folio_add_new_anon_rmap()
and add a page_add_new_anon_rmap() wrapper.  Callers can be converted
individually.

[akpm@linux-foundation.org: fix NOMMU build.  page_add_new_anon_rmap() requires CONFIG_MMU]
[willy@infradead.org: folio-compat.c needs rmap.h]
Link: https://lkml.kernel.org/r/20230111142915.1001531-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/rmap.h~mm-add-folio_add_new_anon_rmap
+++ a/include/linux/rmap.h
@@ -194,6 +194,8 @@ void page_add_anon_rmap(struct page *, s
 		unsigned long address, rmap_t flags);
 void page_add_new_anon_rmap(struct page *, struct vm_area_struct *,
 		unsigned long address);
+void folio_add_new_anon_rmap(struct folio *, struct vm_area_struct *,
+		unsigned long address);
 void page_add_file_rmap(struct page *, struct vm_area_struct *,
 		bool compound);
 void page_remove_rmap(struct page *, struct vm_area_struct *,
--- a/mm/folio-compat.c~mm-add-folio_add_new_anon_rmap
+++ a/mm/folio-compat.c
@@ -6,6 +6,7 @@
 
 #include <linux/migrate.h>
 #include <linux/pagemap.h>
+#include <linux/rmap.h>
 #include <linux/swap.h>
 #include "internal.h"
 
@@ -123,3 +124,13 @@ void putback_lru_page(struct page *page)
 {
 	folio_putback_lru(page_folio(page));
 }
+
+#ifdef CONFIG_MMU
+void page_add_new_anon_rmap(struct page *page, struct vm_area_struct *vma,
+		unsigned long address)
+{
+	VM_BUG_ON_PAGE(PageTail(page), page);
+
+	return folio_add_new_anon_rmap((struct folio *)page, vma, address);
+}
+#endif
--- a/mm/rmap.c~mm-add-folio_add_new_anon_rmap
+++ a/mm/rmap.c
@@ -1264,41 +1264,40 @@ void page_add_anon_rmap(struct page *pag
 }
 
 /**
- * page_add_new_anon_rmap - add mapping to a new anonymous page
- * @page:	the page to add the mapping to
+ * folio_add_new_anon_rmap - Add mapping to a new anonymous folio.
+ * @folio:	The folio to add the mapping to.
  * @vma:	the vm area in which the mapping is added
  * @address:	the user virtual address mapped
  *
- * If it's a compound page, it is accounted as a compound page. As the page
- * is new, it's assume to get mapped exclusively by a single process.
- *
- * Same as page_add_anon_rmap but must only be called on *new* pages.
+ * Like page_add_anon_rmap() but must only be called on *new* folios.
  * This means the inc-and-test can be bypassed.
- * Page does not have to be locked.
+ * The folio does not have to be locked.
+ *
+ * If the folio is large, it is accounted as a THP.  As the folio
+ * is new, it's assumed to be mapped exclusively by a single process.
  */
-void page_add_new_anon_rmap(struct page *page,
-	struct vm_area_struct *vma, unsigned long address)
+void folio_add_new_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
+		unsigned long address)
 {
 	int nr;
 
 	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
-	__SetPageSwapBacked(page);
+	__folio_set_swapbacked(folio);
 
-	if (likely(!PageCompound(page))) {
+	if (likely(!folio_test_pmd_mappable(folio))) {
 		/* increment count (starts at -1) */
-		atomic_set(&page->_mapcount, 0);
+		atomic_set(&folio->_mapcount, 0);
 		nr = 1;
 	} else {
-		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 		/* increment count (starts at -1) */
-		atomic_set(compound_mapcount_ptr(page), 0);
-		atomic_set(subpages_mapcount_ptr(page), COMPOUND_MAPPED);
-		nr = thp_nr_pages(page);
-		__mod_lruvec_page_state(page, NR_ANON_THPS, nr);
+		atomic_set(&folio->_entire_mapcount, 0);
+		atomic_set(&folio->_nr_pages_mapped, COMPOUND_MAPPED);
+		nr = folio_nr_pages(folio);
+		__lruvec_stat_mod_folio(folio, NR_ANON_THPS, nr);
 	}
 
-	__mod_lruvec_page_state(page, NR_ANON_MAPPED, nr);
-	__page_set_anon_rmap(page, vma, address, 1);
+	__lruvec_stat_mod_folio(folio, NR_ANON_MAPPED, nr);
+	__page_set_anon_rmap(&folio->page, vma, address, 1);
 }
 
 /**
_

Patches currently in -mm which might be from willy@infradead.org are


