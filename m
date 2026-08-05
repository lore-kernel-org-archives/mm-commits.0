Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0033BFACA
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896683; cv=none; b=T+RRgW5F5xeqtI8D+kjRHnMKQh/Y00GNvk/LjstcHiI4NmfR9fAtpbMRgHDhYo+rBZW/EHb01MBXIeSpt4qamVSzL3UoDIIkHaZwXOdvj/t7t3b7Ik7Kdu3RcuIlfTCNP0cYBBbWO55HbCn5WH+dT9GppZMyja0MwPMlzJVLrio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896683; c=relaxed/simple;
	bh=LbAAWWFcOg2+uCu/c+w5lfe0P+tiopHwxRIU/Mu4fKM=;
	h=Date:To:From:Subject:Message-Id; b=Z9uZZlgKukuhZ2yAxBoTkrbsPnwA3lFR3+UGtArMvHHLVgFxpWuDTrYNMFlBUglJcl0wKelNYR63zxnPrBwRuW7IKfX6DuqpFo09ftWWX0+c9Y7tOy5NeMvwmks4uUmXFT5K4KFlhnTugOWEwpkZiujXzB9PyKWEL7TNy+nBSNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rn/F/9vl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rn/F/9vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2EF1F000E9;
	Wed,  5 Aug 2026 02:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896680;
	bh=PwVPKHHdXyqSXPVFjtkoIwH7sIIaNXXlQLoIETleu8c=;
	h=Date:To:From:Subject;
	b=rn/F/9vlGpJYpufZde0iku3pQp6swcmTxSXHcH7D1IU7YC5Ceucdi4sINi1jGk1/C
	 iNrXykC7bZVxFsaqMhXb2R4wdcCFF0UU+aEtoEiTQqQBNzhtMnxC8NINFa4j/vGl8C
	 O5SLbkfrWWP/5t+hG7LA65WMLjJyHeyrA+I7HEZg=
Date: Tue, 04 Aug 2026 19:24:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,urezki@gmail.com,tj@kernel.org,surenb@google.com,sj@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,graf@amazon.com,glider@google.com,elver@google.com,dvyukov@google.com,dennis@kernel.org,david@kernel.org,brendan.jackman@linux.dev,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-split-out-mm_init-and-memblock-declarations-from-internalh.patch removed from -mm tree
Message-Id: <20260805022440.3F2EF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: split out mm_init and memblock declarations from internal.h
has been removed from the -mm tree.  Its filename was
     mm-split-out-mm_init-and-memblock-declarations-from-internalh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm: split out mm_init and memblock declarations from internal.h
Date: Thu, 09 Jul 2026 13:00:03 +0300

Patch series "mm: split a couple of headers from internal.h", v2.

mm/internal.h becomes more and more bloated.

Split declarations related to mm_init, memblock, vmalloc and sparse into
new headers.


This patch (of 3):

mm/internal.h becomes more and more bloated.

Move declarations for related to mm/mm_init.c and mm/memblock.c to a new
mm/mm_init.h header.

No functional changes.

[rppt@kernel.org: split stubfs from internal.h to mm_init.h]
  Link: https://lore.kernel.org/alJd1BLypyK9Mpaw@kernel.org
Link: https://lore.kernel.org/20260709-internal-h-v2-0-695631425968@kernel.org
Link: https://lore.kernel.org/20260709-internal-h-v2-1-695631425968@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Pratyush Yadav <pratyush@kernel.org>
Acked-by: SJ Park <sj@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                        |    1 
 kernel/liveupdate/kexec_handover.c |    1 
 mm/cma.c                           |    1 
 mm/hugetlb.c                       |    1 
 mm/internal.h                      |   91 --------------------
 mm/memblock.c                      |    1 
 mm/memory_hotplug.c                |    1 
 mm/mm_init.c                       |    1 
 mm/mm_init.h                       |  120 +++++++++++++++++++++++++++
 mm/page_alloc.c                    |    1 
 mm/sparse-vmemmap.c                |    1 
 mm/sparse.c                        |    1 
 tools/testing/memblock/internal.h  |   20 ----
 tools/testing/memblock/mm_init.h   |   24 +++++
 14 files changed, 154 insertions(+), 111 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~mm-split-out-mm_init-and-memblock-declarations-from-internalh
+++ a/kernel/liveupdate/kexec_handover.c
@@ -35,6 +35,7 @@
  * internal APIs.
  */
 #include "../../mm/internal.h"
+#include "../../mm/mm_init.h"
 #include "../kexec_internal.h"
 #include "kexec_handover_internal.h"
 
--- a/MAINTAINERS~mm-split-out-mm_init-and-memblock-declarations-from-internalh
+++ a/MAINTAINERS
@@ -16883,6 +16883,7 @@ F:	include/linux/memblock.h
 F:	mm/memblock.c
 F:	mm/memtest.c
 F:	mm/mm_init.c
+F:	mm/mm_init.h
 F:	mm/rodata_test.c
 F:	tools/testing/memblock/
 
--- a/mm/cma.c~mm-split-out-mm_init-and-memblock-declarations-from-internalh
+++ a/mm/cma.c
@@ -33,6 +33,7 @@
 
 #include "internal.h"
 #include "cma.h"
+#include "mm_init.h"
 
 struct cma cma_areas[MAX_CMA_AREAS];
 unsigned int cma_area_count;
--- a/mm/hugetlb.c~mm-split-out-mm_init-and-memblock-declarations-from-internalh
+++ a/mm/hugetlb.c
@@ -51,6 +51,7 @@
 #include "hugetlb_vmemmap.h"
 #include "hugetlb_cma.h"
 #include "hugetlb_internal.h"
+#include "mm_init.h"
 #include <linux/page-isolation.h>
 
 int hugetlb_max_hstate __read_mostly;
--- a/mm/internal.h~mm-split-out-mm_init-and-memblock-declarations-from-internalh
+++ a/mm/internal.h
@@ -716,9 +716,6 @@ void set_recommended_min_free_kbytes(voi
 
 extern char * const zone_names[MAX_NR_ZONES];
 
-/* perform sanity checks on struct pages being allocated or freed */
-DECLARE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
-
 extern int min_free_kbytes;
 extern int defrag_mode;
 
@@ -726,19 +723,9 @@ void setup_per_zone_wmarks(void);
 void calculate_min_free_kbytes(void);
 int __meminit init_per_zone_wmark_min(void);
 
-void set_zone_contiguous(struct zone *zone);
-bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
-			   unsigned long nr_pages);
-
-static inline void clear_zone_contiguous(struct zone *zone)
-{
-	zone->contiguous = false;
-}
-
 extern int __isolate_free_page(struct page *page, unsigned int order);
 extern void __putback_isolated_page(struct page *page, unsigned int order,
 				    int mt);
-extern void memblock_free_pages(unsigned long pfn, unsigned int order);
 
 /*
  * This will have no effect, other than possibly generating a warning, if the
@@ -820,14 +807,6 @@ static inline void init_compound_tail(st
 	prep_compound_tail(tail, head, order);
 }
 
-extern void *memmap_alloc(phys_addr_t size, phys_addr_t align,
-			  phys_addr_t min_addr,
-			  int nid, bool exact_nid);
-
-void memmap_init_range(unsigned long, int, unsigned long, unsigned long,
-		unsigned long, enum meminit_context, struct vmem_altmap *, int,
-		bool);
-
 /*
  * mm/sparse.c
  */
@@ -948,9 +927,6 @@ int
 isolate_migratepages_range(struct compact_control *cc,
 			   unsigned long low_pfn, unsigned long end_pfn);
 
