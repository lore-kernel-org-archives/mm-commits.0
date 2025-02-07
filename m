Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904D1187872
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 23:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738971190; cv=none; b=VskLJguwdzNNcMB87mJ3OXThhEsAVQ56hGMH+A+5DcV1wS/ISX8bt0BiiyXzTjO/WDASkj3T5THDppPDJTlRcSwO6qBLMguCmypxRRfcFYOSHGd0+BGtvMc6NwCugVli+ReGAIOCBChkqCD0woyVay4WMHAjH4qvHHO6QnvEUYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738971190; c=relaxed/simple;
	bh=xfi0vddxHbuiskKsH/7OOTpnFK8EkMtwnqeuzR+QNvA=;
	h=Date:To:From:Subject:Message-Id; b=tRpqdjRdVMtA0bZ5uG0nnMwGkfIECvtcUt1RxL0eA94KJCEH5LDIDdiAFMfTAtJXjNgrtoKvRKq/HhWuBPiicVSV69pL2yWNACT0Q3FdHhcGzrWdYi7Agil1N3/zNA/UeFtG2jWIy1X8px5HIQ2Xo3e8+FdiaY+0B/jlnJti7t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uqbhh2zO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uqbhh2zO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3991DC4CED1;
	Fri,  7 Feb 2025 23:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738971190;
	bh=xfi0vddxHbuiskKsH/7OOTpnFK8EkMtwnqeuzR+QNvA=;
	h=Date:To:From:Subject:From;
	b=uqbhh2zOceJClSStzd3drwAKsBMmr3wffMEyBLXwMwCJ+vop8cnuSbRTMz/mNidm2
	 1xbYFJ6TS7jJBXSK9krys9LAGqZSe/QzkxqOSLDV+GeF7q1W1jc7TQ+ThN33t+qGpr
	 ZhGEoZY/YPdRSkJzxK9qmpNcALYfRldt8Suj3srI=
Date: Fri, 07 Feb 2025 15:33:09 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,luis.hernandez093@gmail.com,davidgow@google.com,tamird@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-math-hook-up-tests-makefile.patch added to mm-nonmm-unstable branch
Message-Id: <20250207233310.3991DC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/math: hook up tests/Makefile
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-math-hook-up-tests-makefile.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-math-hook-up-tests-makefile.patch

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
From: Tamir Duberstein <tamird@gmail.com>
Subject: lib/math: hook up tests/Makefile
Date: Fri, 07 Feb 2025 17:32:59 -0500

Patch series "lib/prime_numbers: convert self-test to KUnit".

This is a clear example of a unit test.

I tested this using:

$ tools/testing/kunit/kunit.py run --arch arm64 --make_options LLVM=1 math-prime_numbers

; KTAP version 1
; 1..1
;     KTAP version 1
;     # Subtest: math-prime_numbers
;     # module: prime_numbers_kunit
;     1..1
;     # prime_numbers_test: prime_numbers_test(65536) passed, last prime was 65521
;     # prime_numbers_test: primes.{last=61, .sz=64, .primes[]=...x28208a20a08a28ac} = 2-3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61
; 
;     ok 1 prime_numbers_test
; ok 1 math-prime_numbers


This patch (of 2):

This Makefile has been dead code since it was added in commit 7fcc9b53216c
("lib/math: Add int_pow test suite"); the tests worked because of the
duplicated rules in the parent directory's Makefile.  Wire up
tests/Makefile and remove the duplication.

Link: https://lkml.kernel.org/r/20250207-prime_numbers-kunit-convert-v1-0-6067f2b7c713@gmail.com
Link: https://lkml.kernel.org/r/20250207-prime_numbers-kunit-convert-v1-1-6067f2b7c713@gmail.com
Fixes: 7fcc9b53216c ("lib/math: Add int_pow test suite")
Signed-off-by: Tamir Duberstein <tamird@gmail.com>
Cc: David Gow <davidgow@google.com>
Cc: Luis Felipe Hernandez <luis.hernandez093@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/math/Makefile |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/math/Makefile~lib-math-hook-up-tests-makefile
+++ a/lib/math/Makefile
@@ -5,9 +5,8 @@ obj-$(CONFIG_CORDIC)		+= cordic.o
 obj-$(CONFIG_PRIME_NUMBERS)	+= prime_numbers.o
 obj-$(CONFIG_RATIONAL)		+= rational.o
 
-obj-$(CONFIG_INT_POW_TEST)  += tests/int_pow_kunit.o
 obj-$(CONFIG_TEST_DIV64)	+= test_div64.o
 obj-$(CONFIG_TEST_MULDIV64)	+= test_mul_u64_u64_div_u64.o
 obj-$(CONFIG_RATIONAL_KUNIT_TEST) += rational-test.o
-obj-$(CONFIG_INT_SQRT_KUNIT_TEST) += tests/int_sqrt_kunit.o
 obj-$(CONFIG_GCD_KUNIT_TEST) += tests/gcd_kunit.o
+obj-y += tests/
_

Patches currently in -mm which might be from tamird@gmail.com are

lib-math-hook-up-tests-makefile.patch
lib-prime_numbers-convert-self-test-to-kunit.patch

