Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938DA3803D3
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 17:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775235766; cv=none; b=lXIAbpOPe1dioCYttCbKbRY2LG0R+VxM6PxgJ+AkltKVKpWSyqA7/1umsntPutWgW/QaotJ1YnaYy4vUHKP5+zQ8Z9MilKuFQj/TX7gk8q/mlDyBIrMfowAqeXqrvVt8W8pvTuBRUWKChPtujQR5OO2L9dGrqMbAT+X6X+hjd6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775235766; c=relaxed/simple;
	bh=2+osUTgQmGgAC7Si3ly3poM/RpRBiCRjZxRiI6cFwSM=;
	h=Date:To:From:Subject:Message-Id; b=bfJT0z7I+0ZXQC4Z90XgTtmWkfq5QhWMUkbjFJJh+FrJe7SUkCmu96sraEc/lxJGZNm9a1MjwF/pj6I1Rkptloupm/uI8Zp8ksHJWcshwSYfx9qC03RMcSnQXOCzo3XpSd0yR9cHrYsU/DSIvhMHbP8bxk/ZP/IAriix8qnfXO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vU1WKt+m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vU1WKt+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2332BC4CEF7;
	Fri,  3 Apr 2026 17:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775235766;
	bh=2+osUTgQmGgAC7Si3ly3poM/RpRBiCRjZxRiI6cFwSM=;
	h=Date:To:From:Subject:From;
	b=vU1WKt+mJDWne0Tz2c63uWvkzqWUNoFUTjBDIDXlttAaHMYSbfQWrppxGtP3Jt4dy
	 8nDxsk3ebln9CDMkfW2LifOkGyuB/1i/nEJM9ssIOMzzRXOk0Iqb16g0OVhAsnuzbK
	 8iF7JPmTF7HrjDMdenhQGmdez1f4oCAcJk1QIB7I=
Date: Fri, 03 Apr 2026 10:02:45 -0700
To: mm-commits@vger.kernel.org,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-cmdline_kunit-add-test-case-for-memparse.patch removed from -mm tree
Message-Id: <20260403170246.2332BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/cmdline_kunit: add test case for memparse()
has been removed from the -mm tree.  Its filename was
     lib-cmdline_kunit-add-test-case-for-memparse.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: lib/cmdline_kunit: add test case for memparse()
Date: Thu, 12 Feb 2026 19:44:12 +0300

Better late than never, now there is a long-awaited basic test for
'memparse()' which is provided by cmdline.c.

Link: https://lkml.kernel.org/r/20260212164413.889625-5-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/tests/cmdline_kunit.c |   56 ++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

--- a/lib/tests/cmdline_kunit.c~lib-cmdline_kunit-add-test-case-for-memparse
+++ a/lib/tests/cmdline_kunit.c
@@ -6,6 +6,7 @@
 #include <kunit/test.h>
 #include <linux/kernel.h>
 #include <linux/random.h>
+#include <linux/sizes.h>
 #include <linux/string.h>
 
 static const char *cmdline_test_strings[] = {
@@ -139,11 +140,66 @@ static void cmdline_test_range(struct ku
 	} while (++i < ARRAY_SIZE(cmdline_test_range_strings));
 }
 
+struct cmdline_test_memparse_entry {
+	const char *input;
+	const char *unrecognized;
+	unsigned long long result;
+};
+
+static const struct cmdline_test_memparse_entry testdata[] = {
+	{ "0",				"",	0ULL },
+	{ "1",				"",	1ULL },
+	{ "a",				"a",	0ULL },
+	{ "k",				"k",	0ULL },
+	{ "E",				"E",	0ULL },
+	{ "0xb",			"",	11ULL },
+	{ "0xz",			"x",	0ULL },
+	{ "1234",			"",	1234ULL },
+	{ "04567",			"",	2423ULL },
+	{ "0x9876",			"",	39030LL },
+	{ "05678",			"8",	375ULL },
+	{ "0xabcdefz",			"z",	11259375ULL },
+	{ "0cdba",			"c",	0ULL },
+	{ "4K",				"",	SZ_4K },
+	{ "0x10k@0xaaaabbbb",		"@",	SZ_16K },
+	{ "32M",			"",	SZ_32M },
+	{ "067m:foo",			":",	55 * SZ_1M },
+	{ "2G;bar=baz",			";",	SZ_2G },
+	{ "07gz",			"z",	7ULL * SZ_1G },
+	{ "3T+data",			"+",	3 * SZ_1T },
+	{ "04t,ro",			",",	SZ_4T },
+	{ "012p",			"",	11258999068426240ULL },
+	{ "7P,sync",			",",	7881299347898368ULL },
+	{ "0x2e",			"",	46ULL },
+	{ "2E and more",		" ",	2305843009213693952ULL },
+	{ "18446744073709551615",	"",	ULLONG_MAX },
+	{ "0xffffffffffffffff0",	"",	ULLONG_MAX },
+	{ "1111111111111111111T",	"",	ULLONG_MAX },
+	{ "222222222222222222222G",	"",	ULLONG_MAX },
+	{ "3333333333333333333333M",	"",	ULLONG_MAX },
+};
+
+static void cmdline_test_memparse(struct kunit *test)
+{
+	const struct cmdline_test_memparse_entry *e;
+	unsigned long long ret;
+	char *retptr;
+
+	for (e = testdata; e < testdata + ARRAY_SIZE(testdata); e++) {
+		ret = memparse(e->input, &retptr);
+		KUNIT_EXPECT_EQ_MSG(test, ret, e->result,
+				    "    when parsing '%s'", e->input);
+		KUNIT_EXPECT_EQ_MSG(test, *retptr, *e->unrecognized,
+				    "    when parsing '%s'", e->input);
+	}
+}
+
 static struct kunit_case cmdline_test_cases[] = {
 	KUNIT_CASE(cmdline_test_noint),
 	KUNIT_CASE(cmdline_test_lead_int),
 	KUNIT_CASE(cmdline_test_tail_int),
 	KUNIT_CASE(cmdline_test_range),
+	KUNIT_CASE(cmdline_test_memparse),
 	{}
 };
 
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch

