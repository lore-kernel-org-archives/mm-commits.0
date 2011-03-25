From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-direct-page_cgroup-to-page-pointer.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:49 -0700
Message-ID: <201103250724.p2P7OhcI025951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754674Ab1CYHZA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     memcg: remove direct page_cgroup-to-page pointer
has been removed from the -mm tree.  Its filename was
     memcg-remove-direct-page_cgroup-to-page-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove direct page_cgroup-to-page pointer
From: Johannes Weiner <hannes@cmpxchg.org>

In struct page_cgroup, we have a full word for flags but only a few are
reserved.  Use the remaining upper bits to encode, depending on
configuration, the node or the section, to enable page_cgroup-to-page
lookups without a direct pointer.

This saves a full word for every page in a system with memory cgroups
enabled.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |   75 +++++++++++++++++++++------
 kernel/bounds.c             |    2 
 mm/memcontrol.c             |    4 -
 mm/page_cgroup.c            |   93 ++++++++++++++++++++--------------
 4 files changed, 118 insertions(+), 56 deletions(-)

diff -puN include/linux/page_cgroup.h~memcg-remove-direct-page_cgroup-to-page-pointer include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~memcg-remove-direct-page_cgroup-to-page-pointer
+++ a/include/linux/page_cgroup.h
@@ -1,8 +1,26 @@
 #ifndef __LINUX_PAGE_CGROUP_H
 #define __LINUX_PAGE_CGROUP_H
 
+enum {
+	/* flags for mem_cgroup */
+	PCG_LOCK,  /* Lock for pc->mem_cgroup and following bits. */
+	PCG_CACHE, /* charged as cache */
+	PCG_USED, /* this object is in use. */
+	PCG_MIGRATION, /* under page migration */
+	/* flags for mem_cgroup and file and I/O status */
+	PCG_MOVE_LOCK, /* For race between move_account v.s. following bits */
+	PCG_FILE_MAPPED, /* page is accounted as "mapped" */
+	/* No lock in page_cgroup */
+	PCG_ACCT_LRU, /* page has been accounted for (under lru_lock) */
+	__NR_PCG_FLAGS,
+};
+
+#ifndef __GENERATING_BOUNDS_H
+#include <generated/bounds.h>
+
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 #include <linux/bit_spinlock.h>
+
 /*
  * Page Cgroup can be considered as an extended mem_map.
  * A page_cgroup page is associated with every page descriptor. The
@@ -13,7 +31,6 @@
 struct page_cgroup {
 	unsigned long flags;
 	struct mem_cgroup *mem_cgroup;
-	struct page *page;
 	struct list_head lru;		/* per cgroup LRU list */
 };
 
@@ -32,19 +49,7 @@ static inline void __init page_cgroup_in
 #endif
 
 struct page_cgroup *lookup_page_cgroup(struct page *page);
-
-enum {
-	/* flags for mem_cgroup */
-	PCG_LOCK,  /* Lock for pc->mem_cgroup and following bits. */
-	PCG_CACHE, /* charged as cache */
-	PCG_USED, /* this object is in use. */
-	PCG_MIGRATION, /* under page migration */
-	/* flags for mem_cgroup and file and I/O status */
-	PCG_MOVE_LOCK, /* For race between move_account v.s. following bits */
-	PCG_FILE_MAPPED, /* page is accounted as "mapped" */
-	/* No lock in page_cgroup */
-	PCG_ACCT_LRU, /* page has been accounted for (under lru_lock) */
-};
+struct page *lookup_cgroup_page(struct page_cgroup *pc);
 
 #define TESTPCGFLAG(uname, lname)			\
 static inline int PageCgroup##uname(struct page_cgroup *pc)	\
@@ -117,6 +122,39 @@ static inline void move_unlock_page_cgro
 	local_irq_restore(*flags);
 }
 
