From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-memcontrol-default-hierarchy-interface-for-memory-fix-none.patch removed from -mm tree
Date: Tue, 20 Jan 2015 16:21:50 -0800
Message-ID: <54bef11e.xLtYt4w5Nlp5UZFi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbbAUAVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jan 2015 19:21:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, gthelen@google.com, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: default hierarchy interface for memory fix - "none"
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-default-hierarchy-interface-for-memory-fix-none.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: default hierarchy interface for memory fix - "none"

The "none" name for the low-boundary 0 and the high-boundary maximum
value can be confusing.

Just leave the low boundary at 0, and give the highest-possible
boundary value the name "max" that means the same for controls.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/unified-hierarchy.txt |    5 -
 include/linux/page_counter.h                |    3 
 mm/memcontrol.c                             |   58 +++++-------------
 mm/page_counter.c                           |    9 ++
 4 files changed, 31 insertions(+), 44 deletions(-)

diff -puN Documentation/cgroups/unified-hierarchy.txt~mm-memcontrol-default-hierarchy-interface-for-memory-fix-none Documentation/cgroups/unified-hierarchy.txt
--- a/Documentation/cgroups/unified-hierarchy.txt~mm-memcontrol-default-hierarchy-interface-for-memory-fix-none
+++ a/Documentation/cgroups/unified-hierarchy.txt
@@ -404,9 +404,8 @@ supported and the interface files "relea
   be understood as an underflow into the highest possible value, -2 or
   -10M etc. do not work, so it's not consistent.
 
-  memory.low and memory.high will indicate "none" if the boundary is
-  not configured, and a configured boundary can be unset by writing
-  "none" into these files as well.
+  memory.low, memory.high, and memory.max will use the string "max" to
+  indicate and configure the highest possible value.
 
 5. Planned Changes
 
diff -puN include/linux/page_counter.h~mm-memcontrol-default-hierarchy-interface-for-memory-fix-none include/linux/page_counter.h
--- a/include/linux/page_counter.h~mm-memcontrol-default-hierarchy-interface-for-memory-fix-none
+++ a/include/linux/page_counter.h
@@ -41,7 +41,8 @@ int page_counter_try_charge(struct page_
 			    struct page_counter **fail);
 void page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages);
 int page_counter_limit(struct page_counter *counter, unsigned long limit);
