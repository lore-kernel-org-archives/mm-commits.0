Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91452C4332E
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:20:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D8EF64F26
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhBZBUH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:20:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:52204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229946AbhBZBUE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:20:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF8AA64F32;
        Fri, 26 Feb 2021 01:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302363;
        bh=Bgo6abVMJv3TUg9v1XWbQ7scx5kfagdhozmNNelaS3c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AMlsOOz1COPUgEZQ5kj5geXxqcd9tCbCNfdw4yGi+EYyv5g1WMC0ajpEapL16HmsE
         XsAZv7y3vx0YcqN2w3wvbtQJMSIzrzBdJTeM7kwt+wWMY4iFdO21y/yWyO5tYMq61w
         8IzkX72PEjsmxIRCSaAqswQ+VAkvLjvQuSXh21V4=
Date:   Thu, 25 Feb 2021 17:19:21 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, bp@alien8.de, catalin.marinas@arm.com,
        cl@linux.com, corbet@lwn.net, dave.hansen@linux.intel.com,
        dvyukov@google.com, edumazet@google.com, elver@google.com,
        glider@google.com, gregkh@linuxfoundation.org, hdanton@sina.com,
        hpa@zytor.com, iamjoonsoo.kim@lge.com, jannh@google.com,
        joern@purestorage.com, keescook@chromium.org, linux-mm@kvack.org,
        luto@kernel.org, mark.rutland@arm.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org, penberg@kernel.org,
        peterz@infradead.org, rientjes@google.com, sjpark@amazon.de,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz,
        will@kernel.org
Subject:  [patch 062/118] kfence, kasan: make KFENCE compatible
 with KASAN
Message-ID: <20210226011921.oh-bJmRQc%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alexander Potapenko <glider@google.com>
Subject: kfence, kasan: make KFENCE compatible with KASAN

Make KFENCE compatible with KASAN. Currently this helps test KFENCE
itself, where KASAN can catch potential corruptions to KFENCE state, or
other corruptions that may be a result of freepointer corruptions in the
main allocators.

[akpm@linux-foundation.org: merge fixup]
[andreyknvl@google.com: untag addresses for KFENCE]
  Link: https://lkml.kernel.org/r/9dc196006921b191d25d10f6e611316db7da2efc.1611946152.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/20201103175841.3495947-7-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Jann Horn <jannh@google.com>
Co-developed-by: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joern Engel <joern@purestorage.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: SeongJae Park <sjpark@amazon.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kfence |    2 +-
 mm/kasan/common.c  |    6 ++++++
 mm/kasan/generic.c |    3 ++-
 mm/kasan/kasan.h   |   21 ++++++++++++++++++---
 mm/kasan/shadow.c  |   13 +++++++++++++
 5 files changed, 40 insertions(+), 5 deletions(-)

--- a/lib/Kconfig.kfence~kfence-kasan-make-kfence-compatible-with-kasan
+++ a/lib/Kconfig.kfence
@@ -5,7 +5,7 @@ config HAVE_ARCH_KFENCE
 
 menuconfig KFENCE
 	bool "KFENCE: low-overhead sampling-based memory safety error detector"
-	depends on HAVE_ARCH_KFENCE && !KASAN && (SLAB || SLUB)
+	depends on HAVE_ARCH_KFENCE && (SLAB || SLUB)
 	select STACKTRACE
 	help
 	  KFENCE is a low-overhead sampling-based detector of heap out-of-bounds
--- a/mm/kasan/common.c~kfence-kasan-make-kfence-compatible-with-kasan
+++ a/mm/kasan/common.c
@@ -335,6 +335,9 @@ static bool ____kasan_slab_free(struct k
 	tagged_object = object;
 	object = kasan_reset_tag(object);
 
+	if (is_kfence_address(object))
+		return false;
+
 	if (unlikely(nearest_obj(cache, virt_to_head_page(object), object) !=
 	    object)) {
 		kasan_report_invalid_free(tagged_object, ip);
@@ -413,6 +416,9 @@ static void *____kasan_kmalloc(struct km
 	if (unlikely(object == NULL))
 		return NULL;
 
+	if (is_kfence_address(kasan_reset_tag(object)))
+		return (void *)object;
+
 	redzone_start = round_up((unsigned long)(object + size),
 				KASAN_GRANULE_SIZE);
 	redzone_end = round_up((unsigned long)object + cache->object_size,
--- a/mm/kasan/generic.c~kfence-kasan-make-kfence-compatible-with-kasan
+++ a/mm/kasan/generic.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/kasan.h>
 #include <linux/kernel.h>
+#include <linux/kfence.h>
 #include <linux/kmemleak.h>
 #include <linux/linkage.h>
 #include <linux/memblock.h>
@@ -331,7 +332,7 @@ void kasan_record_aux_stack(void *addr)
 	struct kasan_alloc_meta *alloc_meta;
 	void *object;
 
-	if (!(page && PageSlab(page)))
+	if (is_kfence_address(addr) || !(page && PageSlab(page)))
 		return;
 
 	cache = page->slab_cache;
--- a/mm/kasan/kasan.h~kfence-kasan-make-kfence-compatible-with-kasan
+++ a/mm/kasan/kasan.h
@@ -3,6 +3,7 @@
 #define __MM_KASAN_KASAN_H
 
 #include <linux/kasan.h>
+#include <linux/kfence.h>
 #include <linux/stackdepot.h>
 
 #ifdef CONFIG_KASAN_HW_TAGS
@@ -331,14 +332,28 @@ static inline u8 kasan_random_tag(void)
 
 static inline void kasan_poison(const void *address, size_t size, u8 value)
 {
-	hw_set_mem_tag_range(kasan_reset_tag(address),
+	address = kasan_reset_tag(address);
+
+	/* Skip KFENCE memory if called explicitly outside of sl*b. */
+	if (is_kfence_address(address))
+		return;
+
+	hw_set_mem_tag_range((void *)address,
 			round_up(size, KASAN_GRANULE_SIZE), value);
 }
 
 static inline void kasan_unpoison(const void *address, size_t size)
 {
-	hw_set_mem_tag_range(kasan_reset_tag(address),
-			round_up(size, KASAN_GRANULE_SIZE), get_tag(address));
+	u8 tag = get_tag(address);
+
+	address = kasan_reset_tag(address);
+
+	/* Skip KFENCE memory if called explicitly outside of sl*b. */
+	if (is_kfence_address(address))
+		return;
+
+	hw_set_mem_tag_range((void *)address,
+			round_up(size, KASAN_GRANULE_SIZE), tag);
 }
 
 static inline bool kasan_byte_accessible(const void *addr)
--- a/mm/kasan/shadow.c~kfence-kasan-make-kfence-compatible-with-kasan
+++ a/mm/kasan/shadow.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/kasan.h>
 #include <linux/kernel.h>
+#include <linux/kfence.h>
 #include <linux/kmemleak.h>
 #include <linux/memory.h>
 #include <linux/mm.h>
@@ -84,6 +85,10 @@ void kasan_poison(const void *address, s
 	address = kasan_reset_tag(address);
 	size = round_up(size, KASAN_GRANULE_SIZE);
 
+	/* Skip KFENCE memory if called explicitly outside of sl*b. */
+	if (is_kfence_address(address))
+		return;
+
 	shadow_start = kasan_mem_to_shadow(address);
 	shadow_end = kasan_mem_to_shadow(address + size);
 
@@ -102,6 +107,14 @@ void kasan_unpoison(const void *address,
 	 */
 	address = kasan_reset_tag(address);
 
+	/*
+	 * Skip KFENCE memory if called explicitly outside of sl*b. Also note
+	 * that calls to ksize(), where size is not a multiple of machine-word
+	 * size, would otherwise poison the invalid portion of the word.
+	 */
+	if (is_kfence_address(address))
+		return;
+
 	kasan_poison(address, size, tag);
 
 	if (size & KASAN_GRANULE_MASK) {
_
