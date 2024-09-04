Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BD480638
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423615; cv=none; b=tJ3yp4J7Ka7PLdv134/sUkJOlJY/70QdNwU+Pal2muiPUsLw5fUGuF1+qUFW9j5dxGu/cQMHPMu6vivOiKCRHStdk8FNiblJGKa0eyF58qVcPs+CqRdtQtOna5owtrucYXQTQKwd8eWUVuESk79VjxcYYiHdrtxg6gfVQZ61wDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423615; c=relaxed/simple;
	bh=AoaAZCzPqm2xdMh3XlXEoj1G2hfGU3FIjrOxcLHBZko=;
	h=Date:To:From:Subject:Message-Id; b=WvsaX4x0hfHPA7y61gHBqArIOscxT+V7ZBV9Opw0xfW/Ovk8ZfJUbwVQTc7seLA3iXki+/sm8lSfJ3cJA6TXtdSYfaRfBzGGfZ3oIcx3jHpwz5ch4nhx0UvracS0DPR/wqejWSWBFcvD8qkV4K77aj6Q+iqgMf2WddL5OeERQt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tIvUKji/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tIvUKji/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F93C4CEC2;
	Wed,  4 Sep 2024 04:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423615;
	bh=AoaAZCzPqm2xdMh3XlXEoj1G2hfGU3FIjrOxcLHBZko=;
	h=Date:To:From:Subject:From;
	b=tIvUKji/ae877GYX296D2ALRhEvJos0zRyR17u/kYPmNAChdQg7oVTtkAjNBT+Xsz
	 eClKCLd16+dv7/q/PXPGTk2pb40GLXPx0WsmJV+YrdWW1xytUAFBNkuMGrk5P7jeVb
	 AKjZbUybT/sqR63EyIlLKZRGpamo4TtdCOUhek3U=
Date: Tue, 03 Sep 2024 21:20:14 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,Jonathan.Cameron@huawei.com,david@redhat.com,dan.carpenter@linaro.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch removed from -mm tree
Message-Id: <20240904042015.69F93C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory_hotplug: unify Huge/LRU/non-LRU movable folio isolation
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory_hotplug: unify Huge/LRU/non-LRU movable folio isolation
Date: Tue, 27 Aug 2024 19:47:28 +0800

Use the isolate_folio_to_list() to unify hugetlb/LRU/non-LRU folio
isolation, which cleanup code a bit and save a few calls to
compound_head().

[wangkefeng.wang@huawei.com: various fixes]
  Link: https://lkml.kernel.org/r/20240829150500.2599549-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240827114728.3212578-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   43 ++++++++++++++----------------------------
 1 file changed, 15 insertions(+), 28 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation
+++ a/mm/memory_hotplug.c
@@ -1772,15 +1772,14 @@ found:
 
 static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 {
+	struct folio *folio;
 	unsigned long pfn;
-	struct page *page;
 	LIST_HEAD(source);
 	static DEFINE_RATELIMIT_STATE(migrate_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
-		struct folio *folio;
-		bool isolated;
+		struct page *page;
 
 		if (!pfn_valid(pfn))
 			continue;
@@ -1811,34 +1810,21 @@ static void do_migrate_range(unsigned lo
 			continue;
 		}
 
-		if (folio_test_hugetlb(folio)) {
-			isolate_hugetlb(folio, &source);
+		if (!folio_try_get(folio))
 			continue;
-		}
 
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
+		if (unlikely(page_folio(page) != folio))
+			goto put_folio;
 
-		} else {
+		if (!isolate_folio_to_list(folio, &source)) {
 			if (__ratelimit(&migrate_rs)) {
-				pr_warn("failed to isolate pfn %lx\n", pfn);
+				pr_warn("failed to isolate pfn %lx\n",
+					page_to_pfn(page));
 				dump_page(page, "isolation failed");
 			}
 		}
-		put_page(page);
+put_folio:
+		folio_put(folio);
 	}
 	if (!list_empty(&source)) {
 		nodemask_t nmask = node_states[N_MEMORY];
@@ -1853,7 +1839,7 @@ static void do_migrate_range(unsigned lo
 		 * We have checked that migration range is on a single zone so
 		 * we can use the nid of the first page to all the others.
 		 */
-		mtc.nid = page_to_nid(list_first_entry(&source, struct page, lru));
+		mtc.nid = folio_nid(list_first_entry(&source, struct folio, lru));
 
 		/*
 		 * try to allocate from a different node but reuse this node
@@ -1866,11 +1852,12 @@ static void do_migrate_range(unsigned lo
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

mm-migrate_device-convert-to-migrate_device_coherent_folio.patch
mm-migrate_device-use-a-folio-in-migrate_device_range.patch
mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch
mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch
mm-remove-isolate_lru_page.patch
mm-remove-isolate_lru_page-fix.patch
mm-remove-putback_lru_page.patch

