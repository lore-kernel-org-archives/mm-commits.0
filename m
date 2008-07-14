From: akpm@linux-foundation.org
Subject: + unevictable-lru-infrastructure-revert-migration-change-of-unevictable-lru-infrastructure.patch added to -mm tree
Date: Mon, 14 Jul 2008 14:34:18 -0700
Message-ID: <200807142134.m6ELYImk028634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756584AbYGNVer (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 17:34:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com


The patch titled
     unevictable-lru-infrastructure: revert migration change of unevictable lru infrastructure
has been added to the -mm tree.  Its filename is
     unevictable-lru-infrastructure-revert-migration-change-of-unevictable-lru-infrastructure.patch

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
Subject: unevictable-lru-infrastructure: revert migration change of unevictable lru infrastructure
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Unevictable LRU Infrastructure patch changed several migration code
because Old version putback_lru_page() had needed to page lock.

It has little performance regression and isn't necessary now.  So,
reverting is better.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   38 +++++++++++---------------------------
 1 file changed, 11 insertions(+), 27 deletions(-)

diff -puN mm/migrate.c~unevictable-lru-infrastructure-revert-migration-change-of-unevictable-lru-infrastructure mm/migrate.c
--- a/mm/migrate.c~unevictable-lru-infrastructure-revert-migration-change-of-unevictable-lru-infrastructure
+++ a/mm/migrate.c
@@ -67,11 +67,7 @@ int putback_lru_pages(struct list_head *
 
 	list_for_each_entry_safe(page, page2, l, lru) {
 		list_del(&page->lru);
-		get_page(page);
-		lock_page(page);
 		putback_lru_page(page);
-		unlock_page(page);
-		put_page(page);
 		count++;
 	}
 	return count;
@@ -581,8 +577,6 @@ static int move_to_new_page(struct page 
 	struct address_space *mapping;
 	int rc;
 
-	get_page(newpage); /* for prevent page release under lock_page() */
-
 	/*
 	 * Block others from accessing the page when we get around to
 	 * establishing additional references. We are the only one
@@ -615,12 +609,10 @@ static int move_to_new_page(struct page 
 
 	if (!rc) {
 		remove_migration_ptes(page, newpage);
-		putback_lru_page(newpage);
 	} else
 		newpage->mapping = NULL;
 
 	unlock_page(newpage);
-	put_page(newpage);
 
 	return rc;
 }
@@ -643,16 +635,13 @@ static int unmap_and_move(new_page_t get
 
 	if (page_count(page) == 1) {
 		/* page was freed from under us. So we are done. */
-		get_page(page);
-		goto end_migration;
+		goto move_newpage;
 	}
 
-	get_page(page);
-
 	charge = mem_cgroup_prepare_migration(page, newpage);
 	if (charge == -ENOMEM) {
 		rc = -ENOMEM;
-		goto end_migration;
+		goto move_newpage;
 	}
 	/* prepare cgroup just returns 0 or -ENOMEM */
 	BUG_ON(charge);
@@ -660,7 +649,7 @@ static int unmap_and_move(new_page_t get
 	rc = -EAGAIN;
 	if (TestSetPageLocked(page)) {
 		if (!force)
-			goto end_migration;
+			goto move_newpage;
 		lock_page(page);
 	}
 
@@ -721,6 +710,7 @@ rcu_unlock:
 		rcu_read_unlock();
 
 unlock:
+	unlock_page(page);
 
 	if (rc != -EAGAIN) {
  		/*
@@ -733,22 +723,16 @@ unlock:
 		putback_lru_page(page);
 	}
 
-	unlock_page(page);
-
-end_migration:
-	put_page(page);
-
+move_newpage:
 	if (!charge)
 		mem_cgroup_end_migration(newpage);
 
-	if (!newpage->mapping) {
-		/*
-		 * Migration failed or was never attempted.
-		 * Free the newpage.
-		 */
-		VM_BUG_ON(page_count(newpage) != 1);
-		put_page(newpage);
-	}
+	/*
+	 * Move the new page to the LRU. If migration was not successful
+	 * then this will free the page.
+	 */
+	putback_lru_page(newpage);
+
 	if (result) {
 		if (rc)
 			*result = rc;
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

