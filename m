From: akpm@linux-foundation.org
Subject: +
 mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch added to -mm tree
Date: Wed, 21 Jan 2015 14:33:15 -0800
Message-ID: <54c0292b.5jhrxE+akYz7ph3Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbbAUWdQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jan 2015 17:33:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, gthelen@google.com, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_counter: pull "-1" handling out of page_counter_memparse()
has been added to the -mm tree.  Its filename is
     mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_counter: pull "-1" handling out of page_counter_memparse()

The unified hierarchy interface for memory cgroups will no longer use "-1"
to mean maximum possible resource value.  In preparation for this, make
the string an argument and let the caller supply it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_counter.h |    3 ++-
 mm/hugetlb_cgroup.c          |    2 +-
 mm/memcontrol.c              |    4 ++--
 mm/page_counter.c            |    7 ++++---
 net/ipv4/tcp_memcontrol.c    |    2 +-
 5 files changed, 10 insertions(+), 8 deletions(-)

diff -puN include/linux/page_counter.h~mm-page_counter-pull-1-handling-out-of-page_counter_memparse include/linux/page_counter.h
--- a/include/linux/page_counter.h~mm-page_counter-pull-1-handling-out-of-page_counter_memparse
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
diff -puN mm/hugetlb_cgroup.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse
+++ a/mm/hugetlb_cgroup.c
@@ -279,7 +279,7 @@ static ssize_t hugetlb_cgroup_write(stru
 		return -EINVAL;
 
 	buf = strstrip(buf);
-	ret = page_counter_memparse(buf, &nr_pages);
+	ret = page_counter_memparse(buf, "-1", &nr_pages);
 	if (ret)
 		return ret;
 
diff -puN mm/memcontrol.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse mm/memcontrol.c
--- a/mm/memcontrol.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse
+++ a/mm/memcontrol.c
@@ -3442,7 +3442,7 @@ static ssize_t mem_cgroup_write(struct k
 	int ret;
 
 	buf = strstrip(buf);
-	ret = page_counter_memparse(buf, &nr_pages);
+	ret = page_counter_memparse(buf, "-1", &nr_pages);
 	if (ret)
 		return ret;
 
@@ -3814,7 +3814,7 @@ static int __mem_cgroup_usage_register_e
 	unsigned long usage;
 	int i, size, ret;
 
-	ret = page_counter_memparse(args, &threshold);
+	ret = page_counter_memparse(args, "-1", &threshold);
 	if (ret)
 		return ret;
 
diff -puN mm/page_counter.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse mm/page_counter.c
--- a/mm/page_counter.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse
+++ a/mm/page_counter.c
@@ -166,18 +166,19 @@ int page_counter_limit(struct page_count
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
-	char unlimited[] = "-1";
 	char *end;
 	u64 bytes;
 
-	if (!strncmp(buf, unlimited, sizeof(unlimited))) {
+	if (!strcmp(buf, max)) {
 		*nr_pages = PAGE_COUNTER_MAX;
 		return 0;
 	}
diff -puN net/ipv4/tcp_memcontrol.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse net/ipv4/tcp_memcontrol.c
--- a/net/ipv4/tcp_memcontrol.c~mm-page_counter-pull-1-handling-out-of-page_counter_memparse
+++ a/net/ipv4/tcp_memcontrol.c
@@ -120,7 +120,7 @@ static ssize_t tcp_cgroup_write(struct k
 	switch (of_cft(of)->private) {
 	case RES_LIMIT:
 		/* see memcontrol.c */
-		ret = page_counter_memparse(buf, &nr_pages);
+		ret = page_counter_memparse(buf, "-1", &nr_pages);
 		if (ret)
 			break;
 		mutex_lock(&tcp_limit_mutex);
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
mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
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