+#ifdef CONFIG_SPARSEMEM
+#define PCG_ARRAYID_WIDTH	SECTIONS_SHIFT
+#else
+#define PCG_ARRAYID_WIDTH	NODES_SHIFT
+#endif
+
+#if (PCG_ARRAYID_WIDTH > BITS_PER_LONG - NR_PCG_FLAGS)
+#error Not enough space left in pc->flags to store page_cgroup array IDs
+#endif
+
+/* pc->flags: ARRAY-ID | FLAGS */
+
+#define PCG_ARRAYID_MASK	((1UL << PCG_ARRAYID_WIDTH) - 1)
+
+#define PCG_ARRAYID_OFFSET	(BITS_PER_LONG - PCG_ARRAYID_WIDTH)
+/*
+ * Zero the shift count for non-existant fields, to prevent compiler
+ * warnings and ensure references are optimized away.
+ */
+#define PCG_ARRAYID_SHIFT	(PCG_ARRAYID_OFFSET * (PCG_ARRAYID_WIDTH != 0))
+
+static inline void set_page_cgroup_array_id(struct page_cgroup *pc,
+					    unsigned long id)
+{
+	pc->flags &= ~(PCG_ARRAYID_MASK << PCG_ARRAYID_SHIFT);
+	pc->flags |= (id & PCG_ARRAYID_MASK) << PCG_ARRAYID_SHIFT;
+}
+
+static inline unsigned long page_cgroup_array_id(struct page_cgroup *pc)
+{
+	return (pc->flags >> PCG_ARRAYID_SHIFT) & PCG_ARRAYID_MASK;
+}
+
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct page_cgroup;
 
@@ -137,7 +175,7 @@ static inline void __init page_cgroup_in
 {
 }
 
-#endif
+#endif /* CONFIG_CGROUP_MEM_RES_CTLR */
 
 #include <linux/swap.h>
 
@@ -173,5 +211,8 @@ static inline void swap_cgroup_swapoff(i
 	return;
 }
 
-#endif
-#endif
+#endif /* CONFIG_CGROUP_MEM_RES_CTLR_SWAP */
+
+#endif /* !__GENERATING_BOUNDS_H */
+
+#endif /* __LINUX_PAGE_CGROUP_H */
diff -puN kernel/bounds.c~memcg-remove-direct-page_cgroup-to-page-pointer kernel/bounds.c
--- a/kernel/bounds.c~memcg-remove-direct-page_cgroup-to-page-pointer
+++ a/kernel/bounds.c
@@ -9,11 +9,13 @@
 #include <linux/page-flags.h>
 #include <linux/mmzone.h>
 #include <linux/kbuild.h>
+#include <linux/page_cgroup.h>
 
 void foo(void)
 {
 	/* The enum constants to put into include/generated/bounds.h */
 	DEFINE(NR_PAGEFLAGS, __NR_PAGEFLAGS);
 	DEFINE(MAX_NR_ZONES, __MAX_NR_ZONES);
+	DEFINE(NR_PCG_FLAGS, __NR_PCG_FLAGS);
 	/* End of constants */
 }
