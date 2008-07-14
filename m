From: akpm@linux-foundation.org
Subject: + unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework.patch added to -mm tree
Date: Mon, 14 Jul 2008 14:34:14 -0700
Message-ID: <200807142134.m6ELYF7t028628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756456AbYGNVe0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 17:34:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com


The patch titled
     unevictable-lru-infrastructure: putback_lru_page()/unevictable page handling rework
has been added to the -mm tree.  Its filename is
     unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unevictable-lru-infrastructure: putback_lru_page()/unevictable page handling rework
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Now, putback_lru_page() requires that the page is locked.  And in some
special case, implicitly unlock it.

This patch tries to make putback_lru_pages() to be lock_page() free.  (Of
course, some callers must take the lock.)

The main reason that putback_lru_page() assumes that page is locked is to
avoid the change in page's status among Mlocked/Not-Mlocked.

Once it is added to unevictable list, the page is removed from unevictable
list only when page is munlocked.  (there are other special case.  but we
ignore the special case.) So, status change during putback_lru_page() is
fatal and page should be locked.

putback_lru_page() in this patch has a new concepts.  When it adds page to
unevictable list, it checks the status is changed or not again.  if
changed, retry to putback.

This patche doesn't remove caller's lock_page.  latter patches do it.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 -
 mm/migrate.c  |   33 ++++++++++++----------
 mm/vmscan.c   |   69 +++++++++++++++++++++++++++++++-----------------
 3 files changed, 64 insertions(+), 40 deletions(-)

diff -puN mm/internal.h~unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework mm/internal.h
--- a/mm/internal.h~unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework
+++ a/mm/internal.h
@@ -43,7 +43,7 @@ static inline void __put_page(struct pag
  * in mm/vmscan.c:
  */
 extern int isolate_lru_page(struct page *page);
-extern int putback_lru_page(struct page *page);
+extern void putback_lru_page(struct page *page);
 
 /*
  * in mm/page_alloc.c
diff -puN mm/migrate.c~unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework mm/migrate.c
--- a/mm/migrate.c~unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework
+++ a/mm/migrate.c
@@ -67,9 +67,11 @@ int putback_lru_pages(struct list_head *
 
 	list_for_each_entry_safe(page, page2, l, lru) {
 		list_del(&page->lru);
+		get_page(page);
 		lock_page(page);
-		if (putback_lru_page(page))
-			unlock_page(page);
+		putback_lru_page(page);
+		unlock_page(page);
+		put_page(page);
 		count++;
 	}
 	return count;
@@ -577,9 +579,10 @@ static int fallback_migrate_page(struct 
 static int move_to_new_page(struct page *newpage, struct page *page)
 {
 	struct address_space *mapping;
-	int unlock = 1;
 	int rc;
 
+	get_page(newpage); /* for prevent page release under lock_page() */
+
 	/*
 	 * Block others from accessing the page when we get around to
 	 * establishing additional references. We are the only one
@@ -612,16 +615,12 @@ static int move_to_new_page(struct page 
 
 	if (!rc) {
 		remove_migration_ptes(page, newpage);
-		/*
-		 * Put back on LRU while holding page locked to
-		 * handle potential race with, e.g., munlock()
-		 */
-		unlock = putback_lru_page(newpage);
+		putback_lru_page(newpage);
 	} else
 		newpage->mapping = NULL;
 
-	if (unlock)
-		unlock_page(newpage);
+	unlock_page(newpage);
+	put_page(newpage);
 
 	return rc;
 }
