Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C4F2B9BA
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 00:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782951782; cv=none; b=WgiuI9oGooQcwDjWvmOsRjNZrzkbjyu77by1TChkQIVMVf8i163onJNuXWuRU0pOnw85HnkSpxtEl3q2JjgHXQTy9NXHQ4iDJgVm4Opp5WLpnaNK816btX5n/MDBS6PRHQ1AOOVX3SS0io+jjyVizV+2PIxNjKf+kXS9tThApUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782951782; c=relaxed/simple;
	bh=VZ4d9AqGjJ8hHFUQUDn54o/MeEhCxUb25zRUn9AikKo=;
	h=Date:To:From:Subject:Message-Id; b=h+8Mo5fyNZnKKEXfDMpd+RUXnI5YXoUqXq3BuI78N7oCRrePONXoRIPlL03b8835WzjCDG3POGjV9EYXAEFJhOt2iiTr90Whdoxt7QRSviZN9ej+JKMS6i2zizrBWp07S32Vd4UdOb5znXSeQ7XOSPLbWX59OE6fXUPfE72xCsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E9eozWXI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E9eozWXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9251F000E9;
	Thu,  2 Jul 2026 00:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782951781;
	bh=RF/d//r/pn+rRDZwU6Vj52OTJbKG/8o2FIKHqEcIwBA=;
	h=Date:To:From:Subject;
	b=E9eozWXIuxvt0QAhbfjsz8JX7hR0SZVDHTXEnIf0qN1nkh8SSA2/8uUOO4CavH5Hn
	 4Th9x3JJwZ4ej7n1ydP8tn904ugWisYM1qZnNTqBd5fKmvCNVgkRY2Rb6i7w23MCXX
	 hZjEXgKC7a4b4AkTFH+hJ5lM9H0X7F7MpUs1F2TY=
Date: Wed, 01 Jul 2026 17:23:00 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-test-damon_mvsum.patch added to mm-new branch
Message-Id: <20260702002301.3C9251F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: test damon_mvsum()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-test-damon_mvsum.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-test-damon_mvsum.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: test damon_mvsum()
Date: Mon, 29 Jun 2026 21:07:55 -0700

Add a simple unit test for damon_nr_accesses_mvsum()'s internal core
logic, damon_mvsum().  The test contains cases for just-started windows,
partially completed windows, and just-completed windows.

Link: https://lore.kernel.org/20260630040812.149729-3-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-test-damon_mvsum
+++ a/mm/damon/tests/core-kunit.h
@@ -682,6 +682,30 @@ static void damon_test_moving_sum(struct
 	}
 }
 
+static void damon_test_mvsum(struct kunit *test)
+{
+	unsigned long input_expects[] = {
+		/* current value, last value, remaining window (bp) */
+		0, 49, 10000, 49,	/* 0 + 49 * 1 */
+		3, 10, 7000, 10,	/* 3 + 10 * 0.7 */
+		3, 10, 5000, 8,		/* 3 + 10 * 0.5 */
+		32, 100, 1000, 42,	/* 32 + 100 * 0.1 */
+		42, 49, 0, 42,		/* 42 + 49 * 0 */
+	};
+
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(input_expects); i += 4) {
+		unsigned long current_nr = input_expects[i];
+		unsigned long last_nr = input_expects[i + 1];
+		unsigned long left_window_bp = input_expects[i + 2];
+		unsigned long expect = input_expects[i + 3];
+
+		KUNIT_EXPECT_EQ(test, damon_mvsum(current_nr, last_nr,
+					left_window_bp), expect);
+	}
+}
+
 static void damos_test_new_filter(struct kunit *test)
 {
 	struct damos_filter *filter;
@@ -1575,6 +1599,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_moving_sum),
+	KUNIT_CASE(damon_test_mvsum),
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_commit_quota_goal),
 	KUNIT_CASE(damos_test_commit_quota_goals),
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-fix-dir-put-orders-in-access_pattern_add_dirs.patch
mm-damon-sysfs-schemes-put-stats-for-scheme_add_dirs-internal-error.patch
mm-damon-ops-common-handle-extreme-intervals-in-damon_hot_score.patch
mm-damon-add-a-kernel-doc-comment-for-damon_ctx-probes.patch
mm-damon-add-a-kernel-doc-comment-for-damon_ctx-rnd_state.patch
maintainers-s-seongjae-sj.patch
samples-damon-wsse-handle-damon_start-failure.patch
samples-damon-prcl-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_stop-failure.patch
samples-damon-wsse-stop-and-free-damon-ctx-when-damon_call-fails.patch
samples-damon-prcl-stop-and-free-damon-ctx-when-damon_call-fails.patch
mm-damon-sysfs-kobject_del-target-normal-context-and-kdamond-dirs.patch
mm-damon-sysfs-kobject_del-region-and-target-error-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-region-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-filter-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-quota-goal-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-action-destination-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs.patch
mm-damon-sysfs-kobject_del-probe-filter-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs-in-probes_addd_dir-error-path.patch
mm-damon-sysfs-schemes-kobject_del-region-for-populate_region-error.patch
docs-mm-damon-design-update-for-damos_quota_node_eligible_mem_bp.patch
docs-abi-damon-document-probe-files.patch
mm-damon-tests-core-kunit-test-damon_rand.patch
selftests-damon-sysfssh-test-multiple-probe-dirs-creation.patch
selftests-damon-sysfssh-test-coreops_filters-directories.patch
selftests-damon-sysfssh-test-dests-dir.patch
selftests-damon-sysfssh-test-all-files-in-quota-goal-dir.patch
mm-damon-core-reduce-range-setup-in-damon_commit_target_regions.patch
mm-damon-sysfs-split-probe-setup-function-out.patch
mm-damon-sysfs-split-out-filters-setup-function.patch
mm-damon-sysfs-fix-typos-in-probe_addrm_dirs-s-attr-probe.patch
mm-damon-core-introduce-damon_nr_accesses_mvsum.patch
mm-damon-tests-core-kunit-test-damon_mvsum.patch
mm-damon-core-always-update-last_nr_accesses-for-intervals-change.patch
mm-damon-core-handle-unreset-nr_accesses-in-damon_nr_accesses_mvsum.patch
mm-damon-core-use-damon_nr_accesses_mvsum-in-__damos_valid_target.patch
mm-damon-core-use-damon_nr_accesses_mvsum-for-damos-region-tracing.patch
mm-damon-sysfs-schemes-use-damon_nr_accesses_mvsum-for-damo-regions.patch
mm-damon-core-remove-damon_warn_fix_nr_accesses_corruption.patch
mm-damon-core-remove-damon_verify_reset_aggregated.patch
mm-damon-core-remove-damon_verify_merge_regions_of.patch
mm-damon-tests-core-kunit-remove-nr_accesses_bp-setup-and-tests.patch
selftests-damon-drgn_dump_damon_status-do-not-dump-nr_accesses_bp.patch
mm-damon-core-remove-nr_accesses_bp-setups-and-updates.patch
mm-damon-core-remove-attrs-param-from-damon_update_region_access_rate.patch
mm-damon-paddr-remove-attrs-param-from-__damon_pa_check_access.patch
mm-damon-vaddr-remove-attrs-param-from-__damon_va_check_access.patch
mm-damon-core-remove-damon_moving_sum-and-its-unit-test.patch
mm-damon-core-remove-damon_region-nr_accesses_bp.patch

