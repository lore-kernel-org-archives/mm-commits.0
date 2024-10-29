Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CEF282FB
	for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 03:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730173971; cv=none; b=b+Y4aYGSk+d8mpMoMFVbGonEu7Zv4coKaQdbptLrHNPhquImMHf9/hL+5yUtOKZTB7eONlrtTM/+m0hAASRl9HCfmyG59K+imLrymVzjvtf5hJ1bcnKwsZeXtDyAflrKPphdJeXIcyiGe2aYUdEkWksaTUzNt1168vxmM/+78Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730173971; c=relaxed/simple;
	bh=HWRjBMZCrRY3xD1mX5e37AXudGjJERL7L4ZHdWq9Jns=;
	h=Date:To:From:Subject:Message-Id; b=Es56SP/QEi/cYIrI3yKStddc0R5gaDDGfwW8QswLHkCeVcocdFbu7H8fmR+lBMTAn+DKGS3k/UMNKjxkNy9wzldK0p6SWdlmnrOIsLGrAXUcGbKoj6pV0G008IaBT4GUPb3dQGV9BqVlasI6BrjW4WbT0bIgAn4MCT1rjxI8cSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vM/Y1awB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vM/Y1awB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2DBC4CECD;
	Tue, 29 Oct 2024 03:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730173970;
	bh=HWRjBMZCrRY3xD1mX5e37AXudGjJERL7L4ZHdWq9Jns=;
	h=Date:To:From:Subject:From;
	b=vM/Y1awB9GU8cUpTXE/t0ujabcj25iUY68KUGoFy0SliZJwdCk28JwMMW0dpBtp5c
	 DIDwyIVpBLv2KLNPXZVgCymezyJtddaeizV+GAuZt5ST03W62q4xPLGkCD6TMAPpua
	 lvRvKX47WNLbDZ6iw7WpfYH0Dg1FZd0fei6LjSQc=
Date: Mon, 28 Oct 2024 20:52:49 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shy828301@gmail.com,peterx@redhat.com,pasha.tatashin@soleen.com,david@redhat.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-delete-the-unused-put_pages_list.patch added to mm-unstable branch
Message-Id: <20241029035250.6A2DBC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: delete the unused put_pages_list()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-delete-the-unused-put_pages_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-delete-the-unused-put_pages_list.patch

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

mm-delete-the-unused-put_pages_list.patch

