Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EEC0322A
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 00:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724806388; cv=none; b=LZ+cnARzxuO+bl3+QbtAqcTIZb0Z0BX25ykXa8HPNNXT15RwVEKz/tdDYyLgsMVZgDlmqx1fbwbgqSWUghoJjQqdtz/uIjpy/3FxQKXm+tZvDkw+wxKzq/uuWqM3/3ZrefynO5w/iM2YkJcYYc0dT7iEfgDJ5o2tkOJfYYtnHNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724806388; c=relaxed/simple;
	bh=ENxN+q2LXcST7Do8SzjhfyeuhoAiEFK8TJ/gzU3t2y8=;
	h=Date:To:From:Subject:Message-Id; b=muVvPgP7pa4HesmQ2ziCDNH+VqgskOoFrJZ6YNCADSwTBCuoo5lH2HaJJm3+tl0fyewXqpCHwq0awR716J/sNUQhnW2ZgAGLomX/egdelP+vymO7HWOKupHUeDq0WOY9dg928kf/s8j9WC5l7s9qcTY+HT3osoFStFcLcBxJgf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LvbZ6A6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LvbZ6A6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0806C4AF0C;
	Wed, 28 Aug 2024 00:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724806387;
	bh=ENxN+q2LXcST7Do8SzjhfyeuhoAiEFK8TJ/gzU3t2y8=;
	h=Date:To:From:Subject:From;
	b=LvbZ6A6baO/eJeLj1NF/18MlZ06TYEaVDj3VYI4JTyb895XMZAi/BDdqtx2cmr6zG
	 /gKER1yeIYFt2WtwrW8bBE+nZNuBcIauKw8PAcP0+18zananS65C+nc03hKwC2A9jp
	 31R0GiLxmc9EPx9daIOmFUKn2vQ/vTEsgLaopyFk=
Date: Tue, 27 Aug 2024 17:53:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-isolate_lru_page.patch added to mm-unstable branch
Message-Id: <20240828005307.D0806C4AF0C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove isolate_lru_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-isolate_lru_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-isolate_lru_page.patch

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
Subject: mm: remove isolate_lru_page()
Date: Mon, 26 Aug 2024 14:58:13 +0800

There are no more callers of isolate_lru_page(), remove it.

Link: https://lkml.kernel.org/r/20240826065814.1336616-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/page_migration.rst                    |    6 +++---
 Documentation/mm/unevictable-lru.rst                   |    2 +-
 Documentation/translations/zh_CN/mm/page_migration.rst |    6 +++---
 mm/filemap.c                                           |    2 +-
 mm/folio-compat.c                                      |    7 -------
 mm/internal.h                                          |    1 -
 mm/khugepaged.c                                        |    6 +++---
 mm/migrate_device.c                                    |    2 +-
 mm/swap.c                                              |    2 +-
 9 files changed, 13 insertions(+), 21 deletions(-)

--- a/Documentation/mm/page_migration.rst~mm-remove-isolate_lru_page
+++ a/Documentation/mm/page_migration.rst
@@ -67,8 +67,8 @@ In kernel use of migrate_pages()
 
    Lists of pages to be migrated are generated by scanning over
    pages and moving them into lists. This is done by
-   calling isolate_lru_page().
-   Calling isolate_lru_page() increases the references to the page
+   calling folio_isolate_lru().
+   Calling folio_isolate_lru() increases the references to the page
    so that it cannot vanish while the page migration occurs.
    It also prevents the swapper or other scans from encountering
    the page.
@@ -86,7 +86,7 @@ How migrate_pages() works
 
 migrate_pages() does several passes over its list of pages. A page is moved
 if all references to a page are removable at the time. The page has
-already been removed from the LRU via isolate_lru_page() and the refcount
+already been removed from the LRU via folio_isolate_lru() and the refcount
 is increased so that the page cannot be freed while page migration occurs.
 
 Steps:
--- a/Documentation/mm/unevictable-lru.rst~mm-remove-isolate_lru_page
+++ a/Documentation/mm/unevictable-lru.rst
@@ -230,7 +230,7 @@ In Nick's patch, he used one of the stru
 of VM_LOCKED VMAs that map the page (Rik van Riel had the same idea three years
 earlier).  But this use of the link field for a count prevented the management
 of the pages on an LRU list, and thus mlocked pages were not migratable as
-isolate_lru_page() could not detect them, and the LRU list link field was not
+folio_isolate_lru() could not detect them, and the LRU list link field was not
 available to the migration subsystem.
 
 Nick resolved this by putting mlocked pages back on the LRU list before
--- a/Documentation/translations/zh_CN/mm/page_migration.rst~mm-remove-isolate_lru_page
+++ a/Documentation/translations/zh_CN/mm/page_migration.rst
@@ -50,8 +50,8 @@ 在内核中使用 migrate_pages()
 
 1. 从LRU中移除页面。
 
