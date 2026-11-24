Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795514627;
	b=AE38B6acUqw4ob4TT1wWXtJai+4lf6fUDMmX+9l5D1keGJXeHZvqWKviriGqroVOHmpd
	 LPJxQ0fdMqtdEgf7aFLTD84hu+Evd90jg5aKm8Ob7+vmTUBPTwEgsYO+SA5N4qvpWhwJS
	 Z7FSui9iyc4rb/sXX2uQzzFbI3o+LGR6h9an/f5GCmTmNIoiAnS71Dp5Vfc05gzSRMAGG
	 e7udPRkQjFn6n4wC3RSs5rDwMUufDFOW3EAmeF6vPTqyOL50kMkyNMPG440mn32qTl5rL
	 fY+7KYUm8/jH7uK55z39D56MztKenCiHMpHR2aQUmlb+hfKCT269AcjbHYUXmlGqeaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795514627;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=jjPlizUfysprBLmx68OMo2HBkiM3CuHQoU/hOWUxt9w=;
	b=DiU/pQSzLeyT4Ryd33ccAvo9QGxehdxK85PIcgojIWrv323WjEpo3ZDaf64SweQrvYmE
	 dk2tBqs4d9nVB0RlMhTFNhvGqEPdHWwgq0cBPwF/tmrLYE/LjgvfPbzg+BQ7tSwE2b93G
	 t8mhP32kZzw0JiA9IqSQuy4MdTz344NCJlmn5RvsWHrS2Aci4QM/Lg9LYPfoe44dinUGy
	 zbNzzE2KKq6TUXQC/pVkPu71/xxwSCrjCqF0oTEvCg79OMAy7igKL5jCl3tUvW0lFKyFN
	 HwzpkF2wqewT5PIbWDsugjmZf9UvIjuiVkdU8cxcH+uLQRnGU9CVHZqLS+ujlSAqctQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=O4XNDMRi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB46606A321
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 10:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=O4XNDMRi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550BD1F000CA;
	Tue, 24 Nov 2026 10:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795514626;
	bh=jjPlizUfysprBLmx68OMo2HBkiM3CuHQoU/hOWUxt9w=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=O4XNDMRiFOQWDxLBrP4VsUSExitg0PJjb9B+J5bXoY03eMXOhqOmZ2140rbjDHzXw
	 ly4pFqhb5M8E3tvavOrdESm32VrSepXzpGhgoDVezBelW477f7nncq6McDmbRrSVaM
	 5qM7zfK5tSwTs+sytiWLTD2SQlByHWNpDxoexVs4=
Date: Tue, 24 Nov 2026 02:03:45 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,
	surenb@google.com,smostafa@google.com,skhan@linuxfoundation.org,
	rppt@kernel.org,rdunlap@infradead.org,praan@google.com,mhocko@suse.com,
	liam@infradead.org,ketan.kishore@oss.qualcomm.com,joerg.roedel@amd.com,
	hannes@cmpxchg.org,glider@google.com,elver@google.com,ekffu200098@gmail.com,
	dvyukov@google.com,david@kernel.org,corbet@lwn.net,chris@chrisdown.name,
	brendan.jackman@linux.dev,baolu.lu@linux.intel.com,songmuchun@bytedance.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261119065812.89959-8-songmuchun@bytedance.com>
References: <20261119065812.89959-8-songmuchun@bytedance.com>
Subject: + kmsan-fix-metadata-loss-during-hugetlb-struct-page-reinitialization.patch added to mm-new branch
Message-Id: <20261124100346.550BD1F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: kmsan: fix metadata loss during HugeTLB struct page reinitialization
has been added to the -mm mm-new branch.  Its filename is
     kmsan-fix-metadata-loss-during-hugetlb-struct-page-reinitialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-fix-metadata-loss-during-hugetlb-struct-page-reinitialization.patch

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
Subject: kmsan: fix metadata loss during HugeTLB struct page reinitialization
Date: Thu, 19 Nov 2026 14:58:12 +0800

KMSAN stores each page's shadow and origin pointers in struct page.
Boot-time gigantic HugeTLB pages are reinitialized after
kmsan_init_shadow() installs these pointers, dropping the mappings and
leaving the allocated metadata pages unreachable.

Move the pointers to page_ext, whose boot-time storage is available
before kmsan_init_shadow() and survives struct page reinitialization.
Use the inline unchecked lookup under notrace preemption so metadata
lookup cannot recurse through instrumented hooks.

This shrinks struct page from 80 to 64 bytes on x86-64 KMSAN builds,
making its size a power of two and allowing HugeTLB Vmemmap Optimization
with KMSAN.

Link: https://patch.msgid.link/20261119065812.89959-8-songmuchun@bytedance.com
Fixes: fde1c4ecf916 ("mm: hugetlb: skip initialization of gigantic tail struct pages if freed by HVO")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-ac161ba4-30cc-4bd3-b93c-ab7af8a6f64f
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

 Documentation/dev-tools/kmsan.rst |    8 +---
 include/linux/kmsan.h             |    2 +
 include/linux/mm.h                |   12 +------
 include/linux/mm_types.h          |   12 -------
 lib/Kconfig.kmsan                 |    1 
 mm/kmsan/shadow.c                 |   45 ++++++++++++++++++++++++----
 mm/page_ext.c                     |    4 ++
 7 files changed, 52 insertions(+), 32 deletions(-)

--- a/Documentation/dev-tools/kmsan.rst~kmsan-fix-metadata-loss-during-hugetlb-struct-page-reinitialization
+++ a/Documentation/dev-tools/kmsan.rst
@@ -376,13 +376,11 @@ Metadata allocation
 
 There are several places in the kernel for which the metadata is stored.
 
-1. Each ``struct page`` instance contains two pointers to its shadow and
-origin pages::
+1. Each page frame has a corresponding ``struct page_metadata`` entry containing
+two pointers to its shadow and origin pages::
 
-  struct page {
-    ...
+  struct page_metadata {
     struct page *shadow, *origin;
-    ...
   };
 
 At boot-time, the kernel allocates shadow and origin pages for every available
--- a/include/linux/kmsan.h~kmsan-fix-metadata-loss-during-hugetlb-struct-page-reinitialization
+++ a/include/linux/kmsan.h
@@ -15,12 +15,14 @@
 #include <linux/types.h>
 
 struct page;
+struct page_ext_operations;
 struct kmem_cache;
 struct task_struct;
 struct scatterlist;
 struct urb;
 
 #ifdef CONFIG_KMSAN
+extern struct page_ext_operations kmsan_ops;
 
 /**
  * kmsan_task_create() - Initialize KMSAN state for the task.
--- a/include/linux/mm.h~kmsan-fix-metadata-loss-during-hugetlb-struct-page-reinitialization
+++ a/include/linux/mm.h
@@ -134,7 +134,7 @@ extern int mmap_rnd_compat_bits __read_m
  * define their own version of this macro in <asm/pgtable.h>
  */
 #if BITS_PER_LONG == 64
-/* This function must be updated when the size of struct page grows above 96
+/* This function must be updated when the size of struct page grows above 80
  * or reduces below 56. The idea that compiler optimizes out switch()
  * statement, and only leaves move/store instructions. Also the compiler can
  * combine write statements if they are both assignments and can be reordered,
@@ -145,18 +145,12 @@ static inline void __mm_zero_struct_page
 {
 	unsigned long *_pp = (void *)page;
 
-	 /* Check that struct page is either 56, 64, 72, 80, 88 or 96 bytes */
+	/* Check that struct page is either 56, 64, 72 or 80 bytes */
 	BUILD_BUG_ON(sizeof(struct page) & 7);
 	BUILD_BUG_ON(sizeof(struct page) < 56);
-	BUILD_BUG_ON(sizeof(struct page) > 96);
+	BUILD_BUG_ON(sizeof(struct page) > 80);
 
 	switch (sizeof(struct page)) {
-	case 96:
-		_pp[11] = 0;
-		fallthrough;
-	case 88:
-		_pp[10] = 0;
-		fallthrough;
 	case 80:
 		_pp[9] = 0;
 		fallthrough;
--- a/include/linux/mm_types.h~kmsan-fix-metadata-loss-during-hugetlb-struct-page-reinitialization
+++ a/include/linux/mm_types.h
@@ -208,18 +208,6 @@ struct page {
 #ifdef LAST_CPUPID_NOT_IN_PAGE_FLAGS
 	int _last_cpupid;
 #endif
-
-#ifdef CONFIG_KMSAN
-	/*
-	 * KMSAN metadata for this page:
-	 *  - shadow page: every bit indicates whether the corresponding
-	 *    bit of the original page is initialized (0) or not (1);
-	 *  - origin page: every 4 bytes contain an id of the stack trace
-	 *    where the uninitialized value was created.
-	 */
-	struct page *kmsan_shadow;
-	struct page *kmsan_origin;
-#endif
 } _struct_page_alignment;
 
 /*
--- a/lib/Kconfig.kmsan~kmsan-fix-metadata-loss-during-hugetlb-struct-page-reinitialization
+++ a/lib/Kconfig.kmsan
@@ -10,6 +10,7 @@ config KMSAN
 	depends on HAVE_ARCH_KMSAN && HAVE_KMSAN_COMPILER
 	depends on DEBUG_KERNEL && !KASAN && !KCSAN
 	depends on !PREEMPT_RT
+	select PAGE_EXTENSION
 	select STACKDEPOT
 	select STACKDEPOT_ALWAYS_INIT
 	help
--- a/mm/kmsan/shadow.c~kmsan-fix-metadata-loss-during-hugetlb-struct-page-reinitialization
+++ a/mm/kmsan/shadow.c
@@ -13,6 +13,7 @@
 #include <linux/cacheflush.h>
 #include <linux/memblock.h>
 #include <linux/mm_types.h>
+#include <linux/page_ext.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
 #include <linux/stddef.h>
@@ -24,23 +25,55 @@
 #define KMSAN_META_MASK_SHADOW		BIT(0)
 #define KMSAN_META_MASK_ORIGIN		BIT(1)
 
+/*
+ * KMSAN metadata for this page:
+ *  - shadow page: every bit indicates whether the corresponding
+ *    bit of the original page is initialized (0) or not (1);
+ *  - origin page: every 4 bytes contain an id of the stack trace
+ *    where the uninitialized value was created.
+ */
 struct page_metadata {
 	struct page *shadow;
 	struct page *origin;
 };
 
+static __init bool need_page_metadata(void)
+{
+	return true;
+}
+
+struct page_ext_operations kmsan_ops = {
+	.size	= sizeof(struct page_metadata),
+	.need	= need_page_metadata,
+};
+
 static inline struct page_metadata get_page_metadata(struct page *page)
 {
-	return (struct page_metadata) {
-		.shadow = page->kmsan_shadow,
-		.origin = page->kmsan_origin,
-	};
+	struct page_metadata meta = {};
+	struct page_ext *page_ext;
+
+	/*
+	 * Avoid instrumented preemption debug and tracing hooks while resolving
+	 * KMSAN metadata, as they would recurse back into metadata lookup.
+	 */
+	preempt_disable_notrace();
+	page_ext = __page_ext_lookup(page_to_pfn(page));
+	if (page_ext)
+		meta = *(struct page_metadata *)page_ext_data(page_ext, &kmsan_ops);
+	preempt_enable_no_resched_notrace();
+
+	return meta;
 }
 
 static inline void set_page_metadata(struct page *page, struct page_metadata meta)
 {
-	page->kmsan_shadow = meta.shadow;
-	page->kmsan_origin = meta.origin;
+	struct page_ext *page_ext;
+
+	preempt_disable_notrace();
+	page_ext = __page_ext_lookup(page_to_pfn(page));
+	if (page_ext)
+		*(struct page_metadata *)page_ext_data(page_ext, &kmsan_ops) = meta;
+	preempt_enable_no_resched_notrace();
 }
 
 static inline void *shadow_ptr_for(struct page_metadata meta)
--- a/mm/page_ext.c~kmsan-fix-metadata-loss-during-hugetlb-struct-page-reinitialization
+++ a/mm/page_ext.c
@@ -12,6 +12,7 @@
 #include <linux/rcupdate.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/iommu-debug-pagealloc.h>
+#include <linux/kmsan.h>
 #include <linux/slab.h>
 
 /*
@@ -87,6 +88,9 @@ static struct page_ext_operations *page_
 #ifdef CONFIG_PAGE_TABLE_CHECK
 	&page_table_check_ops,
 #endif
+#ifdef CONFIG_KMSAN
+	&kmsan_ops,
+#endif
 #ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
 	&page_iommu_debug_ops,
 #endif
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

