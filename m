Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0884C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 20:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E9C920771
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 20:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgLVUEO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 15:04:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:47712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbgLVUEN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 15:04:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48F9B21D81;
        Tue, 22 Dec 2020 20:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608667412;
        bh=uJ4An1wnldMhr2Wy6GlXvJSV0e7Q73eZYXMEC7AsUTo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1sqhDCabdwBndTgXl9gB0zYgBUGv6HEwCfc4htKOC0Mc/bujXB+NigFe3kL67q4dG
         rDYlegh+SMODa8IsDSB7aTcIPNkn8/IVUVQS4YkKMk5aJddD+QYx//CWbtulJBRiTu
         NWnY8bEm+HRGPRcgGhKOdXPzFU+3mfBtrVlIoRgQ=
Date:   Tue, 22 Dec 2020 12:03:31 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, gor@linux.ibm.com,
        kevin.brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        Vincenzo.Frascino@arm.com, will.deacon@arm.com
Subject:  [patch 59/60] kasan, mm: allow cache merging with no
 metadata
Message-ID: <20201222200331.wcT_Yhdtg%akpm@linux-foundation.org>
In-Reply-To: <20201222115844.d30aaef7df6f5b120d3e0c3d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, mm: allow cache merging with no metadata

The reason cache merging is disabled with KASAN is because KASAN puts its
metadata right after the allocated object. When the merged caches have
slightly different sizes, the metadata ends up in different places, which
KASAN doesn't support.

It might be possible to adjust the metadata allocation algorithm and make
it friendly to the cache merging code. Instead this change takes a simpler
approach and allows merging caches when no metadata is present. Which is
the case for hardware tag-based KASAN with kasan.mode=prod.

Link: https://lkml.kernel.org/r/37497e940bfd4b32c0a93a702a9ae4cf061d5392.1606162397.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/Ia114847dfb2244f297d2cb82d592bf6a07455dba
Co-developed-by: Vincenzo Frascino <Vincenzo.Frascino@arm.com>
Signed-off-by: Vincenzo Frascino <Vincenzo.Frascino@arm.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   21 +++++++++++++++++++--
 mm/kasan/common.c     |   11 +++++++++++
 mm/slab_common.c      |    3 ++-
 3 files changed, 32 insertions(+), 3 deletions(-)

--- a/include/linux/kasan.h~kasan-mm-allow-cache-merging-with-no-metadata
+++ a/include/linux/kasan.h
@@ -82,17 +82,30 @@ struct kasan_cache {
 };
 
 #ifdef CONFIG_KASAN_HW_TAGS
+
 DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
+
 static __always_inline bool kasan_enabled(void)
 {
 	return static_branch_likely(&kasan_flag_enabled);
 }
-#else
+
+#else /* CONFIG_KASAN_HW_TAGS */
+
 static inline bool kasan_enabled(void)
 {
 	return true;
 }
-#endif
+
+#endif /* CONFIG_KASAN_HW_TAGS */
+
+slab_flags_t __kasan_never_merge(void);
+static __always_inline slab_flags_t kasan_never_merge(void)
+{
+	if (kasan_enabled())
+		return __kasan_never_merge();
+	return 0;
+}
 
 void __kasan_unpoison_range(const void *addr, size_t size);
 static __always_inline void kasan_unpoison_range(const void *addr, size_t size)
@@ -239,6 +252,10 @@ static inline bool kasan_enabled(void)
 {
 	return false;
 }
+static inline slab_flags_t kasan_never_merge(void)
+{
+	return 0;
+}
 static inline void kasan_unpoison_range(const void *address, size_t size) {}
 static inline void kasan_alloc_pages(struct page *page, unsigned int order) {}
 static inline void kasan_free_pages(struct page *page, unsigned int order) {}
--- a/mm/kasan/common.c~kasan-mm-allow-cache-merging-with-no-metadata
+++ a/mm/kasan/common.c
@@ -86,6 +86,17 @@ asmlinkage void kasan_unpoison_task_stac
 }
 #endif /* CONFIG_KASAN_STACK */
 
+/*
+ * Only allow cache merging when stack collection is disabled and no metadata
+ * is present.
+ */
+slab_flags_t __kasan_never_merge(void)
+{
+	if (kasan_stack_collection_enabled())
+		return SLAB_KASAN;
+	return 0;
+}
+
 void __kasan_alloc_pages(struct page *page, unsigned int order)
 {
 	u8 tag;
--- a/mm/slab_common.c~kasan-mm-allow-cache-merging-with-no-metadata
+++ a/mm/slab_common.c
@@ -18,6 +18,7 @@
 #include <linux/seq_file.h>
 #include <linux/proc_fs.h>
 #include <linux/debugfs.h>
+#include <linux/kasan.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/page.h>
@@ -53,7 +54,7 @@ static DECLARE_WORK(slab_caches_to_rcu_d
  */
 #define SLAB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
 		SLAB_TRACE | SLAB_TYPESAFE_BY_RCU | SLAB_NOLEAKTRACE | \
-		SLAB_FAILSLAB | SLAB_KASAN)
+		SLAB_FAILSLAB | kasan_never_merge())
 
 #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
 			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT)
_
