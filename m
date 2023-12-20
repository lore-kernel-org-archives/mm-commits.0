Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8745481C3
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 21:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wLmoEDZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7959AC433C8;
	Wed, 20 Dec 2023 21:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703108832;
	bh=VRctkeqGGCj+I1WpsdTmKTzjGjBl0Qsy//7hAs5cwgg=;
	h=Date:To:From:Subject:From;
	b=wLmoEDZNSF0B6gKucs0lqgNh72/S4ekF12gIZKnNxOUGJ7+ylntLhiFGhGuiSnGHi
	 c6q3PwRCYwS8KViVDQQzw4HwhNhKyXOS8ofaaM7+N1I+QPymjBIxgobPe+vYZHMSGv
	 7isQtWdLORTCPKEyWESkitkFpYRiwCRDWqTJZuYA=
Date: Wed, 20 Dec 2023 13:47:11 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kunit-kasan_test-disable-fortify-string-checker-on-kmalloc_oob_memset.patch removed from -mm tree
Message-Id: <20231220214712.7959AC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kunit: kasan_test: disable fortify string checker on kmalloc_oob_memset
has been removed from the -mm tree.  Its filename was
     kunit-kasan_test-disable-fortify-string-checker-on-kmalloc_oob_memset.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: kunit: kasan_test: disable fortify string checker on kmalloc_oob_memset
Date: Tue, 12 Dec 2023 16:26:59 -0700

Similar to commit 09c6304e38e4 ("kasan: test: fix compatibility with
FORTIFY_SOURCE") the kernel is panicing in kmalloc_oob_memset_*.

This is due to the `ptr` not being hidden from the optimizer which would
disable the runtime fortify string checker.

kernel BUG at lib/string_helpers.c:1048!
Call Trace:
[<00000000272502e2>] fortify_panic+0x2a/0x30
([<00000000272502de>] fortify_panic+0x26/0x30)
[<001bffff817045c4>] kmalloc_oob_memset_2+0x22c/0x230 [kasan_test]

Hide the `ptr` variable from the optimizer to fix the kernel panic.  Also
define a memset_size variable and hide that as well.  This cleans up the
code and follows the same convention as other tests.

[npache@redhat.com: address review comments from Andrey]
  Link: https://lkml.kernel.org/r/20231214164423.6202-1-npache@redhat.com
Link: https://lkml.kernel.org/r/20231212232659.18839-1-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/mm/kasan/kasan_test.c~kunit-kasan_test-disable-fortify-string-checker-on-kmalloc_oob_memset
+++ a/mm/kasan/kasan_test.c
@@ -493,14 +493,17 @@ static void kmalloc_oob_memset_2(struct
 {
 	char *ptr;
 	size_t size = 128 - KASAN_GRANULE_SIZE;
+	size_t memset_size = 2;
 
 	KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test);
 
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
+	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(size);
-	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 1, 0, 2));
+	OPTIMIZER_HIDE_VAR(memset_size);
+	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 1, 0, memset_size));
 	kfree(ptr);
 }
 
@@ -508,14 +511,17 @@ static void kmalloc_oob_memset_4(struct
 {
 	char *ptr;
 	size_t size = 128 - KASAN_GRANULE_SIZE;
+	size_t memset_size = 4;
 
 	KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test);
 
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
+	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(size);
-	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 3, 0, 4));
+	OPTIMIZER_HIDE_VAR(memset_size);
+	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 3, 0, memset_size));
 	kfree(ptr);
 }
 
@@ -523,14 +529,17 @@ static void kmalloc_oob_memset_8(struct
 {
 	char *ptr;
 	size_t size = 128 - KASAN_GRANULE_SIZE;
+	size_t memset_size = 8;
 
 	KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test);
 
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
+	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(size);
-	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 7, 0, 8));
+	OPTIMIZER_HIDE_VAR(memset_size);
+	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 7, 0, memset_size));
 	kfree(ptr);
 }
 
@@ -538,14 +547,17 @@ static void kmalloc_oob_memset_16(struct
 {
 	char *ptr;
 	size_t size = 128 - KASAN_GRANULE_SIZE;
+	size_t memset_size = 16;
 
 	KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test);
 
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
+	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(size);
-	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 15, 0, 16));
+	OPTIMIZER_HIDE_VAR(memset_size);
+	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 15, 0, memset_size));
 	kfree(ptr);
 }
 
_

Patches currently in -mm which might be from npache@redhat.com are


