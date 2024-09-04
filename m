Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2B5763EE
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423506; cv=none; b=V5doSZ9oA3xzrvEVS6kIo9vPXyWEXuywuonp5LC2lBNbfmOMnJQB2koQW16TQ/4rebhvfbpTHKz/OWOvHABhUnGct2ogfTkE4ZjHTca6xXlhBeixLV0dTE186Tb6YflNcwgBEvEsHgABkfKfh348L+4jbWNz1x0II/8ANEAIM1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423506; c=relaxed/simple;
	bh=j3IBoDE6kMphSp1ZwXkdZXyeISLs02RB14+rMuO7wTI=;
	h=Date:To:From:Subject:Message-Id; b=ZsLZ0QXvuq6vPLZTR5+RnvxXiRWaiSEq+zY+LlUczjLK8AeLxkMwTfn8YqwpJIqovhcJxZZMFA51wyf5jUs+CO3NVtY5tBvM3IU2gSq+pi81i88iKvRD5aCLiTy6mS227+Y6/TcAgnbJCZfMByZ6+YQHSDjtFkRrB17Gfb/WcXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mYhuB30q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mYhuB30q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523CBC4CEC2;
	Wed,  4 Sep 2024 04:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423506;
	bh=j3IBoDE6kMphSp1ZwXkdZXyeISLs02RB14+rMuO7wTI=;
	h=Date:To:From:Subject:From;
	b=mYhuB30q3q0YDgPBQtpF/sYrSShGacuFG7NX6ryAKQ13IG7Ch5P8ZFsHjg0nJLdDM
	 Y8HAQk0HHdufLmv+vnBeNb2UNaNnuD+n3tC9HNPVjrpsOm6hI+nbbItMAx4OOp1DTQ
	 NrQMp6B3WWSUIzKe8n7Jr7WFMoI4bmsIdcjJzU34=
Date: Tue, 03 Sep 2024 21:18:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,osalvador@suse.de,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-migration-for-hugepage-in-isolate_single_pageblock.patch removed from -mm tree
Message-Id: <20240904041826.523CBC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove migration for HugePage in isolate_single_pageblock()
has been removed from the -mm tree.  Its filename was
     mm-remove-migration-for-hugepage-in-isolate_single_pageblock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
order-0 pages, its pageblocks after being freed will get to the right
free list.  There is no need to have special handling code for them in
start_isolate_page_range().  For both alloc_contig_range() and memory
offline cases, the migration code after start_isolate_page_range() will
be able to migrate gigantic PageHuge when possible.  Let's clean up
start_isolate_page_range() and fix the aforementioned memory offline
failure issue all together.

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

mm-migrate_device-convert-to-migrate_device_coherent_folio.patch
mm-migrate_device-use-a-folio-in-migrate_device_range.patch
mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch
mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch
mm-remove-isolate_lru_page.patch
mm-remove-isolate_lru_page-fix.patch
mm-remove-putback_lru_page.patch

