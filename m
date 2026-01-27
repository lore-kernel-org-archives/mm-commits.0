Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D9A3191B9
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486724; cv=none; b=PvfarH2SwuqxoPIFqUCRywSemTaGRPGJEkWDSsem4TJEtwfzRfOZNi0aGHDMvQqG8UpUibbT/r8m+ozJLIegx4hkWQ2RwYTwiKJRZyeAcN3D4PU/4iF27vTGgVA3hQtDTcllYBGh2IkxwZj6v9DMYz4g/dXLntenvB9LqhFrrIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486724; c=relaxed/simple;
	bh=AD99qlhX37/T3A0zg4znpa9ted42eh5dY1H2DMxO074=;
	h=Date:To:From:Subject:Message-Id; b=h3QLB7SPXfQ5PLaudRSzD/jwP8zqYxtw8xwLsy1pxGo4RMzoZP39XTuJ2cy/bsp8jDO3ljC1X89t1pMidPCqQmQXaSoxfu18x/dQ0thCkWP9bVuEtIhDlUGDjV1uApTyWQAFV+lgFutVzTXcLN8PHBNrtVi6pMTW+yxJnM+959g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=anqd2Cok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="anqd2Cok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1FDC116C6;
	Tue, 27 Jan 2026 04:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486724;
	bh=AD99qlhX37/T3A0zg4znpa9ted42eh5dY1H2DMxO074=;
	h=Date:To:From:Subject:From;
	b=anqd2CokNa0RX9CI3R1Z4gNSHH23LClUzK/XseqCCTRP/l2QcleAfH6Mmz5DRSON0
	 JqoWwbxKf5eObTxpSdavWD/r5pvbTOVamTYICWc8ETv+Zc1Yi37WoXdTTqsQKLEhiP
	 DogTIQ0MKqvNQrJtT8yA/UFc2VIgonIst2CAwX/Y=
Date: Mon, 26 Jan 2026 20:05:23 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,elver@google.com,dvyukov@google.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmsan-add-tests-for-high-order-page-freeing.patch removed from -mm tree
Message-Id: <20260127040524.2C1FDC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kmsan: add tests for high-order page freeing
has been removed from the -mm tree.  Its filename was
     mm-kmsan-add-tests-for-high-order-page-freeing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: mm: kmsan: add tests for high-order page freeing
Date: Tue, 13 Jan 2026 10:11:50 +0100

Add regression tests to verify that KMSAN correctly poisons the full
memory range when freeing pages.

Specifically, verify that accessing the tail pages of a high-order
non-compound allocation triggers a use-after-free report.  This ensures
that the fix "mm: kmsan: Fix poisoning of high-order non-compound pages"
is working as expected.

Also add a test for standard order-0 pages for completeness.

Link: https://lore.kernel.org/all/20260104134348.3544298-1-ryan.roberts@arm.com/
Link: https://lkml.kernel.org/r/20260113091151.4035013-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/kmsan_test.c |   49 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

--- a/mm/kmsan/kmsan_test.c~mm-kmsan-add-tests-for-high-order-page-freeing
+++ a/mm/kmsan/kmsan_test.c
@@ -361,7 +361,7 @@ static void test_init_vmalloc(struct kun
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
 }
 
-/* Test case: ensure that use-after-free reporting works. */
+/* Test case: ensure that use-after-free reporting works for kmalloc. */
 static void test_uaf(struct kunit *test)
 {
 	EXPECTATION_USE_AFTER_FREE(expect);
@@ -378,6 +378,51 @@ static void test_uaf(struct kunit *test)
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
 }
 
+static volatile char *test_uaf_pages_helper(int order, int offset)
+{
+	struct page *page;
+	volatile char *var;
+
+	/* Memory is initialized up until __free_pages() thanks to __GFP_ZERO. */
+	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
+	var = page_address(page) + offset;
+	__free_pages(page, order);
+
+	return var;
+}
+
+/* Test case: ensure that use-after-free reporting works for a freed page. */
+static void test_uaf_pages(struct kunit *test)
+{
+	EXPECTATION_USE_AFTER_FREE(expect);
+	volatile char value;
+
+	kunit_info(test, "use-after-free on a freed page (UMR report)\n");
+	/* Allocate a single page, free it, then try to access it. */
+	value = *test_uaf_pages_helper(0, 3);
+	USE(value);
+
+	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
+}
+
+/* Test case: ensure that UAF reporting works for high order pages. */
+static void test_uaf_high_order_pages(struct kunit *test)
+{
+	EXPECTATION_USE_AFTER_FREE(expect);
+	volatile char value;
+
+	kunit_info(test,
+		   "use-after-free on a freed high-order page (UMR report)\n");
+	/*
+	 * Create a high-order non-compound page, free it, then try to access
+	 * its tail page.
+	 */
+	value = *test_uaf_pages_helper(1, PAGE_SIZE + 3);
+	USE(value);
+
+	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
+}
+
 /*
  * Test case: ensure that uninitialized values are propagated through per-CPU
  * memory.
@@ -683,6 +728,8 @@ static struct kunit_case kmsan_test_case
 	KUNIT_CASE(test_init_kmsan_vmap_vunmap),
 	KUNIT_CASE(test_init_vmalloc),
 	KUNIT_CASE(test_uaf),
+	KUNIT_CASE(test_uaf_pages),
+	KUNIT_CASE(test_uaf_high_order_pages),
 	KUNIT_CASE(test_percpu_propagate),
 	KUNIT_CASE(test_printk),
 	KUNIT_CASE(test_init_memcpy),
_

Patches currently in -mm which might be from glider@google.com are


