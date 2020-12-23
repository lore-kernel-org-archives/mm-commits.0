Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A78AC433E9
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6578C222F9
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgLWSaL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 13:30:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728442AbgLWSaJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 13:30:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FE9B22482;
        Wed, 23 Dec 2020 18:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608748190;
        bh=6A1Y5PP4zHNQqSL3BAYQURrjGfsXDIn+vrme9xn2btA=;
        h=Date:From:To:Subject:From;
        b=PJ9DOJYdqp8Pd+Gh1X25jP8/iYs0VUnjIi3MMzAvVlnU0cxBGL4FK/FSsPNnYk1eY
         ZCIH8hc6XouBHLjwzdDizpY/X4lI9XvOvjKkTkLyXA6Cwr/M8QnGn6+5X82xOq3sQ7
         Ow8xA3yAwx80+mPTmvzjnT2LxeJhff6AvosVic2A=
Date:   Wed, 23 Dec 2020 10:29:49 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, gor@linux.ibm.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [merged]
 kasan-inline-kasan_reset_tag-for-tag-based-modes.patch removed from -mm
 tree
Message-ID: <20201223182949._mIW8BE7g%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: inline kasan_reset_tag for tag-based modes
has been removed from the -mm tree.  Its filename was
     kasan-inline-kasan_reset_tag-for-tag-based-modes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: inline kasan_reset_tag for tag-based modes

Using kasan_reset_tag() currently results in a function call. As it's
called quite often from the allocator code, this leads to a noticeable
slowdown. Move it to include/linux/kasan.h and turn it into a static
inline function. Also remove the now unneeded reset_tag() internal KASAN
macro and use kasan_reset_tag() instead.

Link: https://lkml.kernel.org/r/6940383a3a9dfb416134d338d8fac97a9ebb8686.1606162397.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/I4d2061acfe91d480a75df00b07c22d8494ef14b5
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
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

 include/linux/kasan.h     |    5 ++++-
 mm/kasan/common.c         |    6 +++---
 mm/kasan/hw_tags.c        |    9 ++-------
 mm/kasan/kasan.h          |    4 ----
 mm/kasan/report.c         |    4 ++--
 mm/kasan/report_hw_tags.c |    2 +-
 mm/kasan/report_sw_tags.c |    4 ++--
 mm/kasan/shadow.c         |    4 ++--
 mm/kasan/sw_tags.c        |    9 ++-------
 9 files changed, 18 insertions(+), 29 deletions(-)

--- a/include/linux/kasan.h~kasan-inline-kasan_reset_tag-for-tag-based-modes
+++ a/include/linux/kasan.h
@@ -194,7 +194,10 @@ static inline void kasan_record_aux_stac
 
 #if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
 
-void *kasan_reset_tag(const void *addr);
+static inline void *kasan_reset_tag(const void *addr)
+{
+	return (void *)arch_kasan_reset_tag(addr);
+}
 
 bool kasan_report(unsigned long addr, size_t size,
 		bool is_write, unsigned long ip);
