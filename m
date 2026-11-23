Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795403045;
	b=1tL5vCJgOl8KFrt/6i3AUspEEonNkjIAE6CpsQwDcQH8iN4yi75BgR+H/7ckh09VPgCu
	 Vblz9TU1nBX6tiTzA+M1nQ8MYcjqHjDvuZvuMscSdOH1iwBQ2J+TLiBzlqwuxcLjQCy6M
	 ERmdX9Sgbhhra1mw/XH/oYsi5OZ7s9r75qd5SrjKPKfg1ClgMhjMNkZmDe2Q1BQ1BF0XG
	 epVGFSLl1hNeBPuhVU25G0SyrtvbZq2wmrBPgz0BZQH9gPu0hMhKT8pXbEw1pRb0ObqT/
	 Kq/HH+1e8KVq3tkRykxN5T8O4bd8BKhh5lrAKIoOCSiz/JMqA1CqfjA1cuAii6dHFRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795403045;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=v41/m8sWU1L6tF6xQxqey5XuUtmgfOQuSsDSbgLpX24=;
	b=seBftYaWmxBmwA46ZKSa7WUrnyrl2Dziuvf+uc/GXL5mvWxiDdrBDwH5Z38Eu8MjGAHW
	 /wqPFxGCR24p1Ak/7YSbOS7xQgz+Wlz48CC13V0Eb95Qy3TewZeT+UZ/eY/B3GsFr3cki
	 pdBDm4ZZ+rUIoSm8rhyTSageMCZiLfZoHOnnKLCNerpuT1pN2fo9eNEwYTuWTncc8pX19
	 sP3KWSOMPbnQkjVYPPDEuwhHpCBsK1AsG5l01AIztDN5NVPHzj3MNWigTcOMnaeIU7LUq
	 KZO7v0uOinoy3GmIduxKsG//9GPeu1ABbVlqz7n03KhFC0rD2iLFZn5KwuenOd/yysQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FSBFhV39;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CBB606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 03:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FSBFhV39
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4ABE1F000CF;
	Mon, 23 Nov 2026 03:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795403045;
	bh=v41/m8sWU1L6tF6xQxqey5XuUtmgfOQuSsDSbgLpX24=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=FSBFhV391TYUI4l2CdzkpmLeN0nsZaSgcWIi3dlqaLdys/vJonT8bPfo0hjtKLFZI
	 fEufPaJ8DebjC7XYdqqumheVQkePOzlWuRpXDXoT03hXme4Lzync2at5bF/MTi1gIM
	 mLD7W5hTF4KvB33+dZ/7Tqo4a28STe8cWg3UtWLA=
Date: Sun, 22 Nov 2026 19:04:04 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,
	ljs@kernel.org,lizhe.67@bytedance.com,liam@infradead.org,
	lance.yang@linux.dev,jthoughton@google.com,david@kernel.org,
	balbirs@nvidia.com,apopple@nvidia.com,songmuchun@bytedance.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261120100856.16929-3-songmuchun@bytedance.com>
References: <20261120100856.16929-3-songmuchun@bytedance.com>
Subject: + mm-mm_init-factor-out-common-struct-page-initialization.patch added to mm-new branch
Message-Id: <20261123030404.D4ABE1F000CF@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mm_init: factor out common struct page initialization
has been added to the -mm mm-new branch.  Its filename is
     mm-mm_init-factor-out-common-struct-page-initialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-factor-out-common-struct-page-initialization.patch

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
Subject: mm/mm_init: factor out common struct page initialization
Date: Fri, 20 Nov 2026 18:08:47 +0800

Several struct page fields have the same initial values for every page in
a zone. __init_single_page() initializes this state as part of its
per-page setup, while the shared vmemmap tail path open-codes only a
subset.

Factor the PFN-independent state into memmap_init_page() and use it for
both regular and shared tail struct pages. Keep section-, PFN- and
instance-specific initialization in __init_single_page().

This also initializes the last cpupid and KASAN tag for shared tail
struct pages consistently with regular struct pages. Since
memmap_init_page() marks ZONE_DEVICE pages reserved, remove the redundant
update from the memory hotplug path.

Link: https://patch.msgid.link/20261120100856.16929-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>

 include/linux/mm.h  |    8 --------
 mm/mm_init.c        |   37 +++++++++++++++++++++----------------
 mm/mm_init.h        |    1 +
 mm/sparse-vmemmap.c |    7 +------
 4 files changed, 23 insertions(+), 30 deletions(-)

--- a/include/linux/mm.h~mm-mm_init-factor-out-common-struct-page-initialization
+++ a/include/linux/mm.h
@@ -3096,14 +3096,6 @@ static inline void set_page_node(struct
 	page->flags.f |= (node & NODES_MASK) << NODES_PGSHIFT;
 }
 
-static inline void set_page_links(struct page *page, enum zone_type zone,
-	unsigned long node, unsigned long pfn)
-{
-	set_page_zone(page, zone);
-	set_page_node(page, node);
-	set_page_section_from_pfn(page, pfn);
-}
-
 /**
  * folio_nr_pages - The number of pages in the folio.
  * @folio: The folio.
--- a/mm/mm_init.c~mm-mm_init-factor-out-common-struct-page-initialization
+++ a/mm/mm_init.c
@@ -602,15 +602,27 @@ static inline void vmemmap_optimization_
 			page_zone_id(page));
 }
 
-void __meminit __init_single_page(struct page *page, unsigned long pfn,
-				unsigned long zone, int nid)
+/* Initialize PFN-independent fields common to pages in the same zone. */
+void memmap_init_page(struct page *page, enum zone_type zone, int nid)
 {
 	mm_zero_struct_page(page);
-	set_page_links(page, zone, nid, pfn);
-	init_page_count(page);
-	atomic_set(&page->_mapcount, -1);
+	set_page_zone(page, zone);
+	set_page_node(page, nid);
 	page_cpupid_reset_last(page);
 	page_kasan_tag_reset(page);
+	atomic_set(&page->_mapcount, -1);
+#ifdef CONFIG_ZONE_DEVICE
+	if (zone == ZONE_DEVICE)
+		__SetPageReserved(page);
+#endif
+}
+
+void __meminit __init_single_page(struct page *page, unsigned long pfn,
+		unsigned long zone, int nid)
+{
+	memmap_init_page(page, zone, nid);
+	set_page_section_from_pfn(page, pfn);
+	init_page_count(page);
 
 	INIT_LIST_HEAD(&page->lru);
 #ifdef WANT_PAGE_VIRTUAL
@@ -891,11 +903,11 @@ void __meminit memmap_init_range(unsigne
 {
 	unsigned long pfn, end_pfn = start_pfn + size;
 	struct page *page;
+	const struct zone *z = &NODE_DATA(nid)->node_zones[zone];
 
 	if (highest_memmap_pfn < end_pfn - 1)
 		highest_memmap_pfn = end_pfn - 1;
 
-#ifdef CONFIG_ZONE_DEVICE
 	/*
 	 * Honor reservation requested by the driver for this ZONE_DEVICE
 	 * memory. We limit the total number of pages to initialize to just
@@ -903,7 +915,7 @@ void __meminit memmap_init_range(unsigne
 	 * ZONE_DEVICE page initialization until after we have released
 	 * the hotplug lock.
 	 */
-	if (zone == ZONE_DEVICE) {
+	if (zone_is_zone_device(z)) {
 		if (!altmap)
 			return;
 
@@ -911,7 +923,6 @@ void __meminit memmap_init_range(unsigne
 			start_pfn += altmap->reserve;
 		end_pfn = altmap->base_pfn + vmem_altmap_offset(altmap);
 	}
-#endif
 
 	for (pfn = start_pfn; pfn < end_pfn; ) {
 		const unsigned int order = pfn_to_section_compound_order(pfn);
@@ -938,14 +949,8 @@ void __meminit memmap_init_range(unsigne
 
 		page = pfn_to_page(pfn);
 		__init_single_page(page, pfn, zone, nid);
-		if (context == MEMINIT_HOTPLUG) {
-#ifdef CONFIG_ZONE_DEVICE
-			if (zone == ZONE_DEVICE)
-				__SetPageReserved(page);
-			else
-#endif
-				__SetPageOffline(page);
-		}
+		if (context == MEMINIT_HOTPLUG && !zone_is_zone_device(z))
+			__SetPageOffline(page);
 
 		if (pageblock_aligned(pfn))
 			cond_resched();
--- a/mm/mm_init.h~mm-mm_init-factor-out-common-struct-page-initialization
+++ a/mm/mm_init.h
@@ -109,6 +109,7 @@ extern bool mirrored_kernelcore;
 bool memblock_has_mirror(void);
 void memblock_free_all(void);
 
+void memmap_init_page(struct page *page, enum zone_type zone, int nid);
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid);
 
--- a/mm/sparse-vmemmap.c~mm-mm_init-factor-out-common-struct-page-initialization
+++ a/mm/sparse-vmemmap.c
@@ -212,12 +212,7 @@ struct page __ref *vmemmap_shared_tail_p
 
 	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++) {
 		page = (struct page *)addr + i;
-		mm_zero_struct_page(page);
-		atomic_set(&page->_mapcount, -1);
-		set_page_node(page, zone_to_nid(zone));
-		set_page_zone(page, zone_idx(zone));
-		if (zone_is_zone_device(zone))
-			__SetPageReserved(page);
+		memmap_init_page(page, zone_idx(zone), zone_to_nid(zone));
 		prep_compound_tail(page, NULL, order);
 	}
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

powerpc-mm-make-vmemmap_populate_compound_pages-static.patch
powerpc-mm-drop-powerpc-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis.patch
mm-hugetlb_vmemmap-fix-hwpoison-state-races-during-optimization.patch
mm-hugetlb_vmemmap-fix-pmd-split-tlb-flush-race.patch
mm-hugetlb_vmemmap-fix-deadlock-during-pmd-split.patch
mm-list_lru-fix-potential-infinite-loop-on-xa-node-allocation-failure.patch
mm-mm_init-verify-zones-for-template-initialized-pages.patch
mm-mm_init-factor-out-common-struct-page-initialization.patch
mm-mm_init-simplify-zone-device-page-initialization.patch
mm-mm_init-factor-out-compound-page-initialization.patch
mm-hugetlb-drop-boot-time-hvo-handling-for-gigantic-folios.patch
mm-hugetlb-initialize-all-struct-pages-for-bootmem-hugepages.patch
mm-hugetlb-use-common-compound-page-initialization-helper.patch
mm-mm_init-make-__init_single_page-static.patch
mm-cma-centralize-cma-pageblock-initialization.patch
mm-cma-localize-init_cma_pageblock-to-cmac.patch
mm-mm_init-move-pageblock-migratetype-init-to-memmap-helpers.patch

