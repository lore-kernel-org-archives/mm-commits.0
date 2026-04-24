Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E8A3CF693
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 17:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777052723; cv=none; b=MomxhC5bX2/l/7mnOlptEhOMh1JUkQzAEun2iwuutrifd464qwr8EnJBRkNufzZ7Ou2WlmQ8/hmvWMYjyjBX9H2KOVqYpSnIJ7wfR61aZMxbZog7FkgHEwW7kS6vjU1udmzmese+WO/nCO+icnHS7t3Nz0nKmMsrOo+X83Yfbi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777052723; c=relaxed/simple;
	bh=2oFpCxj0OA1rHtUn5+5wYiJgO9hRZFC0CKZ6qf3P3D0=;
	h=Date:To:From:Subject:Message-Id; b=Zfr36TGIXzC8GgmuZCqVgCJ22yU/Cbv4sHlfNJQy5pRAJwb04YUlfwMBAQMCEkzXvIh98qRftU2RoBUg8Mvlo2gTJDDFrrkGsN3oNIkRo0QHv+vGljHuSWnj+Lqop0aQqi0hrwQUsJupOywPE3+ZftC0A86SJgwm8sDwhRPRX/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s+IbaHLg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s+IbaHLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03684C19425;
	Fri, 24 Apr 2026 17:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777052723;
	bh=2oFpCxj0OA1rHtUn5+5wYiJgO9hRZFC0CKZ6qf3P3D0=;
	h=Date:To:From:Subject:From;
	b=s+IbaHLg/obrDr78ExH4fSlUqH6ljfNVyTR46b9eLDuKPkstpYT/JYoakpZO/S0qL
	 EZuBCeO98pWtj6W/ESyIkMTCpNTmxEtxEd6xdw5V/F8tBXp360EmG0M9TINWCm95Uy
	 qgyImmSa4KJEuNKppb4slIB+PO3wY1FWxecZLoSo=
Date: Fri, 24 Apr 2026 10:45:22 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch added to mm-new branch
Message-Id: <20260424174523.03684C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: remove sparse buffer pre-allocation mechanism
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse: remove sparse buffer pre-allocation mechanism
Date: Fri, 10 Apr 2026 17:24:19 +0800

Commit 9bdac9142407 ("sparsemem: Put mem map for one node together.")
introduced a mechanism to pre-allocate a large memory block to hold all
memmaps for a NUMA node upfront.

However, the original commit message did not clearly state the actual
benefits or the necessity of explicitly pre-allocating a single chunk for
all memmap areas of a given node.

One of the concerns about removing this pre-allocation is that the
subsequent per-section memmap allocations could become scattered around,
and might turn too many memory blocks/sections into an "un-offlinable"
state.  However, tests show that even without the explicit node-wide
pre-allocation, memblock still allocates memory closely and back-to-back. 
When tracing vmemmap_set_pmd allocations, the physical chunks allocated by
memblock are strictly adjacent to each other in a single contiguous
physical range (mapped top-down).  Because they are packed tightly
together naturally, they will at most consume or pollute the exact same
number of memory blocks as the explicit pre-allocation did.

Another concern is the boot performance impact of calling memmap_alloc()
multiple times compared to one large node-wide allocation.  Tests on a
256GB VM showed that memmap allocation time increased from 199,555 ns to
741,292 ns.  Even though it is 3.7x slower, on a 1TB machine, the entire
memory allocation time would only take a few milliseconds.  This boot
performance difference is completely negligible.

Since no negative impact on memory offlining behavior or noticeable boot
performance regression was found, this patch proposes removing the
explicit node-wide memmap pre-allocation mechanism to reduce the
maintenance burden.

Link: https://lore.kernel.org/20260410092419.2446420-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    1 
 mm/sparse-vmemmap.c |    7 -----
 mm/sparse.c         |   58 ------------------------------------------
 3 files changed, 2 insertions(+), 64 deletions(-)

--- a/include/linux/mm.h~mm-sparse-remove-sparse-buffer-pre-allocation-mechanism
+++ a/include/linux/mm.h
@@ -4855,7 +4855,6 @@ static inline void print_vma_addr(char *
 }
 #endif
 
-void *sparse_buffer_alloc(unsigned long size);
 unsigned long section_map_size(void);
 struct page * __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
