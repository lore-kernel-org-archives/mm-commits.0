Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9021E3BCD13
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896687; cv=none; b=tcRgnHcZBKHScyIw/wroIak0W6iHd0Q3JLHrgSXyCGejg63CMrsNXhg4P2O3nMYHi8JUN9sDsk4rb6vaTCO4V8NdHGiTwfqcEBplQ3jy37Rzw1+rMP6QaiWoUJeuqHaFZCfIdOtfWi8vFvgbPCHRiZqkE4hxsqDxVGILHupgEm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896687; c=relaxed/simple;
	bh=1U1AVl5wMoYUo6iVgmLfA9tKX4FhCuj7iSnt4wnjt2g=;
	h=Date:To:From:Subject:Message-Id; b=EV0qLc91Lt4vHTF78T2tGrtvhjPMNBdc96ye1UNSXrgTms+noegyFrA6z1j4FLuIBAr8oM+M5pP1IHrVakhGjc3wzkGqCrcDpZi0CwjIc6PGA7XA9HU62Qosmlfhknp6SOZuUB/aA0Id/CmJ0Hljm2f6zHGhnWqpu7BT4UYtgRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jNY495l4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jNY495l4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCF11F000E9;
	Wed,  5 Aug 2026 02:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896685;
	bh=daUjN3dJ+39QraW0AHh2SfdWH5nVZiiGaAnw2XSDD8s=;
	h=Date:To:From:Subject;
	b=jNY495l4RAMgqyEV4oXobnC66Jdfvge+a3MoQrBb+fSp+3d0Y7xt9TikmvAqxMYjU
	 0WWanRZfT1vtFgJGb2n9qxu44xVGbyW0/OIJyd0nu7FY2h+Duo2zhlVN6Ke/XWK6hv
	 Kzk9S1zd9Is0BQWBo02cqSSPWMgF+BDazozazOIQ=
Date: Tue, 04 Aug 2026 19:24:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,urezki@gmail.com,tj@kernel.org,surenb@google.com,sj@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,graf@amazon.com,glider@google.com,elver@google.com,dvyukov@google.com,dennis@kernel.org,david@kernel.org,brendan.jackman@linux.dev,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-split-out-sparse-declarations-from-internalh.patch removed from -mm tree
Message-Id: <20260805022445.5CCF11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: split out sparse declarations from internal.h
has been removed from the -mm tree.  Its filename was
     mm-split-out-sparse-declarations-from-internalh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm: split out sparse declarations from internal.h
Date: Thu, 09 Jul 2026 13:00:04 +0300

mm/internal.h becomes more and more bloated.

Move declarations related to SPARSE and SPARSE_VMEMMAP memory models to
a new mm/sparse.h header.

No functional changes.

Link: https://lore.kernel.org/20260709-internal-h-v2-2-695631425968@kernel.org
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

 MAINTAINERS         |    1 
 mm/internal.h       |   52 ----------------------------------
 mm/mm_init.c        |    1 
 mm/sparse-vmemmap.c |    1 
 mm/sparse.c         |    1 
 mm/sparse.h         |   63 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 67 insertions(+), 52 deletions(-)

--- a/MAINTAINERS~mm-split-out-sparse-declarations-from-internalh
+++ a/MAINTAINERS
@@ -17001,6 +17001,7 @@ F:	mm/pgtable-generic.c
 F:	mm/ptdump.c
 F:	mm/sparse-vmemmap.c
 F:	mm/sparse.c
+F:	mm/sparse.h
 F:	mm/util.c
 F:	mm/vmpressure.c
 F:	mm/vmstat.c
--- a/mm/internal.h~mm-split-out-sparse-declarations-from-internalh
+++ a/mm/internal.h
@@ -807,58 +807,6 @@ static inline void init_compound_tail(st
 	prep_compound_tail(tail, head, order);
 }
 
