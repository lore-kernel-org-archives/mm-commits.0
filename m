Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75DC2D3733
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334148; cv=none; b=kt9CjdzjToZG5HiEcNQpuvKa7Da/T+r0Dvd3Wwvu6N0eARbfXEQ9F2d5MeS4y9PqOOK/s+v48TnQfeSsahL/204O5e6xzI+KJtcc5Jbj+iLk81fcz0y8DGw2mnnXNL5855I1E7shdv7OAXjkP5xeCyaRcQfRtNc6uY6y/Vpm4gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334148; c=relaxed/simple;
	bh=40Lfng/UvS7tIbklkwW/diEhR7uw1DZej5tBcNclR74=;
	h=Date:To:From:Subject:Message-Id; b=Wfo1kXuzUknSEm3T87c3rzT188lzVzz0szZAJPQwgyGVNjCgOquGiSto5bHPAphmiAKfR2rAjlacIKZFvBb9lBgNIIAXbzOjYiX30M/jSJZbrqFtZ/EAcCYNE/GQltEJBqdeDXca9OCCpeJEzP41nz3+ausN3naTSO9QCXgpjoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UnpO6R6u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UnpO6R6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F3C1F0089D;
	Wed,  7 Oct 2026 00:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334146;
	bh=qmVFhBy45M+bfUW/7Ue1qNhCTZQnLyTn4tZ8fAkk9IA=;
	h=Date:To:From:Subject;
	b=UnpO6R6ueSPV47TixBtjg461EGN67vfwJeCstY7LVS5Q2Xip3rfev5prwWJ6IxMqg
	 Og8WVHaFN1KvqGQ0EdxqG2thjHORRnq1ywHK/ncsmOHUXMcGNIya5Lzw9zZxRAxz2D
	 37FbAunlS2/I+SXc8Umxe/qIx6El0nYkjyDBaK4Q=
Date: Tue, 06 Oct 2026 17:49:05 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david.laight.linux@gmail.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-relax-struct-mem_section-size-constraints.patch removed from -mm tree
Message-Id: <20261007004906.52F3C1F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: relax struct mem_section size constraints
has been removed from the -mm tree.  Its filename was
     mm-sparse-relax-struct-mem_section-size-constraints.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse: relax struct mem_section size constraints
Date: Thu, 10 Sep 2026 14:32:40 +0800

Patch series "mm: Introduce section-based vmemmap optimization for
HugeTLB", v6.

This series is split out from the earlier, larger series "mm: Generalize
HVO for HugeTLB and device DAX" [1].  While the parent series generalizes
vmemmap optimization across HugeTLB and device DAX, this subset addresses
a single, self-contained step: making the generic sparse-vmemmap code
section-based optimization aware and switching HugeTLB bootmem pages to
this path.

HugeTLB vmemmap optimization currently has its own early boot setup path. 
It pre-populates optimized vmemmap mappings before the normal
sparse-vmemmap population code runs, and sparsemem carries
SPARSEMEM_VMEMMAP_PREINIT only to support that special case.

That makes the HugeTLB vmemmap optimization path harder to share with
other users of sparse-vmemmap optimization and leaves a fair amount of
HugeTLB-specific boot-time state in the generic memory initialization
flow.

This series introduces section-based vmemmap optimization support in the
sparse-vmemmap code and switches HugeTLB bootmem pages over to it. 
Instead of having HugeTLB pre-populate optimized vmemmap mappings itself,
HugeTLB now records the compound page order in the corresponding memory
sections.  The generic sparse-vmemmap population path can then allocate or
reuse shared tail vmemmap pages based on section metadata.

The patches are organized as follows:

  - patches 1-2 prepare sparsemem and vmemmap optimization metadata
  - patches 3-8 teach the common sparse-vmemmap paths to use that state
  - patches 9-10 switch HugeTLB bootmem optimization to the
    section-based path
  - patches 11-17 clean up sparsemem and HugeTLB bootmem code that is no
    longer needed after the conversion

This is intended to be the second smaller step toward the broader HVO
generalization.  The device DAX conversion and the wider HVO consolidation
are left for follow-up series.


This patch (of 17):

struct mem_section is currently forced to a power-of-2 size so the
section-to-root lookup can use a mask instead of a modulo.

That requirement makes future extensions harder than necessary: adding a
small field can require configuration-dependent padding or layout checks
just to preserve the lookup scheme.  Keep the lookup correct for any
struct mem_section size by using a plain modulo instead.

Do not leave the layout entirely unconstrained, though.  Keep struct
mem_section double-word aligned so modest size changes, such as adding
another word-sized field on 64-bit systems, still keep a compact and
efficient layout.  If future fields grow the structure beyond that sweet
spot, the lookup remains correct; only the exact layout efficiency
changes.

Link: https://lore.kernel.org/20260910063256.64386-2-songmuchun@bytedance.com
Link: https://lore.kernel.org/all/20260513130542.35604-1-songmuchun@bytedance.com/ [1]
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
---

 include/linux/mmzone.h  |   11 +++--------
 mm/sparse.c             |    2 --
 scripts/gdb/linux/mm.py |    6 ++----
 3 files changed, 5 insertions(+), 14 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-relax-struct-mem_section-size-constraints
+++ a/include/linux/mmzone.h
@@ -2027,13 +2027,9 @@ struct mem_section {
 	 * section. (see page_ext.h about this.)
 	 */
 	struct page_ext *page_ext;
-	unsigned long pad;
 #endif
-	/*
-	 * WARNING: mem_section must be a power-of-2 in size for the
-	 * calculation and use of SECTION_ROOT_MASK to make sense.
-	 */
-};
+/* Sacrifice minor padding space for efficient lookup. */
+} __aligned(2 * sizeof(unsigned long));
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
 #define SECTIONS_PER_ROOT       (PAGE_SIZE / sizeof (struct mem_section))
@@ -2043,7 +2039,6 @@ struct mem_section {
 
 #define SECTION_NR_TO_ROOT(sec)	((sec) / SECTIONS_PER_ROOT)
 #define NR_SECTION_ROOTS	DIV_ROUND_UP(NR_MEM_SECTIONS, SECTIONS_PER_ROOT)
-#define SECTION_ROOT_MASK	(SECTIONS_PER_ROOT - 1)
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
 extern struct mem_section **mem_section;
@@ -2067,7 +2062,7 @@ static inline struct mem_section *__nr_t
 	if (!mem_section || !mem_section[root])
 		return NULL;
 #endif
-	return &mem_section[root][nr & SECTION_ROOT_MASK];
+	return &mem_section[root][nr % SECTIONS_PER_ROOT];
 }
 
 /*
--- a/mm/sparse.c~mm-sparse-relax-struct-mem_section-size-constraints
+++ a/mm/sparse.c
@@ -322,8 +322,6 @@ void __init sparse_init(void)
 	unsigned long pnum_end, pnum_begin, map_count = 1;
 	int nid_begin;
 
-	/* see include/linux/mmzone.h 'struct mem_section' definition */
-	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
 	memblocks_present();
 
 	if (compound_info_has_mask()) {
--- a/scripts/gdb/linux/mm.py~mm-sparse-relax-struct-mem_section-size-constraints
+++ a/scripts/gdb/linux/mm.py
@@ -70,7 +70,6 @@ class x86_page_ops():
             self.SECTIONS_PER_ROOT = 1
 
         self.NR_SECTION_ROOTS = DIV_ROUND_UP(self.NR_MEM_SECTIONS, self.SECTIONS_PER_ROOT)
-        self.SECTION_ROOT_MASK = self.SECTIONS_PER_ROOT - 1
 
         try:
             self.SECTION_HAS_MEM_MAP = 1 << int(gdb.parse_and_eval('SECTION_HAS_MEM_MAP_BIT'))
@@ -100,7 +99,7 @@ class x86_page_ops():
     def __nr_to_section(self, nr):
         root = self.SECTION_NR_TO_ROOT(nr)
         mem_section = gdb.parse_and_eval("mem_section")
-        return mem_section[root][nr & self.SECTION_ROOT_MASK]
+        return mem_section[root][nr % self.SECTIONS_PER_ROOT]
 
     def pfn_to_section_nr(self, pfn):
         return pfn >> self.PFN_SECTION_SHIFT
@@ -249,7 +248,6 @@ class aarch64_page_ops():
             self.SECTIONS_PER_ROOT = 1
 
         self.NR_SECTION_ROOTS = DIV_ROUND_UP(self.NR_MEM_SECTIONS, self.SECTIONS_PER_ROOT)
-        self.SECTION_ROOT_MASK = self.SECTIONS_PER_ROOT - 1
         self.SUBSECTION_SHIFT = 21
         self.SEBSECTION_SIZE = 1 << self.SUBSECTION_SHIFT
         self.PFN_SUBSECTION_SHIFT = self.SUBSECTION_SHIFT - self.PAGE_SHIFT
@@ -304,7 +302,7 @@ class aarch64_page_ops():
     def __nr_to_section(self, nr):
         root = self.SECTION_NR_TO_ROOT(nr)
         mem_section = gdb.parse_and_eval("mem_section")
-        return mem_section[root][nr & self.SECTION_ROOT_MASK]
+        return mem_section[root][nr % self.SECTIONS_PER_ROOT]
 
     def pfn_to_section_nr(self, pfn):
         return pfn >> self.PFN_SECTION_SHIFT
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


