Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B643C3C
	for <mm-commits@vger.kernel.org>; Sat, 31 Aug 2024 00:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725064011; cv=none; b=SLN7puxqpf0wSQp/JCU7ElKroGBwsBLMEdu6apYXWpWcoj8qrJqZqFIHCu+20rKFPMkaXd+m4L2iH+0eHc1oBpXGPUjXGIxpF4u/Mvr1aOKHf/ZjTv4GFkOS08Eyzzrzf3WIUUcDIX971Q9S57yXwoDM+BaE6AsUJCz3y807xKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725064011; c=relaxed/simple;
	bh=nHZuiglF72h+/sfpsZTZ38kuht7JEVpZUL3Owrv+PE8=;
	h=Date:To:From:Subject:Message-Id; b=rV5an+0IHxgz80fqQ0aB4ik7CFb6DSlpmeZmpo1bD9hQw0h0CEfjsXPuj9h2YQgsNit5lk0awSe5/eA0RYx2HweE62sSG0pq4/CyxMLlgcSPJkU38OYqvCOTZWfYSzRPcpTR0tXFIyou6csobM6x6UVPn/vQu21Mw5C5S/N6LIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dfN5cWyy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dfN5cWyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF209C4CEC2;
	Sat, 31 Aug 2024 00:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725064010;
	bh=nHZuiglF72h+/sfpsZTZ38kuht7JEVpZUL3Owrv+PE8=;
	h=Date:To:From:Subject:From;
	b=dfN5cWyygFQiHJtZXWgx96R5xskBSeuPzyQi9YilUmBb5cZPD4Ti4+8ASd0mFoMse
	 Jlocy0P2NhNi5rB6/KQwLnna9sVPsN8Mdalst3B3aSsqAjhmJf3UAaEPEK1J+riUUc
	 8Y+ATDEkty5TXA/tvKxhIkkztAb4CMu0mSO0QA3A=
Date: Fri, 30 Aug 2024 17:26:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,david@redhat.com,baolin.wang@linux.alibaba.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-add-folio_isolate_movable.patch added to mm-unstable branch
Message-Id: <20240831002650.AF209C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate: add folio_isolate_movable()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-add-folio_isolate_movable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-add-folio_isolate_movable.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: migrate: add folio_isolate_movable()
Date: Thu, 29 Aug 2024 22:54:53 +0800

Like isolate_lru_page(), make isolate_movable_page() as a wrapper around
folio_isolate_movable(), since isolate_movable_page() always fails on a
tail page, return immediately for a tail page in the warpper, and the
wrapper will be removed once all callers are converted to
folio_isolate_movable().

Note all isolate_movable_page() users increased page reference, so replace
redundant folio_get_nontail_page() with folio_get() and add a reference
count check into folio_isolate_movable().

Link: https://lkml.kernel.org/r/20240829145456.2591719-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    4 ++
 mm/migrate.c            |   54 +++++++++++++++++++++-----------------
 2 files changed, 34 insertions(+), 24 deletions(-)

--- a/include/linux/migrate.h~mm-migrate-add-folio_isolate_movable
+++ a/include/linux/migrate.h
@@ -70,6 +70,7 @@ int migrate_pages(struct list_head *l, n
 		  unsigned int *ret_succeeded);
 struct folio *alloc_migration_target(struct folio *src, unsigned long private);
 bool isolate_movable_page(struct page *page, isolate_mode_t mode);
+bool folio_isolate_movable(struct folio *folio, isolate_mode_t mode);
 bool isolate_folio_to_list(struct folio *folio, struct list_head *list);
 
 int migrate_huge_page_move_mapping(struct address_space *mapping,
@@ -92,6 +93,9 @@ static inline struct folio *alloc_migrat
 	{ return NULL; }
 static inline bool isolate_movable_page(struct page *page, isolate_mode_t mode)
 	{ return false; }
+static inline bool folio_isolate_movable(struct folio *folio,
+					 isolate_mode_t mode)
+	{ return false; }
 static inline bool isolate_folio_to_list(struct folio *folio, struct list_head *list)
 	{ return false; }
 
--- a/mm/migrate.c~mm-migrate-add-folio_isolate_movable
+++ a/mm/migrate.c
@@ -58,31 +58,30 @@
 
 #include "internal.h"
 
-bool isolate_movable_page(struct page *page, isolate_mode_t mode)
+/**
+ * folio_isolate_movable() - Try to isolate a non-lru movable folio.
+ * @folio: Folio to isolate.
+ *
+ * Must be called with an elevated refcount on the folio.
+ *
+ * Return: true if the folio was isolated, false otherwise
+ */
+bool folio_isolate_movable(struct folio *folio, isolate_mode_t mode)
 {
-	struct folio *folio = folio_get_nontail_page(page);
 	const struct movable_operations *mops;
 
-	/*
-	 * Avoid burning cycles with pages that are yet under __free_pages(),
-	 * or just got freed under us.
-	 *
-	 * In case we 'win' a race for a movable page being freed under us and
-	 * raise its refcount preventing __free_pages() from doing its job
-	 * the put_page() at the end of this block will take care of
-	 * release this page, thus avoiding a nasty leakage.
-	 */
-	if (!folio)
-		goto out;
+	VM_BUG_ON_FOLIO(!folio_ref_count(folio), folio);
+
+	folio_get(folio);
 
 	if (unlikely(folio_test_slab(folio)))
 		goto out_putfolio;
 	/* Pairs with smp_wmb() in slab freeing, e.g. SLUB's __free_slab() */
 	smp_rmb();
 	/*
-	 * Check movable flag before taking the page lock because
-	 * we use non-atomic bitops on newly allocated page flags so
-	 * unconditionally grabbing the lock ruins page's owner side.
+	 * Check movable flag before taking the folio lock because
+	 * we use non-atomic bitops on newly allocated folio flags so
+	 * unconditionally grabbing the lock ruins folio's owner side.
 	 */
 	if (unlikely(!__folio_test_movable(folio)))
 		goto out_putfolio;
@@ -92,15 +91,15 @@ bool isolate_movable_page(struct page *p
 		goto out_putfolio;
 
 	/*
-	 * As movable pages are not isolated from LRU lists, concurrent
-	 * compaction threads can race against page migration functions
-	 * as well as race against the releasing a page.
+	 * As movable folios are not isolated from LRU lists, concurrent
+	 * compaction threads can race against folio migration functions
+	 * as well as race against the releasing a folio.
 	 *
-	 * In order to avoid having an already isolated movable page
+	 * In order to avoid having an already isolated movable folio
 	 * being (wrongly) re-isolated while it is under migration,
-	 * or to avoid attempting to isolate pages being released,
-	 * lets be sure we have the page lock
-	 * before proceeding with the movable page isolation steps.
+	 * or to avoid attempting to isolate folios being released,
+	 * lets be sure we have the folio lock
+	 * before proceeding with the movable folio isolation steps.
 	 */
 	if (unlikely(!folio_trylock(folio)))
 		goto out_putfolio;
@@ -125,10 +124,17 @@ out_no_isolated:
 	folio_unlock(folio);
 out_putfolio:
 	folio_put(folio);
-out:
 	return false;
 }
 
+bool isolate_movable_page(struct page *page, isolate_mode_t mode)
+{
+	if (PageTail(page))
+		return false;
+
+	return folio_isolate_movable((struct folio *)page, mode);
+}
+
 static void putback_movable_folio(struct folio *folio)
 {
 	const struct movable_operations *mops = folio_movable_ops(folio);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch
mm-remove-migration-for-hugepage-in-isolate_single_pageblock.patch
mm-support-only-one-page_type-per-page-fix.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
mm-memory-failure-add-unmap_poisoned_folio.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch
mm-migrate-add-isolate_folio_to_list.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation-fix.patch
mm-migrate_device-convert-to-migrate_device_coherent_folio.patch
mm-migrate_device-use-a-folio-in-migrate_device_range.patch
mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch
mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch
mm-remove-isolate_lru_page.patch
mm-remove-isolate_lru_page-fix.patch
mm-remove-putback_lru_page.patch
mm-compaction-get-reference-before-non-lru-movable-folio-isolation.patch
mm-migrate-add-folio_isolate_movable.patch
mm-migrate-convert-to-folio_isolate_movable.patch
mm-compaction-convert-to-folio_isolate_movable.patch
mm-migrate-remove-isolate_movable_page.patch

