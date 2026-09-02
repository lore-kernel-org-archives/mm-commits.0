Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7EF3191BA;
	Wed,  2 Sep 2026 02:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788317745; cv=none; b=W3pmulz27YWmcF5dczKUT+421zU3fDiBHRxxqTIdNc5QJVXLh95SHk98ZQglC13lsiXd6brQOm33U6+oQ7FJcTLOYQQmaDrJL0WTQ8rfpunWqffv+sstkj/HeJl0R9YTuO5sMUsQt3+Ngk/q/ImnvtCxAWypb8kvF00ooxBD4e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788317745; c=relaxed/simple;
	bh=5kYCNGWAl5obE4cEzHTnmImv/2TdZoNDNtYVDFCZLa8=;
	h=Date:To:From:Subject:Message-Id; b=eosg1Xs6j88/NprIPE3Vt84b9e+Sxj/OBp00c+YSvg5SZIRD4YWvnrhuG+Ah9q8DBxAEtc6FlM6PTfSmi4H++3v4QzAYtd3U81EANGs7stDEpquqmhisuzytalUJN510wMOlFchvlUmlxf+l09aFg6GI00Zllid8I0DlFqHKrk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iFe5FmIi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iFe5FmIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5F71F000E9;
	Wed,  2 Sep 2026 02:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788317743;
	bh=L//7fjCBRNe8MeTLruYiqhCCXaPKhthpEXZqkd081GY=;
	h=Date:To:From:Subject;
	b=iFe5FmIi3K4OSpZhv3DOyeAFALhVuey22g7rHzuBXWPvGNav3QqbBzUVqFMi7ybFY
	 6hI/SlitKyOLLn0I846NY7RpmrJ1AZFItupuG9XhP448Tchpp2Fu2mScBad8XMs0qJ
	 fYDNFBHJS4mm0yqrs7DiMHo6lu8NJnwUiMgi5w90=
Date: Tue, 01 Sep 2026 19:55:42 -0700
To: mm-commits@vger.kernel.org,yanquanmin1@huawei.com,stable@vger.kernel.org,davidgow@davidgow.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total.patch added to mm-new branch
Message-Id: <20260902025543.2B5F71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total.patch

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
Subject: mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
Date: Tue, 1 Sep 2026 17:27:21 -0700

When DAMOS_QUOTA_SOME_MEM_PSI_US metric damos quota goal is set, the PSI
delta for the feedback loop is calculated using
damos_quota_goal->last_psi_total.  However, it is initialized only after
the first feedback loop.  The first iteration of the loop uses the
uninitialized value.  As a result, the feedback loop can change the
effective quota in an unexpected way at the first iteration.

The user impact of the issue is not big, because the issue impacts only
the first iteration of the feedback loop.  The feedback loop also has an
internal cap of the quota adjustment.  The wrong adjustment will soon be
corrected over a few iterations.  For this reason, doing no initialization
at commit time was intentional.  It is also explicitly commented.  That
said, nobody likes behaviors that are unexpected or difficult to be
expected.

Check last_psi_total initialization and skip the tuning round when it is
not initialized.  For this, initialize last_psi_total with U64_MAX in the
goal creation and the goal commit time.  U64_MAX means the field is not
initialized.  The tuning round shows the value and adjusts it to guarantee
the current quota is maintained for the round, and last_psi_total is
correctly initialized on the next round.

Before this change, committing a new PSI goal on an existing PSI goal with
goal-only DAMON sysfs command (commit_schemes_quota_goals) just worked. 
After this change, the tuning round right after the commit will be
unnecessarily skipped, because last_psi_total is unconditionally marked as
not initialized in the damos_commit_quota_goal_union().  This is an
intended tradeoff for simplicity.  Skipping just one round of tuning is no
problem.  Meanwhile it makes both the code and the behavior simple to
understand.

Also update the quota goal commit unit test for changed last_psi_total
setup behavior.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260902002725.108635-3-sj@kernel.org
Link: https://lore.kernel.org/20260718005316.89585-1-sj@kernel.org [1]
Fixes: 2dbb60f789cb ("mm/damon/core: implement PSI metric DAMOS quota goal")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Cc: <stable@vger.kernel.org> # 6.9.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c             |   13 +++++++++++--
 mm/damon/tests/core-kunit.h |    9 +++------
 2 files changed, 14 insertions(+), 8 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total
+++ a/mm/damon/core.c
@@ -697,6 +697,8 @@ struct damos_quota_goal *damos_new_quota
 		return NULL;
 	goal->metric = metric;
 	goal->target_value = target_value;
+	if (metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
+		goal->last_psi_total = U64_MAX;
 	INIT_LIST_HEAD(&goal->list);
 	return goal;
 }
@@ -1190,6 +1192,9 @@ static void damos_commit_quota_goal_unio
 		struct damos_quota_goal *dst, struct damos_quota_goal *src)
 {
 	switch (dst->metric) {
+	case DAMOS_QUOTA_SOME_MEM_PSI_US:
+		dst->last_psi_total = U64_MAX;
+		break;
 	case DAMOS_QUOTA_NODE_MEM_USED_BP:
 	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
 		dst->nid = src->nid;
@@ -1211,7 +1216,6 @@ static void damos_commit_quota_goal(
 	dst->target_value = src->target_value;
 	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
 		dst->current_value = src->current_value;
-	/* keep last_psi_total as is, since it will be updated in next cycle */
 	damos_commit_quota_goal_union(dst, src);
 }
 
@@ -3136,7 +3140,12 @@ static void damos_set_quota_goal_current
 		break;
 	case DAMOS_QUOTA_SOME_MEM_PSI_US:
 		now_psi_total = damos_get_some_mem_psi_total();
-		goal->current_value = now_psi_total - goal->last_psi_total;
+		/* uninitialized last_psi_total; make no effect this round */
+		if (goal->last_psi_total == U64_MAX)
+			goal->current_value = goal->target_value;
+		else
+			goal->current_value = now_psi_total -
+				goal->last_psi_total;
 		goal->last_psi_total = now_psi_total;
 		break;
 	case DAMOS_QUOTA_NODE_MEM_USED_BP:
--- a/mm/damon/tests/core-kunit.h~mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total
+++ a/mm/damon/tests/core-kunit.h
@@ -757,19 +757,16 @@ static void damos_test_commit_quota_goal
 		struct damos_quota_goal *dst,
 		struct damos_quota_goal *src)
 {
-	u64 dst_last_psi_total = 0;
-
-	if (dst->metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
-		dst_last_psi_total = dst->last_psi_total;
 	damos_commit_quota_goal(dst, src);
 
 	KUNIT_EXPECT_EQ(test, dst->metric, src->metric);
 	KUNIT_EXPECT_EQ(test, dst->target_value, src->target_value);
 	if (src->metric == DAMOS_QUOTA_USER_INPUT)
 		KUNIT_EXPECT_EQ(test, dst->current_value, src->current_value);
-	if (dst_last_psi_total && src->metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
-		KUNIT_EXPECT_EQ(test, dst->last_psi_total, dst_last_psi_total);
 	switch (dst->metric) {
+	case DAMOS_QUOTA_SOME_MEM_PSI_US:
+		KUNIT_EXPECT_EQ(test, dst->last_psi_total, U64_MAX);
+		break;
 	case DAMOS_QUOTA_NODE_MEM_USED_BP:
 	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
 		KUNIT_EXPECT_EQ(test, dst->nid, src->nid);
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

