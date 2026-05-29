Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3DD372661
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028780; cv=none; b=QF9BKwAsuQ4+hm7GfGZzD5c2wxOxRIVZo4oXYW2rCWm78tWJ9R7Ofkyc3z39Tay/3OzY+LNixIqAHs4kNIzKOSBx4TKbMNrAAwN8camOdjOJYlW5PCYZYlewOE1+GbaIyMGZVIcAdfx8jZU/jzl8kGU3oAsS0DUE8npk2RCOl0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028780; c=relaxed/simple;
	bh=aVF1xIqIQsRuA0EGzooQfjEVIFlQWvGkrbsIuTq+iho=;
	h=Date:To:From:Subject:Message-Id; b=C156nU9bm7/lQRorgtCsU6hAV618vXTTF5IaZ5P/rbSwXcn+uhUabhoAGz+Is05WyFASetxLlCf/NN3WN62vFTRbsbiD/i+eEs65RVYF3zRobfQzPapMX9UYU5GksltCCGDDyaVxeBCNY/8ykVilfzksR5Q9Y/i6qlPfkMTXcL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u5D9vTMt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u5D9vTMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643CA1F00893;
	Fri, 29 May 2026 04:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028779;
	bh=tmqyUbzHx9kTskji3kWXDaEfaM3Yd2H39D5zR/1laQg=;
	h=Date:To:From:Subject;
	b=u5D9vTMtaSendgjEE1d7YqkxRE7u1aenE674OgJIdK2kl6+TjEdFwGwZydzImjPwy
	 IMm/TZZqXFlxBBY9QkyLe6VSji1KJSswYq125sL8nIuMnfL5kt6Bnx0YsFHWYP8a/c
	 Uqvr2aw/Ej9FoXQecMk+NUZb1zmNq/p9xNY4cYI8=
Date: Thu, 28 May 2026 21:26:19 -0700
To: mm-commits@vger.kernel.org,neelnatu@google.com,kees@kernel.org,dmantipov@yandex.ru,djwong@kernel.org,andriy.shevchenko@intel.com,shuvampandey1@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-tests-extend-cmdline-kunit-with-next_arg-tests.patch removed from -mm tree
Message-Id: <20260529042619.643CA1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/tests: extend cmdline KUnit with next_arg() tests
has been removed from the -mm tree.  Its filename was
     lib-tests-extend-cmdline-kunit-with-next_arg-tests.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shuvam Pandey <shuvampandey1@gmail.com>
Subject: lib/tests: extend cmdline KUnit with next_arg() tests
Date: Mon, 16 Mar 2026 15:57:27 +0545

The cmdline KUnit suite covers get_option() and get_options(), but it
does not exercise next_arg().

Extend the suite with one test for a quoted value containing spaces and
one regression test for a bare quote token after a normal parameter.

The regression test covers the bare quote token path fixed by commit
9847f21225c4 ("lib/cmdline: avoid page fault in next_arg").

[shuvampandey1@gmail.com: extend cmdline next_arg() coverage with mixed tokens]
  Link: https://lore.kernel.org/20260316211249.88601-1-shuvampandey1@gmail.com
Link: https://lore.kernel.org/20260316101227.15807-1-shuvampandey1@gmail.com
Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Neel Natu <neelnatu@google.com>
Cc: Dmitry Antipov <dmantipov@yandex.ru>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/tests/cmdline_kunit.c |   62 ++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

--- a/lib/tests/cmdline_kunit.c~lib-tests-extend-cmdline-kunit-with-next_arg-tests
+++ a/lib/tests/cmdline_kunit.c
@@ -139,11 +139,73 @@ static void cmdline_test_range(struct ku
 	} while (++i < ARRAY_SIZE(cmdline_test_range_strings));
 }
 
+static void cmdline_test_next_arg_quoted_value(struct kunit *test)
+{
+	char in[] = "foo=\"bar baz\" qux=1";
+	char *next, *param, *val;
+
+	next = next_arg(in, &param, &val);
+	KUNIT_EXPECT_STREQ(test, param, "foo");
+	KUNIT_ASSERT_NOT_NULL(test, val);
+	KUNIT_EXPECT_STREQ(test, val, "bar baz");
+	KUNIT_EXPECT_STREQ(test, next, "qux=1");
+
+	next = next_arg(next, &param, &val);
+	KUNIT_EXPECT_STREQ(test, param, "qux");
+	KUNIT_ASSERT_NOT_NULL(test, val);
+	KUNIT_EXPECT_STREQ(test, val, "1");
+	KUNIT_EXPECT_STREQ(test, next, "");
+}
+
+static void cmdline_test_next_arg_bare_quote_regression(struct kunit *test)
+{
+	char in[] = "foo=bar \"";
+	char *next, *param, *val;
+
+	next = next_arg(in, &param, &val);
+	KUNIT_EXPECT_STREQ(test, param, "foo");
+	KUNIT_ASSERT_NOT_NULL(test, val);
+	KUNIT_EXPECT_STREQ(test, val, "bar");
+	KUNIT_EXPECT_STREQ(test, next, "\"");
+
+	/* This hits the i == 0 quoted-token case fixed by 9847f21225c4. */
+	next = next_arg(next, &param, &val);
+	KUNIT_EXPECT_STREQ(test, param, "");
+	KUNIT_EXPECT_PTR_EQ(test, val, NULL);
+	KUNIT_EXPECT_STREQ(test, next, "");
+}
+
+static void cmdline_test_next_arg_mixed_tokens(struct kunit *test)
+{
+	char in[] = "bbb= jjj kkk=\"a=b\"";
+	char *next, *param, *val;
+
+	next = next_arg(in, &param, &val);
+	KUNIT_EXPECT_STREQ(test, param, "bbb");
+	KUNIT_ASSERT_NOT_NULL(test, val);
+	KUNIT_EXPECT_STREQ(test, val, "");
+	KUNIT_EXPECT_STREQ(test, next, "jjj kkk=\"a=b\"");
+
+	next = next_arg(next, &param, &val);
+	KUNIT_EXPECT_STREQ(test, param, "jjj");
+	KUNIT_EXPECT_NULL(test, val);
+	KUNIT_EXPECT_STREQ(test, next, "kkk=\"a=b\"");
+
+	next = next_arg(next, &param, &val);
+	KUNIT_EXPECT_STREQ(test, param, "kkk");
+	KUNIT_ASSERT_NOT_NULL(test, val);
+	KUNIT_EXPECT_STREQ(test, val, "a=b");
+	KUNIT_EXPECT_STREQ(test, next, "");
+}
+
 static struct kunit_case cmdline_test_cases[] = {
 	KUNIT_CASE(cmdline_test_noint),
 	KUNIT_CASE(cmdline_test_lead_int),
 	KUNIT_CASE(cmdline_test_tail_int),
 	KUNIT_CASE(cmdline_test_range),
+	KUNIT_CASE(cmdline_test_next_arg_quoted_value),
+	KUNIT_CASE(cmdline_test_next_arg_bare_quote_regression),
+	KUNIT_CASE(cmdline_test_next_arg_mixed_tokens),
 	{}
 };
 
_

Patches currently in -mm which might be from shuvampandey1@gmail.com are


