From: akpm@linux-foundation.org
Subject: + mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page.patch
 added to -mm tree
Date: Mon, 19 Oct 2015 15:03:26 -0700
Message-ID: <562568ae.9kMeDvD0k9U+o7Nu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbbJSWD1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Oct 2015 18:03:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, andreyknvl@google.com, cl@linux.com, dave@stgolabs.net, dvyukov@google.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename mem_cgroup_migrate to mem_cgroup_replace_page
has been added to the -mm tree.  Its filename is
     mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: rename mem_cgroup_migrate to mem_cgroup_replace_page

After v4.3's commit 0610c25daa3e ("memcg: fix dirty page migration")
mem_cgroup_migrate() doesn't have much to offer in page migration: convert
migrate_misplaced_transhuge_page() to set_page_memcg() instead.

Then rename mem_cgroup_migrate() to mem_cgroup_replace_page(), since its
remaining callers are replace_page_cache_page() and shmem_replace_page():
both of whom passed lrucare true, so just eliminate that argument.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 ++-----
 mm/filemap.c               |    2 +-
 mm/memcontrol.c            |   29 ++++++++---------------------
 mm/migrate.c               |    5 ++---
 mm/shmem.c                 |    2 +-
 5 files changed, 14 insertions(+), 31 deletions(-)

diff -puN include/linux/memcontrol.h~mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page
+++ a/include/linux/memcontrol.h
@@ -297,8 +297,7 @@ void mem_cgroup_cancel_charge(struct pag
 void mem_cgroup_uncharge(struct page *page);
 void mem_cgroup_uncharge_list(struct list_head *page_list);
 
-void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
-			bool lrucare);
+void mem_cgroup_replace_page(struct page *oldpage, struct page *newpage);
 
 struct lruvec *mem_cgroup_zone_lruvec(struct zone *, struct mem_cgroup *);
 struct lruvec *mem_cgroup_page_lruvec(struct page *, struct zone *);
@@ -537,9 +536,7 @@ static inline void mem_cgroup_uncharge_l
 {
 }
 
-static inline void mem_cgroup_migrate(struct page *oldpage,
-				      struct page *newpage,
-				      bool lrucare)
+static inline void mem_cgroup_replace_page(struct page *old, struct page *new)
 {
 }
 
