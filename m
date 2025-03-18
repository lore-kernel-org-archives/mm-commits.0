Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B5C1A9B4D
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274532; cv=none; b=kyEsAGCJfaHw9nhmolRbNe+kxk09ZyrdKSqYx4GZ7A57dUJeAK8gwaXGiq2aZx4zWaqCmorAEsGkRnSVtPqIjqC9DStAHA7C/oafjglUGro36Fcb1M9ExfG0qJ/JDsisE5zKlZaXzzm5xfRvB881nghzQkxmXvvM/1XEIxug3aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274532; c=relaxed/simple;
	bh=Jce+DhWzbUHgvQDiIbth9tDNkUNK5Z795hvi6xSoSLM=;
	h=Date:To:From:Subject:Message-Id; b=Z6b8zroiVJCTnb7G0TwygLaVrx/werreemY364I0Pi3czVwwaIVnBncI8eWrJtApyoyyVfEkqTx2gPx8Eb/8yzvrwno80drqwEeeipRynWnfZkfSBUDkepiC0rraQFL94s+QhvqBGHGCbIaAw1aNbuHadU0LHYJ6Wbw0o6oh6MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q4nspe8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q4nspe8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4F9C4CEDD;
	Tue, 18 Mar 2025 05:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274532;
	bh=Jce+DhWzbUHgvQDiIbth9tDNkUNK5Z795hvi6xSoSLM=;
	h=Date:To:From:Subject:From;
	b=Q4nspe8+6e0gTdWAJil8yK//QNJ+47y8g/7N66sbS2Kf72+Ri3N/drr3gMyS17ebx
	 YOhboGc/X9ih3hC7CvonPLzrYato8p62h5/RWpOqDuih488Fn9Tn4dBJ35zC46EkJJ
	 /nFn4UEuCMiKD3oddHHHe5smNk2XNl828zBWQM/c=
Date: Mon, 17 Mar 2025 22:08:51 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizefan.x@bytedance.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jannh@google.com,ioworker0@gmail.com,hannes@cmpxchg.org,dave.hansen@linux.intel.com,corbet@lwn.net,bp@alien8.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-_pincount-in-folio-to-page-on-32bit.patch removed from -mm tree
Message-Id: <20250318050852.0E4F9C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: move _pincount in folio to page[2] on 32bit
has been removed from the -mm tree.  Its filename was
     mm-move-_pincount-in-folio-to-page-on-32bit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: move _pincount in folio to page[2] on 32bit
Date: Mon, 3 Mar 2025 17:29:58 +0100

Let's free up some space on 32bit in page[1] by moving the _pincount to
page[2].

For order-1 folios (never anon folios!) on 32bit, we will now also use the
GUP_PIN_COUNTING_BIAS approach.  A fully-mapped order-1 folio requires 2
references.  With GUP_PIN_COUNTING_BIAS being 1024, we'd detect such
folios as "maybe pinned" with 512 full mappings, instead of 1024 for
order-0.  As anon folios are out of the picture (which are the most
relevant users of checking for pinnings on *mapped* pages) and we are
talking about 32bit, this is not expected to cause any trouble.

In __dump_page(), copy one additional folio page if we detect a folio with
an order > 1, so we can dump the pincount on order > 1 folios reliably.

Note that THPs on 32bit are not particularly common (and we don't care too
much about performance), but we want to keep it working reliably, because
likely we want to use large folios there as well in the future,
independent of PMD leaf support.

Once we dynamically allocate "struct folio", fortunately the 32bit
specifics will likely go away again; even small folios could then have a
pincount and folio_has_pincount() would essentially always return "true".

Link: https://lkml.kernel.org/r/20250303163014.1128035-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirks^H^Hski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michal Koutn <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: tejun heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |   11 +++++++++--
 include/linux/mm_types.h |    5 +++++
 mm/debug.c               |   10 +++++++++-
 mm/gup.c                 |    8 ++++----
 mm/internal.h            |    3 ++-
 mm/page_alloc.c          |   14 +++++++++++---
 6 files changed, 40 insertions(+), 11 deletions(-)

--- a/include/linux/mm.h~mm-move-_pincount-in-folio-to-page-on-32bit
+++ a/include/linux/mm.h
@@ -2010,6 +2010,13 @@ static inline struct folio *pfn_folio(un
 	return page_folio(pfn_to_page(pfn));
 }
 
+static inline bool folio_has_pincount(const struct folio *folio)
+{
+	if (IS_ENABLED(CONFIG_64BIT))
+		return folio_test_large(folio);
+	return folio_order(folio) > 1;
+}
+
 /**
  * folio_maybe_dma_pinned - Report if a folio may be pinned for DMA.
  * @folio: The folio.
@@ -2026,7 +2033,7 @@ static inline struct folio *pfn_folio(un
  * get that many refcounts, and b) all the callers of this routine are
  * expected to be able to deal gracefully with a false positive.
  *
- * For large folios, the result will be exactly correct. That's because
+ * For most large folios, the result will be exactly correct. That's because
  * we have more tracking data available: the _pincount field is used
  * instead of the GUP_PIN_COUNTING_BIAS scheme.
  *
@@ -2037,7 +2044,7 @@ static inline struct folio *pfn_folio(un
  */
 static inline bool folio_maybe_dma_pinned(struct folio *folio)
 {
-	if (folio_test_large(folio))
+	if (folio_has_pincount(folio))
 		return atomic_read(&folio->_pincount) > 0;
 
 	/*
--- a/include/linux/mm_types.h~mm-move-_pincount-in-folio-to-page-on-32bit
+++ a/include/linux/mm_types.h
@@ -387,7 +387,9 @@ struct folio {
 					atomic_t _large_mapcount;
 					atomic_t _entire_mapcount;
 					atomic_t _nr_pages_mapped;
+#ifdef CONFIG_64BIT
 					atomic_t _pincount;
+#endif /* CONFIG_64BIT */
 	/* private: the union with struct page is transitional */
 				};
 				unsigned long _usable_1[4];
@@ -408,6 +410,9 @@ struct folio {
 			unsigned long _head_2;
 	/* public: */
 			struct list_head _deferred_list;
+#ifndef CONFIG_64BIT
+			atomic_t _pincount;
+#endif /* !CONFIG_64BIT */
 	/* private: the union with struct page is transitional */
 		};
 		struct page __page_2;
--- a/mm/debug.c~mm-move-_pincount-in-folio-to-page-on-32bit
+++ a/mm/debug.c
@@ -79,12 +79,17 @@ static void __dump_folio(struct folio *f
 			folio_ref_count(folio), mapcount, mapping,
 			folio->index + idx, pfn);
 	if (folio_test_large(folio)) {
+		int pincount = 0;
+
+		if (folio_has_pincount(folio))
+			pincount = atomic_read(&folio->_pincount);
+
 		pr_warn("head: order:%u mapcount:%d entire_mapcount:%d nr_pages_mapped:%d pincount:%d\n",
 				folio_order(folio),
 				folio_mapcount(folio),
 				folio_entire_mapcount(folio),
 				folio_nr_pages_mapped(folio),
-				atomic_read(&folio->_pincount));
+				pincount);
 	}
 
 #ifdef CONFIG_MEMCG
@@ -146,6 +151,9 @@ again:
 	if (idx < MAX_FOLIO_NR_PAGES) {
 		memcpy(&folio, foliop, 2 * sizeof(struct page));
 		nr_pages = folio_nr_pages(&folio);
+		if (nr_pages > 1)
+			memcpy(&folio.__page_2, &foliop->__page_2,
+			       sizeof(struct page));
 		foliop = &folio;
 	}
 
--- a/mm/gup.c~mm-move-_pincount-in-folio-to-page-on-32bit
+++ a/mm/gup.c
@@ -109,7 +109,7 @@ static void gup_put_folio(struct folio *
 		if (is_zero_folio(folio))
 			return;
 		node_stat_mod_folio(folio, NR_FOLL_PIN_RELEASED, refs);
-		if (folio_test_large(folio))
+		if (folio_has_pincount(folio))
 			atomic_sub(refs, &folio->_pincount);
 		else
 			refs *= GUP_PIN_COUNTING_BIAS;
@@ -164,7 +164,7 @@ int __must_check try_grab_folio(struct f
 		 * Increment the normal page refcount field at least once,
 		 * so that the page really is pinned.
 		 */
-		if (folio_test_large(folio)) {
+		if (folio_has_pincount(folio)) {
 			folio_ref_add(folio, refs);
 			atomic_add(refs, &folio->_pincount);
 		} else {
@@ -223,7 +223,7 @@ void folio_add_pin(struct folio *folio)
 	 * page refcount field at least once, so that the page really is
 	 * pinned.
 	 */
-	if (folio_test_large(folio)) {
+	if (folio_has_pincount(folio)) {
 		WARN_ON_ONCE(atomic_read(&folio->_pincount) < 1);
 		folio_ref_inc(folio);
 		atomic_inc(&folio->_pincount);
@@ -575,7 +575,7 @@ static struct folio *try_grab_folio_fast
 	 * is pinned.  That's why the refcount from the earlier
 	 * try_get_folio() is left intact.
 	 */
-	if (folio_test_large(folio))
+	if (folio_has_pincount(folio))
 		atomic_add(refs, &folio->_pincount);
 	else
 		folio_ref_add(folio,
--- a/mm/internal.h~mm-move-_pincount-in-folio-to-page-on-32bit
+++ a/mm/internal.h
@@ -764,7 +764,8 @@ static inline void prep_compound_head(st
 	atomic_set(&folio->_large_mapcount, -1);
 	atomic_set(&folio->_entire_mapcount, -1);
 	atomic_set(&folio->_nr_pages_mapped, 0);
-	atomic_set(&folio->_pincount, 0);
+	if (IS_ENABLED(CONFIG_64BIT) || order > 1)
+		atomic_set(&folio->_pincount, 0);
 	if (order > 1)
 		INIT_LIST_HEAD(&folio->_deferred_list);
 }
--- a/mm/page_alloc.c~mm-move-_pincount-in-folio-to-page-on-32bit
+++ a/mm/page_alloc.c
@@ -959,9 +959,11 @@ static int free_tail_page_prepare(struct
 			bad_page(page, "nonzero nr_pages_mapped");
 			goto out;
 		}
-		if (unlikely(atomic_read(&folio->_pincount))) {
-			bad_page(page, "nonzero pincount");
-			goto out;
+		if (IS_ENABLED(CONFIG_64BIT)) {
+			if (unlikely(atomic_read(&folio->_pincount))) {
+				bad_page(page, "nonzero pincount");
+				goto out;
+			}
 		}
 		break;
 	case 2:
@@ -970,6 +972,12 @@ static int free_tail_page_prepare(struct
 			bad_page(page, "on deferred list");
 			goto out;
 		}
+		if (!IS_ENABLED(CONFIG_64BIT)) {
+			if (unlikely(atomic_read(&folio->_pincount))) {
+				bad_page(page, "nonzero pincount");
+				goto out;
+			}
+		}
 		break;
 	case 3:
 		/* the third tail page: hugetlb specifics overlap ->mappings */
_

Patches currently in -mm which might be from david@redhat.com are


