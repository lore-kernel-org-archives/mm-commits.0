From: akpm@linux-foundation.org
Subject: + tmpfs-insert-tmpfs-cache-pages-to-inactive-list-at-first-fix.patch added to -mm tree
Date: Fri, 21 May 2010 11:57:34 -0700
Message-ID: <201005211857.o4LIvYvL028501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755871Ab0EUS6a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 May 2010 14:58:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hmh@hmh.eng.br, hughd@google.com, minchan.kim@gmail.com, riel@redhat.com, shaohua.li@intel.com, stable@kernel.org


The patch titled
     tmpfs-insert-tmpfs-cache-pages-to-inactive-list-at-first-fix
has been added to the -mm tree.  Its filename is
     tmpfs-insert-tmpfs-cache-pages-to-inactive-list-at-first-fix.patch

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
Subject: tmpfs-insert-tmpfs-cache-pages-to-inactive-list-at-first-fix
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

> Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
>
> The preceding comment "they need to go on the active_anon lru below"
> also needs update.
>

Thanks. incremental patch is here.

Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   10 ----------
 mm/filemap.c         |    2 +-
 2 files changed, 1 insertion(+), 11 deletions(-)

diff -puN include/linux/swap.h~tmpfs-insert-tmpfs-cache-pages-to-inactive-list-at-first-fix include/linux/swap.h
--- a/include/linux/swap.h~tmpfs-insert-tmpfs-cache-pages-to-inactive-list-at-first-fix
+++ a/include/linux/swap.h
@@ -224,21 +224,11 @@ static inline void lru_cache_add_anon(st
 	__lru_cache_add(page, LRU_INACTIVE_ANON);
 }
 
-static inline void lru_cache_add_active_anon(struct page *page)
-{
-	__lru_cache_add(page, LRU_ACTIVE_ANON);
-}
-
 static inline void lru_cache_add_file(struct page *page)
 {
 	__lru_cache_add(page, LRU_INACTIVE_FILE);
 }
 
-static inline void lru_cache_add_active_file(struct page *page)
-{
-	__lru_cache_add(page, LRU_ACTIVE_FILE);
-}
-
 /* linux/mm/vmscan.c */
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
diff -puN mm/filemap.c~tmpfs-insert-tmpfs-cache-pages-to-inactive-list-at-first-fix mm/filemap.c
--- a/mm/filemap.c~tmpfs-insert-tmpfs-cache-pages-to-inactive-list-at-first-fix
+++ a/mm/filemap.c
@@ -441,7 +441,7 @@ int add_to_page_cache_lru(struct page *p
 	/*
 	 * Splice_read and readahead add shmem/tmpfs pages into the page cache
 	 * before shmem_readpage has a chance to mark them as SwapBacked: they
-	 * need to go on the active_anon lru below, and mem_cgroup_cache_charge
+	 * need to go on the anon lru below, and mem_cgroup_cache_charge
 	 * (called in add_to_page_cache) needs to know where they're going too.
 	 */
 	if (mapping_cap_swap_backed(mapping))
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
tmpfs-insert-tmpfs-cache-pages-to-inactive-list-at-first.patch
tmpfs-insert-tmpfs-cache-pages-to-inactive-list-at-first-fix.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mm-remove-return-value-of-putback_lru_pages.patch
mempolicy-remove-redundant-code.patch
mempolicy-dont-call-mpol_set_nodemask-when-no_context.patch
mempolicy-lose-unnecessary-loop-variable-in-mpol_parse_str.patch
mempolicy-rename-policy_types-and-cleanup-initialization.patch
mempolicy-factor-mpol_shared_policy_init-return-paths.patch
mempolicy-document-cpuset-interaction-with-tmpfs-mpol-mount-option.patch
mempolicy-restructure-rebinding-mempolicy-functions.patch
cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems.patch
cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-fix2.patch
mmmigration-take-a-reference-to-the-anon_vma-before-migrating.patch
mmmigration-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mmmigration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mmmigration-allow-the-migration-of-pageswapcache-pages.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mmmigration-avoid-race-between-shift_arg_pages-and-rmap_walk-during-migration-by-not-migrating-temporary-stacks.patch
mm-export-unusable-free-space-index-via-debugfs.patch
mm-export-fragmentation-index-via-debugfs.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mmcompaction-memory-compaction-core.patch
mmcompaction-memory-compaction-core-do-not-schedule-work-on-other-cpus-for-compaction.patch
mmcompaction-add-proc-trigger-for-memory-compaction.patch
mmcompaction-add-sys-trigger-for-per-node-memory-compaction.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mmcompaction-defer-compaction-using-an-exponential-backoff-when-compaction-fails.patch
mm-consider-the-entire-user-address-space-during-node-migration.patch
vmscan-prevent-get_scan_ratio-rounding-errors.patch
vmscan-page_check_references-check-low-order-lumpy-reclaim-properly.patch
vmscan-page_check_references-check-low-order-lumpy-reclaim-properly-update.patch
mm-introduce-free_pages_prepare.patch
mm-introduce-free_pages_prepare-fix.patch
vmscan-remove-all_unreclaimable-scan-control.patch
vmscan-remove-isolate_pages-callback-scan-control.patch
mm-fix-nr_section_roots-==-0-when-using-using-sparsemem-extreme.patch
proc-cleanup-remove-unused-assignments.patch
reiser4.patch

