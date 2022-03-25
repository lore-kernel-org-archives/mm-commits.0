Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94888C43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbiCYWo0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233979AbiCYWoD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:44:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B13520A944
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18E1E61502
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68671C004DD;
        Fri, 25 Mar 2022 22:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248147;
        bh=ddLHhBa40/DkmVSjzjNE9qMyZPZ9yG29R/E3Ol7qqNU=;
        h=Date:To:From:Subject:From;
        b=XgDtaKxmxjitFQk/8YJdA+nlC4FCKRfrReHtggCN9TqmU7wsneX7TMu/2riv8nAKN
         UiHrF68WNmiUyMt03/dw65JBP91pbslhaXCNJinMlu7hC0otx+TvYo5Zjr4szzzer0
         lgi2uYygvnQclz78FZb3RX+WM4o5JUsM4SZz7nSI=
Date:   Fri, 25 Mar 2022 15:42:26 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        mark.rutland@arm.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-vmalloc-only-tag-normal-vmalloc-allocations.patch removed from -mm tree
Message-Id: <20220325224227.68671C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, vmalloc: only tag normal vmalloc allocations
has been removed from the -mm tree.  Its filename was
     kasan-vmalloc-only-tag-normal-vmalloc-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, vmalloc: only tag normal vmalloc allocations

The kernel can use to allocate executable memory.  The only supported way
to do that is via __vmalloc_node_range() with the executable bit set in
the prot argument.  (vmap() resets the bit via pgprot_nx()).

Once tag-based KASAN modes start tagging vmalloc allocations, executing
code from such allocations will lead to the PC register getting a tag,
which is not tolerated by the kernel.

Only tag the allocations for normal kernel pages.

[andreyknvl@google.com: pass KASAN_VMALLOC_PROT_NORMAL to kasan_unpoison_vmalloc()]
  Link: https://lkml.kernel.org/r/9230ca3d3e40ffca041c133a524191fd71969a8d.1646233925.git.andreyknvl@google.com
[andreyknvl@google.com: support tagged vmalloc mappings]
  Link: https://lkml.kernel.org/r/2f6605e3a358cf64d73a05710cb3da356886ad29.1646233925.git.andreyknvl@google.com
[andreyknvl@google.com: don't unintentionally disabled poisoning]
  Link: https://lkml.kernel.org/r/de4587d6a719232e83c760113e46ed2d4d8da61e.1646757322.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/fbfd9939a4dc375923c9a5c6b9e7ab05c26b8c6b.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    7 +++--
 kernel/scs.c          |   12 ++++++---
 mm/kasan/hw_tags.c    |    7 +++++
 mm/kasan/shadow.c     |    8 ++++++
 mm/vmalloc.c          |   49 +++++++++++++++++++++++-----------------
 5 files changed, 56 insertions(+), 27 deletions(-)

--- a/include/linux/kasan.h~kasan-vmalloc-only-tag-normal-vmalloc-allocations
+++ a/include/linux/kasan.h
@@ -28,9 +28,10 @@ struct kunit_kasan_expectation {
 
 typedef unsigned int __bitwise kasan_vmalloc_flags_t;
 
-#define KASAN_VMALLOC_NONE	0x00u
-#define KASAN_VMALLOC_INIT	0x01u
-#define KASAN_VMALLOC_VM_ALLOC	0x02u
+#define KASAN_VMALLOC_NONE		0x00u
+#define KASAN_VMALLOC_INIT		0x01u
+#define KASAN_VMALLOC_VM_ALLOC		0x02u
+#define KASAN_VMALLOC_PROT_NORMAL	0x04u
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 
--- a/kernel/scs.c~kasan-vmalloc-only-tag-normal-vmalloc-allocations
+++ a/kernel/scs.c
@@ -32,15 +32,19 @@ static void *__scs_alloc(int node)
 	for (i = 0; i < NR_CACHED_SCS; i++) {
 		s = this_cpu_xchg(scs_cache[i], NULL);
 		if (s) {
-			kasan_unpoison_vmalloc(s, SCS_SIZE, KASAN_VMALLOC_NONE);
+			s = kasan_unpoison_vmalloc(s, SCS_SIZE,
+						   KASAN_VMALLOC_PROT_NORMAL);
 			memset(s, 0, SCS_SIZE);
-			return s;
+			goto out;
 		}
 	}
 
-	return __vmalloc_node_range(SCS_SIZE, 1, VMALLOC_START, VMALLOC_END,
+	s = __vmalloc_node_range(SCS_SIZE, 1, VMALLOC_START, VMALLOC_END,
 				    GFP_SCS, PAGE_KERNEL, 0, node,
 				    __builtin_return_address(0));
+
+out:
+	return kasan_reset_tag(s);
 }
 
 void *scs_alloc(int node)
@@ -78,7 +82,7 @@ void scs_free(void *s)
 		if (this_cpu_cmpxchg(scs_cache[i], 0, s) == NULL)
 			return;
 
-	kasan_unpoison_vmalloc(s, SCS_SIZE, KASAN_VMALLOC_NONE);
+	kasan_unpoison_vmalloc(s, SCS_SIZE, KASAN_VMALLOC_PROT_NORMAL);
 	vfree_atomic(s);
 }
 
--- a/mm/kasan/hw_tags.c~kasan-vmalloc-only-tag-normal-vmalloc-allocations
+++ a/mm/kasan/hw_tags.c
@@ -247,6 +247,13 @@ void *__kasan_unpoison_vmalloc(const voi
 	if (!(flags & KASAN_VMALLOC_VM_ALLOC))
 		return (void *)start;
 
+	/*
+	 * Don't tag executable memory.
+	 * The kernel doesn't tolerate having the PC register tagged.
+	 */
+	if (!(flags & KASAN_VMALLOC_PROT_NORMAL))
+		return (void *)start;
+
 	tag = kasan_random_tag();
 	start = set_tag(start, tag);
 
--- a/mm/kasan/shadow.c~kasan-vmalloc-only-tag-normal-vmalloc-allocations
+++ a/mm/kasan/shadow.c
@@ -488,6 +488,14 @@ void *__kasan_unpoison_vmalloc(const voi
 	if (!is_vmalloc_or_module_addr(start))
 		return (void *)start;
 
+	/*
+	 * Don't tag executable memory with the tag-based mode.
+	 * The kernel doesn't tolerate having the PC register tagged.
+	 */
+	if (IS_ENABLED(CONFIG_KASAN_SW_TAGS) &&
+	    !(flags & KASAN_VMALLOC_PROT_NORMAL))
+		return (void *)start;
+
 	start = set_tag(start, kasan_random_tag());
 	kasan_unpoison(start, size, false);
 	return (void *)start;
--- a/mm/vmalloc.c~kasan-vmalloc-only-tag-normal-vmalloc-allocations
+++ a/mm/vmalloc.c
@@ -2242,7 +2242,7 @@ void *vm_map_ram(struct page **pages, un
 	 * With hardware tag-based KASAN, marking is skipped for
 	 * non-VM_ALLOC mappings, see __kasan_unpoison_vmalloc().
 	 */
-	mem = kasan_unpoison_vmalloc(mem, size, KASAN_VMALLOC_NONE);
+	mem = kasan_unpoison_vmalloc(mem, size, KASAN_VMALLOC_PROT_NORMAL);
 
 	return mem;
 }
@@ -2481,7 +2481,7 @@ static struct vm_struct *__get_vm_area_n
 	 */
 	if (!(flags & VM_ALLOC))
 		area->addr = kasan_unpoison_vmalloc(area->addr, requested_size,
-							KASAN_VMALLOC_NONE);
+						    KASAN_VMALLOC_PROT_NORMAL);
 
 	return area;
 }
@@ -3091,7 +3091,7 @@ void *__vmalloc_node_range(unsigned long
 {
 	struct vm_struct *area;
 	void *ret;
-	kasan_vmalloc_flags_t kasan_flags;
+	kasan_vmalloc_flags_t kasan_flags = KASAN_VMALLOC_NONE;
 	unsigned long real_size = size;
 	unsigned long real_align = align;
 	unsigned int shift = PAGE_SHIFT;
@@ -3144,21 +3144,28 @@ again:
 		goto fail;
 	}
 
-	/* Prepare arguments for __vmalloc_area_node(). */
-	if (kasan_hw_tags_enabled() &&
-	    pgprot_val(prot) == pgprot_val(PAGE_KERNEL)) {
-		/*
-		 * Modify protection bits to allow tagging.
-		 * This must be done before mapping in __vmalloc_area_node().
-		 */
-		prot = arch_vmap_pgprot_tagged(prot);
+	/*
+	 * Prepare arguments for __vmalloc_area_node() and
+	 * kasan_unpoison_vmalloc().
+	 */
+	if (pgprot_val(prot) == pgprot_val(PAGE_KERNEL)) {
+		if (kasan_hw_tags_enabled()) {
+			/*
+			 * Modify protection bits to allow tagging.
+			 * This must be done before mapping.
+			 */
+			prot = arch_vmap_pgprot_tagged(prot);
 
-		/*
-		 * Skip page_alloc poisoning and zeroing for physical pages
-		 * backing VM_ALLOC mapping. Memory is instead poisoned and
-		 * zeroed by kasan_unpoison_vmalloc().
-		 */
-		gfp_mask |= __GFP_SKIP_KASAN_UNPOISON | __GFP_SKIP_ZERO;
+			/*
+			 * Skip page_alloc poisoning and zeroing for physical
+			 * pages backing VM_ALLOC mapping. Memory is instead
+			 * poisoned and zeroed by kasan_unpoison_vmalloc().
+			 */
+			gfp_mask |= __GFP_SKIP_KASAN_UNPOISON | __GFP_SKIP_ZERO;
+		}
+
+		/* Take note that the mapping is PAGE_KERNEL. */
+		kasan_flags |= KASAN_VMALLOC_PROT_NORMAL;
 	}
 
 	/* Allocate physical pages and map them into vmalloc space. */
@@ -3172,10 +3179,13 @@ again:
 	 * (except for the should_skip_init() check) to make sure that memory
 	 * is initialized under the same conditions regardless of the enabled
 	 * KASAN mode.
+	 * Tag-based KASAN modes only assign tags to normal non-executable
+	 * allocations, see __kasan_unpoison_vmalloc().
 	 */
-	kasan_flags = KASAN_VMALLOC_VM_ALLOC;
+	kasan_flags |= KASAN_VMALLOC_VM_ALLOC;
 	if (!want_init_on_free() && want_init_on_alloc(gfp_mask))
 		kasan_flags |= KASAN_VMALLOC_INIT;
+	/* KASAN_VMALLOC_PROT_NORMAL already set if required. */
 	area->addr = kasan_unpoison_vmalloc(area->addr, real_size, kasan_flags);
 
 	/*
@@ -3881,8 +3891,7 @@ retry:
 	 */
 	for (area = 0; area < nr_vms; area++)
 		vms[area]->addr = kasan_unpoison_vmalloc(vms[area]->addr,
-							 vms[area]->size,
-							 KASAN_VMALLOC_NONE);
+				vms[area]->size, KASAN_VMALLOC_PROT_NORMAL);
 
 	kfree(vas);
 	return vms;
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

