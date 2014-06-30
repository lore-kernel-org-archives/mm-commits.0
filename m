From: akpm@linux-foundation.org
Subject: + mm-replace-init_page_accessed-by-__setpagereferenced.patch
 added to -mm tree
Date: Mon, 30 Jun 2014 14:19:36 -0700
Message-ID: <53b1d468.eieEmlKFXldwq02k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:52223 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaF3VTi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jun 2014 17:19:38 -0400
Received: by mail-oa0-f74.google.com with SMTP id i7so2013093oag.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jun 2014 14:19:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, dave.hansen@intel.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, prabhakar.csengg@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: replace init_page_accessed by __SetPageReferenced
has been added to the -mm tree.  Its filename is
     mm-replace-init_page_accessed-by-__setpagereferenced.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-replace-init_page_accessed-by-__setpagereferenced.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-replace-init_page_accessed-by-__setpagereferenced.patch

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
Subject: mm: replace init_page_accessed by __SetPageReferenced

Do we really need an exported alias for __SetPageReferenced()?
Its callers better know what they're doing, in which case the page
would not be already marked referenced.  Kill init_page_accessed(),
just __SetPageReferenced() inline.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
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
@@ -1100,9 +1100,9 @@ no_page:
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
@@ -1143,7 +1143,7 @@ repeat:
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

shmem-fix-init_page_accessed-use-to-stop-pagelru-bug.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
shmem-fix-double-uncharge-in-__shmem_file_setup.patch
shmem-update-memory-reservation-on-truncate.patch
mm-catch-memory-commitment-underflow.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-zbud-zbud_alloc-minor-param-change.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch
list-use-argument-hlist_add_after-names-from-rcu-variant.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

