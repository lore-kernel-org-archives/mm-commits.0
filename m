Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B381632E7
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 23:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768345546; cv=none; b=LaAOFo/h40a8lAqZ9GF3cjYOxHPai3RSSzttgCcjDJRHc/bARYEF6QSTG59kOpc0GcR2MAAdt8UDBE9cIHqq50Wa1M2Z/TA6QBiDW3LUp7bWTdMT/D6ia41OnOEDIDcX37Fv2YN8ORz4w7YThCt7oM8yXAXc7rY1/dLwVQ9v/xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768345546; c=relaxed/simple;
	bh=mhQ2H/j1pmIDg6qGvOP+lVzWPRki7EuRX9mwO9ZbCoM=;
	h=Date:To:From:Subject:Message-Id; b=WB0mtn3Z/1XkEU25YTXhtE0Zd6HBJKBpHvXk7ZL6KHQhyC2j9k00lnfdtSGYzmQnwAxYc5MTXNZhe7Z3e2qHR9oRSXSxY98lecXYQnnrm9vySQTZGeGx7/RsobBkOiUpjCR2UnkG0qIk5U9hIDbs19o7E7DJedOQ4GeGcDe9nto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HbGNoKae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HbGNoKae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7015EC116C6;
	Tue, 13 Jan 2026 23:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768345545;
	bh=mhQ2H/j1pmIDg6qGvOP+lVzWPRki7EuRX9mwO9ZbCoM=;
	h=Date:To:From:Subject:From;
	b=HbGNoKaeO6vxVaohgx9fsrBnzVDT4zLaenl3ufBvWzwb/N9q2mYula/ZbylNqbpTk
	 neNIczJT5Zr5CAHdAvElDT7dpz0VRUpY6JlBor5uc2JwQkNYrZEZV+1ArLhRA4lOTi
	 Ns2TQOIPq8t4eoJWV+yO/zbfMHBbEbBQGa8rCMxY=
Date: Tue, 13 Jan 2026 15:05:44 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,elver@google.com,dvyukov@google.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmsan-add-tests-for-high-order-page-freeing.patch added to mm-new branch
Message-Id: <20260113230545.7015EC116C6@smtp.kernel.org>
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

mm-kmsan-add-tests-for-high-order-page-freeing.patch
mm-kmsan-add-test_uninit_page.patch

