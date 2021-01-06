Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB60C433E0
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 00:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01CA822E03
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 00:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbhAFAMb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Jan 2021 19:12:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:44182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbhAFAMb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Jan 2021 19:12:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4744E230FE;
        Wed,  6 Jan 2021 00:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609891884;
        bh=lcma6390eUYCp9V5XG3+ys1GrBRYbRMBhY9P+72fppo=;
        h=Date:From:To:Subject:From;
        b=yI71E9SpNZkClCO/jYMRTyie0AddFlGy5Lk7p9fhWKOak9Sr1/jipctZMoFmU3p2k
         rm49hfk5x/kQT1D5eU607LKWdq8G/tmmVSLG4lRCQlX4H1J2g1aMQ7rFGocIrCXnse
         2De3DdZ9DB/RMxmKeotjO2m7K5/mZvMRB9xq0oh8=
Date:   Tue, 05 Jan 2021 16:11:23 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  +
 kasan-fix-bug-detection-via-ksize-for-hw_tags-mode.patch added to -mm tree
Message-ID: <20210106001123.vqaPvI9HV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix bug detection via ksize for HW_TAGS mode
has been added to the -mm tree.  Its filename is
     kasan-fix-bug-detection-via-ksize-for-hw_tags-mode.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-bug-detection-via-ksize-for-hw_tags-mode.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-bug-detection-via-ksize-for-hw_tags-mode.patch

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
Subject: kasan: fix bug detection via ksize for HW_TAGS mode

The currently existing kasan_check_read/write() annotations are intended
to be used for kernel modules that have KASAN compiler instrumentation
disabled. Thus, they are only relevant for the software KASAN modes that
rely on compiler instrumentation.

However there's another use case for these annotations: ksize() checks
that the object passed to it is indeed accessible before unpoisoning the
whole object. This is currently done via __kasan_check_read(), which is
compiled away for the hardware tag-based mode that doesn't rely on
compiler instrumentation. This leads to KASAN missing detecting some
memory corruptions.

Provide another annotation called kasan_check_byte() that is available
for all KASAN modes. As the implementation rename and reuse
kasan_check_invalid_free(). Use this new annotation in ksize().

Also add a new ksize_uaf() test that checks that a use-after-free is
detected via ksize() itself, and via plain accesses that happen later.

Link: https://lkml.kernel.org/r/a83aa371e2ef96e79cbdefceebaa960a34957a79.1609871239.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/Iaabf771881d0f9ce1b969f2a62938e99d3308ec5
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan-checks.h |    6 ++++++
 include/linux/kasan.h        |   13 +++++++++++++
 lib/test_kasan.c             |   20 ++++++++++++++++++++
 mm/kasan/common.c            |   11 ++++++++++-
 mm/kasan/generic.c           |    4 ++--
 mm/kasan/kasan.h             |   10 +++++-----
 mm/kasan/sw_tags.c           |    6 +++---
 mm/slab_common.c             |   15 +++++++++------
 8 files changed, 68 insertions(+), 17 deletions(-)

--- a/include/linux/kasan-checks.h~kasan-fix-bug-detection-via-ksize-for-hw_tags-mode
+++ a/include/linux/kasan-checks.h
@@ -5,6 +5,12 @@
 #include <linux/types.h>
 
 /*
+ * The annotations present in this file are only relevant for the software
+ * KASAN modes that rely on compiler instrumentation, and will be optimized
+ * away for the hardware tag-based KASAN mode. Use kasan_check_byte() instead.
+ */
+
+/*
  * __kasan_check_*: Always available when KASAN is enabled. This may be used
  * even in compilation units that selectively disable KASAN, but must use KASAN
  * to validate access to an address.   Never use these in header files!
--- a/include/linux/kasan.h~kasan-fix-bug-detection-via-ksize-for-hw_tags-mode
+++ a/include/linux/kasan.h
@@ -243,6 +243,18 @@ static __always_inline void kasan_kfree_
 		__kasan_kfree_large(ptr, ip);
 }
 
+/*
+ * Unlike kasan_check_read/write(), kasan_check_byte() is performed even for
+ * the hardware tag-based mode that doesn't rely on compiler instrumentation.
+ */
+bool __kasan_check_byte(const void *addr, unsigned long ip);
+static __always_inline bool kasan_check_byte(const void *addr, unsigned long ip)
+{
+	if (kasan_enabled())
+		return __kasan_check_byte(addr, ip);
+	return true;
+}
+
 bool kasan_save_enable_multi_shot(void);
 void kasan_restore_multi_shot(bool enabled);
 
@@ -299,6 +311,7 @@ static inline void *kasan_krealloc(const
 	return (void *)object;
 }
 static inline void kasan_kfree_large(void *ptr, unsigned long ip) {}
+static inline bool kasan_check_byte(const void *address, unsigned long ip) {}
 
 #endif /* CONFIG_KASAN */
 
--- a/lib/test_kasan.c~kasan-fix-bug-detection-via-ksize-for-hw_tags-mode
+++ a/lib/test_kasan.c
@@ -490,6 +490,7 @@ static void kasan_global_oob(struct kuni
 	KUNIT_EXPECT_KASAN_FAIL(test, *(volatile char *)p);
 }
 
+/* Check that ksize() makes the whole object accessible. */
 static void ksize_unpoisons_memory(struct kunit *test)
 {
 	char *ptr;
@@ -508,6 +509,24 @@ static void ksize_unpoisons_memory(struc
 	kfree(ptr);
 }
 
+/*
+ * Check that a use-after-free is detected by ksize() and via normal accesses
+ * after it.
+ */
+static void ksize_uaf(struct kunit *test)
+{
+	char *ptr;
+	int size = 128 - KASAN_GRANULE_SIZE;
+
+	ptr = kmalloc(size, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+	kfree(ptr);
+
+	KUNIT_EXPECT_KASAN_FAIL(test, ksize(ptr));
+	KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = *ptr);
+	KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = *(ptr + size));
+}
+
 static void kasan_stack_oob(struct kunit *test)
 {
 	char stack_array[10];
@@ -937,6 +956,7 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kasan_alloca_oob_left),
 	KUNIT_CASE(kasan_alloca_oob_right),
 	KUNIT_CASE(ksize_unpoisons_memory),
+	KUNIT_CASE(ksize_uaf),
 	KUNIT_CASE(kmem_cache_double_free),
 	KUNIT_CASE(kmem_cache_invalid_free),
 	KUNIT_CASE(kasan_memchr),
