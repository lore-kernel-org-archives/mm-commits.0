Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91181187872
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 23:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738971192; cv=none; b=YuMlgHeb4GSt8SWwoJ0PU7Ma6zRx50veazyPT9/h19aIG6aPelOK07hleeWDTINHlm27dqnPT/BV9M/ApWKwaGmuftbOZVA/O87Alwg+a5IjZptEafulllIT8dd+1TJikeu0U4ggabBm/dKdEcUv0rhuW17sAoNKocuohDoq3a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738971192; c=relaxed/simple;
	bh=fkHWjFG1tysc/p21qlzRaWgDBSpyIG/+TOjq8nG31BE=;
	h=Date:To:From:Subject:Message-Id; b=bvc0FmC8grjZWATJAID5cRUkifnKSFAgGyGmSHeujHteoDV0e8T/W+pF/FK2KPwfSQbEUb4dkbOg0j+GkvVM06FmIiQD5R73H5NLMlgtvTJruTUmnKuVMKikVHO3rc2fRZK4DRc+aJjuA2e0+w1V2l1KFb708N6ZTLuPSAF5bpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2q1txrEi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2q1txrEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A30DC4CED1;
	Fri,  7 Feb 2025 23:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738971192;
	bh=fkHWjFG1tysc/p21qlzRaWgDBSpyIG/+TOjq8nG31BE=;
	h=Date:To:From:Subject:From;
	b=2q1txrEiklOXx0J8P44TSRKK+HxOBr77gU3kJCGuHYQS4TKp5bfGeX173Iind90tv
	 P5IkOoixoy26BlaCKluqnRPLOnfQNtdg8ktlTbig3wkTgMPj7pLDwSLwnBS+KgAWzS
	 j791FKujCH8+07OTvHr2FLCvwM/OaTeB6WI/AAp4=
Date: Fri, 07 Feb 2025 15:33:11 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,luis.hernandez093@gmail.com,davidgow@google.com,tamird@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-prime_numbers-convert-self-test-to-kunit.patch added to mm-nonmm-unstable branch
Message-Id: <20250207233312.4A30DC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/prime_numbers: convert self-test to KUnit
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-prime_numbers-convert-self-test-to-kunit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-prime_numbers-convert-self-test-to-kunit.patch

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
Subject: lib/prime_numbers: convert self-test to KUnit
Date: Fri, 07 Feb 2025 17:33:00 -0500

Extract a private header and convert the prime_numbers self-test to a
KUnit test.  I considered parameterizing the test using `KUNIT_CASE_PARAM`
but didn't see how it was possible since the test logic is entangled with
the test parameter generation logic.

Link: https://lkml.kernel.org/r/20250207-prime_numbers-kunit-convert-v1-2-6067f2b7c713@gmail.com
Signed-off-by: Tamir Duberstein <tamird@gmail.com>
Cc: David Gow <davidgow@google.com>
Cc: Luis Felipe Hernandez <luis.hernandez093@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug                            |   14 +
 lib/math/prime_numbers.c                     |  151 -----------------
 lib/math/prime_numbers_private.h             |   64 +++++++
 lib/math/tests/Makefile                      |    1 
 lib/math/tests/prime_numbers_kunit.c         |   92 ++++++++++
 tools/testing/selftests/lib/config           |    1 
 tools/testing/selftests/lib/prime_numbers.sh |    4 
 7 files changed, 173 insertions(+), 154 deletions(-)

--- a/lib/Kconfig.debug~lib-prime_numbers-convert-self-test-to-kunit
+++ a/lib/Kconfig.debug
@@ -3210,6 +3210,20 @@ config GCD_KUNIT_TEST
 
 	  If unsure, say N
 
+config PRIME_NUMBERS_KUNIT_TEST
+	tristate "Prime number generator test" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	select PRIME_NUMBERS
+	default KUNIT_ALL_TESTS
+	help
+	  This option enables the KUnit test suite for the {is,next}_prime_number
+	  functions.
+
+	  Enabling this option will include tests that compare the prime number
+	  generator functions against a brute force implementation.
+
+	  If unsure, say N
+
 endif # RUNTIME_TESTING_MENU
 
 config ARCH_USE_MEMTEST
--- a/lib/math/prime_numbers.c~lib-prime_numbers-convert-self-test-to-kunit
+++ a/lib/math/prime_numbers.c
@@ -1,70 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0-only
-#define pr_fmt(fmt) "prime numbers: " fmt
 
-#include <linux/module.h>
-#include <linux/mutex.h>
 #include <linux/prime_numbers.h>
 #include <linux/slab.h>
 