-/*
- * mm/sparse.c
- */
-#ifdef CONFIG_SPARSEMEM
-void sparse_init(void);
-int sparse_index_init(unsigned long section_nr, int nid);
-
-static inline void sparse_init_one_section(struct mem_section *ms,
-		unsigned long pnum, struct page *mem_map,
-		struct mem_section_usage *usage, unsigned long flags)
-{
-	unsigned long coded_mem_map;
-
-	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
-
-	/*
-	 * We encode the start PFN of the section into the mem_map such that
-	 * page_to_pfn() on !CONFIG_SPARSEMEM_VMEMMAP can simply subtract it
-	 * from the page pointer to obtain the PFN.
-	 */
-	coded_mem_map = (unsigned long)(mem_map - section_nr_to_pfn(pnum));
-	VM_WARN_ON_ONCE(coded_mem_map & ~SECTION_MAP_MASK);
-
-	ms->section_mem_map &= ~SECTION_MAP_MASK;
-	ms->section_mem_map |= coded_mem_map;
-	ms->section_mem_map |= flags | SECTION_HAS_MEM_MAP;
-	ms->usage = usage;
-}
-
-static inline void __section_mark_present(struct mem_section *ms,
-		unsigned long section_nr)
-{
-	if (section_nr > __highest_present_section_nr)
-		__highest_present_section_nr = section_nr;
-
-	ms->section_mem_map |= SECTION_MARKED_PRESENT;
-}
-#else
-static inline void sparse_init(void) {}
-#endif /* CONFIG_SPARSEMEM */
-
-/*
- * mm/sparse-vmemmap.c
- */
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-void sparse_init_subsection_map(void);
-#else
-static inline void sparse_init_subsection_map(void)
-{
-}
-#endif /* CONFIG_SPARSEMEM_VMEMMAP */
-
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
 /*
--- a/mm/mm_init.c~mm-split-out-sparse-declarations-from-internalh
+++ a/mm/mm_init.c
@@ -35,6 +35,7 @@
 #include "internal.h"
 #include "mm_init.h"
 #include "page_alloc.h"
+#include "sparse.h"
 #include "slab.h"
 #include "shuffle.h"
 
--- a/mm/sparse.c~mm-split-out-sparse-declarations-from-internalh
+++ a/mm/sparse.c
@@ -16,6 +16,7 @@
 #include <linux/vmstat.h>
 #include "internal.h"
 #include "mm_init.h"
+#include "sparse.h"
 #include <asm/dma.h>
 
 /*
diff --git a/mm/sparse.h a/mm/sparse.h
new file mode 100644
--- /dev/null
+++ a/mm/sparse.h
@@ -0,0 +1,63 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * sparse.h:
+ *
+ * mm/ internal sparse and sparse-vmemmap declarations
+ */
+
+#ifndef __MM_SPARSE_H
+#define __MM_SPARSE_H
+
+#include <linux/mmzone.h>
+
+/*
+ * mm/sparse.c
+ */
+#ifdef CONFIG_SPARSEMEM
+void sparse_init(void);
+int sparse_index_init(unsigned long section_nr, int nid);
+
+static inline void sparse_init_one_section(struct mem_section *ms,
+		unsigned long pnum, struct page *mem_map,
+		struct mem_section_usage *usage, unsigned long flags)
+{
+	unsigned long coded_mem_map;
+
+	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
+
+	/*
+	 * We encode the start PFN of the section into the mem_map such that
+	 * page_to_pfn() on !CONFIG_SPARSEMEM_VMEMMAP can simply subtract it
+	 * from the page pointer to obtain the PFN.
+	 */
+	coded_mem_map = (unsigned long)(mem_map - section_nr_to_pfn(pnum));
+	VM_WARN_ON_ONCE(coded_mem_map & ~SECTION_MAP_MASK);
+
+	ms->section_mem_map &= ~SECTION_MAP_MASK;
+	ms->section_mem_map |= coded_mem_map;
+	ms->section_mem_map |= flags | SECTION_HAS_MEM_MAP;
+	ms->usage = usage;
+}
+
+static inline void __section_mark_present(struct mem_section *ms,
+		unsigned long section_nr)
+{
+	if (section_nr > __highest_present_section_nr)
+		__highest_present_section_nr = section_nr;
+
+	ms->section_mem_map |= SECTION_MARKED_PRESENT;
+}
+#else
+static inline void sparse_init(void) {}
+#endif /* CONFIG_SPARSEMEM */
+
+/*
+ * mm/sparse-vmemmap.c
+ */
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+void sparse_init_subsection_map(void);
+#else
+static inline void sparse_init_subsection_map(void) {}
+#endif /* CONFIG_SPARSEMEM_VMEMMAP */
+
+#endif /* __MM_SPARSE_H */
--- a/mm/sparse-vmemmap.c~mm-split-out-sparse-declarations-from-internalh
+++ a/mm/sparse-vmemmap.c
@@ -42,6 +42,7 @@
 
 #include "internal.h"
 #include "mm_init.h"
+#include "sparse.h"
 
 /*
  * Allocate a block of memory to be used to back the virtual memory map
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

