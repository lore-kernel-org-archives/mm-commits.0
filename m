Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F63343893
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338408; cv=none; b=LJXSiG0v/Muu+Rqa3J1Lh47izd71MGVZ1fJOP5zUfjoTwejok5+kSqLGBxfIzj2gmOK+E8uBg3FuKDJQ0kFS4JjW5t9NujsOApneZ7hS65KAqjl96QLvlJBccHdaI/0oNjIgy2vt/vWJIL/wVk2irg9KNAX5Z53anFqINzpTa+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338408; c=relaxed/simple;
	bh=AQtWYFxnZ3xgzc0eW9HVotDlhnNasDvvWNWGoWNyaog=;
	h=Date:To:From:Subject:Message-Id; b=XWuioKw3ASGvSTC/m5fM1D8Oig5QxiQKhLrm6rucUY+8V1UMC75rlxQJQNMhqP7J8Ysg+0DRTkPQgWaX82E1PWJoLR73eJqirCmJfQLDVRwyOLNfR/iMZlrBfYqt7aYkW70PcV2J1DWOju+b+XV35Bvb9mvN28mhLmAnUKI93ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=03KAQNLd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="03KAQNLd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC891F008A1;
	Wed,  7 Oct 2026 02:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338406;
	bh=XOMGh+VhvrgMgO5n6BtxQv8bCm8wGnnwHha3HngMVv0=;
	h=Date:To:From:Subject;
	b=03KAQNLd+PiN8PAfWuwSQtKgEJGCD6ZNA5gI0Gvy3duYr/dBIdKHntTj6QxugG14P
	 UIImuqOSSVUSuK40aoUkG0RBB5qVHQlZ/rlCVSapqyDvCjbjA/k28DMNfkU7zHwA1C
	 Rs52RfW52GkGE3zV6g3B6YATskjsF7/1ZciMUsNU=
Date: Tue, 06 Oct 2026 19:00:06 -0700
To: mm-commits@vger.kernel.org,kernel@pengutronix.de,kees@kernel.org,andy@kernel.org,jre@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-tests-string_helpers-introduce-test_string_unescape_one.patch removed from -mm tree
Message-Id: <20261007020006.7EC891F008A1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/tests: string_helpers: introduce test_string_unescape_one
has been removed from the -mm tree.  Its filename was
     lib-tests-string_helpers-introduce-test_string_unescape_one.patch

This patch was dropped because an updated version will be issued

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

lib-string_helpers-use-full-destination-buffer-in-string_unescape.patch
lib-string_helpers-fix-counting-of-remaining-bytes-in-string_unescape.patch