diff -puN mm/filemap.c~mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page mm/filemap.c
--- a/mm/filemap.c~mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page
+++ a/mm/filemap.c
@@ -551,7 +551,7 @@ int replace_page_cache_page(struct page
 			__inc_zone_page_state(new, NR_SHMEM);
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
 		mem_cgroup_end_page_stat(memcg);
-		mem_cgroup_migrate(old, new, true);
+		mem_cgroup_replace_page(old, new);
 		radix_tree_preload_end();
 		if (freepage)
 			freepage(old);
diff -puN mm/memcontrol.c~mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page mm/memcontrol.c
--- a/mm/memcontrol.c~mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page
+++ a/mm/memcontrol.c
@@ -4532,9 +4532,8 @@ static int mem_cgroup_move_account(struc
 		goto out;
 
 	/*
-	 * Prevent mem_cgroup_migrate() from looking at page->mem_cgroup
-	 * of its source page while we change it: page migration takes
-	 * both pages off the LRU, but page cache replacement doesn't.
+	 * Prevent mem_cgroup_replace_page() from looking at
+	 * page->mem_cgroup of its source page while we change it.
 	 */
 	if (!trylock_page(page))
 		goto out;
@@ -5496,7 +5495,7 @@ void mem_cgroup_uncharge_list(struct lis
 }
 
 /**
- * mem_cgroup_migrate - migrate a charge to another page
+ * mem_cgroup_replace_page - migrate a charge to another page
  * @oldpage: currently charged page
  * @newpage: page to transfer the charge to
  * @lrucare: either or both pages might be on the LRU already
@@ -5505,16 +5504,13 @@ void mem_cgroup_uncharge_list(struct lis
  *
  * Both pages must be locked, @newpage->mapping must be set up.
  */
-void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
-			bool lrucare)
+void mem_cgroup_replace_page(struct page *oldpage, struct page *newpage)
 {
 	struct mem_cgroup *memcg;
 	int isolated;
 
 	VM_BUG_ON_PAGE(!PageLocked(oldpage), oldpage);
 	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
-	VM_BUG_ON_PAGE(!lrucare && PageLRU(oldpage), oldpage);
-	VM_BUG_ON_PAGE(!lrucare && PageLRU(newpage), newpage);
 	VM_BUG_ON_PAGE(PageAnon(oldpage) != PageAnon(newpage), newpage);
 	VM_BUG_ON_PAGE(PageTransHuge(oldpage) != PageTransHuge(newpage),
 		       newpage);
@@ -5526,25 +5522,16 @@ void mem_cgroup_migrate(struct page *old
 	if (newpage->mem_cgroup)
 		return;
 
-	/*
-	 * Swapcache readahead pages can get migrated before being
-	 * charged, and migration from compaction can happen to an
-	 * uncharged page when the PFN walker finds a page that
-	 * reclaim just put back on the LRU but has not released yet.
-	 */
+	/* Swapcache readahead pages can get replaced before being charged */
 	memcg = oldpage->mem_cgroup;
 	if (!memcg)
 		return;
 
-	if (lrucare)
-		lock_page_lru(oldpage, &isolated);
-
+	lock_page_lru(oldpage, &isolated);
 	oldpage->mem_cgroup = NULL;
+	unlock_page_lru(oldpage, isolated);
 
-	if (lrucare)
-		unlock_page_lru(oldpage, isolated);
-
-	commit_charge(newpage, memcg, lrucare);
+	commit_charge(newpage, memcg, true);
 }
 
 /*
diff -puN mm/migrate.c~mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page mm/migrate.c
--- a/mm/migrate.c~mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page
+++ a/mm/migrate.c
@@ -30,7 +30,6 @@
 #include <linux/mempolicy.h>
 #include <linux/vmalloc.h>
 #include <linux/security.h>
-#include <linux/memcontrol.h>
 #include <linux/syscalls.h>
 #include <linux/hugetlb.h>
 #include <linux/hugetlb_cgroup.h>
@@ -1831,8 +1830,8 @@ fail_putback:
 	}
 
 	mlock_migrate_page(new_page, page);
-	mem_cgroup_migrate(page, new_page, false);
-
+	set_page_memcg(new_page, page_memcg(page));
+	set_page_memcg(page, NULL);
 	page_remove_rmap(page);
 
 	spin_unlock(ptl);
diff -puN mm/shmem.c~mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page mm/shmem.c
--- a/mm/shmem.c~mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page
+++ a/mm/shmem.c
@@ -1025,7 +1025,7 @@ static int shmem_replace_page(struct pag
 		 */
 		oldpage = newpage;
 	} else {
-		mem_cgroup_migrate(oldpage, newpage, true);
+		mem_cgroup_replace_page(oldpage, newpage);
 		lru_cache_add_anon(newpage);
 		*pagep = newpage;
 	}
_

Patches currently in -mm which might be from hughd@google.com are

memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2.patch
mm-documentation-undoc-non-linear-vmas.patch
mm-rmap-use-pte-lock-not-mmap_sem-to-set-pagemlocked.patch
mm-page-migration-fix-pagemlocked-on-migrated-pages.patch
mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page.patch
mm-correct-a-couple-of-page-migration-comments.patch
mm-page-migration-use-the-put_new_page-whenever-necessary.patch
mm-page-migration-trylock-newpage-at-same-level-as-oldpage.patch
mm-page-migration-remove_migration_ptes-at-lockunlock-level.patch
mm-simplify-page-migrations-anon_vma-comment-and-flow.patch
mm-page-migration-use-migration-entry-for-swapcache-too.patch
mm-page-migration-avoid-touching-newpage-until-no-going-back.patch
mm-migrate-dirty-page-without-clear_page_dirty_for_io-etc.patch
mm-use-unsigned-int-for-page-order-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-4.patch

