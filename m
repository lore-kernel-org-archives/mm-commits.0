Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82EB1401C
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 01:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724807770; cv=none; b=mkEerGZPiNatCaX0w33RxOZiReSryp8KbShB6oNnFYiKfzB43K7w817GCAlt9lTjjj+39BfA/HmvhttYY+pn7tdL+bYMuZM6Bo8scyMG1ex+lSlyK+CYwSsGrEjQSV59b7QPhU+NSIXLjA74T5ubyOF4nOGzgCI6skO9qMJ0XSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724807770; c=relaxed/simple;
	bh=BLAbdLBop9fraQzVb4NnCI6PJ0z2nkFxpYXbNDWFQ7c=;
	h=Date:To:From:Subject:Message-Id; b=azugcWjIO0XmKTXTlIl7QTgSaPvqSTA7orkUEwW34M1uDxrVw0H5t29xNZUgO+AvZ/kiMtVa4xGccKUY3Vn44PMIXJ7LGFwO4DN4gIJwYApm5V0ZnP8XGHDAMj/vSYtbb8MBKmt6deLIO/PmizDb6Vgpx7qsK54Eb91U5Gkg4wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SP7f0g3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SP7f0g3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6D9C4FDFA;
	Wed, 28 Aug 2024 01:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724807769;
	bh=BLAbdLBop9fraQzVb4NnCI6PJ0z2nkFxpYXbNDWFQ7c=;
	h=Date:To:From:Subject:From;
	b=SP7f0g3ZFBTLx3+0N+ar7xulufdb60zmmnuQNd8UDDBbm4hzkbc7eewFEJVsnR1Ap
	 bAhhumwTI01wqulomdAs4qsHiGy0nnRQAXMf58x4BCcWrGkN0Tc36q5XzONUybqEzp
	 052HyJHgLMiaphsPaAGE5HewKpYT+kBREzzRE9Wg=
Date: Tue, 27 Aug 2024 18:16:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,david@redhat.com,baolin.wang@linux.alibaba.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-add-folio_isolate_movable.patch added to mm-unstable branch
Message-Id: <20240828011609.4A6D9C4FDFA@smtp.kernel.org>
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
Date: Mon, 26 Aug 2024 12:01:29 +0800

Patch series "mm: convert to folio_isolate_movable()".

Add a new helper folio_isolate_movable() and convert various sites to use
it.  Then remove the newly-unused isolate_movable_page().


This patch (of 4):

Like isolate_lru_page(), make isolate_movable_page() as a wrapper around
folio_isolate_movable(), since isolate_movable_page() always fails on a
tail page, return immediately for a tail page in the warpper, and the
wrapper will be removed once all callers are converted to
folio_isolate_movable().

Link: https://lkml.kernel.org/r/20240826040132.1202297-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240826040132.1202297-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    4 +++
 mm/migrate.c            |   41 ++++++++++++++++++++++----------------
 2 files changed, 28 insertions(+), 17 deletions(-)

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
@@ -58,21 +58,20 @@
 
 #include "internal.h"
 
-bool isolate_movable_page(struct page *page, isolate_mode_t mode)
+bool folio_isolate_movable(struct folio *folio, isolate_mode_t mode)
 {
-	struct folio *folio = folio_get_nontail_page(page);
 	const struct movable_operations *mops;
 
 	/*
-	 * Avoid burning cycles with pages that are yet under __free_pages(),
+	 * Avoid burning cycles with folios that are yet under __free_pages(),
 	 * or just got freed under us.
 	 *
-	 * In case we 'win' a race for a movable page being freed under us and
+	 * In case we 'win' a race for a movable folio being freed under us and
 	 * raise its refcount preventing __free_pages() from doing its job
-	 * the put_page() at the end of this block will take care of
-	 * release this page, thus avoiding a nasty leakage.
+	 * the folio_put() at the end of this block will take care of
+	 * release this folio, thus avoiding a nasty leakage.
 	 */
-	if (!folio)
+	if (!folio_try_get(folio))
 		goto out;
 
 	if (unlikely(folio_test_slab(folio)))
@@ -80,9 +79,9 @@ bool isolate_movable_page(struct page *p
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
@@ -129,6 +128,14 @@ out:
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
mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
mm-memory-failure-add-unmap_poisoned_folio.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch
mm-migrate-add-isolate_folio_to_list.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch
mm-migrate_device-convert-to-migrate_device_coherent_folio.patch
mm-migrate_device-use-a-folio-in-migrate_device_range.patch
mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch
mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch
mm-remove-isolate_lru_page.patch
mm-remove-isolate_lru_page-fix.patch
mm-remove-putback_lru_page.patch
mm-migrate-add-folio_isolate_movable.patch
mm-compaction-convert-to-folio_isolate_movable.patch
mm-migrate-convert-to-folio_isolate_movable.patch
mm-migrate-remove-isolate_movable_page.patch

