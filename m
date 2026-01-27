Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5C43191B9
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486706; cv=none; b=Ja9px/V0Buji1jMRWvDwzWZw6huQjB9v0N1T5We+XhydeNyw7nWkvI7XsQJDTQIu1Y+iXm8T0+kJFJ06b8WK/lw2vLhD9dk8yF+tC2X/9J9AVg9YRk5iMhA/+VKfj68zeu+Vsz5z3H1l48X64pOoawmBpXkzmeVghKzSpQRPzsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486706; c=relaxed/simple;
	bh=wcbprminmemO3bVXzyhJMinKRP0lk0TxI5tYEvHGCuc=;
	h=Date:To:From:Subject:Message-Id; b=CiUf4fipohzPHBE4Q0rvnQYws6LIoIR/Q8atf5QdzmyH3bT8JUVJriERkfH98mq/VMBpNR0xHA97kKS7HEpu8DoDpLHrDvRcGaugZNLQjatwG0HbDHT1Q6vvkFwZnsJzCtabcWIWcP6sM7k8L1n0dl4B3d+U3UML6ScyBxZVduo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QqST8Gps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QqST8Gps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28377C116C6;
	Tue, 27 Jan 2026 04:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486706;
	bh=wcbprminmemO3bVXzyhJMinKRP0lk0TxI5tYEvHGCuc=;
	h=Date:To:From:Subject:From;
	b=QqST8GpsqrtQEe+Ws0ZsLX8b7EGQbyDWHKM9FmRi9yRNub3isqU7eoVJbrT6mW4iY
	 R/ZFIN3M0uSNOe5xGuvQuVFij4RYRHlWDYCziDQ2VW8pf1s66TjBPXtPH9cyt3DhfS
	 PxQD5dTnhwRBUpll6nCk9SBfZ/AK1E9wLj5IHIwc=
Date: Mon, 26 Jan 2026 20:05:05 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,urezki@gmail.com,maze@google.com,maciej.wieczor-retman@intel.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,ryabinin.a.a@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc.patch removed from -mm tree
Message-Id: <20260127040506.28377C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kasan/kunit: extend vmalloc OOB tests to cover vrealloc()
has been removed from the -mm tree.  Its filename was
     mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: mm/kasan/kunit: extend vmalloc OOB tests to cover vrealloc()
Date: Tue, 13 Jan 2026 20:15:16 +0100

Extend the vmalloc_oob() test to validate OOB detection after resizing
vmalloc allocations with vrealloc().

The test now verifies that KASAN correctly poisons and unpoisons vmalloc
memory when allocations are shrunk and expanded, ensuring OOB accesses are
reliably detected after each resize.

[ryabinin.a.a@gmail.com: adjust vrealloc() size]
  Link: https://lkml.kernel.org/r/20260116132822.22227-1-ryabinin.a.a@gmail.com
Link: https://lkml.kernel.org/r/20260113191516.31015-2-ryabinin.a.a@gmail.com
Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Maciej Żenczykowski <maze@google.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |   50 ++++++++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 15 deletions(-)

--- a/mm/kasan/kasan_test_c.c~mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc
+++ a/mm/kasan/kasan_test_c.c
@@ -1840,6 +1840,29 @@ static void vmalloc_helpers_tags(struct
 	vfree(ptr);
 }
 
+static void vmalloc_oob_helper(struct kunit *test, char *v_ptr, size_t size)
+{
+	/*
+	 * We have to be careful not to hit the guard page in vmalloc tests.
+	 * The MMU will catch that and crash us.
+	 */
+
+	/* Make sure in-bounds accesses are valid. */
+	v_ptr[0] = 0;
+	v_ptr[size - 1] = 0;
+
+	/*
+	 * An unaligned access past the requested vmalloc size.
+	 * Only generic KASAN can precisely detect these.
+	 */
+	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
+		KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)v_ptr)[size]);
+
+	/* An aligned access into the first out-of-bounds granule. */
+	size = round_up(size, KASAN_GRANULE_SIZE);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)v_ptr)[size]);
+}
+
 static void vmalloc_oob(struct kunit *test)
 {
 	char *v_ptr, *p_ptr;
@@ -1856,24 +1879,21 @@ static void vmalloc_oob(struct kunit *te
 
 	OPTIMIZER_HIDE_VAR(v_ptr);
 
-	/*
-	 * We have to be careful not to hit the guard page in vmalloc tests.
-	 * The MMU will catch that and crash us.
-	 */
+	vmalloc_oob_helper(test, v_ptr, size);
 
-	/* Make sure in-bounds accesses are valid. */
-	v_ptr[0] = 0;
-	v_ptr[size - 1] = 0;
+	size -= KASAN_GRANULE_SIZE + 1;
+	v_ptr = vrealloc(v_ptr, size, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
 
-	/*
-	 * An unaligned access past the requested vmalloc size.
-	 * Only generic KASAN can precisely detect these.
-	 */
-	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
-		KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)v_ptr)[size]);
+	OPTIMIZER_HIDE_VAR(v_ptr);
 
-	/* An aligned access into the first out-of-bounds granule. */
-	KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)v_ptr)[size + 5]);
+	vmalloc_oob_helper(test, v_ptr, size);
+
+	size += 2 * KASAN_GRANULE_SIZE + 2;
+	v_ptr = vrealloc(v_ptr, size, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
+
+	vmalloc_oob_helper(test, v_ptr, size);
 
 	/* Check that in-bounds accesses to the physical page are valid. */
 	page = vmalloc_to_page(v_ptr);
_

Patches currently in -mm which might be from ryabinin.a.a@gmail.com are


