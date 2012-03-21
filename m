From: akpm@linux-foundation.org
Subject: [folded] memcg-remove-pcg_file_mapped-fix-42.patch removed from -mm tree
Date: Wed, 21 Mar 2012 16:26:31 -0700
Message-ID: <20120321232631.A4EBFA0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:53914 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253Ab2CUX0c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Mar 2012 19:26:32 -0400
Received: by qabg24 with SMTP id g24so1507qab.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 16:26:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove PCG_CACHE page_cgroup flag fix2
has been removed from the -mm tree.  Its filename was
     memcg-remove-pcg_file_mapped-fix-42.patch

This patch was dropped because it was folded into memcg-remove-pcg_file_mapped.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg: remove PCG_CACHE page_cgroup flag fix2

Add comment to MEM_CGROUP_CHARGE_TYPE_MAPPED case in
__mem_cgroup_uncharge_common().

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/memcontrol.c~memcg-remove-pcg_file_mapped-fix-42 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-pcg_file_mapped-fix-42
+++ a/mm/memcontrol.c
@@ -2978,6 +2978,11 @@ __mem_cgroup_uncharge_common(struct page
 
 	switch (ctype) {
 	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
+		/*
+		 * Generally PageAnon tells if it's the anon statistics to be
+		 * updated; but sometimes e.g. mem_cgroup_uncharge_page() is
+		 * used before page reached the stage of being marked PageAnon.
+		 */
 		anon = true;
 		/* fallthrough */
 	case MEM_CGROUP_CHARGE_TYPE_DROP:
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
memcg-use-new-logic-for-page-stat-accounting.patch
memcg-remove-pcg_file_mapped.patch

