Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DBA37C0FB
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 19:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779217301; cv=none; b=I+Y2DaIFYAn7HTFiDOafmeAMcOb18LeQ6fJFinNeaZoqbq1yiceEl84RUjG2vFBmcCoP9mVWBuuSN3ycm9rwSEsLWGFBCGJo7U4j4n4LyCxl2GfvrASokm3LjomvPDdB02SF5KqM2g5jQTgZ/0FZprG36UUtkOWv93i+FKIZonc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779217301; c=relaxed/simple;
	bh=pGquwyOBpN3ppptop0kqFVgCk+p4ycE7CnrGt5Xs//Y=;
	h=Date:To:From:Subject:Message-Id; b=i8NLWJ63JpwFRIsPoksyCCLKPjNOoTasb3gUm8peuPHE4+iqvjB4xjS8n0+PPJxoPj70ZK2COBRRfsslfb01YHNJYMjilVwcH7pEAbD9IdjKZqQpcKxzGCXtyJWG1cVDakjFT1Vrnq2+19L1IHjP3+zgi5pcC7sSr1V4+6YjcZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZxdrQDc8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZxdrQDc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998E51F00893;
	Tue, 19 May 2026 19:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779217299;
	bh=bgk09s8RZu6Ndnin815u46gpA8s0evAPsbCjPnSRxwg=;
	h=Date:To:From:Subject;
	b=ZxdrQDc8fVlyNpQv+GIRCvWtbY9U+B7XlhFT1yGI68JIqH7SCKVWcJmQ9psgBhSYi
	 VDXV9wIJDzByGbs+4LWI02a0xTlHTxU0hGU7xB46riBJvRReX4ZkOG0PSMUbscb2WE
	 zc51lhoguDNmxJY6YWaSXyrpE8Ea77MvMqPdTQaU=
Date: Tue, 19 May 2026 12:01:39 -0700
To: mm-commits@vger.kernel.org,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch removed from -mm tree
Message-Id: <20260519190139.998E51F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: add more string to 64-bit integer conversion overflow tests
has been removed from the -mm tree.  Its filename was
     lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch

This patch was dropped because an updated version will be issued

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
lib-cmdline_kunit-add-test-case-for-memparse.patch
lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch
riscv-add-platform-specific-double-word-shifts-for-riscv32.patch
lib-kunit-add-tests-for-__ashldi3-__ashrdi3-and-__lshrdi3.patch
riscv-fix-building-compressed-efi-image.patch

