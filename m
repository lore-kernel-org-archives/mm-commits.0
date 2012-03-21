From: akpm@linux-foundation.org
Subject: [folded] memcg-remove-pcg_cache-page_cgroup-flag-fix.patch removed from -mm tree
Date: Wed, 21 Mar 2012 16:23:39 -0700
Message-ID: <20120321232339.B95F4A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:60428 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975Ab2CUXXl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Mar 2012 19:23:41 -0400
Received: by qcsp5 with SMTP id p5so129706qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 16:23:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, khlebnikov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove PCG_CACHE page_cgroup flag fix
has been removed from the -mm tree.  Its filename was
     memcg-remove-pcg_cache-page_cgroup-flag-fix.patch

This patch was dropped because it was folded into memcg-remove-pcg_cache-page_cgroup-flag.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg: remove PCG_CACHE page_cgroup flag fix

Swapping tmpfs loads show absurd wrapped rss and wrong cache in memcg's
memory.stat statistics: __mem_cgroup_uncharge_common() is failing to
distinguish the anon and tmpfs cases.

Mostly we can decide between them by PageAnon, which is reliable once it
has been set; but there are several callers who need to uncharge a
MEM_CGROUP_CHARGE_TYPE_MAPPED page before it was fully initialized, so
allow that case to override the PageAnon decision.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-pcg_cache-page_cgroup-flag-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-pcg_cache-page_cgroup-flag-fix
+++ a/mm/memcontrol.c
@@ -2946,13 +2946,16 @@ __mem_cgroup_uncharge_common(struct page
 	if (!PageCgroupUsed(pc))
 		goto unlock_out;
 
+	anon = PageAnon(page);
+
 	switch (ctype) {
 	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
+		anon = true;
+		/* fallthrough */
 	case MEM_CGROUP_CHARGE_TYPE_DROP:
 		/* See mem_cgroup_prepare_migration() */
 		if (page_mapped(page) || PageCgroupMigration(pc))
 			goto unlock_out;
-		anon = true;
 		break;
 	case MEM_CGROUP_CHARGE_TYPE_SWAPOUT:
 		if (!PageAnon(page)) {	/* Shared memory */
@@ -2960,10 +2963,8 @@ __mem_cgroup_uncharge_common(struct page
 				goto unlock_out;
 		} else if (page_mapped(page)) /* Anon */
 				goto unlock_out;
-		anon = true;
 		break;
 	default:
-		anon = false;
 		break;
 	}
 
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode.patch
mm-add-rss-counters-consistency-check.patch
mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch
make-swapin-readahead-skip-over-holes.patch
compact_pgdat-workaround-lockdep-warning-in-kswapd.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem.patch
mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch
rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link.patch
mm-vmscan-handle-isolated-pages-with-lru-lock-released.patch
mm-hugetlb-bail-out-unmapping-after-serving-reference-page.patch
tmpfs-security-xattr-setting-on-inode-creation.patch
mm-fix-move-migrate_pages-race-on-task-struct.patch
hugetlbfs-drop-taking-inode-i_mutex-lock-from-hugetlbfs_read.patch
ksm-cleanup-introduce-find_mergeable_vma.patch
hugetlb-cleanup-hugetlbh.patch
hugepages-fix-use-after-free-bug-in-quota-handling.patch
hugetlbfs-fix-alignment-of-huge-page-requests.patch
mm-forbid-lumpy-reclaim-in-shrink_active_list.patch
swap-dont-do-discard-if-no-discard-option-added.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
idr-make-idr_get_next-good-for-rcu_read_lock.patch
cgroup-revert-ss_id_lock-to-spinlock.patch
memcg-let-css_get_next-rely-upon-rcu_read_lock.patch
memcg-remove-pcg_cache-page_cgroup-flag.patch
memcg-use-new-logic-for-page-stat-accounting-fix-2.patch
memcg-remove-pcg_file_mapped-fix-cosmetic-fix.patch
memcg-remove-pcg_file_mapped-fix-42.patch

