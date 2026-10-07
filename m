Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED64320A14;
	Wed,  7 Oct 2026 00:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334366; cv=none; b=DIsVGxNqPPswkskYCs1FITj/Z2ofY4IfIVMkyPWevFPOW6wvmPUzyz6zrAsIiCZQvaWbgogUw71aHO8vXEAKFry+L03D8eOiC0NvEvdqe0b/mHMhhVXWPXuNkGiK3tAvKE38FI1boPlKi69PMbaUmb8r0wRRV0SmIRcxKjO6EGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334366; c=relaxed/simple;
	bh=AK/F8fO2VRCRMbGgcq/MTTnuetxVh+sKXiVgYTpjzj4=;
	h=Date:To:From:Subject:Message-Id; b=Th21J8nCpYYmFQmP02kpIT+zhKUDQ7w+3x0xt5EISpnEdgHjBzegF2ATTq6nVGFt3xHqEUb36Ifh/RbYw03C2P8xPS4lRl7nMJ1tQqYwoXK0UsAoT2BN5HtvD02xRn8SYffLMAfpL3I0ZTSzkTMpWmuMgNiNEXKiRDoci8WRibY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AHa6poHV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AHa6poHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163621F0089C;
	Wed,  7 Oct 2026 00:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334365;
	bh=Vk1PwVHvii1CUUR8jDteqiXvM5T6D+9erU3coAsZuAw=;
	h=Date:To:From:Subject;
	b=AHa6poHVPIpgRCk/oYLa3pWrOjGuUE9JmGKQhtV5JTtGOQoS79bcx6hyzEMUgPwGk
	 Y2/Y3gjO19mPs+3lo61VODQ8I6mFwZDmuHQgaknv+rZ+QMabFW6zYGGJ38ULYdog7j
	 YS7tjsM1afk+CF/DFBSWI0LPbFTxcK8FLHRgKA/Q=
Date: Tue, 06 Oct 2026 17:52:44 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,lianux.mm@gmail.com,kunwu.chan@gmail.com,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total-fix.patch removed from -mm tree
Message-Id: <20261007005245.163621F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: keep the temporal tuner quota over an unmeasured PSI round
has been removed from the -mm tree.  Its filename was
     mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total-fix.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Karl Mehltretter <kmehltretter@gmail.com>
Subject: mm/damon/core: keep the temporal tuner quota over an unmeasured PSI round
Date: Tue, 22 Sep 2026 22:51:37 -0700

The patch in mm-unstable of subject "mm/damon/core: handle uninitialized
damos_quota_goal->last_psi_total" scores a PSI quota goal without a
previous sample as achieved.  This leaves the consist tuner's input
unchanged, but the temporal tuner sets its quota to zero for an achieved
goal.  A running scheme with a nonzero temporal quota therefore loses a
charge window after a quota-goal commit.

Use the effective quota to preserve the temporal tuner's previous
goal-achievement state during an unmeasured round, as SJ suggested [1]. 
Score the goal as achieved when the effective quota is zero and as not
achieved otherwise.  A new scheme's initially zero quota stays zero, and
the consist tuner's behavior is unchanged.

Move the PSI current-value calculation and last_psi_total update into a
helper that takes the current PSI total.  This lets a unit test cover the
unmeasured and measured rounds without depending on system memory
pressure.

Link: https://lore.kernel.org/20260923055139.2982-1-sj@kernel.org
Link: https://lore.kernel.org/damon/20260916001311.101024-1-sj@kernel.org/ [1]
Fixes: 2dbb60f789cb ("mm/damon/core: implement PSI metric DAMOS quota goal")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Assisted-by: LLM
Cc: Lian Wang <lianux.mm@gmail.com>
Cc: <stable@vger.kernel.org> # 6.9.x
---

 mm/damon/core.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total-fix
+++ a/mm/damon/core.c
@@ -2891,6 +2891,28 @@ static inline u64 damos_get_some_mem_psi
 
 #endif	/* CONFIG_PSI */
 
+static void damos_set_psi_current_val(u64 now_psi_total,
+		struct damos_quota_goal *goal, struct damos *s)
+{
+	u64 last_psi_total = goal->last_psi_total;
+
+	goal->last_psi_total = now_psi_total;
+	if (last_psi_total != U64_MAX) {
+		goal->current_value = now_psi_total - last_psi_total;
+		return;
+	}
+	/* uninitialized last_psi_total; make no effect this round */
+	if (s->quota.goal_tuner == DAMOS_QUOTA_GOAL_TUNER_CONSIST) {
+		goal->current_value = goal->target_value;
+		return;
+	}
+	/* let temporal tuner show the same achievement as in the last round */
+	if (!s->quota.esz)
+		goal->current_value = goal->target_value;
+	else
+		goal->current_value = 0;
+}
+
 #ifdef CONFIG_NUMA
 static bool invalid_mem_node(int nid)
 {
@@ -3143,13 +3165,7 @@ static void damos_set_quota_goal_current
 		break;
 	case DAMOS_QUOTA_SOME_MEM_PSI_US:
 		now_psi_total = damos_get_some_mem_psi_total();
-		/* uninitialized last_psi_total; make no effect this round */
-		if (goal->last_psi_total == U64_MAX)
-			goal->current_value = goal->target_value;
-		else
-			goal->current_value = now_psi_total -
-				goal->last_psi_total;
-		goal->last_psi_total = now_psi_total;
+		damos_set_psi_current_val(now_psi_total, goal, s);
 		break;
 	case DAMOS_QUOTA_NODE_MEM_USED_BP:
 	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
_

Patches currently in -mm which might be from kmehltretter@gmail.com are

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
kcov-report-spurious-pcs-in-the-interrupt-selftest.patch

