Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA18537C0F0
	for <mm-commits@vger.kernel.org>; Mon, 28 Sep 2026 22:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790635873; cv=none; b=efAyPhRHQu1pNBRBAo7gIHpqT69+Ui/iNZBojPHzKbrT/VRU22hqTmzcRSyaVOjsFGQqh8zb+LmExCkPbmnm789/G0Cq0kelnIkC94weTUiyYdklj7aBC6+uQLuazhXNmEeXA26VArclhkvoscaawMB6gJqxt3WFBLvQFU1TC8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790635873; c=relaxed/simple;
	bh=2ZIA0OL2Fo2i4GztsdN+zJC+t3q5pTztTBXTJ0wxzG0=;
	h=Date:To:From:Subject:Message-Id; b=WwT1jAjNryd53FLRY+lUsXGT5okm59QBpu0pGYfE8HrNTbMxNhLqR1U9TcaxKJ43pBERpggNGdqp8q56FPfDBwng+VyTVjyvgBEE+JTji2Z555L4wj1RDCymnGdq7ZpaMANuEBOxooL/m7cncnvw0fB84ioR6aQI6NEpPjdLCrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W3rz4Pfk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W3rz4Pfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FEF41F000FF;
	Mon, 28 Sep 2026 22:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790635871;
	bh=G3rVTePqcvxUp8RZu/lJjzapFKaezn2TRkgEScI8J7A=;
	h=Date:To:From:Subject;
	b=W3rz4PfkRaIcBmZfEUUITvWoSuPUTh0KL8RgF946iUqOgfX35LPKevLRyDpOxT9Q4
	 wpChtyiv2d/ICoNVdv0GqlLWcB4KCQzlNx6kLdZ2GTZV8Q9zsp1g2PKltmmF7vunbq
	 S878ENvEGPYee0WGoKCUvBl+tZB73JrnQLaXXbWk=
Date: Mon, 28 Sep 2026 15:51:10 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lianux.mm@gmail.com,kunwu.chan@gmail.com,davidgow@davidgow.net,brendan.higgins@linux.dev,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-test-psi-goal-values-with-explicit-samples.patch added to mm-new branch
Message-Id: <20260928225111.5FEF41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: test PSI goal values with explicit samples
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-test-psi-goal-values-with-explicit-samples.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-test-psi-goal-values-with-explicit-samples.patch

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
From: Karl Mehltretter <kmehltretter@gmail.com>
Subject: mm/damon/tests/core-kunit: test PSI goal values with explicit samples
Date: Mon, 28 Sep 2026 01:39:57 -0700

Test the PSI current-value helper with explicit totals so the result does
not depend on the test system's memory pressure.  Cover an unmeasured
consist goal, unmeasured temporal goals with zero and nonzero effective
quotas, and measured rounds for both tuners.  Check last_psi_total after
each call.

Link: https://lore.kernel.org/20260928083959.4030-4-sj@kernel.org
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Assisted-by: LLM
Cc: Lian Wang <lianux.mm@gmail.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
---

 mm/damon/tests/core-kunit.h |   43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-test-psi-goal-values-with-explicit-samples
+++ a/mm/damon/tests/core-kunit.h
@@ -952,6 +952,48 @@ static void damos_test_commit_quota_goal
 			});
 }
 
+static void damos_test_set_psi_current_val(struct kunit *test)
+{
+	struct damos s = {
+		.quota.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+	};
+	struct damos_quota_goal goal = {
+		.metric = DAMOS_QUOTA_SOME_MEM_PSI_US,
+		.target_value = 100,
+		.last_psi_total = U64_MAX,
+	};
+
+	/* uninitialized last_psi_total keeps the consist tuner quota */
+	damos_set_psi_current_val(1000, &goal, &s);
+	KUNIT_EXPECT_EQ(test, goal.current_value, 100ul);
+	KUNIT_EXPECT_EQ(test, goal.last_psi_total, 1000ull);
+
+	/* initialized last_psi_total gives the delta */
+	damos_set_psi_current_val(1030, &goal, &s);
+	KUNIT_EXPECT_EQ(test, goal.current_value, 30ul);
+	KUNIT_EXPECT_EQ(test, goal.last_psi_total, 1030ull);
+
+	/* temporal tuner keeps a zero quota */
+	s.quota.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL;
+	s.quota.esz = 0;
+	goal.last_psi_total = U64_MAX;
+	damos_set_psi_current_val(2000, &goal, &s);
+	KUNIT_EXPECT_EQ(test, goal.current_value, 100ul);
+	KUNIT_EXPECT_EQ(test, goal.last_psi_total, 2000ull);
+
+	/* temporal tuner keeps a non-zero quota */
+	s.quota.esz = SZ_64K;
+	goal.last_psi_total = U64_MAX;
+	damos_set_psi_current_val(3000, &goal, &s);
+	KUNIT_EXPECT_EQ(test, goal.current_value, 0ul);
+	KUNIT_EXPECT_EQ(test, goal.last_psi_total, 3000ull);
+
+	/* temporal tuner uses the measured PSI delta */
+	damos_set_psi_current_val(3250, &goal, &s);
+	KUNIT_EXPECT_EQ(test, goal.current_value, 250ul);
+	KUNIT_EXPECT_EQ(test, goal.last_psi_total, 3250ull);
+}
+
 static void damos_test_commit_quota_goals_for(struct kunit *test,
 		struct damos_quota_goal *dst_goals, int nr_dst_goals,
 		struct damos_quota_goal *src_goals, int nr_src_goals)
@@ -2413,6 +2455,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_new_scheme_keeps_src_quota),
 	KUNIT_CASE(damos_test_commit_quota_goal),
+	KUNIT_CASE(damos_test_set_psi_current_val),
 	KUNIT_CASE(damos_test_commit_quota_goals),
 	KUNIT_CASE(damos_test_commit_quota),
 	KUNIT_CASE(damos_test_commit_dests),
_

Patches currently in -mm which might be from kmehltretter@gmail.com are

mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total-fix.patch
docs-mm-ksm-use-the-renamed-ksm-structure-names.patch
mm-secretmem-fix-the-enable-parameter-description.patch
mm-damon-core-preserve-the-quota-passed-to-damon_new_scheme.patch
mm-damon-tests-core-kunit-test-preservation-of-quota-state.patch
mm-damon-tests-core-kunit-test-psi-goal-values-with-explicit-samples.patch
klist-avoid-accesses-after-waking-klist_remove.patch
squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch
fork-honor-task_structs-declared-alignment.patch
ocfs2-cluster-hold-a-reference-on-the-heartbeat-thread.patch
resource-kunit-stop-selecting-get_free_region.patch

