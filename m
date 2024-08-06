Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36EA1EB2A
	for <mm-commits@vger.kernel.org>; Tue,  6 Aug 2024 21:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722978028; cv=none; b=AOtvqF6nYDi6gvcT7giaQ5kazClTZtJtfXmGO6nFEDBngMiyBvW+W//igIp0ezo4kiuvGXaH2L4dVNeaFkm/bXAJyCC1izT+70Q3QDyGhZWMYwS3kP4Gp6sGG1GxMlPVGjQ0RRm5NxiYhSaFxtMRyDKJzz40wKxMxsF95ce8530=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722978028; c=relaxed/simple;
	bh=YqsKxRzqWWbYvLnh2LbVrnptU9jF+nsiyQTad9hcq7g=;
	h=Date:To:From:Subject:Message-Id; b=YX7OxkNoHgnq367Q3xRYKvi1EKNPIdumgFRgbMTCW9FFtOBImpugp0QKKslGnUuzKzIlNTQKAcxO+1+i67ZppsWiYLRZ87vFMa6B0qIsV+oeNYL+WLFKcL6w4dv/RRgQ4z8TBVgXLaY0Ufq1rGJH93kKxjMI7PrFRLep6Q9pMWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K0y7G3Aw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K0y7G3Aw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF6AC32786;
	Tue,  6 Aug 2024 21:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722978027;
	bh=YqsKxRzqWWbYvLnh2LbVrnptU9jF+nsiyQTad9hcq7g=;
	h=Date:To:From:Subject:From;
	b=K0y7G3Aw9+cVrDBQjs0tDUNZUev3tvfUdQNaI70jSgkT8MXagzIWFzp8hKWHDu4gX
	 w1gw+Z5wPeRL7gvFHvfyl3sYO4l+psPAfkb7XeOHDcHGLjZc6B8HHT4u2h/HjaUL3l
	 Naif0pt/k4DdboKb4CacSvrvZGAPV+ieGh9OCwK4=
Date: Tue, 06 Aug 2024 14:00:26 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,linux@rasmusvillemoes.dk,arnd@arndb.de,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] lib-test_bitsc-add-tests-for-genmask_u128.patch removed from -mm tree
Message-Id: <20240806210027.7FF6AC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_bits.c: add tests for GENMASK_U128()
has been removed from the -mm tree.  Its filename was
     lib-test_bitsc-add-tests-for-genmask_u128.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


