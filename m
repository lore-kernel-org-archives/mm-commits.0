Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F9A3399F
	for <mm-commits@vger.kernel.org>; Thu, 14 Dec 2023 18:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kBq00ojB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2080FC433C8;
	Thu, 14 Dec 2023 18:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702579641;
	bh=heV5czI55j+jdV14fAhGAMzaS0dzMJK89nidZlWSTX0=;
	h=Date:To:From:Subject:From;
	b=kBq00ojBgKdnRcweYmwXuFqB70RdlHrjPlOjPECNg+rMep73DIZIJyeH/NETRUFQR
	 2q3sU/zPmHn6En12CQfm8a+WlEeAkacxha0d2HTPWnJt8Q/eHr9gcqAaYm/65gdOSK
	 ESCDeh6fy9ajk6FcJU4xTWuU68RruO7/w6QUT1tc=
Date: Thu, 14 Dec 2023 10:47:19 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kunit-kasan_test-disable-fortify-string-checker-on-kmalloc_oob_memset-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20231214184721.2080FC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kunit: kasan_test: disable fortify string checker on kmalloc_oob_memset
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kunit-kasan_test-disable-fortify-string-checker-on-kmalloc_oob_memset-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kunit-kasan_test-disable-fortify-string-checker-on-kmalloc_oob_memset-v2.patch

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
Date: Thu, 14 Dec 2023 09:44:23 -0700

address review comments from Andrey

Link: https://lkml.kernel.org/r/20231214164423.6202-1-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/mm/kasan/kasan_test.c~kunit-kasan_test-disable-fortify-string-checker-on-kmalloc_oob_memset-v2
+++ a/mm/kasan/kasan_test.c
@@ -493,7 +493,7 @@ static void kmalloc_oob_memset_2(struct
 {
 	char *ptr;
 	size_t size = 128 - KASAN_GRANULE_SIZE;
-	size_t size2 = 2;
+	size_t memset_size = 2;
 
 	KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test);
 
@@ -502,8 +502,8 @@ static void kmalloc_oob_memset_2(struct
 
 	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(size);
-	OPTIMIZER_HIDE_VAR(size2);
-	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 1, 0, size2));
+	OPTIMIZER_HIDE_VAR(memset_size);
+	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 1, 0, memset_size));
 	kfree(ptr);
 }
 
@@ -511,7 +511,7 @@ static void kmalloc_oob_memset_4(struct
 {
 	char *ptr;
 	size_t size = 128 - KASAN_GRANULE_SIZE;
-	size_t size2 = 4;
+	size_t memset_size = 4;
 
 	KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test);
 
@@ -520,8 +520,8 @@ static void kmalloc_oob_memset_4(struct
 
 	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(size);
-	OPTIMIZER_HIDE_VAR(size2);
-	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 3, 0, size2));
+	OPTIMIZER_HIDE_VAR(memset_size);
+	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 3, 0, memset_size));
 	kfree(ptr);
 }
 
@@ -529,7 +529,7 @@ static void kmalloc_oob_memset_8(struct
 {
 	char *ptr;
 	size_t size = 128 - KASAN_GRANULE_SIZE;
-	size_t size2 = 8;
+	size_t memset_size = 8;
 
 	KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test);
 
@@ -538,8 +538,8 @@ static void kmalloc_oob_memset_8(struct
 
 	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(size);
-	OPTIMIZER_HIDE_VAR(size2);
-	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 7, 0, size2));
+	OPTIMIZER_HIDE_VAR(memset_size);
+	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 7, 0, memset_size));
 	kfree(ptr);
 }
 
@@ -547,7 +547,7 @@ static void kmalloc_oob_memset_16(struct
 {
 	char *ptr;
 	size_t size = 128 - KASAN_GRANULE_SIZE;
-	size_t size2 = 16;
+	size_t memset_size = 16;
 
 	KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test);
 
@@ -556,8 +556,8 @@ static void kmalloc_oob_memset_16(struct
 
 	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(size);
-	OPTIMIZER_HIDE_VAR(size2);
-	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 15, 0, size2));
+	OPTIMIZER_HIDE_VAR(memset_size);
+	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 15, 0, memset_size));
 	kfree(ptr);
 }
 
_

Patches currently in -mm which might be from npache@redhat.com are

kunit-kasan_test-disable-fortify-string-checker-on-kmalloc_oob_memset.patch
kunit-kasan_test-disable-fortify-string-checker-on-kmalloc_oob_memset-v2.patch

