Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD51E146D45
	for <mm-commits@vger.kernel.org>; Tue, 24 Sep 2024 22:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727218495; cv=none; b=mDVV4Ql0JoQIHyOe7W7m+zCGGSgRFl8AetWighQWJpOBkriOqPDjz0wNFROLUsz/+kL9nN+LNskh6zG89y4SR2Syn5a9geellvTL8M8KiFTBRJ8yB+5Uq0viglpHuU4X0qwE0JXG3E+ECCmVPZBOxb6EX+JqAVOGnF5zro+Hs/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727218495; c=relaxed/simple;
	bh=1qc+9JqCMbSehUeKjGEmY16hqAyPA5IcotrctNKQ9u8=;
	h=Date:To:From:Subject:Message-Id; b=MU/GQkBQm5ks06OVdgQ5Jf9YrZ5CbREa/ncycfwNpl0/jU4KoPaaH5gMQkLBZQ+hnDvucaLCSHfSmB/uZeKvOoyLvvz2qmBe33Mb+oWYWz/xfTK0xENAKjMH++/SgmzqyGWDFJrdIjrzJ+ng6r+7kHsUoFPaXVPmS1RMz95qu1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tg62mJJG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tg62mJJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F81C4CEC4;
	Tue, 24 Sep 2024 22:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727218494;
	bh=1qc+9JqCMbSehUeKjGEmY16hqAyPA5IcotrctNKQ9u8=;
	h=Date:To:From:Subject:From;
	b=Tg62mJJGW2ArKQr6RKc8i8/M2Yc9IHuPB4MVunvDI7POzl6eEVYn0OgkxejDYP/Wg
	 eeAASD4f7r8facurgrAtD0q+00cd6gzSyQWS7t1IraUAiZa1XJgV9BG47Hzdg11xrI
	 1iLShJtOPPbLYC0LfcMpMqOt+6i85PL7RCT94e1M=
Date: Tue, 24 Sep 2024 15:54:54 -0700
To: mm-commits@vger.kernel.org,brunofrancadevsec@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-math-add-int_log-test-suite-checkpatch-fixes.patch added to mm-nonmm-unstable branch
Message-Id: <20240924225454.95F81C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib-math-add-int_log-test-suite-checkpatch-fixes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-math-add-int_log-test-suite-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-math-add-int_log-test-suite-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-math-add-int_log-test-suite-checkpatch-fixes
Date: Tue Sep 24 03:52:27 PM PDT 2024


ERROR: trailing whitespace
#36: FILE: lib/Kconfig.debug:3098:
+^I  This option enables the KUnit test suite for the int_log library, which $

ERROR: trailing whitespace
#37: FILE: lib/Kconfig.debug:3099:
+^I  provides two functions to compute the integer logarithm in base 2 and $

WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
#54: 
new file mode 100644

ERROR: code indent should use tabs where possible
#77: FILE: lib/math/tests/int_log_kunit.c:20:
+       ^I{16, 67108864, "Log base 2 of 16"},$

WARNING: please, no space before tabs
#77: FILE: lib/math/tests/int_log_kunit.c:20:
+       ^I{16, 67108864, "Log base 2 of 16"},$

WARNING: please, no spaces at the start of a line
#77: FILE: lib/math/tests/int_log_kunit.c:20:
+       ^I{16, 67108864, "Log base 2 of 16"},$

ERROR: trailing whitespace
#78: FILE: lib/math/tests/int_log_kunit.c:21:
+^I{32, 83886080, "Log base 2 of 32"},^I$

ERROR: trailing whitespace
#95: FILE: lib/math/tests/int_log_kunit.c:38:
+^Istrscpy(desc, tc->name, KUNIT_PARAM_DESC_SIZE); $

ERROR: trailing whitespace
#99: FILE: lib/math/tests/int_log_kunit.c:42:
+KUNIT_ARRAY_PARAM(intlog2, intlog2_params, get_desc); $

ERROR: trailing whitespace
#103: FILE: lib/math/tests/int_log_kunit.c:46:
+^Iconst struct test_case_params *tc = (const struct test_case_params *)test->param_value;^I^I$

WARNING: line length of 104 exceeds 100 columns
#103: FILE: lib/math/tests/int_log_kunit.c:46:
+	const struct test_case_params *tc = (const struct test_case_params *)test->param_value;		

ERROR: trailing whitespace
#104: FILE: lib/math/tests/int_log_kunit.c:47:
+^I$

total: 8 errors, 4 warnings, 102 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/lib-math-add-int_log-test-suite.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Bruno Sobreira França <brunofrancadevsec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/math/tests/int_log_kunit.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/lib/math/tests/int_log_kunit.c~lib-math-add-int_log-test-suite-checkpatch-fixes
+++ a/lib/math/tests/int_log_kunit.c
@@ -17,8 +17,8 @@ static const struct test_case_params int
 	{3, 26591232, "Log base 2 of 3"},
 	{4, 33554432, "Log base 2 of 4"},
 	{8, 50331648, "Log base 2 of 8"},
-       	{16, 67108864, "Log base 2 of 16"},
-	{32, 83886080, "Log base 2 of 32"},	
+	{16, 67108864, "Log base 2 of 16"},
+	{32, 83886080, "Log base 2 of 32"},
 	{U32_MAX, 536870911, "Log base 2 of MAX"},
 };
 
@@ -35,16 +35,18 @@ static const struct test_case_params int
 
 static void get_desc(const struct test_case_params *tc, char *desc)
 {
-	strscpy(desc, tc->name, KUNIT_PARAM_DESC_SIZE); 
+	strscpy(desc, tc->name, KUNIT_PARAM_DESC_SIZE);
 }
 
 
-KUNIT_ARRAY_PARAM(intlog2, intlog2_params, get_desc); 
+KUNIT_ARRAY_PARAM(intlog2, intlog2_params, get_desc);
 
 static void intlog2_test(struct kunit *test)
 {
-	const struct test_case_params *tc = (const struct test_case_params *)test->param_value;		
-	
+	const struct test_case_params *tc;
+
+	tc = (const struct test_case_params *)test->param_value;
+
 	KUNIT_EXPECT_EQ(test, tc->expected_result, intlog2(tc->value));
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-math-add-int_log-test-suite-checkpatch-fixes.patch

