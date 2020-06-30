From: akpm@linux-foundation.org
Subject: + mm-memcontrol-account-kernel-stack-per-node.patch added
 to -mm tree
Date: Tue, 30 Jun 2020 16:10:06 -0700
Message-ID: <20200630231006.uf47E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725791AbgF3XKI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 19:10:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@kernel.org, hannes@cmpxchg.org, guro@fb.com, shakeelb@google.com


The patch titled
     Subject: mm: memcontrol: account kernel stack per node
has been added to the -mm tree.  Its filename is
     mm-memcontrol-account-kernel-stack-per-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-account-kernel-stack-per-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-account-kernel-stack-per-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: mm: memcontrol: account kernel stack per node

Currently the kernel stack is being accounted per-zone.  There is no need
to do that.  In addition due to being per-zone, memcg has to keep a
separate MEMCG_KERNEL_STACK_KB.  Make the stat per-node and deprecate
MEMCG_KERNEL_STACK_KB as memcg_stat_item is an extension of
node_stat_item.  In addition localize the kernel stack stats updates to
account_kernel_stack().

Link: http://lkml.kernel.org/r/20200630161539.1759185-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c        |    4 +-
 fs/proc/meminfo.c          |    4 +-
 include/linux/memcontrol.h |   21 +++++++++++++-
 include/linux/mmzone.h     |    8 ++---
 kernel/fork.c              |   51 +++++++++--------------------------
 kernel/scs.c               |    2 -
 mm/memcontrol.c            |    2 -
 mm/page_alloc.c            |   16 +++++-----
 mm/vmstat.c                |    8 ++---
 9 files changed, 55 insertions(+), 61 deletions(-)

--- a/drivers/base/node.c~mm-memcontrol-account-kernel-stack-per-node
+++ a/drivers/base/node.c
@@ -440,9 +440,9 @@ static ssize_t node_read_meminfo(struct
 		       nid, K(node_page_state(pgdat, NR_FILE_MAPPED)),
 		       nid, K(node_page_state(pgdat, NR_ANON_MAPPED)),
 		       nid, K(i.sharedram),
-		       nid, sum_zone_node_page_state(nid, NR_KERNEL_STACK_KB),
+		       nid, node_page_state(pgdat, NR_KERNEL_STACK_KB),
 #ifdef CONFIG_SHADOW_CALL_STACK
-		       nid, sum_zone_node_page_state(nid, NR_KERNEL_SCS_KB),
+		       nid, node_page_state(pgdat, NR_KERNEL_SCS_KB),
 #endif
 		       nid, K(sum_zone_node_page_state(nid, NR_PAGETABLE)),
 		       nid, 0UL,
--- a/fs/proc/meminfo.c~mm-memcontrol-account-kernel-stack-per-node
+++ a/fs/proc/meminfo.c
@@ -101,10 +101,10 @@ static int meminfo_proc_show(struct seq_
 	show_val_kb(m, "SReclaimable:   ", sreclaimable);
 	show_val_kb(m, "SUnreclaim:     ", sunreclaim);
 	seq_printf(m, "KernelStack:    %8lu kB\n",
-		   global_zone_page_state(NR_KERNEL_STACK_KB));
+		   global_node_page_state(NR_KERNEL_STACK_KB));
 #ifdef CONFIG_SHADOW_CALL_STACK
 	seq_printf(m, "ShadowCallStack:%8lu kB\n",
-		   global_zone_page_state(NR_KERNEL_SCS_KB));
+		   global_node_page_state(NR_KERNEL_SCS_KB));
 #endif
 	show_val_kb(m, "PageTables:     ",
 		    global_zone_page_state(NR_PAGETABLE));
--- a/include/linux/memcontrol.h~mm-memcontrol-account-kernel-stack-per-node
+++ a/include/linux/memcontrol.h
@@ -33,8 +33,6 @@ enum memcg_stat_item {
 	MEMCG_SWAP = NR_VM_NODE_STAT_ITEMS,
 	MEMCG_SOCK,
 	MEMCG_PERCPU_B,
-	/* XXX: why are these zone and not node counters? */
-	MEMCG_KERNEL_STACK_KB,
 	MEMCG_NR_STAT,
 };
 
@@ -737,8 +735,19 @@ void __mod_memcg_lruvec_state(struct lru
 void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			int val);
 void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val);
+
 void mod_memcg_obj_state(void *p, int idx, int val);
 
+static inline void mod_lruvec_slab_state(void *p, enum node_stat_item idx,
+					 int val)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__mod_lruvec_slab_state(p, idx, val);
+	local_irq_restore(flags);
+}
+
 static inline void mod_memcg_lruvec_state(struct lruvec *lruvec,
 					  enum node_stat_item idx, int val)
 {
@@ -1159,6 +1168,14 @@ static inline void __mod_lruvec_slab_sta
 	__mod_node_page_state(page_pgdat(page), idx, val);
 }
 
+static inline void mod_lruvec_slab_state(void *p, enum node_stat_item idx,
+					 int val)
+{
+	struct page *page = virt_to_head_page(p);
+
+	mod_node_page_state(page_pgdat(page), idx, val);
+}
+
 static inline void mod_memcg_obj_state(void *p, int idx, int val)
 {
 }
--- a/include/linux/mmzone.h~mm-memcontrol-account-kernel-stack-per-node
+++ a/include/linux/mmzone.h
@@ -155,10 +155,6 @@ enum zone_stat_item {
 	NR_ZONE_WRITE_PENDING,	/* Count of dirty, writeback and unstable pages */
 	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
 	NR_PAGETABLE,		/* used for pagetables */
-	NR_KERNEL_STACK_KB,	/* measured in KiB */
-#if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
-	NR_KERNEL_SCS_KB,	/* measured in KiB */
-#endif
 	/* Second 128 byte cacheline */
 	NR_BOUNCE,
 #if IS_ENABLED(CONFIG_ZSMALLOC)
@@ -203,6 +199,10 @@ enum node_stat_item {
 	NR_KERNEL_MISC_RECLAIMABLE,	/* reclaimable non-slab kernel pages */
 	NR_FOLL_PIN_ACQUIRED,	/* via: pin_user_page(), gup flag: FOLL_PIN */
 	NR_FOLL_PIN_RELEASED,	/* pages returned via unpin_user_page() */
+	NR_KERNEL_STACK_KB,	/* measured in KiB */
+#if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
+	NR_KERNEL_SCS_KB,	/* measured in KiB */
+#endif
 	NR_VM_NODE_STAT_ITEMS
 };
 
--- a/kernel/fork.c~mm-memcontrol-account-kernel-stack-per-node
+++ a/kernel/fork.c
@@ -276,13 +276,8 @@ static inline void free_thread_stack(str
 	if (vm) {
 		int i;
 
-		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
-			mod_memcg_page_state(vm->pages[i],
-					     MEMCG_KERNEL_STACK_KB,
-					     -(int)(PAGE_SIZE / 1024));
-
+		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++)
 			memcg_kmem_uncharge_page(vm->pages[i], 0);
-		}
 
 		for (i = 0; i < NR_CACHED_STACKS; i++) {
 			if (this_cpu_cmpxchg(cached_stacks[i],
@@ -376,31 +371,14 @@ static void account_kernel_stack(struct
 	void *stack = task_stack_page(tsk);
 	struct vm_struct *vm = task_stack_vm_area(tsk);
 
-	BUILD_BUG_ON(IS_ENABLED(CONFIG_VMAP_STACK) && PAGE_SIZE % 1024 != 0);
-
-	if (vm) {
-		int i;
 
-		BUG_ON(vm->nr_pages != THREAD_SIZE / PAGE_SIZE);
-
-		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
-			mod_zone_page_state(page_zone(vm->pages[i]),
-					    NR_KERNEL_STACK_KB,
-					    PAGE_SIZE / 1024 * account);
-		}
-	} else {
-		/*
-		 * All stack pages are in the same zone and belong to the
-		 * same memcg.
-		 */
-		struct page *first_page = virt_to_page(stack);
-
-		mod_zone_page_state(page_zone(first_page), NR_KERNEL_STACK_KB,
-				    THREAD_SIZE / 1024 * account);
-
-		mod_memcg_obj_state(stack, MEMCG_KERNEL_STACK_KB,
-				    account * (THREAD_SIZE / 1024));
-	}
+	/* All stack pages are in the same node. */
+	if (vm)
+		mod_lruvec_page_state(vm->pages[0], NR_KERNEL_STACK_KB,
+				      account * (THREAD_SIZE / 1024));
+	else
+		mod_lruvec_slab_state(stack, NR_KERNEL_STACK_KB,
+				      account * (THREAD_SIZE / 1024));
 }
 
 static int memcg_charge_kernel_stack(struct task_struct *tsk)
@@ -409,24 +387,23 @@ static int memcg_charge_kernel_stack(str
 	struct vm_struct *vm = task_stack_vm_area(tsk);
 	int ret;
 
+	BUILD_BUG_ON(IS_ENABLED(CONFIG_VMAP_STACK) && PAGE_SIZE % 1024 != 0);
+
 	if (vm) {
 		int i;
 
+		BUG_ON(vm->nr_pages != THREAD_SIZE / PAGE_SIZE);
+
 		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
 			/*
 			 * If memcg_kmem_charge_page() fails, page->mem_cgroup
-			 * pointer is NULL, and both memcg_kmem_uncharge_page()
-			 * and mod_memcg_page_state() in free_thread_stack()
-			 * will ignore this page. So it's safe.
+			 * pointer is NULL, and memcg_kmem_uncharge_page() in
+			 * free_thread_stack() will ignore this page.
 			 */
 			ret = memcg_kmem_charge_page(vm->pages[i], GFP_KERNEL,
 						     0);
 			if (ret)
 				return ret;
-
-			mod_memcg_page_state(vm->pages[i],
-					     MEMCG_KERNEL_STACK_KB,
-					     PAGE_SIZE / 1024);
 		}
 	}
 #endif
--- a/kernel/scs.c~mm-memcontrol-account-kernel-stack-per-node
+++ a/kernel/scs.c
@@ -17,7 +17,7 @@ static void __scs_account(void *s, int a
 {
 	struct page *scs_page = virt_to_page(s);
 
-	mod_zone_page_state(page_zone(scs_page), NR_KERNEL_SCS_KB,
+	mod_node_page_state(page_pgdat(scs_page), NR_KERNEL_SCS_KB,
 			    account * (SCS_SIZE / SZ_1K));
 }
 
--- a/mm/memcontrol.c~mm-memcontrol-account-kernel-stack-per-node
+++ a/mm/memcontrol.c
@@ -1485,7 +1485,7 @@ static char *memory_stat_format(struct m
 		       (u64)memcg_page_state(memcg, NR_FILE_PAGES) *
 		       PAGE_SIZE);
 	seq_buf_printf(&s, "kernel_stack %llu\n",
-		       (u64)memcg_page_state(memcg, MEMCG_KERNEL_STACK_KB) *
+		       (u64)memcg_page_state(memcg, NR_KERNEL_STACK_KB) *
 		       1024);
 	seq_buf_printf(&s, "slab %llu\n",
 		       (u64)(memcg_page_state(memcg, NR_SLAB_RECLAIMABLE_B) +
--- a/mm/page_alloc.c~mm-memcontrol-account-kernel-stack-per-node
+++ a/mm/page_alloc.c
@@ -5396,6 +5396,10 @@ void show_free_areas(unsigned int filter
 			" anon_thp: %lukB"
 #endif
 			" writeback_tmp:%lukB"
+			" kernel_stack:%lukB"
+#ifdef CONFIG_SHADOW_CALL_STACK
+			" shadow_call_stack:%lukB"
+#endif
 			" all_unreclaimable? %s"
 			"\n",
 			pgdat->node_id,
@@ -5417,6 +5421,10 @@ void show_free_areas(unsigned int filter
 			K(node_page_state(pgdat, NR_ANON_THPS) * HPAGE_PMD_NR),
 #endif
 			K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
+			node_page_state(pgdat, NR_KERNEL_STACK_KB),
+#ifdef CONFIG_SHADOW_CALL_STACK
+			node_page_state(pgdat, NR_KERNEL_SCS_KB),
+#endif
 			pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES ?
 				"yes" : "no");
 	}
@@ -5448,10 +5456,6 @@ void show_free_areas(unsigned int filter
 			" present:%lukB"
 			" managed:%lukB"
 			" mlocked:%lukB"
-			" kernel_stack:%lukB"
-#ifdef CONFIG_SHADOW_CALL_STACK
-			" shadow_call_stack:%lukB"
-#endif
 			" pagetables:%lukB"
 			" bounce:%lukB"
 			" free_pcp:%lukB"
@@ -5473,10 +5477,6 @@ void show_free_areas(unsigned int filter
 			K(zone->present_pages),
 			K(zone_managed_pages(zone)),
 			K(zone_page_state(zone, NR_MLOCK)),
-			zone_page_state(zone, NR_KERNEL_STACK_KB),
-#ifdef CONFIG_SHADOW_CALL_STACK
-			zone_page_state(zone, NR_KERNEL_SCS_KB),
-#endif
 			K(zone_page_state(zone, NR_PAGETABLE)),
 			K(zone_page_state(zone, NR_BOUNCE)),
 			K(free_pcp),
--- a/mm/vmstat.c~mm-memcontrol-account-kernel-stack-per-node
+++ a/mm/vmstat.c
@@ -1140,10 +1140,6 @@ const char * const vmstat_text[] = {
 	"nr_zone_write_pending",
 	"nr_mlock",
 	"nr_page_table_pages",
-	"nr_kernel_stack",
-#if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
-	"nr_shadow_call_stack",
-#endif
 	"nr_bounce",
 #if IS_ENABLED(CONFIG_ZSMALLOC)
 	"nr_zspages",
@@ -1194,6 +1190,10 @@ const char * const vmstat_text[] = {
 	"nr_kernel_misc_reclaimable",
 	"nr_foll_pin_acquired",
 	"nr_foll_pin_released",
+	"nr_kernel_stack",
+#if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
+	"nr_shadow_call_stack",
+#endif
 
 	/* enum writeback_stat_item counters */
 	"nr_dirty_threshold",
_

Patches currently in -mm which might be from shakeelb@google.com are

mm-memcontrol-account-kernel-stack-per-node.patch
