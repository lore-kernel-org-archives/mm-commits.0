Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 333E5C4167B
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357222AbiCYBNU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357230AbiCYBNJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:13:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF46BD2CC
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:11:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15BFCB82707
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5AAAC340F1;
        Fri, 25 Mar 2022 01:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170692;
        bh=h1eH/UVYb2YtsOgTCAshG7akG2kJpA0j+hNsmp2udYc=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=jGXEJuIsLaX1wiuPmLfnkfXUmNsMwPyC9W0JIjGk9gxxD0ZOdxIs0Q/ANbHTYaWP+
         s5CdDaaiA3ya8hToHGT44kfkg889su4aUpFy9igNRGoEOV2mE1j0nOwTb4zKKFYTFP
         iKuBfBD0D3dnw5K0tiYDbtfzPHfzIQH4fXv4RyCs=
Date:   Thu, 24 Mar 2022 18:11:32 -0700
To:     will@kernel.org, vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
        pcc@google.com, mark.rutland@arm.com, glider@google.com,
        eugenis@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 059/114] kasan, vmalloc: add vmalloc tagging for HW_TAGS
Message-Id: <20220325011132.C5AAAC340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, vmalloc: add vmalloc tagging for HW_TAGS

Add vmalloc tagging support to HW_TAGS KASAN.

The key difference between HW_TAGS and the other two KASAN modes when it
comes to vmalloc: HW_TAGS KASAN can only assign tags to physical memory. 
The other two modes have shadow memory covering every mapped virtual
memory region.

Make __kasan_unpoison_vmalloc() for HW_TAGS KASAN:

- Skip non-VM_ALLOC mappings as HW_TAGS KASAN can only tag a single
  mapping of normal physical memory; see the comment in the function.
- Generate a random tag, tag the returned pointer and the allocation,
  and initialize the allocation at the same time.
- Propagate the tag into the page stucts to allow accesses through
  page_address(vmalloc_to_page()).

The rest of vmalloc-related KASAN hooks are not needed:

- The shadow-related ones are fully skipped.
- __kasan_poison_vmalloc() is kept as a no-op with a comment.

Poisoning and zeroing of physical pages that are backing vmalloc()
allocations are skipped via __GFP_SKIP_KASAN_UNPOISON and __GFP_SKIP_ZERO:
__kasan_unpoison_vmalloc() does that instead.

Enabling CONFIG_KASAN_VMALLOC with HW_TAGS is not yet allowed.

Link: https://lkml.kernel.org/r/d19b2e9e59a9abc59d05b72dea8429dcaea739c6.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Co-developed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   36 +++++++++++++--
 kernel/scs.c          |    4 -
 mm/kasan/hw_tags.c    |   92 ++++++++++++++++++++++++++++++++++++++++
 mm/kasan/shadow.c     |   10 +++-
 mm/vmalloc.c          |   51 +++++++++++++++++-----
 5 files changed, 175 insertions(+), 18 deletions(-)

--- a/include/linux/kasan.h~kasan-vmalloc-add-vmalloc-tagging-for-hw_tags
+++ a/include/linux/kasan.h
@@ -26,6 +26,12 @@ struct kunit_kasan_expectation {
 
 #endif
 
+typedef unsigned int __bitwise kasan_vmalloc_flags_t;
+
+#define KASAN_VMALLOC_NONE	0x00u
+#define KASAN_VMALLOC_INIT	0x01u
+#define KASAN_VMALLOC_VM_ALLOC	0x02u
+
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 
 #include <linux/pgtable.h>
@@ -397,18 +403,39 @@ static inline void kasan_init_hw_tags(vo
 
 #ifdef CONFIG_KASAN_VMALLOC
 
+#if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
+
 void kasan_populate_early_vm_area_shadow(void *start, unsigned long size);
 int kasan_populate_vmalloc(unsigned long addr, unsigned long size);
 void kasan_release_vmalloc(unsigned long start, unsigned long end,
 			   unsigned long free_region_start,
 			   unsigned long free_region_end);
 
-void *__kasan_unpoison_vmalloc(const void *start, unsigned long size);
+#else /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
+
+static inline void kasan_populate_early_vm_area_shadow(void *start,
+						       unsigned long size)
+{ }
+static inline int kasan_populate_vmalloc(unsigned long start,
+					unsigned long size)
+{
+	return 0;
+}
+static inline void kasan_release_vmalloc(unsigned long start,
+					 unsigned long end,
+					 unsigned long free_region_start,
+					 unsigned long free_region_end) { }
+
+#endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
+
+void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
+			       kasan_vmalloc_flags_t flags);
 static __always_inline void *kasan_unpoison_vmalloc(const void *start,
-						    unsigned long size)
+						unsigned long size,
+						kasan_vmalloc_flags_t flags)
 {
 	if (kasan_enabled())
-		return __kasan_unpoison_vmalloc(start, size);
+		return __kasan_unpoison_vmalloc(start, size, flags);
 	return (void *)start;
 }
 
@@ -435,7 +462,8 @@ static inline void kasan_release_vmalloc
 					 unsigned long free_region_end) { }
 
 static inline void *kasan_unpoison_vmalloc(const void *start,
-					   unsigned long size)
+					   unsigned long size,
+					   kasan_vmalloc_flags_t flags)
 {
 	return (void *)start;
 }
--- a/kernel/scs.c~kasan-vmalloc-add-vmalloc-tagging-for-hw_tags
+++ a/kernel/scs.c
@@ -32,7 +32,7 @@ static void *__scs_alloc(int node)
 	for (i = 0; i < NR_CACHED_SCS; i++) {
 		s = this_cpu_xchg(scs_cache[i], NULL);
 		if (s) {
-			kasan_unpoison_vmalloc(s, SCS_SIZE);
+			kasan_unpoison_vmalloc(s, SCS_SIZE, KASAN_VMALLOC_NONE);
 			memset(s, 0, SCS_SIZE);
 			return s;
 		}
@@ -78,7 +78,7 @@ void scs_free(void *s)
 		if (this_cpu_cmpxchg(scs_cache[i], 0, s) == NULL)
 			return;
 
-	kasan_unpoison_vmalloc(s, SCS_SIZE);
+	kasan_unpoison_vmalloc(s, SCS_SIZE, KASAN_VMALLOC_NONE);
 	vfree_atomic(s);
 }
 
--- a/mm/kasan/hw_tags.c~kasan-vmalloc-add-vmalloc-tagging-for-hw_tags
+++ a/mm/kasan/hw_tags.c
@@ -192,6 +192,98 @@ void __init kasan_init_hw_tags(void)
 		kasan_stack_collection_enabled() ? "on" : "off");
 }
 
+#ifdef CONFIG_KASAN_VMALLOC
+
+static void unpoison_vmalloc_pages(const void *addr, u8 tag)
+{
+	struct vm_struct *area;
+	int i;
+
+	/*
+	 * As hardware tag-based KASAN only tags VM_ALLOC vmalloc allocations
+	 * (see the comment in __kasan_unpoison_vmalloc), all of the pages
+	 * should belong to a single area.
+	 */
+	area = find_vm_area((void *)addr);
+	if (WARN_ON(!area))
+		return;
+
+	for (i = 0; i < area->nr_pages; i++) {
+		struct page *page = area->pages[i];
+
+		page_kasan_tag_set(page, tag);
+	}
+}
+
+void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
+				kasan_vmalloc_flags_t flags)
+{
+	u8 tag;
+	unsigned long redzone_start, redzone_size;
+
+	if (!is_vmalloc_or_module_addr(start))
+		return (void *)start;
+
+	/*
+	 * Skip unpoisoning and assigning a pointer tag for non-VM_ALLOC
+	 * mappings as:
+	 *
+	 * 1. Unlike the software KASAN modes, hardware tag-based KASAN only
+	 *    supports tagging physical memory. Therefore, it can only tag a
+	 *    single mapping of normal physical pages.
+	 * 2. Hardware tag-based KASAN can only tag memory mapped with special
+	 *    mapping protection bits, see arch_vmalloc_pgprot_modify().
+	 *    As non-VM_ALLOC mappings can be mapped outside of vmalloc code,
+	 *    providing these bits would require tracking all non-VM_ALLOC
+	 *    mappers.
+	 *
+	 * Thus, for VM_ALLOC mappings, hardware tag-based KASAN only tags
+	 * the first virtual mapping, which is created by vmalloc().
+	 * Tagging the page_alloc memory backing that vmalloc() allocation is
+	 * skipped, see ___GFP_SKIP_KASAN_UNPOISON.
+	 *
+	 * For non-VM_ALLOC allocations, page_alloc memory is tagged as usual.
+	 */
+	if (!(flags & KASAN_VMALLOC_VM_ALLOC))
+		return (void *)start;
+
+	tag = kasan_random_tag();
+	start = set_tag(start, tag);
+
+	/* Unpoison and initialize memory up to size. */
+	kasan_unpoison(start, size, flags & KASAN_VMALLOC_INIT);
+
+	/*
+	 * Explicitly poison and initialize the in-page vmalloc() redzone.
+	 * Unlike software KASAN modes, hardware tag-based KASAN doesn't
+	 * unpoison memory when populating shadow for vmalloc() space.
+	 */
+	redzone_start = round_up((unsigned long)start + size,
+				 KASAN_GRANULE_SIZE);
+	redzone_size = round_up(redzone_start, PAGE_SIZE) - redzone_start;
+	kasan_poison((void *)redzone_start, redzone_size, KASAN_TAG_INVALID,
+		     flags & KASAN_VMALLOC_INIT);
+
+	/*
+	 * Set per-page tag flags to allow accessing physical memory for the
+	 * vmalloc() mapping through page_address(vmalloc_to_page()).
+	 */
+	unpoison_vmalloc_pages(start, tag);
+
+	return (void *)start;
+}
+
+void __kasan_poison_vmalloc(const void *start, unsigned long size)
+{
+	/*
+	 * No tagging here.
+	 * The physical pages backing the vmalloc() allocation are poisoned
+	 * through the usual page_alloc paths.
+	 */
+}
+
+#endif
+
 #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 
 void kasan_enable_tagging_sync(void)
--- a/mm/kasan/shadow.c~kasan-vmalloc-add-vmalloc-tagging-for-hw_tags
+++ a/mm/kasan/shadow.c
@@ -475,8 +475,16 @@ void kasan_release_vmalloc(unsigned long
 	}
 }
 
-void *__kasan_unpoison_vmalloc(const void *start, unsigned long size)
+void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
+			       kasan_vmalloc_flags_t flags)
 {
+	/*
+	 * Software KASAN modes unpoison both VM_ALLOC and non-VM_ALLOC
+	 * mappings, so the KASAN_VMALLOC_VM_ALLOC flag is ignored.
+	 * Software KASAN modes can't optimize zeroing memory by combining it
+	 * with setting memory tags, so the KASAN_VMALLOC_INIT flag is ignored.
+	 */
+
 	if (!is_vmalloc_or_module_addr(start))
 		return (void *)start;
 
--- a/mm/vmalloc.c~kasan-vmalloc-add-vmalloc-tagging-for-hw_tags
+++ a/mm/vmalloc.c
@@ -2237,8 +2237,12 @@ void *vm_map_ram(struct page **pages, un
 		return NULL;
 	}
 
-	/* Mark the pages as accessible, now that they are mapped. */
-	mem = kasan_unpoison_vmalloc(mem, size);
+	/*
+	 * Mark the pages as accessible, now that they are mapped.
+	 * With hardware tag-based KASAN, marking is skipped for
+	 * non-VM_ALLOC mappings, see __kasan_unpoison_vmalloc().
+	 */
+	mem = kasan_unpoison_vmalloc(mem, size, KASAN_VMALLOC_NONE);
 
 	return mem;
 }
@@ -2472,9 +2476,12 @@ static struct vm_struct *__get_vm_area_n
 	 * best-effort approach, as they can be mapped outside of vmalloc code.
 	 * For VM_ALLOC mappings, the pages are marked as accessible after
 	 * getting mapped in __vmalloc_node_range().
+	 * With hardware tag-based KASAN, marking is skipped for
+	 * non-VM_ALLOC mappings, see __kasan_unpoison_vmalloc().
 	 */
 	if (!(flags & VM_ALLOC))
-		area->addr = kasan_unpoison_vmalloc(area->addr, requested_size);
+		area->addr = kasan_unpoison_vmalloc(area->addr, requested_size,
+							KASAN_VMALLOC_NONE);
 
 	return area;
 }
@@ -3084,6 +3091,7 @@ void *__vmalloc_node_range(unsigned long
 {
 	struct vm_struct *area;
 	void *ret;
+	kasan_vmalloc_flags_t kasan_flags;
 	unsigned long real_size = size;
 	unsigned long real_align = align;
 	unsigned int shift = PAGE_SHIFT;
@@ -3136,21 +3144,39 @@ again:
 		goto fail;
 	}
 
-	/*
-	 * Modify protection bits to allow tagging.
-	 * This must be done before mapping by __vmalloc_area_node().
-	 */
+	/* Prepare arguments for __vmalloc_area_node(). */
 	if (kasan_hw_tags_enabled() &&
-	    pgprot_val(prot) == pgprot_val(PAGE_KERNEL))
+	    pgprot_val(prot) == pgprot_val(PAGE_KERNEL)) {
+		/*
+		 * Modify protection bits to allow tagging.
+		 * This must be done before mapping in __vmalloc_area_node().
+		 */
 		prot = arch_vmap_pgprot_tagged(prot);
 
+		/*
+		 * Skip page_alloc poisoning and zeroing for physical pages
+		 * backing VM_ALLOC mapping. Memory is instead poisoned and
+		 * zeroed by kasan_unpoison_vmalloc().
+		 */
+		gfp_mask |= __GFP_SKIP_KASAN_UNPOISON | __GFP_SKIP_ZERO;
+	}
+
 	/* Allocate physical pages and map them into vmalloc space. */
 	ret = __vmalloc_area_node(area, gfp_mask, prot, shift, node);
 	if (!ret)
 		goto fail;
 
-	/* Mark the pages as accessible, now that they are mapped. */
-	area->addr = kasan_unpoison_vmalloc(area->addr, real_size);
+	/*
+	 * Mark the pages as accessible, now that they are mapped.
+	 * The init condition should match the one in post_alloc_hook()
+	 * (except for the should_skip_init() check) to make sure that memory
+	 * is initialized under the same conditions regardless of the enabled
+	 * KASAN mode.
+	 */
+	kasan_flags = KASAN_VMALLOC_VM_ALLOC;
+	if (!want_init_on_free() && want_init_on_alloc(gfp_mask))
+		kasan_flags |= KASAN_VMALLOC_INIT;
+	area->addr = kasan_unpoison_vmalloc(area->addr, real_size, kasan_flags);
 
 	/*
 	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED
@@ -3850,10 +3876,13 @@ retry:
 	/*
 	 * Mark allocated areas as accessible. Do it now as a best-effort
 	 * approach, as they can be mapped outside of vmalloc code.
+	 * With hardware tag-based KASAN, marking is skipped for
+	 * non-VM_ALLOC mappings, see __kasan_unpoison_vmalloc().
 	 */
 	for (area = 0; area < nr_vms; area++)
 		vms[area]->addr = kasan_unpoison_vmalloc(vms[area]->addr,
-							 vms[area]->size);
+							 vms[area]->size,
+							 KASAN_VMALLOC_NONE);
 
 	kfree(vas);
 	return vms;
_
