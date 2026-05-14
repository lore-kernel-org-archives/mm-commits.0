Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907F84A33
	for <mm-commits@vger.kernel.org>; Thu, 14 May 2026 00:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778717322; cv=none; b=SNxV3TbyFuyPeYSpGJ3yjfwFO2IpUW25LcBfdmBSyUNY7L8zz17Z6/k2ETRj35hWQOpHMy6PFG7VJCAZ+BhHPOmHN1PLGuiCUDP9xmmwRstl+Vsj7t/72qSQznYdoH163KmXz2YAamyzeGGagGE57pfM4XTq9d6JFuiycOnCKg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778717322; c=relaxed/simple;
	bh=eUuhnZ2SEZzCMKQPV3l/8I2Bqnccra7Wlifyw18lMxI=;
	h=Date:To:From:Subject:Message-Id; b=o1wrSKafBp8WEtqwgmQJwOIGTOrxLSA1Vh4PC8e3heAlHyPcJP07IQkeiCljMAlJIiHQAhyQOIS+opgcK78o0pxjSjQHvWoLev0h7tx52NocS9IwuwaEHc6NW5XDKt0vUyki6UyKiBccRfyli7OGiDuqfjm7aDN017RBjwsKAuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OoCj2Qet; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OoCj2Qet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13021C19425;
	Thu, 14 May 2026 00:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778717322;
	bh=eUuhnZ2SEZzCMKQPV3l/8I2Bqnccra7Wlifyw18lMxI=;
	h=Date:To:From:Subject:From;
	b=OoCj2QetoGTo6jJE4MyIFFCmvVY7fdqMHg7Hs+oNBqSOV1ZTrSvIpPqHcMWL+iFv1
	 /euJ7i1jlHcD7qjWarigJ27AdNVAAF+etYOO58XRe7Dclrtv8/FFcipdw04l0OF+AK
	 FpSTMcKpOF00re7cS5VffH/l1nyKNILArhqwkDwQ=
Date: Wed, 13 May 2026 17:08:41 -0700
To: mm-commits@vger.kernel.org,thecharlesjenkins@gmail.com,palmer@dabbelt.com,lkp@intel.com,ardb@kernel.org,aou@eecs.berkeley.edu,andriy.shevchenko@intel.com,alex@ghiti.fr,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch added to mm-nonmm-unstable branch
Message-Id: <20260514000842.13021C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: add more string to 64-bit integer conversion overflow tests
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch

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
Subject: lib: add more string to 64-bit integer conversion overflow tests
Date: Wed, 13 May 2026 16:44:02 +0300

Add a few more string to 64-bit integer conversion tests to check whether
'kstrtoull()', 'kstrtoll()', 'kstrtou64()' and 'kstrtos64()' can handle
overflows reported by '_parse_integer_limit()'.

Link: https://lore.kernel.org/20260513134407.884033-4-dmantipov@yandex.ru
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

 lib/test-kstrtox.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/lib/test-kstrtox.c~lib-add-more-string-to-64-bit-integer-conversion-overflow-tests
+++ a/lib/test-kstrtox.c
@@ -198,6 +198,7 @@ static void __init test_kstrtoull_fail(v
 		{"10000000000000000000000000000000000000000000000000000000000000000",	2},
 		{"2000000000000000000000",	8},
 		{"18446744073709551616",	10},
+		{"569202370375329612767",	10},
 		{"10000000000000000",	16},
 		/* negative */
 		{"-0", 0},
@@ -275,9 +276,11 @@ static void __init test_kstrtoll_fail(vo
 		{"9223372036854775809",	10},
 		{"18446744073709551614",	10},
 		{"18446744073709551615",	10},
+		{"569202370375329612767",	10},
 		{"-9223372036854775809",	10},
 		{"-18446744073709551614",	10},
 		{"-18446744073709551615",	10},
+		{"-569202370375329612767",	10},
 		/* sign is first character if any */
 		{"-+1", 0},
 		{"-+1", 8},
@@ -334,6 +337,7 @@ static void __init test_kstrtou64_fail(v
 		{"-1",	10},
 		{"18446744073709551616",	10},
 		{"18446744073709551617",	10},
+		{"569202370375329612767",	10},
 	};
 	TEST_FAIL(kstrtou64, u64, "%llu", test_u64_fail);
 }
@@ -386,6 +390,8 @@ static void __init test_kstrtos64_fail(v
 		{"18446744073709551615",	10},
 		{"18446744073709551616",	10},
 		{"18446744073709551617",	10},
+		{"569202370375329612767",	10},
+		{"-569202370375329612767",	10},
 	};
 	TEST_FAIL(kstrtos64, s64, "%lld", test_s64_fail);
 }
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

