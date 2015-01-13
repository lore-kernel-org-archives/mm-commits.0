From: akpm@linux-foundation.org
Subject: + mm-memcontrol-consolidate-swap-controller-code.patch added to
 -mm tree
Date: Mon, 12 Jan 2015 16:21:50 -0800
Message-ID: <54b4651e.hXWB+qgqTvOPd5f0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbbAMAVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 19:21:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: consolidate swap controller code
has been added to the -mm tree.  Its filename is
     mm-memcontrol-consolidate-swap-controller-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-consolidate-swap-controller-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-consolidate-swap-controller-code.patch

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
Subject: mm: memcontrol: consolidate swap controller code

The swap controller code is scattered all over the file.  Gather all
the code that isn't directly needed by the memory controller at the
end of the file in its own CONFIG_MEMCG_SWAP section.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  264 +++++++++++++++++++++-------------------------
 1 file changed, 125 insertions(+), 139 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-consolidate-swap-controller-code mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-consolidate-swap-controller-code
+++ a/mm/memcontrol.c
@@ -72,22 +72,13 @@ EXPORT_SYMBOL(memory_cgrp_subsys);
 #define MEM_CGROUP_RECLAIM_RETRIES	5
 static struct mem_cgroup *root_mem_cgroup __read_mostly;
 
+/* Whether the swap controller is active */
 #ifdef CONFIG_MEMCG_SWAP
-/* Turned on only when memory cgroup is enabled && really_do_swap_account = 1 */
 int do_swap_account __read_mostly;
-
-/* for remember boot option*/
-#ifdef CONFIG_MEMCG_SWAP_ENABLED
-static int really_do_swap_account __initdata = 1;
-#else
-static int really_do_swap_account __initdata;
-#endif
-
 #else
 #define do_swap_account		0
 #endif
 
-
 static const char * const mem_cgroup_stat_names[] = {
 	"cache",
 	"rss",
@@ -4428,34 +4419,6 @@ static struct cftype mem_cgroup_legacy_f
 	{ },	/* terminate */
 };
 
-#ifdef CONFIG_MEMCG_SWAP
-static struct cftype memsw_cgroup_files[] = {
-	{
-		.name = "memsw.usage_in_bytes",
-		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_USAGE),
-		.read_u64 = mem_cgroup_read_u64,
-	},
-	{
-		.name = "memsw.max_usage_in_bytes",
-		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_MAX_USAGE),
-		.write = mem_cgroup_reset,
-		.read_u64 = mem_cgroup_read_u64,
-	},
-	{
-		.name = "memsw.limit_in_bytes",
-		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_LIMIT),
-		.write = mem_cgroup_write,
-		.read_u64 = mem_cgroup_read_u64,
-	},
-	{
-		.name = "memsw.failcnt",
-		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_FAILCNT),
-		.write = mem_cgroup_reset,
-		.read_u64 = mem_cgroup_read_u64,
-	},
-	{ },	/* terminate */
-};
-#endif
 static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
 {
 	struct mem_cgroup_per_node *pn;
@@ -5459,37 +5422,6 @@ struct cgroup_subsys memory_cgrp_subsys
 	.early_init = 0,
 };
 
