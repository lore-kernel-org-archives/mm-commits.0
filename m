From: akpm@linux-foundation.org
Subject: [folded-merged] mm-gup-track-foll_pin-pages-fix-2.patch
 removed from -mm tree
Date: Wed, 01 Apr 2020 20:25:24 -0700
Message-ID: <20200402032524.o9D9p_Kjh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732664AbgDBDZ0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 1 Apr 2020 23:25:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: imbrenda@linux.ibm.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: fixup for 9947ea2c1e608e32 "mm/gup: track FOLL_PIN pages"
has been removed from the -mm tree.  Its filename was
     mm-gup-track-foll_pin-pages-fix-2.patch

This patch was dropped because it was folded into mm-gup-track-foll_pin-pages.patch

------------------------------------------------------
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: mm/gup: fixup for 9947ea2c1e608e32 "mm/gup: track FOLL_PIN pages"

In case pin fails, we need to unpin, a simple put_page will not be enough

fixup for commit 9947ea2c1e608e32 ("mm/gup: track FOLL_PIN pages")

it can be simply squashed in

Link: http://lkml.kernel.org/r/20200306132537.783769-2-imbrenda@linux.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/mm/gup.c~mm-gup-track-foll_pin-pages-fix-2
+++ a/mm/gup.c
@@ -78,6 +78,21 @@ static __maybe_unused struct page *try_g
 	return NULL;
 }
 
+static void put_compound_head(struct page *page, int refs, unsigned int flags)
+{
+	if (flags & FOLL_PIN)
+		refs *= GUP_PIN_COUNTING_BIAS;
+
+	VM_BUG_ON_PAGE(page_ref_count(page) < refs, page);
+	/*
+	 * Calling put_page() for each ref is unnecessarily slow. Only the last
+	 * ref needs a put_page().
+	 */
+	if (refs > 1)
+		page_ref_sub(page, refs - 1);
+	put_page(page);
+}
+
 /**
  * try_grab_page() - elevate a page's refcount by a flag-dependent amount
  *
@@ -2065,7 +2080,7 @@ static int gup_pte_range(pmd_t pmd, unsi
 			goto pte_unmap;
 
 		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
-			put_page(head);
+			put_compound_head(head, 1, flags);
 			goto pte_unmap;
 		}
 
@@ -2198,21 +2213,6 @@ static int record_subpages(struct page *
 	return nr;
 }
 
-static void put_compound_head(struct page *page, int refs, unsigned int flags)
-{
-	if (flags & FOLL_PIN)
-		refs *= GUP_PIN_COUNTING_BIAS;
-
-	VM_BUG_ON_PAGE(page_ref_count(page) < refs, page);
-	/*
-	 * Calling put_page() for each ref is unnecessarily slow. Only the last
-	 * ref needs a put_page().
-	 */
-	if (refs > 1)
-		page_ref_sub(page, refs - 1);
-	put_page(page);
-}
