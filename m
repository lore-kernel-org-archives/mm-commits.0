Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793405192;
	b=P+i8QGEPGlQKoxhJcAYC4PvdX/wkBp+Kd/tvb7WpsTx6QSJBwcxDz4GqfHW5eGb24wk1
	 YsbUQgA8gOZ0MpzHtR8ayBlfF9xsQP64PRA50VbgFNM+bIQvQUSE/dWlGXtV5leUPmYxY
	 ywZbZFZJgltyHvageXZtirEQEfx+N49OtMpGU6GaJjhGRKhjYG6ghRgtTtYoA3BFo5jE7
	 g1fNGmEK5ldgIxa9/lRtqKliSP+rjYD2IBe4v6k5KaXZlGFgHaHzy0BAfZRvv4Jh+3NIN
	 s254hHxaw2Ya1ah/sj2PX14fr75g9UTZi6KVZyyFGKvwYrgOPjoO3jDa0X7Amte1KQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793405192;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=KHdt/H0RJdVlg8GxE01UAlRp9RJfunrl2ISbvTD/Q8Y=;
	b=NgSAwcs7Y61wlKnWRTicfhQzf9Em1T+3VdNRKaPST51navCoQltrFnTDEUXZ1h5SHNV9
	 oXz8w1Wf6gA/pkqEBzmrYfdZ4+mAYHomzpSdOxKW1hrbG4BX2Stmo82A6TYC0jYB1e3BJ
	 Xh9UB6UHvgjlsTAmRVgw+8n3J8OkOj8E8gJNElb2a8o0Y5dGucOogl9hRV81DL0JNz9lb
	 Dixvn1cHaBPZPy7lZ2L/FaEjhTmOS0Q9RcIYXtuz9pDS0C/34eX/Z3JU2j9Et15iqpx0X
	 vnPLtNXwWJfoG4mWzWPok42AJiL1muPJPaGFn+bUBo3sBpDyjtGM3E3KTVsGOOupSfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gOrVsss1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250A1606A31E
	for <mm-commits@vger.kernel.org>; Sat, 31 Oct 2026 00:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gOrVsss1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFB31F000C1;
	Sat, 31 Oct 2026 00:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793405191;
	bh=KHdt/H0RJdVlg8GxE01UAlRp9RJfunrl2ISbvTD/Q8Y=;
	h=Date:To:From:Subject;
	b=gOrVsss1Cz687f8gPrUd3d5qof6Y1uFfkvyImYtpxWpKriH1o3jErRfJBl8OFzeTh
	 z35EIZlVI9rwHsqbpZ+fkNpd9KSLBWTudkj6EXmOcA7eo2Ys9PvWyUghK072A+WpUf
	 y2BGplP+CTCMBsvJackT6KeKeuDyMJ/oriOWzHio=
Date: Fri, 30 Oct 2026 17:06:31 -0700
To: mm-commits@vger.kernel.org,neil@brown.name,maarseveent@gmail.com,
	jlayton@kernel.org,jack@suse.cz,brauner@kernel.org,jain.sm@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-tests-errseq-add-a-concurrent-check_and_advance-test.patch added to mm-nonmm-unstable branch
Message-Id: <20261031000631.9EFB31F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: lib/tests: errseq: add a concurrent check_and_advance test
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-tests-errseq-add-a-concurrent-check_and_advance-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-tests-errseq-add-a-concurrent-check_and_advance-test.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
---

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

errseq-dont-let-errseq_check_and_advance-hide-later-errors.patch
lib-tests-errseq-add-a-concurrent-check_and_advance-test.patch

