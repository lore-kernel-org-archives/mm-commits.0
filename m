Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FE66AFAE
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423530; cv=none; b=g1QDFsAuJ+NIC+IAZx+gLYrviFfdRzcFZ/2NZSkcazF3kdpkrGPHKMjXIXnyoPFsq9oT8DlwiRaZ2VH4tZ5e8A8bzDLoOXp/ikg/+S71nant+PwZ2X63xgP+VLMwEqi9ZuXakHjoEqlhSR8bs5ui+WAFWRfiXlP63DqZlmIgGLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423530; c=relaxed/simple;
	bh=KZNJmkXqdpTStXfgqdm8KF/RfbR4lRk25ZA6rkKExk8=;
	h=Date:To:From:Subject:Message-Id; b=RgEo9AsaOGdM9qdzA8JSlZcVgoSPMwYQzm0SXkeB8JlE+IDOZNkIOYX+rPuTkoJ10FmuJqnDTQD/hR+N3Fp41zw/YiNDzRjqtaGQTWrX6wK0rpboEQYr0J59c0RsmjZbKh0rngrrQNz+Id9tbf7gUmX3+Jj1mFd9CMHUHZ84VD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hRZA7j5a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hRZA7j5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9FCC4CEC2;
	Wed,  4 Sep 2024 04:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423529;
	bh=KZNJmkXqdpTStXfgqdm8KF/RfbR4lRk25ZA6rkKExk8=;
	h=Date:To:From:Subject:From;
	b=hRZA7j5aYPzEoKbabLcWKaE8h/HHCaSFWnbRmWn47hpG6tJApRgMqZODtAva6qtW5
	 oE+6RhKMUQKYUpOiSy/gsKHzO2pqmHDT5abKYogXwurLaKzVfv2x6KOahwfwNhE8t7
	 dR3IHXbe0TWIHhZIzOkdHP5we8da/7Ll+O8wkPYQ=
Date: Tue, 03 Sep 2024 21:18:49 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-pageunevictable.patch removed from -mm tree
Message-Id: <20240904041849.DC9FCC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove PageUnevictable
has been removed from the -mm tree.  Its filename was
     mm-remove-pageunevictable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove PageUnevictable
Date: Wed, 21 Aug 2024 20:34:38 +0100

There is only one caller of PageUnevictable() left; convert it to call
folio_test_unevictable() and remove all the page accessors.

Link: https://lkml.kernel.org/r/20240821193445.2294269-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    6 +++---
 mm/huge_memory.c           |   16 ++++++++--------
 2 files changed, 11 insertions(+), 11 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-pageunevictable
+++ a/include/linux/page-flags.h
@@ -580,9 +580,9 @@ FOLIO_CLEAR_FLAG(swapcache, FOLIO_HEAD_P
 FOLIO_FLAG_FALSE(swapcache)
 #endif
 
-PAGEFLAG(Unevictable, unevictable, PF_HEAD)
-	__CLEARPAGEFLAG(Unevictable, unevictable, PF_HEAD)
-	TESTCLEARFLAG(Unevictable, unevictable, PF_HEAD)
+FOLIO_FLAG(unevictable, FOLIO_HEAD_PAGE)
+	__FOLIO_CLEAR_FLAG(unevictable, FOLIO_HEAD_PAGE)
+	FOLIO_TEST_CLEAR_FLAG(unevictable, FOLIO_HEAD_PAGE)
 
 #ifdef CONFIG_MMU
 PAGEFLAG(Mlocked, mlocked, PF_NO_TAIL)
--- a/mm/huge_memory.c~mm-remove-pageunevictable
+++ a/mm/huge_memory.c
@@ -2932,25 +2932,25 @@ static void remap_page(struct folio *fol
 	}
 }
 
-static void lru_add_page_tail(struct page *head, struct page *tail,
+static void lru_add_page_tail(struct folio *folio, struct page *tail,
 		struct lruvec *lruvec, struct list_head *list)
 {
-	VM_BUG_ON_PAGE(!PageHead(head), head);
-	VM_BUG_ON_PAGE(PageLRU(tail), head);
+	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
+	VM_BUG_ON_FOLIO(PageLRU(tail), folio);
 	lockdep_assert_held(&lruvec->lru_lock);
 
 	if (list) {
 		/* page reclaim is reclaiming a huge page */
-		VM_WARN_ON(PageLRU(head));
+		VM_WARN_ON(folio_test_lru(folio));
 		get_page(tail);
 		list_add_tail(&tail->lru, list);
 	} else {
 		/* head is still on lru (and we have it frozen) */
-		VM_WARN_ON(!PageLRU(head));
-		if (PageUnevictable(tail))
+		VM_WARN_ON(!folio_test_lru(folio));
+		if (folio_test_unevictable(folio))
 			tail->mlock_count = 0;
 		else
-			list_add_tail(&tail->lru, &head->lru);
+			list_add_tail(&tail->lru, &folio->lru);
 		SetPageLRU(tail);
 	}
 }
@@ -3049,7 +3049,7 @@ static void __split_huge_page_tail(struc
 	 * pages to show after the currently processed elements - e.g.
 	 * migrate_pages
 	 */
-	lru_add_page_tail(head, page_tail, lruvec, list);
+	lru_add_page_tail(folio, page_tail, lruvec, list);
 }
 
 static void __split_huge_page(struct page *page, struct list_head *list,
_

Patches currently in -mm which might be from willy@infradead.org are

swap-convert-swapon-to-use-a-folio.patch

