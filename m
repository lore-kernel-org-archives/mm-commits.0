Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F51376A13
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 16:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779208172; cv=none; b=UtUS1VrSCbewIO2qy3Nxk95sj34ruCeQTrOFPS3DUcdyOOAv8bgXNcsCMCDCFPRSZDdsOppwKLpiHrnQ8mFB2aB2dTbTP8ZLl+Wk6Hub+6Il1SCvsNFZi4D01AKNpE2nN8hMur0ZgNgxztM1HhN3FICsasdrbhC473K7vu9pBJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779208172; c=relaxed/simple;
	bh=NCMfyiHSv1cYc6FEGA1EjxbqSI9bV1baK3ce9DinRZU=;
	h=Date:To:From:Subject:Message-Id; b=OqFxRnYJj0uN0sXYmBjVJVC5Cg5zunEOWi0VdShEUfv3UpRY21DUUndoSaF0EnbdsjvPi+KfWzC6vhcJO8aIwAfc/CBVpY0WUYVWUJ2mxRTwJSAe/r1ltNniluMSTp4aPSPgqwkIssTmKjkS9ZyUJ+5q4rnCLfAEEQWgj+cbOyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C7IjbEqK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C7IjbEqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D08DC2BCB3;
	Tue, 19 May 2026 16:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779208172;
	bh=NCMfyiHSv1cYc6FEGA1EjxbqSI9bV1baK3ce9DinRZU=;
	h=Date:To:From:Subject:From;
	b=C7IjbEqK1r7MBoFeml7/ov7phfl9c6zwk3QzOWUuu8rIqS6D9EPauY4Q56N1NLXuE
	 96R/7UkZp7L+pVG6+rKo51/ce4CbEB6JP3yyxCyuKEPPrtxuXPYYGFzW1L5gQ63yyW
	 BrcisVAxfknK79FjpPYokayA2qGFBajGesQbbgwE=
Date: Tue, 19 May 2026 09:29:31 -0700
To: mm-commits@vger.kernel.org,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kunit-add-tests-for-smp_cond_load_relaxed_timeout.patch removed from -mm tree
Message-Id: <20260519162932.2D08DC2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kunit: add tests for smp_cond_load_relaxed_timeout()
has been removed from the -mm tree.  Its filename was
     kunit-add-tests-for-smp_cond_load_relaxed_timeout.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ankur Arora <ankur.a.arora@oracle.com>
Subject: kunit: add tests for smp_cond_load_relaxed_timeout()
Date: Wed, 8 Apr 2026 17:55:38 +0530

Add a success and failure case for smp_cond_load_relaxed_timeout().

Both test cases wait on some state in smp_cond_load_relaxed_timeout().  In
the success case we spawn a kthread that pokes the bit.

Link: https://lore.kernel.org/20260408122538.3610871-15-ankur.a.arora@oracle.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Boqun Feng <boqun@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: David Gow <davidgow@google.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Haris Okanovic <harisokn@amazon.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug                |   10 ++
 lib/tests/Makefile               |    1 
 lib/tests/barrier-timeout-test.c |  125 +++++++++++++++++++++++++++++
 3 files changed, 136 insertions(+)

--- a/lib/Kconfig.debug~kunit-add-tests-for-smp_cond_load_relaxed_timeout
+++ a/lib/Kconfig.debug
@@ -2406,6 +2406,16 @@ config FPROBE_SANITY_TEST
 
 	  Say N if you are unsure.
 
+config BARRIER_TIMEOUT_TEST
+	tristate "KUnit tests for smp_cond_load_relaxed_timeout()"
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Builds KUnit tests that validate wake-up and timeout handling paths
+	  in smp_cond_load_relaxed_timeout().
+
+	  Say N if you are unsure.
+
 config BACKTRACE_SELF_TEST
 	tristate "Self test for the backtrace code"
 	depends on DEBUG_KERNEL