-/* Free whole pageblock and set its migration type to MIGRATE_CMA. */
-void init_cma_reserved_pageblock(struct page *page);
-
 #endif /* CONFIG_COMPACTION || CONFIG_CMA */
 
 struct cma;
@@ -958,7 +934,6 @@ struct cma;
 #ifdef CONFIG_CMA
 bool cma_validate_zones(struct cma *cma);
 void *cma_reserve_early(struct cma *cma, unsigned long size);
-void init_cma_pageblock(struct page *page);
 #else
 static inline bool cma_validate_zones(struct cma *cma)
 {
@@ -968,9 +943,6 @@ static inline void *cma_reserve_early(st
 {
 	return NULL;
 }
-static inline void init_cma_pageblock(struct page *page)
-{
-}
 #endif
 
 /* mm/util.c */
@@ -1177,63 +1149,6 @@ static inline void vunmap_range_noflush(
 }
 #endif /* !CONFIG_MMU */
 
-/* Memory initialisation debug and verification */
-#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
-DECLARE_STATIC_KEY_TRUE(deferred_pages);
-
-static inline bool deferred_pages_enabled(void)
-{
-	return static_branch_unlikely(&deferred_pages);
-}
-
-bool __init deferred_grow_zone(struct zone *zone, unsigned int order);
-#else
-static inline bool deferred_pages_enabled(void)
-{
-	return false;
-}
-#endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
-
-void init_deferred_page(unsigned long pfn, int nid);
-
-enum mminit_level {
-	MMINIT_WARNING,
-	MMINIT_VERIFY,
-	MMINIT_TRACE
-};
-
-#ifdef CONFIG_DEBUG_MEMORY_INIT
-
-extern int mminit_loglevel;
-
-#define mminit_dprintk(level, prefix, fmt, arg...) \
-do { \
-	if (level < mminit_loglevel) { \
-		if (level <= MMINIT_WARNING) \
-			pr_warn("mminit::" prefix " " fmt, ##arg);	\
-		else \
-			printk(KERN_DEBUG "mminit::" prefix " " fmt, ##arg); \
-	} \
-} while (0)
-
-extern void mminit_verify_pageflags_layout(void);
-extern void mminit_verify_zonelist(void);
-#else
-
-static inline void mminit_dprintk(enum mminit_level level,
-				const char *prefix, const char *fmt, ...)
-{
-}
-
-static inline void mminit_verify_pageflags_layout(void)
-{
-}
-
-static inline void mminit_verify_zonelist(void)
-{
-}
-#endif /* CONFIG_DEBUG_MEMORY_INIT */
-
 #define NODE_RECLAIM_NOSCAN	-2
 #define NODE_RECLAIM_FULL	-1
 #define NODE_RECLAIM_SOME	0
@@ -1532,9 +1447,6 @@ static inline bool gup_must_unshare(stru
 	return !PageAnonExclusive(page);
 }
 
-extern bool mirrored_kernelcore;
-bool memblock_has_mirror(void);
-void memblock_free_all(void);
 
 static __always_inline void vma_set_range(struct vm_area_struct *vma,
 					  unsigned long start, unsigned long end,
@@ -1573,9 +1485,6 @@ static inline bool pte_needs_soft_dirty_
 	return vma_soft_dirty_enabled(vma) && !pte_soft_dirty(pte);
 }
 
-void __meminit __init_single_page(struct page *page, unsigned long pfn,
-				unsigned long zone, int nid);
-
 /* shrinker related functions */
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
 			  int priority);
--- a/mm/memblock.c~mm-split-out-mm_init-and-memblock-declarations-from-internalh
+++ a/mm/memblock.c
@@ -29,6 +29,7 @@
 #include <linux/io.h>
 
 #include "internal.h"
+#include "mm_init.h"
 
 #define INIT_MEMBLOCK_REGIONS			128
 #define INIT_PHYSMEM_REGIONS			4
--- a/mm/memory_hotplug.c~mm-split-out-mm_init-and-memblock-declarations-from-internalh
+++ a/mm/memory_hotplug.c
@@ -40,6 +40,7 @@
 #include <asm/tlbflush.h>
 
 #include "internal.h"
+#include "mm_init.h"
 #include "page_alloc.h"
 #include "shuffle.h"
 
--- a/mm/mm_init.c~mm-split-out-mm_init-and-memblock-declarations-from-internalh
+++ a/mm/mm_init.c
@@ -33,6 +33,7 @@
 #include <linux/kexec_handover.h>
 #include <linux/hugetlb.h>
 #include "internal.h"
+#include "mm_init.h"
 #include "page_alloc.h"
 #include "slab.h"
 #include "shuffle.h"
diff --git a/mm/mm_init.h a/mm/mm_init.h
new file mode 100644
--- /dev/null
+++ a/mm/mm_init.h
@@ -0,0 +1,120 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * mm_init.h:
+ *
+ * mm/ internal mm_init and memblock declarations
+ */
+
+#ifndef __MM_MM_INIT_H
+#define __MM_MM_INIT_H
+
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/mmzone.h>
+#include <linux/jump_label.h>
+#include <linux/printk.h>
+
+struct page;
+struct vmem_altmap;
+
+/* perform sanity checks on struct pages being allocated or freed */
+DECLARE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
+
+void set_zone_contiguous(struct zone *zone);
+bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
+			   unsigned long nr_pages);
+
+static inline void clear_zone_contiguous(struct zone *zone)
+{
+	zone->contiguous = false;
+}
+
+void memblock_free_pages(unsigned long pfn, unsigned int order);
+
+void *memmap_alloc(phys_addr_t size, phys_addr_t align, phys_addr_t min_addr,
+		int nid, bool exact_nid);
+
+void memmap_init_range(unsigned long size, int nid, unsigned long zone,
+		unsigned long start_pfn, unsigned long zone_end_pfn,
+		enum meminit_context context,
+		struct vmem_altmap *altmap, int migratetype,
+		bool isolate_pageblock);
+
+#if defined CONFIG_COMPACTION || defined CONFIG_CMA
+/* Free whole pageblock and set its migration type to MIGRATE_CMA. */
+void init_cma_reserved_pageblock(struct page *page);
+#endif
+
+#ifdef CONFIG_CMA
+void init_cma_pageblock(struct page *page);
+#else
+static inline void init_cma_pageblock(struct page *page)
+{
+}
+#endif
+
+/* Memory initialisation debug and verification */
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+DECLARE_STATIC_KEY_TRUE(deferred_pages);
+
+static inline bool deferred_pages_enabled(void)
+{
+	return static_branch_unlikely(&deferred_pages);
+}
+
+bool __init deferred_grow_zone(struct zone *zone, unsigned int order);
+#else
+static inline bool deferred_pages_enabled(void)
+{
+	return false;
+}
+#endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
+
+void init_deferred_page(unsigned long pfn, int nid);
+
+enum mminit_level {
+	MMINIT_WARNING,
+	MMINIT_VERIFY,
+	MMINIT_TRACE
+};
+
+#ifdef CONFIG_DEBUG_MEMORY_INIT
+
+extern int mminit_loglevel;
+
+#define mminit_dprintk(level, prefix, fmt, arg...) \
+do { \
+	if (level < mminit_loglevel) { \
+		if (level <= MMINIT_WARNING) \
+			pr_warn("mminit::" prefix " " fmt, ##arg);	\
+		else \
+			printk(KERN_DEBUG "mminit::" prefix " " fmt, ##arg); \
+	} \
+} while (0)
+
+void mminit_verify_pageflags_layout(void);
+void mminit_verify_zonelist(void);
+#else
+
+static inline void mminit_dprintk(enum mminit_level level,
+				const char *prefix, const char *fmt, ...)
+{
+}
+
+static inline void mminit_verify_pageflags_layout(void)
+{
+}
+
+static inline void mminit_verify_zonelist(void)
+{
+}
+#endif /* CONFIG_DEBUG_MEMORY_INIT */
+
+extern bool mirrored_kernelcore;
+bool memblock_has_mirror(void);
+void memblock_free_all(void);
+
+void __meminit __init_single_page(struct page *page, unsigned long pfn,
+				unsigned long zone, int nid);
+
+#endif /* __MM_MM_INIT_H */
--- a/mm/page_alloc.c~mm-split-out-mm_init-and-memblock-declarations-from-internalh
+++ a/mm/page_alloc.c
@@ -56,6 +56,7 @@
 #include <linux/pgalloc_tag.h>
 #include <asm/div64.h>
 #include "internal.h"
+#include "mm_init.h"
 #include "page_alloc.h"
 #include "shuffle.h"
 #include "page_reporting.h"
--- a/mm/sparse.c~mm-split-out-mm_init-and-memblock-declarations-from-internalh
+++ a/mm/sparse.c
@@ -15,6 +15,7 @@
 #include <linux/swapops.h>
 #include <linux/vmstat.h>
 #include "internal.h"
+#include "mm_init.h"
 #include <asm/dma.h>
 
 /*
--- a/mm/sparse-vmemmap.c~mm-split-out-mm_init-and-memblock-declarations-from-internalh
+++ a/mm/sparse-vmemmap.c
@@ -41,6 +41,7 @@
 #define VMEMMAP_POPULATE_PAGEREF	0x0001
 
 #include "internal.h"
+#include "mm_init.h"
 
 /*
  * Allocate a block of memory to be used to back the virtual memory map
--- a/tools/testing/memblock/internal.h~mm-split-out-mm_init-and-memblock-declarations-from-internalh
+++ a/tools/testing/memblock/internal.h
@@ -28,22 +28,6 @@ static inline struct page *virt_to_page(
 	return virt;
 }
 
-void memblock_free_pages(unsigned long pfn, unsigned int order)
-{
-}
-
-static inline void accept_memory(phys_addr_t start, unsigned long size)
-{
-}
-
-unsigned long free_reserved_area(void *start, void *end, int poison, const char *s);
-void free_reserved_page(struct page *page);
-
-static inline bool deferred_pages_enabled(void)
-{
-	return false;
-}
-
 #define for_each_valid_pfn(pfn, start_pfn, end_pfn)			 \
 	for ((pfn) = (start_pfn); (pfn) < (end_pfn); (pfn)++)
 
@@ -60,10 +44,6 @@ static inline bool __is_kernel(unsigned
 #define for_each_valid_pfn(pfn, start_pfn, end_pfn)                     \
        for ((pfn) = (start_pfn); (pfn) < (end_pfn); (pfn)++)
 
-static inline void init_deferred_page(unsigned long pfn, int nid)
-{
-}
-
 #define __SetPageReserved(p)	((void)(p))
 
 #endif
diff --git a/tools/testing/memblock/mm_init.h a/tools/testing/memblock/mm_init.h
new file mode 100644
--- /dev/null
+++ a/tools/testing/memblock/mm_init.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef __MM_MM_INIT_H
+#define __MM_MM_INIT_H
+
+void memblock_free_pages(unsigned long pfn, unsigned int order)
+{
+}
+
+static inline void accept_memory(phys_addr_t start, unsigned long size)
+{
+}
+
+unsigned long free_reserved_area(void *start, void *end, int poison, const char *s);
+void free_reserved_page(struct page *page);
+
+static inline bool deferred_pages_enabled(void)
+{
+	return false;
+}
+
+static inline void init_deferred_page(unsigned long pfn, int nid)
+{
+}
+#endif /* __MM_MM_INIT_H */
_

Patches currently in -mm which might be from rppt@kernel.org are

sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch

