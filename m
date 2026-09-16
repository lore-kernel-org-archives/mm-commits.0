Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E5D479886
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 21:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789594759; cv=none; b=dgXwrqbXom5giMXwJ/9aYMx/HdNfWZngQdnIAoBM46a/riZ9DnOpWPYrhu4B6F6VlZKNBfovFvxxfXXiga3MdVx3kFevnQa/Nc0yGvYv+vzTDhuI25RIlTw25hb3lTrji4FCkTZ3a0wDy5iiNmMF9dzjIIjHsQA3CZYGHFW6MEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789594759; c=relaxed/simple;
	bh=imFznM7aOpHgB73xSIi5w6zUPQa8e8o8XTqBKSrZEJU=;
	h=Date:To:From:Subject:Message-Id; b=Pya4nrnMAceZr5VsO/Z9IUd/ew35KnK1RlydS23GdyAG9/WpIyQwndo+jfwTV1NA0WwnGcqZY/spWMPZNgXvj7V0J2hSEnCrrkWpBuKYnLwbb0L8gxfPIeFZ0qgoEszKWH4FYe1lYuY3lHmDz4iEEuJqs073Gnu5Z09UHRs31ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hdpwuq1G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hdpwuq1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1511F1F00893;
	Wed, 16 Sep 2026 21:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789594745;
	bh=VDfQsxHGcCXIkRnV4mi+kzgs/pMxOQZsf/Ze1lPF5/Q=;
	h=Date:To:From:Subject;
	b=hdpwuq1G1dRmWjLLDIe1jlSavF2ZrXI36N31l1Q4QGZlumqx7kRYNBZ5ycM8342Hf
	 FyV3gwxw2xBYsj0U3/fZGi2FdFObo9Gl+OVcf9IStJPEu6urYiUObxBMvD84Osy3h8
	 EV4qLQrL32V7sMWgiS2Jq6bpMmHiL+BQvtbuMzdo=
Date: Wed, 16 Sep 2026 14:39:04 -0700
To: mm-commits@vger.kernel.org,kernel@pengutronix.de,kees@kernel.org,andy@kernel.org,jre@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-tests-string_helpers-introduce-test_string_unescape_one.patch added to mm-nonmm-unstable branch
Message-Id: <20260916213905.1511F1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/tests: string_helpers: introduce test_string_unescape_one
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-tests-string_helpers-introduce-test_string_unescape_one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-tests-string_helpers-introduce-test_string_unescape_one.patch

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
From: Jonas Rebmann <jre@pengutronix.de>
Subject: lib/tests: string_helpers: introduce test_string_unescape_one
Date: Wed, 16 Sep 2026 19:38:08 +0200

The existing test_string_unescape() function follows a complex procedure
where it, given a set of UNESCAPE flags, appends multiple test fragments
and predicts their unescape result for the chosen set of flags.  Rename
test_string_unescape() to a more descriptive test_string_unescape_combined

In preparation to add simple regression tests, introduce
test_string_unescape_one() which asserts on exactly one call to
string_unescape.

Add some tests for corner cases which already pass.

Link: https://lore.kernel.org/20260916-string_unescape-v1-3-7f8bd986fa33@pengutronix.de
Signed-off-by: Jonas Rebmann <jre@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
---

 lib/tests/string_helpers_kunit.c |   31 +++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

--- a/lib/tests/string_helpers_kunit.c~lib-tests-string_helpers-introduce-test_string_unescape_one
+++ a/lib/tests/string_helpers_kunit.c
@@ -55,9 +55,9 @@ static const struct test_string strings[
 	},
 };
 
-static void test_string_unescape(struct kunit *test,
-				 const char *name, unsigned int flags,
-				 bool inplace)
+static void test_string_unescape_combined(struct kunit *test,
+					  const char *name, unsigned int flags,
+					  bool inplace)
 {
 	int q_real = 256;
 	char *in = kunit_kzalloc(test, q_real, GFP_KERNEL);
@@ -596,14 +596,33 @@ static void test_upper_lower(struct kuni
 	}
 }
 
+static void test_string_unescape_one(struct kunit *test,
+				     const char *name, unsigned int flags,
+				     char *src, size_t len,
+				     char *out_test, size_t q_test)
+{
+	char *out_real = kunit_kzalloc(test, len, GFP_KERNEL);
+	int q_real;
+
+	q_real = string_unescape(src, out_real, len, flags);
+	test_string_check_buf(test, name, flags, out_real, q_real, out_test, q_test);
+}
+
 static void test_unescape(struct kunit *test)
 {
 	unsigned int i;
 
 	for (i = 0; i < UNESCAPE_ALL_MASK + 1; i++)
-		test_string_unescape(test, "unescape", i, false);
-	test_string_unescape(test, "unescape inplace",
-			     get_random_u32_below(UNESCAPE_ALL_MASK + 1), true);
+		test_string_unescape_combined(test, "unescape", i, false);
+	test_string_unescape_combined(test, "unescape inplace",
+				      get_random_u32_below(UNESCAPE_ALL_MASK + 1), true);
+
+	test_string_unescape_one(test, "simple case", UNESCAPE_HEX | UNESCAPE_SPECIAL, "ABC", 6, "ABC", 3);
+	test_string_unescape_one(test, "single escape", UNESCAPE_HEX | UNESCAPE_SPECIAL, "A\\x42C", 6, "ABC", 3);
+	test_string_unescape_one(test, "escape before end", UNESCAPE_HEX, "B\\qX", 4, "B\\q", 3);
+	test_string_unescape_one(test, "escape at end", UNESCAPE_HEX, "a\\qX", 3, "a\\", 2);
+	test_string_unescape_one(test, "backslash before escape", UNESCAPE_HEX, "\\\\x41B", 12, "\\\\x41B", 6);
+	test_string_unescape_one(test, "backslash escape", UNESCAPE_HEX | UNESCAPE_SPECIAL, "\\\\x41B", 16, "\\x41B", 5);
 }
 
 static void test_escape(struct kunit *test)
_

Patches currently in -mm which might be from jre@pengutronix.de are

lib-tests-string_helpers-check-null-terminator-too.patch
lib-tests-string_helpers-drop-unused-parameters.patch
lib-tests-string_helpers-introduce-test_string_unescape_one.patch
lib-string_helpers-use-full-destination-buffer-in-string_unescape.patch
lib-string_helpers-fix-counting-of-remaining-bytes-in-string_unescape.patch