@@ -638,14 +637,17 @@ static int unmap_and_move(new_page_t get
 	struct page *newpage = get_new_page(page, private, &result);
 	int rcu_locked = 0;
 	int charge = 0;
-	int unlock = 1;
 
 	if (!newpage)
 		return -ENOMEM;
 
-	if (page_count(page) == 1)
+	if (page_count(page) == 1) {
 		/* page was freed from under us. So we are done. */
+		get_page(page);
 		goto end_migration;
+	}
+
+	get_page(page);
 
 	charge = mem_cgroup_prepare_migration(page, newpage);
 	if (charge == -ENOMEM) {
@@ -728,13 +730,14 @@ unlock:
  		 * restored.
  		 */
  		list_del(&page->lru);
-		unlock = putback_lru_page(page);
+		putback_lru_page(page);
 	}
 
-	if (unlock)
-		unlock_page(page);
+	unlock_page(page);
 
 end_migration:
+	put_page(page);
+
 	if (!charge)
 		mem_cgroup_end_migration(newpage);
 
diff -puN mm/vmscan.c~unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework mm/vmscan.c
--- a/mm/vmscan.c~unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework
+++ a/mm/vmscan.c
@@ -478,30 +478,20 @@ int remove_mapping(struct address_space 
  * Page may still be unevictable for other reasons.
  *
  * lru_lock must not be held, interrupts must be enabled.
- * Must be called with page locked.
- *
- * return 1 if page still locked [not truncated], else 0
  */
-int putback_lru_page(struct page *page)
+#ifdef CONFIG_UNEVICTABLE_LRU
+void putback_lru_page(struct page *page)
 {
 	int lru;
 	int ret = 1;
 
-	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(PageLRU(page));
 
+redo:
 	lru = !!TestClearPageActive(page);
-	ClearPageUnevictable(page);	/* for page_evictable() */
+	ClearPageUnevictable(page);
 
-	if (unlikely(!page->mapping)) {
-		/*
-		 * page truncated.  drop lock as put_page() will
-		 * free the page.
-		 */
-		VM_BUG_ON(page_count(page) != 1);
-		unlock_page(page);
-		ret = 0;
-	} else if (page_evictable(page, NULL)) {
+	if (page_evictable(page, NULL)) {
 		/*
 		 * For evictable pages, we can use the cache.
 		 * In event of a race, worst case is we end up with an
@@ -510,20 +500,50 @@ int putback_lru_page(struct page *page)
 		 */
 		lru += page_is_file_cache(page);
 		lru_cache_add_lru(page, lru);
-		mem_cgroup_move_lists(page, lru);
 	} else {
 		/*
 		 * Put unevictable pages directly on zone's unevictable
 		 * list.
 		 */
+		lru = LRU_UNEVICTABLE;
 		add_page_to_unevictable_list(page);
-		mem_cgroup_move_lists(page, LRU_UNEVICTABLE);
+	}
+	mem_cgroup_move_lists(page, lru);
+
+	/*
+	 * page's status can change while we move it among lru. If an evictable
+	 * page is on unevictable list, it never be freed. To avoid that,
+	 * check after we added it to the list, again.
+	 */
+	if (lru == LRU_UNEVICTABLE && page_evictable(page, NULL)) {
+		if (!isolate_lru_page(page)) {
+			put_page(page);
+			goto redo;
+		}
+		/* This means someone else dropped this page from LRU
+		 * So, it will be freed or putback to LRU again. There is
+		 * nothing to do here.
+		 */
 	}
 
 	put_page(page);		/* drop ref from isolate */
-	return ret;		/* ret => "page still locked" */
 }
 
+#else /* CONFIG_UNEVICTABLE_LRU */
+
+void putback_lru_page(struct page *page)
+{
+	int lru;
+	VM_BUG_ON(PageLRU(page));
+
+	lru = !!TestClearPageActive(page) + page_is_file_cache(page);
+	lru_cache_add_lru(page, lru);
+	mem_cgroup_move_lists(page, lru);
+	put_page(page);
+}
+#endif /* CONFIG_UNEVICTABLE_LRU */
+
+
 /*
  * Cull page that shrink_*_list() has detected to be unevictable
  * under page lock to close races with other tasks that might be making
@@ -532,11 +552,14 @@ int putback_lru_page(struct page *page)
  */
 static void cull_unevictable_page(struct page *page)
 {
+	get_page(page);
 	lock_page(page);
-	if (putback_lru_page(page))
-		unlock_page(page);
+	putback_lru_page(page);
+	unlock_page(page);
+	put_page(page);
 }
 
+
 /*
  * shrink_page_list() returns the number of reclaimed pages
  */
@@ -571,8 +594,8 @@ static unsigned long shrink_page_list(st
 		sc->nr_scanned++;
 
 		if (unlikely(!page_evictable(page, NULL))) {
-			if (putback_lru_page(page))
-				unlock_page(page);
+			unlock_page(page);
+			putback_lru_page(page);
 			continue;
 		}
 
@@ -2361,8 +2384,6 @@ int zone_reclaim(struct zone *zone, gfp_
 int page_evictable(struct page *page, struct vm_area_struct *vma)
 {
 
-	VM_BUG_ON(PageUnevictable(page));
-
 	/* TODO:  test page [!]evictable conditions */
 
 	return 1;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
mm-hugetlbc-fix-duplicate-variable.patch
page-flags-record-page-flag-overlays-explicitly.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
pm-schedule-sysrq-poweroff-on-boot-cpu-fix.patch
call_usermodehelper-increase-reliability.patch
cgroup-list_for_each-cleanup-v2.patch
cgroup-anotate-two-variables-with-__read_mostly.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-handle-swap-cache-fix-shmem-page-migration-incorrectness-on-memcgroup.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch
per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix.patch
relay-add-buffer-only-channels-useful-for-early-logging-fix.patch
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-collect-lru-meminfo-statistics-from-correct-offset.patch
vmscan-split-lru-lists-into-anon-file-sets-prevent-incorrect-oom-under-split_lru.patch
vmscan-split-lru-lists-into-anon-file-sets-split_lru-fix-pagevec_move_tail-doesnt-treat-unevictable-page.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-infrastructure-remove-redundant-page-mapping-check.patch
unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework.patch
unevictable-lru-infrastructure-kill-unnecessary-lock_page-in-vmscanc.patch
unevictable-lru-infrastructure-revert-migration-change-of-unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
unevictable-lru-page-statistics-fix-printk-in-show_free_areas.patch
unevictable-lru-page-statistics-units-fix.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-revert-shm-change-of-shm_locked-pages-are-unevictable-patch.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mlock-mlocked-pages-are-unevictable-restore-patch-failure-hunk-of-mlock-mlocked-pages-are-unevictablepatch.patch
mlock-mlocked-pages-are-unevictable-fix-truncate-race-and-sevaral-comments.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
vmstat-mlocked-pages-statistics-fix.patch
swap-cull-unevictable-pages-in-fault-path-fix.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
vmscam-kill-unused-lru-functions.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch

