Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 315FBC433DB
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 20:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFF8E20771
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 20:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgLVUDp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 15:03:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:47264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbgLVUDp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 15:03:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F18DA20700;
        Tue, 22 Dec 2020 20:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608667384;
        bh=wPvi+UsUpTxgCzcocHc0vONZ7AR6L8dOcpE8h6uun9o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=b8FF/zUnen67BY4xiFx/uRWePB4rUwcb8BAH/CjhDdoFB1kxNsHb4hiLN6NbyPdqc
         +QqByp74CulQt+zBcQt8ZKH8dP4sa75HuT6XS8J/6MbsevkiCn+tKvFsX1QhfZilnT
         EtNeKyC2QbDpvvMED7dlI6ICiKp1owe0ILZVwVUU=
Date:   Tue, 22 Dec 2020 12:03:03 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, gor@linux.ibm.com,
        kevin.brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [patch 51/60] kasan: inline (un)poison_range and
 check_invalid_free
Message-ID: <20201222200303.rJO6f-L6E%akpm@linux-foundation.org>
In-Reply-To: <20201222115844.d30aaef7df6f5b120d3e0c3d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: inline (un)poison_range and check_invalid_free

Using (un)poison_range() or check_invalid_free() currently results in
function calls. Move their definitions to mm/kasan/kasan.h and turn them
into static inline functions for hardware tag-based mode to avoid
unneeded function calls.

Link: https://lkml.kernel.org/r/7007955b69eb31b5376a7dc1e0f4ac49138504f2.1606162397.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/Ia9d8191024a12d1374675b3d27197f10193f50bb
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/hw_tags.c |   21 ---------------------
 mm/kasan/kasan.h   |   36 +++++++++++++++++++++++++++++++-----
 2 files changed, 31 insertions(+), 26 deletions(-)

--- a/mm/kasan/hw_tags.c~kasan-inline-unpoison_range-and-check_invalid_free
+++ a/mm/kasan/hw_tags.c
@@ -30,27 +30,6 @@ void __init kasan_init_hw_tags(void)
 	pr_info("KernelAddressSanitizer initialized\n");
 }
 
-void poison_range(const void *address, size_t size, u8 value)
-{
-	hw_set_mem_tag_range(kasan_reset_tag(address),
-			round_up(size, KASAN_GRANULE_SIZE), value);
-}
-
-void unpoison_range(const void *address, size_t size)
-{
-	hw_set_mem_tag_range(kasan_reset_tag(address),
-			round_up(size, KASAN_GRANULE_SIZE), get_tag(address));
-}
-
-bool check_invalid_free(void *addr)
-{
-	u8 ptr_tag = get_tag(addr);
-	u8 mem_tag = hw_get_mem_tag(addr);
-
-	return (mem_tag == KASAN_TAG_INVALID) ||
-		(ptr_tag != KASAN_TAG_KERNEL && ptr_tag != mem_tag);
-}
-
 void kasan_set_free_info(struct kmem_cache *cache,
 				void *object, u8 tag)
 {
--- a/mm/kasan/kasan.h~kasan-inline-unpoison_range-and-check_invalid_free
+++ a/mm/kasan/kasan.h
@@ -154,9 +154,6 @@ struct kasan_alloc_meta *kasan_get_alloc
 struct kasan_free_meta *kasan_get_free_meta(struct kmem_cache *cache,
 						const void *object);
 
-void poison_range(const void *address, size_t size, u8 value);
-void unpoison_range(const void *address, size_t size);
-
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 
 static inline const void *kasan_shadow_to_mem(const void *shadow_addr)
@@ -196,8 +193,6 @@ void print_tags(u8 addr_tag, const void
 static inline void print_tags(u8 addr_tag, const void *addr) { }
 #endif
 
-bool check_invalid_free(void *addr);
-
 void *find_first_bad_addr(void *addr, size_t size);
 const char *get_bug_type(struct kasan_access_info *info);
 void metadata_fetch_row(char *buffer, void *row);
@@ -278,6 +273,37 @@ static inline u8 random_tag(void) { retu
 static inline u8 random_tag(void) { return 0; }
 #endif
 
+#ifdef CONFIG_KASAN_HW_TAGS
+
+static inline void poison_range(const void *address, size_t size, u8 value)
+{
+	hw_set_mem_tag_range(kasan_reset_tag(address),
+			round_up(size, KASAN_GRANULE_SIZE), value);
+}
+
+static inline void unpoison_range(const void *address, size_t size)
+{
+	hw_set_mem_tag_range(kasan_reset_tag(address),
+			round_up(size, KASAN_GRANULE_SIZE), get_tag(address));
+}
+
+static inline bool check_invalid_free(void *addr)
+{
+	u8 ptr_tag = get_tag(addr);
+	u8 mem_tag = hw_get_mem_tag(addr);
+
+	return (mem_tag == KASAN_TAG_INVALID) ||
+		(ptr_tag != KASAN_TAG_KERNEL && ptr_tag != mem_tag);
+}
+
+#else /* CONFIG_KASAN_HW_TAGS */
+
+void poison_range(const void *address, size_t size, u8 value);
+void unpoison_range(const void *address, size_t size);
+bool check_invalid_free(void *addr);
+
+#endif /* CONFIG_KASAN_HW_TAGS */
+
 /*
  * Exported functions for interfaces called from assembly or from generated
  * code. Declarations here to avoid warning about missing declarations.
_
