Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FF0AD5A
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 01:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774746743; cv=none; b=X02aQJFmIWkrhRUvh9sabOLiVbAhOCpBWeiploLQq4vBzUM+ouuwHiffGrWE5wCzntlHoay8L7pjRl87kMuXQFxZ4u06g3Eu3Fdt2fpPTNQsmLRIxdaG8Q8UiGRhArhij7lqXT2N09qYxAf6JCt1Puribg8LjnmQnfZdenT5lvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774746743; c=relaxed/simple;
	bh=S3hM8HnsZ9dkcI1JUQkr5VSDg8I7oX9SrLj2OGjbuBM=;
	h=Date:To:From:Subject:Message-Id; b=KGuqoahkV4BfB/iN734KwUpmNTJYFYMHOY0CXbHsSTGzTrU9hIJZ4YAHkTrbytcrO05JMM+kDRG+lX1xk08scsszIL2zX3INEkHBGObZeB1flD8qi5jQclk68G0zfeAdR/N2qNWdYpGmlYqo1SMs9lQM/qU70IDTq2sMqxw9H8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xxrEapXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xxrEapXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E771C4CEF7;
	Sun, 29 Mar 2026 01:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774746742;
	bh=S3hM8HnsZ9dkcI1JUQkr5VSDg8I7oX9SrLj2OGjbuBM=;
	h=Date:To:From:Subject:From;
	b=xxrEapXz04Nng7T0pWhle1AHdRo1FYcqldNuve43PegXy4bxTXxHffFCugis/9BWA
	 l2cvkbHlHgZayc05i8uouJ2nj7z220u9KARDnPeXDZV3eCFcfd0wxKhLmQcuPFQwCd
	 6Nrm0jaygJ2byWy9monqq3QKi18NwqJ1JUx8FW8s=
Date: Sat, 28 Mar 2026 18:12:21 -0700
To: mm-commits@vger.kernel.org,andriy.shevchenko@intel.com,shuvampandey1@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-tests-extend-cmdline-kunit-with-next_arg-tests-fix.patch removed from -mm tree
Message-Id: <20260329011222.7E771C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/tests: extend cmdline next_arg() coverage with mixed tokens
has been removed from the -mm tree.  Its filename was
     lib-tests-extend-cmdline-kunit-with-next_arg-tests-fix.patch

This patch was dropped because it was folded into lib-tests-extend-cmdline-kunit-with-next_arg-tests.patch

------------------------------------------------------
From: Shuvam Pandey <shuvampandey1@gmail.com>
Subject: lib/tests: extend cmdline next_arg() coverage with mixed tokens
Date: Tue, 17 Mar 2026 02:57:49 +0545

The cmdline KUnit suite now covers quoted values and the bare quote
regression path in next_arg(), but it still does not exercise a mixed
sequence containing an empty value, a bare token, and a quoted value with
'='.

Andy Shevchenko suggested covering a sequence such as "bbb= jjj
kkk=\"a=b\"".  Add that case so the suite checks all three forms in one
parse stream.

Validated with the arm64 cmdline KUnit suite and a W=1 rebuild of
lib/tests/cmdline_kunit.o.

Link: https://lkml.kernel.org/r/20260316211249.88601-1-shuvampandey1@gmail.com
Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/tests/cmdline_kunit.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/lib/tests/cmdline_kunit.c~lib-tests-extend-cmdline-kunit-with-next_arg-tests-fix
+++ a/lib/tests/cmdline_kunit.c
@@ -230,6 +230,29 @@ static void cmdline_test_next_arg_bare_q
 	KUNIT_EXPECT_STREQ(test, next, "");
 }
 
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
@@ -238,6 +261,7 @@ static struct kunit_case cmdline_test_ca
 	KUNIT_CASE(cmdline_test_memparse),
 	KUNIT_CASE(cmdline_test_next_arg_quoted_value),
 	KUNIT_CASE(cmdline_test_next_arg_bare_quote_regression),
+	KUNIT_CASE(cmdline_test_next_arg_mixed_tokens),
 	{}
 };
 
_

Patches currently in -mm which might be from shuvampandey1@gmail.com are

lib-tests-extend-cmdline-kunit-with-next_arg-tests.patch

