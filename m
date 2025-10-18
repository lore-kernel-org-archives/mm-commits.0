Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F79B672
	for <mm-commits@vger.kernel.org>; Sat, 18 Oct 2025 00:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760746791; cv=none; b=cZ2+2Fil4doQm1udyr54UaEO05xvloqfue5dA6I3/y+wQ3bHFdDcj1CTcXOVnUMMErdYI01ek5kIYrA0pmX5mubo4nEYF1baMVj6CPmduQWz/CpBkvN47pqlbsCzP9SqfjQZLrfUwALCY2v5h8PFhW41wqcJBJ6hsIj/YI4EBRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760746791; c=relaxed/simple;
	bh=2Aj+MxVfEe3BMJuh9JgPotRroNPP2weysdxM7Vwl/XM=;
	h=Date:To:From:Subject:Message-Id; b=W8RNmopyj28lI7bmca9+u8G/Cz8vGfUtcPhtmxpHKiatrOFAzBeRnPU97ElQOvPNEOFNHBHm97pS+ANrvK7dID0V+MNfEPrIfXmVucb+EZNTWPTGomvhMxFeZbSnA7lgcFcX7jrIFKxYnh0nMspgfY+lisido8zphbzX5oNHRRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=baLbv8dK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="baLbv8dK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4753AC4CEE7;
	Sat, 18 Oct 2025 00:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760746791;
	bh=2Aj+MxVfEe3BMJuh9JgPotRroNPP2weysdxM7Vwl/XM=;
	h=Date:To:From:Subject:From;
	b=baLbv8dKhn+Df/dOsHCv8fu4UWpE97wP2YCkbsxPzBg0r/7RyDlnqGoEkjO3g7AGG
	 AJYju1R+118eJYsHbR2ys4z8qq7btycIH1QwCeyvWCS1MXPjMa5XceR90HbfcVSWKK
	 V+BiLP7/MuoPxGMU5vKqg9yxAwyCqAjohkJQ9CoY=
Date: Fri, 17 Oct 2025 17:19:50 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-support-damos_quota_node_memcg_free_bp.patch added to mm-new branch
Message-Id: <20251018001951.4753AC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: support DAMOS_QUOTA_NODE_MEMCG_FREE_BP
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-schemes-support-damos_quota_node_memcg_free_bp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-support-damos_quota_node_memcg_free_bp.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: support DAMOS_QUOTA_NODE_MEMCG_FREE_BP
Date: Fri, 17 Oct 2025 14:26:59 -0700

Extend DAMON sysfs to support DAMOS_QUOTA_NODE_MEMCG_FREE_BP.

Link: https://lkml.kernel.org/r/20251017212706.183502-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-support-damos_quota_node_memcg_free_bp
+++ a/mm/damon/sysfs-schemes.c
@@ -1034,6 +1034,10 @@ struct damos_sysfs_qgoal_metric_name dam
 		.metric = DAMOS_QUOTA_NODE_MEMCG_USED_BP,
 		.name = "node_memcg_used_bp",
 	},
+	{
+		.metric = DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
+		.name = "node_memcg_free_bp",
+	},
 };
 
 static ssize_t target_metric_show(struct kobject *kobj,
@@ -2552,6 +2556,7 @@ static int damos_sysfs_add_quota_score(
 			goal->nid = sysfs_goal->nid;
 			break;
 		case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
+		case DAMOS_QUOTA_NODE_MEMCG_FREE_BP:
 			err = damon_sysfs_memcg_path_to_id(
 					sysfs_goal->path, &goal->memcg_id);
 			if (err) {
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-fix-list_add_tail-call-on-damon_call.patch
mm-damon-core-use-damos_commit_quota_goal-for-new-goal-commit.patch
mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch
mm-damon-document-damos_quota_goal-nid-use-case.patch
mm-damon-add-damos-quota-goal-type-for-per-memcg-per-node-memory-usage.patch
mm-damon-core-implement-damos_quota_node_memcg_used_bp.patch
mm-damon-sysfs-schemes-implement-path-file-under-quota-goal-directory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_used_bp.patch
mm-damon-core-add-damos-quota-gaol-metric-for-per-memcg-per-numa-free-memory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_free_bp.patch
docs-mm-damon-design-document-damos_quota_node_memcg_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-damos-quota-goal-path-file.patch
docs-abi-damon-document-damos-quota-goal-path-file.patch

