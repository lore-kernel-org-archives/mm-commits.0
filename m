Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82DA372698
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028784; cv=none; b=oyUPYdww4dJv24ksXEM/EzMLb3Fz6HfkaI/6jTLlGebw27ynZDvw8goRIx6w648LxSjodvTDJqco2XYVab+5nN5Rkiv5JxrPeRsoMqw4E9luDUrIRsjzhMP0BuY1UUnH37mXJe1F1hcZHb6usnBYEbx+odODswYEeSMiFSH1BM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028784; c=relaxed/simple;
	bh=E/bA8C4q4NTw9u/uhOFyn3Q/xns3oEq27CoS2nA4l3c=;
	h=Date:To:From:Subject:Message-Id; b=sqBlmD3LfACwOwlTZv3SZBAe68TgEcjz3Oe/1xYZvBsJUmFQ5juOrTZR5DzmPnQZof+AxFTeIKtsG1lCwlZRApuTt6fUOmwVyT84mPzcIMxEMR2f5E6elkoQqyLUna8I4WW/2l7577u6UgMgkOwAEEhqmgPktXx5NXFB6SjeDhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lCUI3pnJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lCUI3pnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1EE1F00898;
	Fri, 29 May 2026 04:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028783;
	bh=+j6sgnlAO04PW5EaXmKRXOmWhHITP2GA+x4QMlb2Krw=;
	h=Date:To:From:Subject;
	b=lCUI3pnJqGSU9UugP7+I9VYYpVY+JNlYnnTkQJocjvUSqGjjtvAPi0NB5dLJK1Xsl
	 yykmLJC9VhdGRTW3PIbX9CBW0Yd4TKCu0WtTtNfIuVyddgu/WhT/ZO5FVGIeAN5hnz
	 ZLjs9NZEEXh6SuyO9VdxQh4YoPYr3y8cIFCuM3Qg=
Date: Thu, 28 May 2026 21:26:23 -0700
To: mm-commits@vger.kernel.org,thecharlesjenkins@gmail.com,palmer@dabbelt.com,ardb@kernel.org,aou@eecs.berkeley.edu,andriy.shevchenko@intel.com,alex@ghiti.fr,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch removed from -mm tree
Message-Id: <20260529042623.7D1EE1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: add more string to 64-bit integer conversion overflow tests
has been removed from the -mm tree.  Its filename was
     lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: lib: add more string to 64-bit integer conversion overflow tests
Date: Tue, 19 May 2026 20:22:54 +0300

Add a few more string to 64-bit integer conversion tests to check whether
'kstrtoull()', 'kstrtoll()', 'kstrtou64()' and 'kstrtos64()' can handle
overflows reported by '_parse_integer_limit()'.

Link: https://lore.kernel.org/20260519172259.908980-4-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Charlie Jenkins <thecharlesjenkins@gmail.com>
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

