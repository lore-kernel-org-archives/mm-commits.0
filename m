Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C6C4C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 00:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359220AbiAYAeL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jan 2022 19:34:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44852 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1837041AbiAXWmG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jan 2022 17:42:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14AED61444
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 22:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EF4C340E4;
        Mon, 24 Jan 2022 22:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643064124;
        bh=ZKdepm9xFF0OoV9cxinE1wcz6Pjo+Q5Aw3KwdiiOvXw=;
        h=Date:From:To:Subject:From;
        b=tX39j7LXGKKbidKNbx5Iiuco2YWomOG0tq0e2yYq9zHr9WP2m0sVLvWdJwjHHM1W2
         bE1zWOUSJZd1JXAjn3tNaGgqY8gwzpuhgmlBEJwqxXxDI7kL8NsKh1AIwTmaiCIQQL
         BnC8oOXJwWk43FiKq+EyI+KEoSAbEfTPHjDlEx6U=
Date:   Mon, 24 Jan 2022 14:42:03 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, catalin.marinas@arm.com, dvyukov@google.com,
        elver@google.com, eugenis@google.com, glider@google.com,
        mark.rutland@arm.com, mm-commits@vger.kernel.org, pcc@google.com,
        ryabinin.a.a@gmail.com, vincenzo.frascino@arm.com, will@kernel.org
Subject:  +
 kasan-page_alloc-refactor-init-checks-in-post_alloc_hook.patch added to -mm
 tree
Message-ID: <20220124224203.rUei14V7C%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, page_alloc: refactor init checks in post_alloc_hook
has been added to the -mm tree.  Its filename is
     kasan-page_alloc-refactor-init-checks-in-post_alloc_hook.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-page_alloc-refactor-init-checks-in-post_alloc_hook.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-page_alloc-refactor-init-checks-in-post_alloc_hook.patch

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
Subject: kasan, page_alloc: refactor init checks in post_alloc_hook

Separate code for zeroing memory from the code clearing tags in
post_alloc_hook().

This patch is not useful by itself but makes the simplifications in the
following patches easier to follow.

This patch does no functional changes.

Link: https://lkml.kernel.org/r/2283fde963adfd8a2b29a92066f106cc16661a3c.1643047180.git.andreyknvl@google.com
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

 mm/page_alloc.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/mm/page_alloc.c~kasan-page_alloc-refactor-init-checks-in-post_alloc_hook
+++ a/mm/page_alloc.c
@@ -2420,19 +2420,21 @@ inline void post_alloc_hook(struct page
 		kasan_alloc_pages(page, order, gfp_flags);
 	} else {
 		bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags);
+		bool init_tags = init && (gfp_flags & __GFP_ZEROTAGS);
 
 		kasan_unpoison_pages(page, order, init);
 
-		if (init) {
-			if (gfp_flags & __GFP_ZEROTAGS) {
-				int i;
-
-				for (i = 0; i < 1 << order; i++)
-					tag_clear_highpage(page + i);
-			} else {
-				kernel_init_free_pages(page, 1 << order);
-			}
+		if (init_tags) {
+			int i;
+
+			for (i = 0; i < 1 << order; i++)
+				tag_clear_highpage(page + i);
+
+			init = false;
 		}
+
+		if (init)
+			kernel_init_free_pages(page, 1 << order);
 	}
 
 	set_page_owner(page, order, gfp_flags);
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

