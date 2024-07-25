Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBA713E8A5
	for <mm-commits@vger.kernel.org>; Thu, 25 Jul 2024 21:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721941560; cv=none; b=AOTPuWcNERUOhFV5rwA5j6AulGrgxQ9fqYrhUsyZfyGuwBvZ5Zxwos3e1eyXgQ6n8yP+LrPWHjC3UIHDcroX3ECSq77U9fHzjtzi7OYLfBE6qC/2Nm61uT7m8GM2zUZBoXyo4GBUxTqyxh+i1lJPRzp/wHwXrMu1/ZiRxQNEvuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721941560; c=relaxed/simple;
	bh=Vg3CNWoJwuq1oTl8wOD6Jro+o+FO+v9GpDE6MWhJRFQ=;
	h=Date:To:From:Subject:Message-Id; b=jbpq0J9oFFSh5viZAn6tv5pDTSMdD3Ii1w7SSknvktfr2aYC0zPA0Iiij9vep0yIt8hZiNew5n24ExKpmwn2RB/jE7QjEvIIKMEa3qNe9EY+TKobG/nS6AXix7b+oxQxhMFGOt9eeTgw9DCpuVcCV2tHpMwr9Oxec6/LznfM21s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AHFK5gsN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AHFK5gsN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E10BC116B1;
	Thu, 25 Jul 2024 21:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721941560;
	bh=Vg3CNWoJwuq1oTl8wOD6Jro+o+FO+v9GpDE6MWhJRFQ=;
	h=Date:To:From:Subject:From;
	b=AHFK5gsN0QRE0vh+Q4uEGxsiVpcqMqmD4UspkXky7NV0lRIhCPbfTphWJwwq2OQxI
	 QRM4IoxmJfLU+MTjg7n4CvZf/oddMztIB2zWWrvTRkp7uBYW01pqykx2ZaLUL5E0vu
	 lEejeziMdwL5nEpjBGQycAQpK5H5Q8m5NUQP2//E=
Date: Thu, 25 Jul 2024 14:05:59 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,linux@rasmusvillemoes.dk,arnd@arndb.de,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_bitsc-add-tests-for-genmask_u128.patch added to mm-nonmm-unstable branch
Message-Id: <20240725210600.4E10BC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_bits.c: add tests for GENMASK_U128()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-test_bitsc-add-tests-for-genmask_u128.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_bitsc-add-tests-for-genmask_u128.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: lib/test_bits.c: add tests for GENMASK_U128()
Date: Thu, 25 Jul 2024 11:18:08 +0530

This adds GENMASK_U128() tests although currently only 64 bit wide masks
are being tested.

Link: https://lkml.kernel.org/r/20240725054808.286708-3-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bits.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/lib/test_bits.c~lib-test_bitsc-add-tests-for-genmask_u128
+++ a/lib/test_bits.c
@@ -39,6 +39,26 @@ static void genmask_ull_test(struct kuni
 #endif
 }
 
+#ifdef CONFIG_ARCH_SUPPORTS_INT128
+static void genmask_u128_test(struct kunit *test)
+{
+	/* Tests mask generation only when the mask width is within 64 bits */
+	KUNIT_EXPECT_EQ(test, 0x0000000000ff0000ULL, GENMASK_U128(87, 80) >> 64);
+	KUNIT_EXPECT_EQ(test, 0x0000000000ffffffULL, GENMASK_U128(87, 64) >> 64);
+	KUNIT_EXPECT_EQ(test, 0x0000000000000001ULL, GENMASK_U128(0, 0));
+	KUNIT_EXPECT_EQ(test, 0xffffffffffffffffULL, GENMASK_U128(63, 0));
+	KUNIT_EXPECT_EQ(test, 0xffffffffffffffffULL, GENMASK_U128(64, 0) >> 1);
+	KUNIT_EXPECT_EQ(test, 0x00000000ffffffffULL, GENMASK_U128(81, 50) >> 50);
+
+#ifdef TEST_GENMASK_FAILURES
+	/* these should fail compilation */
+	GENMASK_U128(0, 1);
+	GENMASK_U128(0, 10);
+	GENMASK_U128(9, 10);
+#endif
+}
+#endif
+
 static void genmask_input_check_test(struct kunit *test)
 {
 	unsigned int x, y;
@@ -56,12 +76,17 @@ static void genmask_input_check_test(str
 	/* Valid input */
 	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(1, 1));
 	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(39, 21));
+	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(100, 80));
+	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(110, 65));
 }
 
 
 static struct kunit_case bits_test_cases[] = {
 	KUNIT_CASE(genmask_test),
 	KUNIT_CASE(genmask_ull_test),
+#ifdef CONFIG_ARCH_SUPPORTS_INT128
+	KUNIT_CASE(genmask_u128_test),
+#endif
 	KUNIT_CASE(genmask_input_check_test),
 	{}
 };
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

uapi-define-genmask_u128.patch
lib-test_bitsc-add-tests-for-genmask_u128.patch

