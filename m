Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66016C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 03:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386785AbiAYDpG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jan 2022 22:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3415023AbiAYAzT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jan 2022 19:55:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAF6C0612F2
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 14:41:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EC29B81257
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 22:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B45C340E4;
        Mon, 24 Jan 2022 22:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643064100;
        bh=uxY08+cQBuDHHtYrm5qkZB0pBEbiw9K/IJvW2slJ9Fw=;
        h=Date:From:To:Subject:From;
        b=fD7qLRoKHo2G4E3r0EYlefVVvmEenH2JI69MiLJctDzkVwvdoR8jexLYc3+MZgkDu
         mpEnmhfP8KwFJp60iVzeWerL8XZmHdr2yDENr4GEeo/7rsX2mfpnHAY3jxtZvf4KSM
         jAmQuwCwSIXhTIBrit5EAlf3eXXNON/JxPAf0b5A=
Date:   Mon, 24 Jan 2022 14:41:39 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, catalin.marinas@arm.com, dvyukov@google.com,
        elver@google.com, eugenis@google.com, glider@google.com,
        mark.rutland@arm.com, mm-commits@vger.kernel.org, pcc@google.com,
        ryabinin.a.a@gmail.com, vincenzo.frascino@arm.com, will@kernel.org
Subject:  +
 kasan-page_alloc-deduplicate-should_skip_kasan_poison.patch added to -mm
 tree
Message-ID: <20220124224139.dpWRcQpq5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, page_alloc: deduplicate should_skip_kasan_poison
has been added to the -mm tree.  Its filename is
     kasan-page_alloc-deduplicate-should_skip_kasan_poison.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-page_alloc-deduplicate-should_skip_kasan_poison.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-page_alloc-deduplicate-should_skip_kasan_poison.patch

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
Subject: kasan, page_alloc: deduplicate should_skip_kasan_poison

Patch series "kasan, vmalloc, arm64: add vmalloc tagging support for SW/HW_TAGS", v6.

This patchset adds vmalloc tagging support for SW_TAGS and HW_TAGS
KASAN modes.

About half of patches are cleanups I went for along the way.  None of them
seem to be important enough to go through stable, so I decided not to
split them out into separate patches/series.

The patchset is partially based on an early version of the HW_TAGS
patchset by Vincenzo that had vmalloc support.  Thus, I added a
Co-developed-by tag into a few patches.

SW_TAGS vmalloc tagging support is straightforward.  It reuses all of the
generic KASAN machinery, but uses shadow memory to store tags instead of
magic values.  Naturally, vmalloc tagging requires adding a few
kasan_reset_tag() annotations to the vmalloc code.

HW_TAGS vmalloc tagging support stands out.  HW_TAGS KASAN is based on Arm
MTE, which can only assigns tags to physical memory.  As a result, HW_TAGS
KASAN only tags vmalloc() allocations, which are backed by page_alloc
memory.  It ignores vmap() and others.


This patch (of 39):

Currently, should_skip_kasan_poison() has two definitions: one for when
CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, one for when it's not.

Instead of duplicating the checks, add a deferred_pages_enabled() helper
and use it in a single should_skip_kasan_poison() definition.

Also move should_skip_kasan_poison() closer to its caller and clarify all
conditions in the comment.

Link: https://lkml.kernel.org/r/cover.1643047180.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/658b79f5fb305edaf7dc16bc52ea870d3220d4a8.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   55 +++++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 22 deletions(-)

--- a/mm/page_alloc.c~kasan-page_alloc-deduplicate-should_skip_kasan_poison
+++ a/mm/page_alloc.c
@@ -378,25 +378,9 @@ int page_group_by_mobility_disabled __re
  */
 static DEFINE_STATIC_KEY_TRUE(deferred_pages);
 
-/*
- * Calling kasan_poison_pages() only after deferred memory initialization
- * has completed. Poisoning pages during deferred memory init will greatly
- * lengthen the process and cause problem in large memory systems as the
- * deferred pages initialization is done with interrupt disabled.
- *
- * Assuming that there will be no reference to those newly initialized
- * pages before they are ever allocated, this should have no effect on
- * KASAN memory tracking as the poison will be properly inserted at page
- * allocation time. The only corner case is when pages are allocated by
- * on-demand allocation and then freed again before the deferred pages
- * initialization is done, but this is not likely to happen.
- */
-static inline bool should_skip_kasan_poison(struct page *page, fpi_t fpi_flags)
+static inline bool deferred_pages_enabled(void)
 {
-	return static_branch_unlikely(&deferred_pages) ||
-	       (!IS_ENABLED(CONFIG_KASAN_GENERIC) &&
-		(fpi_flags & FPI_SKIP_KASAN_POISON)) ||
-	       PageSkipKASanPoison(page);
+	return static_branch_unlikely(&deferred_pages);
 }
 
 /* Returns true if the struct page for the pfn is uninitialised */
@@ -447,11 +431,9 @@ defer_init(int nid, unsigned long pfn, u
 	return false;
 }
 #else
-static inline bool should_skip_kasan_poison(struct page *page, fpi_t fpi_flags)
+static inline bool deferred_pages_enabled(void)
 {
-	return (!IS_ENABLED(CONFIG_KASAN_GENERIC) &&
-		(fpi_flags & FPI_SKIP_KASAN_POISON)) ||
-	       PageSkipKASanPoison(page);
+	return false;
 }
 
 static inline bool early_page_uninitialised(unsigned long pfn)
@@ -1271,6 +1253,35 @@ out:
 	return ret;
 }
 
+/*
+ * Skip KASAN memory poisoning when either:
+ *
+ * 1. Deferred memory initialization has not yet completed,
+ *    see the explanation below.
+ * 2. Skipping poisoning is requested via FPI_SKIP_KASAN_POISON,
+ *    see the comment next to it.
+ * 3. Skipping poisoning is requested via __GFP_SKIP_KASAN_POISON,
+ *    see the comment next to it.
+ *
+ * Poisoning pages during deferred memory init will greatly lengthen the
+ * process and cause problem in large memory systems as the deferred pages
+ * initialization is done with interrupt disabled.
+ *
+ * Assuming that there will be no reference to those newly initialized
+ * pages before they are ever allocated, this should have no effect on
+ * KASAN memory tracking as the poison will be properly inserted at page
+ * allocation time. The only corner case is when pages are allocated by
+ * on-demand allocation and then freed again before the deferred pages
+ * initialization is done, but this is not likely to happen.
+ */
+static inline bool should_skip_kasan_poison(struct page *page, fpi_t fpi_flags)
+{
+	return deferred_pages_enabled() ||
+	       (!IS_ENABLED(CONFIG_KASAN_GENERIC) &&
+		(fpi_flags & FPI_SKIP_KASAN_POISON)) ||
+	       PageSkipKASanPoison(page);
+}
+
 static void kernel_init_free_pages(struct page *page, int numpages, bool zero_tags)
 {
 	int i;
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

