Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795514607;
	b=P4UB+5j8oi0YLQdOaG7g1vQ2YIKXYeTu2XTcniyd0jw/T2Dwo26uZYcY6h32UWD9MpKb
	 TnIvK+cXotQsxrCUC7Lpu+AJDfGGBBmOfp2d4u36YtsnMMVuEp//RWgClJq2ZA+10fBia
	 MoV0bLPVBTTOWH3YOKg3oWuJp64To24Q1NTtkcEx0IPNpQbLvYjCxkRzBG0U8/mgkICX0
	 I3lsg8s+XYvSSW4gR+PmMvKaGFN2RPWsE31P7+Gsk5L6PhmGibRjbb7K3u29b02r8vne4
	 tkkIT4rC59yfh1qIP3peQ2vjI8Wib6v+SutWR3g1UwwOMV5Xnfqoyzma1G4nW4wzM1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795514607;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=bFELS2ihjYQPGrPfVXC39Lfxd2C48hjdRG+KdsoglOs=;
	b=ZWCnd3/NHdYG69n4tjV+gF/BGG6mfuKyUiQLosqR6VKFc//p34AbqgBt+9JiBYL8320O
	 mLTI+75fDHYJqqEAbX2RRNM6JtefFPi6wUKxkeKTsEl3YVNTZJ/yZJf7Nd1kWSqe9e0cq
	 kY3acN9gm/EVJPsQxwpqDLSXO9/5JmgcHJ2QfgGADHfGRWPXKWl2v+vESLWLplQ0iuhDZ
	 J5WpBoc41pPW6o/WSRSVHzDlQpfkVlURLmme50tw7CIjHOrCKf+gSr+cIS1xUtnADSnVg
	 /cA8fw8faU2neG6Fqtb7BqBumdqSLKpTVsIj7a9ZBDTQ3U6xKUkC2nRWKGEzSwYVIGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Xm24VoY+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE419606A321
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 10:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Xm24VoY+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFAE71F000C6;
	Tue, 24 Nov 2026 10:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795514606;
	bh=bFELS2ihjYQPGrPfVXC39Lfxd2C48hjdRG+KdsoglOs=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=Xm24VoY+zQuKHjlFqI14bhg3LuW+Fzs7U5CnFYmomVlf0eJyOhWdlQzbT+tsmMlQb
	 dvdp4nk3P2j9Ege+DRqDDPkW5t7lLrPvmlAHEcKRsEi2hvVx3jRPRgN6SG3ccJHTUS
	 I1FOmF93fLmkfduKxYKW/Fi8xiJSLUCRwVFpS0GE=
Date: Tue, 24 Nov 2026 02:03:26 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,
	surenb@google.com,smostafa@google.com,skhan@linuxfoundation.org,
	rppt@kernel.org,rdunlap@infradead.org,praan@google.com,mhocko@suse.com,
	liam@infradead.org,ketan.kishore@oss.qualcomm.com,joerg.roedel@amd.com,
	hannes@cmpxchg.org,glider@google.com,elver@google.com,ekffu200098@gmail.com,
	dvyukov@google.com,david@kernel.org,corbet@lwn.net,chris@chrisdown.name,
	brendan.jackman@linux.dev,baolu.lu@linux.intel.com,songmuchun@bytedance.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261119065812.89959-2-songmuchun@bytedance.com>
References: <20261119065812.89959-2-songmuchun@bytedance.com>
Subject: + kmsan-encapsulate-per-page-metadata-access.patch added to mm-new branch
Message-Id: <20261124100326.CFAE71F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: kmsan: encapsulate per-page metadata access
has been added to the -mm mm-new branch.  Its filename is
     kmsan-encapsulate-per-page-metadata-access.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-encapsulate-per-page-metadata-access.patch

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
Subject: kmsan: encapsulate per-page metadata access
Date: Thu, 19 Nov 2026 14:58:06 +0800

Patch series "KMSAN: Move per-page metadata out of struct page", v3.

This series fixes a KMSAN metadata-loss bug triggered when boot-time
gigantic HugeTLB pages reinitialize their page descriptors after
kmsan_init_shadow(). KMSAN currently stores each page's shadow and
origin pointers in struct page, so the later initialization drops the
metadata mappings and leaves their backing pages unreachable.

Preserving the pointers around the HugeTLB initialization would add
KMSAN-specific state handling to the memmap path. Moving
kmsan_init_shadow() later is not viable either, because it allocates
metadata from memblock while gigantic page descriptors are initialized
after memblock teardown.

Move the metadata pointers to page_ext instead. page_ext storage is
independent of struct page contents and is made available before
kmsan_init_shadow(), so later page-descriptor initialization cannot
erase the mappings.

The series first decouples KMSAN metadata access from its storage, then
makes page_ext safe and available during early boot, and finally moves
the metadata pointers. The move also shrinks struct page from 80 to 64
bytes on x86-64 KMSAN builds, allowing HugeTLB Vmemmap Optimization to
be used with KMSAN.


This patch (of 7):

KMSAN directly accesses page->kmsan_shadow and page->kmsan_origin
throughout the shadow implementation. This couples these users to
storing the metadata pointers in struct page, requiring every access
site to change when the storage moves elsewhere.

Introduce helpers that get and set both metadata page pointers as a pair
and convert the existing users to them.

kmsan_get_shadow_origin_ptr() is the main metadata lookup path for
compiler-instrumented memory accesses and requires both pointers. For
page-backed addresses, resolve the backing page once and obtain the
metadata pair through one lookup instead of calling the single-metadata
path twice. This also avoids duplicate lookups after moving the metadata
storage out of struct page.

No functional change is intended.

Link: https://lore.kernel.org/20261119065812.89959-1-songmuchun@bytedance.com
Link: https://patch.msgid.link/20261119065812.89959-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
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

 mm/kmsan/shadow.c |  166 +++++++++++++++++++++++++++++---------------
 1 file changed, 111 insertions(+), 55 deletions(-)

--- a/mm/kmsan/shadow.c~kmsan-encapsulate-per-page-metadata-access
+++ a/mm/kmsan/shadow.c
@@ -9,6 +9,7 @@
 
 #include <asm/kmsan.h>
 #include <asm/tlbflush.h>
+#include <linux/bits.h>
 #include <linux/cacheflush.h>
 #include <linux/memblock.h>
 #include <linux/mm_types.h>
@@ -20,29 +21,46 @@
 #include "../vmalloc.h"
 #include "kmsan.h"
 
-#define shadow_page_for(page) ((page)->kmsan_shadow)
+#define KMSAN_META_MASK_SHADOW		BIT(0)
+#define KMSAN_META_MASK_ORIGIN		BIT(1)
 
-#define origin_page_for(page) ((page)->kmsan_origin)
+struct page_metadata {
+	struct page *shadow;
+	struct page *origin;
+};
 
-static void *shadow_ptr_for(struct page *page)
+static inline struct page_metadata get_page_metadata(struct page *page)
 {
-	return page_address(shadow_page_for(page));
+	return (struct page_metadata) {
+		.shadow = page->kmsan_shadow,
+		.origin = page->kmsan_origin,
+	};
 }
 
-static void *origin_ptr_for(struct page *page)
+static inline void set_page_metadata(struct page *page, struct page_metadata meta)
 {
-	return page_address(origin_page_for(page));
+	page->kmsan_shadow = meta.shadow;
+	page->kmsan_origin = meta.origin;
 }
 
-static bool page_has_metadata(struct page *page)
+static inline void *shadow_ptr_for(struct page_metadata meta)
 {
-	return shadow_page_for(page) && origin_page_for(page);
+	return page_address(meta.shadow);
+}
+
+static inline void *origin_ptr_for(struct page_metadata meta)
+{
+	return page_address(meta.origin);
+}
+
+static inline bool page_has_metadata(struct page_metadata meta)
+{
+	return meta.shadow && meta.origin;
 }
 
 static void set_no_shadow_origin_page(struct page *page)
 {
-	shadow_page_for(page) = NULL;
-	origin_page_for(page) = NULL;
+	set_page_metadata(page, (struct page_metadata) {});
 }
 
 /*
@@ -79,11 +97,56 @@ static struct page *virt_to_page_or_null
 		return NULL;
 }
 
+static __always_inline
+struct shadow_origin_ptr __kmsan_get_metadata(void *address, unsigned int mask)
+{
+	struct shadow_origin_ptr ret = {};
+	struct page_metadata meta;
+	struct page *page;
+	u64 addr = (u64)address;
+	u64 origin_addr = ALIGN_DOWN(addr, KMSAN_ORIGIN_SIZE);
+
+	if (kmsan_internal_is_vmalloc_addr(address) ||
+	    kmsan_internal_is_module_addr(address)) {
+		if (mask & KMSAN_META_MASK_SHADOW)
+			ret.shadow = (void *)vmalloc_meta(address, KMSAN_META_SHADOW);
+		if (mask & KMSAN_META_MASK_ORIGIN)
+			ret.origin = (void *)vmalloc_meta((void *)origin_addr,
+							  KMSAN_META_ORIGIN);
+		return ret;
+	}
+
+	if (mask & KMSAN_META_MASK_SHADOW) {
+		ret.shadow = arch_kmsan_get_meta_or_null(address, KMSAN_META_SHADOW);
+		if (!ret.shadow)
+			goto lookup_page;
+	}
+	if (mask & KMSAN_META_MASK_ORIGIN)
+		ret.origin = arch_kmsan_get_meta_or_null((void *)origin_addr,
+							 KMSAN_META_ORIGIN);
+	if (ret.shadow || ret.origin)
+		return ret;
+
+lookup_page:
+	page = virt_to_page_or_null(address);
+	if (!page)
+		return ret;
+	meta = get_page_metadata(page);
+	if (!page_has_metadata(meta))
+		return ret;
+
+	if (mask & KMSAN_META_MASK_SHADOW)
+		ret.shadow = shadow_ptr_for(meta) + offset_in_page(addr);
+	if (mask & KMSAN_META_MASK_ORIGIN)
+		ret.origin = origin_ptr_for(meta) + offset_in_page(origin_addr);
+
+	return ret;
+}
+
 struct shadow_origin_ptr kmsan_get_shadow_origin_ptr(void *address, u64 size,
 						     bool store)
 {
 	struct shadow_origin_ptr ret;
-	void *shadow;
 
 	/*
 	 * Even if we redirect this memory access to the dummy page, it will
@@ -95,12 +158,10 @@ struct shadow_origin_ptr kmsan_get_shado
 		goto return_dummy;
 
 	KMSAN_WARN_ON(!kmsan_metadata_is_contiguous(address, size));
-	shadow = kmsan_get_metadata(address, KMSAN_META_SHADOW);
-	if (!shadow)
+	ret = __kmsan_get_metadata(address, KMSAN_META_MASK_SHADOW |
+					    KMSAN_META_MASK_ORIGIN);
+	if (!ret.shadow)
 		goto return_dummy;
-
-	ret.shadow = shadow;
-	ret.origin = kmsan_get_metadata(address, KMSAN_META_ORIGIN);
 	return ret;
 
 return_dummy:
@@ -124,46 +185,36 @@ return_dummy:
  */
 void *kmsan_get_metadata(void *address, bool is_origin)
 {
-	u64 addr = (u64)address, off;
-	struct page *page;
-	void *ret;
-
-	if (is_origin)
-		addr = ALIGN_DOWN(addr, KMSAN_ORIGIN_SIZE);
-	address = (void *)addr;
-	if (kmsan_internal_is_vmalloc_addr(address) ||
-	    kmsan_internal_is_module_addr(address))
-		return (void *)vmalloc_meta(address, is_origin);
-
-	ret = arch_kmsan_get_meta_or_null(address, is_origin);
-	if (ret)
-		return ret;
-
-	page = virt_to_page_or_null(address);
-	if (!page)
-		return NULL;
-	if (!page_has_metadata(page))
-		return NULL;
-	off = offset_in_page(addr);
+	struct shadow_origin_ptr ret;
+	unsigned int mask;
 
-	return (is_origin ? origin_ptr_for(page) : shadow_ptr_for(page)) + off;
+	mask = is_origin ? KMSAN_META_MASK_ORIGIN : KMSAN_META_MASK_SHADOW;
+	ret = __kmsan_get_metadata(address, mask);
+	return is_origin ? ret.origin : ret.shadow;
 }
 
 void kmsan_copy_page_meta(struct page *dst, struct page *src)
 {
+	struct page_metadata dst_meta, src_meta;
+
 	if (!kmsan_enabled || kmsan_in_runtime())
 		return;
-	if (!dst || !page_has_metadata(dst))
+	if (!dst)
 		return;
-	if (!src || !page_has_metadata(src)) {
+	dst_meta = get_page_metadata(dst);
+	if (!page_has_metadata(dst_meta))
+		return;
+	if (src)
+		src_meta = get_page_metadata(src);
+	if (!src || !page_has_metadata(src_meta)) {
 		kmsan_internal_unpoison_memory(page_address(dst), PAGE_SIZE,
 					       /*checked*/ false);
 		return;
 	}
 
 	kmsan_enter_runtime();
-	__memcpy(shadow_ptr_for(dst), shadow_ptr_for(src), PAGE_SIZE);
-	__memcpy(origin_ptr_for(dst), origin_ptr_for(src), PAGE_SIZE);
+	__memcpy(shadow_ptr_for(dst_meta), shadow_ptr_for(src_meta), PAGE_SIZE);
+	__memcpy(origin_ptr_for(dst_meta), origin_ptr_for(src_meta), PAGE_SIZE);
 	kmsan_leave_runtime();
 }
 EXPORT_SYMBOL(kmsan_copy_page_meta);
@@ -171,19 +222,18 @@ EXPORT_SYMBOL(kmsan_copy_page_meta);
 void kmsan_alloc_page(struct page *page, unsigned int order, gfp_t flags)
 {
 	bool initialized = (flags & __GFP_ZERO) || !kmsan_enabled;
-	struct page *shadow, *origin;
+	struct page_metadata meta;
 	depot_stack_handle_t handle;
 	int pages = 1 << order;
 
 	if (!page)
 		return;
 
-	shadow = shadow_page_for(page);
-	origin = origin_page_for(page);
+	meta = get_page_metadata(page);
 
 	if (initialized) {
-		__memset(page_address(shadow), 0, PAGE_SIZE * pages);
-		__memset(page_address(origin), 0, PAGE_SIZE * pages);
+		__memset(shadow_ptr_for(meta), 0, PAGE_SIZE * pages);
+		__memset(origin_ptr_for(meta), 0, PAGE_SIZE * pages);
 		return;
 	}
 
@@ -191,7 +241,7 @@ void kmsan_alloc_page(struct page *page,
 	if (kmsan_in_runtime())
 		return;
 
-	__memset(page_address(shadow), -1, PAGE_SIZE * pages);
+	__memset(shadow_ptr_for(meta), -1, PAGE_SIZE * pages);
 	kmsan_enter_runtime();
 	handle = kmsan_save_stack_with_flags(flags, /*extra_bits*/ 0);
 	kmsan_leave_runtime();
@@ -200,7 +250,7 @@ void kmsan_alloc_page(struct page *page,
 	 * to just fill the origin pages with @handle.
 	 */
 	for (int i = 0; i < PAGE_SIZE * pages / sizeof(handle); i++)
-		((depot_stack_handle_t *)page_address(origin))[i] = handle;
+		((depot_stack_handle_t *)origin_ptr_for(meta))[i] = handle;
 }
 
 void kmsan_free_page(struct page *page, unsigned int order)
@@ -238,8 +288,10 @@ int kmsan_vmap_pages_range_noflush(unsig
 		goto ret;
 	}
 	for (int i = 0; i < nr; i++) {
-		s_pages[i] = shadow_page_for(pages[i]);
-		o_pages[i] = origin_page_for(pages[i]);
+		struct page_metadata meta = get_page_metadata(pages[i]);
+
+		s_pages[i] = meta.shadow;
+		o_pages[i] = meta.origin;
 	}
 	prot = PAGE_KERNEL;
 
@@ -289,10 +341,12 @@ void __init kmsan_init_alloc_meta_for_ra
 		page = virt_to_page_or_null((char *)start + addr);
 		shadow_p = virt_to_page((char *)shadow + addr);
 		set_no_shadow_origin_page(shadow_p);
-		shadow_page_for(page) = shadow_p;
 		origin_p = virt_to_page((char *)origin + addr);
 		set_no_shadow_origin_page(origin_p);
-		origin_page_for(page) = origin_p;
+		set_page_metadata(page, (struct page_metadata) {
+			.shadow = shadow_p,
+			.origin = origin_p,
+		});
 	}
 }
 
@@ -302,7 +356,9 @@ void kmsan_setup_meta(struct page *page,
 	for (int i = 0; i < (1 << order); i++) {
 		set_no_shadow_origin_page(&shadow[i]);
 		set_no_shadow_origin_page(&origin[i]);
-		shadow_page_for(&page[i]) = &shadow[i];
-		origin_page_for(&page[i]) = &origin[i];
+		set_page_metadata(&page[i], (struct page_metadata) {
+			.shadow = &shadow[i],
+			.origin = &origin[i],
+		});
 	}
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
kmsan-encapsulate-per-page-metadata-access.patch
mm-page_ext-fix-client-data-alignment.patch
mm-page_ext-always-use-vmalloc-for-section-page-extensions.patch
mm-page_ext-use-common-allocation-and-initialization-entry-points.patch
mm-page_ext-allocate-page-extensions-early-for-sparsemem.patch
mm-page_ext-inline-unchecked-page-extension-lookup.patch
kmsan-fix-metadata-loss-during-hugetlb-struct-page-reinitialization.patch

