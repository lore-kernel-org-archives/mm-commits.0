Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A408FC1C
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600569; cv=none; b=npAnaXeeiCdNSPgskbbIkYJxdZ7RUqqAZBjlnergl8Pdz2DpytIwig1K6ncl+qulf1x1eeSlC0ZAdWNeqZvRnXP0DPBxcWw+7L7hotU2dGG7tRx216AjkXoquSye2hE3nL2NVd5Z9ACyBSGQCIXTM7kNXGCa1jASRNYWqmlOT50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600569; c=relaxed/simple;
	bh=5HYqaowMVhnOiG6+RNklswMYs5NkqNPGINktuKEP30g=;
	h=Date:To:From:Subject:Message-Id; b=jSn0Fzx/rRwv3y1zUWf+zylm9Kb2VWLraC8TjWvGfMI3PFEMxpPMfS9B97RCa5IeeoDkBtEkIalgJX+wXGmE2BWMHbRSvrs5g2Uy1mwrKzc3IjU3ftvlCHww8ywoo9pyzbVREEJjdN2LXou5z+3HszQhTZAxLB87VuY7YICMX7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UXyStwwX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UXyStwwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1450C43390;
	Tue,  5 Mar 2024 01:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600569;
	bh=5HYqaowMVhnOiG6+RNklswMYs5NkqNPGINktuKEP30g=;
	h=Date:To:From:Subject:From;
	b=UXyStwwXkgJMp6C/WIFNyWIOg+11/c5TvjQf0Jbc5Vrq7QHaD1u4bHD7S2Hyhus0g
	 mSJs18oOVgAhm8XrPOKHx5C27bwtUmFF0ySz7DhZNUF9xOfV8EnamXuzdPButIbH7O
	 1JrRauQZkYtvjRnsnxBQwx9HgpgV1qvRGBvQTcLs=
Date: Mon, 04 Mar 2024 17:02:48 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-__page_cache_release-in-folios_put.patch removed from -mm tree
Message-Id: <20240305010248.F1450C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use __page_cache_release() in folios_put()
has been removed from the -mm tree.  Its filename was
     mm-use-__page_cache_release-in-folios_put.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-add-__dump_folio-fix.patch
mm-add-__dump_folio-fix-2.patch
mm-add-__dump_folio-fix-3.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch
mm-mempolicy-use-a-folio-in-do_mbind.patch

