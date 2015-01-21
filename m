From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch removed
 from -mm tree
Date: Tue, 20 Jan 2015 16:21:38 -0800
Message-ID: <54bef112.gaUG11bdyDiyeREg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbbAUAVj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jan 2015 19:21:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, gthelen@google.com, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_counter: pull "-1" handling out of page_counter_memparse()
has been removed from the -mm tree.  Its filename was
     mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_counter: pull "-1" handling out of page_counter_memparse()

It was convenient to have the generic function handle it, as all callsites
agreed.  Subsequent patches will add new user interfaces that do not want
to support the "-1" special string.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c       |   10 +++++++---
 mm/memcontrol.c           |   20 ++++++++++++++------
 mm/page_counter.c         |    6 ------
 net/ipv4/tcp_memcontrol.c |   10 +++++++---
 4 files changed, 28 insertions(+), 18 deletions(-)

diff -puN mm/hugetlb_cgroup.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse
+++ a/mm/hugetlb_cgroup.c
@@ -279,9 +279,13 @@ static ssize_t hugetlb_cgroup_write(stru
 		return -EINVAL;
 
 	buf = strstrip(buf);
-	ret = page_counter_memparse(buf, &nr_pages);
-	if (ret)
-		return ret;
+	if (!strcmp(buf, "-1")) {
+		nr_pages = PAGE_COUNTER_MAX;
+	} else {
+		ret = page_counter_memparse(buf, &nr_pages);
+		if (ret)
+			return ret;
+	}
 
 	idx = MEMFILE_IDX(of_cft(of)->private);
 
diff -puN mm/memcontrol.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse mm/memcontrol.c
--- a/mm/memcontrol.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse
+++ a/mm/memcontrol.c
@@ -3442,9 +3442,13 @@ static ssize_t mem_cgroup_write(struct k
 	int ret;
 
 	buf = strstrip(buf);
-	ret = page_counter_memparse(buf, &nr_pages);
-	if (ret)
-		return ret;
+	if (!strcmp(buf, "-1")) {
+		nr_pages = PAGE_COUNTER_MAX;
+	} else {
+		ret = page_counter_memparse(buf, &nr_pages);
+		if (ret)
+			return ret;
+	}
 
 	switch (MEMFILE_ATTR(of_cft(of)->private)) {
 	case RES_LIMIT:
@@ -3814,9 +3818,13 @@ static int __mem_cgroup_usage_register_e
 	unsigned long usage;
 	int i, size, ret;
 
-	ret = page_counter_memparse(args, &threshold);
-	if (ret)
-		return ret;
+	if (!strcmp(args, "-1")) {
+		threshold = PAGE_COUNTER_MAX;
+	} else {
+		ret = page_counter_memparse(args, &threshold);
+		if (ret)
+			return ret;
+	}
 
 	mutex_lock(&memcg->thresholds_lock);
 
diff -puN mm/page_counter.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse mm/page_counter.c
--- a/mm/page_counter.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse
+++ a/mm/page_counter.c
@@ -173,15 +173,9 @@ int page_counter_limit(struct page_count
  */
 int page_counter_memparse(const char *buf, unsigned long *nr_pages)
 {
-	char unlimited[] = "-1";
 	char *end;
 	u64 bytes;
 
-	if (!strncmp(buf, unlimited, sizeof(unlimited))) {
-		*nr_pages = PAGE_COUNTER_MAX;
-		return 0;
-	}
-
 	bytes = memparse(buf, &end);
 	if (*end != '\0')
 		return -EINVAL;
diff -puN net/ipv4/tcp_memcontrol.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse net/ipv4/tcp_memcontrol.c
--- a/net/ipv4/tcp_memcontrol.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse
+++ a/net/ipv4/tcp_memcontrol.c
@@ -120,9 +120,13 @@ static ssize_t tcp_cgroup_write(struct k
 	switch (of_cft(of)->private) {
 	case RES_LIMIT:
 		/* see memcontrol.c */
-		ret = page_counter_memparse(buf, &nr_pages);
-		if (ret)
-			break;
+		if (!strcmp(buf, "-1")) {
+			nr_pages = PAGE_COUNTER_MAX;
+		} else {
+			ret = page_counter_memparse(buf, &nr_pages);
+			if (ret)
+				break;
+		}
 		mutex_lock(&tcp_limit_mutex);
 		ret = tcp_update_limit(memcg, nr_pages);
 		mutex_unlock(&tcp_limit_mutex);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
memcg-remove-extra-newlines-from-memcg-oom-kill-log.patch
mm-vmscan-fix-highidx-argument-type.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
mm-page_alloc-place-zone_id-check-before-vm_bug_on_page-check.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-memcontrol-track-move_lock-state-internally-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch
mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
memcg-add-build_bug_on-for-string-tables.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.patch
mm-memcontrol-default-hierarchy-interface-for-memory-fix.patch
mm-memcontrol-default-hierarchy-interface-for-memory-fix-high-reclaim.patch
mm-memcontrol-default-hierarchy-interface-for-memory-fix-none.patch
mm-memcontrol-fold-move_anon-and-move_file.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
oom-add-helpers-for-setting-and-clearing-tif_memdie.patch
oom-thaw-the-oom-victim-if-it-is-frozen.patch
pm-convert-printk-to-pr_-equivalent.patch
sysrq-convert-printk-to-pr_-equivalent.patch
oom-pm-make-oom-detection-in-the-freezer-path-raceless.patch
mm-memcontrol-remove-unnecessary-soft-limit-tree-node-test.patch
mm-memcontrol-consolidate-memory-controller-initialization.patch
mm-memcontrol-consolidate-swap-controller-code.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
documentation-proc-add-proc-pid-numa_maps-interface-explanation-snippet.patch
fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps.patch
fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps-fix.patch

