From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-remove-unused-node-section-info-from-pc-flags.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:33:03 -0800
Message-ID: <20120113203309.70EEA5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:49326 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759096Ab2AMUdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:33:13 -0500
Received: by eeke50 with SMTP id e50so23664eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:33:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, bsingharora@gmail.com, gthelen@google.com, hch@infradead.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, mhocko@suse.cz, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, riel@redhat.com, walken@google.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: remove unused node/section info from pc->flags
has been removed from the -mm tree.  Its filename was
     mm-memcg-remove-unused-node-section-info-from-pc-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: memcg: remove unused node/section info from pc->flags

To find the page corresponding to a certain page_cgroup, the pc->flags
encoded the node or section ID with the base array to compare the pc
pointer to.

Now that the per-memory cgroup LRU lists link page descriptors directly,
there is no longer any code that knows the struct page_cgroup of a PFN but
not the struct page.

[hughd@google.com: remove unused node/section info from pc->flags fix]
Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Ying Han <yinghan@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |   33 -------------------
 mm/page_cgroup.c            |   59 ++++------------------------------
 2 files changed, 7 insertions(+), 85 deletions(-)

diff -puN include/linux/page_cgroup.h~mm-memcg-remove-unused-node-section-info-from-pc-flags include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~mm-memcg-remove-unused-node-section-info-from-pc-flags
+++ a/include/linux/page_cgroup.h
@@ -121,39 +121,6 @@ static inline void move_unlock_page_cgro
 	local_irq_restore(*flags);
 }
 
-#ifdef CONFIG_SPARSEMEM
-#define PCG_ARRAYID_WIDTH	SECTIONS_SHIFT
-#else
-#define PCG_ARRAYID_WIDTH	NODES_SHIFT
-#endif
-
-#if (PCG_ARRAYID_WIDTH > BITS_PER_LONG - NR_PCG_FLAGS)
-#error Not enough space left in pc->flags to store page_cgroup array IDs
-#endif
-
-/* pc->flags: ARRAY-ID | FLAGS */
-
-#define PCG_ARRAYID_MASK	((1UL << PCG_ARRAYID_WIDTH) - 1)
-
-#define PCG_ARRAYID_OFFSET	(BITS_PER_LONG - PCG_ARRAYID_WIDTH)
-/*
- * Zero the shift count for non-existent fields, to prevent compiler
- * warnings and ensure references are optimized away.
- */
-#define PCG_ARRAYID_SHIFT	(PCG_ARRAYID_OFFSET * (PCG_ARRAYID_WIDTH != 0))
-
-static inline void set_page_cgroup_array_id(struct page_cgroup *pc,
-					    unsigned long id)
-{
-	pc->flags &= ~(PCG_ARRAYID_MASK << PCG_ARRAYID_SHIFT);
-	pc->flags |= (id & PCG_ARRAYID_MASK) << PCG_ARRAYID_SHIFT;
-}
-
-static inline unsigned long page_cgroup_array_id(struct page_cgroup *pc)
-{
-	return (pc->flags >> PCG_ARRAYID_SHIFT) & PCG_ARRAYID_MASK;
-}
-
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct page_cgroup;
 
diff -puN mm/page_cgroup.c~mm-memcg-remove-unused-node-section-info-from-pc-flags mm/page_cgroup.c
--- a/mm/page_cgroup.c~mm-memcg-remove-unused-node-section-info-from-pc-flags
+++ a/mm/page_cgroup.c
@@ -11,12 +11,6 @@
 #include <linux/swapops.h>
 #include <linux/kmemleak.h>
 
-static void __meminit init_page_cgroup(struct page_cgroup *pc, unsigned long id)
-{
-	pc->flags = 0;
-	set_page_cgroup_array_id(pc, id);
-	pc->mem_cgroup = NULL;
-}
 static unsigned long total_usage;
 
 #if !defined(CONFIG_SPARSEMEM)
