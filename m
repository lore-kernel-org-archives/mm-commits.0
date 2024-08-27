Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DE584A2F
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724799794; cv=none; b=ReHVuCTS2GLv63MJGWjSEZa6t+78t40F/khKgZt751K3kuqRBsZDAAkDpoPUlc6tYluXxJ9bnkKDeCuiig8o5DRbvHaYUzGYRV133pMy694qw5zdu649Ko9xGiUOgrsCvcZhNCjAf0KUdBeQLyaRJGRujoy4hoAWe6wfiTE78+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724799794; c=relaxed/simple;
	bh=NXuFIx7dfbb5H3WaAilBtLyVyni/gQesw+7DHSmz99U=;
	h=Date:To:From:Subject:Message-Id; b=cr+NXTFEkZ67RwW+eYmoDmpBbhDwAL4K+ngfm2B1eDrMKxTK9GFB5lA7cbwI9tMVllDnLJuWPaPydS0/qHQUPdD+JBLeKqlvi2P3MQ1BH0VmcwlwHzsPRQVT5cNKXA9ryaMDKcEe2d4UCzwWU8xY84BmFkI/MQpQMfnPDi2yL4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dKY7JAPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dKY7JAPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2864C4AF17;
	Tue, 27 Aug 2024 23:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724799793;
	bh=NXuFIx7dfbb5H3WaAilBtLyVyni/gQesw+7DHSmz99U=;
	h=Date:To:From:Subject:From;
	b=dKY7JAPexA4XOqaoZj0ogOkcunrAhWIGIISoyE2fxVbDFZTD92+A51lBERBmVO9JU
	 vS5pMUXeRKCPG14gAnUkcfjhSevX6MvAWgq/PhIwiSvknvOVu4FD0oYJaNngs7AF/0
	 HWLsDXnIZ1mVEFNo6qVubZbNkO4Dy+Wt2Arj+SLQ=
Date: Tue, 27 Aug 2024 16:03:13 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,Jonathan.Cameron@huawei.com,david@redhat.com,dan.carpenter@linaro.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-add-isolate_folio_to_list.patch added to mm-unstable branch
Message-Id: <20240827230313.D2864C4AF17@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate: add isolate_folio_to_list()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-add-isolate_folio_to_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-add-isolate_folio_to_list.patch

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
Subject: mm: migrate: add isolate_folio_to_list()
Date: Tue, 27 Aug 2024 19:47:27 +0800

Add isolate_folio_to_list() helper to try to isolate HugeTLB, no-LRU
movable and LRU folios to a list, which will be reused by
do_migrate_range() from memory hotplug soon, also drop the
mf_isolate_folio() since we could directly use new helper in the
soft_offline_in_use_page().

Link: https://lkml.kernel.org/r/20240827114728.3212578-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Tested-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    3 ++
 mm/memory-failure.c     |   48 ++++++++++----------------------------
 mm/migrate.c            |   26 ++++++++++++++++++++
 3 files changed, 42 insertions(+), 35 deletions(-)

--- a/include/linux/migrate.h~mm-migrate-add-isolate_folio_to_list
+++ a/include/linux/migrate.h
@@ -70,6 +70,7 @@ int migrate_pages(struct list_head *l, n
 		  unsigned int *ret_succeeded);
 struct folio *alloc_migration_target(struct folio *src, unsigned long private);
 bool isolate_movable_page(struct page *page, isolate_mode_t mode);
+bool isolate_folio_to_list(struct folio *folio, struct list_head *list);
 
 int migrate_huge_page_move_mapping(struct address_space *mapping,
 		struct folio *dst, struct folio *src);
@@ -91,6 +92,8 @@ static inline struct folio *alloc_migrat
 	{ return NULL; }
 static inline bool isolate_movable_page(struct page *page, isolate_mode_t mode)
 	{ return false; }
+static inline bool isolate_folio_to_list(struct folio *folio, struct list_head *list)
+	{ return false; }
 
 static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
 				  struct folio *dst, struct folio *src)
--- a/mm/memory-failure.c~mm-migrate-add-isolate_folio_to_list
+++ a/mm/memory-failure.c
@@ -2652,40 +2652,6 @@ EXPORT_SYMBOL(unpoison_memory);
 #undef pr_fmt
 #define pr_fmt(fmt) "Soft offline: " fmt
 
-static bool mf_isolate_folio(struct folio *folio, struct list_head *pagelist)
-{
-	bool isolated = false;
-
-	if (folio_test_hugetlb(folio)) {
-		isolated = isolate_hugetlb(folio, pagelist);
-	} else {
-		bool lru = !__folio_test_movable(folio);
-
-		if (lru)
-			isolated = folio_isolate_lru(folio);
-		else
-			isolated = isolate_movable_page(&folio->page,
-							ISOLATE_UNEVICTABLE);
-
-		if (isolated) {
-			list_add(&folio->lru, pagelist);
-			if (lru)
-				node_stat_add_folio(folio, NR_ISOLATED_ANON +
-						    folio_is_file_lru(folio));
-		}
-	}
-
-	/*
-	 * If we succeed to isolate the folio, we grabbed another refcount on
-	 * the folio, so we can safely drop the one we got from get_any_page().
-	 * If we failed to isolate the folio, it means that we cannot go further
-	 * and we will return an error, so drop the reference we got from
-	 * get_any_page() as well.
-	 */
-	folio_put(folio);
-	return isolated;
-}
-
 /*
  * soft_offline_in_use_page handles hugetlb-pages and non-hugetlb pages.
  * If the page is a non-dirty unmapped page-cache page, it simply invalidates.
@@ -2698,6 +2664,7 @@ static int soft_offline_in_use_page(stru
 	struct folio *folio = page_folio(page);
 	char const *msg_page[] = {"page", "hugepage"};
 	bool huge = folio_test_hugetlb(folio);
+	bool isolated;
 	LIST_HEAD(pagelist);
 	struct migration_target_control mtc = {
 		.nid = NUMA_NO_NODE,
@@ -2737,7 +2704,18 @@ static int soft_offline_in_use_page(stru
 		return 0;
 	}
 
-	if (mf_isolate_folio(folio, &pagelist)) {
+	isolated = isolate_folio_to_list(folio, &pagelist);
+
+	/*
+	 * If we succeed to isolate the folio, we grabbed another refcount on
+	 * the folio, so we can safely drop the one we got from get_any_page().
+	 * If we failed to isolate the folio, it means that we cannot go further
+	 * and we will return an error, so drop the reference we got from
+	 * get_any_page() as well.
+	 */
+	folio_put(folio);
+
+	if (isolated) {
 		ret = migrate_pages(&pagelist, alloc_migration_target, NULL,
 			(unsigned long)&mtc, MIGRATE_SYNC, MR_MEMORY_FAILURE, NULL);
 		if (!ret) {
--- a/mm/migrate.c~mm-migrate-add-isolate_folio_to_list
+++ a/mm/migrate.c
@@ -178,6 +178,32 @@ void putback_movable_pages(struct list_h
 	}
 }
 
+/* Must be called with an elevated refcount on the non-hugetlb folio */
+bool isolate_folio_to_list(struct folio *folio, struct list_head *list)
+{
+	bool isolated, lru;
+
+	if (folio_test_hugetlb(folio))
+		return isolate_hugetlb(folio, list);
+
+	lru = !__folio_test_movable(folio);
+	if (lru)
+		isolated = folio_isolate_lru(folio);
+	else
+		isolated = isolate_movable_page(&folio->page,
+						ISOLATE_UNEVICTABLE);
+
+	if (!isolated)
+		return false;
+
+	list_add(&folio->lru, list);
+	if (lru)
+		node_stat_add_folio(folio, NR_ISOLATED_ANON +
+				    folio_is_file_lru(folio));
+
+	return true;
+}
+
 /*
  * Restore a potential migration pte to a working pte entry
  */
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch
mm-remove-migration-for-hugepage-in-isolate_single_pageblock.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
mm-memory-failure-add-unmap_poisoned_folio.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch
mm-migrate-add-isolate_folio_to_list.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch

