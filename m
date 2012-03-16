From: akpm@linux-foundation.org
Subject: [merged] memcg-free-mem_cgroup-by-rcu-to-fix-oops.patch removed from -mm tree
Date: Fri, 16 Mar 2012 13:57:51 -0700
Message-ID: <20120316205751.6479BA0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:62201 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965109Ab2CPU5y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Mar 2012 16:57:54 -0400
Received: by faaa19 with SMTP id a19so211242faa.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Mar 2012 13:57:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, khlebnikov@openvz.org, tj@kernel.org, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: free mem_cgroup by RCU to fix oops
has been removed from the -mm tree.  Its filename was
     memcg-free-mem_cgroup-by-rcu-to-fix-oops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg: free mem_cgroup by RCU to fix oops

After fixing the GPF in mem_cgroup_lru_del_list(), three times one machine
running a similar load (moving and removing memcgs while swapping) has
oopsed in mem_cgroup_zone_nr_lru_pages(), when retrieving memcg zone
numbers for get_scan_count() for shrink_mem_cgroup_zone(): this is where a
struct mem_cgroup is first accessed after being chosen by
mem_cgroup_iter().

Just what protects a struct mem_cgroup from being freed, in between
mem_cgroup_iter()'s css_get_next() and its css_tryget()?  css_tryget()
fails once css->refcnt is zero with CSS_REMOVED set in flags, yes: but
what if that memory is freed and reused for something else, which sets
"refcnt" non-zero?  Hmm, and scope for an indefinite freeze if refcnt is
left at zero but flags are cleared.

It's tempting to move the css_tryget() into css_get_next(), to make it
really "get" the css, but I don't think that actually solves anything: the
same difficulty in moving from css_id found to stable css remains.

But we already have rcu_read_lock() around the two, so it's easily fixed
if __mem_cgroup_free() just uses kfree_rcu() to free mem_cgroup.

However, a big struct mem_cgroup is allocated with vzalloc() instead of
kzalloc(), and we're not allowed to vfree() at interrupt time: there
doesn't appear to be a general vfree_rcu() to help with this, so roll our
own using schedule_work().  The compiler decently removes vfree_work() and
vfree_rcu() when the config doesn't need them.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   53 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 47 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~memcg-free-mem_cgroup-by-rcu-to-fix-oops mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-free-mem_cgroup-by-rcu-to-fix-oops
+++ a/mm/memcontrol.c
@@ -230,10 +230,30 @@ struct mem_cgroup {
 	 * the counter to account for memory usage
 	 */
 	struct res_counter res;
-	/*
-	 * the counter to account for mem+swap usage.
-	 */
-	struct res_counter memsw;
+
+	union {
+		/*
+		 * the counter to account for mem+swap usage.
+		 */
+		struct res_counter memsw;
+
+		/*
+		 * rcu_freeing is used only when freeing struct mem_cgroup,
+		 * so put it into a union to avoid wasting more memory.
+		 * It must be disjoint from the css field.  It could be
+		 * in a union with the res field, but res plays a much
+		 * larger part in mem_cgroup life than memsw, and might
+		 * be of interest, even at time of free, when debugging.
+		 * So share rcu_head with the less interesting memsw.
+		 */
+		struct rcu_head rcu_freeing;
+		/*
+		 * But when using vfree(), that cannot be done at
+		 * interrupt time, so we must then queue the work.
+		 */
+		struct work_struct work_freeing;
+	};
+
 	/*
 	 * Per cgroup active and inactive list, similar to the
 	 * per zone LRU lists.
@@ -4780,6 +4800,27 @@ out_free:
 }
 
 /*
+ * Helpers for freeing a vzalloc()ed mem_cgroup by RCU,
+ * but in process context.  The work_freeing structure is overlaid
+ * on the rcu_freeing structure, which itself is overlaid on memsw.
+ */
+static void vfree_work(struct work_struct *work)
+{
+	struct mem_cgroup *memcg;
+
+	memcg = container_of(work, struct mem_cgroup, work_freeing);
+	vfree(memcg);
+}
+static void vfree_rcu(struct rcu_head *rcu_head)
+{
+	struct mem_cgroup *memcg;
+
+	memcg = container_of(rcu_head, struct mem_cgroup, rcu_freeing);
+	INIT_WORK(&memcg->work_freeing, vfree_work);
+	schedule_work(&memcg->work_freeing);
+}
+
+/*
  * At destroying mem_cgroup, references from swap_cgroup can remain.
  * (scanning all at force_empty is too costly...)
  *
@@ -4802,9 +4843,9 @@ static void __mem_cgroup_free(struct mem
 
 	free_percpu(memcg->stat);
 	if (sizeof(struct mem_cgroup) < PAGE_SIZE)
-		kfree(memcg);
+		kfree_rcu(memcg, rcu_freeing);
 	else
-		vfree(memcg);
+		call_rcu(&memcg->rcu_freeing, vfree_rcu);
 }
 
 static void mem_cgroup_get(struct mem_cgroup *memcg)
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode.patch
mm-add-rss-counters-consistency-check.patch
mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch
make-swapin-readahead-skip-over-holes.patch
make-swapin-readahead-skip-over-holes-fix.patch
compact_pgdat-workaround-lockdep-warning-in-kswapd.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix-fix.patch
mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch
rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link.patch
mm-vmscan-handle-isolated-pages-with-lru-lock-released.patch
mm-hugetlb-bail-out-unmapping-after-serving-reference-page.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch
tmpfs-security-xattr-setting-on-inode-creation.patch
mm-fix-move-migrate_pages-race-on-task-struct.patch
hugetlbfs-drop-taking-inode-i_mutex-lock-from-hugetlbfs_read.patch
ksm-cleanup-introduce-find_mergeable_vma.patch
hugetlb-cleanup-hugetlbh.patch
hugepages-fix-use-after-free-bug-in-quota-handling.patch
hugetlbfs-fix-alignment-of-huge-page-requests.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
idr-make-idr_get_next-good-for-rcu_read_lock.patch
cgroup-revert-ss_id_lock-to-spinlock.patch
memcg-let-css_get_next-rely-upon-rcu_read_lock.patch
memcg-remove-pcg_cache-page_cgroup-flag.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix-2.patch
memcg-remove-pcg_file_mapped-fix-cosmetic-fix.patch
memcg-remove-pcg_file_mapped-fix-42.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch
prio_tree-debugging-patch.patch