@@ -41,28 +35,13 @@ struct page_cgroup *lookup_page_cgroup(s
 	return base + offset;
 }
 
-struct page *lookup_cgroup_page(struct page_cgroup *pc)
-{
-	unsigned long pfn;
-	struct page *page;
-	pg_data_t *pgdat;
-
-	pgdat = NODE_DATA(page_cgroup_array_id(pc));
-	pfn = pc - pgdat->node_page_cgroup + pgdat->node_start_pfn;
-	page = pfn_to_page(pfn);
-	VM_BUG_ON(pc != lookup_page_cgroup(page));
-	return page;
-}
-
 static int __init alloc_node_page_cgroup(int nid)
 {
-	struct page_cgroup *base, *pc;
+	struct page_cgroup *base;
 	unsigned long table_size;
-	unsigned long start_pfn, nr_pages, index;
+	unsigned long nr_pages;
 
-	start_pfn = NODE_DATA(nid)->node_start_pfn;
 	nr_pages = NODE_DATA(nid)->node_spanned_pages;
-
 	if (!nr_pages)
 		return 0;
 
@@ -72,10 +51,6 @@ static int __init alloc_node_page_cgroup
 			table_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
 	if (!base)
 		return -ENOMEM;
-	for (index = 0; index < nr_pages; index++) {
-		pc = base + index;
-		init_page_cgroup(pc, nid);
-	}
 	NODE_DATA(nid)->node_page_cgroup = base;
 	total_usage += table_size;
 	return 0;
@@ -116,23 +91,10 @@ struct page_cgroup *lookup_page_cgroup(s
 	return section->page_cgroup + pfn;
 }
 
-struct page *lookup_cgroup_page(struct page_cgroup *pc)
-{
-	struct mem_section *section;
-	struct page *page;
-	unsigned long nr;
-
-	nr = page_cgroup_array_id(pc);
-	section = __nr_to_section(nr);
-	page = pfn_to_page(pc - section->page_cgroup);
-	VM_BUG_ON(pc != lookup_page_cgroup(page));
-	return page;
-}
-
 static void *__meminit alloc_page_cgroup(size_t size, int nid)
 {
+	gfp_t flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN;
 	void *addr = NULL;
-	gfp_t flags = GFP_KERNEL | __GFP_NOWARN;
 
 	addr = alloc_pages_exact_nid(nid, size, flags);
 	if (addr) {
@@ -141,9 +103,9 @@ static void *__meminit alloc_page_cgroup
 	}
 
 	if (node_state(nid, N_HIGH_MEMORY))
-		addr = vmalloc_node(size, nid);
+		addr = vzalloc_node(size, nid);
 	else
-		addr = vmalloc(size);
+		addr = vzalloc(size);
 
 	return addr;
 }
@@ -166,14 +128,11 @@ static void free_page_cgroup(void *addr)
 
 static int __meminit init_section_page_cgroup(unsigned long pfn, int nid)
 {
-	struct page_cgroup *base, *pc;
 	struct mem_section *section;
+	struct page_cgroup *base;
 	unsigned long table_size;
-	unsigned long nr;
-	int index;
 
-	nr = pfn_to_section_nr(pfn);
-	section = __nr_to_section(nr);
+	section = __pfn_to_section(pfn);
 
 	if (section->page_cgroup)
 		return 0;
@@ -193,10 +152,6 @@ static int __meminit init_section_page_c
 		return -ENOMEM;
 	}
 
-	for (index = 0; index < PAGES_PER_SECTION; index++) {
-		pc = base + index;
-		init_page_cgroup(pc, nr);
-	}
 	/*
 	 * The passed "pfn" may not be aligned to SECTION.  For the calculation
 	 * we need to apply a mask.
_

Patches currently in -mm which might be from jweiner@redhat.com are

origin.patch
mm-add-extra-free-kbytes-tunable.patch