-   要迁移的页面列表是通过扫描页面并把它们移到列表中来生成的。这是通过调用 isolate_lru_page()
-   来完成的。调用isolate_lru_page()增加了对该页的引用，这样在页面迁移发生时它就不会
+   要迁移的页面列表是通过扫描页面并把它们移到列表中来生成的。这是通过调用 folio_isolate_lru()
+   来完成的。调用folio_isolate_lru()增加了对该页的引用，这样在页面迁移发生时它就不会
    消失。它还可以防止交换器或其他扫描器遇到该页。
 
 
@@ -65,7 +65,7 @@ migrate_pages()如何工作
 =======================
 
 migrate_pages()对它的页面列表进行了多次处理。如果当时对一个页面的所有引用都可以被移除，
-那么这个页面就会被移动。该页已经通过isolate_lru_page()从LRU中移除，并且refcount被
+那么这个页面就会被移动。该页已经通过folio_isolate_lru()从LRU中移除，并且refcount被
 增加，以便在页面迁移发生时不释放该页。
 
 步骤:
--- a/mm/filemap.c~mm-remove-isolate_lru_page
+++ a/mm/filemap.c
@@ -114,7 +114,7 @@
  *    ->private_lock		(try_to_unmap_one)
  *    ->i_pages lock		(try_to_unmap_one)
  *    ->lruvec->lru_lock	(follow_page_mask->mark_page_accessed)
- *    ->lruvec->lru_lock	(check_pte_range->isolate_lru_page)
+ *    ->lruvec->lru_lock	(check_pte_range->folio_isolate_lru)
  *    ->private_lock		(folio_remove_rmap_pte->set_page_dirty)
  *    ->i_pages lock		(folio_remove_rmap_pte->set_page_dirty)
  *    bdi.wb->list_lock		(folio_remove_rmap_pte->set_page_dirty)
--- a/mm/folio-compat.c~mm-remove-isolate_lru_page
+++ a/mm/folio-compat.c
@@ -93,13 +93,6 @@ struct page *grab_cache_page_write_begin
 }
 EXPORT_SYMBOL(grab_cache_page_write_begin);
 
-bool isolate_lru_page(struct page *page)
-{
-	if (WARN_RATELIMIT(PageTail(page), "trying to isolate tail page"))
-		return false;
-	return folio_isolate_lru((struct folio *)page);
-}
-
 void putback_lru_page(struct page *page)
 {
 	folio_putback_lru(page_folio(page));
--- a/mm/internal.h~mm-remove-isolate_lru_page
+++ a/mm/internal.h
@@ -416,7 +416,6 @@ extern unsigned long highest_memmap_pfn;
 /*
  * in mm/vmscan.c:
  */
-bool isolate_lru_page(struct page *page);
 bool folio_isolate_lru(struct folio *folio);
 void putback_lru_page(struct page *page);
 void folio_putback_lru(struct folio *folio);
--- a/mm/khugepaged.c~mm-remove-isolate_lru_page
+++ a/mm/khugepaged.c
@@ -627,7 +627,7 @@ static int __collapse_huge_page_isolate(
 		}
 
 		/*
-		 * We can do it before isolate_lru_page because the
+		 * We can do it before folio_isolate_lru because the
 		 * page can't be freed from under us. NOTE: PG_lock
 		 * is needed to serialize against split_huge_page
 		 * when invoked from the VM.
@@ -1874,7 +1874,7 @@ static int collapse_file(struct mm_struc
 					result = SCAN_FAIL;
 					goto xa_unlocked;
 				}
-				/* drain lru cache to help isolate_lru_page() */
+				/* drain lru cache to help folio_isolate_lru() */
 				lru_add_drain();
 			} else if (folio_trylock(folio)) {
 				folio_get(folio);
@@ -1889,7 +1889,7 @@ static int collapse_file(struct mm_struc
 				page_cache_sync_readahead(mapping, &file->f_ra,
 							  file, index,
 							  end - index);
-				/* drain lru cache to help isolate_lru_page() */
+				/* drain lru cache to help folio_isolate_lru() */
 				lru_add_drain();
 				folio = filemap_lock_folio(mapping, index);
 				if (IS_ERR(folio)) {
--- a/mm/migrate_device.c~mm-remove-isolate_lru_page
+++ a/mm/migrate_device.c
@@ -328,7 +328,7 @@ static bool migrate_vma_check_page(struc
 
 	/*
 	 * One extra ref because caller holds an extra reference, either from
-	 * isolate_lru_page() for a regular page, or migrate_vma_collect() for
+	 * folio_isolate_lru() for a regular page, or migrate_vma_collect() for
 	 * a device page.
 	 */
 	int extra = 1 + (page == fault_page);
--- a/mm/swap.c~mm-remove-isolate_lru_page
+++ a/mm/swap.c
@@ -906,7 +906,7 @@ atomic_t lru_disable_count = ATOMIC_INIT
 
 /*
  * lru_cache_disable() needs to be called before we start compiling
- * a list of pages to be migrated using isolate_lru_page().
+ * a list of pages to be migrated using folio_isolate_lru().
  * It drains pages on LRU cache and then disable on all cpus until
  * lru_cache_enable is called.
  *
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

