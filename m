Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025252;
	b=HwDNnDtBHQot53r6X00/dSd7i9sI1/MtMV+lL/7LtQtKtCdunUffnmJ3yL8ZMRlQWGQ1
	 nrXeIO1r1fDL+Shu8VSJ7kCUFCMma1W3JqrLJzMCUIaK6wKVFYK9cLOUbGvUp9kFGyUNy
	 jRPD/jpaO8Gv/lewLPyzgpUA9HTvoRixqxqHi5h9J38B6SeflGfn/AFL+gZiqEr7ikMqG
	 ovIvCz6GNE7DlbY65/gkahKf+FACg9qJADgBRHL0bmLmSBI/KZd1xgHUSVQtAuQjjM41A
	 nR/um3Rrx0H5b/OrVspHYkN0kWDrxShq3HA8ARweaw8s7G6tP4DEjzfRWpdMF/L7rLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025252;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=VD+ut8dPLoy2taxEsINR4Mz0kgfPq660Tps5KUKNm0o=;
	b=k0rZRcFKmwFFD9NH48f9iHB1sTfurNJ4A+/T4hldbrsCyJGX+qP6fORP8ChS2CBHFBkj
	 YSOmbYYwokqvPzMl3faZdcaoVA3jAab27LnEKgEmgsbb+XzjayDEGM3HcMnx8OgvBudG7
	 jhe1rMQP+Q1TAydZkcAt7sFR19DbAZodrOnlRqv5dL1oTS176o4yt3niumZ9sxbt2FOIK
	 U0ygDKYeYM08WLKrYHYvBJSDcFrGHtOw2K/puZrLlFBhuJqMWmF7GxY75W5av2+q3W5+5
	 bkGmvhx0L53k39bTuGssbPFcqOeqEbFGrW204/wjBKjyVcyVb3lorHd4uRnzBk1yWeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fmX+i0TE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F09D606A320
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 18:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fmX+i0TE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83DE1F000C5;
	Wed, 18 Nov 2026 18:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795025251;
	bh=VD+ut8dPLoy2taxEsINR4Mz0kgfPq660Tps5KUKNm0o=;
	h=Date:To:From:Subject;
	b=fmX+i0TEl/rr3+tFZpfhOUG02YY9RPdRn/33UamMQA/a1oIlJUNYrzNM8JPqDoZNb
	 4w9/XTeNyegoTJH6zPVk1GE7xmaUhXQ5y/2Nol7sIsA/OiARCPyOTdLY6xlqalVfMI
	 iko0Jt15SVSzY5dHeYyPA83oQOfYj9jVFlUlquo8=
Date: Wed, 18 Nov 2026 10:07:31 -0800
To: mm-commits@vger.kernel.org,neil@brown.name,maarseveent@gmail.com,
	jlayton@kernel.org,jack@suse.cz,brauner@kernel.org,jain.sm@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] lib-tests-errseq-add-a-concurrent-check_and_advance-test.patch removed from -mm tree
Message-Id: <20261118180731.B83DE1F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: lib/tests: errseq: add a concurrent check_and_advance test
has been removed from the -mm tree.  Its filename was
     lib-tests-errseq-add-a-concurrent-check_and_advance-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shashank Mohan Jain <jain.sm@gmail.com>
Subject: lib/tests: errseq: add a concurrent check_and_advance test
Date: Sun, 27 Sep 2026 10:47:26 +0530

Add a test case that races errseq_check_and_advance() on one CPU against
errseq_set() of a different error on another CPU, then records the first
error again and lets a second cursor consume it.  The second -EIO is
recorded after the first cursor's check returned, so that cursor's next
check must report an error, whichever way the race with -ENOSPC went.

Without the previous commit 1-6% of 2 million rounds lose the error on UML
with 4 CPUs (seccomp=on ncpus=4); with it none do.  The case is skipped on
a single CPU and stops after 5 seconds.

Link: https://lore.kernel.org/20260927051726.71337-3-jain.sm@gmail.com
Signed-off-by: Shashank Mohan Jain <jain.sm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: NeilBrown <neil@brown.name>
Cc: Thomas Maarseveen <maarseveent@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>

 lib/tests/errseq_kunit.c |  110 +++++++++++++++++++++++++++++++++++--
 1 file changed, 105 insertions(+), 5 deletions(-)

--- a/lib/tests/errseq_kunit.c~lib-tests-errseq-add-a-concurrent-check_and_advance-test
+++ a/lib/tests/errseq_kunit.c
@@ -2,21 +2,26 @@
 /*
  * KUnit tests for the errseq_t error-tracking infrastructure.
  *
- * These exercise the documented single-threaded semantics of the errseq
- * API (see Documentation/core-api/errseq.rst and lib/errseq.c): error
+ * Most cases exercise the documented single-threaded semantics of the
+ * errseq API (see Documentation/core-api/errseq.rst and lib/errseq.c): error
  * recording and overwriting, the "seen" handoff between errseq_sample()
  * and errseq_check_and_advance(), and the re-reporting of an error that
  * is recorded again after it has been seen.
  *
- * The lockless properties of errseq_t under concurrent updates are
- * outside the scope of these deterministic tests, as is the WARN path
- * for invalid error values.
+ * The WARN path for invalid error values is not tested.  The last case
+ * races errseq_set() against errseq_check_and_advance() on another CPU.
  */
 #include <kunit/test.h>
 
+#include <linux/atomic.h>
+#include <linux/cpumask.h>
 #include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/errseq.h>
+#include <linux/jiffies.h>
+#include <linux/kthread.h>
+#include <linux/random.h>
+#include <linux/sched.h>
 
 /*
  * A zeroed errseq_t is the "no error has ever occurred" epoch: it
@@ -209,6 +214,100 @@ static void errseq_test_two_subscribers_
 	KUNIT_EXPECT_EQ(test, errseq_check_and_advance(&eseq, &cursor_b), 0);
 }
 
+/*
+ * errseq_check_and_advance() racing with errseq_set() on another CPU.
+ *
+ * Each round, cursor @f checks an unseen -EIO while another CPU records
+ * -ENOSPC.  Afterwards -EIO is recorded again and cursor @g checks.  The
+ * second -EIO is recorded after @f's check returned, so @f's next check
+ * must report an error, whichever way the race with -ENOSPC went.
+ */
+struct errseq_race {
+	errseq_t eseq;
+	atomic_t go;		/* round the writer should run */
+	atomic_t done;		/* last round the writer completed */
+	unsigned int wdelay;
+};
+
+static void errseq_race_spin(unsigned int n)
+{
+	while (n--)
+		cpu_relax();
+}
+
+static int errseq_race_writer(void *data)
+{
+	struct errseq_race *r = data;
+	int seen = 0;
+
+	while (!kthread_should_stop()) {
+		int round = atomic_read_acquire(&r->go);
+
+		if (round == seen) {
+			cond_resched();
+			continue;
+		}
+		seen = round;
+		errseq_race_spin(READ_ONCE(r->wdelay));
+		errseq_set(&r->eseq, -ENOSPC);
+		atomic_set_release(&r->done, round);
+	}
+	return 0;
+}
+
+#define ERRSEQ_RACE_ROUNDS	2000000
+#define ERRSEQ_RACE_SECONDS	5
+
+static void errseq_test_check_and_advance_race(struct kunit *test)
+{
+	struct errseq_race *r;
+	struct task_struct *writer;
+	unsigned long deadline;
+	int round, unreported = 0, missed = 0;
+
+	if (num_online_cpus() < 2)
+		kunit_skip(test, "needs at least two CPUs");
+
+	r = kunit_kzalloc(test, sizeof(*r), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, r);
+
+	writer = kthread_run(errseq_race_writer, r, "errseq_race");
+	KUNIT_ASSERT_FALSE(test, IS_ERR(writer));
+
+	deadline = jiffies + ERRSEQ_RACE_SECONDS * HZ;
+	for (round = 1; round <= ERRSEQ_RACE_ROUNDS; round++) {
+		errseq_t f = 0, g = 0;
+
+		WRITE_ONCE(r->eseq, 0);
+		errseq_set(&r->eseq, -EIO);
+		WRITE_ONCE(r->wdelay, get_random_u32_below(64));
+		atomic_set_release(&r->go, round);
+
+		errseq_race_spin(get_random_u32_below(64));
+		if (!errseq_check_and_advance(&r->eseq, &f))
+			unreported++;
+
+		while (atomic_read_acquire(&r->done) != round)
+			cond_resched();
+
+		/* Recorded after f's check returned: f must hear about it. */
+		errseq_set(&r->eseq, -EIO);
+		errseq_check_and_advance(&r->eseq, &g);
+		if (!errseq_check_and_advance(&r->eseq, &f))
+			missed++;
+
+		if (time_after(jiffies, deadline))
+			break;
+		if (!(round & 1023))
+			cond_resched();
+	}
+	kthread_stop(writer);
+
+	kunit_info(test, "%d rounds, %d missed errors\n", round - 1, missed);
+	KUNIT_EXPECT_EQ(test, unreported, 0);
+	KUNIT_EXPECT_EQ(test, missed, 0);
+}
+
 static struct kunit_case errseq_test_cases[] = {
 	KUNIT_CASE(errseq_test_zero_epoch_reports_no_error),
 	KUNIT_CASE(errseq_test_set_records_error),
@@ -223,6 +322,7 @@ static struct kunit_case errseq_test_cas
 	KUNIT_CASE(errseq_test_repeat_error_visible_to_all_cursors),
 	KUNIT_CASE(errseq_test_advance_stable_when_unchanged),
 	KUNIT_CASE(errseq_test_two_subscribers_independent),
+	KUNIT_CASE_SLOW(errseq_test_check_and_advance_race),
 	{}
 };
 
_

Patches currently in -mm which might be from jain.sm@gmail.com are


