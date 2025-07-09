Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9E4224D7
	for <mm-commits@vger.kernel.org>; Wed,  9 Jul 2025 22:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752101107; cv=none; b=hvXr8Ki6DdXo75Z4g1iX2d50+UXZNJ0KuBSYOb7t0CJ5ZDlgnAd8MeYhf5EHaguUQT+FWZqabE4ivu/UXfRdnz1N7E4fGQg7hWzK6j4skVfXDPU39AaD8qMAFbZUA9W9Xp4AplE+q/WfVWKtuhN46jneQUYIQZiJt5ihtvkJNc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752101107; c=relaxed/simple;
	bh=ccVWgAkVFN+MW7KbEsH0BlXDqyv5v8sueSAA40DjnfM=;
	h=Date:To:From:Subject:Message-Id; b=P+lqmOwOGEnKsvmTBFttEFaLJLPrmcTOx04r4AGoSS3x+OWoxn8smAD0A8e+FVlbHi2ipN+IJ9c4wfdXJR+CLwJCwEUaA7UmvIAesAuk/L11Z0Fg+jLgU7U0iqOLay4DyMMNZZOa+VE/Vk8Kgz6cejnOr1NxXBDZvetS0GRqp9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mXvPejTV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mXvPejTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61D0C4CEEF;
	Wed,  9 Jul 2025 22:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752101106;
	bh=ccVWgAkVFN+MW7KbEsH0BlXDqyv5v8sueSAA40DjnfM=;
	h=Date:To:From:Subject:From;
	b=mXvPejTVzKaxJcNW4C0sQ6Nn1fYTYCdclVnsog6sW5MYXPfq/I3KOEluTUzO8rV3W
	 XegaUztEinN21YWWZWRL7MoJ4TFGKukfMKjZT5imVk41lPE0XYd9CwkrZHvcgnTIUO
	 sKdhgY2cl7BDaKImsbWsA9yDIoMGrJtKagCm6Bww=
Date: Wed, 09 Jul 2025 15:45:06 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,rostedt@goodmis.org,pmladek@suse.com,pandoh@google.com,mjguzik@gmail.com,kuniyu@amazon.com,karolina.stolarek@oracle.com,john.ogness@linutronix.de,bhelgaas@google.com,paulmck@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-add-trivial-kunit-test-for-ratelimit.patch added to mm-nonmm-unstable branch
Message-Id: <20250709224506.A61D0C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: add trivial kunit test for ratelimit
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-add-trivial-kunit-test-for-ratelimit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-add-trivial-kunit-test-for-ratelimit.patch

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
From: "Paul E. McKenney" <paulmck@kernel.org>
Subject: lib: add trivial kunit test for ratelimit
Date: Wed, 9 Jul 2025 11:03:33 -0700

Patch series "ratelimit: Add tests for lib/ratelimit.c", v6.

Add a simple "smoke" test along with a simple stress test:

1.	Add trivial kunit test for ratelimit.
2.	Make the ratelimit test more reliable, courtesy of Petr Mladek.
3.	Add stress test for ratelimit.


This patch (of 3):

Add a simple single-threaded smoke test for lib/ratelimit.c

To run on x86:

	make ARCH=x86_64 mrproper
	./tools/testing/kunit/kunit.py run --arch x86_64 --kconfig_add CONFIG_RATELIMIT_KUNIT_TEST=y --kconfig_add CONFIG_SMP=y lib_ratelimit

This will fail on old ___ratelimit(), and subsequent patches provide
the fixes that are required.

[paulmck@kernel.org: apply timeout and kunit feedback from Petr Mladek]
Link: https://lkml.kernel.org/r/d1007957-97ff-4f6f-92ac-606f68c65dfa@paulmck-laptop
Link: https://lore.kernel.org/all/fbe93a52-365e-47fe-93a4-44a44547d601@paulmck-laptop/
Link: https://lore.kernel.org/all/20250423115409.3425-1-spasswolf@web.de/
Link: https://lkml.kernel.org/r/20250709180335.1716384-1-paulmck@kernel.org
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jon Pan-Doh <pandoh@google.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Karolina Stolarek <karolina.stolarek@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug          |   11 ++++
 lib/tests/Makefile         |    1 
 lib/tests/test_ratelimit.c |   79 +++++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+)

--- a/lib/Kconfig.debug~lib-add-trivial-kunit-test-for-ratelimit
+++ a/lib/Kconfig.debug
@@ -3225,6 +3225,17 @@ config TEST_OBJPOOL
 
 	  If unsure, say N.
 
+config RATELIMIT_KUNIT_TEST
+	tristate "KUnit Test for correctness and stress of ratelimit" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  This builds the "test_ratelimit" module that should be used
+	  for correctness verification and concurrent testings of rate
+	  limiting.
+
+	  If unsure, say N.
+
 config INT_POW_KUNIT_TEST
 	tristate "Integer exponentiation (int_pow) test" if !KUNIT_ALL_TESTS
 	depends on KUNIT
--- a/lib/tests/Makefile~lib-add-trivial-kunit-test-for-ratelimit
+++ a/lib/tests/Makefile
@@ -46,5 +46,6 @@ obj-$(CONFIG_STRING_KUNIT_TEST) += strin
 obj-$(CONFIG_STRING_HELPERS_KUNIT_TEST) += string_helpers_kunit.o
 obj-$(CONFIG_USERCOPY_KUNIT_TEST) += usercopy_kunit.o
 obj-$(CONFIG_UTIL_MACROS_KUNIT) += util_macros_kunit.o
+obj-$(CONFIG_RATELIMIT_KUNIT_TEST) += test_ratelimit.o
 
 obj-$(CONFIG_TEST_RUNTIME_MODULE)		+= module/
diff --git a/lib/tests/test_ratelimit.c a/lib/tests/test_ratelimit.c
new file mode 100644
--- /dev/null
+++ a/lib/tests/test_ratelimit.c
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <kunit/test.h>
+
+#include <linux/ratelimit.h>
+#include <linux/module.h>
+
+/* a simple boot-time regression test */
+
+#define TESTRL_INTERVAL (5 * HZ)
+static DEFINE_RATELIMIT_STATE(testrl, TESTRL_INTERVAL, 3);
+
+#define test_ratelimited(test, expected) \
+	KUNIT_ASSERT_EQ(test, ___ratelimit(&testrl, "test_ratelimit_smoke"), (expected))
+
+static void test_ratelimit_smoke(struct kunit *test)
+{
+	// Check settings.
+	KUNIT_ASSERT_GE(test, TESTRL_INTERVAL, 100);
+
+	// Test normal operation.
+	test_ratelimited(test, true);
+	test_ratelimited(test, true);
+	test_ratelimited(test, true);
+	test_ratelimited(test, false);
+
+	schedule_timeout_idle(TESTRL_INTERVAL - 40);
+	test_ratelimited(test, false);
+
+	schedule_timeout_idle(50);
+	test_ratelimited(test, true);
+
+	schedule_timeout_idle(2 * TESTRL_INTERVAL);
+	test_ratelimited(test, true);
+	test_ratelimited(test, true);
+
+	schedule_timeout_idle(TESTRL_INTERVAL - 40);
+	test_ratelimited(test, true);
+	schedule_timeout_idle(50);
+	test_ratelimited(test, true);
+	test_ratelimited(test, true);
+	test_ratelimited(test, true);
+	test_ratelimited(test, false);
+
+	// Test disabling.
+	testrl.burst = 0;
+	test_ratelimited(test, false);
+	testrl.burst = 2;
+	testrl.interval = 0;
+	test_ratelimited(test, true);
+	test_ratelimited(test, true);
+	test_ratelimited(test, true);
+	test_ratelimited(test, true);
+	test_ratelimited(test, true);
+	test_ratelimited(test, true);
+	test_ratelimited(test, true);
+
+	// Testing re-enabling.
+	testrl.interval = TESTRL_INTERVAL;
+	test_ratelimited(test, true);
+	test_ratelimited(test, true);
+	test_ratelimited(test, false);
+	test_ratelimited(test, false);
+}
+
+static struct kunit_case sort_test_cases[] = {
+	KUNIT_CASE_SLOW(test_ratelimit_smoke),
+	{}
+};
+
+static struct kunit_suite ratelimit_test_suite = {
+	.name = "lib_ratelimit",
+	.test_cases = sort_test_cases,
+};
+
+kunit_test_suites(&ratelimit_test_suite);
+
+MODULE_DESCRIPTION("___ratelimit() KUnit test suite");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from paulmck@kernel.org are

lib-add-trivial-kunit-test-for-ratelimit.patch
lib-add-stress-test-for-ratelimit.patch

