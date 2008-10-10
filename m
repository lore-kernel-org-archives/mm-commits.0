From: akpm@linux-foundation.org
Subject: + memcg-make-page-mapping-null-before-uncharge.patch added to -mm tree
Date: Fri, 10 Oct 2008 16:49:10 -0700
Message-ID: <200810102349.m9ANnAhc018341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753193AbYJJXuL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 19:50:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: make page->mapping NULL before uncharge
has been added to the -mm tree.  Its filename is
     memcg-make-page-mapping-null-before-uncharge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: make page->mapping NULL before uncharge
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch tries to make page->mapping to be NULL before
mem_cgroup_uncharge_cache_page() is called.

"page->mapping == NULL" is a good check for "whether the page is still
radix-tree or not".  This patch also adds BUG_ON() to
mem_cgroup_uncharge_cache_page();

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c    |    2 +-
 mm/memcontrol.c |    1 +
 mm/migrate.c    |    9 +++++++--
 3 files changed, 9 insertions(+), 3 deletions(-)

diff -puN mm/filemap.c~memcg-make-page-mapping-null-before-uncharge mm/filemap.c
--- a/mm/filemap.c~memcg-make-page-mapping-null-before-uncharge
+++ a/mm/filemap.c
@@ -116,12 +116,12 @@ void __remove_from_page_cache(struct pag
 {
 	struct address_space *mapping = page->mapping;
 
-	mem_cgroup_uncharge_cache_page(page);
 	radix_tree_delete(&mapping->page_tree, page->index);
 	page->mapping = NULL;
 	mapping->nrpages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 	BUG_ON(page_mapped(page));
+	mem_cgroup_uncharge_cache_page(page);
 
 	/*
 	 * Some filesystems seem to re-dirty the page even after
diff -puN mm/memcontrol.c~memcg-make-page-mapping-null-before-uncharge mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-make-page-mapping-null-before-uncharge
+++ a/mm/memcontrol.c
@@ -734,6 +734,7 @@ void mem_cgroup_uncharge_page(struct pag
 void mem_cgroup_uncharge_cache_page(struct page *page)
 {
 	VM_BUG_ON(page_mapped(page));
+	VM_BUG_ON(page->mapping);
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE);
 }
 
diff -puN mm/migrate.c~memcg-make-page-mapping-null-before-uncharge mm/migrate.c
--- a/mm/migrate.c~memcg-make-page-mapping-null-before-uncharge
+++ a/mm/migrate.c
@@ -331,8 +331,6 @@ static int migrate_page_move_mapping(str
 	__inc_zone_page_state(newpage, NR_FILE_PAGES);
 
 	spin_unlock_irq(&mapping->tree_lock);
-	if (!PageSwapCache(newpage))
-		mem_cgroup_uncharge_cache_page(page);
 
 	return 0;
 }
@@ -342,6 +340,8 @@ static int migrate_page_move_mapping(str
  */
 static void migrate_page_copy(struct page *newpage, struct page *page)
 {
+	int anon;
+
 	copy_highpage(newpage, page);
 
 	if (PageError(page))
@@ -379,8 +379,13 @@ static void migrate_page_copy(struct pag
 #endif
 	ClearPagePrivate(page);
 	set_page_private(page, 0);
+	/* page->mapping contains a flag for PageAnon() */
+	anon = PageAnon(page);
 	page->mapping = NULL;
 
+	if (!anon) /* This page was removed from radix-tree. */
+		mem_cgroup_uncharge_cache_page(page);
+
 	/*
 	 * If any waiters have accumulated on the new page then
 	 * wake them up.
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

drivers-mfd-ucb1400_corec-further-unbork.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
vmscan-split-lru-lists-into-anon-file-sets-memcg-fix-handling-of-shmem-migrationv2.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-remember-pages-active-state.patch
unevictable-lru-infrastructure-defer-vm-event-counting.patch
unevictable-infrastructure-lru-add-event-counting-with-statistics.patch
shm_locked-pages-are-unevictable-add-event-counts-to-list-scan.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics-mlocked-pages-add-event-counting-with-statistics.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
setup_per_zone_pages_min-take-zone-lock-instead-of-zone-lru_lock.patch
documentation-clarify-dirty_ratio-and-dirty_background_ratio-description-v2.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-cgroups-eliminate-race-in-css_set-refcounting.patch
cgroups-convert-tasks-file-to-use-a-seq_file-with-shared-pid-array.patch
memcg-move-charge-swapin-under-lock.patch
memcg-make-page-mapping-null-before-uncharge.patch
memcg-avoid-accounting-special-pages.patch
memcg-optimize-per-cpu-statistics.patch
memcg-atomic-ops-for-page_cgroup-flags.patch
memcg-allocate-all-page_cgroup-at-boot.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

