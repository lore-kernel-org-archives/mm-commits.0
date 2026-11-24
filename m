Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795514619;
	b=VyoXeXrj2VpxzXZgySPT5CiiDV5+HIbB2m9Tr+sb2pM5f9WhZyEHR8n1vToAHtX1ycme
	 Pks6PDQ7gvaOiVuvuLCUqSp3tC4C71oP9UN53nNvjlFhrgatQJW5D1EIqNzM3eRziSGwl
	 L0qNAS5CXdZZF+hhXHxRYa6y0qNi/5D8Jih9+lmrsZxVAgdYfXXz8FLpnb+FyDfPL7Piv
	 5D0aYSG3w2AjO8XFM5HjdMejsP9sU5JKmm27b+fri+UmyeV4kf89nBHqXufgL4m8trece
	 Pqw7VyIfSs2OTQgb6JSeGqL4TUM7v+eItBXz2rIxj5ZpV4laDIvct05zHy6GSkYPkCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795514619;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=eXf+e1ciPgf1bBffXnNnaSGSp1TmUBCcFB5/nfTktZI=;
	b=NgNrWvMlPm/tIFMFblhT4RQhj2ACN63khCCWU37OKz4FlKkGXhS44s+FVdpC5Yk7Fb9W
	 vS5D/s2mpGpWHRrSNp4FSzsapvROovlwtcGVt08EeRY1mZwBoAlKHCwmf3NiK3BwzNy7G
	 3Tm0f+vbuGIzkgykwX1yIHL2DbvKmF5su/dKfQExWqKYsEgdEFzDKAfdei9q+batkRsvQ
	 Ju7QLyKdlyRjQRAAXglli10xJOvw/PgEa5epSZsZvgLejEKlBQyassm59P89Piwrdwr03
	 spu7Y6gIRYYupkD2Ev06XASh67jqaP1Ha6q17PXqrJy9E67IVFlUomZLCBqiNhBZGYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RqdoLFDG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56E2606A322
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 10:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RqdoLFDG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009BB1F000C4;
	Tue, 24 Nov 2026 10:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795514619;
	bh=eXf+e1ciPgf1bBffXnNnaSGSp1TmUBCcFB5/nfTktZI=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=RqdoLFDGWrqtUy1wbGbhwniesbIreeHbtmJEetMgOkFOkFbuxXECGbhenFthubT+i
	 5JAPThbnHmT7BWd7KdlpQK0nFHhBuwbFIhb4tWRf3GfBmmyoA2TQ5uZUmZorEXyLCA
	 DCd7RjN+zZ585utZo2ltmniiW/+Vk7jfESIjCJCw=
Date: Tue, 24 Nov 2026 02:03:38 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,
	surenb@google.com,smostafa@google.com,skhan@linuxfoundation.org,
	rppt@kernel.org,rdunlap@infradead.org,praan@google.com,mhocko@suse.com,
	liam@infradead.org,ketan.kishore@oss.qualcomm.com,joerg.roedel@amd.com,
	hannes@cmpxchg.org,glider@google.com,elver@google.com,ekffu200098@gmail.com,
	dvyukov@google.com,david@kernel.org,corbet@lwn.net,chris@chrisdown.name,
	brendan.jackman@linux.dev,baolu.lu@linux.intel.com,songmuchun@bytedance.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261119065812.89959-6-songmuchun@bytedance.com>
References: <20261119065812.89959-6-songmuchun@bytedance.com>
Subject: + mm-page_ext-allocate-page-extensions-early-for-sparsemem.patch added to mm-new branch
Message-Id: <20261124100339.009BB1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/page_ext: allocate page extensions early for SPARSEMEM
has been added to the -mm mm-new branch.  Its filename is
     mm-page_ext-allocate-page-extensions-early-for-sparsemem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_ext-allocate-page-extensions-early-for-sparsemem.patch

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
Subject: mm/page_ext: allocate page extensions early for SPARSEMEM
Date: Thu, 19 Nov 2026 14:58:10 +0800

KMSAN needs page extensions when kmsan_init_shadow() installs per-page
metadata, before memblock_free_all() releases memory to the buddy
allocator.  FLATMEM makes page extensions available by this point,
whereas SPARSEMEM initializes them later in boot.

Allocate boot-time SPARSEMEM page extensions from memblock to match
FLATMEM's initialization timing.  This gives early clients the same
page_ext availability guarantee across both memory models, while runtime
memory hotplug continues to use vmalloc.

Link: https://patch.msgid.link/20261119065812.89959-6-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Pranjal Shrivastava <praan@google.com>
Cc: Ketan <ketan.kishore@oss.qualcomm.com>
Cc: Mostafa Saleh <smostafa@google.com>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>

 include/linux/page_ext.h |    9 --
 mm/mm_init.c             |    4 -
 mm/page_ext.c            |  117 ++++++++++++++++++-------------------
 3 files changed, 59 insertions(+), 71 deletions(-)

--- a/include/linux/page_ext.h~mm-page_ext-allocate-page-extensions-early-for-sparsemem
+++ a/include/linux/page_ext.h
@@ -61,12 +61,10 @@ static inline bool early_page_ext_enable
 	return early_page_ext;
 }
 
-#ifdef CONFIG_SPARSEMEM
-static inline void page_ext_alloc(void)
-{
-}
+void page_ext_alloc(void);
 void page_ext_init(void);
 
+#ifdef CONFIG_SPARSEMEM
 static inline bool page_ext_iter_next_fast_possible(unsigned long next_pfn)
 {
 	/*
@@ -76,9 +74,6 @@ static inline bool page_ext_iter_next_fa
 	return next_pfn % PAGES_PER_SECTION;
 }
 #else
-void page_ext_alloc(void);
-void page_ext_init(void);
-
 static inline bool page_ext_iter_next_fast_possible(unsigned long next_pfn)
 {
 	return true;
--- a/mm/mm_init.c~mm-page_ext-allocate-page-extensions-early-for-sparsemem
+++ a/mm/mm_init.c
@@ -2644,10 +2644,6 @@ void __init mm_core_init(void)
 	build_all_zonelists(NULL);
 	page_alloc_init_cpuhp();
 	alloc_tag_sec_init();
-	/*
-	 * page_ext requires contiguous pages,
-	 * bigger than MAX_PAGE_ORDER unless SPARSEMEM.
-	 */
 	page_ext_alloc();
 	mem_debugging_and_hardening_init();
 	kfence_alloc_pool_and_metadata();
--- a/mm/page_ext.c~mm-page_ext-allocate-page-extensions-early-for-sparsemem
+++ a/mm/page_ext.c
@@ -12,6 +12,7 @@
 #include <linux/rcupdate.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/iommu-debug-pagealloc.h>
+#include <linux/slab.h>
 
 /*
  * struct page extension
@@ -185,11 +186,6 @@ static inline struct page_ext *get_entry
 }
 
 #ifndef CONFIG_SPARSEMEM
-void __init page_ext_init(void)
-{
-	invoke_init_callbacks();
-}
-
 static struct page_ext *lookup_page_ext(const struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
@@ -243,24 +239,16 @@ static int __init alloc_node_page_ext(in
 	return 0;
 }
 
-void __init page_ext_alloc(void)
+static int __init __page_ext_alloc(void)
 {
-	int nid, fail;
-
-	if (!invoke_need_callbacks())
-		return;
+	int nid;
 
-	for_each_online_node(nid)  {
-		fail = alloc_node_page_ext(nid);
-		if (fail)
-			goto fail;
+	for_each_online_node(nid) {
+		if (alloc_node_page_ext(nid))
+			return -ENOMEM;
 	}
-	pr_info("allocated %ld bytes of page_ext\n", total_usage);
-	return;
 
-fail:
-	pr_crit("allocation of page_ext failed.\n");
-	panic("Out of memory");
+	return 0;
 }
 
 #else /* CONFIG_SPARSEMEM */
@@ -287,10 +275,18 @@ static struct page_ext *lookup_page_ext(
 	return get_entry(page_ext, pfn);
 }
 
-static void *__meminit alloc_page_ext(size_t size, int nid)
+static __ref void *alloc_page_ext(size_t size, int nid)
 {
 	void *addr;
 
+	if (!slab_is_available()) {
+		addr = memblock_alloc_try_nid(size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS),
+					      MEMBLOCK_ALLOC_ACCESSIBLE, nid);
+		if (addr)
+			memmap_boot_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
+		return addr;
+	}
+
 	addr = vzalloc_node(size, nid);
 	if (addr)
 		memmap_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
@@ -309,7 +305,7 @@ static int __meminit init_section_page_e
 	if (section->page_ext)
 		return 0;
 
-	table_size = page_ext_size * PAGES_PER_SECTION;
+	table_size = PAGE_ALIGN(page_ext_size * PAGES_PER_SECTION);
 	base = alloc_page_ext(table_size, nid);
 
 	/*
@@ -336,11 +332,19 @@ static int __meminit init_section_page_e
 
 static void free_page_ext(void *addr)
 {
-	size_t table_size;
+	size_t table_size = PAGE_ALIGN(page_ext_size * PAGES_PER_SECTION);
+	long nr_pages = table_size / PAGE_SIZE;
+
+	if (is_vmalloc_addr(addr)) {
+		memmap_pages_add(-nr_pages);
+		vfree(addr);
+		return;
+	}
 
-	table_size = page_ext_size * PAGES_PER_SECTION;
-	memmap_pages_add(-1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
-	vfree(addr);
+	VM_WARN_ON_ONCE(!PageReserved(virt_to_page(addr)));
+	memmap_boot_pages_add(-nr_pages);
+	kmemleak_free_part_phys(__pa(addr), table_size);
+	free_reserved_area(addr, addr + table_size, -1, NULL);
 }
 
 static void __free_page_ext(unsigned long pfn)
@@ -454,52 +458,45 @@ static int __meminit page_ext_callback(s
 	return notifier_from_errno(ret);
 }
 
-void __init page_ext_init(void)
+static int __init __page_ext_alloc(void)
 {
-	unsigned long pfn;
-	int nid;
-
-	if (!invoke_need_callbacks())
-		return;
-
-	for_each_node_state(nid, N_MEMORY) {
-		unsigned long start_pfn, end_pfn;
-
-		start_pfn = node_start_pfn(nid);
-		end_pfn = node_end_pfn(nid);
-		/*
-		 * start_pfn and end_pfn may not be aligned to SECTION and the
-		 * page->flags of out of node pages are not initialized.  So we
-		 * scan [start_pfn, the biggest section's pfn < end_pfn) here.
-		 */
-		for (pfn = start_pfn; pfn < end_pfn;
-			pfn = ALIGN(pfn + 1, PAGES_PER_SECTION)) {
+	unsigned long start, end, pfn;
+	int i, nid;
 
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid) {
+		for (pfn = start; pfn < end; pfn = SECTION_ALIGN_UP(pfn + 1)) {
 			if (!pfn_valid(pfn))
 				continue;
-			/*
-			 * Nodes's pfns can be overlapping.
-			 * We know some arch can have a nodes layout such as
-			 * -------------pfn-------------->
-			 * N0 | N1 | N2 | N0 | N1 | N2|....
-			 */
-			if (pfn_to_nid(pfn) != nid)
-				continue;
 			if (init_section_page_ext(pfn, nid))
-				goto oom;
-			cond_resched();
+				return -ENOMEM;
 		}
 	}
-	hotplug_memory_notifier(page_ext_callback, DEFAULT_CALLBACK_PRI);
-	pr_info("allocated %ld bytes of page_ext\n", total_usage);
-	invoke_init_callbacks();
-	return;
 
-oom:
-	panic("Out of memory");
+	return 0;
+}
+
+#endif
+
+void __init page_ext_alloc(void)
+{
+	if (!invoke_need_callbacks())
+		return;
+	if (__page_ext_alloc())
+		panic("Out of memory");
+
+	pr_info("allocated %ld bytes of page_ext\n", total_usage);
 }
 
+void __init page_ext_init(void)
+{
+	if (!page_ext_size)
+		return;
+
+#ifdef CONFIG_SPARSEMEM
+	hotplug_memory_notifier(page_ext_callback, DEFAULT_CALLBACK_PRI);
 #endif
+	invoke_init_callbacks();
+}
 
 /**
  * page_ext_lookup() - Lookup a page extension for a PFN.
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
kmsan-encapsulate-per-page-metadata-access.patch
mm-page_ext-fix-client-data-alignment.patch
mm-page_ext-always-use-vmalloc-for-section-page-extensions.patch
mm-page_ext-use-common-allocation-and-initialization-entry-points.patch
mm-page_ext-allocate-page-extensions-early-for-sparsemem.patch
mm-page_ext-inline-unchecked-page-extension-lookup.patch
kmsan-fix-metadata-loss-during-hugetlb-struct-page-reinitialization.patch

