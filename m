Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B42434DB78
	for <mm-commits@vger.kernel.org>; Mon, 16 Mar 2026 21:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773696962; cv=none; b=t1lqKSXpGl457uYKT3jaazLMAuQuilaVL37ZSZfzNuloF4mTOwiDxLy6ODD8/PKxlLp/HEBREnz2jDAUbB/lVcsTcH5VeQCIuyRT0p3IoCocL+yRk+k00TOECPmoMbjU7EcsdwcpEpDbfk7i4vlvzZC2WTQAvS6RXwzU2AV7znc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773696962; c=relaxed/simple;
	bh=UTuJKdsIQaew0h3oOgg6wjz432k6Rq1pYm1h7MaVjWM=;
	h=Date:To:From:Subject:Message-Id; b=ey5T0+ZeRyxWBLvm5dMn9KkAXpQpwPGuH4FZDMP7DBP0Ur8sunMC4CKu9jCvCeSp/YR+1XHzrBkZFOVaY6rNCXtPbc4LjClS/H0MxEqVOfJJnMg7cdHmM0Intht5+8cJC43Tmd9oYHVUOY8nWmTK/D4crnnyYtSiCHlky9HfQ8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L+kAFvU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L+kAFvU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DC3C19421;
	Mon, 16 Mar 2026 21:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773696962;
	bh=UTuJKdsIQaew0h3oOgg6wjz432k6Rq1pYm1h7MaVjWM=;
	h=Date:To:From:Subject:From;
	b=L+kAFvU+nSa/VnauyQiBorHXfSICnaeODenh68pn3rTqD/zZw+8lxnzQI/c+aJcYy
	 tCuIyENiXH8xxKR5ctqGzFuHkSpyLD5r//Fh3H/mDgNh7T/KDNz/dQ6pSrag5ci42z
	 5xLkQOldcYd71mBOvYZbu/rOTJS+5BAkTAt0rcuQ=
Date: Mon, 16 Mar 2026 14:36:01 -0700
To: mm-commits@vger.kernel.org,andriy.shevchenko@intel.com,shuvampandey1@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-tests-extend-cmdline-kunit-with-next_arg-tests-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260316213601.E8DC3C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/tests: extend cmdline next_arg() coverage with mixed tokens
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-tests-extend-cmdline-kunit-with-next_arg-tests-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-tests-extend-cmdline-kunit-with-next_arg-tests-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
lib-tests-extend-cmdline-kunit-with-next_arg-tests-fix.patch

