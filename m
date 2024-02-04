Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257DF79DC
	for <mm-commits@vger.kernel.org>; Sun,  4 Feb 2024 07:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707031258; cv=none; b=V9nRGGAxykz+xTzgB//nNVskIvSkqecPF9eN1BIKtkhJhgnEfhOac3ZLTaJLan4Q49Xp/8u6JzhBbhx0E6fny12lMc4BMrNmouV7NT4UrJ2dQ4X3QuXpuOJOPAlzOKwglR4P7/Phv/ziplKWOBeg2RsqX0D5tGsfiuJxIbu5GLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707031258; c=relaxed/simple;
	bh=rwDEjNbtfLTMnFTqu0TdMEG06s5/s/AHadHQ+XW55hs=;
	h=Date:To:From:Subject:Message-Id; b=oP8RXfiKbvmCKeX5jG0+8Y1nAtnc9AXTNW4l/muhWs4aLKCuccP/yIQHs0fWjny5jcY3fxtCjXLB/aEiZ5dt4w0CRcFMTns16CSl5jM6XnDFvYFXMZ9iU4PGepfl42cQdpVAWqJjS4ulbbivowO4LB7GFUVmmOPuk3gzweoYD5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0OZaF0rC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0OZaF0rC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3B2C433F1;
	Sun,  4 Feb 2024 07:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707031258;
	bh=rwDEjNbtfLTMnFTqu0TdMEG06s5/s/AHadHQ+XW55hs=;
	h=Date:To:From:Subject:From;
	b=0OZaF0rCGCp690O+jjLSBKF0W3XGcXfDzUneKURoQVDN7YfvFqHYY+D8hd0Gzjmls
	 ksCxt9qV3oiHg4uFBCIMOURyXqJeCVNGpXYgWNQxrvQh8hakWSud7SMlItaANkqGJo
	 xFBc5gCrk3nsKUUl07wUFN+LLPUb14NY64V4dSb8=
Date: Sat, 03 Feb 2024 23:20:57 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,paul.heidekrueger@tum.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-add-atomic-tests.patch added to mm-unstable branch
Message-Id: <20240204072057.DF3B2C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: add atomic tests
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-add-atomic-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-add-atomic-tests.patch

This patch will later appear in the mm-unstable branch at
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
From: Paul Heidekrüger <paul.heidekrueger@tum.de>
Subject: kasan: add atomic tests
Date: Fri, 2 Feb 2024 11:32:59 +0000

Test that KASan can detect some unsafe atomic accesses.

As discussed in the linked thread below, these tests attempt to cover
the most common uses of atomics and, therefore, aren't exhaustive.

Link: https://lkml.kernel.org/r/20240202113259.3045705-1-paul.heidekrueger@tum.de
Signed-off-by: Paul Heidekrüger <paul.heidekrueger@tum.de>
Cc: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Link: https://lore.kernel.org/all/20240131210041.686657-1-paul.heidekrueger@tum.de/T/#u
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=214055
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test.c |   79 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

--- a/mm/kasan/kasan_test.c~kasan-add-atomic-tests
+++ a/mm/kasan/kasan_test.c
@@ -697,6 +697,84 @@ static void kmalloc_uaf3(struct kunit *t
 	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr1)[8]);
 }
 
+static void kasan_atomics_helper(struct kunit *test, void *unsafe, void *safe)
+{
+	int *i_unsafe = (int *)unsafe;
+
+	KUNIT_EXPECT_KASAN_FAIL(test, READ_ONCE(*i_unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, WRITE_ONCE(*i_unsafe, 42));
+	KUNIT_EXPECT_KASAN_FAIL(test, smp_load_acquire(i_unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, smp_store_release(i_unsafe, 42));
+
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_read(unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_set(unsafe, 42));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_add(42, unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_sub(42, unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_inc(unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_dec(unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_and(42, unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_andnot(42, unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_or(42, unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_xor(42, unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_xchg(unsafe, 42));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_cmpxchg(unsafe, 21, 42));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_try_cmpxchg(unsafe, safe, 42));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_try_cmpxchg(safe, unsafe, 42));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_sub_and_test(42, unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_dec_and_test(unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_inc_and_test(unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_add_negative(42, unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_add_unless(unsafe, 21, 42));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_inc_not_zero(unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_inc_unless_negative(unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_dec_unless_positive(unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_dec_if_positive(unsafe));
+
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_read(unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_set(unsafe, 42));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_add(42, unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_sub(42, unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_inc(unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_dec(unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_and(42, unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_andnot(42, unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_or(42, unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_xor(42, unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_xchg(unsafe, 42));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_cmpxchg(unsafe, 21, 42));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_try_cmpxchg(unsafe, safe, 42));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_try_cmpxchg(safe, unsafe, 42));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_sub_and_test(42, unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_dec_and_test(unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_inc_and_test(unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_add_negative(42, unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_add_unless(unsafe, 21, 42));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_inc_not_zero(unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_inc_unless_negative(unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_dec_unless_positive(unsafe));
+	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_dec_if_positive(unsafe));
+}
+
+static void kasan_atomics(struct kunit *test)
+{
+	void *a1, *a2;
+
+	/*
+	 * Just as with kasan_bitops_tags(), we allocate 48 bytes of memory such
+	 * that the following 16 bytes will make up the redzone.
+	 */
+	a1 = kzalloc(48, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, a1);
+	a2 = kzalloc(sizeof(int), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, a1);
+
+	/* Use atomics to access the redzone. */
+	kasan_atomics_helper(test, a1 + 48, a2);
+
+	kfree(a1);
+	kfree(a2);
+}
+
 static void kmalloc_double_kzfree(struct kunit *test)
 {
 	char *ptr;
@@ -1883,6 +1961,7 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kasan_strings),
 	KUNIT_CASE(kasan_bitops_generic),
 	KUNIT_CASE(kasan_bitops_tags),
+	KUNIT_CASE(kasan_atomics),
 	KUNIT_CASE(vmalloc_helpers_tags),
 	KUNIT_CASE(vmalloc_oob),
 	KUNIT_CASE(vmap_tags),
_

Patches currently in -mm which might be from paul.heidekrueger@tum.de are

kasan-add-atomic-tests.patch

