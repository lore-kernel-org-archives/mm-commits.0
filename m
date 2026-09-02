Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC513290C7
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 20:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788381031; cv=none; b=QihECvW3kkzDNQAnxW1fDMKFQyHXau4NgrPqqmcOBF1go1KsICO1C6/GW9NkmZKS+qCcA9y7+tYs31MqL2vD6aA4a10gk1P12cc+6z9q9zEFN45Q98NLUStJ5DPgqpAgexAAKiucA5zmoC3od2eSQz52N/hwn1EaIbZLIjYhzpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788381031; c=relaxed/simple;
	bh=ta7Hqopss/UmeUCug8deV+8v6qmwMRukRXqCyQTxGKM=;
	h=Date:To:From:Subject:Message-Id; b=CI95Ci05SjE9YmrwUzAVVaj20ITyf4x9Z061JbOUcc84HafQzyq+f8Zi/3uuITOgBBThz7Z/420t4Q7t9Xb2Y764EtFMT1DXVefD6Zvhoz2HMIfz+e7GG8xc8BK7jH6iQpyBde1U4ZWqrqViaK8c1u3hL+i9prAm8gvAnMxAZAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n1XMeY4m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n1XMeY4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565861F000E9;
	Wed,  2 Sep 2026 20:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788381029;
	bh=XF6QIZWDQwWAn7//DatdMghynZtIln7q5sBb6qBikME=;
	h=Date:To:From:Subject;
	b=n1XMeY4mrKBnulkpm8X1b3+/TUFOLAt96lJmo3PKGl8Tye5MyyH/LUnEMWiSORnHw
	 cfDZ6z+SaDJBcuXmXbPrR1wcy5r9qSPMJgUiuHi6TnmAQ9uL+w7LmmuClrtf0X5gFp
	 +2YR6VbgslRFkg51/hbWlclC9hkBESrV0CCeXQgw=
Date: Wed, 02 Sep 2026 13:30:28 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@davidgow.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-test-damon_commit_filter.patch added to mm-new branch
Message-Id: <20260902203029.565861F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: test damon_commit_filter()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-test-damon_commit_filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-test-damon_commit_filter.patch

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
Subject: mm/damon/tests/core-kunit: test damon_commit_filter()
Date: Wed, 2 Sep 2026 07:03:07 -0700

Patch series "mm/damon: add kunit and selftests for probes and probe
weights".

DAMON recently introduced probes and probe weights.  Add kunit and
selftests for ensuring the parameters for features can be set using the
core API and the sysfs ABI, respectively.


This patch (of 6):

Add kunit test to ensure damon_commit_filter() updates destination filter
as expected for valid inputs.

Link: https://lore.kernel.org/20260902140313.85983-1-sj@kernel.org
Link: https://lore.kernel.org/20260902140313.85983-2-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   40 ++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-test-damon_commit_filter
+++ a/mm/damon/tests/core-kunit.h
@@ -1316,6 +1316,45 @@ static void damon_test_commit_target_reg
 			(unsigned long[][2]) {{3, 8}, {8, 10}}, 2);
 }
 
+static void damon_test_commit_filter_for(struct kunit *test,
+		struct damon_filter *dst, struct damon_filter *src)
+{
+	damon_commit_filter(dst, src);
+	KUNIT_EXPECT_EQ(test, dst->type, src->type);
+	KUNIT_EXPECT_EQ(test, dst->matching, src->matching);
+	KUNIT_EXPECT_EQ(test, dst->allow, src->allow);
+	switch (src->type) {
+	case DAMON_FILTER_TYPE_MEMCG:
+		KUNIT_EXPECT_EQ(test, dst->memcg_id, src->memcg_id);
+		break;
+	default:
+		break;
+	}
+}
+
+static void damon_test_commit_filter(struct kunit *test)
+{
+	struct damon_filter dst = {
+		.type = DAMON_FILTER_TYPE_ANON,
+		.matching = false,
+		.allow = false,
+	};
+
+	damon_test_commit_filter_for(test, &dst,
+			&(struct damon_filter){
+			.type = DAMON_FILTER_TYPE_ANON,
+			.matching = true,
+			.allow = true,
+			});
+	damon_test_commit_filter_for(test, &dst,
+			&(struct damon_filter){
+			.type = DAMON_FILTER_TYPE_MEMCG,
+			.matching = false,
+			.allow = false,
+			.memcg_id = 123,
+			});
+}
+
 static void damon_test_commit_ctx(struct kunit *test)
 {
 	struct damon_ctx *src, *dst;
@@ -1722,6 +1761,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damos_test_commit_pageout),
 	KUNIT_CASE(damos_test_commit_migrate_hot),
 	KUNIT_CASE(damon_test_commit_target_regions),
+	KUNIT_CASE(damon_test_commit_filter),
 	KUNIT_CASE(damon_test_commit_ctx),
 	KUNIT_CASE(damon_test_valid_probe_params),
 	KUNIT_CASE(damos_test_filter_out),
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

