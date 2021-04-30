Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABCD0C43460
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CED561482
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhD3GAo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230045AbhD3GAo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:00:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02EF661481;
        Fri, 30 Apr 2021 05:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762396;
        bh=YqVPFnJlKjcCjL/T2DP84nAX4j+pncKyvXnSoMjx2YQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sj/IJJInPu+asoLJCUGcRYEVFSmGZcqlS2yZQ73gi1KGTLMUrQV9OXLCT4+vwc9Ki
         ucDBTdP3wkvG9lD3NypeV4bJU3oKvG4J/JsrFNH30aFp84SmXhNbCpP7KtAwtfXL6+
         7cC9BPcfWz5DnIpk8CrUD19zlfJdnI1NBM8+BdRE=
Date:   Thu, 29 Apr 2021 22:59:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, cl@linux.com, dvyukov@google.com,
        elver@google.com, eugenis@google.com, glider@google.com,
        iamjoonsoo.kim@lge.com, kevin.brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, pcc@google.com, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [patch 131/178] arm64: kasan: allow to init memory when
 setting tags
Message-ID: <20210430055955.lPnlaQ-lb%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -250,8 +250,8 @@ static inline const void *__tag_set(cons
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
 
 void mte_enable_kernel_sync(void);
@@ -101,7 +111,8 @@ static inline u8 mte_get_random_tag(void
 	return 0xFF;
 }
 
-static inline void mte_set_mem_tag_range(void *addr, size_t size, u8 tag)
+static inline void mte_set_mem_tag_range(void *addr, size_t size,
+						u8 tag, bool init)
 {
 }
 
--- a/mm/kasan/kasan.h~arm64-kasan-allow-to-init-memory-when-setting-tags
+++ a/mm/kasan/kasan.h
@@ -314,7 +314,7 @@ static inline const void *arch_kasan_set
 #define arch_get_mem_tag(addr)	(0xFF)
 #endif
 #ifndef arch_set_mem_tag_range
-#define arch_set_mem_tag_range(addr, size, tag) ((void *)(addr))
+#define arch_set_mem_tag_range(addr, size, tag, init) ((void *)(addr))
 #endif
 
 #define hw_enable_tagging_sync()		arch_enable_tagging_sync()
@@ -324,7 +324,8 @@ static inline const void *arch_kasan_set
 #define hw_force_async_tag_fault()		arch_force_async_tag_fault()
 #define hw_get_random_tag()			arch_get_random_tag()
 #define hw_get_mem_tag(addr)			arch_get_mem_tag(addr)
-#define hw_set_mem_tag_range(addr, size, tag)	arch_set_mem_tag_range((addr), (size), (tag))
+#define hw_set_mem_tag_range(addr, size, tag, init) \
+			arch_set_mem_tag_range((addr), (size), (tag), (init))
 
 #else /* CONFIG_KASAN_HW_TAGS */
 
@@ -371,7 +372,7 @@ static inline void kasan_poison(const vo
 	if (WARN_ON(size & KASAN_GRANULE_MASK))
 		return;
 
-	hw_set_mem_tag_range((void *)addr, size, value);
+	hw_set_mem_tag_range((void *)addr, size, value, false);
 }
 
 static inline void kasan_unpoison(const void *addr, size_t size)
@@ -388,7 +389,7 @@ static inline void kasan_unpoison(const
 		return;
 	size = round_up(size, KASAN_GRANULE_SIZE);
 
-	hw_set_mem_tag_range((void *)addr, size, tag);
+	hw_set_mem_tag_range((void *)addr, size, tag, false);
 }
 
 static inline bool kasan_byte_accessible(const void *addr)
_
