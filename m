Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A5A13E02E
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313708; cv=none; b=JrBpgtYU3eW4ClUvgzY43aksQmKtXoHbWG/0NbPexOhvrf1FdePLWSNoPQHSxHxa9CaKSYeFhClQay2yUBGCcftr0SslIrVKEXKYrslFYugnDZlHRvWqT+Kt80H19Tv18Ew8v2lInbdg7SIb8vJ9XoHLfkGz9dCrYhxQ2BlMVnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313708; c=relaxed/simple;
	bh=mJNCgFK5v/1Kvk8T3Vdp88Mnhmpc47JkI352uy+viDA=;
	h=Date:To:From:Subject:Message-Id; b=nIshEppvulOAEy5ro1vapkDVLs7hXGEvHA4SWbuqwxvF5A1r0A4BeSkFtaAUHbm0oiyEAHyByKHhmMW4LGBdh5DvJJJU/YzKP8Kju/SsQn1u6cZAHwGNgH365Agq/AePTtet2sz7z5nC42cU8IbZ9KYjiLSvHafab7agHSd4BcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ELR3o5wK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ELR3o5wK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003BEC4CED0;
	Mon, 11 Nov 2024 08:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313708;
	bh=mJNCgFK5v/1Kvk8T3Vdp88Mnhmpc47JkI352uy+viDA=;
	h=Date:To:From:Subject:From;
	b=ELR3o5wKmVLFFImkCrPVrz7M0d/d+HaSP1agpaeBc5kLuh392Le4N3qXYSmGGlCXk
	 4jdq4x9yz0+DgjpFLWTGWEG8D8bRQHEBQIiVLghse5UpPSJ3x72jm/MHPWtWtj6bc5
	 X5m+EEIJDAed/6n5SckoBJiiC9FwbnsUuswvgReY=
Date: Mon, 11 Nov 2024 00:28:27 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shy828301@gmail.com,peterx@redhat.com,pasha.tatashin@soleen.com,david@redhat.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-delete-the-unused-put_pages_list.patch removed from -mm tree
Message-Id: <20241111082828.003BEC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: delete the unused put_pages_list()
has been removed from the -mm tree.  Its filename was
     mm-delete-the-unused-put_pages_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: delete the unused put_pages_list()
Date: Sun, 27 Oct 2024 13:14:42 -0700 (PDT)

The last user of put_pages_list() converted away from it in 6.10 commit
06c375053cef ("iommu/vt-d: add wrapper functions for page allocations"):
delete put_pages_list().

Link: https://lkml.kernel.org/r/d9985d6a-293e-176b-e63d-82fdfd28c139@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 mm/swap.c          |   31 -------------------------------
 2 files changed, 33 deletions(-)

--- a/include/linux/mm.h~mm-delete-the-unused-put_pages_list
+++ a/include/linux/mm.h
@@ -1286,8 +1286,6 @@ static inline struct folio *virt_to_foli
 
 void __folio_put(struct folio *folio);
 
-void put_pages_list(struct list_head *pages);
-
 void split_page(struct page *page, unsigned int order);
 void folio_copy(struct folio *dst, struct folio *src);
 int folio_mc_copy(struct folio *dst, struct folio *src);
--- a/mm/swap.c~mm-delete-the-unused-put_pages_list
+++ a/mm/swap.c
@@ -127,37 +127,6 @@ void __folio_put(struct folio *folio)
 }
 EXPORT_SYMBOL(__folio_put);
 
-/**
- * put_pages_list() - release a list of pages
- * @pages: list of pages threaded on page->lru
- *
- * Release a list of pages which are strung together on page.lru.
- */
-void put_pages_list(struct list_head *pages)
-{
-	struct folio_batch fbatch;
-	struct folio *folio, *next;
-
-	folio_batch_init(&fbatch);
-	list_for_each_entry_safe(folio, next, pages, lru) {
-		if (!folio_put_testzero(folio))
-			continue;
-		if (folio_test_hugetlb(folio)) {
-			free_huge_folio(folio);
-			continue;
-		}
-		/* LRU flag must be clear because it's passed using the lru */
-		if (folio_batch_add(&fbatch, folio) > 0)
-			continue;
-		free_unref_folios(&fbatch);
-	}
-
-	if (fbatch.nr)
-		free_unref_folios(&fbatch);
-	INIT_LIST_HEAD(pages);
-}
-EXPORT_SYMBOL(put_pages_list);
-
 typedef void (*move_fn_t)(struct lruvec *lruvec, struct folio *folio);
 
 static void lru_add(struct lruvec *lruvec, struct folio *folio)
_

Patches currently in -mm which might be from hughd@google.com are

mm-thp-fix-deferred-split-queue-not-partially_mapped-fix.patch

