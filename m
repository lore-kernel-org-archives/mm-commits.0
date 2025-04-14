Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242751E51E2
	for <mm-commits@vger.kernel.org>; Mon, 14 Apr 2025 21:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744667056; cv=none; b=dQ+j3Op0ulhrWyKAkabvFrKfaqYd0jpqR0OVGbxMw5SUlr00Uutlql3t7Y+1U5Y7banKD59/dafUR8yCHNmQQxYYEOvwj7s3sjkMJPajcuHANjrIr5ikr2cpRNS0o3bZSWd+f1IPrr4DVgNgybAD8uRuEoMFvDnzvjB8/EGsJMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744667056; c=relaxed/simple;
	bh=/CZQKNsm6NscwySaEqZGNjM8uc2IBrAMXl9GG9TuuJs=;
	h=Date:To:From:Subject:Message-Id; b=AljFAc4+fBFuqExvxz3tLHm807lF6CMi50QIEx3Wa3CSJ/tOaeMFhcbiH4BGU55PPS+8I1l+JZbG8vrfoRAjfXe0s2qSjKRSpvDSV5YgPdf5acvNxRwl+kbPKSXRFzdFSIaddVkgm3HdF16utL0WCdj3pjTTxsGtUxU/uiW++nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YlEKA1Ey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YlEKA1Ey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E481FC4CEE2;
	Mon, 14 Apr 2025 21:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744667056;
	bh=/CZQKNsm6NscwySaEqZGNjM8uc2IBrAMXl9GG9TuuJs=;
	h=Date:To:From:Subject:From;
	b=YlEKA1EyqxMUNfxuSGQXnuBJeB3Lg/0FDs0C9MLmtGbgNad20xxAnNDXj8H3DjXwY
	 CxYgTrlFIA1Mk19JQpWmpFjxDIHnV5cJ/ugmCxpvUHcpaqFTrlzjKWmU0EBhEcYDxD
	 S9dE5UzAbQMoc3iXKSQbxEpbCjuvmiPztsm3RX18=
Date: Mon, 14 Apr 2025 14:44:15 -0700
To: mm-commits@vger.kernel.org,tamird@gmail.com,rmoar@google.com,davidgow@google.com,brendan.higgins@linux.dev,geert@linux-m68k.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-prime_numbers_kunit_test-should-not-select-prime_numbers.patch added to mm-nonmm-unstable branch
Message-Id: <20250414214415.E481FC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: PRIME_NUMBERS_KUNIT_TEST should not select PRIME_NUMBERS
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-prime_numbers_kunit_test-should-not-select-prime_numbers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-prime_numbers_kunit_test-should-not-select-prime_numbers.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

lib-prime_numbers_kunit_test-should-not-select-prime_numbers.patch

