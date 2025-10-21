Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E18B2D24A1;
	Tue, 21 Oct 2025 22:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761086821; cv=none; b=ZhRaKCTNf6uQbpcqiQ+hCIGtjBPWsYBiXjREMDUbzJMS9ECWVgpq0oW4vP2L1DWvEOsMLx7BEYzQS72d9DPOaIFq/DUujVFZL7ukRQ+utG4FnpkEkmWmMlM4voVgHWQ1MDYtnaP74preHpr00ofCiySyT/qb1BKxJJutr7wM7ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761086821; c=relaxed/simple;
	bh=19cb4H6SqfY/3wNBmp4ldJBkHN34eCNvBebpwNKZeYo=;
	h=Date:To:From:Subject:Message-Id; b=qLpvcsBgHTUljqczPOIiRk3XKzm/GMNc7UMDrZuxpvX8UkycmAOif+bNnvxN+CRyjFjeKw/YxJ1xjSluAd9Bwpk1nz+HjteZvabSTinZmv5O11r0bUbOPmLsqfbIzB4sMo3h5NqLc451r8Z12oonUkejublMvZrMbyMpetqyK6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fj0s0kN3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fj0s0kN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A882C4CEF1;
	Tue, 21 Oct 2025 22:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761086820;
	bh=19cb4H6SqfY/3wNBmp4ldJBkHN34eCNvBebpwNKZeYo=;
	h=Date:To:From:Subject:From;
	b=fj0s0kN3sRgLzLaa/mmnBI6/X9+lue/O6Y6k4F8fuuxw3PcSL86HrpKbC3WEffEHS
	 nD+YuOR47w0vYq0dAdQZl2ZZnMLOlJgUj52mF48zpgRK2C20eDvN1xq1AgYmLWL83F
	 Wqt3XXIW95OBE9CZZK3/iQxRSRQiGWdF9DUdh7OQ=
Date: Tue, 21 Oct 2025 15:46:59 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-use-damos_commit_quota_goal-for-new-goal-commit.patch removed from -mm tree
Message-Id: <20251021224700.8A882C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: use damos_commit_quota_goal() for new goal commit
has been removed from the -mm tree.  Its filename was
     mm-damon-core-use-damos_commit_quota_goal-for-new-goal-commit.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: use damos_commit_quota_goal() for new goal commit
Date: Mon, 13 Oct 2025 17:18:44 -0700

When damos_commit_quota_goals() is called for adding new DAMOS quota goals
of DAMOS_QUOTA_USER_INPUT metric, current_value fields of the new goals
should be also set as requested.

However, damos_commit_quota_goals() is not updating the field for the
case, since it is setting only metrics and target values using
damos_new_quota_goal(), and metric-optional union fields using
damos_commit_quota_goal_union().  As a result, users could see the first
current_value parameter that committed online with a new quota goal is
ignored.  Users are assumed to commit the current_value for
DAMOS_QUOTA_USER_INPUT quota goals, since it is being used as a feedback. 
Hence the real impact would be subtle.  That said, this is obviously not
intended behavior.

Fix the issue by using damos_commit_quota_goal() which sets all quota goal
parameters, instead of damos_commit_quota_goal_union(), which sets only
the union fields.

Link: https://lkml.kernel.org/r/20251014001846.279282-1-sj@kernel.org
Fixes: 1aef9df0ee90 ("mm/damon/core: commit damos_quota_goal->nid")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.16+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-use-damos_commit_quota_goal-for-new-goal-commit
+++ a/mm/damon/core.c
@@ -835,7 +835,7 @@ int damos_commit_quota_goals(struct damo
 				src_goal->metric, src_goal->target_value);
 		if (!new_goal)
 			return -ENOMEM;
-		damos_commit_quota_goal_union(new_goal, src_goal);
+		damos_commit_quota_goal(new_goal, src_goal);
 		damos_add_quota_goal(dst, new_goal);
 	}
 	return 0;
_

Patches currently in -mm which might be from sj@kernel.org are

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

