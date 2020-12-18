Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6262AC4361B
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C47823BA7
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgLRWFi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:05:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:39298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbgLRWFi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 17:05:38 -0500
Date:   Fri, 18 Dec 2020 14:04:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608329097;
        bh=7LQXGIx6RDAeofE5iVyO/yTxLjk97FSR2IehAPp21CE=;
        h=From:To:Subject:In-Reply-To:From;
        b=ja7tR8kmuSpGQ9GOhqKS2O2DcX15vlm22X708eqsZQ1CJnCy8fgze7FgiifPycf7y
         BaGw9AcRdqx6r4EnXKt5XnngOWmVRrb1fTXzVilDPFVp4eFf+puHKZR0OaDZVuJQlw
         kaYgV9NtGyIwZbtezyVO5qoGo4QBNvy+CzVnHu/k=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, gor@linux.ibm.com,
        kevin.brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [patch 64/78] kasan: inline (un)poison_range and
 check_invalid_free
Message-ID: <20201218220456.ewCaZp1VN%akpm@linux-foundation.org>
In-Reply-To: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
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

 mm/kasan/hw_tags.c |   30 ----------------------------
 mm/kasan/kasan.h   |   45 ++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 40 insertions(+), 35 deletions(-)

--- a/mm/kasan/hw_tags.c~kasan-inline-unpoison_range-and-check_invalid_free
+++ a/mm/kasan/hw_tags.c
@@ -10,7 +10,6 @@
 
 #include <linux/kasan.h>
 #include <linux/kernel.h>
-#include <linux/kfence.h>
 #include <linux/memory.h>
 #include <linux/mm.h>
 #include <linux/string.h>
@@ -31,35 +30,6 @@ void __init kasan_init_hw_tags(void)
 	pr_info("KernelAddressSanitizer initialized\n");
 }
 
-void poison_range(const void *address, size_t size, u8 value)
-{
-	/* Skip KFENCE memory if called explicitly outside of sl*b. */
-	if (is_kfence_address(address))
-		return;
-
-	hw_set_mem_tag_range(kasan_reset_tag(address),
-			round_up(size, KASAN_GRANULE_SIZE), value);
-}
-
-void unpoison_range(const void *address, size_t size)
-{
-	/* Skip KFENCE memory if called explicitly outside of sl*b. */
-	if (is_kfence_address(address))
-		return;
-
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
@@ -3,6 +3,7 @@
 #define __MM_KASAN_KASAN_H
 
 #include <linux/kasan.h>
+#include <linux/kfence.h>
 #include <linux/stackdepot.h>
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
@@ -154,9 +155,6 @@ struct kasan_alloc_meta *kasan_get_alloc
 struct kasan_free_meta *kasan_get_free_meta(struct kmem_cache *cache,
 						const void *object);
 
-void poison_range(const void *address, size_t size, u8 value);
-void unpoison_range(const void *address, size_t size);
-
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 
 static inline const void *kasan_shadow_to_mem(const void *shadow_addr)
@@ -196,8 +194,6 @@ void print_tags(u8 addr_tag, const void
 static inline void print_tags(u8 addr_tag, const void *addr) { }
 #endif
 
-bool check_invalid_free(void *addr);
-
 void *find_first_bad_addr(void *addr, size_t size);
 const char *get_bug_type(struct kasan_access_info *info);
 void metadata_fetch_row(char *buffer, void *row);
@@ -278,6 +274,45 @@ static inline u8 random_tag(void) { retu
 static inline u8 random_tag(void) { return 0; }
 #endif
 
+#ifdef CONFIG_KASAN_HW_TAGS
+
+static inline void poison_range(const void *address, size_t size, u8 value)
+{
+	/* Skip KFENCE memory if called explicitly outside of sl*b. */
+	if (is_kfence_address(address))
+		return;
+
+	hw_set_mem_tag_range(kasan_reset_tag(address),
+			round_up(size, KASAN_GRANULE_SIZE), value);
+}
+
+static inline void unpoison_range(const void *address, size_t size)
+{
+	/* Skip KFENCE memory if called explicitly outside of sl*b. */
+	if (is_kfence_address(address))
+		return;
+
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
