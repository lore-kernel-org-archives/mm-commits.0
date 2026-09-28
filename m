Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DD620D4FC;
	Mon, 28 Sep 2026 22:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790633941; cv=none; b=V+zabrNuvt00V4Yugx5j9V1iQz3bsrYWfKfhojv/jFFeMVARGactJuvE8YBFAd81V7OtFwbD95r7p3XAiaLyZG6D1CIuooIMyjmL4bDF0SAt2mQEZpsm2sR/4BVs0rVdpom6KVzbH3rRkiq6va6enIRtSABfQRUN+15/DxOtLek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790633941; c=relaxed/simple;
	bh=mN93aZwj0sLL9wZu3aPcOGrz8f4JdIEwsr03/4kf9JU=;
	h=Date:To:From:Subject:Message-Id; b=UfVWV383Y8hUdBe4zyT/HAcp1sI8dW6lQj2rPynaVkNKGznib0Lal/qya+tMxPx5wUUHX9X1FttLvGDg3BtTQcu4PcJ89F06kmfynvTzt9NiH2VWJs0DIqUQ2cJq8iRueQPphn/cXw4A18jpJ4+L47hCEzZohM0l8QDrPsJ6fQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VeBbkUW7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VeBbkUW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711AC1F000FF;
	Mon, 28 Sep 2026 22:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790633939;
	bh=9EDQF5uMQpnZxSmk/RgZwWOHVdJB97dJsjv0RzMsKao=;
	h=Date:To:From:Subject;
	b=VeBbkUW7m4KtOP9vUAaOSwd5R3Eyk80wAvDXOhwUqWe9nG8temX5Urn+7byIJQD8I
	 frqE4vm46PNFPoumyEHdAsDcGqp3usBpjfEt1Ne9d74j7q4CwRY88buFDS4X6wg7iz
	 y9jZ5pZa+bRzasbetDsvBXLmVLGrFGF7bWwnSqQ8=
Date: Mon, 28 Sep 2026 15:18:59 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,bijan311@gmail.com,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-preserve-the-quota-passed-to-damon_new_scheme.patch added to mm-new branch
Message-Id: <20260928221859.711AC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: preserve the quota passed to damon_new_scheme()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-preserve-the-quota-passed-to-damon_new_scheme.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-preserve-the-quota-passed-to-damon_new_scheme.patch

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
Subject: mm/damon/core: preserve the quota passed to damon_new_scheme()
Date: Mon, 28 Sep 2026 01:58:33 -0700

Patch series "mm/damon/core: preserve quota state when constructing
schemes", v3.

damon_commit_ctx() first commits the running context's parameters to a
temporary context for validating proposed updates.  Constructing the
temporary schemes clears the running schemes' quota state because
damon_new_scheme() initializes the quota passed as a parameter before
copying it to the new scheme.  Even an update later rejected with -EINVAL
loses the running quota state.

Initialize the new scheme's copy instead, and add KUnit tests for the
constructor and for accepted and rejected context updates.

Note: below are test results and changelogs that could be removed from the
final commit log.

In the v1 live test with damo, a scheme with a plain 64 KiB size quota and
a 60-second reset interval uses its quota, and a full "damo tune" with
unchanged parameters then lets it try another 64 KiB within the same
window.  With the fix, sz_tried stays at 64 KiB.

KUnit was rerun after the rebase on x86-64 and i386. With only patch 2
applied, the two new tests fail. With the fix, all 46 DAMON KUnit tests
pass on both architectures.

The v1 DAMON selftests showed no new failures (QEMU TCG guest; the
wss_estimation test missed its accuracy bounds with and without the fix).


This patch (of 2):

damon_commit_ctx() first commits the running context's parameters to a
temporary context for validating proposed updates.  When
damon_commit_schemes() creates the temporary schemes, it passes the
running scheme's quota as the quota parameter of damon_new_scheme().

damon_new_scheme() calls damos_quota_init() on that quota before copying
it to the new scheme.  This clears the running scheme's effective quota,
feedback input and charging state.  Even an update rejected with -EINVAL
loses the running quota state.

For a size quota, this discards the bytes already charged and allows the
scheme to use a fresh quota before the reset interval has elapsed.  For a
goal-driven quota, the consist tuner loses its accumulated input and
restarts from its minimum input.  A time quota loses its throughput
estimate and falls back to the initial estimate.

The end users will show DAMOS works more or less aggressively than
expected for online-commit updates of quotas.  DAMON provides best efforts
by default.  DAMON parameters online commit is supposed to be executed
only occasionally.  Hence, the issue wouldn't be critical on sane setups. 
For user_input type quota goals, online commit of the user input score is
expected to be frequent.  But, for the case commit_schemes_quota_goals
command is recommended for optimal execution, and it doesn't have this
bug.

Commit 60bd24f272d0 ("mm/damon/sysfs: test commit input against realistic
destination") introduced this problem in v6.19 when sysfs validation began
committing the running context's parameters to a temporary context. 
Commit b90408ef1163 ("mm/damon/core: safely validate src on
damon_commit_ctx()") later moved that validation into the core API,
exposing other callers including DAMON_RECLAIM and DAMON_LRU_SORT.

Sashiko reported the same side effect [1] on the RFC of the core API
change.

Copy the quota to the new scheme first, then initialize that copy.  Make
damos_quota_init() return void, since its return value is no longer
needed.

Link: https://lore.kernel.org/20260928085835.7675-1-sj@kernel.org
Link: https://lore.kernel.org/20260928085835.7675-2-sj@kernel.org
Link: https://lore.kernel.org/r/20260702212143.0CB6D1F00A3D@smtp.kernel.org/ [1]
Fixes: 60bd24f272d0 ("mm/damon/sysfs: test commit input against realistic destination")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Assisted-by: LLM
Cc: Bijan Tabatabai <bijan311@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/damon/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-preserve-the-quota-passed-to-damon_new_scheme
+++ a/mm/damon/core.c
@@ -734,7 +734,7 @@ static bool damos_quota_goals_empty(stru
 }
 
 /* initialize fields of @quota that normally API users wouldn't set */
-static struct damos_quota *damos_quota_init(struct damos_quota *quota)
+static void damos_quota_init(struct damos_quota *quota)
 {
 	quota->esz = 0;
 	quota->total_charged_sz = 0;
@@ -744,7 +744,6 @@ static struct damos_quota *damos_quota_i
 	quota->charge_target_from = NULL;
 	quota->charge_addr_from = 0;
 	quota->esz_bp = 0;
-	return quota;
 }
 
 struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
@@ -776,7 +775,8 @@ struct damos *damon_new_scheme(struct da
 	scheme->last_applied = NULL;
 	INIT_LIST_HEAD(&scheme->list);
 
-	scheme->quota = *(damos_quota_init(quota));
+	scheme->quota = *quota;
+	damos_quota_init(&scheme->quota);
 	/* quota.goals should be separately set by caller */
 	INIT_LIST_HEAD(&scheme->quota.goals);
 
_

Patches currently in -mm which might be from kmehltretter@gmail.com are

mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total-fix.patch
docs-mm-ksm-use-the-renamed-ksm-structure-names.patch
mm-secretmem-fix-the-enable-parameter-description.patch
mm-damon-core-preserve-the-quota-passed-to-damon_new_scheme.patch
mm-damon-tests-core-kunit-test-preservation-of-quota-state.patch
klist-avoid-accesses-after-waking-klist_remove.patch
squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch
fork-honor-task_structs-declared-alignment.patch
ocfs2-cluster-hold-a-reference-on-the-heartbeat-thread.patch
resource-kunit-stop-selecting-get_free_region.patch

