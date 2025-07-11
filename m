Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D19611E
	for <mm-commits@vger.kernel.org>; Fri, 11 Jul 2025 05:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752210877; cv=none; b=In8f3lytlE7F0qQ6q9C2nuMcvLwKCIcpOp8/2xQTDbf/QbotKRECdI+xabuIK8c7L4ixaWezQ6q+5eDFkAr6WiEB1aGY+H5rSLpzpBlzdj8wyiBiEryBT2YOEzP387hJSiPl1JvX0dVMfvlwMSXZ+inTxvgaJ7E6mLL88urtuFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752210877; c=relaxed/simple;
	bh=xwIz5sxGQlksCrujdDElHWdjRWYLt7Sy5+9vuEU3lfY=;
	h=Date:To:From:Subject:Message-Id; b=JSgJjFpYkCFvcrL84ICacXTOb4LAAIYH0TvmKWZChbvop3/6cJMcMWfr0Pv6xPKbtY1nzvDve1XHxLdGgUICpwmVNnOJCPLno77AAhfdkaVEMWdo0ANBJrfkNV8RRlv5v6oUkjCcqCj95SIQxbRpVxjZ7+HJoM083PG7uBNh+VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LICJKXY2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LICJKXY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249FCC4CEEF;
	Fri, 11 Jul 2025 05:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752210877;
	bh=xwIz5sxGQlksCrujdDElHWdjRWYLt7Sy5+9vuEU3lfY=;
	h=Date:To:From:Subject:From;
	b=LICJKXY2ui4AhYbPu8HGRkgXtqRoqjDImJmWZ2C2885vjgT+Mn9NXfm0/+BQMVH/7
	 OYnHVbTTJfgMfcyIfVK+2/TZMHsvxo9BYXTrqVFqDh66LFgef5pOlFmMNRcrYtRdHI
	 leE6U1VINndlr98+ezcD6v8LjYMKz9h9vdF1v8Xo=
Date: Thu, 10 Jul 2025 22:14:36 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,rostedt@goodmis.org,pmladek@suse.com,pandoh@google.com,mjguzik@gmail.com,kuniyu@amazon.com,karolina.stolarek@oracle.com,john.ogness@linutronix.de,bhelgaas@google.com,paulmck@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] lib-add-stress-test-for-ratelimit.patch removed from -mm tree
Message-Id: <20250711051437.249FCC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: add stress test for ratelimit
has been removed from the -mm tree.  Its filename was
     lib-add-stress-test-for-ratelimit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Paul E. McKenney" <paulmck@kernel.org>
Subject: lib: add stress test for ratelimit
Date: Wed, 9 Jul 2025 11:03:35 -0700

Add a simple stress test for lib/ratelimit.c

To run on x86:

	./tools/testing/kunit/kunit.py run --arch x86_64 --kconfig_add CONFIG_RATELIMIT_KUNIT_TEST=y --kconfig_add CONFIG_SMP=y --qemu_args "-smp 4" lib_ratelimit

On a 16-CPU system, the "4" in "-smp 4" can be varied between 1 and 8. 
Larger numbers have higher probabilities of introducing delays that break
the smoke test.  In the extreme case, increasing the number to larger than
the number of CPUs in the underlying system is an excellent way to get a
test failure.

Link: https://lore.kernel.org/all/fbe93a52-365e-47fe-93a4-44a44547d601@paulmck-laptop/
Link: https://lore.kernel.org/all/20250423115409.3425-1-spasswolf@web.de/
Link: https://lkml.kernel.org/r/20250709180335.1716384-3-paulmck@kernel.org
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
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

 lib/tests/test_ratelimit.c |   69 +++++++++++++++++++++++++++++++++--
 1 file changed, 67 insertions(+), 2 deletions(-)

--- a/lib/tests/test_ratelimit.c~lib-add-stress-test-for-ratelimit
+++ a/lib/tests/test_ratelimit.c
@@ -4,6 +4,8 @@
 
 #include <linux/ratelimit.h>
 #include <linux/module.h>
+#include <linux/kthread.h>
+#include <linux/cpumask.h>
 
 /* a simple boot-time regression test */
 
@@ -63,14 +65,77 @@ static void test_ratelimit_smoke(struct
 	test_ratelimited(test, false);
 }
 
-static struct kunit_case sort_test_cases[] = {
+static struct ratelimit_state stressrl = RATELIMIT_STATE_INIT_FLAGS("stressrl", HZ / 10, 3,
+								    RATELIMIT_MSG_ON_RELEASE);
+
+static int doneflag;
+static const int stress_duration = 2 * HZ;
+
+struct stress_kthread {
+	unsigned long nattempts;
+	unsigned long nunlimited;
+	unsigned long nlimited;
+	unsigned long nmissed;
+	struct task_struct *tp;
+};
+
+static int test_ratelimit_stress_child(void *arg)
+{
+	struct stress_kthread *sktp = arg;
+
+	set_user_nice(current, MAX_NICE);
+	WARN_ON_ONCE(!sktp->tp);
+
+	while (!READ_ONCE(doneflag)) {
+		sktp->nattempts++;
+		if (___ratelimit(&stressrl, __func__))
+			sktp->nunlimited++;
+		else
+			sktp->nlimited++;
+		cond_resched();
+	}
+
+	sktp->nmissed = ratelimit_state_reset_miss(&stressrl);
+	return 0;
+}
+
+static void test_ratelimit_stress(struct kunit *test)
+{
+	int i;
+	const int n_stress_kthread = cpumask_weight(cpu_online_mask);
+	struct stress_kthread skt = { 0 };
+	struct stress_kthread *sktp = kcalloc(n_stress_kthread, sizeof(*sktp), GFP_KERNEL);
+
+	KUNIT_EXPECT_NOT_NULL_MSG(test, sktp, "Memory allocation failure");
+	for (i = 0; i < n_stress_kthread; i++) {
+		sktp[i].tp = kthread_run(test_ratelimit_stress_child, &sktp[i], "%s/%i",
+					 "test_ratelimit_stress_child", i);
+		KUNIT_EXPECT_NOT_NULL_MSG(test, sktp, "kthread creation failure");
+		pr_alert("Spawned test_ratelimit_stress_child %d\n", i);
+	}
+	schedule_timeout_idle(stress_duration);
+	WRITE_ONCE(doneflag, 1);
+	for (i = 0; i < n_stress_kthread; i++) {
+		kthread_stop(sktp[i].tp);
+		skt.nattempts += sktp[i].nattempts;
+		skt.nunlimited += sktp[i].nunlimited;
+		skt.nlimited += sktp[i].nlimited;
+		skt.nmissed += sktp[i].nmissed;
+	}
+	KUNIT_ASSERT_EQ_MSG(test, skt.nunlimited + skt.nlimited, skt.nattempts,
+			    "Outcomes not equal to attempts");
+	KUNIT_ASSERT_EQ_MSG(test, skt.nlimited, skt.nmissed, "Misses not equal to limits");
+}
+
+static struct kunit_case ratelimit_test_cases[] = {
 	KUNIT_CASE_SLOW(test_ratelimit_smoke),
+	KUNIT_CASE_SLOW(test_ratelimit_stress),
 	{}
 };
 
 static struct kunit_suite ratelimit_test_suite = {
 	.name = "lib_ratelimit",
-	.test_cases = sort_test_cases,
+	.test_cases = ratelimit_test_cases,
 };
 
 kunit_test_suites(&ratelimit_test_suite);
_

Patches currently in -mm which might be from paulmck@kernel.org are


