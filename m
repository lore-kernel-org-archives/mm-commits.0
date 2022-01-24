Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E2EC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jan 2022 23:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1844194AbiAXXIH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jan 2022 18:08:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45010 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1837118AbiAXWmV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jan 2022 17:42:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F2FA612FC
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 22:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED62C340E4;
        Mon, 24 Jan 2022 22:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643064139;
        bh=X35tc/huuc+jd34cwOYSiV5T3no4KOOdgZ2QFMOPe7w=;
        h=Date:From:To:Subject:From;
        b=VoOQS/PUsiXQbnxX8926ZKeAPGiYj380WPNmwJu3wKFZFpYuduNBT/aYYLxOvLoqe
         hLeS0NbIk408YyBVIqAhexjkrqrLJnZSB12jbU6L8WKExsY2SdDfPwFaj0yJLdQ4Za
         g24RYVzhRdSVKlHB/DqKBJuKhve8XGwZ/ahB/ko4=
Date:   Mon, 24 Jan 2022 14:42:18 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, catalin.marinas@arm.com, dvyukov@google.com,
        elver@google.com, eugenis@google.com, glider@google.com,
        mark.rutland@arm.com, mm-commits@vger.kernel.org, pcc@google.com,
        ryabinin.a.a@gmail.com, vincenzo.frascino@arm.com, will@kernel.org
Subject:  +
 kasan-page_alloc-rework-kasan_unpoison_pages-call-site.patch added to -mm
 tree
Message-ID: <20220124224218.9sbUrMBtb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, page_alloc: rework kasan_unpoison_pages call site
has been added to the -mm tree.  Its filename is
     kasan-page_alloc-rework-kasan_unpoison_pages-call-site.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-page_alloc-rework-kasan_unpoison_pages-call-site.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-page_alloc-rework-kasan_unpoison_pages-call-site.patch

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
Subject: kasan, page_alloc: rework kasan_unpoison_pages call site

Rework the checks around kasan_unpoison_pages() call in post_alloc_hook().

The logical condition for calling this function is:

- If a software KASAN mode is enabled, we need to mark shadow memory.
- Otherwise, HW_TAGS KASAN is enabled, and it only makes sense to
  set tags if they haven't already been cleared by tag_clear_highpage(),
  which is indicated by init_tags.

This patch concludes the changes for post_alloc_hook().

Link: https://lkml.kernel.org/r/0ecebd0d7ccd79150e3620ea4185a32d3dfe912f.1643047180.git.andreyknvl@google.com
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

 mm/page_alloc.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/mm/page_alloc.c~kasan-page_alloc-rework-kasan_unpoison_pages-call-site
+++ a/mm/page_alloc.c
@@ -2434,15 +2434,20 @@ inline void post_alloc_hook(struct page
 		/* Note that memory is already initialized by the loop above. */
 		init = false;
 	}
-	if (kasan_has_integrated_init()) {
-		if (!init_tags) {
-			kasan_unpoison_pages(page, order, init);
+	/*
+	 * If either a software KASAN mode is enabled, or,
+	 * in the case of hardware tag-based KASAN,
+	 * if memory tags have not been cleared via tag_clear_highpage().
+	 */
+	if (IS_ENABLED(CONFIG_KASAN_GENERIC) ||
+	    IS_ENABLED(CONFIG_KASAN_SW_TAGS) ||
+	    kasan_hw_tags_enabled() && !init_tags) {
+		/* Mark shadow memory or set memory tags. */
+		kasan_unpoison_pages(page, order, init);
 
-			/* Note that memory is already initialized by KASAN. */
+		/* Note that memory is already initialized by KASAN. */
+		if (kasan_has_integrated_init())
 			init = false;
-		}
-	} else {
-		kasan_unpoison_pages(page, order, init);
 	}
 	/* If memory is still not initialized, do it now. */
 	if (init)
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

