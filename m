Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560631;
	b=DjsFBqvB6SH5JImdMCDGyS+q4Zoc3A6Om//1/hC8Em9fVQsULKi2hwAA7oroE9Lpt2ft
	 R2X3DImNgiAHGNi3Y5vLP5F5yFWjB/4LQdUiFlBKwHSBQo4EOPFGdvH3uyix1Ft4E6oyi
	 TQoUY/7EnR98fhhLrEvmdyInpn/Tt7AiM+kyq+eqcaJZzdafrINine0zJr0GtZZVA+e3z
	 3Gml7zgP0hbm3Hgfp3Ok2wJxj2FKVnXUwYAWOd8q5I28+WKmD7aGi86og4S9YYsFLfLJi
	 /eCyKrKDrdHBbY2BpFLS9XDjJqf8WmyBNoGIYUzg1XuEeYH8M84Ln2jcHShEnL1MX4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560631;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=FlfAq/3kxPoBKM2MMHxmBDoHs0tku2gOoOW4dwlB9fE=;
	b=iQFWCiZCixTaZdcH46n5E365Eq8tQOvGxAA8fLq/YquDw2mOkZevuXJNXrc6tuRhUCOx
	 wbg5Cfv7Br6+gkjX+OYWVobVgbRqufwmOlISZe7hfmaZnzSfq8A7lMURd+WHLDtmagfir
	 2lEeCn/kLaYiBRk1yLZknqPiGKR83ESqOEDrkjEeNp+w0wX+BdHMSkiwSdvHy3Bq+a1Em
	 gFOHcm2G3FM4jvWYrRkDbUJRrAOm1XfAwUADu72lgOB54HR8dQk26YmJpwwSBkl/F/jbO
	 7QccZ3xHeyJzRo7LpoNwRQ+lHCeeyS/xeSA9bkaKvTgoRLEFAGL+sPSSiqE+en6CBiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="1a4oqZ/a";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0488C606A31D;
	Wed, 21 Oct 2026 05:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1a4oqZ/a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DF91F000CC;
	Wed, 21 Oct 2026 05:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792560630;
	bh=FlfAq/3kxPoBKM2MMHxmBDoHs0tku2gOoOW4dwlB9fE=;
	h=Date:To:From:Subject;
	b=1a4oqZ/aZ4NBWc1ejr2fDITBg5sOHyCIQJFciBcq/VQp4HnhUaa7CpoOCmnK71HVf
	 fnQkaFQO0DRNFNo01tdHkbXNAAtVU707r5hA0QijHwyQMikFH2ivni1ZY9dgQi8kT2
	 F+SIwQvqMGomTdI+jQlxxKmoDLsETnAe2Tnpli7s=
Date: Tue, 20 Oct 2026 22:30:30 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,lzsx618@gmail.com,andriy.shevchenko@intel.com,armaan.sandhu0504@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges.patch removed from -mm tree
Message-Id: <20261021053030.85DF91F000CC@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: lib/cmdline: fix get_options() count and overflow with large ranges
has been removed from the -mm tree.  Its filename was
     lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Armaan Sandhu <armaan.sandhu0504@gmail.com>
Subject: lib/cmdline: fix get_options() count and overflow with large ranges
Date: Mon,  5 Oct 2026 17:39:45 -0400

get_range() stops writing once the array is full, but get_options() still
advances its index by the whole range.  So "1-100" parsed into four ints
reports 99 numbers, and a range like "0-2147483647" wraps the index
negative and writes outside the array.

Stop once a range fills the array, bail out in validation mode before the
count overflows, and saturate the range length in get_range().  Add KUnit
cases; without the fix "0-2147483647" panics the test kernel.

Only root can supply this input, so this is a robustness fix.

[akpm@linux-foundation.org: add additional test case from Leizhen]
Link: https://lore.kernel.org/20261005213945.359905-1-armaan.sandhu0504@gmail.com
Fixes: 22f2e2801799 ("[PATCH] get_options to allow a hypenated range for isolcpus")
Signed-off-by: Armaan Sandhu <armaan.sandhu0504@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Leizhen Zhang <lzsx618@gmail.com>
Reviewed-by: Leizhen Zhang <lzsx618@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <stable@vger.kernel.org>
---

 lib/cmdline.c             |   13 +++++++++++-
 lib/tests/cmdline_kunit.c |   39 ++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 1 deletion(-)

--- a/lib/cmdline.c~lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges
+++ a/lib/cmdline.c
@@ -11,6 +11,7 @@
 
 #include <linux/export.h>
 #include <linux/kernel.h>
+#include <linux/overflow.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
 
@@ -26,7 +27,9 @@ static int get_range(char **str, int *pi
 
 	(*str)++;
 	upper_range = simple_strtol((*str), NULL, 0);
-	inc_counter = upper_range - *pint;
+	/* Keep the sign of the result when the difference doesn't fit */
+	if (check_sub_overflow(upper_range, *pint, &inc_counter))
+		inc_counter = upper_range < *pint ? -1 : INT_MAX;
 	for (x = *pint; n && x < upper_range; x++, n--)
 		*pint++ = x;
 	return inc_counter;
@@ -122,6 +125,14 @@ char *get_options(const char *str, int n
 			range_nums = get_range((char **)&str, pint, n);
 			if (range_nums < 0)
 				break;
+			/* The range didn't fit, so the array is full */
+			if (!validate && range_nums > n) {
+				i = nints;
+				break;
+			}
+			/* Leave room for the upper number of the range */
+			if (range_nums >= INT_MAX - i)
+				break;
 			/*
 			 * Decrement the result by one to leave out the
 			 * last number in the range.  The next iteration
--- a/lib/tests/cmdline_kunit.c~lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges
+++ a/lib/tests/cmdline_kunit.c
@@ -140,6 +140,44 @@ static void cmdline_test_range(struct ku
 	} while (++i < ARRAY_SIZE(cmdline_test_range_strings));
 }
 
+static const struct {
+	const char *in;
+	int parsed[4];
+	int validated;
+} cmdline_test_range_overflow_cases[] = {
+	{ "1-100",         { 3, 1, 2, 3, },    100,        },
+	{ "1,5-100,7",     { 3, 1, 5, 6, },    98,         },
+	{ "1-2147483646",  { 3, 1, 2, 3, },    2147483646, },
+	{ "0-2147483647",  { 3, 0, 1, 2, },    0,          },
+	{ "-5-2147483647", { 3, -5, -4, -3, }, 0,          },
+	{ "2147483647--5", { 0, 2147483647, }, 0,          },
+	{ "1,0-2147483647", { 3, 1, 0, 1, },   1, },
+};
+
+static void cmdline_test_range_overflow(struct kunit *test)
+{
+	unsigned int i, j;
+
+	for (i = 0; i < ARRAY_SIZE(cmdline_test_range_overflow_cases); i++) {
+		const char *in = cmdline_test_range_overflow_cases[i].in;
+		const int *e = cmdline_test_range_overflow_cases[i].parsed;
+		/* Two guard elements past the array handed to get_options() */
+		int r[ARRAY_SIZE(cmdline_test_range_overflow_cases[0].parsed) + 2];
+		int n;
+
+		memset(r, 0, sizeof(r));
+		get_options(in, ARRAY_SIZE(r) - 2, r);
+		for (j = 0; j < ARRAY_SIZE(r) - 2; j++)
+			KUNIT_EXPECT_EQ_MSG(test, r[j], e[j], "Pattern: %s at %u", in, j);
+		for (; j < ARRAY_SIZE(r); j++)
+			KUNIT_EXPECT_EQ_MSG(test, r[j], 0, "Pattern: %s out of bound at %u", in, j);
+
+		get_options(in, 0, &n);
+		KUNIT_EXPECT_EQ_MSG(test, n, cmdline_test_range_overflow_cases[i].validated,
+				    "Pattern: %s (validated)", in);
+	}
+}
+
 static void cmdline_test_next_arg_quoted_value(struct kunit *test)
 {
 	char in[] = "foo=\"bar baz\" qux=1";
@@ -258,6 +296,7 @@ static struct kunit_case cmdline_test_ca
 	KUNIT_CASE(cmdline_test_lead_int),
 	KUNIT_CASE(cmdline_test_tail_int),
 	KUNIT_CASE(cmdline_test_range),
+	KUNIT_CASE(cmdline_test_range_overflow),
 	KUNIT_CASE(cmdline_test_next_arg_quoted_value),
 	KUNIT_CASE(cmdline_test_next_arg_bare_quote_regression),
 	KUNIT_CASE(cmdline_test_next_arg_mixed_tokens),
_

Patches currently in -mm which might be from armaan.sandhu0504@gmail.com are


