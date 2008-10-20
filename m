From: akpm@linux-foundation.org
Subject: - memcg-make-page-mapping-null-before-uncharge.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:36:30 -0700
Message-ID: <200810202036.m9KKaU6U011384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754635AbYJTUq6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: make page->mapping NULL before uncharge
has been removed from the -mm tree.  Its filename was
     memcg-make-page-mapping-null-before-uncharge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -330,8 +330,6 @@ static int migrate_page_move_mapping(str
 	__inc_zone_page_state(newpage, NR_FILE_PAGES);
 
 	spin_unlock_irq(&mapping->tree_lock);
-	if (!PageSwapCache(newpage))
-		mem_cgroup_uncharge_cache_page(page);
 
 	return 0;
 }
@@ -341,6 +339,8 @@ static int migrate_page_move_mapping(str
  */
 static void migrate_page_copy(struct page *newpage, struct page *page)
 {
+	int anon;
+
 	copy_highpage(newpage, page);
 
 	if (PageError(page))
@@ -378,8 +378,13 @@ static void migrate_page_copy(struct pag
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

origin.patch
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

