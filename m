Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E92134420
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 21:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711055011; cv=none; b=Z4Pj2Cn9fYdGqgv81xUSkzs9bUxROml+zS3sJn7rZElv/mnGy2hZqmAokzwnXHy6wZnYSEuHyGezEadndHJfEOwOWO1/QDQuemK37DvjYrnNcvYPa/8HwJhl3T5lXZm0VC38guiYN5aJpkGZ/gOE0pDYs6R1Vt9zox8Ru3pP7+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711055011; c=relaxed/simple;
	bh=gTW+PK1qXB6ZiznEhxjw7S7PpKPMTn38KBs9IX5og84=;
	h=Date:To:From:Subject:Message-Id; b=ryKa4lpZncdj4VfVfgQVzw3t3MIAAHKz2VpihBj3JGJP22N6FfzZnsJZ8W4RCFlK441rTijgwYxVIY/aJxQWZXEUkdWzBmYXU+EgEOns3STbYl8g/YJA6eAyOjAain0Be3l24vsxLTfYOJRNg/mS76rXDYQwkbQSqnXPyMb6wLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pZUKdkr/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pZUKdkr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B989C43390;
	Thu, 21 Mar 2024 21:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711055010;
	bh=gTW+PK1qXB6ZiznEhxjw7S7PpKPMTn38KBs9IX5og84=;
	h=Date:To:From:Subject:From;
	b=pZUKdkr/R6+qiC96dRzSd8weHuvJJRPdSBhddBHWeSg0QdiIrC54b0hgCmReDJ8ud
	 Z5taxKMM8DbPNpV2eTyWGTqecvU+TPFAcdKsFKumOSVNVJDxnKTc47aDFfkoXcsGXi
	 QJmEZz9gCzWmrbd+YKs13YJIP/4iIzZ9zlS/CBoc=
Date: Thu, 21 Mar 2024 14:03:30 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-turn-folio_test_hugetlb-into-a-pagetype.patch added to mm-unstable branch
Message-Id: <20240321210330.8B989C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: turn folio_test_hugetlb into a PageType
has been added to the -mm mm-unstable branch.  Its filename is
     mm-turn-folio_test_hugetlb-into-a-pagetype.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-turn-folio_test_hugetlb-into-a-pagetype.patch

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
Subject: mm: turn folio_test_hugetlb into a PageType
Date: Thu, 21 Mar 2024 14:24:43 +0000

The current folio_test_hugetlb() can be fooled by a concurrent folio split
into returning true for a folio which has never belonged to hugetlbfs. 
This can't happen if the caller holds a refcount on it, but we have a few
places (memory-failure, compaction, procfs) which do not and should not
take a speculative reference.

Since hugetlb pages do not use individual page mapcounts (they are always
fully mapped and use the entire_mapcount field to record the number of
mappings), the PageType field is available now that page_mapcount()
ignores the value in this field.

Link: https://lkml.kernel.org/r/20240321142448.1645400-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h     |   70 ++++++++++++++-----------------
 include/trace/events/mmflags.h |    1 
 mm/hugetlb.c                   |   22 +--------
 3 files changed, 37 insertions(+), 56 deletions(-)

--- a/include/linux/page-flags.h~mm-turn-folio_test_hugetlb-into-a-pagetype
+++ a/include/linux/page-flags.h
@@ -190,7 +190,6 @@ enum pageflags {
 
 	/* At least one page in this folio has the hwpoison flag set */
 	PG_has_hwpoisoned = PG_error,
-	PG_hugetlb = PG_active,
 	PG_large_rmappable = PG_workingset, /* anon or file-backed */
 };
 
@@ -876,29 +875,6 @@ FOLIO_FLAG_FALSE(large_rmappable)
 
 #define PG_head_mask ((1UL << PG_head))
 
-#ifdef CONFIG_HUGETLB_PAGE
-int PageHuge(const struct page *page);
-SETPAGEFLAG(HugeTLB, hugetlb, PF_SECOND)
-CLEARPAGEFLAG(HugeTLB, hugetlb, PF_SECOND)
-
-/**
- * folio_test_hugetlb - Determine if the folio belongs to hugetlbfs
- * @folio: The folio to test.
- *
- * Context: Any context.  Caller should have a reference on the folio to
- * prevent it from being turned into a tail page.
- * Return: True for hugetlbfs folios, false for anon folios or folios
- * belonging to other filesystems.
- */
-static inline bool folio_test_hugetlb(const struct folio *folio)
-{
-	return folio_test_large(folio) &&
-		test_bit(PG_hugetlb, const_folio_flags(folio, 1));
-}
-#else
-TESTPAGEFLAG_FALSE(Huge, hugetlb)
-#endif
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
  * PageHuge() only returns true for hugetlbfs pages, but not for
@@ -955,18 +931,6 @@ PAGEFLAG_FALSE(HasHWPoisoned, has_hwpois
 #endif
 
 /*
- * Check if a page is currently marked HWPoisoned. Note that this check is
- * best effort only and inherently racy: there is no way to synchronize with
- * failing hardware.
- */
-static inline bool is_page_hwpoison(struct page *page)
-{
-	if (PageHWPoison(page))
-		return true;
-	return PageHuge(page) && PageHWPoison(compound_head(page));
-}
-
-/*
  * For pages that are never mapped to userspace (and aren't PageSlab),
  * page_type may be used.  Because it is initialised to -1, we invert the
  * sense of the bit, so __SetPageFoo *clears* the bit used for PageFoo, and
@@ -982,6 +946,7 @@ static inline bool is_page_hwpoison(stru
 #define PG_offline	0x00000100
 #define PG_table	0x00000200
 #define PG_guard	0x00000400
+#define PG_hugetlb	0x00000800
 
 #define PageType(page, flag)						\
 	((page->page_type & (PAGE_TYPE_BASE | flag)) == PAGE_TYPE_BASE)
@@ -1076,6 +1041,37 @@ PAGE_TYPE_OPS(Table, table, pgtable)
  */
 PAGE_TYPE_OPS(Guard, guard, guard)
 
+#ifdef CONFIG_HUGETLB_PAGE
+FOLIO_TYPE_OPS(hugetlb, hugetlb)
+#else
+FOLIO_TEST_FLAG_FALSE(hugetlb)
+#endif
+
+/**
+ * PageHuge - Determine if the page belongs to hugetlbfs
+ * @page: The page to test.
+ *
+ * Context: Any context.
+ * Return: True for hugetlbfs pages, false for anon pages or pages
+ * belonging to other filesystems.
+ */
+static inline bool PageHuge(const struct page *page)
+{
+	return folio_test_hugetlb(page_folio(page));
+}
+
+/*
+ * Check if a page is currently marked HWPoisoned. Note that this check is
+ * best effort only and inherently racy: there is no way to synchronize with
+ * failing hardware.
+ */
+static inline bool is_page_hwpoison(struct page *page)
+{
+	if (PageHWPoison(page))
+		return true;
+	return PageHuge(page) && PageHWPoison(compound_head(page));
+}
+
 extern bool is_free_buddy_page(struct page *page);
 
 PAGEFLAG(Isolated, isolated, PF_ANY);
@@ -1142,7 +1138,7 @@ static __always_inline void __ClearPageA
  */
 #define PAGE_FLAGS_SECOND						\
 	(0xffUL /* order */		| 1UL << PG_has_hwpoisoned |	\
-	 1UL << PG_hugetlb		| 1UL << PG_large_rmappable)
+	 1UL << PG_large_rmappable)
 
 #define PAGE_FLAGS_PRIVATE				\
 	(1UL << PG_private | 1UL << PG_private_2)
--- a/include/trace/events/mmflags.h~mm-turn-folio_test_hugetlb-into-a-pagetype
+++ a/include/trace/events/mmflags.h
@@ -135,6 +135,7 @@ IF_HAVE_PG_ARCH_X(arch_3)
 #define DEF_PAGETYPE_NAME(_name) { PG_##_name, __stringify(_name) }
 
 #define __def_pagetype_names						\
+	DEF_PAGETYPE_NAME(hugetlb),					\
 	DEF_PAGETYPE_NAME(offline),					\
 	DEF_PAGETYPE_NAME(guard),					\
 	DEF_PAGETYPE_NAME(table),					\
--- a/mm/hugetlb.c~mm-turn-folio_test_hugetlb-into-a-pagetype
+++ a/mm/hugetlb.c
@@ -1624,7 +1624,7 @@ static inline void __clear_hugetlb_destr
 {
 	lockdep_assert_held(&hugetlb_lock);
 
-	folio_clear_hugetlb(folio);
+	__folio_clear_hugetlb(folio);
 }
 
 /*
@@ -1711,7 +1711,7 @@ static void add_hugetlb_folio(struct hst
 		h->surplus_huge_pages_node[nid]++;
 	}
 
-	folio_set_hugetlb(folio);
+	__folio_set_hugetlb(folio);
 	folio_change_private(folio, NULL);
 	/*
 	 * We have to set hugetlb_vmemmap_optimized again as above
@@ -2050,7 +2050,7 @@ static void __prep_account_new_huge_page
 
 static void init_new_hugetlb_folio(struct hstate *h, struct folio *folio)
 {
-	folio_set_hugetlb(folio);
+	__folio_set_hugetlb(folio);
 	INIT_LIST_HEAD(&folio->lru);
 	hugetlb_set_folio_subpool(folio, NULL);
 	set_hugetlb_cgroup(folio, NULL);
@@ -2161,22 +2161,6 @@ static bool prep_compound_gigantic_folio
 }
 
 /*
- * PageHuge() only returns true for hugetlbfs pages, but not for normal or
- * transparent huge pages.  See the PageTransHuge() documentation for more
- * details.
- */
-int PageHuge(const struct page *page)
-{
-	const struct folio *folio;
-
-	if (!PageCompound(page))
-		return 0;
-	folio = page_folio(page);
-	return folio_test_hugetlb(folio);
-}
-EXPORT_SYMBOL_GPL(PageHuge);
-
-/*
  * Find and lock address space (mapping) in write mode.
  *
  * Upon entry, the page is locked which means that page_mapping() is
_

Patches currently in -mm which might be from willy@infradead.org are

mm-increase-folio-batch-size.patch
mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch

