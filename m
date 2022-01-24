Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A509C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 03:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S246230AbiAYDqO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jan 2022 22:46:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3415230AbiAYA7U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jan 2022 19:59:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D69C06B58B
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 14:44:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B9FE614E1
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 22:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183A3C340E4;
        Mon, 24 Jan 2022 22:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643064176;
        bh=oz2Rmm0oTU/8c2h9dUPA9Nh5KipzUsC4VUGSXOzv7bI=;
        h=Date:From:To:Subject:From;
        b=FBAnxAWpgj2I2u3BKkfm46gS0mTiaJAvvtD2DY0M091aNJ5vP2AvWjPbPwvrksv9I
         bv5Ti2z0w3HtUZU3QXwJiyzqjrIS9NeOgCeiPjLaRU0qFVJcY0rPFfHwptm8Sh8qQW
         ylalm/bds+pnMs2d5uZOFcXcNeIMoBxzl9Bohz+o=
Date:   Mon, 24 Jan 2022 14:42:55 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, catalin.marinas@arm.com, dvyukov@google.com,
        elver@google.com, eugenis@google.com, glider@google.com,
        mark.rutland@arm.com, mm-commits@vger.kernel.org, pcc@google.com,
        ryabinin.a.a@gmail.com, vincenzo.frascino@arm.com, will@kernel.org
Subject:  +
 kasan-vmalloc-unpoison-vm_alloc-pages-after-mapping.patch added to -mm tree
Message-ID: <20220124224255.SJ72e4zpn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, vmalloc: unpoison VM_ALLOC pages after mapping
has been added to the -mm tree.  Its filename is
     kasan-vmalloc-unpoison-vm_alloc-pages-after-mapping.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-vmalloc-unpoison-vm_alloc-pages-after-mapping.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-vmalloc-unpoison-vm_alloc-pages-after-mapping.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, vmalloc: unpoison VM_ALLOC pages after mapping

Make KASAN unpoison vmalloc mappings after they have been mapped in when
it's possible: for vmalloc() (indentified via VM_ALLOC) and vm_map_ram().

The reasons for this are:

- For vmalloc() and vm_map_ram(): pages don't get unpoisoned in case
  mapping them fails.
- For vmalloc(): HW_TAGS KASAN needs pages to be mapped to set tags via
  kasan_unpoison_vmalloc().

As a part of these changes, the return value of __vmalloc_node_range() is
changed to area->addr.  This is a non-functional change, as
__vmalloc_area_node() returns area->addr anyway.

Link: https://lkml.kernel.org/r/fcb98980e6fcd3c4be6acdcb5d6110898ef28548.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: Marco Elver <elver@google.com>
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

 mm/vmalloc.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

--- a/mm/vmalloc.c~kasan-vmalloc-unpoison-vm_alloc-pages-after-mapping
+++ a/mm/vmalloc.c
@@ -2210,14 +2210,15 @@ void *vm_map_ram(struct page **pages, un
 		mem = (void *)addr;
 	}
 
-	mem = kasan_unpoison_vmalloc(mem, size);
-
 	if (vmap_pages_range(addr, addr + size, PAGE_KERNEL,
 				pages, PAGE_SHIFT) < 0) {
 		vm_unmap_ram(mem, count);
 		return NULL;
 	}
 
+	/* Mark the pages as accessible, now that they are mapped. */
+	mem = kasan_unpoison_vmalloc(mem, size);
+
 	return mem;
 }
 EXPORT_SYMBOL(vm_map_ram);
@@ -2445,7 +2446,14 @@ static struct vm_struct *__get_vm_area_n
 
 	setup_vmalloc_vm(area, va, flags, caller);
 
-	area->addr = kasan_unpoison_vmalloc(area->addr, requested_size);
+	/*
+	 * Mark pages for non-VM_ALLOC mappings as accessible. Do it now as a
+	 * best-effort approach, as they can be mapped outside of vmalloc code.
+	 * For VM_ALLOC mappings, the pages are marked as accessible after
+	 * getting mapped in __vmalloc_node_range().
+	 */
+	if (!(flags & VM_ALLOC))
+		area->addr = kasan_unpoison_vmalloc(area->addr, requested_size);
 
 	return area;
 }
@@ -3055,7 +3063,7 @@ void *__vmalloc_node_range(unsigned long
 			const void *caller)
 {
 	struct vm_struct *area;
-	void *addr;
+	void *ret;
 	unsigned long real_size = size;
 	unsigned long real_align = align;
 	unsigned int shift = PAGE_SHIFT;
@@ -3117,10 +3125,13 @@ again:
 		prot = arch_vmap_pgprot_tagged(prot);
 
 	/* Allocate physical pages and map them into vmalloc space. */
-	addr = __vmalloc_area_node(area, gfp_mask, prot, shift, node);
-	if (!addr)
+	ret = __vmalloc_area_node(area, gfp_mask, prot, shift, node);
+	if (!ret)
 		goto fail;
 
+	/* Mark the pages as accessible, now that they are mapped. */
+	area->addr = kasan_unpoison_vmalloc(area->addr, real_size);
+
 	/*
 	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED
 	 * flag. It means that vm_struct is not fully initialized.
@@ -3132,7 +3143,7 @@ again:
 	if (!(vm_flags & VM_DEFER_KMEMLEAK))
 		kmemleak_vmalloc(area, size, gfp_mask);
 
-	return addr;
+	return area->addr;
 
 fail:
 	if (shift > PAGE_SHIFT) {
@@ -3816,7 +3827,10 @@ retry:
 	}
 	spin_unlock(&vmap_area_lock);
 
-	/* mark allocated areas as accessible */
+	/*
+	 * Mark allocated areas as accessible. Do it now as a best-effort
+	 * approach, as they can be mapped outside of vmalloc code.
+	 */
 	for (area = 0; area < nr_vms; area++)
 		vms[area]->addr = kasan_unpoison_vmalloc(vms[area]->addr,
 							 vms[area]->size);
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-page_alloc-deduplicate-should_skip_kasan_poison.patch
kasan-page_alloc-move-tag_clear_highpage-out-of-kernel_init_free_pages.patch
kasan-page_alloc-merge-kasan_free_pages-into-free_pages_prepare.patch
kasan-page_alloc-simplify-kasan_poison_pages-call-site.patch
kasan-page_alloc-init-memory-of-skipped-pages-on-free.patch
kasan-drop-skip_kasan_poison-variable-in-free_pages_prepare.patch
mm-clarify-__gfp_zerotags-comment.patch
kasan-only-apply-__gfp_zerotags-when-memory-is-zeroed.patch
kasan-page_alloc-refactor-init-checks-in-post_alloc_hook.patch
kasan-page_alloc-merge-kasan_alloc_pages-into-post_alloc_hook.patch
kasan-page_alloc-combine-tag_clear_highpage-calls-in-post_alloc_hook.patch
kasan-page_alloc-move-setpageskipkasanpoison-in-post_alloc_hook.patch
kasan-page_alloc-move-kernel_init_free_pages-in-post_alloc_hook.patch
kasan-page_alloc-rework-kasan_unpoison_pages-call-site.patch
kasan-clean-up-metadata-byte-definitions.patch
kasan-define-kasan_vmalloc_invalid-for-sw_tags.patch
kasan-x86-arm64-s390-rename-functions-for-modules-shadow.patch
kasan-vmalloc-drop-outdated-vm_kasan-comment.patch
kasan-reorder-vmalloc-hooks.patch
kasan-add-wrappers-for-vmalloc-hooks.patch
kasan-vmalloc-reset-tags-in-vmalloc-functions.patch
kasan-fork-reset-pointer-tags-of-vmapped-stacks.patch
kasan-arm64-reset-pointer-tags-of-vmapped-stacks.patch
kasan-vmalloc-add-vmalloc-tagging-for-sw_tags.patch
kasan-vmalloc-arm64-mark-vmalloc-mappings-as-pgprot_tagged.patch
kasan-vmalloc-unpoison-vm_alloc-pages-after-mapping.patch
kasan-mm-only-define-___gfp_skip_kasan_poison-with-hw_tags.patch
kasan-page_alloc-allow-skipping-unpoisoning-for-hw_tags.patch
kasan-page_alloc-allow-skipping-memory-init-for-hw_tags.patch
kasan-vmalloc-add-vmalloc-tagging-for-hw_tags.patch
kasan-vmalloc-only-tag-normal-vmalloc-allocations.patch
kasan-arm64-dont-tag-executable-vmalloc-allocations.patch
kasan-mark-kasan_arg_stacktrace-as-__initdata.patch
kasan-clean-up-feature-flags-for-hw_tags-mode.patch
kasan-add-kasanvmalloc-command-line-flag.patch
kasan-allow-enabling-kasan_vmalloc-and-sw-hw_tags.patch
arm64-select-kasan_vmalloc-for-sw-hw_tags-modes.patch
kasan-documentation-updates.patch
kasan-improve-vmalloc-tests.patch