--- a/mm/sparse.c~mm-sparse-remove-sparse-buffer-pre-allocation-mechanism
+++ a/mm/sparse.c
@@ -239,12 +239,9 @@ struct page __init *__populate_section_m
 		struct dev_pagemap *pgmap)
 {
 	unsigned long size = section_map_size();
-	struct page *map = sparse_buffer_alloc(size);
+	struct page *map;
 	phys_addr_t addr = __pa(MAX_DMA_ADDRESS);
 
-	if (map)
-		return map;
-
 	map = memmap_alloc(size, size, addr, nid, false);
 	if (!map)
 		panic("%s: Failed to allocate %lu bytes align=0x%lx nid=%d from=%pa\n",
@@ -254,55 +251,6 @@ struct page __init *__populate_section_m
 }
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
-static void *sparsemap_buf __meminitdata;
-static void *sparsemap_buf_end __meminitdata;
-
-static inline void __meminit sparse_buffer_free(unsigned long size)
-{
-	WARN_ON(!sparsemap_buf || size == 0);
-	memblock_free(sparsemap_buf, size);
-}
-
-static void __init sparse_buffer_init(unsigned long size, int nid)
-{
-	phys_addr_t addr = __pa(MAX_DMA_ADDRESS);
-	WARN_ON(sparsemap_buf);	/* forgot to call sparse_buffer_fini()? */
-	/*
-	 * Pre-allocated buffer is mainly used by __populate_section_memmap
-	 * and we want it to be properly aligned to the section size - this is
-	 * especially the case for VMEMMAP which maps memmap to PMDs
-	 */
-	sparsemap_buf = memmap_alloc(size, section_map_size(), addr, nid, true);
-	sparsemap_buf_end = sparsemap_buf + size;
-}
-
-static void __init sparse_buffer_fini(void)
-{
-	unsigned long size = sparsemap_buf_end - sparsemap_buf;
-
-	if (sparsemap_buf && size > 0)
-		sparse_buffer_free(size);
-	sparsemap_buf = NULL;
-}
-
-void * __meminit sparse_buffer_alloc(unsigned long size)
-{
-	void *ptr = NULL;
-
-	if (sparsemap_buf) {
-		ptr = (void *) roundup((unsigned long)sparsemap_buf, size);
-		if (ptr + size > sparsemap_buf_end)
-			ptr = NULL;
-		else {
-			/* Free redundant aligned space */
-			if ((unsigned long)(ptr - sparsemap_buf) > 0)
-				sparse_buffer_free((unsigned long)(ptr - sparsemap_buf));
-			sparsemap_buf = ptr + size;
-		}
-	}
-	return ptr;
-}
-
 void __weak __meminit vmemmap_populate_print_last(void)
 {
 }
@@ -360,8 +308,6 @@ static void __init sparse_init_nid(int n
 		goto failed;
 	}
 
-	sparse_buffer_init(map_count * section_map_size(), nid);
-
 	sparse_vmemmap_init_nid_early(nid);
 
 	for_each_present_section_nr(pnum_begin, pnum) {
@@ -379,7 +325,6 @@ static void __init sparse_init_nid(int n
 				       __func__, nid);
 				pnum_begin = pnum;
 				sparse_usage_fini();
-				sparse_buffer_fini();
 				goto failed;
 			}
 			memmap_boot_pages_add(DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
@@ -388,7 +333,6 @@ static void __init sparse_init_nid(int n
 		}
 	}
 	sparse_usage_fini();
-	sparse_buffer_fini();
 	return;
 failed:
 	/*
--- a/mm/sparse-vmemmap.c~mm-sparse-remove-sparse-buffer-pre-allocation-mechanism
+++ a/mm/sparse-vmemmap.c
@@ -87,15 +87,10 @@ static void * __meminit altmap_alloc_blo
 void * __meminit vmemmap_alloc_block_buf(unsigned long size, int node,
 					 struct vmem_altmap *altmap)
 {
-	void *ptr;
-
 	if (altmap)
 		return altmap_alloc_block_buf(size, altmap);
 
-	ptr = sparse_buffer_alloc(size);
-	if (!ptr)
-		ptr = vmemmap_alloc_block(size, node);
-	return ptr;
+	return vmemmap_alloc_block(size, node);
 }
 
 static unsigned long __meminit vmem_altmap_next_pfn(struct vmem_altmap *altmap)
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch

