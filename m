From: akpm@linux-foundation.org
Subject: + mm-compaction-fix-compactpagefailed-counting.patch added to -mm tree
Date: Fri, 03 Sep 2010 17:02:32 -0700
Message-ID: <201009040002.o8402WPE020292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091Ab0IDADK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 20:03:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, andi@firstfloor.org, cl@linux.com, fengguang.wu@intel.com, hughd@google.com, mel@csn.ul.ie


The patch titled
     mm: compaction: fix COMPACTPAGEFAILED counting
has been added to the -mm tree.  Its filename is
     mm-compaction-fix-compactpagefailed-counting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: compaction: fix COMPACTPAGEFAILED counting
From: Minchan Kim <minchan.kim@gmail.com>

Presently update_nr_listpages() doesn't have a role.  That's because lists
passed is always empty just after calling migrate_pages.  The
migrate_pages cleans up page list which have failed to migrate before
returning by aaa994b3.

 [PATCH] page migration: handle freeing of pages in migrate_pages()

 Do not leave pages on the lists passed to migrate_pages().  Seems that we will
 not need any postprocessing of pages.  This will simplify the handling of
 pages by the callers of migrate_pages().

At that time, we thought we don't need any postprocessing of pages.  But
the situation is changed.  The compaction need to know the number of
failed to migrate for COMPACTPAGEFAILED stat

This patch makes new rule for caller of migrate_pages to call
putback_lru_pages.  So caller need to clean up the lists so it has a
chance to postprocess the pages.  [suggested by Christoph Lameter]

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Reviewed-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    1 +
 mm/memory_hotplug.c |    2 ++
 mm/mempolicy.c      |   10 ++++++++--
 mm/migrate.c        |   12 +++++++-----
 4 files changed, 18 insertions(+), 7 deletions(-)

diff -puN mm/memory-failure.c~mm-compaction-fix-compactpagefailed-counting mm/memory-failure.c
--- a/mm/memory-failure.c~mm-compaction-fix-compactpagefailed-counting
+++ a/mm/memory-failure.c
@@ -1339,6 +1339,7 @@ int soft_offline_page(struct page *page,
 		list_add(&page->lru, &pagelist);
 		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, 0);
 		if (ret) {
+			putback_lru_pages(&pagelist);
 			pr_debug("soft offline: %#lx: migration failed %d, type %lx\n",
 				pfn, ret, page->flags);
 			if (ret > 0)
diff -puN mm/memory_hotplug.c~mm-compaction-fix-compactpagefailed-counting mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-compaction-fix-compactpagefailed-counting
+++ a/mm/memory_hotplug.c
@@ -731,6 +731,8 @@ do_migrate_range(unsigned long start_pfn
 		goto out;
 	/* this function returns # of failed pages */
 	ret = migrate_pages(&source, hotremove_migrate_alloc, 0, 1);
+	if (ret)
+		putback_lru_pages(&source);
 
 out:
 	return ret;
diff -puN mm/mempolicy.c~mm-compaction-fix-compactpagefailed-counting mm/mempolicy.c
--- a/mm/mempolicy.c~mm-compaction-fix-compactpagefailed-counting
+++ a/mm/mempolicy.c
@@ -931,8 +931,11 @@ static int migrate_to_node(struct mm_str
 	check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
 			flags | MPOL_MF_DISCONTIG_OK, &pagelist);
 
-	if (!list_empty(&pagelist))
+	if (!list_empty(&pagelist)) {
 		err = migrate_pages(&pagelist, new_node_page, dest, 0);
+		if (err)
+			putback_lru_pages(&pagelist);
+	}
 
 	return err;
 }
@@ -1147,9 +1150,12 @@ static long do_mbind(unsigned long start
 
 		err = mbind_range(mm, start, end, new);
 
-		if (!list_empty(&pagelist))
+		if (!list_empty(&pagelist)) {
 			nr_failed = migrate_pages(&pagelist, new_vma_page,
 						(unsigned long)vma, 0);
+			if (nr_failed)
+				putback_lru_pages(&pagelist);
+		}
 
 		if (!err && nr_failed && (flags & MPOL_MF_STRICT))
 			err = -EIO;
diff -puN mm/migrate.c~mm-compaction-fix-compactpagefailed-counting mm/migrate.c
--- a/mm/migrate.c~mm-compaction-fix-compactpagefailed-counting
+++ a/mm/migrate.c
@@ -731,8 +731,9 @@ move_newpage:
  *
  * The function returns after 10 attempts or if no pages
  * are movable anymore because to has become empty
- * or no retryable pages exist anymore. All pages will be
- * returned to the LRU or freed.
+ * or no retryable pages exist anymore.
+ * Caller should call putback_lru_pages to return pages to the LRU
+ * or free list.
  *
  * Return: Number of pages not migrated or error code.
  */
@@ -779,8 +780,6 @@ out:
 	if (!swapwrite)
 		current->flags &= ~PF_SWAPWRITE;
 
-	putback_lru_pages(from);
-
 	if (rc)
 		return rc;
 
@@ -889,9 +888,12 @@ set_status:
 	}
 
 	err = 0;
-	if (!list_empty(&pagelist))
+	if (!list_empty(&pagelist)) {
 		err = migrate_pages(&pagelist, new_page_node,
 				(unsigned long)pm, 0);
+		if (err)
+			putback_lru_pages(&pagelist);
+	}
 
 	up_read(&mm->mmap_sem);
 	return err;
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

mm-compaction-handle-active-and-inactive-fairly-in-too_many_isolated.patch
vmstat-update-zone-stat-threshold-when-onlining-a-cpu.patch
mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list.patch
mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list-fix.patch
mm-page-allocator-drain-per-cpu-lists-after-direct-reclaim-allocation-fails.patch
vmscan-prevent-background-aging-of-anon-page-in-no-swap-system.patch
mm-vmap-area-cache.patch
mm-compaction-fix-compactpagefailed-counting.patch

