Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF24C3F3297
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 21:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789594768; cv=none; b=Yf49oNl7sOJn5GWvyOvdwWPxaQw1gGhfCWFQFqqTOE9Nzvj+MN6pQzSZybYugrfKZLq47pnU7rRzIY4AAsy78smIOyCkAcmgzEkPxEV1Rtmoab3ZqrN/RC2MbjqlVul6Tk2ZMbMUv4rNAcBmFYB6ScBuALoZqTIKBDsPQ5ERv3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789594768; c=relaxed/simple;
	bh=62fzwlAlZf6Z7VeHckhSwAOE2KY7HWdryAQWRpLPB88=;
	h=Date:To:From:Subject:Message-Id; b=YCORbAsO6fArBxqlmXTZUerWqHbRAkDMbgR3FSr0rwVC+8w5GbQBU2CH9QXtLb9o5fVfCfZJK0dZftbE0Nj03dWggxCLotusbBg1hR6HGUaSYUAouRTU30sxlvjMPCIyqoPJVEjhn/16mIUaXWcKjvANt7H60DM9EhRFFfkkddk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TR44onIJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TR44onIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3151F000FF;
	Wed, 16 Sep 2026 21:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789594741;
	bh=YL+tkMJBT9qc8CVbGn3lJT24+/nDim7c6KWHBhexjtA=;
	h=Date:To:From:Subject;
	b=TR44onIJFnPQEWA0DJVzqU7navuL7u+hMpVj8irCRZarYM/qjtou7cn5lzv816yth
	 UN1KUvKf8GkRnh3FeQg+LJnTIGwLNbJXpAxdh0z3WpFl/WCNYd+dLxgRLJA9jj9gg8
	 8+0wB45xvEckh9EppnVPZPYCRbqWngvTH9v4mzbg=
Date: Wed, 16 Sep 2026 14:39:00 -0700
To: mm-commits@vger.kernel.org,kernel@pengutronix.de,kees@kernel.org,andy@kernel.org,jre@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-tests-string_helpers-check-null-terminator-too.patch added to mm-nonmm-unstable branch
Message-Id: <20260916213901.1A3151F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/tests: string_helpers: check null terminator too
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-tests-string_helpers-check-null-terminator-too.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-tests-string_helpers-check-null-terminator-too.patch

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
Subject: lib/tests: string_helpers: check null terminator too
Date: Wed, 16 Sep 2026 19:38:06 +0200

Patch series "lib/string_helpers: fixes and test cases for
string_unescape()".

This series fixes two bugs in string_unescape() regarding the destination
buffer length.  Both fixes are accompanied with kunit tests which would
fail without the fixes.

To make this possible, preparatory patches 1 and 2 improve and clean up
testing helpers and 3 introduces test_unescape_one() which allows for
targeted testing of the string_unescape() function.


This patch (of 5):

string_unescape() returns the number of character written to dst, not
counting the null terminator which is always written.

Ensure string_unescape has included the null terminator by adding a
separate check.

While at it, improve output for failed tests by showing the memory dump
even if the length differs.

Link: https://lore.kernel.org/20260916-string_unescape-v1-0-7f8bd986fa33@pengutronix.de
Link: https://lore.kernel.org/20260916-string_unescape-v1-1-7f8bd986fa33@pengutronix.de
Signed-off-by: Jonas Rebmann <jre@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
---

 lib/tests/string_helpers_kunit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/tests/string_helpers_kunit.c~lib-tests-string_helpers-check-null-terminator-too
+++ a/lib/tests/string_helpers_kunit.c
@@ -22,7 +22,7 @@ static void test_string_check_buf(struct
 				  char *out_real, size_t q_real,
 				  char *out_test, size_t q_test)
 {
-	KUNIT_ASSERT_EQ_MSG(test, q_real, q_test, "name:%s", name);
+	KUNIT_EXPECT_EQ_MSG(test, q_real, q_test, "name:%s", name);
 	KUNIT_EXPECT_MEMEQ_MSG(test, out_test, out_real, q_test,
 			       "name:%s", name);
 }
@@ -103,6 +103,7 @@ static void test_string_unescape(struct
 
 	test_string_check_buf(test, name, flags, in, p - 1, out_real, q_real,
 			      out_test, q_test);
+	KUNIT_EXPECT_EQ_MSG(test, out_real[q_real], '\0', "name:%s", name);
 }
 
 struct test_string_1 {
_

Patches currently in -mm which might be from jre@pengutronix.de are

lib-tests-string_helpers-check-null-terminator-too.patch
lib-tests-string_helpers-drop-unused-parameters.patch
lib-tests-string_helpers-introduce-test_string_unescape_one.patch
lib-string_helpers-use-full-destination-buffer-in-string_unescape.patch
lib-string_helpers-fix-counting-of-remaining-bytes-in-string_unescape.patch

