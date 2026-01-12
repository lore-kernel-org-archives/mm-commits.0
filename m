Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E897379995
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 17:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768238574; cv=none; b=orTk+q/KjAbuspvZdZIYa/4DAKYE1MwqS8VaMiU1y/KKNaovQ0iwyWfAElitpvYu2el4ZLOf6nDedpVoh3j4tHHaE80nJCH3NpU9+i8Yn55YaTaw69CQbzBU3rdInlykdvfbIFnf1cXW/23l6PItcj5+D6stWPthmwww4mftiFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768238574; c=relaxed/simple;
	bh=AK1628yHqQPtl1bkWaKNAMNmphQxcz32Fh4+8dk4u58=;
	h=Date:To:From:Subject:Message-Id; b=GIZ9uNHyra8WPeBc7LF0Egrk5K8BDqVW8YJvS+pwvkjdiXFWA1OPRhs6SE4UyVvGFqIQJW4N/jO6mgkLMIYpDHVNdm6usa3eIK76Xgx2knB4pkUfjDWK6OEKcTa333kIu1/QU3CUKRQ0Zb7Z2csYl6uxLA5wL6AXpENxFnoZOpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F6EIbGR4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F6EIbGR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D34C16AAE;
	Mon, 12 Jan 2026 17:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768238574;
	bh=AK1628yHqQPtl1bkWaKNAMNmphQxcz32Fh4+8dk4u58=;
	h=Date:To:From:Subject:From;
	b=F6EIbGR4wrrROQeK9H04krDX2WS6XkKtS39UnTCXtgDtMoW+UYb+x1tGD4rs9Fhz7
	 y6WP8RQMmWszP/Rc6Fa/XXOlZ81OiRbmFCtH+RMFaiFojFGNrYoSu8YqrbfdssjKt4
	 hlAf/zD8UjH99asbedIHMBVqRTzYEQ3DPZTs2sH0=
Date: Mon, 12 Jan 2026 09:22:53 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,elver@google.com,dvyukov@google.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmsan-add-tests-for-high-order-page-freeing.patch added to mm-new branch
Message-Id: <20260112172254.06D34C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmsan: add tests for high-order page freeing
has been added to the -mm mm-new branch.  Its filename is
     mm-kmsan-add-tests-for-high-order-page-freeing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmsan-add-tests-for-high-order-page-freeing.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: mm: kmsan: add tests for high-order page freeing
Date: Mon, 12 Jan 2026 15:51:50 +0100

Add regression tests to verify that KMSAN correctly poisons the full
memory range when freeing pages.

Specifically, verify that accessing the tail pages of a high-order
non-compound allocation triggers a use-after-free report.  This ensures
that the fix "mm: kmsan: Fix poisoning of high-order non-compound pages"
is working as expected.

Also add a test for standard order-0 pages for completeness.

Link: https://lore.kernel.org/all/20260104134348.3544298-1-ryan.roberts@arm.com/
Link: https://lkml.kernel.org/r/20260112145150.3259084-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/kmsan_test.c |   48 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

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
@@ -378,6 +378,50 @@ static void test_uaf(struct kunit *test)
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
 }
 
+/* Test case: ensure that use-after-free reporting works for freed pages. */
+static void test_uaf_pages(struct kunit *test)
+{
+	EXPECTATION_USE_AFTER_FREE(expect);
+	const int order = 0;
+	volatile char value;
+	struct page *page;
+	volatile char *var;
+
+	kunit_info(test, "use-after-free on a freed page (UMR report)\n");
+
+	/* Memory is initialized up until __free_pages() thanks to __GFP_ZERO. */
+	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
+	var = page_address(page);
+	__free_pages(page, order);
+
+	/* Copy the invalid value before checking it. */
+	value = var[3];
+	USE(value);
+	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
+}
+
+/* Test case: ensure that use-after-free reporting works for alloc_pages. */
+static void test_uaf_high_order_pages(struct kunit *test)
+{
+	EXPECTATION_USE_AFTER_FREE(expect);
+	const int order = 1;
+	volatile char value;
+	struct page *page;
+	volatile char *var;
+
+	kunit_info(test,
+		   "use-after-free on a freed high-order page (UMR report)\n");
+
+	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
+	var = page_address(page) + PAGE_SIZE;
+	__free_pages(page, order);
+
+	/* Copy the invalid value before checking it. */
+	value = var[3];
+	USE(value);
+	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
+}
+
 /*
  * Test case: ensure that uninitialized values are propagated through per-CPU
  * memory.
@@ -683,6 +727,8 @@ static struct kunit_case kmsan_test_case
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

mm-kmsan-add-tests-for-high-order-page-freeing.patch

