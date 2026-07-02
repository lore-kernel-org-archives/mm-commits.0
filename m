Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBDD2B9BA
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 00:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782951813; cv=none; b=mePRYNn1HF2oR1wK0qhNkMk7Io0wdITv+mof3TvZJIRu0ZaoECTujL+UpmnmAOFGMouO8c+z015Xj1JnLEyV1FHID5MKP7Bh/MSxhbX613YctaIfvtHsL1DoVXABItS/BYFSTusvc1kYFbpOVBiShsavNi7PskRqg9WDVlqI6w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782951813; c=relaxed/simple;
	bh=uBRE1ap/+vFFqenrYXqqSE30MIh4uJpD+O2wn8YR9DE=;
	h=Date:To:From:Subject:Message-Id; b=pFbK2kH4uBqub29WEtahHODZb+51ZgJLmckghUDEU8vo3GgwUoOTAXTy6rffE6XJ85zKoJ07eUWT0qC4EhkJe5gKyNPfzmmyVJKV1ooXbtvtzsOqZK+zJwZ6arcPNLBF0oE0FqUYHVVoJIWySYmsmRmNZO5bD7qrFQWqR9S2ANg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dojllJ6S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dojllJ6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4771F00A3A;
	Thu,  2 Jul 2026 00:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782951812;
	bh=/PX/pp31f/BalWzHQ7/IrCcXG+ceyOM4OSSA/e6XAvk=;
	h=Date:To:From:Subject;
	b=dojllJ6SJZmTQBpDM+9HGJjeoKsXLwRPFCWjLIGQtCnVKk2a6IEsUBz/BTXtSPP69
	 ErVOpOI7W5vlSBmNzIV8/zWY9vfPXwCW6KG0aQAunA4NmDmQmSeaiAj43VQ59qv5++
	 eqTUSxz04yIBv83vAK8m4y+0OE8lBXG+bZ9/KOlY=
Date: Wed, 01 Jul 2026 17:23:31 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-remove-damon_moving_sum-and-its-unit-test.patch added to mm-new branch
Message-Id: <20260702002332.0F4771F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: remove damon_moving_sum() and its unit test
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-remove-damon_moving_sum-and-its-unit-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-remove-damon_moving_sum-and-its-unit-test.patch

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
Subject: mm/damon/core: remove damon_moving_sum() and its unit test
Date: Mon, 29 Jun 2026 21:08:10 -0700

damon_moving_sum() is no longer being called for real purpose but its unit
test.  Testing a function that is not being used for real users makes no
sense.  Remove the test and the function.

Link: https://lore.kernel.org/20260630040812.149729-18-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c             |   40 ----------------------------------
 mm/damon/tests/core-kunit.h |   16 -------------
 2 files changed, 56 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-remove-damon_moving_sum-and-its-unit-test
+++ a/mm/damon/core.c
@@ -3776,46 +3776,6 @@ int damon_set_region_system_rams_default
 	return damon_set_regions(t, &addr_range, 1, min_region_sz);
 }
 
-/*
- * damon_moving_sum() - Calculate an inferred moving sum value.
- * @mvsum:	Inferred sum of the last @len_window values.
- * @nomvsum:	Non-moving sum of the last discrete @len_window window values.
- * @len_window:	The number of last values to take care of.
- * @new_value:	New value that will be added to the pseudo moving sum.
- *
- * Moving sum (moving average * window size) is good for handling noise, but
- * the cost of keeping past values can be high for arbitrary window size.  This
- * function implements a lightweight pseudo moving sum function that doesn't
- * keep the past window values.
- *
- * It simply assumes there was no noise in the past, and get the no-noise
- * assumed past value to drop from @nomvsum and @len_window.  @nomvsum is a
- * non-moving sum of the last window.  For example, if @len_window is 10 and we
- * have 25 values, @nomvsum is the sum of the 11th to 20th values of the 25
- * values.  Hence, this function simply drops @nomvsum / @len_window from
- * given @mvsum and add @new_value.
- *
- * For example, if @len_window is 10 and @nomvsum is 50, the last 10 values for
- * the last window could be vary, e.g., 0, 10, 0, 10, 0, 10, 0, 0, 0, 20.  For
- * calculating next moving sum with a new value, we should drop 0 from 50 and
- * add the new value.  However, this function assumes it got value 5 for each
- * of the last ten times.  Based on the assumption, when the next value is
- * measured, it drops the assumed past value, 5 from the current sum, and add
- * the new value to get the updated pseduo-moving average.
- *
- * This means the value could have errors, but the errors will be disappeared
- * for every @len_window aligned calls.  For example, if @len_window is 10, the
- * pseudo moving sum with 11th value to 19th value would have an error.  But
- * the sum with 20th value will not have the error.
- *
- * Return: Pseudo-moving average after getting the @new_value.
- */
-static unsigned int damon_moving_sum(unsigned int mvsum, unsigned int nomvsum,
-		unsigned int len_window, unsigned int new_value)
-{
-	return mvsum - nomvsum / len_window + new_value;
-}
-
 /**
  * damon_update_region_access_rate() - Update the access rate of a region.
  * @r:		The DAMON region to update for its access check result.
--- a/mm/damon/tests/core-kunit.h~mm-damon-core-remove-damon_moving_sum-and-its-unit-test
+++ a/mm/damon/tests/core-kunit.h
@@ -659,21 +659,6 @@ static void damon_test_set_attrs(struct
 	damon_destroy_ctx(c);
 }
 
-static void damon_test_moving_sum(struct kunit *test)
-{
-	unsigned int mvsum = 50000, nomvsum = 50000, len_window = 10;
-	unsigned int new_values[] = {10000, 0, 10000, 0, 0, 0, 10000, 0, 0, 0};
-	unsigned int expects[] = {55000, 50000, 55000, 50000, 45000, 40000,
-		45000, 40000, 35000, 30000};
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(new_values); i++) {
-		mvsum = damon_moving_sum(mvsum, nomvsum, len_window,
-				new_values[i]);
-		KUNIT_EXPECT_EQ(test, mvsum, expects[i]);
-	}
-}
-
 static void damon_test_mvsum(struct kunit *test)
 {
 	unsigned long input_expects[] = {
@@ -1590,7 +1575,6 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_nr_accesses_to_accesses_bp),
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
-	KUNIT_CASE(damon_test_moving_sum),
 	KUNIT_CASE(damon_test_mvsum),
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_commit_quota_goal),
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

