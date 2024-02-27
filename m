Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19892557E
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 18:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059678; cv=none; b=TScKjT0tNg6RAxWlKoYQtQlCtmhbZ+EMSvNw09Li73D3eZS21gleYppxbr86dY5zupgOh46CNxhFw8POlio6plUL/QBlw95fzYQfLb0e2njQBZT2UR0ems/wJ7msoPaWMRBxbeQcYrcp82eie+cw64BQRncXjxAJ57h62p/atmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059678; c=relaxed/simple;
	bh=jOJMXojcJRbwb3k9eKZSlGzY94NxAn8OH15GjsgWbEc=;
	h=Date:To:From:Subject:Message-Id; b=SEv8gAbhVTRkfIqkhHHMCHi4LGuNAdIhrR4gpU8kKfuJT+u8pKVLyoF+hX8R4s4c4+zy2+r3eFIloxBmedJZ6TR7LiKg4kcnwEUBJg9LTqtvPO9YQ3DD/RyVvzFeczUbBy7finf8rEbaZZz/DqD73VTmiartNwaHldFgJV8YcAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I1UNirCN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I1UNirCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC72C43394;
	Tue, 27 Feb 2024 18:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709059678;
	bh=jOJMXojcJRbwb3k9eKZSlGzY94NxAn8OH15GjsgWbEc=;
	h=Date:To:From:Subject:From;
	b=I1UNirCNPd2FpYG8Xq/De1Pweyhc7eM462UzfNR5i0Sb6mrTEJsUEYdiloOdd9QGl
	 hvOQeIBUzBv9sTMwdQRQvf2rUddGqNTqY71Kv/c/obNs5ayYg70wd8JZXQocQstSsL
	 VZdDPKs98Y6JYs4ueGd6dnrD6yZk6ubsDbDuIKFQ=
Date: Tue, 27 Feb 2024 10:47:57 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-__page_cache_release-in-folios_put.patch added to mm-unstable branch
Message-Id: <20240227184758.6DC72C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use __page_cache_release() in folios_put()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-__page_cache_release-in-folios_put.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-__page_cache_release-in-folios_put.patch

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
Subject: mm: use __page_cache_release() in folios_put()
Date: Tue, 27 Feb 2024 17:42:42 +0000

Pass a pointer to the lruvec so we can take advantage of the
folio_lruvec_relock_irqsave().  Adjust the calling convention of
folio_lruvec_relock_irqsave() to suit and add a page_cache_release()
wrapper.

Link: https://lkml.kernel.org/r/20240227174254.710559-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   16 ++++-----
 mm/swap.c                  |   62 ++++++++++++++++-------------------
 2 files changed, 37 insertions(+), 41 deletions(-)

--- a/include/linux/memcontrol.h~mm-use-__page_cache_release-in-folios_put
+++ a/include/linux/memcontrol.h
@@ -1705,18 +1705,18 @@ static inline struct lruvec *folio_lruve
 	return folio_lruvec_lock_irq(folio);
 }
 