--- a/mm/kasan/common.c~kasan-inline-kasan_reset_tag-for-tag-based-modes
+++ a/mm/kasan/common.c
@@ -179,14 +179,14 @@ size_t kasan_metadata_size(struct kmem_c
 struct kasan_alloc_meta *kasan_get_alloc_meta(struct kmem_cache *cache,
 					      const void *object)
 {
-	return (void *)reset_tag(object) + cache->kasan_info.alloc_meta_offset;
+	return kasan_reset_tag(object) + cache->kasan_info.alloc_meta_offset;
 }
 
 struct kasan_free_meta *kasan_get_free_meta(struct kmem_cache *cache,
 					    const void *object)
 {
 	BUILD_BUG_ON(sizeof(struct kasan_free_meta) > 32);
-	return (void *)reset_tag(object) + cache->kasan_info.free_meta_offset;
+	return kasan_reset_tag(object) + cache->kasan_info.free_meta_offset;
 }
 
 void kasan_poison_slab(struct page *page)
@@ -283,7 +283,7 @@ static bool __kasan_slab_free(struct kme
 
 	tag = get_tag(object);
 	tagged_object = object;
-	object = reset_tag(object);
+	object = kasan_reset_tag(object);
 
 	if (unlikely(nearest_obj(cache, virt_to_head_page(object), object) !=
 	    object)) {
--- a/mm/kasan/hw_tags.c~kasan-inline-kasan_reset_tag-for-tag-based-modes
+++ a/mm/kasan/hw_tags.c
@@ -30,20 +30,15 @@ void __init kasan_init_hw_tags(void)
 	pr_info("KernelAddressSanitizer initialized\n");
 }
 
-void *kasan_reset_tag(const void *addr)
-{
-	return reset_tag(addr);
-}
-
 void poison_range(const void *address, size_t size, u8 value)
 {
-	hw_set_mem_tag_range(reset_tag(address),
+	hw_set_mem_tag_range(kasan_reset_tag(address),
 			round_up(size, KASAN_GRANULE_SIZE), value);
 }
 
 void unpoison_range(const void *address, size_t size)
 {
-	hw_set_mem_tag_range(reset_tag(address),
+	hw_set_mem_tag_range(kasan_reset_tag(address),
 			round_up(size, KASAN_GRANULE_SIZE), get_tag(address));
 }
 
--- a/mm/kasan/kasan.h~kasan-inline-kasan_reset_tag-for-tag-based-modes
+++ a/mm/kasan/kasan.h
@@ -248,15 +248,11 @@ static inline const void *arch_kasan_set
 	return addr;
 }
 #endif
-#ifndef arch_kasan_reset_tag
-#define arch_kasan_reset_tag(addr)	((void *)(addr))
-#endif
 #ifndef arch_kasan_get_tag
 #define arch_kasan_get_tag(addr)	0
 #endif
 
 #define set_tag(addr, tag)	((void *)arch_kasan_set_tag((addr), (tag)))
-#define reset_tag(addr)		((void *)arch_kasan_reset_tag(addr))
 #define get_tag(addr)		arch_kasan_get_tag(addr)
 
 #ifdef CONFIG_KASAN_HW_TAGS
--- a/mm/kasan/report.c~kasan-inline-kasan_reset_tag-for-tag-based-modes
+++ a/mm/kasan/report.c
@@ -328,7 +328,7 @@ void kasan_report_invalid_free(void *obj
 	unsigned long flags;
 	u8 tag = get_tag(object);
 
-	object = reset_tag(object);
+	object = kasan_reset_tag(object);
 
 #if IS_ENABLED(CONFIG_KUNIT)
 	if (current->kunit_test)
@@ -361,7 +361,7 @@ static void __kasan_report(unsigned long
 	disable_trace_on_warning();
 
 	tagged_addr = (void *)addr;
-	untagged_addr = reset_tag(tagged_addr);
+	untagged_addr = kasan_reset_tag(tagged_addr);
 
 	info.access_addr = tagged_addr;
 	if (addr_has_metadata(untagged_addr))
--- a/mm/kasan/report_hw_tags.c~kasan-inline-kasan_reset_tag-for-tag-based-modes
+++ a/mm/kasan/report_hw_tags.c
@@ -22,7 +22,7 @@ const char *get_bug_type(struct kasan_ac
 
 void *find_first_bad_addr(void *addr, size_t size)
 {
-	return reset_tag(addr);
+	return kasan_reset_tag(addr);
 }
 
 void metadata_fetch_row(char *buffer, void *row)
--- a/mm/kasan/report_sw_tags.c~kasan-inline-kasan_reset_tag-for-tag-based-modes
+++ a/mm/kasan/report_sw_tags.c
@@ -41,7 +41,7 @@ const char *get_bug_type(struct kasan_ac
 	int i;
 
 	tag = get_tag(info->access_addr);
-	addr = reset_tag(info->access_addr);
+	addr = kasan_reset_tag(info->access_addr);
 	page = kasan_addr_to_page(addr);
 	if (page && PageSlab(page)) {
 		cache = page->slab_cache;
@@ -72,7 +72,7 @@ const char *get_bug_type(struct kasan_ac
 void *find_first_bad_addr(void *addr, size_t size)
 {
 	u8 tag = get_tag(addr);
-	void *p = reset_tag(addr);
+	void *p = kasan_reset_tag(addr);
 	void *end = p + size;
 
 	while (p < end && tag == *(u8 *)kasan_mem_to_shadow(p))
--- a/mm/kasan/shadow.c~kasan-inline-kasan_reset_tag-for-tag-based-modes
+++ a/mm/kasan/shadow.c
@@ -81,7 +81,7 @@ void poison_range(const void *address, s
 	 * some of the callers (e.g. kasan_poison_object_data) pass tagged
 	 * addresses to this function.
 	 */
-	address = reset_tag(address);
+	address = kasan_reset_tag(address);
 
 	shadow_start = kasan_mem_to_shadow(address);
 	shadow_end = kasan_mem_to_shadow(address + size);
@@ -98,7 +98,7 @@ void unpoison_range(const void *address,
 	 * some of the callers (e.g. kasan_unpoison_object_data) pass tagged
 	 * addresses to this function.
 	 */
-	address = reset_tag(address);
+	address = kasan_reset_tag(address);
 
 	poison_range(address, size, tag);
 
--- a/mm/kasan/sw_tags.c~kasan-inline-kasan_reset_tag-for-tag-based-modes
+++ a/mm/kasan/sw_tags.c
@@ -67,11 +67,6 @@ u8 random_tag(void)
 	return (u8)(state % (KASAN_TAG_MAX + 1));
 }
 
-void *kasan_reset_tag(const void *addr)
-{
-	return reset_tag(addr);
-}
-
 bool check_memory_region(unsigned long addr, size_t size, bool write,
 				unsigned long ret_ip)
 {
@@ -107,7 +102,7 @@ bool check_memory_region(unsigned long a
 	if (tag == KASAN_TAG_KERNEL)
 		return true;
 
-	untagged_addr = reset_tag((const void *)addr);
+	untagged_addr = kasan_reset_tag((const void *)addr);
 	if (unlikely(untagged_addr <
 			kasan_shadow_to_mem((void *)KASAN_SHADOW_START))) {
 		return !kasan_report(addr, size, write, ret_ip);
@@ -126,7 +121,7 @@ bool check_memory_region(unsigned long a
 bool check_invalid_free(void *addr)
 {
 	u8 tag = get_tag(addr);
-	u8 shadow_byte = READ_ONCE(*(u8 *)kasan_mem_to_shadow(reset_tag(addr)));
+	u8 shadow_byte = READ_ONCE(*(u8 *)kasan_mem_to_shadow(kasan_reset_tag(addr)));
 
 	return (shadow_byte == KASAN_TAG_INVALID) ||
 		(tag != KASAN_TAG_KERNEL && tag != shadow_byte);
_

Patches currently in -mm which might be from andreyknvl@google.com are


