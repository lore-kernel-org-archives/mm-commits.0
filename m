Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FEB3C433E6
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 361CF64F37
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhB0Ccl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:32:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230131AbhB0CcJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:32:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A96764F3C;
        Sat, 27 Feb 2021 02:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393088;
        bh=ef+jCq4xXLUqhy+Xq1OQC/1psDxLXEZfKU2AJv42hNA=;
        h=Date:From:To:Subject:From;
        b=WYMAy84yHjepeQlLBqDwgTvPZCVrtTei4FJJH8YiJcvOLI0K2La+QwzttZteCOcr8
         M7pguVXUb9DPdeG2L2b4k/A7/l1j3eCsB1zAkXdf9eypQYVQUnWMUQc/97YYoAcCdw
         +kgEMuvS1HUPWw9KSnO3cptV0wi3wDGecbdUIXoI=
Date:   Fri, 26 Feb 2021 18:31:28 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [merged] kasan-ensure-poisoning-size-alignment.patch
 removed from -mm tree
Message-ID: <20210227023128.On36XWSfx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: ensure poisoning size alignment
has been removed from the -mm tree.  Its filename was
     kasan-ensure-poisoning-size-alignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: ensure poisoning size alignment

A previous changes d99f6a10c161 ("kasan: don't round_up too much")
attempted to simplify the code by adding a round_up(size) call into
kasan_poison().  While this allows to have less round_up() calls around
the code, this results in round_up() being called multiple times.

This patch removes round_up() of size from kasan_poison() and ensures that
all callers round_up() the size explicitly.  This patch also adds
WARN_ON() alignment checks for address and size to kasan_poison() and
kasan_unpoison().

Link: https://lkml.kernel.org/r/3ffe8d4a246ae67a8b5e91f65bf98cd7cba9d7b9.1612546384.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    9 ++++++---
 mm/kasan/kasan.h  |   33 ++++++++++++++++++++-------------
 mm/kasan/shadow.c |   37 ++++++++++++++++++++++---------------
 3 files changed, 48 insertions(+), 31 deletions(-)

--- a/mm/kasan/common.c~kasan-ensure-poisoning-size-alignment
+++ a/mm/kasan/common.c
@@ -261,7 +261,8 @@ void __kasan_unpoison_object_data(struct
 
 void __kasan_poison_object_data(struct kmem_cache *cache, void *object)
 {
-	kasan_poison(object, cache->object_size, KASAN_KMALLOC_REDZONE);
+	kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE_SIZE),
+			KASAN_KMALLOC_REDZONE);
 }
 
 /*
@@ -348,7 +349,8 @@ static bool ____kasan_slab_free(struct k
 		return true;
 	}
 
-	kasan_poison(object, cache->object_size, KASAN_KMALLOC_FREE);
+	kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE_SIZE),
+			KASAN_KMALLOC_FREE);
 
 	if ((IS_ENABLED(CONFIG_KASAN_GENERIC) && !quarantine))
 		return false;
@@ -490,7 +492,8 @@ static void *____kasan_kmalloc(struct km
 	/* Poison the aligned part of the redzone. */
 	redzone_start = round_up((unsigned long)(object + size),
 				KASAN_GRANULE_SIZE);
-	redzone_end = (unsigned long)object + cache->object_size;
+	redzone_end = round_up((unsigned long)(object + cache->object_size),
+				KASAN_GRANULE_SIZE);
 	kasan_poison((void *)redzone_start, redzone_end - redzone_start,
 			   KASAN_KMALLOC_REDZONE);
 
--- a/mm/kasan/kasan.h~kasan-ensure-poisoning-size-alignment
+++ a/mm/kasan/kasan.h
@@ -330,30 +330,37 @@ static inline u8 kasan_random_tag(void)
 
 #ifdef CONFIG_KASAN_HW_TAGS
 
-static inline void kasan_poison(const void *address, size_t size, u8 value)
+static inline void kasan_poison(const void *addr, size_t size, u8 value)
 {
-	address = kasan_reset_tag(address);
+	addr = kasan_reset_tag(addr);
 
 	/* Skip KFENCE memory if called explicitly outside of sl*b. */
-	if (is_kfence_address(address))
+	if (is_kfence_address(addr))
 		return;
 
-	hw_set_mem_tag_range((void *)address,
-			round_up(size, KASAN_GRANULE_SIZE), value);
+	if (WARN_ON((unsigned long)addr & KASAN_GRANULE_MASK))
+		return;
+	if (WARN_ON(size & KASAN_GRANULE_MASK))
+		return;
+
+	hw_set_mem_tag_range((void *)addr, size, value);
 }
 
-static inline void kasan_unpoison(const void *address, size_t size)
+static inline void kasan_unpoison(const void *addr, size_t size)
 {
-	u8 tag = get_tag(address);
+	u8 tag = get_tag(addr);
 
-	address = kasan_reset_tag(address);
+	addr = kasan_reset_tag(addr);
 
 	/* Skip KFENCE memory if called explicitly outside of sl*b. */
-	if (is_kfence_address(address))
+	if (is_kfence_address(addr))
+		return;
+
+	if (WARN_ON((unsigned long)addr & KASAN_GRANULE_MASK))
 		return;
+	size = round_up(size, KASAN_GRANULE_SIZE);
 
-	hw_set_mem_tag_range((void *)address,
-			round_up(size, KASAN_GRANULE_SIZE), tag);
+	hw_set_mem_tag_range((void *)addr, size, tag);
 }
 
 static inline bool kasan_byte_accessible(const void *addr)
@@ -370,7 +377,7 @@ static inline bool kasan_byte_accessible
 /**
  * kasan_poison - mark the memory range as unaccessible
  * @addr - range start address, must be aligned to KASAN_GRANULE_SIZE
- * @size - range size
+ * @size - range size, must be aligned to KASAN_GRANULE_SIZE
  * @value - value that's written to metadata for the range
  *
  * The size gets aligned to KASAN_GRANULE_SIZE before marking the range.
@@ -380,7 +387,7 @@ void kasan_poison(const void *addr, size
 /**
  * kasan_unpoison - mark the memory range as accessible
  * @addr - range start address, must be aligned to KASAN_GRANULE_SIZE
- * @size - range size
+ * @size - range size, can be unaligned
  *
  * For the tag-based modes, the @size gets aligned to KASAN_GRANULE_SIZE before
  * marking the range.
--- a/mm/kasan/shadow.c~kasan-ensure-poisoning-size-alignment
+++ a/mm/kasan/shadow.c
@@ -69,7 +69,7 @@ void *memcpy(void *dest, const void *src
 	return __memcpy(dest, src, len);
 }
 
-void kasan_poison(const void *address, size_t size, u8 value)
+void kasan_poison(const void *addr, size_t size, u8 value)
 {
 	void *shadow_start, *shadow_end;
 
@@ -78,55 +78,62 @@ void kasan_poison(const void *address, s
 	 * some of the callers (e.g. kasan_poison_object_data) pass tagged
 	 * addresses to this function.
 	 */
-	address = kasan_reset_tag(address);
+	addr = kasan_reset_tag(addr);
 
 	/* Skip KFENCE memory if called explicitly outside of sl*b. */
-	if (is_kfence_address(address))
+	if (is_kfence_address(addr))
 		return;
 
-	size = round_up(size, KASAN_GRANULE_SIZE);
-	shadow_start = kasan_mem_to_shadow(address);
-	shadow_end = kasan_mem_to_shadow(address + size);
+	if (WARN_ON((unsigned long)addr & KASAN_GRANULE_MASK))
+		return;
+	if (WARN_ON(size & KASAN_GRANULE_MASK))
+		return;
+
+	shadow_start = kasan_mem_to_shadow(addr);
+	shadow_end = kasan_mem_to_shadow(addr + size);
 
 	__memset(shadow_start, value, shadow_end - shadow_start);
 }
 EXPORT_SYMBOL(kasan_poison);
 
 #ifdef CONFIG_KASAN_GENERIC
-void kasan_poison_last_granule(const void *address, size_t size)
+void kasan_poison_last_granule(const void *addr, size_t size)
 {
 	if (size & KASAN_GRANULE_MASK) {
-		u8 *shadow = (u8 *)kasan_mem_to_shadow(address + size);
+		u8 *shadow = (u8 *)kasan_mem_to_shadow(addr + size);
 		*shadow = size & KASAN_GRANULE_MASK;
 	}
 }
 #endif
 
-void kasan_unpoison(const void *address, size_t size)
+void kasan_unpoison(const void *addr, size_t size)
 {
-	u8 tag = get_tag(address);
+	u8 tag = get_tag(addr);
 
 	/*
 	 * Perform shadow offset calculation based on untagged address, as
 	 * some of the callers (e.g. kasan_unpoison_object_data) pass tagged
 	 * addresses to this function.
 	 */
-	address = kasan_reset_tag(address);
+	addr = kasan_reset_tag(addr);
 
 	/*
 	 * Skip KFENCE memory if called explicitly outside of sl*b. Also note
 	 * that calls to ksize(), where size is not a multiple of machine-word
 	 * size, would otherwise poison the invalid portion of the word.
 	 */
-	if (is_kfence_address(address))
+	if (is_kfence_address(addr))
+		return;
+
+	if (WARN_ON((unsigned long)addr & KASAN_GRANULE_MASK))
 		return;
 
-	/* Unpoison round_up(size, KASAN_GRANULE_SIZE) bytes. */
-	kasan_poison(address, size, tag);
+	/* Unpoison all granules that cover the object. */
+	kasan_poison(addr, round_up(size, KASAN_GRANULE_SIZE), tag);
 
 	/* Partially poison the last granule for the generic mode. */
 	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
-		kasan_poison_last_granule(address, size);
+		kasan_poison_last_granule(addr, size);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
_

Patches currently in -mm which might be from andreyknvl@google.com are