-/* Don't lock again iff page's lruvec locked */
-static inline struct lruvec *folio_lruvec_relock_irqsave(struct folio *folio,
-		struct lruvec *locked_lruvec, unsigned long *flags)
+/* Don't lock again iff folio's lruvec locked */
+static inline void folio_lruvec_relock_irqsave(struct folio *folio,
+		struct lruvec **lruvecp, unsigned long *flags)
 {
-	if (locked_lruvec) {
-		if (folio_matches_lruvec(folio, locked_lruvec))
-			return locked_lruvec;
+	if (*lruvecp) {
+		if (folio_matches_lruvec(folio, *lruvecp))
+			return;
 
-		unlock_page_lruvec_irqrestore(locked_lruvec, *flags);
+		unlock_page_lruvec_irqrestore(*lruvecp, *flags);
 	}
 
-	return folio_lruvec_lock_irqsave(folio, flags);
+	*lruvecp = folio_lruvec_lock_irqsave(folio, flags);
 }
 
 #ifdef CONFIG_CGROUP_WRITEBACK
--- a/mm/swap.c~mm-use-__page_cache_release-in-folios_put
+++ a/mm/swap.c
@@ -74,22 +74,21 @@ static DEFINE_PER_CPU(struct cpu_fbatche
 	.lock = INIT_LOCAL_LOCK(lock),
 };
 
-/*
- * This path almost never happens for VM activity - pages are normally freed
- * in batches.  But it gets used by networking - and for compound pages.
- */
-static void __page_cache_release(struct folio *folio)
+static void __page_cache_release(struct folio *folio, struct lruvec **lruvecp,
+		unsigned long *flagsp)
 {
 	if (folio_test_lru(folio)) {
-		struct lruvec *lruvec;
-		unsigned long flags;
-
-		lruvec = folio_lruvec_lock_irqsave(folio, &flags);
-		lruvec_del_folio(lruvec, folio);
+		folio_lruvec_relock_irqsave(folio, lruvecp, flagsp);
+		lruvec_del_folio(*lruvecp, folio);
 		__folio_clear_lru_flags(folio);
-		unlock_page_lruvec_irqrestore(lruvec, flags);
 	}
-	/* See comment on folio_test_mlocked in folios_put() */
+
+	/*
+	 * In rare cases, when truncation or holepunching raced with
+	 * munlock after VM_LOCKED was cleared, Mlocked may still be
+	 * found set here.  This does not indicate a problem, unless
+	 * "unevictable_pgs_cleared" appears worryingly large.
+	 */
 	if (unlikely(folio_test_mlocked(folio))) {
 		long nr_pages = folio_nr_pages(folio);
 
@@ -99,9 +98,23 @@ static void __page_cache_release(struct
 	}
 }
 
+/*
+ * This path almost never happens for VM activity - pages are normally freed
+ * in batches.  But it gets used by networking - and for compound pages.
+ */
+static void page_cache_release(struct folio *folio)
+{
+	struct lruvec *lruvec = NULL;
+	unsigned long flags;
+
+	__page_cache_release(folio, &lruvec, &flags);
+	if (lruvec)
+		unlock_page_lruvec_irqrestore(lruvec, flags);
+}
+
 static void __folio_put_small(struct folio *folio)
 {
-	__page_cache_release(folio);
+	page_cache_release(folio);
 	mem_cgroup_uncharge(folio);
 	free_unref_page(&folio->page, 0);
 }
@@ -115,7 +128,7 @@ static void __folio_put_large(struct fol
 	 * be called for hugetlb (it has a separate hugetlb_cgroup.)
 	 */
 	if (!folio_test_hugetlb(folio))
-		__page_cache_release(folio);
+		page_cache_release(folio);
 	destroy_large_folio(folio);
 }
 
@@ -216,7 +229,7 @@ static void folio_batch_move_lru(struct
 		if (move_fn != lru_add_fn && !folio_test_clear_lru(folio))
 			continue;
 
-		lruvec = folio_lruvec_relock_irqsave(folio, lruvec, &flags);
+		folio_lruvec_relock_irqsave(folio, &lruvec, &flags);
 		move_fn(lruvec, folio);
 
 		folio_set_lru(folio);
@@ -999,24 +1012,7 @@ void folios_put_refs(struct folio_batch
 			continue;
 		}
 
-		if (folio_test_lru(folio)) {
-			lruvec = folio_lruvec_relock_irqsave(folio, lruvec,
-									&flags);
-			lruvec_del_folio(lruvec, folio);
-			__folio_clear_lru_flags(folio);
-		}
-
-		/*
-		 * In rare cases, when truncation or holepunching raced with
-		 * munlock after VM_LOCKED was cleared, Mlocked may still be
-		 * found set here.  This does not indicate a problem, unless
-		 * "unevictable_pgs_cleared" appears worryingly large.
-		 */
-		if (unlikely(folio_test_mlocked(folio))) {
-			__folio_clear_mlocked(folio);
-			zone_stat_sub_folio(folio, NR_MLOCK);
-			count_vm_event(UNEVICTABLE_PGCLEARED);
-		}
+		__page_cache_release(folio, &lruvec, &flags);
 
 		if (j != i)
 			folios->folios[j] = folio;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-support-order-1-folios-in-the-page-cache.patch
mm-make-folios_put-the-basis-of-release_pages.patch
mm-convert-free_unref_page_list-to-use-folios.patch
mm-add-free_unref_folios.patch
mm-use-folios_put-in-__folio_batch_release.patch
memcg-add-mem_cgroup_uncharge_folios.patch
mm-remove-use-of-folio-list-from-folios_put.patch
mm-use-free_unref_folios-in-put_pages_list.patch
mm-use-__page_cache_release-in-folios_put.patch
mm-handle-large-folios-in-free_unref_folios.patch
mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch
mm-free-folios-in-a-batch-in-shrink_folio_list.patch
mm-free-folios-directly-in-move_folios_to_lru.patch
memcg-remove-mem_cgroup_uncharge_list.patch
mm-remove-free_unref_page_list.patch
mm-remove-lru_to_page.patch
mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch
mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch
mm-convert-free_swap_cache-to-take-a-folio.patch