diff --git a/lib/tests/barrier-timeout-test.c a/lib/tests/barrier-timeout-test.c
new file mode 100644
--- /dev/null
+++ a/lib/tests/barrier-timeout-test.c
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests exercising smp_cond_load_relaxed_timeout().
+ *
+ * Copyright (c) 2026, Oracle Corp.
+ * Author: Ankur Arora <ankur.a.arora@oracle.com>
+ */
+
+#include <linux/bitops.h>
+#include <linux/types.h>
+#include <linux/sched/clock.h>
+#include <linux/delay.h>
+#include <linux/kthread.h>
+#include <asm/barrier.h>
+#include <kunit/test.h>
+#include <kunit/visibility.h>
+
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
+
+struct clock_state {
+	s64 start_time;
+	s64 end_time;
+};
+
+#define TIMEOUT_MSEC	2
+#define TEST_FLAG_VAL	BIT(2)
+static unsigned int flag;
+
+static s64 basic_clock(struct clock_state *clk)
+{
+	clk->end_time = local_clock();
+	return clk->end_time;
+}
+
+static void update_flags(void)
+{
+	WRITE_ONCE(flag, TEST_FLAG_VAL);
+}
+
+static s64 mock_clock(struct clock_state *clk)
+{
+	s64 clk_mid = clk->start_time + (TIMEOUT_MSEC * NSEC_PER_MSEC)/2;
+
+	clk->end_time = local_clock();
+	if (clk->end_time >= clk_mid)
+		update_flags();
+	return clk->end_time;
+}
+
+typedef s64 (*clkfn_t)(struct clock_state *);
+
+static void test_smp_cond_relaxed_timeout(struct kunit *test,
+					  clkfn_t clock, bool succeeds)
+{
+	struct clock_state clk = {
+		.start_time = local_clock(),
+		.end_time = local_clock(),
+	};
+	s64 runtime, timeout_ns = TIMEOUT_MSEC * NSEC_PER_MSEC;
+	unsigned int result;
+
+	result = smp_cond_load_relaxed_timeout(&flag,
+					       (VAL & TEST_FLAG_VAL),
+					       clock(&clk),
+					       timeout_ns);
+
+	runtime = clk.end_time - clk.start_time;
+	KUNIT_EXPECT_EQ(test, (bool)(result & TEST_FLAG_VAL), succeeds);
+	KUNIT_EXPECT_EQ(test, runtime <= timeout_ns, succeeds);
+}
+
+static int smp_cond_threadfn(void *data)
+{
+	udelay(TIMEOUT_MSEC * USEC_PER_MSEC / 4);
+
+	/*
+	 * Update flags after a delay to give smp_cond_relaxed_timeout()
+	 * time to get started.
+	 */
+	update_flags();
+	return 0;
+}
+
+static void smp_cond_relaxed_timeout_succeeds(struct kunit *test)
+{
+	struct task_struct *task;
+
+	flag = 0;
+
+	task = kthread_run(smp_cond_threadfn, &flag, "smp_cond_thread");
+
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, task);
+	test_smp_cond_relaxed_timeout(test, &basic_clock, true);
+
+	kthread_stop(task);
+}
+
+static void smp_cond_relaxed_timeout_mocked(struct kunit *test)
+{
+	flag = 0;
+	test_smp_cond_relaxed_timeout(test, &mock_clock, true);
+}
+
+static void smp_cond_relaxed_timeout_expires(struct kunit *test)
+{
+	flag = 0;
+	test_smp_cond_relaxed_timeout(test, &basic_clock, false);
+}
+
+static struct kunit_case barrier_timeout_test_cases[] = {
+	KUNIT_CASE(smp_cond_relaxed_timeout_mocked),
+	KUNIT_CASE(smp_cond_relaxed_timeout_succeeds),
+	KUNIT_CASE(smp_cond_relaxed_timeout_expires),
+	{}
+};
+
+static struct kunit_suite barrier_timeout_test_suite = {
+	.name = "smp-cond-load-relaxed-timeout",
+	.test_cases = barrier_timeout_test_cases,
+};
+
+kunit_test_suite(barrier_timeout_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests for smp_cond_load_relaxed_timeout()");
+MODULE_LICENSE("GPL");
--- a/lib/tests/Makefile~kunit-add-tests-for-smp_cond_load_relaxed_timeout
+++ a/lib/tests/Makefile
@@ -20,6 +20,7 @@ CFLAGS_fortify_kunit.o += $(DISABLE_STRU
 obj-$(CONFIG_FORTIFY_KUNIT_TEST) += fortify_kunit.o
 CFLAGS_test_fprobe.o += $(CC_FLAGS_FTRACE)
 obj-$(CONFIG_FPROBE_SANITY_TEST) += test_fprobe.o
+obj-$(CONFIG_BARRIER_TIMEOUT_TEST) += barrier-timeout-test.o
 obj-$(CONFIG_GLOB_KUNIT_TEST) += glob_kunit.o
 obj-$(CONFIG_HASHTABLE_KUNIT_TEST) += hashtable_test.o
 obj-$(CONFIG_HASH_KUNIT_TEST) += test_hash.o
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are


