Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A1F2BE630
	for <mm-commits@vger.kernel.org>; Mon, 16 Mar 2026 16:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773680130; cv=none; b=rOX3AWZd7oRyjhQVDqK3/rX+ohtAEuVYLPpVrrlqUGaABCknuxCLNsDWjAKYOgjrGPqLZT/J9Q0jT6N3IYnQfSTYwtWJT0myvukEaK2rMnfOm3YNinZrn0Hc+KDh5U2pfTDccNAsN1ZisXJoKMpYN20mFoi3dwoPa/R3YV/5Z58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773680130; c=relaxed/simple;
	bh=VT0Yzi2fV68TtfrBYHc1QcuxV2DOwcIo/0eEjTMbWe4=;
	h=Date:To:From:Subject:Message-Id; b=HIqoABr3bQtPDK6cTEJLVsxh2i1ePsRg3TfcV3IefgW4X1EFwIU6KmCM+s+h2ng+TXj+YB+/IDvg9F6RQOcMYNndtrAbgDwRwvG4BxNlU73UeoNfKySMxZXJc4nIYUEEPbdNfZO6IpJE+O/nJ/VzBTL+BXS4X3yVgtYmwKJBOfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DimTcX6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DimTcX6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E248C19421;
	Mon, 16 Mar 2026 16:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773680130;
	bh=VT0Yzi2fV68TtfrBYHc1QcuxV2DOwcIo/0eEjTMbWe4=;
	h=Date:To:From:Subject:From;
	b=DimTcX6gxywLFP/WZ52F7Kw/Ez+d3tlMGtZE0DKzBofeQ69srM2Rl1bGShnRhrqnx
	 2ts2bd/zCpsix9qvz8bEXEoD7/ac708dyQjsYOnHdsK7VeGy//rjayJiMi4mgValJh
	 arjFXZUmU6wXprCv/IVqWsRlAPkdsV6ElGRj2ofU=
Date: Mon, 16 Mar 2026 09:55:29 -0700
To: mm-commits@vger.kernel.org,neelnatu@google.com,kees@kernel.org,dmantipov@yandex.ru,djwong@kernel.org,andriy.shevchenko@intel.com,shuvampandey1@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-tests-extend-cmdline-kunit-with-next_arg-tests.patch added to mm-nonmm-unstable branch
Message-Id: <20260316165530.3E248C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/tests: extend cmdline KUnit with next_arg() tests
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-tests-extend-cmdline-kunit-with-next_arg-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-tests-extend-cmdline-kunit-with-next_arg-tests.patch

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
Subject: lib/tests: extend cmdline KUnit with next_arg() tests
Date: Mon, 16 Mar 2026 15:57:27 +0545

The cmdline KUnit suite covers get_option() and get_options(), but it
does not exercise next_arg().

Extend the suite with one test for a quoted value containing spaces and
one regression test for a bare quote token after a normal parameter.

The regression test covers the bare quote token path fixed by commit
9847f21225c4 ("lib/cmdline: avoid page fault in next_arg").

Link: https://lkml.kernel.org/r/20260316101227.15807-1-shuvampandey1@gmail.com
Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
Cc: Neel Natu <neelnatu@google.com>
Cc: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/tests/cmdline_kunit.c |   38 ++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

--- a/lib/tests/cmdline_kunit.c~lib-tests-extend-cmdline-kunit-with-next_arg-tests
+++ a/lib/tests/cmdline_kunit.c
@@ -194,12 +194,50 @@ static void cmdline_test_memparse(struct
 	}
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
 static struct kunit_case cmdline_test_cases[] = {
 	KUNIT_CASE(cmdline_test_noint),
 	KUNIT_CASE(cmdline_test_lead_int),
 	KUNIT_CASE(cmdline_test_tail_int),
 	KUNIT_CASE(cmdline_test_range),
 	KUNIT_CASE(cmdline_test_memparse),
+	KUNIT_CASE(cmdline_test_next_arg_quoted_value),
+	KUNIT_CASE(cmdline_test_next_arg_bare_quote_regression),
 	{}
 };
 
_

Patches currently in -mm which might be from shuvampandey1@gmail.com are

lib-tests-extend-cmdline-kunit-with-next_arg-tests.patch

