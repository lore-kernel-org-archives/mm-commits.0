Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D958C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 18 Feb 2021 21:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B23B264E38
	for <mm-commits@archiver.kernel.org>; Thu, 18 Feb 2021 21:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhBRV5Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Feb 2021 16:57:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:34700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229908AbhBRV5P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Feb 2021 16:57:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E790864E38;
        Thu, 18 Feb 2021 21:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613685394;
        bh=RKnDhCzRaCHFUAcNHtGLU+/k9+0CD12A3/Kmrd3qfgA=;
        h=Date:From:To:Subject:From;
        b=GnGru3M/0F6SVK8r7sL65rAp4/Oq8+yldEKITaO+Ruurq6qliu7Fnh9iKpUYeGDXQ
         VlEQAon5f4+xVRlWSXjgjWNLDCxmomyEbfisVRxPSL+cAEKYd+dO2gjGVrOy2hloGE
         IS1f4PTc/D00pEgJOjJlCMREMwbSbW4AqCwA1LOE=
Date:   Thu, 18 Feb 2021 13:56:33 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will.deacon@arm.com,
        vincenzo.frascino@arm.com, pcc@google.com, kevin.brodsky@arm.com,
        hch@infradead.org, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        Branislav.Rankov@arm.com, aryabinin@virtuozzo.com,
        andreyknvl@google.com
Subject:  + mm-kasan-dont-poison-boot-memory.patch added to -mm tree
Message-ID: <20210218215633.vMkX2%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, kasan: don't poison boot memory
has been added to the -mm tree.  Its filename is
     mm-kasan-dont-poison-boot-memory.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-dont-poison-boot-memory.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-dont-poison-boot-memory.patch

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
Subject: mm, kasan: don't poison boot memory

During boot, all non-reserved memblock memory is exposed to the buddy
allocator.  Poisoning all that memory with KASAN lengthens boot time,
especially on systems with large amount of RAM.  This patch makes
page_alloc to not call kasan_free_pages() on all new memory.

__free_pages_core() is used when exposing fresh memory during system boot
and when onlining memory during hotplug.  This patch adds a new
FPI_SKIP_KASAN_POISON flag and passes it to __free_pages_ok() through
free_pages_prepare() from __free_pages_core().

This has little impact on KASAN memory tracking.

Assuming that there are no references to newly exposed pages before they
are ever allocated, there won't be any intended (but buggy) accesses to
that memory that KASAN would normally detect.

However, with this patch, KASAN stops detecting wild and large
out-of-bounds accesses that happen to land on a fresh memory page that was
never allocated.  This is taken as an acceptable trade-off.

All memory allocated normally when the boot is over keeps getting
poisoned as usual.

Link: https://lkml.kernel.org/r/8d79640cdab4608c454310881b6c771e856dbd2e.1613595522.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

--- a/mm/page_alloc.c~mm-kasan-dont-poison-boot-memory
+++ a/mm/page_alloc.c
@@ -108,6 +108,17 @@ typedef int __bitwise fpi_t;
  */
 #define FPI_TO_TAIL		((__force fpi_t)BIT(1))
 
+/*
+ * Don't poison memory with KASAN.
+ * During boot, all non-reserved memblock memory is exposed to the buddy
+ * allocator. Poisoning all that memory lengthens boot time, especially on
+ * systems with large amount of RAM. This flag is used to skip that poisoning.
+ * Assuming that there are no references to those newly exposed pages before
+ * they are ever allocated, this has little effect on KASAN memory tracking.
+ * All memory allocated normally after boot gets poisoned as usual.
+ */
+#define FPI_SKIP_KASAN_POISON	((__force fpi_t)BIT(2))
+
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
 #define MIN_PERCPU_PAGELIST_FRACTION	(8)
@@ -384,10 +395,14 @@ static DEFINE_STATIC_KEY_TRUE(deferred_p
  * on-demand allocation and then freed again before the deferred pages
  * initialization is done, but this is not likely to happen.
  */
-static inline void kasan_free_nondeferred_pages(struct page *page, int order)
+static inline void kasan_free_nondeferred_pages(struct page *page, int order,
+							fpi_t fpi_flags)
 {
-	if (!static_branch_unlikely(&deferred_pages))
-		kasan_free_pages(page, order);
+	if (static_branch_unlikely(&deferred_pages))
+		return;
+	if (fpi_flags & FPI_SKIP_KASAN_POISON)
+		return;
+	kasan_free_pages(page, order);
 }
 
 /* Returns true if the struct page for the pfn is uninitialised */
@@ -438,7 +453,13 @@ defer_init(int nid, unsigned long pfn, u
 	return false;
 }
 #else
-#define kasan_free_nondeferred_pages(p, o)	kasan_free_pages(p, o)
+static inline void kasan_free_nondeferred_pages(struct page *page, int order,
+							fpi_t fpi_flags)
+{
+	if (fpi_flags & FPI_SKIP_KASAN_POISON)
+		return;
+	kasan_free_pages(page, order);
+}
 
 static inline bool early_page_uninitialised(unsigned long pfn)
 {
@@ -1216,7 +1237,7 @@ static void kernel_init_free_pages(struc
 }
 
 static __always_inline bool free_pages_prepare(struct page *page,
-					unsigned int order, bool check_free)
+			unsigned int order, bool check_free, fpi_t fpi_flags)
 {
 	int bad = 0;
 
@@ -1290,7 +1311,7 @@ static __always_inline bool free_pages_p
 
 	debug_pagealloc_unmap_pages(page, 1 << order);
 
-	kasan_free_nondeferred_pages(page, order);
+	kasan_free_nondeferred_pages(page, order, fpi_flags);
 
 	return true;
 }
@@ -1303,7 +1324,7 @@ static __always_inline bool free_pages_p
  */
 static bool free_pcp_prepare(struct page *page)
 {
-	return free_pages_prepare(page, 0, true);
+	return free_pages_prepare(page, 0, true, FPI_NONE);
 }
 
 static bool bulkfree_pcp_prepare(struct page *page)
@@ -1323,9 +1344,9 @@ static bool bulkfree_pcp_prepare(struct
 static bool free_pcp_prepare(struct page *page)
 {
 	if (debug_pagealloc_enabled_static())
-		return free_pages_prepare(page, 0, true);
+		return free_pages_prepare(page, 0, true, FPI_NONE);
 	else
-		return free_pages_prepare(page, 0, false);
+		return free_pages_prepare(page, 0, false, FPI_NONE);
 }
 
 static bool bulkfree_pcp_prepare(struct page *page)
@@ -1533,7 +1554,7 @@ static void __free_pages_ok(struct page
 	int migratetype;
 	unsigned long pfn = page_to_pfn(page);
 
-	if (!free_pages_prepare(page, order, true))
+	if (!free_pages_prepare(page, order, true, fpi_flags))
 		return;
 
 	migratetype = get_pfnblock_migratetype(page, pfn);
@@ -1570,7 +1591,7 @@ void __free_pages_core(struct page *page
 	 * Bypass PCP and place fresh pages right to the tail, primarily
 	 * relevant for memory onlining.
 	 */
-	__free_pages_ok(page, order, FPI_TO_TAIL);
+	__free_pages_ok(page, order, FPI_TO_TAIL | FPI_SKIP_KASAN_POISON);
 }
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-prefix-global-functions-with-kasan_.patch
kasan-clarify-hw_tags-impact-on-tbi.patch
kasan-clean-up-comments-in-tests.patch
kasan-add-macros-to-simplify-checking-test-constraints.patch
kasan-add-match-all-tag-tests.patch
kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode.patch
kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode-fix.patch
kasan-rename-config_test_kasan_module.patch
kasan-add-compiler-barriers-to-kunit_expect_kasan_fail.patch
kasan-adapt-kmalloc_uaf2-test-to-hw_tags-mode.patch
kasan-fix-memory-corruption-in-kasan_bitops_tags-test.patch
kasan-move-_ret_ip_-to-inline-wrappers.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode.patch
kasan-add-proper-page-allocator-tests.patch
kasan-add-a-test-for-kmem_cache_alloc-free_bulk.patch
kasan-dont-run-tests-when-kasan-is-not-enabled.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix-2.patch
kasan-mm-dont-save-alloc-stacks-twice.patch
kasan-mm-optimize-kmalloc-poisoning.patch
kasan-optimize-large-kmalloc-poisoning.patch
kasan-clean-up-setting-free-info-in-kasan_slab_free.patch
kasan-unify-large-kfree-checks.patch
kasan-rework-krealloc-tests.patch
kasan-mm-fail-krealloc-on-freed-objects.patch
kasan-mm-optimize-krealloc-poisoning.patch
kasan-ensure-poisoning-size-alignment.patch
arm64-kasan-simplify-and-inline-mte-functions.patch
kasan-inline-hw_tags-helper-functions.patch
kasan-clarify-that-only-first-bug-is-reported-in-hw_tags.patch
mm-kasan-dont-poison-boot-memory.patch

