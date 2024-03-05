Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DA41078F
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600562; cv=none; b=cv5SKvQMsP61tn7XBfvRZQmdemTlN0plqtQ8zwJ5OAY6h9vdMcuLByFj/myCExaAYsNuuH83/8mMXSG0brDe1PPwRKDUv53y3xFYGimUT3zlEV8nvbB+r+DHmFkgxb4s7rfmoCBTHG72fUCIWpSqQUDG2d6a+V465kiAiP3RRYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600562; c=relaxed/simple;
	bh=kYcOyBbGa2HpoeQ9BeaTT5MoI1CKYiYaX9ScE0Dnx3s=;
	h=Date:To:From:Subject:Message-Id; b=Lk/QgU5jFzI0G7rcbw7uvDCga/QpEqusM7FQ6ws1emMxmd8Dp5B6ffvqj36C+MN4C0pksaix2ITLiyfSDDIHMw5wzYvsbEZyO5XODodCby8zKHD7dWLV9gVvYm3hp+GjRraxvJ1fA0rgQvjqFMFOJgRCK2pbNSM3dLft5EgwIX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M/3k/S/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M/3k/S/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEE8C433C7;
	Tue,  5 Mar 2024 01:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600562;
	bh=kYcOyBbGa2HpoeQ9BeaTT5MoI1CKYiYaX9ScE0Dnx3s=;
	h=Date:To:From:Subject:From;
	b=M/3k/S/YNP+oG412U+oea5bJHRN2aL9LB5Yfi7aphVZJgEAHHDQFnTwYMDn9ux1pr
	 svxz9Jgg/5y15cFddQht9rW/dcG1Blq44YRw9QP0v9WOOso7jHUMPl/HfUJjtFCWDR
	 gWhOA36Z9YTNWemUYbV65Tb+0NuAtzTys2WtZRqg=
Date: Mon, 04 Mar 2024 17:02:41 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-folios_put-the-basis-of-release_pages.patch removed from -mm tree
Message-Id: <20240305010241.DEEE8C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make folios_put() the basis of release_pages()
has been removed from the -mm tree.  Its filename was
     mm-make-folios_put-the-basis-of-release_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: make folios_put() the basis of release_pages()
Date: Tue, 27 Feb 2024 17:42:35 +0000

Patch series "Rearrange batched folio freeing", v3.

Other than the obvious "remove calls to compound_head" changes, the
fundamental belief here is that iterating a linked list is much slower
than iterating an array (5-15x slower in my testing).  There's also an
associated belief that since we iterate the batch of folios three times,
we do better when the array is small (ie 15 entries) than we do with a
batch that is hundreds of entries long, which only gives us the
opportunity for the first pages to fall out of cache by the time we get to
the end.

It is possible we should increase the size of folio_batch.  Hopefully the
bots let us know if this introduces any performance regressions.


This patch (of 3):

By making release_pages() call folios_put(), we can get rid of the calls
to compound_head() for the callers that already know they have folios.  We
can also get rid of the lock_batch tracking as we know the size of the
batch is limited by folio_batch.  This does reduce the maximum number of
pages for which the lruvec lock is held, from SWAP_CLUSTER_MAX (32) to
PAGEVEC_SIZE (15).  I do not expect this to make a significant difference,
but if it does, we can increase PAGEVEC_SIZE to 31.

Link: https://lkml.kernel.org/r/20240227174254.710559-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240227174254.710559-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   16 ++++--
 mm/mlock.c         |    3 -
 mm/swap.c          |  102 +++++++++++++++++++++++++------------------
 3 files changed, 71 insertions(+), 50 deletions(-)

--- a/include/linux/mm.h~mm-make-folios_put-the-basis-of-release_pages
+++ a/include/linux/mm.h
@@ -36,6 +36,7 @@ struct anon_vma;
 struct anon_vma_chain;
 struct user_struct;
 struct pt_regs;
+struct folio_batch;
 
 extern int sysctl_page_lock_unfairness;
 
@@ -1512,6 +1513,8 @@ static inline void folio_put_refs(struct
 		__folio_put(folio);
 }
 
+void folios_put_refs(struct folio_batch *folios, unsigned int *refs);
+
 /*
  * union release_pages_arg - an array of pages or folios
  *
@@ -1534,18 +1537,19 @@ void release_pages(release_pages_arg, in
 /**
  * folios_put - Decrement the reference count on an array of folios.
  * @folios: The folios.
- * @nr: How many folios there are.
  *
- * Like folio_put(), but for an array of folios.  This is more efficient
- * than writing the loop yourself as it will optimise the locks which
- * need to be taken if the folios are freed.
+ * Like folio_put(), but for a batch of folios.  This is more efficient
+ * than writing the loop yourself as it will optimise the locks which need
+ * to be taken if the folios are freed.  The folios batch is returned
+ * empty and ready to be reused for another batch; there is no need to
+ * reinitialise it.
  *
  * Context: May be called in process or interrupt context, but not in NMI
  * context.  May be called while holding a spinlock.
  */
-static inline void folios_put(struct folio **folios, unsigned int nr)
+static inline void folios_put(struct folio_batch *folios)
 {
-	release_pages(folios, nr);
+	folios_put_refs(folios, NULL);
 }
 
 static inline void put_page(struct page *page)
--- a/mm/mlock.c~mm-make-folios_put-the-basis-of-release_pages
+++ a/mm/mlock.c
@@ -206,8 +206,7 @@ static void mlock_folio_batch(struct fol
 
 	if (lruvec)
 		unlock_page_lruvec_irq(lruvec);
-	folios_put(fbatch->folios, folio_batch_count(fbatch));
-	folio_batch_reinit(fbatch);
+	folios_put(fbatch);
 }
 
 void mlock_drain_local(void)
--- a/mm/swap.c~mm-make-folios_put-the-basis-of-release_pages
+++ a/mm/swap.c
@@ -89,7 +89,7 @@ static void __page_cache_release(struct
 		__folio_clear_lru_flags(folio);
 		unlock_page_lruvec_irqrestore(lruvec, flags);
 	}
