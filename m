From: akpm@linux-foundation.org
Subject: - page-allocator-inlnie-some-__alloc_pages-wrappers.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:21:25 -0700
Message-ID: <200807242321.m6ONLPfD010395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753336AbYGXXVl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:21:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     page allocator: inline some __alloc_pages() wrappers
has been removed from the -mm tree.  Its filename was
     page-allocator-inlnie-some-__alloc_pages-wrappers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: inline some __alloc_pages() wrappers
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Two zonelist patch series rewrote __page_alloc() largely.  Now, it is just
a wrapper function.  Inlining them will save a function call.

[akpm@linux-foundation.org: export __alloc_pages_internal]
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   21 +++++++++++++++++----
 mm/page_alloc.c     |   19 ++-----------------
 2 files changed, 19 insertions(+), 21 deletions(-)

diff -puN include/linux/gfp.h~page-allocator-inlnie-some-__alloc_pages-wrappers include/linux/gfp.h
--- a/include/linux/gfp.h~page-allocator-inlnie-some-__alloc_pages-wrappers
+++ a/include/linux/gfp.h
@@ -173,11 +173,24 @@ static inline void arch_free_page(struct
 static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
 
-extern struct page *__alloc_pages(gfp_t, unsigned int, struct zonelist *);
+struct page *
+__alloc_pages_internal(gfp_t gfp_mask, unsigned int order,
+		       struct zonelist *zonelist, nodemask_t *nodemask);
+
+static inline struct page *
+__alloc_pages(gfp_t gfp_mask, unsigned int order,
+		struct zonelist *zonelist)
+{
+	return __alloc_pages_internal(gfp_mask, order, zonelist, NULL);
+}
+
+static inline struct page *
+__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
+		struct zonelist *zonelist, nodemask_t *nodemask)
+{
+	return __alloc_pages_internal(gfp_mask, order, zonelist, nodemask);
+}
 
-extern struct page *
-__alloc_pages_nodemask(gfp_t, unsigned int,
-				struct zonelist *, nodemask_t *nodemask);
 
 static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
diff -puN mm/page_alloc.c~page-allocator-inlnie-some-__alloc_pages-wrappers mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-inlnie-some-__alloc_pages-wrappers
+++ a/mm/page_alloc.c
@@ -1429,7 +1429,7 @@ try_next_zone:
 /*
  * This is the 'heart' of the zoned buddy allocator.
  */
-static struct page *
+struct page *
 __alloc_pages_internal(gfp_t gfp_mask, unsigned int order,
 			struct zonelist *zonelist, nodemask_t *nodemask)
 {
@@ -1632,22 +1632,7 @@ nopage:
 got_pg:
 	return page;
 }
-
-struct page *
-__alloc_pages(gfp_t gfp_mask, unsigned int order,
-		struct zonelist *zonelist)
-{
-	return __alloc_pages_internal(gfp_mask, order, zonelist, NULL);
-}
-
-struct page *
-__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
-		struct zonelist *zonelist, nodemask_t *nodemask)
-{
-	return __alloc_pages_internal(gfp_mask, order, zonelist, nodemask);
-}
-
-EXPORT_SYMBOL(__alloc_pages);
+EXPORT_SYMBOL(__alloc_pages_internal);
 
 /*
  * Common helper functions.
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
ahci-use-correct-type-for-cpu-flags.patch
call_usermodehelper-increase-reliability.patch
cgroup-list_for_each-cleanup-v2.patch
cgroup-anotate-two-variables-with-__read_mostly.patch
devcgroup-code-cleanup-fix-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch
per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix-fix.patch
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
vmscan-second-chance-replacement-for-anonymous-pages-fix.patch
vmscan-second-chance-replacement-for-anonymous-pages-memcg-lru-scan-fix.patch
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
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
vmstat-mlocked-pages-statistics-fix.patch
swap-cull-unevictable-pages-in-fault-path-fix.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
vmscam-kill-unused-lru-functions.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch

