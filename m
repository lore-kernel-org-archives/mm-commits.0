From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-consolidate-swap-controller-code.patch
 removed from -mm tree
Date: Thu, 12 Feb 2015 11:37:20 -0800
Message-ID: <54dd00f0.mIFWmKlgFUkhmBGW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbbBLThV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:37:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: consolidate swap controller code
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-consolidate-swap-controller-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -4373,34 +4364,6 @@ static struct cftype mem_cgroup_legacy_f
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
@@ -5391,37 +5354,6 @@ struct cgroup_subsys memory_cgrp_subsys
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
@@ -5472,74 +5404,6 @@ bool mem_cgroup_low(struct mem_cgroup *r
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
@@ -5897,8 +5761,130 @@ static int __init mem_cgroup_init(void)
 		soft_limit_tree.rb_tree_per_node[node] = rtpn;
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

origin.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
memcg-cleanup-static-keys-decrement.patch
documentation-proc-add-proc-pid-numa_maps-interface-explanation-snippet.patch
fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps.patch
fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps-fix.patch

