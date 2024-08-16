Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7F97DA64
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 21:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845093; cv=none; b=B+SHm0J5adnTcFXIsccCaYoTKUAsrp60BmhTxzyJr7S3zdRH4a/KeKpuUdZmokmF0+qWtEKXRIBhnwfuxpBKjke2y8qvCJi0nen14PYxAqlZE1Q6xXXYu9rXk1Fylul5KF1J08e2Zo7J/Xb5NBBiQIAzAVqSaKrkO8Pia8QhxLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845093; c=relaxed/simple;
	bh=H0ZHe0pyHqBtlHq+owoENDzqZ0P3QsJewDrhcNfztNE=;
	h=Date:To:From:Subject:Message-Id; b=sOTvBARUB26IV2BGlVa0Hm+o+KrSuaZzGgf5ghOYJFj3+EdZvVFqq8kGX4QgA0QiFAVrnavWC0p+b7wOXPrt9uMKIPuWq6ooJwqdcbeg0go5ozXuB/aFv0TCpPN24zt2sqwmjWiL/jArTs7ffhDyV47c28lYyIQ9Fi5K3D2d8vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ag++g7c3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ag++g7c3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E111BC32782;
	Fri, 16 Aug 2024 21:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723845092;
	bh=H0ZHe0pyHqBtlHq+owoENDzqZ0P3QsJewDrhcNfztNE=;
	h=Date:To:From:Subject:From;
	b=ag++g7c3+LxIga7Xgo87Jd3UjUpWv5d/alYafoWWg2QPtldgrzmk1nf7Amj9xgwG1
	 xd5pmSKJs+SmkI5PzxKVnziCdYJZhZU1l9Sg+G1fERKhDO8I088H5P/EdrAIGUIJy2
	 63HlUWRsaFIYfHHoYRel7ZuUOhqYUcxIzohmB4To=
Date: Fri, 16 Aug 2024 14:51:31 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,surenb@google.com,shli@fb.com,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,kaleshsingh@google.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch added to mm-unstable branch
Message-Id: <20240816215131.E111BC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory_hotplug: unify Huge/LRU/non-LRU movable folio isolation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch

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
Subject: mm: memory_hotplug: unify Huge/LRU/non-LRU movable folio isolation
Date: Fri, 16 Aug 2024 17:04:35 +0800

Use the isolate_folio_to_list() to unify hugetlb/LRU/non-LRU folio
isolation, which cleanup code a bit and save a few calls to
compound_head().

Link: https://lkml.kernel.org/r/20240816090435.888946-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   45 +++++++++++++++---------------------------
 1 file changed, 17 insertions(+), 28 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation
+++ a/mm/memory_hotplug.c
@@ -1773,14 +1773,14 @@ found:
 static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 {
 	unsigned long pfn;
-	struct page *page;
 	LIST_HEAD(source);
+	struct folio *folio;
 	static DEFINE_RATELIMIT_STATE(migrate_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
-		struct folio *folio;
-		bool isolated;
+		struct page *page;
+		bool huge;
 
 		if (!pfn_valid(pfn))
 			continue;
@@ -1812,34 +1812,22 @@ static void do_migrate_range(unsigned lo
 			continue;
 		}
 
-		if (folio_test_hugetlb(folio)) {
-			isolate_hugetlb(folio, &source);
-			continue;
+		huge = folio_test_hugetlb(folio);
+		if (!huge) {
+			folio = folio_get_nontail_page(page);
+			if (!folio)
+				continue;
 		}
 
-		if (!get_page_unless_zero(page))
-			continue;
-		/*
-		 * We can skip free pages. And we can deal with pages on
-		 * LRU and non-lru movable pages.
-		 */
-		if (PageLRU(page))
-			isolated = isolate_lru_page(page);
-		else
-			isolated = isolate_movable_page(page, ISOLATE_UNEVICTABLE);
-		if (isolated) {
-			list_add_tail(&page->lru, &source);
-			if (!__PageMovable(page))
-				inc_node_page_state(page, NR_ISOLATED_ANON +
-						    page_is_file_lru(page));
-
-		} else {
+		if (!isolate_folio_to_list(folio, &source)) {
 			if (__ratelimit(&migrate_rs)) {
 				pr_warn("failed to isolate pfn %lx\n", pfn);
 				dump_page(page, "isolation failed");
 			}
 		}
-		put_page(page);
+
+		if (!huge)
+			folio_put(folio);
 	}
 	if (!list_empty(&source)) {
 		nodemask_t nmask = node_states[N_MEMORY];
@@ -1854,7 +1842,7 @@ static void do_migrate_range(unsigned lo
 		 * We have checked that migration range is on a single zone so
 		 * we can use the nid of the first page to all the others.
 		 */
-		mtc.nid = page_to_nid(list_first_entry(&source, struct page, lru));
+		mtc.nid = folio_nid(list_first_entry(&source, struct folio, lru));
 
 		/*
 		 * try to allocate from a different node but reuse this node
@@ -1867,11 +1855,12 @@ static void do_migrate_range(unsigned lo
 		ret = migrate_pages(&source, alloc_migration_target, NULL,
 			(unsigned long)&mtc, MIGRATE_SYNC, MR_MEMORY_HOTPLUG, NULL);
 		if (ret) {
-			list_for_each_entry(page, &source, lru) {
+			list_for_each_entry(folio, &source, lru) {
 				if (__ratelimit(&migrate_rs)) {
 					pr_warn("migrating pfn %lx failed ret:%d\n",
-						page_to_pfn(page), ret);
-					dump_page(page, "migration failure");
+						folio_pfn(folio), ret);
+					dump_page(&folio->page,
+						  "migration failure");
 				}
 			}
 			putback_movable_pages(&source);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
mm-memory-failure-add-unmap_posioned_folio.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch
mm-migrate-add-isolate_folio_to_list.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch

