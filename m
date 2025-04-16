Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA9B4174A
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 01:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744765266; cv=none; b=R80xclfh7nnVpUmcpsj5+pLNiGiEkJrVgVHOzTmf0QAgjvEIGM97b3UvwNZPfCrkLvpxHC1cvOmUzq43O+JrxHUMSk6p4j80cf17+4h2t18+zCXHTypvcD70Xhr5XUjBDRMrP8hHEO9EVU5kpPto+nkLBTWu5jdvF0eOPCZO5To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744765266; c=relaxed/simple;
	bh=d+Lbzzrgih6CL5Texht7myZkfqny9FDni0/OaPb5+yg=;
	h=Date:To:From:Subject:Message-Id; b=UHX/ChPMAvQVEq0scDzZbo3BE/AQrpsVsCNU4zLe5XrVkJUfvWpZEWw7XR/ZOKbnW8//4zPEBBCR+xYIETLmGfj+lN6m6vnJ+IHUlDchCpXiF5suHECMTBCLlR8QB+/J9sVRGQY10aD0wUJvTJZXS2GGW80NHfBf96zKd/U+xJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HZkeqwAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HZkeqwAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4ABCC4CEE7;
	Wed, 16 Apr 2025 01:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744765265;
	bh=d+Lbzzrgih6CL5Texht7myZkfqny9FDni0/OaPb5+yg=;
	h=Date:To:From:Subject:From;
	b=HZkeqwAZy91Fne+/q9jG6B/XoxGRsQwjwtAeknxOzU4pqBypd78+xkhjpLT9jlVNg
	 MVxUdgb35qrit38p79fxWnlOyd8oitK9fULYqlE4u8H6R3kuxVwzEcgBL+6o2QOUr2
	 tlBIfuXKpWapXzl1DEu7sTFkdqOFMUMxmai4QKfw=
Date: Tue, 15 Apr 2025 18:01:05 -0700
To: mm-commits@vger.kernel.org,tamird@gmail.com,rmoar@google.com,davidgow@google.com,brendan.higgins@linux.dev,geert@linux-m68k.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] lib-prime_numbers_kunit_test-should-not-select-prime_numbers.patch removed from -mm tree
Message-Id: <20250416010105.B4ABCC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: PRIME_NUMBERS_KUNIT_TEST should not select PRIME_NUMBERS
has been removed from the -mm tree.  Its filename was
     lib-prime_numbers_kunit_test-should-not-select-prime_numbers.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: lib: PRIME_NUMBERS_KUNIT_TEST should not select PRIME_NUMBERS
Date: Mon, 14 Apr 2025 16:35:00 +0200

Enabling a (modular) test should not silently enable additional kernel
functionality, as that may increase the attack vector of a product.

Fix this by making PRIME_NUMBERS_KUNIT_TEST depend on PRIME_NUMBERS
instead of selecting it.

After this, one can safely enable CONFIG_KUNIT_ALL_TESTS=m to build
modules for all appropriate tests for ones system, without pulling in
extra unwanted functionality, while still allowing a tester to manually
enable PRIME_NUMBERS and this test suite on a system where PRIME_NUMBERS
is not enabled by default.  Resurrect CONFIG_PRIME_NUMBERS=m in
tools/testing/selftests/lib/config for the latter use case.

Link: https://lkml.kernel.org/r/40f8a40eef4930d3ac9febd205bc171eb04e171c.1744641237.git.geert@linux-m68k.org
Fixes: 313b38a6ecb46db4 ("lib/prime_numbers: convert self-test to KUnit")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Tamir Duberstein <tamird@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Rae Moar <rmoar@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug                  |    2 +-
 tools/testing/selftests/lib/config |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/lib/Kconfig.debug~lib-prime_numbers_kunit_test-should-not-select-prime_numbers
+++ a/lib/Kconfig.debug
@@ -3290,7 +3290,7 @@ config GCD_KUNIT_TEST
 config PRIME_NUMBERS_KUNIT_TEST
 	tristate "Prime number generator test" if !KUNIT_ALL_TESTS
 	depends on KUNIT
-	select PRIME_NUMBERS
+	depends on PRIME_NUMBERS
 	default KUNIT_ALL_TESTS
 	help
 	  This option enables the KUnit test suite for the {is,next}_prime_number
--- a/tools/testing/selftests/lib/config~lib-prime_numbers_kunit_test-should-not-select-prime_numbers
+++ a/tools/testing/selftests/lib/config
@@ -1,2 +1,3 @@
 CONFIG_TEST_BITMAP=m
+CONFIG_PRIME_NUMBERS=m
 CONFIG_TEST_BITOPS=m
_

Patches currently in -mm which might be from geert@linux-m68k.org are


