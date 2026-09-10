Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC8E379980
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 23:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789081255; cv=none; b=NHFyYVUBL6g1wENKnw4taZQVnq+bB+AQ3tTd7SaRL2yp1KDHHkRoUF44U7+SkmhLeSZjbmSBw/Y3xk6a2kIH2vXZ1OdHYKbV7ZmBU8OuuiXOscZNHGQXITPCFCCpf2B8CLMHZfggeR4IL4jhWGKC5KmmhHq5IF2cxVWOoV2Mmbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789081255; c=relaxed/simple;
	bh=KDZjJR9oMxakwGsYXK0Pvq5OH/z1QFKO3LIyuAwgnwc=;
	h=Date:To:From:Subject:Message-Id; b=MGuCCNmTuBeFj6bVsDO52fCV7CCGfYO+hIdND6yH1aa2q3MiDC6BYxP5XgJqYIYgvG5o7AjTQ/8VnKow5+rjn4BOGL9/EM9tuYu939v/Q80vHjsjea49R/+Ce8zOQEBY0Y3G+d6cWnV+kQYYMgx01aO9SzrEAvIqa10CoUQl9mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=16uSjw2b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="16uSjw2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994DA1F000FF;
	Thu, 10 Sep 2026 23:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789081253;
	bh=N3JTSkc+S0dwbRa5RToN4gJaC8BRTJehxDDpPXsgLYc=;
	h=Date:To:From:Subject;
	b=16uSjw2b1L7Wnv7sNqGonXJdLSyV//hVoeO6c8F1rcUTib2FqPz7boU9C8FT1qdIX
	 JL3sqBMC9B4pgZGgs7xQvQO91/d5E57+70R//N70heqdh5eFTCfE3rrek1aT885jIR
	 pYOeAsZ02uLmWfbtS4HvPQYyUXSD6dMhLPNPAqU4=
Date: Thu, 10 Sep 2026 16:00:53 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-sparse-inline-usemap-allocation-into-sparse_init_nid.patch removed from -mm tree
Message-Id: <20260910230053.994DA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: inline usemap allocation into sparse_init_nid()
has been removed from the -mm tree.  Its filename was
     mm-sparse-inline-usemap-allocation-into-sparse_init_nid.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse: inline usemap allocation into sparse_init_nid()
Date: Tue, 25 Aug 2026 16:46:03 +0800

After removing SPARSEMEM_VMEMMAP_PREINIT, sparse_init_nid() no longer
needs the transient sparse_usagebuf state and its helper wrappers.

Allocate the usemap buffer directly in sparse_init_nid(), pass it to
sparse_init_one_section(), and drop sparse_usage_init(),
sparse_usage_fini(), and sparse_init_early_section().

Link: https://lore.kernel.org/20260825084608.47437-13-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 --
 mm/sparse.c            |   46 +++++----------------------------------
 2 files changed, 7 insertions(+), 42 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-inline-usemap-allocation-into-sparse_init_nid
+++ a/include/linux/mmzone.h
@@ -2223,9 +2223,6 @@ static inline bool pfn_section_first_val
 }
 #endif
 
-void sparse_init_early_section(int nid, struct page *map, unsigned long pnum,
-			       unsigned long flags);
-
 #ifndef CONFIG_HAVE_ARCH_PFN_VALID
 /**
  * pfn_valid - check if there is a valid memory map entry for a PFN
--- a/mm/sparse.c~mm-sparse-inline-usemap-allocation-into-sparse_init_nid
+++ a/mm/sparse.c
@@ -235,42 +235,6 @@ void __weak __meminit vmemmap_populate_p
 {
 }
 
-static void *sparse_usagebuf __initdata;
-static void *sparse_usagebuf_end __initdata;
-
-/*
- * Helper function that is used for generic section initialization, and
- * can also be used by any hooks added above.
- */
-void __init sparse_init_early_section(int nid, struct page *map,
-				      unsigned long pnum, unsigned long flags)
-{
-	BUG_ON(!sparse_usagebuf || sparse_usagebuf >= sparse_usagebuf_end);
-	sparse_init_one_section(__nr_to_section(pnum), pnum, map,
-			sparse_usagebuf, SECTION_IS_EARLY | flags);
-	sparse_usagebuf = (void *)sparse_usagebuf + mem_section_usage_size();
-}
-
-static int __init sparse_usage_init(int nid, unsigned long map_count)
-{
-	unsigned long size;
-
-	size = mem_section_usage_size() * map_count;
-	sparse_usagebuf = memblock_alloc_node(size, SMP_CACHE_BYTES, nid);
-	if (!sparse_usagebuf) {
-		sparse_usagebuf_end = NULL;
-		return -ENOMEM;
-	}
-
-	sparse_usagebuf_end = sparse_usagebuf + size;
-	return 0;
-}
-
-static void __init sparse_usage_fini(void)
-{
-	sparse_usagebuf = sparse_usagebuf_end = NULL;
-}
-
 /*
  * Initialize sparse on a specific node. The node spans [pnum_begin, pnum_end)
  * And number of present sections in this node is map_count.
@@ -280,8 +244,11 @@ static void __init sparse_init_nid(int n
 				   unsigned long map_count)
 {
 	unsigned long pnum;
+	struct mem_section_usage *usage;
 
-	if (sparse_usage_init(nid, map_count))
+	usage = memblock_alloc_node(map_count * mem_section_usage_size(),
+				    SMP_CACHE_BYTES, nid);
+	if (!usage)
 		panic("Failed to allocate usemap for node %d\n", nid);
 
 	for_each_present_section_nr(pnum_begin, pnum) {
@@ -297,9 +264,10 @@ static void __init sparse_init_nid(int n
 			panic("Failed to allocate memmap for section %lu\n", pnum);
 		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
 							       NULL, NULL));
-		sparse_init_early_section(nid, map, pnum, 0);
+		sparse_init_one_section(__nr_to_section(pnum), pnum, map, usage,
+					SECTION_IS_EARLY);
+		usage = (void *)usage + mem_section_usage_size();
 	}
-	sparse_usage_fini();
 }
 
 /*
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-sparse-remove-section_map_size.patch
mm-hugetlb-remove-huge_bootmem_hvo.patch
mm-hugetlb-remove-huge_bootmem_cma.patch
mm-hugetlb-localize-struct-huge_bootmem_page.patch
mm-hugetlb-localize-huge_bootmem_zones_valid.patch
mm-sparse-vmemmap-introduce-config_sparsemem_vmemmap_optimization.patch
mm-sparse-vmemmap-factor-out-shared-vmemmap-tail-page-allocation.patch
mm-sparse-vmemmap-open-code-init_compound_tail.patch
mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-section-orders.patch
mm-sparse-vmemmap-set-section-order-for-device-dax.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-move-hvo-helpers-to-a-public-header.patch
powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation.patch
mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch
documentation-mm-update-dax-vmemmap-deduplication-docs.patch

