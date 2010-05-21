From: akpm@linux-foundation.org
Subject: + tmpfs-insert-tmpfs-cache-pages-to-inactive-list-at-first.patch added to -mm tree
Date: Fri, 21 May 2010 11:52:21 -0700
Message-ID: <201005211852.o4LIqLKs028287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758660Ab0EUSxZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 May 2010 14:53:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hmh@hmh.eng.br, hughd@google.com, minchan.kim@gmail.com, riel@redhat.com, shaohua.li@intel.com, stable@kernel.org


The patch titled
     tmpfs: insert tmpfs cache pages to inactive list at first
has been added to the -mm tree.  Its filename is
     tmpfs-insert-tmpfs-cache-pages-to-inactive-list-at-first.patch

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
Subject: tmpfs: insert tmpfs cache pages to inactive list at first
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Shaohua Li reported parallel file copy on tmpfs can lead to OOM killer. 
This is regression of caused by commit 9ff473b9a7 ("vmscan: evict
streaming IO first").  Wow, It is 2 years old patch!

Currently, tmpfs file cache is inserted active list at first.  This means
that the insertion doesn't only increase numbers of pages in anon LRU, but
it also reduces anon scanning ratio.  Therefore, vmscan will get totally
confused.  It scans almost only file LRU even though the system has plenty
unused tmpfs pages.

Historically, lru_cache_add_active_anon() was used for two reasons.
1) Intend to priotize shmem page rather than regular file cache.
2) Intend to avoid reclaim priority inversion of used once pages.

But we've lost both motivation because (1) Now we have separate anon and
file LRU list.  then, to insert active list doesn't help such priotize. 
(2) In past, one pte access bit will cause page activation.  then to
insert inactive list with pte access bit mean higher priority than to
insert active list.  Its priority inversion may lead to uninteded lru
chun.  but it was already solved by commit 645747462 (vmscan: detect
mapped file pages used only once).  (Thanks Hannes, you are great!)

Thus, now we can use lru_cache_add_anon() instead.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reported-by: Shaohua Li <shaohua.li@intel.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/filemap.c~tmpfs-insert-tmpfs-cache-pages-to-inactive-list-at-first mm/filemap.c
--- a/mm/filemap.c~tmpfs-insert-tmpfs-cache-pages-to-inactive-list-at-first
+++ a/mm/filemap.c
@@ -452,7 +452,7 @@ int add_to_page_cache_lru(struct page *p
 		if (page_is_file_cache(page))
 			lru_cache_add_file(page);
 		else
-			lru_cache_add_active_anon(page);
+			lru_cache_add_anon(page);
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
tmpfs-insert-tmpfs-cache-pages-to-inactive-list-at-first.patch
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