-#ifdef CONFIG_MEMCG_SWAP
-static int __init enable_swap_account(char *s)
-{
-	if (!strcmp(s, "1"))
-		really_do_swap_account = 1;
-	else if (!strcmp(s, "0"))
-		really_do_swap_account = 0;
-	return 1;
-}
-__setup("swapaccount=", enable_swap_account);
-
-static void __init memsw_file_init(void)
-{
-	WARN_ON(cgroup_add_legacy_cftypes(&memory_cgrp_subsys,
-					  memsw_cgroup_files));
-}
-
-static void __init enable_swap_cgroup(void)
-{
-	if (!mem_cgroup_disabled() && really_do_swap_account) {
-		do_swap_account = 1;
-		memsw_file_init();
-	}
-}
-
-#else
-static void __init enable_swap_cgroup(void)
-{
-}
-#endif
-
 /**
  * mem_cgroup_events - count memory events against a cgroup
  * @memcg: the memory cgroup
@@ -5540,74 +5472,6 @@ bool mem_cgroup_low(struct mem_cgroup *r
 	return true;
 }
 
-#ifdef CONFIG_MEMCG_SWAP
-/**
- * mem_cgroup_swapout - transfer a memsw charge to swap
- * @page: page whose memsw charge to transfer
- * @entry: swap entry to move the charge to
- *
- * Transfer the memsw charge of @page to @entry.
- */
-void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
-{
-	struct mem_cgroup *memcg;
-	unsigned short oldid;
-
-	VM_BUG_ON_PAGE(PageLRU(page), page);
-	VM_BUG_ON_PAGE(page_count(page), page);
-
-	if (!do_swap_account)
-		return;
-
-	memcg = page->mem_cgroup;
-
-	/* Readahead page, never charged */
-	if (!memcg)
-		return;
-
-	oldid = swap_cgroup_record(entry, mem_cgroup_id(memcg));
-	VM_BUG_ON_PAGE(oldid, page);
-	mem_cgroup_swap_statistics(memcg, true);
-
-	page->mem_cgroup = NULL;
-
-	if (!mem_cgroup_is_root(memcg))
-		page_counter_uncharge(&memcg->memory, 1);
-
-	/* XXX: caller holds IRQ-safe mapping->tree_lock */
-	VM_BUG_ON(!irqs_disabled());
-
-	mem_cgroup_charge_statistics(memcg, page, -1);
-	memcg_check_events(memcg, page);
-}
-
-/**
- * mem_cgroup_uncharge_swap - uncharge a swap entry
- * @entry: swap entry to uncharge
- *
- * Drop the memsw charge associated with @entry.
- */
-void mem_cgroup_uncharge_swap(swp_entry_t entry)
-{
-	struct mem_cgroup *memcg;
-	unsigned short id;
-
-	if (!do_swap_account)
-		return;
-
-	id = swap_cgroup_record(entry, 0);
-	rcu_read_lock();
-	memcg = mem_cgroup_lookup(id);
-	if (memcg) {
-		if (!mem_cgroup_is_root(memcg))
-			page_counter_uncharge(&memcg->memsw, 1);
-		mem_cgroup_swap_statistics(memcg, false);
-		css_put(&memcg->css);
-	}
-	rcu_read_unlock();
-}
-#endif
-
 /**
  * mem_cgroup_try_charge - try charging a page
  * @page: page to charge
@@ -5964,8 +5828,130 @@ static int __init mem_cgroup_init(void)
 		soft_limit_tree.rb_tree_per_node[nid] = rtpn;
 	}
 
-	enable_swap_cgroup();
-
 	return 0;
 }
 subsys_initcall(mem_cgroup_init);
+
+#ifdef CONFIG_MEMCG_SWAP
+/**
+ * mem_cgroup_swapout - transfer a memsw charge to swap
+ * @page: page whose memsw charge to transfer
+ * @entry: swap entry to move the charge to
+ *
+ * Transfer the memsw charge of @page to @entry.
+ */
+void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
+{
+	struct mem_cgroup *memcg;
+	unsigned short oldid;
+
+	VM_BUG_ON_PAGE(PageLRU(page), page);
+	VM_BUG_ON_PAGE(page_count(page), page);
+
+	if (!do_swap_account)
+		return;
+
+	memcg = page->mem_cgroup;
+
+	/* Readahead page, never charged */
+	if (!memcg)
+		return;
+
+	oldid = swap_cgroup_record(entry, mem_cgroup_id(memcg));
+	VM_BUG_ON_PAGE(oldid, page);
+	mem_cgroup_swap_statistics(memcg, true);
+
+	page->mem_cgroup = NULL;
+
+	if (!mem_cgroup_is_root(memcg))
+		page_counter_uncharge(&memcg->memory, 1);
+
+	/* XXX: caller holds IRQ-safe mapping->tree_lock */
+	VM_BUG_ON(!irqs_disabled());
+
+	mem_cgroup_charge_statistics(memcg, page, -1);
+	memcg_check_events(memcg, page);
+}
+
+/**
+ * mem_cgroup_uncharge_swap - uncharge a swap entry
+ * @entry: swap entry to uncharge
+ *
+ * Drop the memsw charge associated with @entry.
+ */
+void mem_cgroup_uncharge_swap(swp_entry_t entry)
+{
+	struct mem_cgroup *memcg;
+	unsigned short id;
+
+	if (!do_swap_account)
+		return;
+
+	id = swap_cgroup_record(entry, 0);
+	rcu_read_lock();
+	memcg = mem_cgroup_lookup(id);
+	if (memcg) {
+		if (!mem_cgroup_is_root(memcg))
+			page_counter_uncharge(&memcg->memsw, 1);
+		mem_cgroup_swap_statistics(memcg, false);
+		css_put(&memcg->css);
+	}
+	rcu_read_unlock();
+}
+
+/* for remember boot option*/
+#ifdef CONFIG_MEMCG_SWAP_ENABLED
+static int really_do_swap_account __initdata = 1;
+#else
+static int really_do_swap_account __initdata;
+#endif
+
+static int __init enable_swap_account(char *s)
+{
+	if (!strcmp(s, "1"))
+		really_do_swap_account = 1;
+	else if (!strcmp(s, "0"))
+		really_do_swap_account = 0;
+	return 1;
+}
+__setup("swapaccount=", enable_swap_account);
+
+static struct cftype memsw_cgroup_files[] = {
+	{
+		.name = "memsw.usage_in_bytes",
+		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_USAGE),
+		.read_u64 = mem_cgroup_read_u64,
+	},
+	{
+		.name = "memsw.max_usage_in_bytes",
+		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_MAX_USAGE),
+		.write = mem_cgroup_reset,
+		.read_u64 = mem_cgroup_read_u64,
+	},
+	{
+		.name = "memsw.limit_in_bytes",
+		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_LIMIT),
+		.write = mem_cgroup_write,
+		.read_u64 = mem_cgroup_read_u64,
+	},
+	{
+		.name = "memsw.failcnt",
+		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_FAILCNT),
+		.write = mem_cgroup_reset,
+		.read_u64 = mem_cgroup_read_u64,
+	},
+	{ },	/* terminate */
+};
+
+static int __init mem_cgroup_swap_init(void)
+{
+	if (!mem_cgroup_disabled() && really_do_swap_account) {
+		do_swap_account = 1;
+		WARN_ON(cgroup_add_legacy_cftypes(&memory_cgrp_subsys,
+						  memsw_cgroup_files));
+	}
+	return 0;
+}
+subsys_initcall(mem_cgroup_swap_init);
+
+#endif /* CONFIG_MEMCG_SWAP */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
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
vmscan-per-memory-cgroup-slab-shrinkers-fix.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
memcg-add-build_bug_on-for-string-tables.patch
mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.patch
oom-add-helpers-for-setting-and-clearing-tif_memdie.patch
oom-thaw-the-oom-victim-if-it-is-frozen.patch
pm-convert-printk-to-pr_-equivalent.patch
sysrq-convert-printk-to-pr_-equivalent.patch
oom-pm-make-oom-detection-in-the-freezer-path-raceless.patch
mm-memcontrol-remove-unnecessary-soft-limit-tree-node-test.patch
mm-memcontrol-consolidate-memory-controller-initialization.patch
mm-memcontrol-consolidate-swap-controller-code.patch
fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps.patch

