Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32806C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 169CF61482
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhD3GAk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:00:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230280AbhD3GAk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:00:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A76A061463;
        Fri, 30 Apr 2021 05:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762393;
        bh=Ojtovq+XXtv1vnpLfV9lBwerQTzImo2Vr9zNXH+UBwU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gQyAgpL1i66Fyn0sP3LftUO9OtNINvWmmSry2BFdKrp/0Qcon1eA1K32ndZZqpHnE
         swOSYy9wSjQL7/j+kd4KWz2VHvE0nrgCCpW8GlnR/VDpyRUyrLrvdHT6TgmEHoq9Ps
         2/Jj6YByrU6abEh0yIrAz0Gy6/upkr9OWUJTCJq8=
Date:   Thu, 29 Apr 2021 22:59:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, hch@infradead.org,
        kevin.brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, pcc@google.com,
        torvalds@linux-foundation.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [patch 130/178] mm, kasan: don't poison boot memory with
 tag-based modes
Message-ID: <20210430055952.sDCf5Hesn%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: mm, kasan: don't poison boot memory with tag-based modes

During boot, all non-reserved memblock memory is exposed to page_alloc via
memblock_free_pages->__free_pages_core().  This results in
kasan_free_pages() being called, which poisons that memory.

Poisoning all that memory lengthens boot time.  The most noticeable effect
is observed with the HW_TAGS mode.  A boot-time impact may potentially
also affect systems with large amount of RAM.

This patch changes the tag-based modes to not poison the memory during the
memblock->page_alloc transition.

An exception is made for KASAN_GENERIC.  Since it marks all new memory as
accessible, not poisoning the memory released from memblock will lead to
KASAN missing invalid boot-time accesses to that memory.

With KASAN_SW_TAGS, as it uses the invalid 0xFE tag as the default tag for
all memory, it won't miss bad boot-time accesses even if the poisoning of
memblock memory is removed.

With KASAN_HW_TAGS, the default memory tags values are unspecified. 
Therefore, if memblock poisoning is removed, this KASAN mode will miss the
mentioned type of boot-time bugs with a 1/16 probability.  This is taken
as an acceptable trafe-off.

Internally, the poisoning is removed as follows.  __free_pages_core() is
used when exposing fresh memory during system boot and when onlining
memory during hotplug.  This patch adds a new FPI_SKIP_KASAN_POISON flag
and passes it to __free_pages_ok() through free_pages_prepare() from
__free_pages_core().  If FPI_SKIP_KASAN_POISON is set, kasan_free_pages()
is not called.

All memory allocated normally when the boot is over keeps getting poisoned
as usual.

Link: https://lkml.kernel.org/r/a0570dc1e3a8f39a55aa343a1fc08cd5c2d4cad6.1613692950.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
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

 mm/page_alloc.c |   45 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 11 deletions(-)

--- a/mm/page_alloc.c~mm-kasan-dont-poison-boot-memory-with-tag-based-modes
+++ a/mm/page_alloc.c
@@ -109,6 +109,17 @@ typedef int __bitwise fpi_t;
  */
 #define FPI_TO_TAIL		((__force fpi_t)BIT(1))
 
+/*
+ * Don't poison memory with KASAN (only for the tag-based modes).
+ * During boot, all non-reserved memblock memory is exposed to page_alloc.
+ * Poisoning all that memory lengthens boot time, especially on systems with
+ * large amount of RAM. This flag is used to skip that poisoning.
+ * This is only done for the tag-based KASAN modes, as those are able to
+ * detect memory corruptions with the memory tags assigned by default.
+ * All memory allocated normally after boot gets poisoned as usual.
+ */
+#define FPI_SKIP_KASAN_POISON	((__force fpi_t)BIT(2))
+
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
 #define MIN_PERCPU_PAGELIST_FRACTION	(8)
@@ -385,10 +396,15 @@ static DEFINE_STATIC_KEY_TRUE(deferred_p
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
+	if (!IS_ENABLED(CONFIG_KASAN_GENERIC) &&
+			(fpi_flags & FPI_SKIP_KASAN_POISON))
+		return;
+	kasan_free_pages(page, order);
 }
 
 /* Returns true if the struct page for the pfn is uninitialised */
@@ -439,7 +455,14 @@ defer_init(int nid, unsigned long pfn, u
 	return false;
 }
 #else
-#define kasan_free_nondeferred_pages(p, o)	kasan_free_pages(p, o)
+static inline void kasan_free_nondeferred_pages(struct page *page, int order,
+							fpi_t fpi_flags)
+{
+	if (!IS_ENABLED(CONFIG_KASAN_GENERIC) &&
+			(fpi_flags & FPI_SKIP_KASAN_POISON))
+		return;
+	kasan_free_pages(page, order);
+}
 
 static inline bool early_page_uninitialised(unsigned long pfn)
 {
@@ -1217,7 +1240,7 @@ static void kernel_init_free_pages(struc
 }
 
 static __always_inline bool free_pages_prepare(struct page *page,
-					unsigned int order, bool check_free)
+			unsigned int order, bool check_free, fpi_t fpi_flags)
 {
 	int bad = 0;
 
@@ -1286,7 +1309,7 @@ static __always_inline bool free_pages_p
 	 * With hardware tag-based KASAN, memory tags must be set before the
 	 * page becomes unavailable via debug_pagealloc or arch_free_page.
 	 */
-	kasan_free_nondeferred_pages(page, order);
+	kasan_free_nondeferred_pages(page, order, fpi_flags);
 
 	/*
 	 * arch_free_page() can make the page's contents inaccessible.  s390
@@ -1308,7 +1331,7 @@ static __always_inline bool free_pages_p
  */
 static bool free_pcp_prepare(struct page *page)
 {
-	return free_pages_prepare(page, 0, true);
+	return free_pages_prepare(page, 0, true, FPI_NONE);
 }
 
 static bool bulkfree_pcp_prepare(struct page *page)
@@ -1328,9 +1351,9 @@ static bool bulkfree_pcp_prepare(struct
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
@@ -1538,7 +1561,7 @@ static void __free_pages_ok(struct page
 	int migratetype;
 	unsigned long pfn = page_to_pfn(page);
 
-	if (!free_pages_prepare(page, order, true))
+	if (!free_pages_prepare(page, order, true, fpi_flags))
 		return;
 
 	migratetype = get_pfnblock_migratetype(page, pfn);
@@ -1575,7 +1598,7 @@ void __free_pages_core(struct page *page
 	 * Bypass PCP and place fresh pages right to the tail, primarily
 	 * relevant for memory onlining.
 	 */
-	__free_pages_ok(page, order, FPI_TO_TAIL);
+	__free_pages_ok(page, order, FPI_TO_TAIL | FPI_SKIP_KASAN_POISON);
 }
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
_
