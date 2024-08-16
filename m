Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36F72D02E
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 21:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723844582; cv=none; b=XOapGYEeg9A8U353xczBN8e6TzFvSMxW066W0qGitJgw6SPQmmYk8Txo25raAH4/xiPLrwFO4f+/NPR0B6liLb/RtGyyJFtvxlQ8BjhORJWPynChYb6oBB2/GQM2bcMTc3bFhSCGaG362HrDtbIm51/OMm9s/wjjgCAVAdohWFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723844582; c=relaxed/simple;
	bh=3Q1dlA4j6j6VBvRlwa6JqfwdTpMgKiSDmo8nsybdhTA=;
	h=Date:To:From:Subject:Message-Id; b=qky4ZkvK/TrvCNBs+AMjhBkUSStw9xHRPNgSZNugD9/xUiTkaa1dMjMT5vt/qMouVE8szQfQNX0s1li4Rgl2iM8akKXKwgTvqb3iqcMxdic57CllnOeMVhEvP8r+vqdu8z52NOzXCY+bRAPQUv73vKBOcIws1k4boYbTjHovuIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zsmwb804; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zsmwb804"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583BEC32782;
	Fri, 16 Aug 2024 21:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723844582;
	bh=3Q1dlA4j6j6VBvRlwa6JqfwdTpMgKiSDmo8nsybdhTA=;
	h=Date:To:From:Subject:From;
	b=Zsmwb804NvP0/yClX4q2EoR8VgteMyOVmz9D4IEvZKtR/qTE7BWLqXaHrSz/Qbg2W
	 4MdR926PMY9aio85fkW9lWqmtwh0HNmn8TxYh/LqX+42IGEmPRVIh5BeMgSFUjwr7W
	 lvAh9pezAiLOPM67kFsxSgCAT4BKqAxkRjiucyWI=
Date: Fri, 16 Aug 2024 14:43:01 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-add-isolate_folio_to_list.patch added to mm-unstable branch
Message-Id: <20240816214302.583BEC32782@smtp.kernel.org>
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
Date: Fri, 16 Aug 2024 17:04:34 +0800

Add isolate_folio_to_list() helper to try to isolate HugeTLB, no-LRU
movable and LRU folios to a list, which will be reused by
do_migrate_range() from memory hotplug soon, also drop the
mf_isolate_folio() since we could directly use new helper in the
soft_offline_in_use_page().

Link: https://lkml.kernel.org/r/20240816090435.888946-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    3 ++
 mm/memory-failure.c     |   46 +++++++++-----------------------------
 mm/migrate.c            |   27 ++++++++++++++++++++++
 3 files changed, 41 insertions(+), 35 deletions(-)

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
@@ -2737,7 +2703,7 @@ static int soft_offline_in_use_page(stru
 		return 0;
 	}
 
-	if (mf_isolate_folio(folio, &pagelist)) {
+	if (isolate_folio_to_list(folio, &pagelist)) {
 		ret = migrate_pages(&pagelist, alloc_migration_target, NULL,
 			(unsigned long)&mtc, MIGRATE_SYNC, MR_MEMORY_FAILURE, NULL);
 		if (!ret) {
@@ -2759,6 +2725,16 @@ static int soft_offline_in_use_page(stru
 			pfn, msg_page[huge], page_count(page), &page->flags);
 		ret = -EBUSY;
 	}
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
 	return ret;
 }
 
--- a/mm/migrate.c~mm-migrate-add-isolate_folio_to_list
+++ a/mm/migrate.c
@@ -137,6 +137,33 @@ static void putback_movable_folio(struct
 	folio_clear_isolated(folio);
 }
 
+/* Must be called with an elevated refcount on the non-hugetlb folio */
+bool isolate_folio_to_list(struct folio *folio, struct list_head *list)
+{
+	bool isolated = false;
+
+	if (folio_test_hugetlb(folio)) {
+		isolated = isolate_hugetlb(folio, list);
+	} else {
+		bool lru = !__folio_test_movable(folio);
+
+		if (lru)
+			isolated = folio_isolate_lru(folio);
+		else
+			isolated = isolate_movable_page(&folio->page,
+							ISOLATE_UNEVICTABLE);
+
+		if (isolated) {
+			list_add(&folio->lru, list);
+			if (lru)
+				node_stat_add_folio(folio, NR_ISOLATED_ANON +
+						    folio_is_file_lru(folio));
+		}
+	}
+
+	return isolated;
+}
+
 /*
  * Put previously isolated pages back onto the appropriate lists
  * from where they were once taken off for compaction/migration.
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
mm-memory-failure-add-unmap_posioned_folio.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch
mm-migrate-add-isolate_folio_to_list.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch

