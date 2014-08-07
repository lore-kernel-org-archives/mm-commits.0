From: akpm@linux-foundation.org
Subject: [merged]
 mm-replace-init_page_accessed-by-__setpagereferenced.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:05:15 -0700
Message-ID: <53e3dbfb.+m2CHT+jQyczbK0O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:64269 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbaHGUFQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:05:16 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so841628oah.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:05:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, dave.hansen@intel.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, prabhakar.csengg@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: replace init_page_accessed by __SetPageReferenced
has been removed from the -mm tree.  Its filename was
     mm-replace-init_page_accessed-by-__setpagereferenced.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: replace init_page_accessed by __SetPageReferenced

Do we really need an exported alias for __SetPageReferenced()?
Its callers better know what they're doing, in which case the page
would not be already marked referenced.  Kill init_page_accessed(),
just __SetPageReferenced() inline.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 -
 mm/filemap.c         |    4 ++--
 mm/shmem.c           |    2 +-
 mm/swap.c            |   14 +++-----------
 4 files changed, 6 insertions(+), 15 deletions(-)

diff -puN include/linux/swap.h~mm-replace-init_page_accessed-by-__setpagereferenced include/linux/swap.h
--- a/include/linux/swap.h~mm-replace-init_page_accessed-by-__setpagereferenced
+++ a/include/linux/swap.h
@@ -311,7 +311,6 @@ extern void lru_add_page_tail(struct pag
 			 struct lruvec *lruvec, struct list_head *head);
 extern void activate_page(struct page *);
 extern void mark_page_accessed(struct page *);
-extern void init_page_accessed(struct page *page);
 extern void lru_add_drain(void);
 extern void lru_add_drain_cpu(int cpu);
 extern void lru_add_drain_all(void);
diff -puN mm/filemap.c~mm-replace-init_page_accessed-by-__setpagereferenced mm/filemap.c
--- a/mm/filemap.c~mm-replace-init_page_accessed-by-__setpagereferenced
+++ a/mm/filemap.c
@@ -1091,9 +1091,9 @@ no_page:
 		if (WARN_ON_ONCE(!(fgp_flags & FGP_LOCK)))
 			fgp_flags |= FGP_LOCK;
 
-		/* Init accessed so avoit atomic mark_page_accessed later */
+		/* Init accessed so avoid atomic mark_page_accessed later */
 		if (fgp_flags & FGP_ACCESSED)
-			init_page_accessed(page);
+			__SetPageReferenced(page);
 
 		err = add_to_page_cache_lru(page, mapping, offset, radix_gfp_mask);
 		if (unlikely(err)) {
diff -puN mm/shmem.c~mm-replace-init_page_accessed-by-__setpagereferenced mm/shmem.c
--- a/mm/shmem.c~mm-replace-init_page_accessed-by-__setpagereferenced
+++ a/mm/shmem.c
@@ -1166,7 +1166,7 @@ repeat:
 		__SetPageSwapBacked(page);
 		__set_page_locked(page);
 		if (sgp == SGP_WRITE)
-			init_page_accessed(page);
+			__SetPageReferenced(page);
 
 		error = mem_cgroup_charge_file(page, current->mm,
 						gfp & GFP_RECLAIM_MASK);
diff -puN mm/swap.c~mm-replace-init_page_accessed-by-__setpagereferenced mm/swap.c
--- a/mm/swap.c~mm-replace-init_page_accessed-by-__setpagereferenced
+++ a/mm/swap.c
@@ -589,6 +589,9 @@ static void __lru_cache_activate_page(st
  * inactive,unreferenced	->	inactive,referenced
  * inactive,referenced		->	active,unreferenced
  * active,unreferenced		->	active,referenced
+ *
+ * When a newly allocated page is not yet visible, so safe for non-atomic ops,
+ * __SetPageReferenced(page) may be substituted for mark_page_accessed(page).
  */
 void mark_page_accessed(struct page *page)
 {
@@ -614,17 +617,6 @@ void mark_page_accessed(struct page *pag
 }
 EXPORT_SYMBOL(mark_page_accessed);
 
-/*
- * Used to mark_page_accessed(page) that is not visible yet and when it is
- * still safe to use non-atomic ops
- */
-void init_page_accessed(struct page *page)
-{
-	if (!PageReferenced(page))
-		__SetPageReferenced(page);
-}
-EXPORT_SYMBOL(init_page_accessed);
-
 static void __lru_cache_add(struct page *page)
 {
 	struct pagevec *pvec = &get_cpu_var(lru_add_pvec);
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
vmstat-on-demand-vmstat-workers-v8.patch
vmstat-on-demand-vmstat-workers-v8-do-not-open-code-alloc_cpumask_var.patch
mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch
mm-hugetlb-add-migration-entry-check-in-hugetlb_change_protection.patch
mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
linux-next.patch
mm-allow-drivers-to-prevent-new-writable-mappings.patch
shm-add-sealing-api.patch
shm-add-memfd_create-syscall.patch
selftests-add-memfd_create-sealing-tests.patch
selftests-add-memfd-sealing-page-pinning-tests.patch
shm-wait-for-pins-to-be-released-when-sealing.patch
timer-provide-an-api-for-deferrable-timeout.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

