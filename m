From: akpm@linux-foundation.org
Subject: + memcg-enhance-memcg-iterator-to-support-predicates-fix.patch
 added to -mm tree
Date: Tue, 20 Aug 2013 14:52:47 -0700
Message-ID: <5213e52f.xsQnMLkAlh+ehSxP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3HTVws (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Aug 2013 17:52:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, hughd@google.com

Subject: + memcg-enhance-memcg-iterator-to-support-predicates-fix.patch added to -mm tree
To: hughd@google.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Tue, 20 Aug 2013 14:52:47 -0700


The patch titled
     Subject: mm: fix memcg-less page reclaim
has been added to the -mm tree.  Its filename is
     memcg-enhance-memcg-iterator-to-support-predicates-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-enhance-memcg-iterator-to-support-predicates-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-enhance-memcg-iterator-to-support-predicates-fix.patch

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
Subject: mm: fix memcg-less page reclaim

Now that everybody loves memcg, configures it on, and would not dream
of booting with cgroup_disable=memory, it can pass unnoticed for weeks
that memcg-less page reclaim is completely broken.

mmotm's "memcg: enhance memcg iterator to support predicates" replaces
__shrink_zone()'s "do { } while (memcg);" loop by a "while (memcg) {}"
loop: which is nicer for memcg, but does nothing for !CONFIG_MEMCG or
cgroup_disable=memory.  Page reclaim hangs, making no progress.

Adding mem_cgroup_disabled() and once++ test there is ugly.  Ideally,
even a !CONFIG_MEMCG build might in future have a stub root_mem_cgroup,
which would get around this: but that's not so at present.

However, it appears that nothing actually dereferences the memcg pointer
in the mem_cgroup_disabled() case, here or anywhere else that case can
reach mem_cgroup_iter() (mem_cgroup_iter_break() is not called in
global reclaim).

So, simply pass back an ordinarily-oopsing non-NULL address the first
time, and we shall hear about it if I'm wrong.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 ++-
 mm/memcontrol.c            |    6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-enhance-memcg-iterator-to-support-predicates-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-enhance-memcg-iterator-to-support-predicates-fix
+++ a/include/linux/memcontrol.h
@@ -328,7 +328,8 @@ mem_cgroup_iter_cond(struct mem_cgroup *
 		struct mem_cgroup_reclaim_cookie *reclaim,
 		mem_cgroup_iter_filter cond)
 {
-	return NULL;
+	/* first call must return non-NULL, second return NULL */
+	return (struct mem_cgroup *)(unsigned long)!prev;
 }
 
 static inline struct mem_cgroup *
diff -puN mm/memcontrol.c~memcg-enhance-memcg-iterator-to-support-predicates-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-enhance-memcg-iterator-to-support-predicates-fix
+++ a/mm/memcontrol.c
@@ -1018,8 +1018,10 @@ struct mem_cgroup *mem_cgroup_iter_cond(
 	struct mem_cgroup *memcg = NULL;
 	struct mem_cgroup *last_visited = NULL;
 
-	if (mem_cgroup_disabled())
-		return NULL;
+	if (mem_cgroup_disabled()) {
+		/* first call must return non-NULL, second return NULL */
+		return (struct mem_cgroup *)(unsigned long)!prev;
+	}
 
 	if (!root)
 		root = root_mem_cgroup;
_

Patches currently in -mm which might be from hughd@google.com are

swap-warn-when-a-swap-area-overflows-the-maximum-size.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff-v2.patch
mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode.patch
mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_shmem_file_read.patch
thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch
swap-change-block-allocation-algorithm-for-ssd.patch
swap-make-swap-discard-async.patch
swap-fix-races-exposed-by-swap-discard.patch
swap-make-cluster-allocation-per-cpu.patch
mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
mm-hugetlb-trivial-commenting-fix.patch
mm-hugetlb-clean-up-alloc_huge_page.patch
mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
mm-migrate-make-core-migration-code-aware-of-hugepage.patch
mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page.patch
migrate-add-hugepage-migration-code-to-migrate_pages.patch
mm-migrate-add-hugepage-migration-code-to-move_pages.patch
mm-mbind-add-hugepage-migration-code-to-mbind.patch
mm-migrate-remove-vm_hugetlb-from-vma-flag-check-in-vma_migratable.patch
mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch
mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2.patch
mm-mempolicy-rename-check_range-to-queue_pages_range.patch
mm-putback_lru_page-remove-unnecessary-call-to-page_lru_base_type.patch
mm-munlock-remove-unnecessary-call-to-lru_add_drain.patch
mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec.patch
mm-munlock-batch-nr_mlock-zone-state-updates.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch
mm-munlock-remove-redundant-get_page-put_page-pair-on-the-fast-path.patch
mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
linux-next.patch
memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
memcg-get-rid-of-soft-limit-tree-infrastructure.patch
vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
memcg-enhance-memcg-iterator-to-support-predicates.patch
memcg-enhance-memcg-iterator-to-support-predicates-fix.patch
memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
memcg-track-all-children-over-limit-in-the-root.patch
memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch

