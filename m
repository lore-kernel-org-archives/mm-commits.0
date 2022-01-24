Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87682C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jan 2022 23:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579863AbiAXXIk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jan 2022 18:08:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46509 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1837381AbiAXWn7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jan 2022 17:43:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47C9461465
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 22:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A78CC340E7;
        Mon, 24 Jan 2022 22:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643064173;
        bh=ZbD489G+G8cHsx7BnQfeLnh1jaSHDAr515OEtoheGoI=;
        h=Date:From:To:Subject:From;
        b=Eq+ntUA6xyrFhBzXLCPbSSuj+L+fwaiI3rjICC39y9e0Uw7+J9w+7+XWXmyAQ8Fvs
         HbadU7b84YHl2vL+Y1/UuBhCYNG75iJIuUlBBJqq6XRc061Mdsys5HkVhiNsr3rEQU
         jsYR+WYgZhPR7E52YYcx0WexHqA5TOZqACuqZ1hw=
Date:   Mon, 24 Jan 2022 14:42:52 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, catalin.marinas@arm.com, dvyukov@google.com,
        elver@google.com, eugenis@google.com, glider@google.com,
        mark.rutland@arm.com, mm-commits@vger.kernel.org, pcc@google.com,
        ryabinin.a.a@gmail.com, vincenzo.frascino@arm.com, will@kernel.org
Subject:  +
 kasan-vmalloc-arm64-mark-vmalloc-mappings-as-pgprot_tagged.patch added to
 -mm tree
Message-ID: <20220124224252.y_Tgie4DW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, vmalloc, arm64: mark vmalloc mappings as pgprot_tagged
has been added to the -mm tree.  Its filename is
     kasan-vmalloc-arm64-mark-vmalloc-mappings-as-pgprot_tagged.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-vmalloc-arm64-mark-vmalloc-mappings-as-pgprot_tagged.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-vmalloc-arm64-mark-vmalloc-mappings-as-pgprot_tagged.patch

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
Subject: kasan, vmalloc, arm64: mark vmalloc mappings as pgprot_tagged

HW_TAGS KASAN relies on ARM Memory Tagging Extension (MTE).  With MTE, a
memory region must be mapped as MT_NORMAL_TAGGED to allow setting memory
tags via MTE-specific instructions.

Add proper protection bits to vmalloc() allocations.  These allocations
are always backed by page_alloc pages, so the tags will actually be
getting set on the corresponding physical memory.

Link: https://lkml.kernel.org/r/983fc33542db2f6b1e77b34ca23448d4640bbb9e.1643047180.git.andreyknvl@google.com
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

 arch/arm64/include/asm/vmalloc.h |    6 ++++++
 include/linux/vmalloc.h          |    7 +++++++
 mm/vmalloc.c                     |    9 +++++++++
 3 files changed, 22 insertions(+)

--- a/arch/arm64/include/asm/vmalloc.h~kasan-vmalloc-arm64-mark-vmalloc-mappings-as-pgprot_tagged
+++ a/arch/arm64/include/asm/vmalloc.h
@@ -25,4 +25,10 @@ static inline bool arch_vmap_pmd_support
 
 #endif
 
+#define arch_vmap_pgprot_tagged arch_vmap_pgprot_tagged
+static inline pgprot_t arch_vmap_pgprot_tagged(pgprot_t prot)
+{
+	return pgprot_tagged(prot);
+}
+
 #endif /* _ASM_ARM64_VMALLOC_H */
--- a/include/linux/vmalloc.h~kasan-vmalloc-arm64-mark-vmalloc-mappings-as-pgprot_tagged
+++ a/include/linux/vmalloc.h
@@ -115,6 +115,13 @@ static inline int arch_vmap_pte_supporte
 }
 #endif
 
+#ifndef arch_vmap_pgprot_tagged
+static inline pgprot_t arch_vmap_pgprot_tagged(pgprot_t prot)
+{
+	return prot;
+}
+#endif
+
 /*
  *	Highlevel APIs for driver use
  */
--- a/mm/vmalloc.c~kasan-vmalloc-arm64-mark-vmalloc-mappings-as-pgprot_tagged
+++ a/mm/vmalloc.c
@@ -3108,6 +3108,15 @@ again:
 		goto fail;
 	}
 
+	/*
+	 * Modify protection bits to allow tagging.
+	 * This must be done before mapping by __vmalloc_area_node().
+	 */
+	if (kasan_hw_tags_enabled() &&
+	    pgprot_val(prot) == pgprot_val(PAGE_KERNEL))
+		prot = arch_vmap_pgprot_tagged(prot);
+
+	/* Allocate physical pages and map them into vmalloc space. */
 	addr = __vmalloc_area_node(area, gfp_mask, prot, shift, node);
 	if (!addr)
 		goto fail;
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