diff -puN mm/memcontrol.c~memcg-remove-direct-page_cgroup-to-page-pointer mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-direct-page_cgroup-to-page-pointer
+++ a/mm/memcontrol.c
@@ -1080,7 +1080,7 @@ unsigned long mem_cgroup_isolate_pages(u
 		if (unlikely(!PageCgroupUsed(pc)))
 			continue;
 
-		page = pc->page;
+		page = lookup_cgroup_page(pc);
 
 		if (unlikely(!PageLRU(page)))
 			continue;
@@ -3344,7 +3344,7 @@ static int mem_cgroup_force_empty_list(s
 		}
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 
-		page = pc->page;
+		page = lookup_cgroup_page(pc);
 
 		ret = mem_cgroup_move_parent(page, pc, mem, GFP_KERNEL);
 		if (ret == -ENOMEM)
diff -puN mm/page_cgroup.c~memcg-remove-direct-page_cgroup-to-page-pointer mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-remove-direct-page_cgroup-to-page-pointer
+++ a/mm/page_cgroup.c
@@ -11,12 +11,11 @@
 #include <linux/swapops.h>
 #include <linux/kmemleak.h>
 
-static void __meminit
-__init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
+static void __meminit init_page_cgroup(struct page_cgroup *pc, unsigned long id)
 {
 	pc->flags = 0;
+	set_page_cgroup_array_id(pc, id);
 	pc->mem_cgroup = NULL;
-	pc->page = pfn_to_page(pfn);
 	INIT_LIST_HEAD(&pc->lru);
 }
 static unsigned long total_usage;
@@ -43,6 +42,19 @@ struct page_cgroup *lookup_page_cgroup(s
 	return base + offset;
 }
 
+struct page *lookup_cgroup_page(struct page_cgroup *pc)
+{
+	unsigned long pfn;
+	struct page *page;
+	pg_data_t *pgdat;
+
+	pgdat = NODE_DATA(page_cgroup_array_id(pc));
+	pfn = pc - pgdat->node_page_cgroup + pgdat->node_start_pfn;
+	page = pfn_to_page(pfn);
+	VM_BUG_ON(pc != lookup_page_cgroup(page));
+	return page;
+}
+
 static int __init alloc_node_page_cgroup(int nid)
 {
 	struct page_cgroup *base, *pc;
@@ -63,7 +75,7 @@ static int __init alloc_node_page_cgroup
 		return -ENOMEM;
 	for (index = 0; index < nr_pages; index++) {
 		pc = base + index;
-		__init_page_cgroup(pc, start_pfn + index);
+		init_page_cgroup(pc, nid);
 	}
 	NODE_DATA(nid)->node_page_cgroup = base;
 	total_usage += table_size;
@@ -105,46 +117,53 @@ struct page_cgroup *lookup_page_cgroup(s
 	return section->page_cgroup + pfn;
 }
 
+struct page *lookup_cgroup_page(struct page_cgroup *pc)
+{
+	struct mem_section *section;
+	struct page *page;
+	unsigned long nr;
+
+	nr = page_cgroup_array_id(pc);
+	section = __nr_to_section(nr);
+	page = pfn_to_page(pc - section->page_cgroup);
+	VM_BUG_ON(pc != lookup_page_cgroup(page));
+	return page;
+}
+
 /* __alloc_bootmem...() is protected by !slab_available() */
 static int __init_refok init_section_page_cgroup(unsigned long pfn)
 {
-	struct mem_section *section = __pfn_to_section(pfn);
 	struct page_cgroup *base, *pc;
+	struct mem_section *section;
 	unsigned long table_size;
+	unsigned long nr;
 	int nid, index;
 
-	if (!section->page_cgroup) {
-		nid = page_to_nid(pfn_to_page(pfn));
-		table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
-		VM_BUG_ON(!slab_is_available());
-		if (node_state(nid, N_HIGH_MEMORY)) {
-			base = kmalloc_node(table_size,
-				GFP_KERNEL | __GFP_NOWARN, nid);
-			if (!base)
-				base = vmalloc_node(table_size, nid);
-		} else {
-			base = kmalloc(table_size, GFP_KERNEL | __GFP_NOWARN);
-			if (!base)
-				base = vmalloc(table_size);
-		}
-		/*
-		 * The value stored in section->page_cgroup is (base - pfn)
-		 * and it does not point to the memory block allocated above,
-		 * causing kmemleak false positives.
-		 */
-		kmemleak_not_leak(base);
+	nr = pfn_to_section_nr(pfn);
+	section = __nr_to_section(nr);
+
+	if (section->page_cgroup)
+		return 0;
+
+	nid = page_to_nid(pfn_to_page(pfn));
+	table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
+	VM_BUG_ON(!slab_is_available());
+	if (node_state(nid, N_HIGH_MEMORY)) {
+		base = kmalloc_node(table_size,
+				    GFP_KERNEL | __GFP_NOWARN, nid);
+		if (!base)
+			base = vmalloc_node(table_size, nid);
 	} else {
-		/*
- 		 * We don't have to allocate page_cgroup again, but
-		 * address of memmap may be changed. So, we have to initialize
-		 * again.
-		 */
-		base = section->page_cgroup + pfn;
-		table_size = 0;
-		/* check address of memmap is changed or not. */
-		if (base->page == pfn_to_page(pfn))
-			return 0;
-	}
+		base = kmalloc(table_size, GFP_KERNEL | __GFP_NOWARN);
+		if (!base)
+			base = vmalloc(table_size);
+	}
+	/*
+	 * The value stored in section->page_cgroup is (base - pfn)
+	 * and it does not point to the memory block allocated above,
+	 * causing kmemleak false positives.
+	 */
+	kmemleak_not_leak(base);
 
 	if (!base) {
 		printk(KERN_ERR "page cgroup allocation failure\n");
@@ -153,7 +172,7 @@ static int __init_refok init_section_pag
 
 	for (index = 0; index < PAGES_PER_SECTION; index++) {
 		pc = base + index;
-		__init_page_cgroup(pc, pfn + index);
+		init_page_cgroup(pc, nr);
 	}
 
 	section->page_cgroup = base - pfn;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-add-vm-counters-for-transparent-hugepages.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch

