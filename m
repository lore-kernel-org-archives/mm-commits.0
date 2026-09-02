Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024984078FB
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 22:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788388946; cv=none; b=OcNl9P1Rkaz3ZprEG87IVkVNXxkFrSgRuZIxLvFdav+lTdHe6f8nOZgDvs6aEvXSTtJY+EilbB0O8BHpteWKmSO6OipCX/CEK+21K6UrgkJM0j+CdSiMX/xIdoAf4SJyva5UlFVtJH/8rCeOLryWRPnURfnlZKZYoMa8KtfbRZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788388946; c=relaxed/simple;
	bh=YAMOn9xheqFHHx2cgWsuNqjA2d3u5fbbaHWzliFV754=;
	h=Date:To:From:Subject:Message-Id; b=L2KM8Dr1+Kya8GVq2xfuKcQLFh7DAT+H3YATpIbcoXsV2nf6oL/9hohTZv+yhJgPFH2TFPn+JVwEW1cz5+eKeV6RUIfM1uvs3tfy96jKPZWlK81aeQLZx+ukCiCSw2kJUbUjZATn4/nXow4LXp9ZljEBv5gicrfHYPmZLrtd0yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=udmziEez; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="udmziEez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1D61F00A3E;
	Wed,  2 Sep 2026 22:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788388936;
	bh=oP29S3BwX7u4D5v3c+d9hwgrCypinPtU2ztRcxWpQg8=;
	h=Date:To:From:Subject;
	b=udmziEezIAZxawZJh/7GUMCO1nkDUqrX+4izYmXJ0Tu8mTEohJJa++k8nJC1VzA3z
	 SOQiyB5sH+KQpusn0sYzU6Mdb4ahvv5BirE+yZAR4eeob7xwy56gI4LX8W8EDuD4WF
	 l/3IhFi4SuB0DSgmzVQKsdlbPGlwmHXwarf5GDq8=
Date: Wed, 02 Sep 2026 15:42:16 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-test-damon_nr_samples_per_aggr.patch added to mm-new branch
Message-Id: <20260902224216.6E1D61F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: test damon_nr_samples_per_aggr()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-test-damon_nr_samples_per_aggr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-test-damon_nr_samples_per_aggr.patch

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
Subject: mm/damon/tests/core-kunit: test damon_nr_samples_per_aggr()
Date: Tue, 1 Sep 2026 22:47:42 -0700

damon_max_nr_accesses(), which is a previous version of
damon_nr_samples_per_aggr() before the renaming, was wrongly returning
zero or random overflowed values for extreme intervals setup.  Commit
35d4a3cf70a8 ("mm/damon/ops-common: handle extreme intervals in
damon_hot_score()") updated the function to return correct or more valid
values.  Add a kunit test to ensure it is working as expected.

Link: https://lore.kernel.org/20260902054747.99370-10-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-test-damon_nr_samples_per_aggr
+++ a/mm/damon/tests/core-kunit.h
@@ -625,6 +625,27 @@ static void damon_test_set_regions(struc
 			(struct damon_addr_range[]){}, 0, -EINVAL);
 }
 
+static void damon_test_nr_samples_per_aggr(struct kunit *test)
+{
+	struct damon_attrs attrs = {
+		.sample_interval = 0,
+		.aggr_interval = 0,
+	};
+
+	/* Zero aggregation interval doesn't cause division by zero */
+	KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs), 1);
+
+	/*
+	 * Too large aggregation interval on 64 bit system doesn't cause
+	 * overflow
+	 */
+	if (ULONG_MAX > UINT_MAX) {
+		attrs.aggr_interval = (unsigned long)UINT_MAX + 1;
+		KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs),
+				UINT_MAX);
+	}
+}
+
 static void damon_test_update_monitoring_result(struct kunit *test)
 {
 	struct damon_attrs old_attrs = {
@@ -1858,6 +1879,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_split_above_half_progresses),
 	KUNIT_CASE(damon_test_ops_registration),
 	KUNIT_CASE(damon_test_set_regions),
+	KUNIT_CASE(damon_test_nr_samples_per_aggr),
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_mvsum),
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-skip-applying-scheme-if-region-split-for-quota-fails.patch
mm-damon-paddr-respect-folio-end-for-damos_stat.patch
mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_migrate_hotcold.patch
mm-damon-core-handle-extreme-memory-state-in-damon_get_node_mem_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_node_memcg_used_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp.patch
mm-damon-core-introduce-damon_filter_type_pgidle_unset.patch
mm-damon-paddr-support-pgidle_unset-probe-filter-type.patch
mm-damon-sysfs-support-pgidle_unset-probe-filter-type.patch
docs-mm-damon-design-document-pgidle_unset-probe-filter-type.patch
mm-damon-core-introduce-damon_prep-struct.patch
mm-damon-core-commit-preps.patch
mm-damon-core-introduce-damon_operations-prep_probes.patch
mm-damon-paddr-support-damon_prep.patch
mm-damon-sysfs-implement-preps-directory.patch
mm-damon-sysfs-implement-preps-nr_preps-file.patch
mm-damon-sysfs-create-directories-for-nr_preps-writes.patch
mm-damon-sysfs-implement-prep_action-file.patch
mm-damon-sysfs-pass-preps-to-damon-core.patch
selftests-damon-sysfssh-test-probe-prep-sysfs-files.patch
docs-mm-damon-design-document-probe-preps.patch
docs-admin-guide-mm-damon-usage-document-probe-preps-sysfs-files.patch
docs-abi-damon-document-probe-prep-sysfs-files.patch
mm-damon-tests-core-kunit-test-committing-psi-goal-to-psi-goal.patch
mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total.patch
mm-damon-core-copy-nid-for-eligible_mem_bp-damos-quota-goal-commit.patch
mm-damon-sysfs-set-next-refresh-jiffies-per-sysfs-context.patch
mm-damon-tests-core-kunit-test-damon_commit_filter.patch
mm-damon-tests-core-kunit-add-damon_commit_probes-test.patch
selftests-damon-_damon_sysfs-implement-damonprobes.patch
selftests-damon-drgn_dump_damon_status-dump-probes.patch
selftests-damon-sysfspy-extend-commit-assertion-function-for-probes.patch
selftests-damon-sysfspy-test-damon-probes.patch
mm-damon-core-use-damon_nr_samples_per_aggr-for-max-merge-threshold.patch
mm-damon-core-remove-debug-messages.patch
mm-damon-core-remove-debug-messages-fix.patch
mm-damon-vaddr-remove-a-debug-message.patch
mm-damon-core-validate-number-of-probes-in-valid_probe_params.patch
mm-damon-sysfs-remove-probes-number-validation.patch
mm-damon-tests-core-kunit-extend-set_regions-test-for-error-case.patch
mm-damon-tests-core-kunit-test-=0-size-damon_set_regions-inputs.patch
mm-damon-tests-core-kunit-test-overlapping-ranges-for-set_regions.patch
mm-damon-tests-core-kunit-test-damon_nr_samples_per_aggr.patch
selftests-damon-sysfssh-test-hugepage_mem_bp-quota-goal.patch
docs-mm-damon-maintainer-profile-update-ai-review-for-sashiko-replies.patch
docs-abi-damon-recommend-subsystem-doc-instead-of-admin-guide.patch

