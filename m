Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795514623;
	b=NI68oHD/Wvn73EN8HajxwrrKAjU+iRi4ZGPROWbN7g7Y96hcGGWmKKZYQdJnn6p7IvDF
	 tDubbMvVAXCWX5BtNNzB0J68p5EEUlXhlOcAFBoOlthfdYkE3+2uz8U3+dz8xtDEAk5n4
	 ZbixIVuicCq58hSTJmaxH4APty2Qg61Qvs03a83v5frXWINUaWN2TfwPKNqZvTscXo8QQ
	 yn69+JfTaDDwfs3Ja9w/eeRk71um9AyWfJH2BEgVxvftUmIsCH0E4jc3JUxjja36bD0gL
	 la3qMvR5YwW1TrmJgkJGUZpc5ZSWtJuMFqNGNj0WalW7JIuSZ3JvvG2R95WbTzmf4Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795514623;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=nvILDKG7w98l35/j/eXutNdHf6HOJkiNecAJdcvTEjQ=;
	b=asa42TXOrHVv+vbGNw0Gok7nAcSdS84X4xXIfEcQjAmySV7+w+7sz5183KcBb2VO/5fG
	 1lYasnq0J/vmjXS6vH5U2oZv2cnYqQjSGBSZu+sqSVxrHZDIX8mcftcTd6l/pA71ml5hZ
	 FH68hPSmIHzjMWLfkPDoR7CmMKO9WHBwQ8IRerHgTZ1SvbS95JgiHRVXwWvHLBqLhpZo5
	 iX1FmCARywE7LnV+RxIfoqpgMam7aShyzaiToX+U7/7kEe5JAHVB3C7z2vLMU8tdVLhhk
	 pWcAmjvgT3EnRWnchjDNcwOYmUaq8x5bmJ4Q/typcJztbeeKn4GL9nk0qfQCnATfmfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1XJ2UxQZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569D2606A682
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 10:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1XJ2UxQZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4D11F000CF;
	Tue, 24 Nov 2026 10:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795514622;
	bh=nvILDKG7w98l35/j/eXutNdHf6HOJkiNecAJdcvTEjQ=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=1XJ2UxQZ9o7Z6GHGicx0GGlMhgqIZ32kh+LwMEFTvxWmk0ypxWPDiG56T7ADDPQHH
	 dsmfTyJLnfhCqudg0jvjgDGjBk4YSkoT4Qd5X3U7ufzB6MhozPdR9MSry8lmx7I7Ht
	 Pq0Hj2Da8VoDQMX4hhz9iG88mzCelelFzqu/1czU=
Date: Tue, 24 Nov 2026 02:03:42 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,
	surenb@google.com,smostafa@google.com,skhan@linuxfoundation.org,
	rppt@kernel.org,rdunlap@infradead.org,praan@google.com,mhocko@suse.com,
	liam@infradead.org,ketan.kishore@oss.qualcomm.com,joerg.roedel@amd.com,
	hannes@cmpxchg.org,glider@google.com,elver@google.com,ekffu200098@gmail.com,
	dvyukov@google.com,david@kernel.org,corbet@lwn.net,chris@chrisdown.name,
	brendan.jackman@linux.dev,baolu.lu@linux.intel.com,songmuchun@bytedance.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261119065812.89959-7-songmuchun@bytedance.com>
References: <20261119065812.89959-7-songmuchun@bytedance.com>
Subject: + mm-page_ext-inline-unchecked-page-extension-lookup.patch added to mm-new branch
Message-Id: <20261124100342.CC4D11F000CF@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/page_ext: inline unchecked page extension lookup
has been added to the -mm mm-new branch.  Its filename is
     mm-page_ext-inline-unchecked-page-extension-lookup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_ext-inline-unchecked-page-extension-lookup.patch

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
Subject: mm/page_ext: inline unchecked page extension lookup
Date: Thu, 19 Nov 2026 14:58:11 +0800

The KMSAN runtime needs an unchecked page extension lookup that can be
inlined into its uninstrumented compilation unit while page_ext.c remains
instrumented.

Provide an inline lookup for this use case while keeping the existing RCU
checks for other callers.

Link: https://patch.msgid.link/20261119065812.89959-7-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
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

 include/linux/page_ext.h |   46 ++++++++++++++++++++++++++++
 mm/page_ext.c            |   60 ++-----------------------------------
 2 files changed, 50 insertions(+), 56 deletions(-)

--- a/include/linux/page_ext.h~mm-page_ext-inline-unchecked-page-extension-lookup
+++ a/include/linux/page_ext.h
@@ -64,7 +64,14 @@ static inline bool early_page_ext_enable
 void page_ext_alloc(void);
 void page_ext_init(void);
 
+static __always_inline struct page_ext *page_ext_entry(void *base, unsigned long index)
+{
+	return base + page_ext_size * index;
+}
+
 #ifdef CONFIG_SPARSEMEM
+#define PAGE_EXT_INVALID	0x1
+
 static inline bool page_ext_iter_next_fast_possible(unsigned long next_pfn)
 {
 	/*
@@ -73,11 +80,50 @@ static inline bool page_ext_iter_next_fa
 	 */
 	return next_pfn % PAGES_PER_SECTION;
 }
+
+static __always_inline bool page_ext_invalid(struct page_ext *page_ext)
+{
+	return !page_ext || (((unsigned long)page_ext & PAGE_EXT_INVALID) == PAGE_EXT_INVALID);
+}
+
+static __always_inline struct page_ext *__page_ext_lookup(unsigned long pfn)
+{
+	struct mem_section *section = __pfn_to_section(pfn);
+	struct page_ext *page_ext = READ_ONCE(section->page_ext);
+
+	/*
+	 * The sanity checks the page allocator does upon freeing a page can
+	 * reach here before the page_ext arrays are allocated when feeding a
+	 * range of pages to the allocator for the first time during bootup or
+	 * memory hotplug.
+	 */
+	if (page_ext_invalid(page_ext))
+		return NULL;
+	return page_ext_entry(page_ext, pfn);
+}
 #else
 static inline bool page_ext_iter_next_fast_possible(unsigned long next_pfn)
 {
 	return true;
 }
+
+static __always_inline struct page_ext *__page_ext_lookup(unsigned long pfn)
+{
+	int nid = pfn_to_nid(pfn);
+	struct page_ext *base = NODE_DATA(nid)->node_page_ext;
+	unsigned long index;
+
+	/*
+	 * The sanity checks the page allocator does upon freeing a page can
+	 * reach here before the page_ext arrays are allocated when feeding a
+	 * range of pages to the allocator for the first time during bootup or
+	 * memory hotplug.
+	 */
+	if (unlikely(!base))
+		return NULL;
+	index = pfn - round_down(node_start_pfn(nid), MAX_ORDER_NR_PAGES);
+	return page_ext_entry(base, index);
+}
 #endif
 
 extern struct page_ext *page_ext_get(const struct page *page);
--- a/mm/page_ext.c~mm-page_ext-inline-unchecked-page-extension-lookup
+++ a/mm/page_ext.c
@@ -63,10 +63,6 @@
  * can utilize this callback to initialize the state of it correctly.
  */
 
-#ifdef CONFIG_SPARSEMEM
-#define PAGE_EXT_INVALID       (0x1)
-#endif
-
 #if defined(CONFIG_PAGE_IDLE_FLAG) && !defined(CONFIG_64BIT)
 static bool need_page_idle(void)
 {
@@ -180,33 +176,7 @@ static void __init invoke_init_callbacks
 	}
 }
 
-static inline struct page_ext *get_entry(void *base, unsigned long index)
-{
-	return base + page_ext_size * index;
-}
-
 #ifndef CONFIG_SPARSEMEM
-static struct page_ext *lookup_page_ext(const struct page *page)
-{
-	unsigned long pfn = page_to_pfn(page);
-	unsigned long index;
-	struct page_ext *base;
-
-	WARN_ON_ONCE(!rcu_read_lock_held());
-	base = NODE_DATA(page_to_nid(page))->node_page_ext;
-	/*
-	 * The sanity checks the page allocator does upon freeing a
-	 * page can reach here before the page_ext arrays are
-	 * allocated when feeding a range of pages to the allocator
-	 * for the first time during bootup or memory hotplug.
-	 */
-	if (unlikely(!base))
-		return NULL;
-	index = pfn - round_down(node_start_pfn(page_to_nid(page)),
-					MAX_ORDER_NR_PAGES);
-	return get_entry(base, index);
-}
-
 static int __init alloc_node_page_ext(int nid)
 {
 	struct page_ext *base;
@@ -252,29 +222,6 @@ static int __init __page_ext_alloc(void)
 }
 
 #else /* CONFIG_SPARSEMEM */
-static bool page_ext_invalid(struct page_ext *page_ext)
-{
-	return !page_ext || (((unsigned long)page_ext & PAGE_EXT_INVALID) == PAGE_EXT_INVALID);
-}
-
-static struct page_ext *lookup_page_ext(const struct page *page)
-{
-	unsigned long pfn = page_to_pfn(page);
-	struct mem_section *section = __pfn_to_section(pfn);
-	struct page_ext *page_ext = READ_ONCE(section->page_ext);
-
-	WARN_ON_ONCE(!rcu_read_lock_held());
-	/*
-	 * The sanity checks the page allocator does upon freeing a
-	 * page can reach here before the page_ext arrays are
-	 * allocated when feeding a range of pages to the allocator
-	 * for the first time during bootup or memory hotplug.
-	 */
-	if (page_ext_invalid(page_ext))
-		return NULL;
-	return get_entry(page_ext, pfn);
-}
-
 static __ref void *alloc_page_ext(size_t size, int nid)
 {
 	void *addr;
@@ -365,7 +312,7 @@ static void __free_page_ext(unsigned lon
 		base = (void *)base - PAGE_EXT_INVALID;
 	WRITE_ONCE(ms->page_ext, NULL);
 
-	base = get_entry(base, pfn);
+	base = page_ext_entry(base, pfn);
 	free_page_ext(base);
 }
 
@@ -508,7 +455,8 @@ void __init page_ext_init(void)
  */
 struct page_ext *page_ext_lookup(unsigned long pfn)
 {
-	return lookup_page_ext(pfn_to_page(pfn));
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	return __page_ext_lookup(pfn);
 }
 
 /**
@@ -527,7 +475,7 @@ struct page_ext *page_ext_get(const stru
 	struct page_ext *page_ext;
 
 	rcu_read_lock();
-	page_ext = lookup_page_ext(page);
+	page_ext = page_ext_lookup(page_to_pfn(page));
 	if (!page_ext) {
 		rcu_read_unlock();
 		return NULL;
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

