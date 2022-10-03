Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E6CC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiJCVIP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiJCVGV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:06:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E6E4D16B
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E0BD610E7
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F230EC433D6;
        Mon,  3 Oct 2022 21:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831138;
        bh=kkhgWGhyKzksgw2YDa4bLJVc4kIyoIFukMQZuW0MFfI=;
        h=Date:To:From:Subject:From;
        b=cN3fySWYk75RlteY/14W7arjK4KO1+dcxxmSHbK/u0bMRHM1dQhyJOWJihHG725j1
         SqV3kfQWsb0pY1ZpIUiULkmPKqdilqbjcPWqcGWhBKGNoVRNHpQtxMUSw6ko2zZ2z+
         0bKSS8y+UJO61RZUvoEKP890zYJ2e3lKs9cW03ns=
Date:   Mon, 03 Oct 2022 14:05:37 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-page_get_anon_vma-to-folio_get_anon_vma.patch removed from -mm tree
Message-Id: <20221003210537.F230EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert page_get_anon_vma() to folio_get_anon_vma()
has been removed from the -mm tree.  Its filename was
     mm-convert-page_get_anon_vma-to-folio_get_anon_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert page_get_anon_vma() to folio_get_anon_vma()
Date: Fri, 2 Sep 2022 20:46:50 +0100

With all callers now passing in a folio, rename the function and convert
all callers.  Removes a couple of calls to compound_head() and a reference
to page->mapping.

Link: https://lkml.kernel.org/r/20220902194653.1739778-55-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +-
 mm/huge_memory.c     |    2 +-
 mm/migrate.c         |    6 +++---
 mm/rmap.c            |   14 +++++++-------
 4 files changed, 12 insertions(+), 12 deletions(-)

--- a/include/linux/rmap.h~mm-convert-page_get_anon_vma-to-folio_get_anon_vma
+++ a/include/linux/rmap.h
@@ -163,7 +163,7 @@ static inline void anon_vma_merge(struct
 	unlink_anon_vmas(next);
 }
 
-struct anon_vma *page_get_anon_vma(struct page *page);
+struct anon_vma *folio_get_anon_vma(struct folio *folio);
 
 /* RMAP flags, currently only relevant for some anon rmap operations. */
 typedef int __bitwise rmap_t;
--- a/mm/huge_memory.c~mm-convert-page_get_anon_vma-to-folio_get_anon_vma
+++ a/mm/huge_memory.c
@@ -2649,7 +2649,7 @@ int split_huge_page_to_list(struct page
 		 * is taken to serialise against parallel split or collapse
 		 * operations.
 		 */
-		anon_vma = page_get_anon_vma(&folio->page);
+		anon_vma = folio_get_anon_vma(folio);
 		if (!anon_vma) {
 			ret = -EBUSY;
 			goto out;
--- a/mm/migrate.c~mm-convert-page_get_anon_vma-to-folio_get_anon_vma
+++ a/mm/migrate.c
@@ -1052,14 +1052,14 @@ static int __unmap_and_move(struct folio
 	 * File Caches may use write_page() or lock_page() in migration, then,
 	 * just care Anon page here.
 	 *
-	 * Only page_get_anon_vma() understands the subtleties of
+	 * Only folio_get_anon_vma() understands the subtleties of
 	 * getting a hold on an anon_vma from outside one of its mms.
 	 * But if we cannot get anon_vma, then we won't need it anyway,
 	 * because that implies that the anon page is no longer mapped
 	 * (and cannot be remapped so long as we hold the page lock).
 	 */
 	if (folio_test_anon(src) && !folio_test_ksm(src))
-		anon_vma = page_get_anon_vma(&src->page);
+		anon_vma = folio_get_anon_vma(src);
 
 	/*
 	 * Block others from accessing the new page when we get around to
@@ -1298,7 +1298,7 @@ static int unmap_and_move_huge_page(new_
 	}
 
 	if (folio_test_anon(src))
-		anon_vma = page_get_anon_vma(&src->page);
+		anon_vma = folio_get_anon_vma(src);
 
 	if (unlikely(!folio_trylock(dst)))
 		goto put_anon;
--- a/mm/rmap.c~mm-convert-page_get_anon_vma-to-folio_get_anon_vma
+++ a/mm/rmap.c
@@ -486,16 +486,16 @@ void __init anon_vma_init(void)
  * if there is a mapcount, we can dereference the anon_vma after observing
  * those.
  */
-struct anon_vma *page_get_anon_vma(struct page *page)
+struct anon_vma *folio_get_anon_vma(struct folio *folio)
 {
 	struct anon_vma *anon_vma = NULL;
 	unsigned long anon_mapping;
 
 	rcu_read_lock();
-	anon_mapping = (unsigned long)READ_ONCE(page->mapping);
+	anon_mapping = (unsigned long)READ_ONCE(folio->mapping);
 	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
 		goto out;
-	if (!page_mapped(page))
+	if (!folio_mapped(folio))
 		goto out;
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
@@ -505,13 +505,13 @@ struct anon_vma *page_get_anon_vma(struc
 	}
 
 	/*
-	 * If this page is still mapped, then its anon_vma cannot have been
+	 * If this folio is still mapped, then its anon_vma cannot have been
 	 * freed.  But if it has been unmapped, we have no security against the
 	 * anon_vma structure being freed and reused (for another anon_vma:
 	 * SLAB_TYPESAFE_BY_RCU guarantees that - so the atomic_inc_not_zero()
 	 * above cannot corrupt).
 	 */
-	if (!page_mapped(page)) {
+	if (!folio_mapped(folio)) {
 		rcu_read_unlock();
 		put_anon_vma(anon_vma);
 		return NULL;
@@ -523,11 +523,11 @@ out:
 }
 
 /*
- * Similar to page_get_anon_vma() except it locks the anon_vma.
+ * Similar to folio_get_anon_vma() except it locks the anon_vma.
  *
  * Its a little more complex as it tries to keep the fast path to a single
  * atomic op -- the trylock. If we fail the trylock, we fall back to getting a
- * reference like with page_get_anon_vma() and then block on the mutex
+ * reference like with folio_get_anon_vma() and then block on the mutex
  * on !rwc->try_lock case.
  */
 struct anon_vma *folio_lock_anon_vma_read(struct folio *folio,
_

Patches currently in -mm which might be from willy@infradead.org are


