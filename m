Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC5816FF26
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 20:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724272443; cv=none; b=iR/psamvUjL/BJkCQMlm6XeRFToWJPT/4FKWz2VZwzRcjM3gUjuUhuEhcphKmLsAn+ORLldx1altOjZ+h9ndoZSzqltpY0znXEAjRpp/7sAtdlB25XIEmr4C8+Otfx4EKs9v2IDyVtP03b72znC+k3Hx2a+9lVrSWBvIGDgiwEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724272443; c=relaxed/simple;
	bh=UUonAP3lgxgXpK9fbo/RS/aKJO9Y/MyH0l5jnJ9gNUM=;
	h=Date:To:From:Subject:Message-Id; b=KrYupDdQqo80K3LRBFy0hz0rLF9KcyyEKeUbHzAhmMS6tGO1T91uLHOf0pFBcs5DcuNZkVWb+g9oepl80fPKGDNbXu85iordkIAa4UKqUaPDdYejkSV/XhCl4nXF7OL03WTNNnZ8ABfQPOnskEk3l2Bs3iekhqm/Bk0yqmHWD2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MyGIdE2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MyGIdE2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4C7C32781;
	Wed, 21 Aug 2024 20:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724272443;
	bh=UUonAP3lgxgXpK9fbo/RS/aKJO9Y/MyH0l5jnJ9gNUM=;
	h=Date:To:From:Subject:From;
	b=MyGIdE2Y9xscMLGpKnls9eXDtpCM6tvNCdpM78zs5Q9u7MNlFu38+4U7CI+rWZItX
	 qDPWvSltaB24/3P3QbFdj0C9pmVQWy6Zyq8vAbEz7KiseS5MBpuR5nottoN0oNXJvL
	 gFxeKmxB/pHg7PKJoI2Qlys3V7X8Zzi6w2SYuGS8=
Date: Wed, 21 Aug 2024 13:34:02 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pageunevictable.patch added to mm-unstable branch
Message-Id: <20240821203403.8E4C7C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove PageUnevictable
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-pageunevictable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-pageunevictable.patch

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
@@ -3016,25 +3016,25 @@ static void remap_page(struct folio *fol
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
@@ -3133,7 +3133,7 @@ static void __split_huge_page_tail(struc
 	 * pages to show after the currently processed elements - e.g.
 	 * migrate_pages
 	 */
-	lru_add_page_tail(head, page_tail, lruvec, list);
+	lru_add_page_tail(folio, page_tail, lruvec, list);
 }
 
 static void __split_huge_page(struct page *page, struct list_head *list,
_

Patches currently in -mm which might be from willy@infradead.org are

fs-remove-calls-to-set-and-clear-the-folio-error-flag.patch
mm-remove-pg_error.patch
mm-return-the-folio-from-swapin_readahead.patch
printf-remove-%pgt-support.patch
mm-introduce-page_mapcount_is_type.patch
mm-support-only-one-page_type-per-page.patch
zsmalloc-use-all-available-24-bits-of-page_type.patch
mm-remove-pageactive.patch
mm-remove-pageswapbacked.patch
mm-remove-pagereadahead.patch
mm-remove-pageswapcache.patch
mm-remove-pageunevictable.patch
mm-remove-pagemlocked.patch
mm-remove-pageownerpriv1.patch
mm-remove-page_has_private.patch
mm-rename-pg_mappedtodisk-to-pg_owner_2.patch
x86-remove-pg_uncached.patch