-	/* See comment on folio_test_mlocked in release_pages() */
+	/* See comment on folio_test_mlocked in folios_put() */
 	if (unlikely(folio_test_mlocked(folio))) {
 		long nr_pages = folio_nr_pages(folio);
 
@@ -175,7 +175,7 @@ static void lru_add_fn(struct lruvec *lr
 	 * while the LRU lock is held.
 	 *
 	 * (That is not true of __page_cache_release(), and not necessarily
-	 * true of release_pages(): but those only clear the mlocked flag after
+	 * true of folios_put(): but those only clear the mlocked flag after
 	 * folio_put_testzero() has excluded any other users of the folio.)
 	 */
 	if (folio_evictable(folio)) {
@@ -221,8 +221,7 @@ static void folio_batch_move_lru(struct
 
 	if (lruvec)
 		unlock_page_lruvec_irqrestore(lruvec, flags);
-	folios_put(fbatch->folios, folio_batch_count(fbatch));
-	folio_batch_reinit(fbatch);
+	folios_put(fbatch);
 }
 
 static void folio_batch_add_and_move(struct folio_batch *fbatch,
@@ -946,47 +945,30 @@ void lru_cache_disable(void)
 }
 
 /**
- * release_pages - batched put_page()
- * @arg: array of pages to release
- * @nr: number of pages
+ * folios_put_refs - Reduce the reference count on a batch of folios.
+ * @folios: The folios.
+ * @refs: The number of refs to subtract from each folio.
+ *
+ * Like folio_put(), but for a batch of folios.  This is more efficient
+ * than writing the loop yourself as it will optimise the locks which need
+ * to be taken if the folios are freed.  The folios batch is returned
+ * empty and ready to be reused for another batch; there is no need
+ * to reinitialise it.  If @refs is NULL, we subtract one from each
+ * folio refcount.
  *
- * Decrement the reference count on all the pages in @arg.  If it
- * fell to zero, remove the page from the LRU and free it.
- *
- * Note that the argument can be an array of pages, encoded pages,
- * or folio pointers. We ignore any encoded bits, and turn any of
- * them into just a folio that gets free'd.
+ * Context: May be called in process or interrupt context, but not in NMI
+ * context.  May be called while holding a spinlock.
  */
-void release_pages(release_pages_arg arg, int nr)
+void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 {
 	int i;
-	struct encoded_page **encoded = arg.encoded_pages;
 	LIST_HEAD(pages_to_free);
 	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
-	unsigned int lock_batch;
 
-	for (i = 0; i < nr; i++) {
-		unsigned int nr_refs = 1;
-		struct folio *folio;
-
-		/* Turn any of the argument types into a folio */
-		folio = page_folio(encoded_page_ptr(encoded[i]));
-
-		/* Is our next entry actually "nr_pages" -> "nr_refs" ? */
-		if (unlikely(encoded_page_flags(encoded[i]) &
-			     ENCODED_PAGE_BIT_NR_PAGES_NEXT))
-			nr_refs = encoded_nr_pages(encoded[++i]);
-
-		/*
-		 * Make sure the IRQ-safe lock-holding time does not get
-		 * excessive with a continuous string of pages from the
-		 * same lruvec. The lock is held only if lruvec != NULL.
-		 */
-		if (lruvec && ++lock_batch == SWAP_CLUSTER_MAX) {
-			unlock_page_lruvec_irqrestore(lruvec, flags);
-			lruvec = NULL;
-		}
+	for (i = 0; i < folios->nr; i++) {
+		struct folio *folio = folios->folios[i];
+		unsigned int nr_refs = refs ? refs[i] : 1;
 
 		if (is_huge_zero_page(&folio->page))
 			continue;
@@ -1016,13 +998,8 @@ void release_pages(release_pages_arg arg
 		}
 
 		if (folio_test_lru(folio)) {
-			struct lruvec *prev_lruvec = lruvec;
-
 			lruvec = folio_lruvec_relock_irqsave(folio, lruvec,
 									&flags);
-			if (prev_lruvec != lruvec)
-				lock_batch = 0;
-
 			lruvec_del_folio(lruvec, folio);
 			__folio_clear_lru_flags(folio);
 		}
@@ -1046,6 +1023,47 @@ void release_pages(release_pages_arg arg
 
 	mem_cgroup_uncharge_list(&pages_to_free);
 	free_unref_page_list(&pages_to_free);
+	folio_batch_reinit(folios);
+}
+EXPORT_SYMBOL(folios_put_refs);
+
+/**
+ * release_pages - batched put_page()
+ * @arg: array of pages to release
+ * @nr: number of pages
+ *
+ * Decrement the reference count on all the pages in @arg.  If it
+ * fell to zero, remove the page from the LRU and free it.
+ *
+ * Note that the argument can be an array of pages, encoded pages,
+ * or folio pointers. We ignore any encoded bits, and turn any of
+ * them into just a folio that gets free'd.
+ */
+void release_pages(release_pages_arg arg, int nr)
+{
+	struct folio_batch fbatch;
+	int refs[PAGEVEC_SIZE];
+	struct encoded_page **encoded = arg.encoded_pages;
+	int i;
+
+	folio_batch_init(&fbatch);
+	for (i = 0; i < nr; i++) {
+		/* Turn any of the argument types into a folio */
+		struct folio *folio = page_folio(encoded_page_ptr(encoded[i]));
+
+		/* Is our next entry actually "nr_pages" -> "nr_refs" ? */
+		refs[fbatch.nr] = 1;
+		if (unlikely(encoded_page_flags(encoded[i]) &
+			     ENCODED_PAGE_BIT_NR_PAGES_NEXT))
+			refs[fbatch.nr] = encoded_nr_pages(encoded[++i]);
+
+		if (folio_batch_add(&fbatch, folio) > 0)
+			continue;
+		folios_put_refs(&fbatch, refs);
+	}
+
+	if (fbatch.nr)
+		folios_put_refs(&fbatch, refs);
 }
 EXPORT_SYMBOL(release_pages);
 
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

