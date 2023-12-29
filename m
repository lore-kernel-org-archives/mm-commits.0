Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA66813AFC
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kmRpaFrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9640AC433C8;
	Fri, 29 Dec 2023 20:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880050;
	bh=k8Y6sF1EWjMEzeNE179M039/90qjrgwAJE818PZLFis=;
	h=Date:To:From:Subject:From;
	b=kmRpaFrRe3i3de44AFGJCkNvlLIzgCbq15Evo2orgzioEw+sLv8215Bhw7tgIhsRZ
	 4jsvxn42VMFOy4WZHJBHJItOSWEBn0b1+IdLCZLjFBRA5jM8x8X7Yp+P/i8CDZzfB/
	 vDz0gOsyBuxVw5SKHUkdS3XkvncPqHckkIt4siqk=
Date: Fri, 29 Dec 2023 12:00:50 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-add-mempool-tests.patch removed from -mm tree
Message-Id: <20231229200050.9640AC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: add mempool tests
has been removed from the -mm tree.  Its filename was
     kasan-add-mempool-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: add mempool tests
Date: Tue, 19 Dec 2023 23:29:00 +0100

Add KASAN tests for mempool.

Link: https://lkml.kernel.org/r/5fd64732266be8287711b6408d86ffc78784be06.1703024586.git.andreyknvl@google.com
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

 mm/kasan/kasan_test.c |  319 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 319 insertions(+)

--- a/mm/kasan/kasan_test.c~kasan-add-mempool-tests
+++ a/mm/kasan/kasan_test.c
@@ -13,6 +13,7 @@
 #include <linux/io.h>
 #include <linux/kasan.h>
 #include <linux/kernel.h>
+#include <linux/mempool.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/module.h>
@@ -810,6 +811,312 @@ static void kmem_cache_bulk(struct kunit
 	kmem_cache_destroy(cache);
 }
 
+static void *mempool_prepare_kmalloc(struct kunit *test, mempool_t *pool, size_t size)
+{
+	int pool_size = 4;
+	int ret;
+	void *elem;
+
+	memset(pool, 0, sizeof(*pool));
+	ret = mempool_init_kmalloc_pool(pool, pool_size, size);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
+	/*
+	 * Allocate one element to prevent mempool from freeing elements to the
+	 * underlying allocator and instead make it add them to the element
+	 * list when the tests trigger double-free and invalid-free bugs.
+	 * This allows testing KASAN annotations in add_element().
+	 */
+	elem = mempool_alloc_preallocated(pool);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, elem);
+
+	return elem;
+}
+
+static struct kmem_cache *mempool_prepare_slab(struct kunit *test, mempool_t *pool, size_t size)
+{
+	struct kmem_cache *cache;
+	int pool_size = 4;
+	int ret;
+
+	cache = kmem_cache_create("test_cache", size, 0, 0, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
+
+	memset(pool, 0, sizeof(*pool));
+	ret = mempool_init_slab_pool(pool, pool_size, cache);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
+	/*
+	 * Do not allocate one preallocated element, as we skip the double-free
+	 * and invalid-free tests for slab mempool for simplicity.
+	 */
+
+	return cache;
+}
+
+static void *mempool_prepare_page(struct kunit *test, mempool_t *pool, int order)
+{
+	int pool_size = 4;
+	int ret;
+	void *elem;
+
+	memset(pool, 0, sizeof(*pool));
+	ret = mempool_init_page_pool(pool, pool_size, order);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
+	elem = mempool_alloc_preallocated(pool);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, elem);
+
+	return elem;
+}
+
+static void mempool_oob_right_helper(struct kunit *test, mempool_t *pool, size_t size)
+{
+	char *elem;
+
+	elem = mempool_alloc_preallocated(pool);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, elem);
+
+	OPTIMIZER_HIDE_VAR(elem);
+
+	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
+		KUNIT_EXPECT_KASAN_FAIL(test,
+			((volatile char *)&elem[size])[0]);
+	else
+		KUNIT_EXPECT_KASAN_FAIL(test,
+			((volatile char *)&elem[round_up(size, KASAN_GRANULE_SIZE)])[0]);
+
+	mempool_free(elem, pool);
+}
+
+static void mempool_kmalloc_oob_right(struct kunit *test)
+{
+	mempool_t pool;
+	size_t size = 128 - KASAN_GRANULE_SIZE - 5;
+	void *extra_elem;
+
+	extra_elem = mempool_prepare_kmalloc(test, &pool, size);
+
+	mempool_oob_right_helper(test, &pool, size);
+
+	mempool_free(extra_elem, &pool);
+	mempool_exit(&pool);
+}
+
+static void mempool_kmalloc_large_oob_right(struct kunit *test)
+{
+	mempool_t pool;
+	size_t size = KMALLOC_MAX_CACHE_SIZE + 1;
+	void *extra_elem;
+
+	extra_elem = mempool_prepare_kmalloc(test, &pool, size);
+
+	mempool_oob_right_helper(test, &pool, size);
+
+	mempool_free(extra_elem, &pool);
+	mempool_exit(&pool);
+}
+
+static void mempool_slab_oob_right(struct kunit *test)
+{
+	mempool_t pool;
+	size_t size = 123;
+	struct kmem_cache *cache;
+
+	cache = mempool_prepare_slab(test, &pool, size);
+
+	mempool_oob_right_helper(test, &pool, size);
+
+	mempool_exit(&pool);
+	kmem_cache_destroy(cache);
+}
+
+/*
+ * Skip the out-of-bounds test for page mempool. With Generic KASAN, page
+ * allocations have no redzones, and thus the out-of-bounds detection is not
+ * guaranteed; see https://bugzilla.kernel.org/show_bug.cgi?id=210503. With
+ * the tag-based KASAN modes, the neighboring allocation might have the same
+ * tag; see https://bugzilla.kernel.org/show_bug.cgi?id=203505.
+ */
+
+static void mempool_uaf_helper(struct kunit *test, mempool_t *pool, bool page)
+{
+	char *elem, *ptr;
+
+	elem = mempool_alloc_preallocated(pool);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, elem);
+
+	mempool_free(elem, pool);
+
+	ptr = page ? page_address((struct page *)elem) : elem;
+	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
+}
+
+static void mempool_kmalloc_uaf(struct kunit *test)
+{
+	mempool_t pool;
+	size_t size = 128;
+	void *extra_elem;
+
+	extra_elem = mempool_prepare_kmalloc(test, &pool, size);
+
+	mempool_uaf_helper(test, &pool, false);
+
+	mempool_free(extra_elem, &pool);
+	mempool_exit(&pool);
+}
+
+static void mempool_kmalloc_large_uaf(struct kunit *test)
+{
+	mempool_t pool;
+	size_t size = KMALLOC_MAX_CACHE_SIZE + 1;
+	void *extra_elem;
+
+	/* page_alloc fallback is only implemented for SLUB. */
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_SLUB);
+
+	extra_elem = mempool_prepare_kmalloc(test, &pool, size);
+
+	mempool_uaf_helper(test, &pool, false);
+
+	mempool_free(extra_elem, &pool);
+	mempool_exit(&pool);
+}
+
+static void mempool_slab_uaf(struct kunit *test)
+{
+	mempool_t pool;
+	size_t size = 123;
+	struct kmem_cache *cache;
+
+	cache = mempool_prepare_slab(test, &pool, size);
+
+	mempool_uaf_helper(test, &pool, false);
+
+	mempool_exit(&pool);
+	kmem_cache_destroy(cache);
+}
+
+static void mempool_page_alloc_uaf(struct kunit *test)
+{
+	mempool_t pool;
+	int order = 2;
+	void *extra_elem;
+
+	extra_elem = mempool_prepare_page(test, &pool, order);
+
+	mempool_uaf_helper(test, &pool, true);
+
+	mempool_free(extra_elem, &pool);
+	mempool_exit(&pool);
+}
+
+static void mempool_double_free_helper(struct kunit *test, mempool_t *pool)
+{
+	char *elem;
+
+	elem = mempool_alloc_preallocated(pool);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, elem);
+
+	mempool_free(elem, pool);
+
+	KUNIT_EXPECT_KASAN_FAIL(test, mempool_free(elem, pool));
+}
+
+static void mempool_kmalloc_double_free(struct kunit *test)
+{
+	mempool_t pool;
+	size_t size = 128;
+	char *extra_elem;
+
+	extra_elem = mempool_prepare_kmalloc(test, &pool, size);
+
+	mempool_double_free_helper(test, &pool);
+
+	mempool_free(extra_elem, &pool);
+	mempool_exit(&pool);
+}
+
+static void mempool_kmalloc_large_double_free(struct kunit *test)
+{
+	mempool_t pool;
+	size_t size = KMALLOC_MAX_CACHE_SIZE + 1;
+	char *extra_elem;
+
+	/* page_alloc fallback is only implemented for SLUB. */
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_SLUB);
+
+	extra_elem = mempool_prepare_kmalloc(test, &pool, size);
+
+	mempool_double_free_helper(test, &pool);
+
+	mempool_free(extra_elem, &pool);
+	mempool_exit(&pool);
+}
+
+static void mempool_page_alloc_double_free(struct kunit *test)
+{
+	mempool_t pool;
+	int order = 2;
+	char *extra_elem;
+
+	extra_elem = mempool_prepare_page(test, &pool, order);
+
+	mempool_double_free_helper(test, &pool);
+
+	mempool_free(extra_elem, &pool);
+	mempool_exit(&pool);
+}
+
+static void mempool_kmalloc_invalid_free_helper(struct kunit *test, mempool_t *pool)
+{
+	char *elem;
+
+	elem = mempool_alloc_preallocated(pool);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, elem);
+
+	KUNIT_EXPECT_KASAN_FAIL(test, mempool_free(elem + 1, pool));
+
+	mempool_free(elem, pool);
+}
+
+static void mempool_kmalloc_invalid_free(struct kunit *test)
+{
+	mempool_t pool;
+	size_t size = 128;
+	char *extra_elem;
+
+	extra_elem = mempool_prepare_kmalloc(test, &pool, size);
+
+	mempool_kmalloc_invalid_free_helper(test, &pool);
+
+	mempool_free(extra_elem, &pool);
+	mempool_exit(&pool);
+}
+
+static void mempool_kmalloc_large_invalid_free(struct kunit *test)
+{
+	mempool_t pool;
+	size_t size = KMALLOC_MAX_CACHE_SIZE + 1;
+	char *extra_elem;
+
+	/* page_alloc fallback is only implemented for SLUB. */
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_SLUB);
+
+	extra_elem = mempool_prepare_kmalloc(test, &pool, size);
+
+	mempool_kmalloc_invalid_free_helper(test, &pool);
+
+	mempool_free(extra_elem, &pool);
+	mempool_exit(&pool);
+}
+
+/*
+ * Skip the invalid-free test for page mempool. The invalid-free detection only
+ * works for compound pages and mempool preallocates all page elements without
+ * the __GFP_COMP flag.
+ */
+
 static char global_array[10];
 
 static void kasan_global_oob_right(struct kunit *test)
@@ -1550,6 +1857,18 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kmem_cache_oob),
 	KUNIT_CASE(kmem_cache_accounted),
 	KUNIT_CASE(kmem_cache_bulk),
+	KUNIT_CASE(mempool_kmalloc_oob_right),
+	KUNIT_CASE(mempool_kmalloc_large_oob_right),
+	KUNIT_CASE(mempool_slab_oob_right),
+	KUNIT_CASE(mempool_kmalloc_uaf),
+	KUNIT_CASE(mempool_kmalloc_large_uaf),
+	KUNIT_CASE(mempool_slab_uaf),
+	KUNIT_CASE(mempool_page_alloc_uaf),
+	KUNIT_CASE(mempool_kmalloc_double_free),
+	KUNIT_CASE(mempool_kmalloc_large_double_free),
+	KUNIT_CASE(mempool_page_alloc_double_free),
+	KUNIT_CASE(mempool_kmalloc_invalid_free),
+	KUNIT_CASE(mempool_kmalloc_large_invalid_free),
 	KUNIT_CASE(kasan_global_oob_right),
 	KUNIT_CASE(kasan_global_oob_left),
 	KUNIT_CASE(kasan_stack_oob),
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

