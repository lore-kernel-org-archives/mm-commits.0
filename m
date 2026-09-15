Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F341F91F6
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 04:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789446158; cv=none; b=esDIHNrf8NsMyX+DEWnaV+7M2axqjWquYuyXybPFEmk9CqtE13BfXS79VuINCBij82KasKFFSl52l61OXhUv6+yk3iQxAZlkLPVKK27qeoWnLw9wD0ic7DUCRUjGxYrwyBUvveUgKTGiruhciSBPhGLjfsDArJsWMur/sn3Jics=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789446158; c=relaxed/simple;
	bh=t96IEX41Z05Hdicv0WHiMeVQFr6tUsGMyK7JYGWkDJs=;
	h=Date:To:From:Subject:Message-Id; b=SypjQw5xjcqNwPVEVFM/uxKImUuxbPnvMZkLjtwjW8Y8qLzPiuKNJ6bvLeSW9Ch+qKvuuuevYW1GHH/7Uy7Aacw1jhod2UEl1lgyAv8aYeUmKvkcflggVcSpMrupkjj0XgybKkwP1sXvD9E2ZZxA6uYS0Rr1yNiCNvGyAOOb54o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fnEjiBzb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fnEjiBzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E173F1F00898;
	Tue, 15 Sep 2026 04:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789446157;
	bh=p9dwCvTG6XkKhpYLKAr7sAIpapTOIkVmd0IaeWl9eH8=;
	h=Date:To:From:Subject;
	b=fnEjiBzbkY4/rm23ceP5k7LOWY/hP4S5U9hx43KDeLKiPUNqqdIH6FysWpnWliSyD
	 eq6f441MiQ1EsNRDEBMR5oUQkGj1q6SmB/uaHiJivNgAj3ObjWM8yT15xFUOYSzjiz
	 zMMXgE4Eesi6uiqrST/H4o7HUpZriRMHZGuYZTHg=
Date: Mon, 14 Sep 2026 21:22:36 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unused-exact_nid-parameter-from-memmap_alloc.patch added to mm-new branch
Message-Id: <20260915042236.E173F1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove unused exact_nid parameter from memmap_alloc()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-unused-exact_nid-parameter-from-memmap_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unused-exact_nid-parameter-from-memmap_alloc.patch

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
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm: remove unused exact_nid parameter from memmap_alloc()
Date: Mon, 14 Sep 2026 13:51:30 +0800

Commit ffe55393137c ("mm/sparse: remove sparse buffer pre-allocation
mechanism") removed sparse_buffer_init(), which was the only caller of
memmap_alloc() that passed true for exact_nid.

All remaining callers pass false, leaving the exact-node allocation branch
unreachable.  Remove the exact_nid parameter and unconditionally use
memblock_alloc_try_nid_raw().

This has no functional impact.

Link: https://lore.kernel.org/20260914055130.44543-1-kaitao.cheng@linux.dev
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/mm_init.c        |   14 ++++----------
 mm/mm_init.h        |    4 ++--
 mm/sparse-vmemmap.c |    2 +-
 mm/sparse.c         |    2 +-
 4 files changed, 8 insertions(+), 14 deletions(-)

--- a/mm/mm_init.c~mm-remove-unused-exact_nid-parameter-from-memmap_alloc
+++ a/mm/mm_init.c
@@ -1606,7 +1606,7 @@ static void __init free_area_init_core(s
 }
 
 void __init *memmap_alloc(phys_addr_t size, phys_addr_t align,
-			  phys_addr_t min_addr, int nid, bool exact_nid)
+			  phys_addr_t min_addr, int nid)
 {
 	void *ptr;
 
@@ -1614,14 +1614,8 @@ void __init *memmap_alloc(phys_addr_t si
 	 * Kmemleak will explicitly scan mem_map by traversing all valid
 	 * `struct *page`,so memblock does not need to be added to the scan list.
 	 */
-	if (exact_nid)
-		ptr = memblock_alloc_exact_nid_raw(size, align, min_addr,
-						   MEMBLOCK_ALLOC_NOLEAKTRACE,
-						   nid);
-	else
-		ptr = memblock_alloc_try_nid_raw(size, align, min_addr,
-						 MEMBLOCK_ALLOC_NOLEAKTRACE,
-						 nid);
+	ptr = memblock_alloc_try_nid_raw(size, align, min_addr,
+					 MEMBLOCK_ALLOC_NOLEAKTRACE, nid);
 
 	if (ptr && size > 0)
 		page_init_poison(ptr, size);
@@ -1649,7 +1643,7 @@ static void __init alloc_node_mem_map(st
 	end = ALIGN(pgdat_end_pfn(pgdat), MAX_ORDER_NR_PAGES);
 	size =  (end - start) * sizeof(struct page);
 	map = memmap_alloc(size, SMP_CACHE_BYTES, MEMBLOCK_LOW_LIMIT,
-			   pgdat->node_id, false);
+			   pgdat->node_id);
 	if (!map)
 		panic("Failed to allocate %ld bytes for node %d memory map\n",
 		      size, pgdat->node_id);
--- a/mm/mm_init.h~mm-remove-unused-exact_nid-parameter-from-memmap_alloc
+++ a/mm/mm_init.h
@@ -31,8 +31,8 @@ static inline void clear_zone_contiguous
 
 void memblock_free_pages(unsigned long pfn, unsigned int order);
 
-void *memmap_alloc(phys_addr_t size, phys_addr_t align, phys_addr_t min_addr,
-		int nid, bool exact_nid);
+void *memmap_alloc(phys_addr_t size, phys_addr_t align,
+		   phys_addr_t min_addr, int nid);
 
 void memmap_init_range(unsigned long size, int nid, unsigned long zone,
 		unsigned long start_pfn, unsigned long zone_end_pfn,
--- a/mm/sparse.c~mm-remove-unused-exact_nid-parameter-from-memmap_alloc
+++ a/mm/sparse.c
@@ -215,7 +215,7 @@ struct page __init *__populate_section_m
 {
 	const unsigned long size = PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
 
-	return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), nid, false);
+	return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), nid);
 }
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
--- a/mm/sparse-vmemmap.c~mm-remove-unused-exact_nid-parameter-from-memmap_alloc
+++ a/mm/sparse-vmemmap.c
@@ -62,7 +62,7 @@ void __ref *vmemmap_alloc_block(unsigned
 		}
 		return NULL;
 	} else
-		return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), node, false);
+		return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), node);
 }
 
 static void * __meminit altmap_alloc_block_buf(unsigned long size,
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

mm-hugetlb-use-hugetlb_vmemmap_optimizable-in-boolean-contexts.patch
mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally.patch
nvdimm-pmem-remove-test_and_clear_pmem_poison.patch
mm-remove-unused-exact_nid-parameter-from-memmap_alloc.patch

