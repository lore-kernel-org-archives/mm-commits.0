Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2890431D730
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 17:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775235765; cv=none; b=oTQVxWU7qvxtPX0M8qdnDnduFKGzGH9PIrgSwdmu/ssrWZiNDPN2X+TcYxG1blPRsMygFM8fyKSxU5OSjbkp9CdKSvsUkz+3fMVU0f5RMQvSO/TeYvUP+K/eissGF4nXvErrKTG7AZFPF6MxJOpFG6mfLBFC4D+2SZf/rWFAphI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775235765; c=relaxed/simple;
	bh=gjxl8rBQna2DmLXLh8PAoIfslCfxbirHvTmbCOStYUo=;
	h=Date:To:From:Subject:Message-Id; b=V/5fsXHC2EUKsK720oEKla03x3f4Pps12dNSEnc7kGWGV9Ecli6uxiC7XAxbTAL/8tj+O8otyLTenVBkbkpcPrY+8z3YLKxsRYABT73eG1oFN5PQhNrTQ1lDuBt0WIirkOAGYHfHDVOLKdDuhvnCUzOlqi46+YMl51rSbPtZHlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T+6MvPXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T+6MvPXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0458C4CEF7;
	Fri,  3 Apr 2026 17:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775235764;
	bh=gjxl8rBQna2DmLXLh8PAoIfslCfxbirHvTmbCOStYUo=;
	h=Date:To:From:Subject:From;
	b=T+6MvPXC78qISKepnA7Yaz7hz2JrNUz1YAr2EY18GmO9uzYQP7OCEpJVgrvjqRzVP
	 QR1zRaOZ2Gnvh/cbsVqHn8njxzH5h/Jo4TlDMbNauBfaVSmA909znPnkdnT2YYjJyn
	 WR7Esf5O4Ecj/9tk46mdG/hiTrSG3wPuXhTBcSzU=
Date: Fri, 03 Apr 2026 10:02:44 -0700
To: mm-commits@vger.kernel.org,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch removed from -mm tree
Message-Id: <20260403170244.C0458C4CEF7@smtp.kernel.org>
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
Date: Thu, 12 Feb 2026 19:44:11 +0300

Add a few more string to 64-bit integer conversion tests to check whether
'kstrtoull()', 'kstrtoll()', 'kstrtou64()' and 'kstrtos64()' can handle
overflows reported by '_parse_integer_limit()'.

Link: https://lkml.kernel.org/r/20260212164413.889625-4-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kees Cook <kees@kernel.org>
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

lib-cmdline_kunit-add-test-case-for-memparse.patch
lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch

