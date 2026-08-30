Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A352818FC80
	for <mm-commits@vger.kernel.org>; Sun, 30 Aug 2026 02:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788058197; cv=none; b=avLNuKh1GwkpxeK/xd28YNL7DkAwGulIENAFtj6lVtdCLsu13FZr8wANgJBMfVDeBlZHAvnDYVNgR/a7p61mhgw1O1bnTG+6aV0Ou1mSUad8xdQMqbV8/5JMoSjxfmK9E2PAkr99pQ+CMjiqvOzsSsrKVsWTbszZ8ryD0bcqPK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788058197; c=relaxed/simple;
	bh=Aj+6GZHra42ibnt6j/IK6NqATRNqNoupdS5KkAT+D2A=;
	h=Date:To:From:Subject:Message-Id; b=ex4DH1BRJhjOccb8MzMGeVnpJiQYLMP3yKK5jijTCDpAh5OOO8qt4+EdEg/2OFEKH8q9B5PNPEt3knn9P3CdNm3Lejp8FYfq1KTGhUhFAEOQPKmjv1fzPOOg2D4sYlc/mL0z0UM059jqg/CBDHqGcOXRTP6x+RLi7E8WHvSGLHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u9jNxnj4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u9jNxnj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CAF1F000E9;
	Sun, 30 Aug 2026 02:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788058195;
	bh=8MjqQrWl1LUYypjW301mrJZgxJcF65jAgoV3oyciIao=;
	h=Date:To:From:Subject;
	b=u9jNxnj4hOdpuVEU0jiinAuvaOTlG/pm2WUgcnBg0NnO2GHYWs5CS80q8cR51KTPl
	 zunUKaosXGJGGfks5qd8EZjizeUpcfxYD5uR1ChcRF0B9S06eoVLO6g5g2VsXiEity
	 BShUVl5r8Ij09+0QkgFYGd7BeWMXkczYYniN7t98=
Date: Sat, 29 Aug 2026 19:49:54 -0700
To: mm-commits@vger.kernel.org,jlayton@kernel.org,david@davidgow.net,maarseveent@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-tests-add-kunit-tests-for-errseq.patch added to mm-nonmm-unstable branch
Message-Id: <20260830024955.13CAF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/tests: add KUnit tests for errseq
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-tests-add-kunit-tests-for-errseq.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-tests-add-kunit-tests-for-errseq.patch

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
From: Thomas Maarseveen <maarseveent@gmail.com>
Subject: lib/tests: add KUnit tests for errseq
Date: Wed, 12 Aug 2026 20:55:33 +0200

The errseq_t infrastructure (lib/errseq.c) underpins writeback error
reporting but has no regression tests.  Its semantics are subtle enough to
have needed fixing before: commit b4678df184b3 ("errseq: Always report a
writeback error once") changed how unseen errors reach new samplers.

Add a KUnit suite covering the documented single-threaded semantics:

 - a zeroed errseq_t is the "no error yet" epoch
 - errors are recorded, overwrite one another, and both ends of the
   valid errno range round-trip exactly
 - an error nobody has seen samples as zero, so a check against a
   fresh sample still reports it
 - errseq_check_and_advance() reports a given error exactly once per
   cursor and leaves the cursor in place when nothing has changed
 - once an error has been seen, a fresh sample is current and a check
   against it reports nothing
 - the same error recorded again after being seen is reported again,
   even to a cursor that consumed the first occurrence while another
   cursor marked the repeat as seen
 - independent cursors each observe each error

The lockless behaviour of errseq_t under concurrent updates and the WARN
path for invalid error values are deliberately out of scope.

Tested with ./tools/testing/kunit/kunit.py run, with a kunitconfig
enabling CONFIG_KUNIT=y and CONFIG_ERRSEQ_KUNIT_TEST=y; all 13 tests pass
under ARCH=um.

Link: https://lore.kernel.org/20260812-errseq-kunit-v1-1-312be4c3aa0d@gmail.com
Signed-off-by: Thomas Maarseveen <maarseveent@gmail.com>
Acked-by: Jeff Layton <jlayton@kernel.org>
Cc: David Gow <david@davidgow.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS              |    1 
 lib/Kconfig.debug        |   15 ++
 lib/tests/Makefile       |    1 
 lib/tests/errseq_kunit.c |  237 +++++++++++++++++++++++++++++++++++++
 4 files changed, 254 insertions(+)

--- a/lib/Kconfig.debug~lib-tests-add-kunit-tests-for-errseq
+++ a/lib/Kconfig.debug
@@ -2797,6 +2797,21 @@ config SYSCTL_KUNIT_TEST
 
 	  If unsure, say N.
 
+config ERRSEQ_KUNIT_TEST
+	tristate "KUnit test for errseq" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  This builds the errseq KUnit test suite.
+	  It tests the documented semantics of the errseq_t error-tracking
+	  infrastructure (lib/errseq.c), which underpins writeback error
+	  reporting.
+
+	  For more information on KUnit and unit tests in general please refer
+	  to the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  If unsure, say N.
+
 config KFIFO_KUNIT_TEST
 	tristate "KUnit Test for the generic kernel FIFO implementation" if !KUNIT_ALL_TESTS
 	depends on KUNIT
diff --git a/lib/tests/errseq_kunit.c a/lib/tests/errseq_kunit.c
new file mode 100644
--- /dev/null
+++ a/lib/tests/errseq_kunit.c
@@ -0,0 +1,237 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for the errseq_t error-tracking infrastructure.
+ *
+ * These exercise the documented single-threaded semantics of the errseq
+ * API (see Documentation/core-api/errseq.rst and lib/errseq.c): error
+ * recording and overwriting, the "seen" handoff between errseq_sample()
+ * and errseq_check_and_advance(), and the re-reporting of an error that
+ * is recorded again after it has been seen.
+ *
+ * The lockless properties of errseq_t under concurrent updates are
+ * outside the scope of these deterministic tests, as is the WARN path
+ * for invalid error values.
+ */
+#include <kunit/test.h>
+
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/errseq.h>
+
+/*
+ * A zeroed errseq_t is the "no error has ever occurred" epoch: it
+ * samples as zero and no check against it reports anything.
+ */
+static void errseq_test_zero_epoch_reports_no_error(struct kunit *test)
+{
+	errseq_t eseq = 0;
+	errseq_t since = 0;
+
+	KUNIT_EXPECT_EQ(test, errseq_sample(&eseq), 0);
+	KUNIT_EXPECT_EQ(test, errseq_check(&eseq, 0), 0);
+	KUNIT_EXPECT_EQ(test, errseq_check_and_advance(&eseq, &since), 0);
+	KUNIT_EXPECT_EQ(test, since, 0);
+}
+
+static void errseq_test_set_records_error(struct kunit *test)
+{
+	errseq_t eseq = 0;
+
+	/* errseq_set() returns the previous value; the epoch is zero. */
+	KUNIT_EXPECT_EQ(test, errseq_set(&eseq, -EIO), 0);
+	KUNIT_EXPECT_EQ(test, errseq_check(&eseq, 0), -EIO);
+}
+
+/* Any error set always overwrites an existing error. */
+static void errseq_test_set_overwrites_error(struct kunit *test)
+{
+	errseq_t eseq = 0;
+
+	errseq_set(&eseq, -EIO);
+	errseq_set(&eseq, -ENOSPC);
+	KUNIT_EXPECT_EQ(test, errseq_check(&eseq, 0), -ENOSPC);
+}
+
+/* Both ends of the valid error range are recorded exactly. */
+static void errseq_test_errno_range_extremes(struct kunit *test)
+{
+	errseq_t lo = 0;
+	errseq_t hi = 0;
+
+	errseq_set(&lo, -1);
+	KUNIT_EXPECT_EQ(test, errseq_check(&lo, 0), -1);
+
+	errseq_set(&hi, -MAX_ERRNO);
+	KUNIT_EXPECT_EQ(test, errseq_check(&hi, 0), -MAX_ERRNO);
+}
+
+/*
+ * An error nobody has seen yet samples as zero, so that a check against
+ * the sample still reports it (see commit b4678df184b3 ("errseq: Always
+ * report a writeback error once")).
+ */
+static void errseq_test_sample_of_unseen_error_is_zero(struct kunit *test)
+{
+	errseq_t eseq = 0;
+
+	errseq_set(&eseq, -EIO);
+	KUNIT_EXPECT_EQ(test, errseq_sample(&eseq), 0);
+}
+
+static void errseq_test_new_sampler_sees_unseen_error(struct kunit *test)
+{
+	errseq_t eseq = 0;
+	errseq_t since;
+
+	errseq_set(&eseq, -EIO);
+	since = errseq_sample(&eseq);
+	KUNIT_EXPECT_EQ(test, errseq_check(&eseq, since), -EIO);
+}
+
+/* A given error is reported exactly once per advancing cursor. */
+static void errseq_test_check_and_advance_reports_once(struct kunit *test)
+{
+	errseq_t eseq = 0;
+	errseq_t since = errseq_sample(&eseq);
+
+	errseq_set(&eseq, -EIO);
+	KUNIT_EXPECT_EQ(test, errseq_check_and_advance(&eseq, &since), -EIO);
+	KUNIT_EXPECT_EQ(test, errseq_check_and_advance(&eseq, &since), 0);
+}
+
+/*
+ * Once an error has been seen, a fresh sample is non-zero and checking
+ * against it reports nothing: handled errors do not reach new samplers.
+ */
+static void errseq_test_sample_after_seen_is_current(struct kunit *test)
+{
+	errseq_t eseq = 0;
+	errseq_t since = 0;
+	errseq_t sample;
+
+	errseq_set(&eseq, -EIO);
+	KUNIT_EXPECT_EQ(test, errseq_check_and_advance(&eseq, &since), -EIO);
+
+	sample = errseq_sample(&eseq);
+	KUNIT_EXPECT_NE(test, sample, 0);
+	KUNIT_EXPECT_EQ(test, errseq_check(&eseq, sample), 0);
+}
+
+static void errseq_test_new_error_after_advance(struct kunit *test)
+{
+	errseq_t eseq = 0;
+	errseq_t since = 0;
+
+	errseq_set(&eseq, -EIO);
+	KUNIT_EXPECT_EQ(test, errseq_check_and_advance(&eseq, &since), -EIO);
+
+	errseq_set(&eseq, -ENOSPC);
+	KUNIT_EXPECT_EQ(test, errseq_check_and_advance(&eseq, &since), -ENOSPC);
+	KUNIT_EXPECT_EQ(test, errseq_check_and_advance(&eseq, &since), 0);
+}
+
+/*
+ * Recording the same error again after it has been seen must bump the
+ * sequence, so cursors that consumed the first occurrence see the
+ * second one too.
+ */
+static void errseq_test_same_error_reported_again_after_seen(struct kunit *test)
+{
+	errseq_t eseq = 0;
+	errseq_t since = 0;
+	errseq_t seen_cursor;
+
+	errseq_set(&eseq, -EIO);
+	KUNIT_EXPECT_EQ(test, errseq_check_and_advance(&eseq, &since), -EIO);
+
+	seen_cursor = since;
+	errseq_set(&eseq, -EIO);
+	KUNIT_EXPECT_EQ(test, errseq_check(&eseq, since), -EIO);
+	KUNIT_EXPECT_EQ(test, errseq_check_and_advance(&eseq, &since), -EIO);
+	/* The repeat must advance the sequence, not just re-toggle "seen". */
+	KUNIT_EXPECT_NE(test, since, seen_cursor);
+}
+
+/*
+ * A cursor that consumed an error must still observe a repeat of that
+ * error even when another cursor has already marked the repeat seen:
+ * recording over a seen value must advance the sequence.
+ */
+static void errseq_test_repeat_error_visible_to_all_cursors(struct kunit *test)
+{
+	errseq_t eseq = 0;
+	errseq_t cursor_a = 0;
+	errseq_t cursor_b = 0;
+
+	errseq_set(&eseq, -EIO);
+	KUNIT_EXPECT_EQ(test, errseq_check_and_advance(&eseq, &cursor_a), -EIO);
+
+	errseq_set(&eseq, -EIO);
+	KUNIT_EXPECT_EQ(test, errseq_check_and_advance(&eseq, &cursor_b), -EIO);
+
+	KUNIT_EXPECT_EQ(test, errseq_check(&eseq, cursor_a), -EIO);
+	KUNIT_EXPECT_EQ(test, errseq_check_and_advance(&eseq, &cursor_a), -EIO);
+	KUNIT_EXPECT_EQ(test, errseq_check_and_advance(&eseq, &cursor_a), 0);
+}
+
+/* An advance with no new error reports nothing and leaves the cursor put. */
+static void errseq_test_advance_stable_when_unchanged(struct kunit *test)
+{
+	errseq_t eseq = 0;
+	errseq_t since = 0;
+	errseq_t cursor;
+
+	errseq_set(&eseq, -EIO);
+	KUNIT_EXPECT_EQ(test, errseq_check_and_advance(&eseq, &since), -EIO);
+
+	cursor = since;
+	KUNIT_EXPECT_EQ(test, errseq_check_and_advance(&eseq, &since), 0);
+	KUNIT_EXPECT_EQ(test, since, cursor);
+}
+
+/*
+ * Cursors are independent: one subscriber consuming an error does not
+ * consume it for another, and each subscriber sees each error once.
+ */
+static void errseq_test_two_subscribers_independent(struct kunit *test)
+{
+	errseq_t eseq = 0;
+	errseq_t cursor_a = errseq_sample(&eseq);
+	errseq_t cursor_b = errseq_sample(&eseq);
+
+	errseq_set(&eseq, -EIO);
+
+	KUNIT_EXPECT_EQ(test, errseq_check_and_advance(&eseq, &cursor_a), -EIO);
+	KUNIT_EXPECT_EQ(test, errseq_check(&eseq, cursor_b), -EIO);
+	KUNIT_EXPECT_EQ(test, errseq_check_and_advance(&eseq, &cursor_b), -EIO);
+
+	KUNIT_EXPECT_EQ(test, errseq_check_and_advance(&eseq, &cursor_a), 0);
+	KUNIT_EXPECT_EQ(test, errseq_check_and_advance(&eseq, &cursor_b), 0);
+}
+
+static struct kunit_case errseq_test_cases[] = {
+	KUNIT_CASE(errseq_test_zero_epoch_reports_no_error),
+	KUNIT_CASE(errseq_test_set_records_error),
+	KUNIT_CASE(errseq_test_set_overwrites_error),
+	KUNIT_CASE(errseq_test_errno_range_extremes),
+	KUNIT_CASE(errseq_test_sample_of_unseen_error_is_zero),
+	KUNIT_CASE(errseq_test_new_sampler_sees_unseen_error),
+	KUNIT_CASE(errseq_test_check_and_advance_reports_once),
+	KUNIT_CASE(errseq_test_sample_after_seen_is_current),
+	KUNIT_CASE(errseq_test_new_error_after_advance),
+	KUNIT_CASE(errseq_test_same_error_reported_again_after_seen),
+	KUNIT_CASE(errseq_test_repeat_error_visible_to_all_cursors),
+	KUNIT_CASE(errseq_test_advance_stable_when_unchanged),
+	KUNIT_CASE(errseq_test_two_subscribers_independent),
+	{}
+};
+
+static struct kunit_suite errseq_test_suite = {
+	.name = "errseq",
+	.test_cases = errseq_test_cases,
+};
+
+kunit_test_suite(errseq_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests for the errseq infrastructure");
+MODULE_LICENSE("GPL");
--- a/lib/tests/Makefile~lib-tests-add-kunit-tests-for-errseq
+++ a/lib/tests/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_BLACKHOLE_DEV_KUNIT_TEST) +
 obj-$(CONFIG_CHECKSUM_KUNIT) += checksum_kunit.o
 obj-$(CONFIG_CMDLINE_KUNIT_TEST) += cmdline_kunit.o
 obj-$(CONFIG_CPUMASK_KUNIT_TEST) += cpumask_kunit.o
+obj-$(CONFIG_ERRSEQ_KUNIT_TEST) += errseq_kunit.o
 obj-$(CONFIG_FFS_KUNIT_TEST) += ffs_kunit.o
 CFLAGS_fortify_kunit.o += $(call cc-disable-warning, unsequenced)
 CFLAGS_fortify_kunit.o += $(call cc-disable-warning, stringop-overread)
--- a/MAINTAINERS~lib-tests-add-kunit-tests-for-errseq
+++ a/MAINTAINERS
@@ -9701,6 +9701,7 @@ M:	Jeff Layton <jlayton@kernel.org>
 S:	Maintained
 F:	include/linux/errseq.h
 F:	lib/errseq.c
+F:	lib/tests/errseq_kunit.c
 
 ESD CAN NETWORK DRIVERS
 M:	Stefan Mätje <stefan.maetje@esd.eu>
_

Patches currently in -mm which might be from maarseveent@gmail.com are

lib-tests-add-kunit-tests-for-errseq.patch

