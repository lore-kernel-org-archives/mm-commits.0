Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F9630D407;
	Wed,  2 Sep 2026 02:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788317743; cv=none; b=f9XIGx5eRXSCBAZDIYw65JRA5nGvcryyLqvkBwLfXeFpjSNVx+qE2Snkgvl72AV7husdUYyPT9jv2Ko81nUMsumYl9BaeIdhWFQBMEDbS4gNDGGrBk99hzR52oFFEtDE5cBxSSDtiGh+MYlaHn/3o6GprgHKNI8mgKTTG8d40oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788317743; c=relaxed/simple;
	bh=brgyi7clMT7/7pitm0hsUYAFU2svqT1XZ0Fp0B8cmac=;
	h=Date:To:From:Subject:Message-Id; b=WIM9Ewh9rSschtb/TCGCRsQbQtGWOs2R2VTFviMbGYH1itONTpICHB0JF7A795ITxzkdLCE/fP+3fVyvCW6C+h1iFVSEtx88l8g+eioKg8d0pwAzhzFPbFPZXsaW+7SdUEYGKeJrMmf8W1b5uOGZMTRnBoYW1HKaJZDcR6hTT6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OiLe3yKx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OiLe3yKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D011F000E9;
	Wed,  2 Sep 2026 02:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788317741;
	bh=wIkcnGt2XK+yTpRhjOM4JFBC/LESpX42piUhsGl5MI0=;
	h=Date:To:From:Subject;
	b=OiLe3yKxtuOgg3k9iXAQtC2bpZWZ5GmkskO08PWoM0dlu6c8YcFbymueQHfdVj1nk
	 UVPvKEGAoiA0GCP6lkUA+OE3msWyaZX8YYSoP+T+TjsFRV7u6OFbC7qf+84xIqHH03
	 Uz2Usq/QbI/GQxezwjVPEsbqEJ0wonOUupehWJF4=
Date: Tue, 01 Sep 2026 19:55:40 -0700
To: mm-commits@vger.kernel.org,yanquanmin1@huawei.com,stable@vger.kernel.org,davidgow@davidgow.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-test-committing-psi-goal-to-psi-goal.patch added to mm-new branch
Message-Id: <20260902025541.19D011F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: test committing psi goal to psi goal
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-test-committing-psi-goal-to-psi-goal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-test-committing-psi-goal-to-psi-goal.patch

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
Subject: mm/damon/tests/core-kunit: test committing psi goal to psi goal
Date: Tue, 1 Sep 2026 17:27:20 -0700

Patch series "mm/damon: fix misc bugs in kunit, quota goals and sysfs
refresh_ms".

DAMOS quota goals commit unit test is mistakenly not testing a test case
that was designed to test.  DAMOS quota goals and DAMON sysfs refresh_ms
file have bugs that can produce non critical but still unexpected
behaviors.  Fix the bugs.

Patch 1 fixes the DAMOS quota goals commit unit test to cover a mistakenly
uncovered case.  Patches 2 and 3 fix the bugs in DAMOS PSI goal
initialization and eligible_mem_bp online commit, respectively.  Patch 4
fixes the bug in DAMON sysfs refresh_ms file handling.


This patch (of 4):

damon_test_commit_quota_goal_for() is set to test committing a new psi
goal on an existing psi goal.  However, damon_test_commit_quota_goal() is
mistakenly not covering the test case.  Add the test case.

Link: https://lore.kernel.org/20260902002725.108635-1-sj@kernel.org
Link: https://lore.kernel.org/20260902002725.108635-2-sj@kernel.org
Fixes: 99f89debafc5 ("mm/damon/tests/core-kunit: add damos_commit_quota_goal() test")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-test-committing-psi-goal-to-psi-goal
+++ a/mm/damon/tests/core-kunit.h
@@ -794,6 +794,13 @@ static void damos_test_commit_quota_goal
 	};
 
 	damos_test_commit_quota_goal_for(test, &dst,
+			&(struct damos_quota_goal) {
+			.metric = DAMOS_QUOTA_SOME_MEM_PSI_US,
+			.target_value = 234,
+			.current_value = 345,
+			.last_psi_total = 567,
+			});
+	damos_test_commit_quota_goal_for(test, &dst,
 			&(struct damos_quota_goal){
 			.metric = DAMOS_QUOTA_USER_INPUT,
 			.target_value = 789,
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

