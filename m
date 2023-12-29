Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E7A13ADC
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jR3ttso/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F358BC433C7;
	Fri, 29 Dec 2023 20:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880076;
	bh=lljLevuiyWYG1HdXWV5pXg/A+RQdRxlZlso8YpJVpYQ=;
	h=Date:To:From:Subject:From;
	b=jR3ttso/ot7tGQ1LD95XFeP9YkKYNeuLxEJkfWVIwFb/LwpmpL3qrliSVEQtEKgPZ
	 a63o/ZrWoaqPVcQACW0+FFCRttuLIEI5fB4YmgrUyEwbNAV7EqkURL5s8iXjbGYEKf
	 v6CxiwG4hygMLon79PTk5Zsra3MikBki2VCcs6cw=
Date: Fri, 29 Dec 2023 12:01:15 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-check-kasan_vmalloc_enabled-in-vmalloc-tests.patch removed from -mm tree
Message-Id: <20231229200115.F358BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: check kasan_vmalloc_enabled in vmalloc tests
has been removed from the -mm tree.  Its filename was
     kasan-check-kasan_vmalloc_enabled-in-vmalloc-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: check kasan_vmalloc_enabled in vmalloc tests
Date: Thu, 21 Dec 2023 21:04:50 +0100

Check that vmalloc poisoning is not disabled via command line when running
the vmalloc-related KASAN tests.  Skip the tests otherwise.

Link: https://lkml.kernel.org/r/954456e50ac98519910c3e24a479a18eae62f8dd.1703188911.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/hw_tags.c    |    1 +
 mm/kasan/kasan.h      |    5 +++++
 mm/kasan/kasan_test.c |   11 ++++++++++-
 3 files changed, 16 insertions(+), 1 deletion(-)

--- a/mm/kasan/hw_tags.c~kasan-check-kasan_vmalloc_enabled-in-vmalloc-tests
+++ a/mm/kasan/hw_tags.c
@@ -62,6 +62,7 @@ DEFINE_STATIC_KEY_TRUE(kasan_flag_vmallo
 #else
 DEFINE_STATIC_KEY_FALSE(kasan_flag_vmalloc);
 #endif
+EXPORT_SYMBOL_GPL(kasan_flag_vmalloc);
 
 #define PAGE_ALLOC_SAMPLE_DEFAULT	1
 #define PAGE_ALLOC_SAMPLE_ORDER_DEFAULT	3
--- a/mm/kasan/kasan.h~kasan-check-kasan_vmalloc_enabled-in-vmalloc-tests
+++ a/mm/kasan/kasan.h
@@ -83,6 +83,11 @@ static inline bool kasan_sample_page_all
 
 #else /* CONFIG_KASAN_HW_TAGS */
 
+static inline bool kasan_vmalloc_enabled(void)
+{
+	return IS_ENABLED(CONFIG_KASAN_VMALLOC);
+}
+
 static inline bool kasan_async_fault_possible(void)
 {
 	return false;
--- a/mm/kasan/kasan_test.c~kasan-check-kasan_vmalloc_enabled-in-vmalloc-tests
+++ a/mm/kasan/kasan_test.c
@@ -1552,6 +1552,9 @@ static void vmalloc_helpers_tags(struct
 
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_VMALLOC);
 
+	if (!kasan_vmalloc_enabled())
+		kunit_skip(test, "Test requires kasan.vmalloc=on");
+
 	ptr = vmalloc(PAGE_SIZE);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
@@ -1586,6 +1589,9 @@ static void vmalloc_oob(struct kunit *te
 
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_VMALLOC);
 
+	if (!kasan_vmalloc_enabled())
+		kunit_skip(test, "Test requires kasan.vmalloc=on");
+
 	v_ptr = vmalloc(size);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
 
@@ -1639,6 +1645,9 @@ static void vmap_tags(struct kunit *test
 
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_VMALLOC);
 
+	if (!kasan_vmalloc_enabled())
+		kunit_skip(test, "Test requires kasan.vmalloc=on");
+
 	p_page = alloc_pages(GFP_KERNEL, 1);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p_page);
 	p_ptr = page_address(p_page);
@@ -1757,7 +1766,7 @@ static void match_all_not_assigned(struc
 		free_pages((unsigned long)ptr, order);
 	}
 
-	if (!IS_ENABLED(CONFIG_KASAN_VMALLOC))
+	if (!kasan_vmalloc_enabled())
 		return;
 
 	for (i = 0; i < 256; i++) {
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

