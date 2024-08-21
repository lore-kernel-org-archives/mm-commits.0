Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09420A55
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 01:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724204147; cv=none; b=S7RsuJLuQZbmjMBd390aCIcOrjUKPIhF2bxkL/bc/fjGiokOdgPSlYzLe6v9w17S6wf56yZaErx+LtMuMRN45IHlXh/jArNvdD1yufufXjiH7HfH997FJb6r0xrOBjOEBeWbvkaqMcYToqd6nlOlAdoKzkpX9KN5ccMoalW6ikg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724204147; c=relaxed/simple;
	bh=o3KxPfGC1LSRNa4jFME2EMkf4doKTK8GPwAxNY4t/s4=;
	h=Date:To:From:Subject:Message-Id; b=aZ9ICH5g8Uq7Jtd95xDQGiUK/jOkKooXaFXqffK4oa5Bmi+LjW6ZrVD0rT0blcfgXv9LO+fWReKLrv66kmPJ/T7j3xVypfYUkSrpmDb1sp7JfnNIYgOsOhh/HqCo+mf8AA8LlhzUEKEGaeiAObpu8v7c4gTHjICLpUQswoZGW3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v8ydoyM7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v8ydoyM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87380C4AF0B;
	Wed, 21 Aug 2024 01:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724204146;
	bh=o3KxPfGC1LSRNa4jFME2EMkf4doKTK8GPwAxNY4t/s4=;
	h=Date:To:From:Subject:From;
	b=v8ydoyM7ks2BRpq9wFxtnCYWbyb8MnNsZwbiX22VWwHy/Cw1aCHu4rdD42wDBwZZs
	 4AB91hl4kBM8EZEjzJfvzl6WtfWRzFyYYMYSscDbe9k4sBecLpaUTG5LjjvbdnEe2x
	 kvmiAW98ikN4d/mhZ8xHArgdpOx8+F1ch++jgmQw=
Date: Tue, 20 Aug 2024 18:35:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,osalvador@suse.de,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-migration-for-hugepage-in-isolate_single_pageblock.patch added to mm-unstable branch
Message-Id: <20240821013546.87380C4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove migration for HugePage in isolate_single_pageblock()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-migration-for-hugepage-in-isolate_single_pageblock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-migration-for-hugepage-in-isolate_single_pageblock.patch

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
Subject: mm: remove migration for HugePage in isolate_single_pageblock()
Date: Tue, 20 Aug 2024 11:26:30 +0800

The gigantic page size may larger than memory block size, so memory
offline always fails in this case after commit b2c9e2fbba32 ("mm: make
alloc_contig_range work at pageblock granularity"),

offline_pages
  start_isolate_page_range
    start_isolate_page_range(isolate_before=true)
      isolate [isolate_start, isolate_start + pageblock_nr_pages)
    start_isolate_page_range(isolate_before=false)
      isolate [isolate_end - pageblock_nr_pages, isolate_end) pageblock
       	__alloc_contig_migrate_range
          isolate_migratepages_range
            isolate_migratepages_block
              isolate_or_dissolve_huge_page
                if (hstate_is_gigantic(h))
                    return -ENOMEM;

[   15.815756] memory offlining [mem 0x3c0000000-0x3c7ffffff] failed due to failure to isolate range

Gigantic PageHuge is bigger than a pageblock, but since it is freed as
order-0 pages, its pageblocks after being freed will get to the right free
list.  There is no need to have special handling code for them in
start_isolate_page_range().  For both alloc_contig_range() and memory
offline cases, the migration code after start_isolate_page_range() will be
able to migrate gigantic PageHuge when possible.

Let's clean up start_isolate_page_range() and fix the aforementioned
memory offline failure issue all together.

Link: https://lkml.kernel.org/r/20240820032630.1894770-1-wangkefeng.wang@huawei.com
Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   28 +++-------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

--- a/mm/page_isolation.c~mm-remove-migration-for-hugepage-in-isolate_single_pageblock
+++ a/mm/page_isolation.c
@@ -403,30 +403,8 @@ static int isolate_single_pageblock(unsi
 			unsigned long head_pfn = page_to_pfn(head);
 			unsigned long nr_pages = compound_nr(head);
 
-			if (head_pfn + nr_pages <= boundary_pfn) {
-				pfn = head_pfn + nr_pages;
-				continue;
-			}
-
-#if defined CONFIG_COMPACTION || defined CONFIG_CMA
-			if (PageHuge(page)) {
-				int page_mt = get_pageblock_migratetype(page);
-				struct compact_control cc = {
-					.nr_migratepages = 0,
-					.order = -1,
-					.zone = page_zone(pfn_to_page(head_pfn)),
-					.mode = MIGRATE_SYNC,
-					.ignore_skip_hint = true,
-					.no_set_skip_hint = true,
-					.gfp_mask = gfp_flags,
-					.alloc_contig = true,
-				};
-				INIT_LIST_HEAD(&cc.migratepages);
-
-				ret = __alloc_contig_migrate_range(&cc, head_pfn,
-							head_pfn + nr_pages, page_mt);
-				if (ret)
-					goto failed;
+			if (head_pfn + nr_pages <= boundary_pfn ||
+			    PageHuge(page)) {
 				pfn = head_pfn + nr_pages;
 				continue;
 			}
@@ -440,7 +418,7 @@ static int isolate_single_pageblock(unsi
 			 */
 			VM_WARN_ON_ONCE_PAGE(PageLRU(page), page);
 			VM_WARN_ON_ONCE_PAGE(__PageMovable(page), page);
-#endif
+
 			goto failed;
 		}
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
mm-memory-failure-add-unmap_posioned_folio.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch
mm-migrate-add-isolate_folio_to_list.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch
mm-remove-migration-for-hugepage-in-isolate_single_pageblock.patch

