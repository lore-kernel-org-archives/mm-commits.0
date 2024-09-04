Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFF680BF8
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423614; cv=none; b=EKO2YLGtoknRS2hkAjgIwc4DCkJILrLJdqmFwpWW6Q+BHXPRFP2sEj0FO0VrEYbXLbj+KHOzJGfnTNLk89mURTZGfmgJJHy0Ceek5hMWFy4bCWyk8PWprYb7bvJcL2fr8CBTRaNy135bchfXkJEuaOOuB018dOE/rn043YXgUS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423614; c=relaxed/simple;
	bh=TANuTRkjtygvAlwfWe5CbPrW9l1uv+VMvf08RrwhGeQ=;
	h=Date:To:From:Subject:Message-Id; b=F5CIolBHR8p3NZtAeEoiifp7NVV1HWYIIoz8Q6VOXEzaj5A9EGk2mqugTHnb/BZh87bFVpPc0rhFIA579rI4mPWrWtzd8L8kx+k5OA4FQ+7hTc+/SancfnvJQtSiXcGk6mjHO987zd4hD3umZuzjdxn0AnLBNjNguUf6sefX3AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fx48WSY2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fx48WSY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A4EC4CEC2;
	Wed,  4 Sep 2024 04:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423614;
	bh=TANuTRkjtygvAlwfWe5CbPrW9l1uv+VMvf08RrwhGeQ=;
	h=Date:To:From:Subject:From;
	b=fx48WSY2EQ4WowgT+c6tVDjUCjI9qDop19wJxr7RWF2LVuYhWwhhUDPuyniYy03+I
	 gYi7oRvk8MK4qDMBzhuuXYDKBKuGcGNkYjCiP17nUhHr1v+RCCjUbBF3r5A2IwYmsm
	 gis2V7+Y/EzaizhR2/ro+8LzzXjT2hWzuurHaw2c=
Date: Tue, 03 Sep 2024 21:20:13 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,Jonathan.Cameron@huawei.com,david@redhat.com,dan.carpenter@linaro.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-add-isolate_folio_to_list.patch removed from -mm tree
Message-Id: <20240904042014.12A4EC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: migrate: add isolate_folio_to_list()
has been removed from the -mm tree.  Its filename was
     mm-migrate-add-isolate_folio_to_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2653,40 +2653,6 @@ EXPORT_SYMBOL(unpoison_memory);
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
@@ -2699,6 +2665,7 @@ static int soft_offline_in_use_page(stru
 	struct folio *folio = page_folio(page);
 	char const *msg_page[] = {"page", "hugepage"};
 	bool huge = folio_test_hugetlb(folio);
+	bool isolated;
 	LIST_HEAD(pagelist);
 	struct migration_target_control mtc = {
 		.nid = NUMA_NO_NODE,
@@ -2738,7 +2705,18 @@ static int soft_offline_in_use_page(stru
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

mm-migrate_device-convert-to-migrate_device_coherent_folio.patch
mm-migrate_device-use-a-folio-in-migrate_device_range.patch
mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch
mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch
mm-remove-isolate_lru_page.patch
mm-remove-isolate_lru_page-fix.patch
mm-remove-putback_lru_page.patch

