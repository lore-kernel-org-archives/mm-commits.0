Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EAB41E6A7;
	Thu, 24 Sep 2026 20:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790280175; cv=none; b=gL+DucTdMazetwntq0qtX2WGXPlO+g11XyKVhdWH3FB7CKrXLjLQuH6pBcE8HonkoKnNGuXy0ekmLlwkFeT8IZcIc0lx0KipZ9RkqnypHW1gkMIXygnMokjqbqk4YaDs5P5RDhoVamm74yhm33t/w/rXSAO85ChyhjtYgvE6oZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790280175; c=relaxed/simple;
	bh=o3VRR0FuL3q7gOJw+LSUA6dn5YSOIa6Al5wLUS2hzKM=;
	h=Date:To:From:Subject:Message-Id; b=JKCcfSy1njUpxMaxnND+9yGBf/mvF3mk2BaCSQtedvhQ7RTaAchatNpFbo2+MQWFSVM4TWXaYv0irwypgJ7XEX54G+ePzkHfODmh7SQaITcnOvSr11YVNthjO21yM6RG2suSK87VwyQG21RzHnwTtq6HTLfo4DxU2yZc1IqAXcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lkd53KPA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lkd53KPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A682A1F00893;
	Thu, 24 Sep 2026 20:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790280173;
	bh=i5l56kRbRV7H3NKFZT1LiHWv2KDCLKjsEL6LxvlHkIk=;
	h=Date:To:From:Subject;
	b=lkd53KPA6Q5wVu5u5UvnfdXtx+r7fDTjwoXXUGeEXYbLCaM/Sc4SeJFsJKi4o4Pm7
	 sxGREnzj4tG1b3eNnvdMfZ5k7CxkSFH0bse+8TiJEyEsyM+kMtdfEqqlm0i6RUMV/G
	 aEhU0jNuHd64HdRq6xz5HD5DzXjMW0HeWHoaVyVc=
Date: Thu, 24 Sep 2026 13:02:53 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,lianux.mm@gmail.com,kunwu.chan@gmail.com,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total-fix.patch added to mm-unstable branch
Message-Id: <20260924200253.A682A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: keep the temporal tuner quota over an unmeasured PSI round
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total-fix.patch

This patch will later appear in the mm-unstable branch at
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

Assisted-by: LLM
Link: https://lore.kernel.org/20260923055139.2982-1-sj@kernel.org
Link: https://lore.kernel.org/damon/20260916001311.101024-1-sj@kernel.org/ [1]
Fixes: 2dbb60f789cb ("mm/damon/core: implement PSI metric DAMOS quota goal")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
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

mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total-fix.patch
docs-mm-ksm-use-the-renamed-ksm-structure-names.patch
mm-secretmem-fix-the-enable-parameter-description.patch
klist-avoid-accesses-after-waking-klist_remove.patch
squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch
fork-honor-task_structs-declared-alignment.patch
ocfs2-cluster-hold-a-reference-on-the-heartbeat-thread.patch

