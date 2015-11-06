From: akpm@linux-foundation.org
Subject: [merged]
 mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:16:34 -0800
Message-ID: <563d0aa2.8EBb9ywKObiFFB/X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162955AbbKFUQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:16:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, cl@linux.com, dave@stgolabs.net, dvyukov@google.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename mem_cgroup_migrate to mem_cgroup_replace_page
has been removed from the -mm tree.  Its filename was
     mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -4531,9 +4531,8 @@ static int mem_cgroup_move_account(struc
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
@@ -5495,7 +5494,7 @@ void mem_cgroup_uncharge_list(struct lis
 }
 
 /**
- * mem_cgroup_migrate - migrate a charge to another page
+ * mem_cgroup_replace_page - migrate a charge to another page
  * @oldpage: currently charged page
  * @newpage: page to transfer the charge to
  * @lrucare: either or both pages might be on the LRU already
@@ -5504,16 +5503,13 @@ void mem_cgroup_uncharge_list(struct lis
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
@@ -5525,25 +5521,16 @@ void mem_cgroup_migrate(struct page *old
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
