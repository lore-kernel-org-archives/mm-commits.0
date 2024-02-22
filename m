Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C407B7491
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560184; cv=none; b=uHkgIvPU7uiAaG5aL/t0RBisLsS+wtBEosZqtJ7GXECUouI3vleGL9ukBBZ/zbsxUVX2rREVRtg+kJEuHhJxpfKwOhJkDean5AsaMsuizQWkgiRt5d9RXy9J2wLUoJLKlT2jlmHlGZgquXmThjG6/WqXVZbrwseeSHa9MKSs+2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560184; c=relaxed/simple;
	bh=wXfM+PC3WSyITN7gRM+mJd/dyjmabjGOkqTk+u2xliI=;
	h=Date:To:From:Subject:Message-Id; b=kvxXV8O9Hg3jVjTGTsCvfND4vax3qBuyeOOTD2sTimhuaElEb413jI/26T5LLT9irfakeN8nvutkKWYUpeQrCprCTL8NRUlkXgmYDFSEYa/riEAMz5zmUn1+cWNQ9rjc2k91df648P4T5Ca0ocaQXD90PoP9LiYZnJlaGetXLvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UhjTO3ad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UhjTO3ad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA56C43390;
	Thu, 22 Feb 2024 00:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560184;
	bh=wXfM+PC3WSyITN7gRM+mJd/dyjmabjGOkqTk+u2xliI=;
	h=Date:To:From:Subject:From;
	b=UhjTO3adwLlnhgl7GhEI7yvD5wZ2ZgLX2SrUk2PpmEdbnzr78iIkyFivbtv7eC1tx
	 3gMV+cf1yOrhChcXvaf5DI9BHnkRISBRjPTWt87V5EWlRG8G03SJ5ZFmGQQ5cL743k
	 hMVcQi2S+NKSpTaeKEfsdnw7PdGlXpgm/Jd3P7lI=
Date: Wed, 21 Feb 2024 16:03:04 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,mark.rutland@arm.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,paul.heidekrueger@tum.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-add-atomic-tests.patch removed from -mm tree
Message-Id: <20240222000304.8FA56C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: add atomic tests
has been removed from the -mm tree.  Its filename was
     kasan-add-atomic-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Paul Heidekrüger <paul.heidekrueger@tum.de>
Subject: kasan: add atomic tests
Date: Fri, 2 Feb 2024 11:32:59 +0000

Test that KASan can detect some unsafe atomic accesses.

As discussed in the linked thread below, these tests attempt to cover
the most common uses of atomics and, therefore, aren't exhaustive.

Link: https://lkml.kernel.org/r/20240202113259.3045705-1-paul.heidekrueger@tum.de
Link: https://lore.kernel.org/all/20240131210041.686657-1-paul.heidekrueger@tum.de/T/#u
Signed-off-by: Paul Heidekrüger <paul.heidekrueger@tum.de>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=214055
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
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


