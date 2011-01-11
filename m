From: akpm@linux-foundation.org
Subject: + mm-fix-migration-hangs-on-anon_vma-lock.patch added to -mm tree
Date: Tue, 11 Jan 2011 13:36:06 -0800
Message-ID: <201101112136.p0BLa61e008149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902Ab1AKVgr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Jan 2011 16:36:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, ak@linux.intel.com, j-nomura@ce.jp.nec.com, mel@csn.ul.ie, n-horiguchi@ah.jp.nec.com, riel@redhat.com, stable@kernel.org


The patch titled
     mm: fix migration hangs on anon_vma lock
has been added to the -mm tree.  Its filename is
     mm-fix-migration-hangs-on-anon_vma-lock.patch

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
Subject: mm: fix migration hangs on anon_vma lock
From: Hugh Dickins <hughd@google.com>

Increased usage of page migration in mmotm reveals that the anon_vma
locking in unmap_and_move() has been deficient since 2.6.36 (or even
earlier).  Review at the time of f18194275c39835cb84563500995e0d503a32d9a
("mm: fix hang on anon_vma->root->lock") missed the issue here: the
anon_vma to which we get a reference may already have been freed back to
its slab (it is in use when we check page_mapped, but that can change),
and so its anon_vma->root may be switched at any moment by reuse in
anon_vma_prepare.

Perhaps we could fix that with a get_anon_vma_unless_zero(), but let's
not: just rely on page_lock_anon_vma() to do all the hard thinking for us,
then we don't need any rcu read locking over here.

In removing the rcu_unlock label: since PageAnon is a bit in
page->mapping, it's impossible for a !page->mapping page to be anon; but
insert VM_BUG_ON in case the implementation ever changes.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: <stable@kernel.org> [2.6.37, 2.6.36]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   49 ++++++++++++++++++++-----------------------------
 1 file changed, 20 insertions(+), 29 deletions(-)

diff -puN mm/migrate.c~mm-fix-migration-hangs-on-anon_vma-lock mm/migrate.c
--- a/mm/migrate.c~mm-fix-migration-hangs-on-anon_vma-lock
+++ a/mm/migrate.c
@@ -622,7 +622,6 @@ static int unmap_and_move(new_page_t get
 	int *result = NULL;
 	struct page *newpage = get_new_page(page, private, &result);
 	int remap_swapcache = 1;
-	int rcu_locked = 0;
 	int charge = 0;
 	struct mem_cgroup *mem = NULL;
 	struct anon_vma *anon_vma = NULL;
@@ -694,20 +693,27 @@ static int unmap_and_move(new_page_t get
 	/*
 	 * By try_to_unmap(), page->mapcount goes down to 0 here. In this case,
 	 * we cannot notice that anon_vma is freed while we migrates a page.
-	 * This rcu_read_lock() delays freeing anon_vma pointer until the end
+	 * This get_anon_vma() delays freeing anon_vma pointer until the end
 	 * of migration. File cache pages are no problem because of page_lock()
 	 * File Caches may use write_page() or lock_page() in migration, then,
 	 * just care Anon page here.
 	 */
 	if (PageAnon(page)) {
-		rcu_read_lock();
-		rcu_locked = 1;
-
-		/* Determine how to safely use anon_vma */
-		if (!page_mapped(page)) {
-			if (!PageSwapCache(page))
-				goto rcu_unlock;
-
+		/*
+		 * Only page_lock_anon_vma() understands the subtleties of
+		 * getting a hold on an anon_vma from outside one of its mms.
+		 */
+		anon_vma = page_lock_anon_vma(page);
+		if (anon_vma) {
+			/*
+			 * Take a reference count on the anon_vma if the
+			 * page is mapped so that it is guaranteed to
+			 * exist when the page is remapped later
+			 */
+			get_anon_vma(anon_vma);
+			page_unlock_anon_vma(anon_vma);
+		}
+		else if (PageSwapCache(page)) {
 			/*
 			 * We cannot be sure that the anon_vma of an unmapped
 			 * swapcache page is safe to use because we don't
@@ -722,13 +728,7 @@ static int unmap_and_move(new_page_t get
 			 */
 			remap_swapcache = 0;
 		} else {
-			/*
-			 * Take a reference count on the anon_vma if the
-			 * page is mapped so that it is guaranteed to
-			 * exist when the page is remapped later
-			 */
-			anon_vma = page_anon_vma(page);
-			get_anon_vma(anon_vma);
+			goto uncharge;
 		}
 	}
 
@@ -745,16 +745,10 @@ static int unmap_and_move(new_page_t get
 	 * free the metadata, so the page can be freed.
 	 */
 	if (!page->mapping) {
-		if (!PageAnon(page) && page_has_private(page)) {
-			/*
-			 * Go direct to try_to_free_buffers() here because
-			 * a) that's what try_to_release_page() would do anyway
-			 * b) we may be under rcu_read_lock() here, so we can't
-			 *    use GFP_KERNEL which is what try_to_release_page()
-			 *    needs to be effective.
-			 */
+		VM_BUG_ON(PageAnon(page));
+		if (page_has_private(page)) {
 			try_to_free_buffers(page);
-			goto rcu_unlock;
+			goto uncharge;
 		}
 		goto skip_unmap;
 	}
@@ -768,14 +762,11 @@ skip_unmap:
 
 	if (rc && remap_swapcache)
 		remove_migration_ptes(page, page);
-rcu_unlock:
 
 	/* Drop an anon_vma reference if we took one */
 	if (anon_vma)
 		drop_anon_vma(anon_vma);
 
-	if (rcu_locked)
-		rcu_read_unlock();
 uncharge:
 	if (!charge)
 		mem_cgroup_end_migration(mem, page, newpage);
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-vmap-area-cache-fix.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction-fix.patch
do_wp_page-remove-the-reuse-flag.patch
do_wp_page-clarify-dirty_page-handling.patch
mlock-avoid-dirtying-pages-and-triggering-writeback.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages.patch
mm-add-foll_mlock-follow_page-flag.patch
mm-move-vm_locked-check-to-__mlock_vma_pages_range.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
thp-ksm-free-swap-when-swapcache-page-is-replaced.patch
thp-transparent-hugepage-core-fixlet.patch
thp-ksm-on-thp.patch
thp-add-compound_trans_head-helper.patch
ksm-drain-pagevecs-to-lru.patch
mm-fix-migration-hangs-on-anon_vma-lock.patch
mm-fix-hugepage-migration.patch
memcg-fix-memory-migration-of-shmem-swapcache.patch
prio_tree-debugging-patch.patch

