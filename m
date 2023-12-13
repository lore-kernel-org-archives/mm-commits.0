Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78ACBA53
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 01:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rW2VLIV+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6F5C433C7;
	Wed, 13 Dec 2023 01:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702430034;
	bh=SiSzfM3GW8a0ndOKlIwpzlLTyUiPMkPEbj41As9M1EY=;
	h=Date:To:From:Subject:From;
	b=rW2VLIV+wtgTa+AoD3f7qO4Lx+szSwA7DiT49Q0LKH3VqYyTVGuC8xI7rLQE8OVus
	 CBKXjzEOCrpE93Fg4nOvZtpVsBfZmnWLiqK3WG+pVpDpel8AqHobPKx8QcQps9Gryn
	 3IMUsAR07fUSVq3T1xOBcsRwumzCTUIhYwZxXGWo=
Date: Tue, 12 Dec 2023 17:13:54 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kunit-kasan_test-disable-fortify-string-checker-on-kmalloc_oob_memset.patch added to mm-hotfixes-unstable branch
Message-Id: <20231213011354.DE6F5C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kunit: kasan_test: disable fortify string checker on kmalloc_oob_memset
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kunit-kasan_test-disable-fortify-string-checker-on-kmalloc_oob_memset.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kunit-kasan_test-disable-fortify-string-checker-on-kmalloc_oob_memset.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
define a size2 variable and hide that as well.  This cleans up the code
and follows the same convention as other tests.

Link: https://lkml.kernel.org/r/20231212232659.18839-1-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
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
+	size_t size2 = 2;
 
 	KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test);
 
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
+	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(size);
-	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 1, 0, 2));
+	OPTIMIZER_HIDE_VAR(size2);
+	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 1, 0, size2));
 	kfree(ptr);
 }
 
@@ -508,14 +511,17 @@ static void kmalloc_oob_memset_4(struct
 {
 	char *ptr;
 	size_t size = 128 - KASAN_GRANULE_SIZE;
+	size_t size2 = 4;
 
 	KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test);
 
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
+	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(size);
-	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 3, 0, 4));
+	OPTIMIZER_HIDE_VAR(size2);
+	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 3, 0, size2));
 	kfree(ptr);
 }
 
@@ -523,14 +529,17 @@ static void kmalloc_oob_memset_8(struct
 {
 	char *ptr;
 	size_t size = 128 - KASAN_GRANULE_SIZE;
+	size_t size2 = 8;
 
 	KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test);
 
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
+	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(size);
-	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 7, 0, 8));
+	OPTIMIZER_HIDE_VAR(size2);
+	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 7, 0, size2));
 	kfree(ptr);
 }
 
@@ -538,14 +547,17 @@ static void kmalloc_oob_memset_16(struct
 {
 	char *ptr;
 	size_t size = 128 - KASAN_GRANULE_SIZE;
+	size_t size2 = 16;
 
 	KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test);
 
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
+	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(size);
-	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 15, 0, 16));
+	OPTIMIZER_HIDE_VAR(size2);
+	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 15, 0, size2));
 	kfree(ptr);
 }
 
_

Patches currently in -mm which might be from npache@redhat.com are

kunit-kasan_test-disable-fortify-string-checker-on-kmalloc_oob_memset.patch

