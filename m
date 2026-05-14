Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854367261A
	for <mm-commits@vger.kernel.org>; Thu, 14 May 2026 00:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778717324; cv=none; b=G+uyq6j7wq0vXabyq9ljIL+MW11WeO/80qmeWPaxMBeENoCH0y4JrXIBjl8XgyWAGSi+xYu3JpBQiAgqXPdMm3N+FB/65pJddLdsuaEN0+s3gFmmK2S76Fc42XxNBTqlxZH7lr+7nxJGZK9vTrxy4784AZ3ltoqFl3Uge9gWd5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778717324; c=relaxed/simple;
	bh=VfIA1upKiRB0egMeswwY6mQHu/ADVmDF98fhdvZ97pg=;
	h=Date:To:From:Subject:Message-Id; b=E3OO1F4m/Z+NOAnBp+ZAFKh4SHJdTFGerROBRXpO8xj26j9ahLim+TmSxb/qi8xRKM9cLfglQ/h9S+ezNwWtxPmfVIxTO+VsMglXc8DGGWBEyktLduU3EAfS4YQOIlQl0Afp6cvaLAPJNB2x6GO8jRtOUbwinnS2H7A40KwcPp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OmkVSQlU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OmkVSQlU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C648C19425;
	Thu, 14 May 2026 00:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778717324;
	bh=VfIA1upKiRB0egMeswwY6mQHu/ADVmDF98fhdvZ97pg=;
	h=Date:To:From:Subject:From;
	b=OmkVSQlUkdFV8VIATMX+gR1fMx8TtCftgz2m29j2bgnvbSQiyv0Az1DjqjgaIYPIg
	 xWDqUiysuOIMzkF+8xcpGZgy1SoMz2ZHfubWBUkQ/N3nWVRFKAA0xOUyeCmsMY550A
	 IDWQvB6AmACgyMoeiK/W3cYf5EVkGcqwLKkPFCD8=
Date: Wed, 13 May 2026 17:08:43 -0700
To: mm-commits@vger.kernel.org,thecharlesjenkins@gmail.com,palmer@dabbelt.com,lkp@intel.com,ardb@kernel.org,aou@eecs.berkeley.edu,andriy.shevchenko@intel.com,alex@ghiti.fr,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-cmdline_kunit-add-test-case-for-memparse.patch added to mm-nonmm-unstable branch
Message-Id: <20260514000844.4C648C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/cmdline_kunit: add test case for memparse()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-cmdline_kunit-add-test-case-for-memparse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-cmdline_kunit-add-test-case-for-memparse.patch

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
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: lib/cmdline_kunit: add test case for memparse()
Date: Wed, 13 May 2026 16:44:03 +0300

Better late than never, now there is a long-awaited basic test for
'memparse()' which is provided by cmdline.c.

Link: https://lore.kernel.org/20260513134407.884033-5-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Charlie Jenkins <thecharlesjenkins@gmail.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
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
@@ -198,6 +199,60 @@ static void cmdline_test_next_arg_mixed_
 	KUNIT_EXPECT_STREQ(test, next, "");
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
@@ -206,6 +261,7 @@ static struct kunit_case cmdline_test_ca
 	KUNIT_CASE(cmdline_test_next_arg_quoted_value),
 	KUNIT_CASE(cmdline_test_next_arg_bare_quote_regression),
 	KUNIT_CASE(cmdline_test_next_arg_mixed_tokens),
+	KUNIT_CASE(cmdline_test_memparse),
 	{}
 };
 
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

lib-free-pagelist-on-error-in-iov_iter_extract_pages.patch
lib-fix-_parse_integer_limit-to-handle-overflow.patch
lib-fix-memparse-to-handle-overflow.patch
lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch
lib-cmdline_kunit-add-test-case-for-memparse.patch
lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch
riscv-add-platform-specific-double-word-shifts-for-riscv32.patch
lib-kunit-add-tests-for-__ashldi3-__ashrdi3-and-__lshrdi3.patch
riscv-fix-building-compressed-efi-image.patch

