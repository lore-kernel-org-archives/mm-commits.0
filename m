Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF6A36AB7C;
	Sat, 18 Apr 2026 07:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498883; cv=none; b=G8W7UfUolETUonCLLPMThv16lrx0xAVcHEkgFMwc2fwwawcChnL+jA4wo1Ed08JnFdXG4LA/8QRgWEykYNWRnxNRw8P9eTRStP+mKBU7UCyjDbI37Wa+6LaIrDvtktwOiYTr98PCMviM+OQ4aYbVa+XVhxppkMk09jXFtXoSWeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498883; c=relaxed/simple;
	bh=/SR37cc+ZFMYnUzaxLING+aOcrduxM8S3E7rO9VuJGo=;
	h=Date:To:From:Subject:Message-Id; b=sVrKxRFuLZO+gr5QO0LI++2YVlqbXbacZbPAvZejWD40RpCwoDK6abI5iiJOAUFO53pYImGc0qFQCNOxj65axECPL909V5T2N7wr49a0dY76qu4lq7ZIrXnyIIBMuugT2/d1LaVCjAtVVDi18kYslezPK6Hx9JK5cqRotX/rrqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XWh7NRil; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XWh7NRil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0321C19424;
	Sat, 18 Apr 2026 07:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498882;
	bh=/SR37cc+ZFMYnUzaxLING+aOcrduxM8S3E7rO9VuJGo=;
	h=Date:To:From:Subject:From;
	b=XWh7NRilETK98aVIS6fFoRkbFcgAQhaYRpg1aFGbfAM72buDLpjB5CgNslGeA2bfB
	 GCWwOJoE7g9Rio1QlXyKE+qTPdchQ1cJmACfxTQxjiVlLiKwe27OUNoyRxalF9TyYi
	 xMR8PjAV4qA5loIt/eKGk2oBIKvbXQlZlqLDPpeQ=
Date: Sat, 18 Apr 2026 00:54:36 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-validate-damos_quota_goal-nid-for-node_mem_usedfree_bp.patch removed from -mm tree
Message-Id: <20260418075440.E0321C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp
has been removed from the -mm tree.  Its filename was
     mm-damon-core-validate-damos_quota_goal-nid-for-node_mem_usedfree_bp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp
Date: Sat, 28 Mar 2026 21:38:59 -0700

Patch series "mm/damon/core: validate damos_quota_goal->nid".

node_mem[cg]_{used,free}_bp DAMOS quota goals receive the node id.  The
node id is used for si_meminfo_node() and NODE_DATA() without proper
validation.  As a result, privileged users can trigger an out of bounds
memory access using DAMON_SYSFS.  Fix the issues.

The issue was originally reported [1] with a fix by another author.  The
original author announced [2] that they will stop working including the
fix that was still in the review stage.  Hence I'm restarting this.


This patch (of 2):

Users can set damos_quota_goal->nid with arbitrary value for
node_mem_{used,free}_bp.  But DAMON core is using those for
si_meminfo_node() without the validation of the value.  This can result in
out of bounds memory access.  The issue can actually triggered using DAMON
user-space tool (damo), like below.

    $ sudo ./damo start --damos_action stat \
    	--damos_quota_goal node_mem_used_bp 50% -1 \
    	--damos_quota_interval 1s
    $ sudo dmesg
    [...]
    [   65.565986] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000098

Fix this issue by adding the validation of the given node.  If an invalid
node id is given, it returns 0% for used memory ratio, and 100% for free
memory ratio.

Link: https://lore.kernel.org/20260329043902.46163-2-sj@kernel.org
Link: https://lore.kernel.org/20260325073034.140353-1-objecting@objecting.org [1]
Link: https://lore.kernel.org/20260327040924.68553-1-sj@kernel.org [2]
Fixes: 0e1c773b501f ("mm/damon/core: introduce damos quota goal metrics for memory node utilization")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-validate-damos_quota_goal-nid-for-node_mem_usedfree_bp
+++ a/mm/damon/core.c
@@ -2217,12 +2217,24 @@ static inline u64 damos_get_some_mem_psi
 #endif	/* CONFIG_PSI */
 
 #ifdef CONFIG_NUMA
+static bool invalid_mem_node(int nid)
+{
+	return nid < 0 || nid >= MAX_NUMNODES || !node_state(nid, N_MEMORY);
+}
+
 static __kernel_ulong_t damos_get_node_mem_bp(
 		struct damos_quota_goal *goal)
 {
 	struct sysinfo i;
 	__kernel_ulong_t numerator;
 
+	if (invalid_mem_node(goal->nid)) {
+		if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
+			return 0;
+		else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
+			return 10000;
+	}
+
 	si_meminfo_node(&i, goal->nid);
 	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
 		numerator = i.totalram - i.freeram;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-disallow-time-quota-setting-zero-esz.patch
mm-damon-core-disallow-non-power-of-two-min_region_sz-on-damon_start.patch