-struct primes {
-	struct rcu_head rcu;
-	unsigned long last, sz;
-	unsigned long primes[];
-};
-
-#if BITS_PER_LONG == 64
-static const struct primes small_primes = {
-	.last = 61,
-	.sz = 64,
-	.primes = {
-		BIT(2) |
-		BIT(3) |
-		BIT(5) |
-		BIT(7) |
-		BIT(11) |
-		BIT(13) |
-		BIT(17) |
-		BIT(19) |
-		BIT(23) |
-		BIT(29) |
-		BIT(31) |
-		BIT(37) |
-		BIT(41) |
-		BIT(43) |
-		BIT(47) |
-		BIT(53) |
-		BIT(59) |
-		BIT(61)
-	}
-};
-#elif BITS_PER_LONG == 32
-static const struct primes small_primes = {
-	.last = 31,
-	.sz = 32,
-	.primes = {
-		BIT(2) |
-		BIT(3) |
-		BIT(5) |
-		BIT(7) |
-		BIT(11) |
-		BIT(13) |
-		BIT(17) |
-		BIT(19) |
-		BIT(23) |
-		BIT(29) |
-		BIT(31)
-	}
-};
-#else
-#error "unhandled BITS_PER_LONG"
-#endif
-
-static DEFINE_MUTEX(lock);
-static const struct primes __rcu *primes = RCU_INITIALIZER(&small_primes);
+#include "prime_numbers_private.h"
 
-static unsigned long selftest_max;
-
-static bool slow_is_prime_number(unsigned long x)
+bool slow_is_prime_number(unsigned long x)
 {
 	unsigned long y = int_sqrt(x);
 
@@ -156,19 +97,6 @@ unlock:
 	return true;
 }
 
-static void free_primes(void)
-{
-	const struct primes *p;
-
-	mutex_lock(&lock);
-	p = rcu_dereference_protected(primes, lockdep_is_held(&lock));
-	if (p != &small_primes) {
-		rcu_assign_pointer(primes, &small_primes);
-		kfree_rcu((struct primes *)p, rcu);
-	}
-	mutex_unlock(&lock);
-}
-
 /**
  * next_prime_number - return the next prime number
  * @x: the starting point for searching to test
@@ -238,78 +166,3 @@ bool is_prime_number(unsigned long x)
 	return result;
 }
 EXPORT_SYMBOL(is_prime_number);
-
-static void dump_primes(void)
-{
-	const struct primes *p;
-	char *buf;
-
-	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
-
-	rcu_read_lock();
-	p = rcu_dereference(primes);
-
-	if (buf)
-		bitmap_print_to_pagebuf(true, buf, p->primes, p->sz);
-	pr_info("primes.{last=%lu, .sz=%lu, .primes[]=...x%lx} = %s\n",
-		p->last, p->sz, p->primes[BITS_TO_LONGS(p->sz) - 1], buf);
-
-	rcu_read_unlock();
-
-	kfree(buf);
-}
-
-static int selftest(unsigned long max)
-{
-	unsigned long x, last;
-
-	if (!max)
-		return 0;
-
-	for (last = 0, x = 2; x < max; x++) {
-		bool slow = slow_is_prime_number(x);
-		bool fast = is_prime_number(x);
-
-		if (slow != fast) {
-			pr_err("inconsistent result for is-prime(%lu): slow=%s, fast=%s!\n",
-			       x, slow ? "yes" : "no", fast ? "yes" : "no");
-			goto err;
-		}
-
-		if (!slow)
-			continue;
-
-		if (next_prime_number(last) != x) {
-			pr_err("incorrect result for next-prime(%lu): expected %lu, got %lu\n",
-			       last, x, next_prime_number(last));
-			goto err;
-		}
-		last = x;
-	}
-
-	pr_info("%s(%lu) passed, last prime was %lu\n", __func__, x, last);
-	return 0;
-
-err:
-	dump_primes();
-	return -EINVAL;
-}
-
-static int __init primes_init(void)
-{
-	return selftest(selftest_max);
-}
-
-static void __exit primes_exit(void)
-{
-	free_primes();
-}
-
-module_init(primes_init);
-module_exit(primes_exit);
-
-module_param_named(selftest, selftest_max, ulong, 0400);
-
-MODULE_AUTHOR("Intel Corporation");
-MODULE_DESCRIPTION("Prime number library");
-MODULE_LICENSE("GPL");
diff --git a/lib/math/prime_numbers_private.h a/lib/math/prime_numbers_private.h
new file mode 100644
--- /dev/null
+++ a/lib/math/prime_numbers_private.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <linux/bits.h>
+#include <linux/mutex.h>
+#include <linux/rcupdate.h>
+#include <linux/types.h>
+
+struct primes {
+	struct rcu_head rcu;
+	unsigned long last, sz;
+	unsigned long primes[];
+};
+
+#if BITS_PER_LONG == 64
+static const struct primes small_primes = {
+	.last = 61,
+	.sz = 64,
+	.primes = {
+		BIT(2) |
+		BIT(3) |
+		BIT(5) |
+		BIT(7) |
+		BIT(11) |
+		BIT(13) |
+		BIT(17) |
+		BIT(19) |
+		BIT(23) |
+		BIT(29) |
+		BIT(31) |
+		BIT(37) |
+		BIT(41) |
+		BIT(43) |
+		BIT(47) |
+		BIT(53) |
+		BIT(59) |
+		BIT(61)
+	}
+};
+#elif BITS_PER_LONG == 32
+static const struct primes small_primes = {
+	.last = 31,
+	.sz = 32,
+	.primes = {
+		BIT(2) |
+		BIT(3) |
+		BIT(5) |
+		BIT(7) |
+		BIT(11) |
+		BIT(13) |
+		BIT(17) |
+		BIT(19) |
+		BIT(23) |
+		BIT(29) |
+		BIT(31)
+	}
+};
+#else
+#error "unhandled BITS_PER_LONG"
+#endif
+
+static const struct primes __rcu *primes = RCU_INITIALIZER(&small_primes);
+static DEFINE_MUTEX(lock);
+
+bool slow_is_prime_number(unsigned long x);
--- a/lib/math/tests/Makefile~lib-prime_numbers-convert-self-test-to-kunit
+++ a/lib/math/tests/Makefile
@@ -3,3 +3,4 @@
 obj-$(CONFIG_INT_POW_TEST) += int_pow_kunit.o
 obj-$(CONFIG_INT_SQRT_KUNIT_TEST) += int_sqrt_kunit.o
 obj-$(CONFIG_GCD_KUNIT_TEST) += gcd_kunit.o
+obj-$(CONFIG_PRIME_NUMBERS_KUNIT_TEST) += prime_numbers_kunit.o
diff --git a/lib/math/tests/prime_numbers_kunit.c a/lib/math/tests/prime_numbers_kunit.c
new file mode 100644
--- /dev/null
+++ a/lib/math/tests/prime_numbers_kunit.c
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <kunit/test.h>
+#include <linux/module.h>
+#include <linux/prime_numbers.h>
+#include <linux/slab.h>
+
+#include "../prime_numbers_private.h"
+
+static void free_primes(struct kunit_suite *suite)
+{
+	const struct primes *p;
+
+	mutex_lock(&lock);
+	p = rcu_dereference_protected(primes, lockdep_is_held(&lock));
+	if (p != &small_primes) {
+		rcu_assign_pointer(primes, &small_primes);
+		kfree_rcu((struct primes *)p, rcu);
+	}
+	mutex_unlock(&lock);
+}
+
+static void dump_primes(struct kunit *test)
+{
+	const struct primes *p;
+	char *buf;
+
+	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+
+	rcu_read_lock();
+	p = rcu_dereference(primes);
+
+	if (buf)
+		bitmap_print_to_pagebuf(true, buf, p->primes, p->sz);
+	kunit_info(test, "primes.{last=%lu, .sz=%lu, .primes[]=...x%lx} = %s\n",
+		   p->last, p->sz, p->primes[BITS_TO_LONGS(p->sz) - 1], buf);
+
+	rcu_read_unlock();
+
+	kfree(buf);
+}
+
+static void prime_numbers_test(struct kunit *test)
+{
+	const unsigned long max = 65536;
+	unsigned long x, last;
+
+	for (last = 0, x = 2; x < max; x++) {
+		bool slow = slow_is_prime_number(x);
+		bool fast = is_prime_number(x);
+
+		if (slow != fast) {
+			KUNIT_FAIL(test,
+				   "inconsistent result for is-prime(%lu): slow=%s, fast=%s!\n",
+				   x, slow ? "yes" : "no", fast ? "yes" : "no");
+			goto err;
+		}
+
+		if (!slow)
+			continue;
+
+		if (next_prime_number(last) != x) {
+			KUNIT_FAIL(test,
+				   "incorrect result for next-prime(%lu): expected %lu, got %lu\n",
+				   last, x, next_prime_number(last));
+			goto err;
+		}
+		last = x;
+	}
+
+	kunit_info(test, "%s(%lu) passed, last prime was %lu\n", __func__, x, last);
+
+err:
+	dump_primes(test);
+}
+
+static struct kunit_case prime_numbers_cases[] = {
+	KUNIT_CASE(prime_numbers_test),
+	{},
+};
+
+static struct kunit_suite prime_numbers_suite = {
+	.name = "math-prime_numbers",
+	.suite_exit = free_primes,
+	.test_cases = prime_numbers_cases,
+};
+
+kunit_test_suite(prime_numbers_suite);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("Prime number library");
+MODULE_LICENSE("GPL");
--- a/tools/testing/selftests/lib/config~lib-prime_numbers-convert-self-test-to-kunit
+++ a/tools/testing/selftests/lib/config
@@ -1,5 +1,4 @@
 CONFIG_TEST_PRINTF=m
 CONFIG_TEST_SCANF=m
 CONFIG_TEST_BITMAP=m
-CONFIG_PRIME_NUMBERS=m
 CONFIG_TEST_BITOPS=m
diff --git a/tools/testing/selftests/lib/prime_numbers.sh a/tools/testing/selftests/lib/prime_numbers.sh
deleted file mode 100644
--- a/tools/testing/selftests/lib/prime_numbers.sh
+++ /dev/null
@@ -1,4 +0,0 @@
-#!/bin/sh
-# SPDX-License-Identifier: GPL-2.0
-# Checks fast/slow prime_number generation for inconsistencies
-$(dirname $0)/../kselftest/module.sh "prime numbers" prime_numbers selftest=65536
_

Patches currently in -mm which might be from tamird@gmail.com are

lib-math-hook-up-tests-makefile.patch
lib-prime_numbers-convert-self-test-to-kunit.patch

