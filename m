Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D07C43381
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 22:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CF3C64F9A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 22:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhCKWpS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 17:45:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:34386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhCKWo7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 17:44:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7072664F26;
        Thu, 11 Mar 2021 22:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615502699;
        bh=/JMOniaplcIbMCkpekEEjrlccLCO3dBeDJruizWt3WE=;
        h=Date:From:To:Subject:From;
        b=Qgjk3byCRSqwo2PqArHeP/ZAKTljvE1Aaz0rYskowpo/7rvHOlbbwTtZFOr9ujr8/
         d8nm4/nCoHE7Ys0NnvamRuF5xcm0Tc+c+PLkI7gNuEG7kMJpp3GF3tBk6QxXh8HRJy
         oNJsLZAWNaXckiQxvaK/YKfNYs8tQvG+62J5zNzo=
Date:   Thu, 11 Mar 2021 14:44:57 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com, cl@linux.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, iamjoonsoo.kim@lge.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  +
 arm64-kasan-allow-to-init-memory-when-setting-tags.patch added to -mm tree
Message-ID: <20210311224457.cGZnJrvSW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: kasan: allow to init memory when setting tags
has been added to the -mm tree.  Its filename is
     arm64-kasan-allow-to-init-memory-when-setting-tags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-kasan-allow-to-init-memory-when-setting-tags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-kasan-allow-to-init-memory-when-setting-tags.patch

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
Subject: arm64: kasan: allow to init memory when setting tags

Patch series "kasan: integrate with init_on_alloc/free", v3.

This patch series integrates HW_TAGS KASAN with init_on_alloc/free by
initializing memory via the same arm64 instruction that sets memory tags.

This is expected to improve HW_TAGS KASAN performance when
init_on_alloc/free is enabled.  The exact perfomance numbers are unknown
as MTE-enabled hardware doesn't exist yet.


This patch (of 5):

This change adds an argument to mte_set_mem_tag_range() that allows to
enable memory initialization when settinh the allocation tags.  The
implementation uses stzg instruction instead of stg when this argument
indicates to initialize memory.

Combining setting allocation tags with memory initialization will improve
HW_TAGS KASAN performance when init_on_alloc/free is enabled.

This change doesn't integrate memory initialization with KASAN, this is
done is subsequent patches in this series.

Link: https://lkml.kernel.org/r/cover.1615296150.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/d04ae90cc36be3fe246ea8025e5085495681c3d7.1615296150.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/memory.h    |    4 +-
 arch/arm64/include/asm/mte-kasan.h |   39 +++++++++++++++++----------
 mm/kasan/kasan.h                   |    9 +++---
 3 files changed, 32 insertions(+), 20 deletions(-)

--- a/arch/arm64/include/asm/memory.h~arm64-kasan-allow-to-init-memory-when-setting-tags
+++ a/arch/arm64/include/asm/memory.h
@@ -248,8 +248,8 @@ static inline const void *__tag_set(cons
 #define arch_init_tags(max_tag)			mte_init_tags(max_tag)
 #define arch_get_random_tag()			mte_get_random_tag()
 #define arch_get_mem_tag(addr)			mte_get_mem_tag(addr)
-#define arch_set_mem_tag_range(addr, size, tag)	\
-			mte_set_mem_tag_range((addr), (size), (tag))
+#define arch_set_mem_tag_range(addr, size, tag, init)	\
+			mte_set_mem_tag_range((addr), (size), (tag), (init))
 #endif /* CONFIG_KASAN_HW_TAGS */
 
 /*
--- a/arch/arm64/include/asm/mte-kasan.h~arm64-kasan-allow-to-init-memory-when-setting-tags
+++ a/arch/arm64/include/asm/mte-kasan.h
@@ -53,7 +53,8 @@ static inline u8 mte_get_random_tag(void
  * Note: The address must be non-NULL and MTE_GRANULE_SIZE aligned and
  * size must be non-zero and MTE_GRANULE_SIZE aligned.
  */
-static inline void mte_set_mem_tag_range(void *addr, size_t size, u8 tag)
+static inline void mte_set_mem_tag_range(void *addr, size_t size,
+						u8 tag, bool init)
 {
 	u64 curr, end;
 
@@ -63,18 +64,27 @@ static inline void mte_set_mem_tag_range
 	curr = (u64)__tag_set(addr, tag);
 	end = curr + size;
 
-	do {
-		/*
-		 * 'asm volatile' is required to prevent the compiler to move
-		 * the statement outside of the loop.
-		 */
-		asm volatile(__MTE_PREAMBLE "stg %0, [%0]"
-			     :
-			     : "r" (curr)
-			     : "memory");
-
-		curr += MTE_GRANULE_SIZE;
-	} while (curr != end);
+	/*
+	 * 'asm volatile' is required to prevent the compiler to move
+	 * the statement outside of the loop.
+	 */
+	if (init) {
+		do {
+			asm volatile(__MTE_PREAMBLE "stzg %0, [%0]"
+				     :
+				     : "r" (curr)
+				     : "memory");
+			curr += MTE_GRANULE_SIZE;
+		} while (curr != end);
+	} else {
+		do {
+			asm volatile(__MTE_PREAMBLE "stg %0, [%0]"
+				     :
+				     : "r" (curr)
+				     : "memory");
+			curr += MTE_GRANULE_SIZE;
+		} while (curr != end);
+	}
 }
 
 void mte_enable_kernel(void);
@@ -100,7 +110,8 @@ static inline u8 mte_get_random_tag(void
 	return 0xFF;
 }
 
-static inline void mte_set_mem_tag_range(void *addr, size_t size, u8 tag)
+static inline void mte_set_mem_tag_range(void *addr, size_t size,
+						u8 tag, bool init)
 {
 }
 
--- a/mm/kasan/kasan.h~arm64-kasan-allow-to-init-memory-when-setting-tags
+++ a/mm/kasan/kasan.h
@@ -291,7 +291,7 @@ static inline const void *arch_kasan_set
 #define arch_get_mem_tag(addr)	(0xFF)
 #endif
 #ifndef arch_set_mem_tag_range
-#define arch_set_mem_tag_range(addr, size, tag) ((void *)(addr))
+#define arch_set_mem_tag_range(addr, size, tag, init) ((void *)(addr))
 #endif
 
 #define hw_enable_tagging()			arch_enable_tagging()
@@ -299,7 +299,8 @@ static inline const void *arch_kasan_set
 #define hw_set_tagging_report_once(state)	arch_set_tagging_report_once(state)
 #define hw_get_random_tag()			arch_get_random_tag()
 #define hw_get_mem_tag(addr)			arch_get_mem_tag(addr)
-#define hw_set_mem_tag_range(addr, size, tag)	arch_set_mem_tag_range((addr), (size), (tag))
+#define hw_set_mem_tag_range(addr, size, tag, init) \
+			arch_set_mem_tag_range((addr), (size), (tag), (init))
 
 #else /* CONFIG_KASAN_HW_TAGS */
 
@@ -343,7 +344,7 @@ static inline void kasan_poison(const vo
 	if (WARN_ON(size & KASAN_GRANULE_MASK))
 		return;
 
-	hw_set_mem_tag_range((void *)addr, size, value);
+	hw_set_mem_tag_range((void *)addr, size, value, false);
 }
 
 static inline void kasan_unpoison(const void *addr, size_t size)
@@ -360,7 +361,7 @@ static inline void kasan_unpoison(const
 		return;
 	size = round_up(size, KASAN_GRANULE_SIZE);
 
-	hw_set_mem_tag_range((void *)addr, size, tag);
+	hw_set_mem_tag_range((void *)addr, size, tag, false);
 }
 
 static inline bool kasan_byte_accessible(const void *addr)
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc.patch
kasan-fix-kasan_stack-dependency-for-hw_tags.patch
kasan-fix-per-page-tags-for-non-page_alloc-pages.patch
kasan-initialize-shadow-to-tag_invalid-for-sw_tags.patch
mm-kasan-dont-poison-boot-memory-with-tag-based-modes.patch
arm64-kasan-allow-to-init-memory-when-setting-tags.patch
kasan-init-memory-in-kasan_unpoison-for-hw_tags.patch
kasan-mm-integrate-page_alloc-init-with-hw_tags.patch
kasan-mm-integrate-slab-init_on_alloc-with-hw_tags.patch
kasan-mm-integrate-slab-init_on_free-with-hw_tags.patch

