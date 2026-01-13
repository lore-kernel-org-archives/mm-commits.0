Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01BE352C3F
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 22:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768342350; cv=none; b=TxdPqQlowCnqHL4OQK3QEkz5UpFNB1OFvdX4z1heND0j2Xw1029z4p1OaeuRJNlFWkwyKjeZL80fvljodtdwkPU4rgt/9bTgQP0OSJtI2Xak+iHKjA4ggmpK30wf9QYIODbJsqRTyh6Fudx89RoxLBVd/9ReG7u8BKwItzkddM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768342350; c=relaxed/simple;
	bh=+YrzrNmprnmUHfkDPZuAJw7N7KU+mpd1vdj+QrERbg8=;
	h=Date:To:From:Subject:Message-Id; b=rrp4sZfiqu/SnKPzOGF7H2wikzTEhNF5H0ORYGt3pz2d9W2731cHwdNWdQnJ5CicvpEnAGHNWnQG2cvCjjXBvZevBlIPckVam4aMtKDtlcBUxH+Z6Aib+Tq1yvhdrcFIEr5Ci6SoXzrJN4g8YArAKMK/T7LzzL85RVfTTy/vXxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q8AhkmNs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q8AhkmNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69ABBC116C6;
	Tue, 13 Jan 2026 22:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768342350;
	bh=+YrzrNmprnmUHfkDPZuAJw7N7KU+mpd1vdj+QrERbg8=;
	h=Date:To:From:Subject:From;
	b=q8AhkmNsQvR4Tsy2zwv/Q+b6y5Abxxh+EaE6qkqoclabCrJMMKI6n+fTScvWhXraF
	 PY+QtGDW2lGy2g7Bjo6Eur1zUDb3zL61fTCUG0EsmKe1iof3+oKjRCc5LrkPESqxmd
	 gvlq+eSUOzv1GsI76azrMsI/kMV39KNw+l1lVITc=
Date: Tue, 13 Jan 2026 14:12:29 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,urezki@gmail.com,maze@google.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,ryabinin.a.a@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc.patch added to mm-new branch
Message-Id: <20260113221230.69ABBC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kasan/kunit: extend vmalloc OOB tests to cover vrealloc()
has been added to the -mm mm-new branch.  Its filename is
     mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc.patch

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
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: mm/kasan/kunit: extend vmalloc OOB tests to cover vrealloc()
Date: Tue, 13 Jan 2026 20:15:16 +0100

Extend the vmalloc_oob() test to validate OOB detection after resizing
vmalloc allocations with vrealloc().

The test now verifies that KASAN correctly poisons and unpoisons vmalloc
memory when allocations are shrunk and expanded, ensuring OOB accesses are
reliably detected after each resize.

Link: https://lkml.kernel.org/r/20260113191516.31015-2-ryabinin.a.a@gmail.com
Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Maciej Żenczykowski <maze@google.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
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
+	size--;
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
+	size += 2;
+	v_ptr = vrealloc(v_ptr, size, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
+
+	vmalloc_oob_helper(test, v_ptr, size);
 
 	/* Check that in-bounds accesses to the physical page are valid. */
 	page = vmalloc_to_page(v_ptr);
_

Patches currently in -mm which might be from ryabinin.a.a@gmail.com are

mm-kasan-fix-kasan-poisoning-in-vrealloc.patch
mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc.patch