-int page_counter_memparse(const char *buf, unsigned long *nr_pages);
+int page_counter_memparse(const char *buf, const char *max,
+			  unsigned long *nr_pages);
 
 static inline void page_counter_reset_watermark(struct page_counter *counter)
 {
diff -puN mm/memcontrol.c~mm-memcontrol-default-hierarchy-interface-for-memory-fix-none mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-default-hierarchy-interface-for-memory-fix-none
+++ a/mm/memcontrol.c
@@ -3452,13 +3452,9 @@ static ssize_t mem_cgroup_write(struct k
 	int ret;
 
 	buf = strstrip(buf);
-	if (!strcmp(buf, "-1")) {
-		nr_pages = PAGE_COUNTER_MAX;
-	} else {
-		ret = page_counter_memparse(buf, &nr_pages);
-		if (ret)
-			return ret;
-	}
+	ret = page_counter_memparse(buf, "-1", &nr_pages);
+	if (ret)
+		return ret;
 
 	switch (MEMFILE_ATTR(of_cft(of)->private)) {
 	case RES_LIMIT:
@@ -3828,13 +3824,9 @@ static int __mem_cgroup_usage_register_e
 	unsigned long usage;
 	int i, size, ret;
 
-	if (!strcmp(args, "-1")) {
-		threshold = PAGE_COUNTER_MAX;
-	} else {
-		ret = page_counter_memparse(args, &threshold);
-		if (ret)
-			return ret;
-	}
+	ret = page_counter_memparse(args, "-1", &threshold);
+	if (ret)
+		return ret;
 
 	mutex_lock(&memcg->thresholds_lock);
 
@@ -5330,8 +5322,8 @@ static int memory_low_show(struct seq_fi
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
 	unsigned long low = ACCESS_ONCE(memcg->low);
 
-	if (low == 0)
-		seq_puts(m, "none\n");
+	if (low == PAGE_COUNTER_MAX)
+		seq_puts(m, "max\n");
 	else
 		seq_printf(m, "%llu\n", (u64)low * PAGE_SIZE);
 
@@ -5346,13 +5338,9 @@ static ssize_t memory_low_write(struct k
 	int err;
 
 	buf = strstrip(buf);
-	if (!strcmp(buf, "none")) {
-		low = 0;
-	} else {
-		err = page_counter_memparse(buf, &low);
-		if (err)
-			return err;
-	}
+	err = page_counter_memparse(buf, "max", &low);
+	if (err)
+		return err;
 
 	memcg->low = low;
 
@@ -5365,7 +5353,7 @@ static int memory_high_show(struct seq_f
 	unsigned long high = ACCESS_ONCE(memcg->high);
 
 	if (high == PAGE_COUNTER_MAX)
-		seq_puts(m, "none\n");
+		seq_puts(m, "max\n");
 	else
 		seq_printf(m, "%llu\n", (u64)high * PAGE_SIZE);
 
@@ -5380,13 +5368,9 @@ static ssize_t memory_high_write(struct
 	int err;
 
 	buf = strstrip(buf);
-	if (!strcmp(buf, "none")) {
-		high = PAGE_COUNTER_MAX;
-	} else {
-		err = page_counter_memparse(buf, &high);
-		if (err)
-			return err;
-	}
+	err = page_counter_memparse(buf, "max", &high);
+	if (err)
+		return err;
 
 	memcg->high = high;
 
@@ -5399,7 +5383,7 @@ static int memory_max_show(struct seq_fi
 	unsigned long max = ACCESS_ONCE(memcg->memory.limit);
 
 	if (max == PAGE_COUNTER_MAX)
-		seq_puts(m, "none\n");
+		seq_puts(m, "max\n");
 	else
 		seq_printf(m, "%llu\n", (u64)max * PAGE_SIZE);
 
@@ -5414,13 +5398,9 @@ static ssize_t memory_max_write(struct k
 	int err;
 
 	buf = strstrip(buf);
-	if (!strcmp(buf, "none")) {
-		max = PAGE_COUNTER_MAX;
-	} else {
-		err = page_counter_memparse(buf, &max);
-		if (err)
-			return err;
-	}
+	err = page_counter_memparse(buf, "max", &max);
+	if (err)
+		return err;
 
 	err = mem_cgroup_resize_limit(memcg, max);
 	if (err)
diff -puN mm/page_counter.c~mm-memcontrol-default-hierarchy-interface-for-memory-fix-none mm/page_counter.c
--- a/mm/page_counter.c~mm-memcontrol-default-hierarchy-interface-for-memory-fix-none
+++ a/mm/page_counter.c
@@ -166,16 +166,23 @@ int page_counter_limit(struct page_count
 /**
  * page_counter_memparse - memparse() for page counter limits
  * @buf: string to parse
+ * @max: string meaning maximum possible value
  * @nr_pages: returns the result in number of pages
  *
  * Returns -EINVAL, or 0 and @nr_pages on success.  @nr_pages will be
  * limited to %PAGE_COUNTER_MAX.
  */
-int page_counter_memparse(const char *buf, unsigned long *nr_pages)
+int page_counter_memparse(const char *buf, const char *max,
+			  unsigned long *nr_pages)
 {
 	char *end;
 	u64 bytes;
 
+	if (!strcmp(buf, max)) {
+		*nr_pages = PAGE_COUNTER_MAX;
+		return 0;
+	}
+
 	bytes = memparse(buf, &end);
 	if (*end != '\0')
 		return -EINVAL;
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

