Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D58C346A19
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 22:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783635718; cv=none; b=TLLX++tas6tw8/R9U84NGzns49ctZnxpqpgjL2Eak85BdBc8YmpJVPh1JlN8v72kkZPzcua8m6qqWp7Yr1hBiuTguur/SkSEF2RutRie1Ym4GHIRW/oD6Zss+itDLbZYuzicwmpuamSAmERJkxTdB63lEjIBpwtJP2tsw13bdik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783635718; c=relaxed/simple;
	bh=UoyJ95V4wGmU1rmh+pdTY9AaUYR1PVLqPE1j1gOlFyE=;
	h=Date:To:From:Subject:Message-Id; b=mlVBzjP0c8wgir6/mVu/HTIsG/+zW0K7ZRMy5EdSgeLQ6SRydnOVic+7KacLf9Yvd8xvjoCEhYvZaXlimCBBiE5oXEg/IzXGMcBab41AhlnECKqfoocZnfH6dPRz4m3+/DN04NDe6+3Hl/TtAY/azauCbuwwKg0v5YDyFIjABwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KdEOqClC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KdEOqClC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24A21F000E9;
	Thu,  9 Jul 2026 22:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783635717;
	bh=0YsvrDz/ne7Sh7Zlgpyf2d8gPZaCWds7x4GAyEYn8i8=;
	h=Date:To:From:Subject;
	b=KdEOqClC8uap18VcfvrnvUQUoy5eqnaw7nYaAn/KoEIKfyj8nGF8Q1wSZWSjuCb0I
	 GfQs2qdRBt1Ty5bA4ecqX3IZ7Vs7lnJn00Br0skyBAlEqMXY10Gkpw3uskyUvtYx9F
	 mfa0Z7k4iGOlmZm68mvhSLBhmVe8K/vPvK3vx3vQ=
Date: Thu, 09 Jul 2026 15:21:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,urezki@gmail.com,tj@kernel.org,surenb@google.com,pratyush@kernel.org,pasha.tatashin@soleen.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,graf@amazon.com,glider@google.com,elver@google.com,dvyukov@google.com,dennis@kernel.org,david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-split-out-sparse-declarations-from-internalh.patch added to mm-new branch
Message-Id: <20260709222156.E24A21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: split out sparse declarations from internal.h
has been added to the -mm mm-new branch.  Its filename is
     mm-split-out-sparse-declarations-from-internalh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-split-out-sparse-declarations-from-internalh.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Alexander Graf <graf@amazon.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
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
@@ -16999,6 +16999,7 @@ F:	mm/pgtable-generic.c
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

userfaultfd-prevent-registration-of-special-vmas.patch
selftests-mm-uffd-dont-treat-uffdio_copy-enoent-as-a-failure.patch
mm-split-out-mm_init-and-memblock-declarations-from-internalh.patch
mm-split-out-sparse-declarations-from-internalh.patch
mm-split-out-vmalloc-declarations-from-internalh.patch

