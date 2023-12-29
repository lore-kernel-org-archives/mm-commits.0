Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C4113AF9
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0PvsW2Ed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B33DC433C7;
	Fri, 29 Dec 2023 20:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880051;
	bh=fWnNQ4yd583BTmvOVbqvI/bwetv2dL5lVASVg2pXlSY=;
	h=Date:To:From:Subject:From;
	b=0PvsW2Ed0+gvsues94GVFoBnmr3F9Q8lQGNjaC3nxhMRw1KALLvkIwH3VHudTAhVC
	 F8yb2Qa6F3nLGDtm/i6rYNa7havEmUGrfUVpw3tiVo5dggKkCBYU/qcNh41M/PF2cv
	 lRW4DoO+XF2Z5+7IGLjrNCL0QVIS2Szki1tRThJE=
Date: Fri, 29 Dec 2023 12:00:51 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-rename-pagealloc-tests.patch removed from -mm tree
Message-Id: <20231229200051.9B33DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: rename pagealloc tests
has been removed from the -mm tree.  Its filename was
     kasan-rename-pagealloc-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: rename pagealloc tests
Date: Tue, 19 Dec 2023 23:29:01 +0100

Rename "pagealloc" KASAN tests:

1. Use "kmalloc_large" for tests that use large kmalloc allocations.

2. Use "page_alloc" for tests that use page_alloc.

Also clean up the comments.

Link: https://lkml.kernel.org/r/f3eef6ddb87176c40958a3e5a0bd2386b52af4c6.1703024586.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test.c |   51 ++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

--- a/mm/kasan/kasan_test.c~kasan-rename-pagealloc-tests
+++ a/mm/kasan/kasan_test.c
@@ -214,12 +214,13 @@ static void kmalloc_node_oob_right(struc
 }
 
 /*
- * These kmalloc_pagealloc_* tests try allocating a memory chunk that doesn't
- * fit into a slab cache and therefore is allocated via the page allocator
- * fallback. Since this kind of fallback is only implemented for SLUB, these
- * tests are limited to that allocator.
+ * The kmalloc_large_* tests below use kmalloc() to allocate a memory chunk
+ * that does not fit into the largest slab cache and therefore is allocated via
+ * the page_alloc fallback for SLUB. SLAB has no such fallback, and thus these
+ * tests are not supported for it.
  */
-static void kmalloc_pagealloc_oob_right(struct kunit *test)
+
+static void kmalloc_large_oob_right(struct kunit *test)
 {
 	char *ptr;
 	size_t size = KMALLOC_MAX_CACHE_SIZE + 10;
@@ -235,7 +236,7 @@ static void kmalloc_pagealloc_oob_right(
 	kfree(ptr);
 }
 
-static void kmalloc_pagealloc_uaf(struct kunit *test)
+static void kmalloc_large_uaf(struct kunit *test)
 {
 	char *ptr;
 	size_t size = KMALLOC_MAX_CACHE_SIZE + 10;
@@ -249,7 +250,7 @@ static void kmalloc_pagealloc_uaf(struct
 	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
 }
 
-static void kmalloc_pagealloc_invalid_free(struct kunit *test)
+static void kmalloc_large_invalid_free(struct kunit *test)
 {
 	char *ptr;
 	size_t size = KMALLOC_MAX_CACHE_SIZE + 10;
@@ -262,7 +263,7 @@ static void kmalloc_pagealloc_invalid_fr
 	KUNIT_EXPECT_KASAN_FAIL(test, kfree(ptr + 1));
 }
 
-static void pagealloc_oob_right(struct kunit *test)
+static void page_alloc_oob_right(struct kunit *test)
 {
 	char *ptr;
 	struct page *pages;
@@ -284,7 +285,7 @@ static void pagealloc_oob_right(struct k
 	free_pages((unsigned long)ptr, order);
 }
 
-static void pagealloc_uaf(struct kunit *test)
+static void page_alloc_uaf(struct kunit *test)
 {
 	char *ptr;
 	struct page *pages;
@@ -298,15 +299,15 @@ static void pagealloc_uaf(struct kunit *
 	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
 }
 
-static void kmalloc_large_oob_right(struct kunit *test)
+/*
+ * Check that KASAN detects an out-of-bounds access for a big object allocated
+ * via kmalloc(). But not as big as to trigger the page_alloc fallback for SLUB.
+ */
+static void kmalloc_big_oob_right(struct kunit *test)
 {
 	char *ptr;
 	size_t size = KMALLOC_MAX_CACHE_SIZE - 256;
 
-	/*
-	 * Allocate a chunk that is large enough, but still fits into a slab
-	 * and does not trigger the page allocator fallback in SLUB.
-	 */
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
@@ -404,18 +405,18 @@ static void krealloc_less_oob(struct kun
 	krealloc_less_oob_helper(test, 235, 201);
 }
 
-static void krealloc_pagealloc_more_oob(struct kunit *test)
+static void krealloc_large_more_oob(struct kunit *test)
 {
-	/* page_alloc fallback in only implemented for SLUB. */
+	/* page_alloc fallback is only implemented for SLUB. */
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_SLUB);
 
 	krealloc_more_oob_helper(test, KMALLOC_MAX_CACHE_SIZE + 201,
 					KMALLOC_MAX_CACHE_SIZE + 235);
 }
 
-static void krealloc_pagealloc_less_oob(struct kunit *test)
+static void krealloc_large_less_oob(struct kunit *test)
 {
-	/* page_alloc fallback in only implemented for SLUB. */
+	/* page_alloc fallback is only implemented for SLUB. */
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_SLUB);
 
 	krealloc_less_oob_helper(test, KMALLOC_MAX_CACHE_SIZE + 235,
@@ -1828,16 +1829,16 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kmalloc_oob_right),
 	KUNIT_CASE(kmalloc_oob_left),
 	KUNIT_CASE(kmalloc_node_oob_right),
-	KUNIT_CASE(kmalloc_pagealloc_oob_right),
-	KUNIT_CASE(kmalloc_pagealloc_uaf),
-	KUNIT_CASE(kmalloc_pagealloc_invalid_free),
-	KUNIT_CASE(pagealloc_oob_right),
-	KUNIT_CASE(pagealloc_uaf),
 	KUNIT_CASE(kmalloc_large_oob_right),
+	KUNIT_CASE(kmalloc_large_uaf),
+	KUNIT_CASE(kmalloc_large_invalid_free),
+	KUNIT_CASE(page_alloc_oob_right),
+	KUNIT_CASE(page_alloc_uaf),
+	KUNIT_CASE(kmalloc_big_oob_right),
 	KUNIT_CASE(krealloc_more_oob),
 	KUNIT_CASE(krealloc_less_oob),
-	KUNIT_CASE(krealloc_pagealloc_more_oob),
-	KUNIT_CASE(krealloc_pagealloc_less_oob),
+	KUNIT_CASE(krealloc_large_more_oob),
+	KUNIT_CASE(krealloc_large_less_oob),
 	KUNIT_CASE(krealloc_uaf),
 	KUNIT_CASE(kmalloc_oob_16),
 	KUNIT_CASE(kmalloc_uaf_16),
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

