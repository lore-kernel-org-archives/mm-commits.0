Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B353C43334
	for <mm-commits@archiver.kernel.org>; Thu,  9 Jun 2022 18:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344842AbiFISp5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Jun 2022 14:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239383AbiFISp5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2022 14:45:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0583422938D
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 11:45:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 994C8B82F72
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 18:45:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2342EC34114;
        Thu,  9 Jun 2022 18:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654800353;
        bh=yNRwGlpomjk0RJzIU471GGPJsHSg0nZqhi3lAN+h9aE=;
        h=Date:To:From:Subject:From;
        b=11CGYArBuQMe+scwrBwBJsKznFGYtl25YsouhEe40dYo8ZjpRD+GayLvpbDNTmpoi
         Onm2Qs3lkjQaGC40JyeVbZbQFjgTY5koxmAgzRz9y1yAWPwxT7M+xMeOG6XpR1PXT6
         QRIV/GfRbiZN1JhR7IOAe3iNzQyJzyncdDVS37o0=
Date:   Thu, 09 Jun 2022 11:45:52 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fix-zeroing-vmalloc-memory-with-hw_tags.patch added to mm-unstable branch
Message-Id: <20220609184553.2342EC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix zeroing vmalloc memory with HW_TAGS
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-fix-zeroing-vmalloc-memory-with-hw_tags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-fix-zeroing-vmalloc-memory-with-hw_tags.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: fix zeroing vmalloc memory with HW_TAGS
Date: Thu, 9 Jun 2022 20:18:47 +0200

HW_TAGS KASAN skips zeroing page_alloc allocations backing vmalloc
mappings via __GFP_SKIP_ZERO.  Instead, these pages are zeroed via
kasan_unpoison_vmalloc() by passing the KASAN_VMALLOC_INIT flag.

The problem is that __kasan_unpoison_vmalloc() does not zero pages when
either kasan_vmalloc_enabled() or is_vmalloc_or_module_addr() fail.

Thus:

1. Change __vmalloc_node_range() to only set KASAN_VMALLOC_INIT when
   __GFP_SKIP_ZERO is set.

2. Change __kasan_unpoison_vmalloc() to always zero pages when the
   KASAN_VMALLOC_INIT flag is set.

3. Add WARN_ON() asserts to check that KASAN_VMALLOC_INIT cannot be set
   in other early return paths of __kasan_unpoison_vmalloc().

Also clean up the comment in __kasan_unpoison_vmalloc.

Link: https://lkml.kernel.org/r/4bc503537efdc539ffc3f461c1b70162eea31cf6.1654798516.git.andreyknvl@google.com
Fixes: 23689e91fb22 ("kasan, vmalloc: add vmalloc tagging for HW_TAGS")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/hw_tags.c |   32 +++++++++++++++++++++++---------
 mm/vmalloc.c       |   10 +++++-----
 2 files changed, 28 insertions(+), 14 deletions(-)

--- a/mm/kasan/hw_tags.c~kasan-fix-zeroing-vmalloc-memory-with-hw_tags
+++ a/mm/kasan/hw_tags.c
@@ -257,27 +257,37 @@ static void unpoison_vmalloc_pages(const
 	}
 }
 
+static void init_vmalloc_pages(const void *start, unsigned long size)
+{
+	const void *addr;
+
+	for (addr = start; addr < start + size; addr += PAGE_SIZE) {
+		struct page *page = virt_to_page(addr);
+
+		clear_highpage_kasan_tagged(page);
+	}
+}
+
 void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
 				kasan_vmalloc_flags_t flags)
 {
 	u8 tag;
 	unsigned long redzone_start, redzone_size;
 
-	if (!kasan_vmalloc_enabled())
-		return (void *)start;
-
-	if (!is_vmalloc_or_module_addr(start))
+	if (!kasan_vmalloc_enabled() || !is_vmalloc_or_module_addr(start)) {
+		if (flags & KASAN_VMALLOC_INIT)
+			init_vmalloc_pages(start, size);
 		return (void *)start;
+	}
 
 	/*
-	 * Skip unpoisoning and assigning a pointer tag for non-VM_ALLOC
-	 * mappings as:
+	 * Don't tag non-VM_ALLOC mappings, as:
 	 *
 	 * 1. Unlike the software KASAN modes, hardware tag-based KASAN only
 	 *    supports tagging physical memory. Therefore, it can only tag a
 	 *    single mapping of normal physical pages.
 	 * 2. Hardware tag-based KASAN can only tag memory mapped with special
-	 *    mapping protection bits, see arch_vmalloc_pgprot_modify().
+	 *    mapping protection bits, see arch_vmap_pgprot_tagged().
 	 *    As non-VM_ALLOC mappings can be mapped outside of vmalloc code,
 	 *    providing these bits would require tracking all non-VM_ALLOC
 	 *    mappers.
@@ -289,15 +299,19 @@ void *__kasan_unpoison_vmalloc(const voi
 	 *
 	 * For non-VM_ALLOC allocations, page_alloc memory is tagged as usual.
 	 */
-	if (!(flags & KASAN_VMALLOC_VM_ALLOC))
+	if (!(flags & KASAN_VMALLOC_VM_ALLOC)) {
+		WARN_ON(flags & KASAN_VMALLOC_INIT);
 		return (void *)start;
+	}
 
 	/*
 	 * Don't tag executable memory.
 	 * The kernel doesn't tolerate having the PC register tagged.
 	 */
-	if (!(flags & KASAN_VMALLOC_PROT_NORMAL))
+	if (!(flags & KASAN_VMALLOC_PROT_NORMAL)) {
+		WARN_ON(flags & KASAN_VMALLOC_INIT);
 		return (void *)start;
+	}
 
 	tag = kasan_random_tag();
 	start = set_tag(start, tag);
--- a/mm/vmalloc.c~kasan-fix-zeroing-vmalloc-memory-with-hw_tags
+++ a/mm/vmalloc.c
@@ -3167,15 +3167,15 @@ again:
 
 	/*
 	 * Mark the pages as accessible, now that they are mapped.
-	 * The init condition should match the one in post_alloc_hook()
-	 * (except for the should_skip_init() check) to make sure that memory
-	 * is initialized under the same conditions regardless of the enabled
-	 * KASAN mode.
+	 * The condition for setting KASAN_VMALLOC_INIT should complement the
+	 * one in post_alloc_hook() with regards to the __GFP_SKIP_ZERO check
+	 * to make sure that memory is initialized under the same conditions.
 	 * Tag-based KASAN modes only assign tags to normal non-executable
 	 * allocations, see __kasan_unpoison_vmalloc().
 	 */
 	kasan_flags |= KASAN_VMALLOC_VM_ALLOC;
-	if (!want_init_on_free() && want_init_on_alloc(gfp_mask))
+	if (!want_init_on_free() && want_init_on_alloc(gfp_mask) &&
+	    (gfp_mask & __GFP_SKIP_ZERO))
 		kasan_flags |= KASAN_VMALLOC_INIT;
 	/* KASAN_VMALLOC_PROT_NORMAL already set if required. */
 	area->addr = kasan_unpoison_vmalloc(area->addr, real_size, kasan_flags);
_

Patches currently in -mm which might be from andreyknvl@google.com are

mm-rename-kernel_init_free_pages-to-kernel_init_pages.patch
mm-introduce-clear_highpage_kasan_tagged.patch
kasan-fix-zeroing-vmalloc-memory-with-hw_tags.patch

