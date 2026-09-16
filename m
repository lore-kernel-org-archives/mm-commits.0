Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB4F191F94
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 01:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789521625; cv=none; b=Wc0gVDDOgyKM+xYbeAsVC+kjbqfyMOsL6syR81p821nO0ayV4Pw12ANg0Hayico0dgv1coQbnVPe4QbeuVUmhfNhTiO2kMk/igsm1OXvbbWJ/+jCU5LbCpRuZKrzIMWrTN0pGDreHL0lePiWA9C83vrpZvsH3rmXoKNiPk0SYHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789521625; c=relaxed/simple;
	bh=DJ/IODiU3EvnZP6G9aipF91j3wC8XttiaUxnQ+TCYv8=;
	h=Date:To:From:Subject:Message-Id; b=NpW1ds4Co+aItDAGKV2dID+rhTf0LH323ZaWUd8htGIiJNWjB40J2kjmJbjNZuqFD95C9yeEkEUaoN3w+G9scVLvvofUqGIcbFiK8QN8Z+G7St/v9if2MnU9a20F8sGQqHuH0uqOQzIg0vDHFet9XnPiWpLBgmJFqwV4jDzIvjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x2kbV1/t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x2kbV1/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031481F000FF;
	Wed, 16 Sep 2026 01:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789521624;
	bh=aD1UiUOTUkQIxxacOYPd9t7ZrScqRjbxDWGxKYDU0qo=;
	h=Date:To:From:Subject;
	b=x2kbV1/tuL5ZblU+Kaeu/lljtaLYeshDN5j5Mh3F4xVLAyeUBJwcpJFQDgcoM5FAk
	 XbeUlAFUF50Jf+W6QKw9rmST1P85pazpJBPylbJjTzFqNKeE7BPo/YZqtxpRq7qDLk
	 cJegxbF6kGUm1TSzwdHk614gbwbJ8d4zaGc5g3R8=
Date: Tue, 15 Sep 2026 18:20:23 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-remove-unused-exact_nid-parameter-from-memmap_alloc.patch removed from -mm tree
Message-Id: <20260916012024.031481F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove unused exact_nid parameter from memmap_alloc()
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-exact_nid-parameter-from-memmap_alloc.patch

This patch was dropped because an updated version will be issued

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