--- a/mm/kasan/common.c~kasan-fix-bug-detection-via-ksize-for-hw_tags-mode
+++ a/mm/kasan/common.c
@@ -345,7 +345,7 @@ static bool ____kasan_slab_free(struct k
 	if (unlikely(cache->flags & SLAB_TYPESAFE_BY_RCU))
 		return false;
 
-	if (kasan_check_invalid_free(tagged_object)) {
+	if (!kasan_check(tagged_object)) {
 		kasan_report_invalid_free(tagged_object, ip);
 		return true;
 	}
@@ -490,3 +490,12 @@ void __kasan_kfree_large(void *ptr, unsi
 		kasan_report_invalid_free(ptr, ip);
 	/* The object will be poisoned by kasan_free_pages(). */
 }
+
+bool __kasan_check_byte(const void *address, unsigned long ip)
+{
+	if (!kasan_check(address)) {
+		kasan_report_invalid_free((void *)address, ip);
+		return false;
+	}
+	return true;
+}
--- a/mm/kasan/generic.c~kasan-fix-bug-detection-via-ksize-for-hw_tags-mode
+++ a/mm/kasan/generic.c
@@ -185,11 +185,11 @@ bool kasan_check_range(unsigned long add
 	return check_region_inline(addr, size, write, ret_ip);
 }
 
-bool kasan_check_invalid_free(void *addr)
+bool kasan_check(const void *addr)
 {
 	s8 shadow_byte = READ_ONCE(*(s8 *)kasan_mem_to_shadow(addr));
 
-	return shadow_byte < 0 || shadow_byte >= KASAN_GRANULE_SIZE;
+	return shadow_byte >= 0 && shadow_byte < KASAN_GRANULE_SIZE;
 }
 
 void kasan_cache_shrink(struct kmem_cache *cache)
--- a/mm/kasan/kasan.h~kasan-fix-bug-detection-via-ksize-for-hw_tags-mode
+++ a/mm/kasan/kasan.h
@@ -329,20 +329,20 @@ static inline void kasan_unpoison(const
 			round_up(size, KASAN_GRANULE_SIZE), get_tag(address));
 }
 
-static inline bool kasan_check_invalid_free(void *addr)
+static inline bool kasan_check(const void *addr)
 {
 	u8 ptr_tag = get_tag(addr);
-	u8 mem_tag = hw_get_mem_tag(addr);
+	u8 mem_tag = hw_get_mem_tag((void *)addr);
 
-	return (mem_tag == KASAN_TAG_INVALID) ||
-		(ptr_tag != KASAN_TAG_KERNEL && ptr_tag != mem_tag);
+	return (mem_tag != KASAN_TAG_INVALID) &&
+		(ptr_tag == KASAN_TAG_KERNEL || ptr_tag == mem_tag);
 }
 
 #else /* CONFIG_KASAN_HW_TAGS */
 
 void kasan_poison(const void *address, size_t size, u8 value);
 void kasan_unpoison(const void *address, size_t size);
-bool kasan_check_invalid_free(void *addr);
+bool kasan_check(const void *addr);
 
 #endif /* CONFIG_KASAN_HW_TAGS */
 
--- a/mm/kasan/sw_tags.c~kasan-fix-bug-detection-via-ksize-for-hw_tags-mode
+++ a/mm/kasan/sw_tags.c
@@ -118,13 +118,13 @@ bool kasan_check_range(unsigned long add
 	return true;
 }
 
-bool kasan_check_invalid_free(void *addr)
+bool kasan_check(const void *addr)
 {
 	u8 tag = get_tag(addr);
 	u8 shadow_byte = READ_ONCE(*(u8 *)kasan_mem_to_shadow(kasan_reset_tag(addr)));
 
-	return (shadow_byte == KASAN_TAG_INVALID) ||
-		(tag != KASAN_TAG_KERNEL && tag != shadow_byte);
+	return (shadow_byte != KASAN_TAG_INVALID) &&
+		(tag == KASAN_TAG_KERNEL || tag == shadow_byte);
 }
 
 #define DEFINE_HWASAN_LOAD_STORE(size)					\
--- a/mm/slab_common.c~kasan-fix-bug-detection-via-ksize-for-hw_tags-mode
+++ a/mm/slab_common.c
@@ -1157,11 +1157,13 @@ size_t ksize(const void *objp)
 	size_t size;
 
 	/*
-	 * We need to check that the pointed to object is valid, and only then
-	 * unpoison the shadow memory below. We use __kasan_check_read(), to
-	 * generate a more useful report at the time ksize() is called (rather
-	 * than later where behaviour is undefined due to potential
-	 * use-after-free or double-free).
+	 * We need to first check that the pointer to the object is valid, and
+	 * only then unpoison the memory. The report printed from ksize() is
+	 * more useful, then when it's printed later when the behaviour could
+	 * be undefined due to a potential use-after-free or double-free.
+	 *
+	 * We use kasan_check_byte(), which is supported for hardware tag-based
+	 * KASAN mode, unlike kasan_check_read/write().
 	 *
 	 * If the pointed to memory is invalid we return 0, to avoid users of
 	 * ksize() writing to and potentially corrupting the memory region.
@@ -1169,7 +1171,8 @@ size_t ksize(const void *objp)
 	 * We want to perform the check before __ksize(), to avoid potentially
 	 * crashing in __ksize() due to accessing invalid metadata.
 	 */
-	if (unlikely(ZERO_OR_NULL_PTR(objp)) || !__kasan_check_read(objp, 1))
+	if (unlikely(ZERO_OR_NULL_PTR(objp)) ||
+	    !kasan_check_byte(objp, _RET_IP_))
 		return 0;
 
 	size = __ksize(objp);
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-prefix-exported-functions-with-kasan_.patch
kasan-clarify-hw_tags-impact-on-tbi.patch
kasan-clean-up-comments-in-tests.patch
kasan-add-match-all-tag-tests.patch
kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode.patch
kasan-rename-config_test_kasan_module.patch
kasan-add-compiler-barriers-to-kunit_expect_kasan_fail.patch
kasan-adopt-kmalloc_uaf2-test-to-hw_tags-mode.patch
kasan-fix-memory-corruption-in-kasan_bitops_tags-test.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode.patch
kasan-add-proper-page-allocator-tests.patch

