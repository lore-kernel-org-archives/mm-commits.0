Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB72BA3D;
	Fri, 25 Jul 2025 00:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753405111; cv=none; b=V0Ub+ddkANm3maP7k1BaJAc5JjChjTcEjHNRd5VKbxNNk+R8tKWKC8aDQSfKWMhzQ3TzKELv8xtwtPq8utgFz/kshmQGBDTQwvxFrZ9GSbIEAG5OhEsyWtw7/o2tDJalOiSltArIqxMk5KIXZ2I3MgEslvqS8i7EuDugQv6epv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753405111; c=relaxed/simple;
	bh=/sWG7Hu8uNEY3A5D6seheMXhvyuh2famuFqzPqgiKPk=;
	h=Date:To:From:Subject:Message-Id; b=K2bdNMeijLGEISRZx+4Mx6N9dmaBqMzCnnO9vgJO/WngjvzR/XCWoepH8HA+H8ZXbMNJFWxCKR09CGDVeKCwg01Nc21Hi0FfpEiU0TQYSpyprFvmDjS3XfPkLZuXM1Tj0QhYDDwam5pVUWCO8lWUymxvpZ6aWz3DK6OX8kOaw6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MluffViY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MluffViY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F76C4CEED;
	Fri, 25 Jul 2025 00:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753405111;
	bh=/sWG7Hu8uNEY3A5D6seheMXhvyuh2famuFqzPqgiKPk=;
	h=Date:To:From:Subject:From;
	b=MluffViYyT2yr2O6YRvukwgEOWpmbTzt0ITcfv5BiY/RYJeO/8nmSM/NwiHzskcUj
	 utSzgbCQqDM7KoDY7EILt9YCtNVPPXepLEvBv9+WQoWgDZoZbL12dipKh7B+xzvcy/
	 U3H2gf0fwp5FsaNRQkrFJciiQSp4w+WbyFaSPavU=
Date: Thu, 24 Jul 2025 17:58:30 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-commit-damos_quota_goal-nid.patch removed from -mm tree
Message-Id: <20250725005831.37F76C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: commit damos_quota_goal->nid
has been removed from the -mm tree.  Its filename was
     mm-damon-core-commit-damos_quota_goal-nid.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: commit damos_quota_goal->nid
Date: Sat, 19 Jul 2025 11:19:32 -0700

DAMOS quota goal uses 'nid' field when the metric is
DAMOS_QUOTA_NODE_MEM_{USED,FREE}_BP.  But the goal commit function is not
updating the goal's nid field.  Fix it.

Link: https://lkml.kernel.org/r/20250719181932.72944-1-sj@kernel.org
Fixes: 0e1c773b501f ("mm/damon/core: introduce damos quota goal metrics for memory node utilization")	[6.16.x]
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-commit-damos_quota_goal-nid
+++ a/mm/damon/core.c
@@ -754,6 +754,19 @@ static struct damos_quota_goal *damos_nt
 	return NULL;
 }
 
+static void damos_commit_quota_goal_union(
+		struct damos_quota_goal *dst, struct damos_quota_goal *src)
+{
+	switch (dst->metric) {
+	case DAMOS_QUOTA_NODE_MEM_USED_BP:
+	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
+		dst->nid = src->nid;
+		break;
+	default:
+		break;
+	}
+}
+
 static void damos_commit_quota_goal(
 		struct damos_quota_goal *dst, struct damos_quota_goal *src)
 {
@@ -762,6 +775,7 @@ static void damos_commit_quota_goal(
 	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
 		dst->current_value = src->current_value;
 	/* keep last_psi_total as is, since it will be updated in next cycle */
+	damos_commit_quota_goal_union(dst, src);
 }
 
 /**
@@ -795,6 +809,7 @@ int damos_commit_quota_goals(struct damo
 				src_goal->metric, src_goal->target_value);
 		if (!new_goal)
 			return -ENOMEM;
+		damos_commit_quota_goal_union(new_goal, src_goal);
 		damos_add_quota_goal(dst, new_goal);
 	}
 	return 0;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch
mm-damon-ops-common-ignore-migration-request-to-invalid-nodes.patch
selftests-damon-sysfspy-stop-damon-for-dumping-failures.patch
selftests-damon-_damon_sysfs-support-damos-watermarks-setup.patch
selftests-damon-_damon_sysfs-support-damos-filters-setup.patch
selftests-damon-_damon_sysfs-support-monitoring-intervals-goal-setup.patch
selftests-damon-_damon_sysfs-support-damos-quota-weights-setup.patch
selftests-damon-_damon_sysfs-support-damos-quota-goal-nid-setup.patch
selftests-damon-_damon_sysfs-support-damos-action-dests-setup.patch
selftests-damon-_damon_sysfs-support-damos-target_nid-setup.patch
selftests-damon-_damon_sysfs-use-232-1-as-max-nr_accesses-and-age.patch
selftests-damon-drgn_dump_damon_status-dump-damos-migrate_dests.patch
selftests-damon-drgn_dump_damon_status-dump-ctx-opsid.patch
selftests-damon-drgn_dump_damon_status-dump-damos-filters.patch
selftests-damon-sysfspy-generalize-damos-watermarks-commit-assertion.patch
selftests-damon-sysfspy-generalize-damosquota-commit-assertion.patch
selftests-damon-sysfspy-test-quota-goal-commitment.patch
selftests-damon-sysfspy-test-damos-destinations-commitment.patch
selftests-damon-sysfspy-generalize-damos-scheme-commit-assertion.patch
selftests-damon-sysfspy-test-damos-filters-commitment.patch
selftests-damon-sysfspy-generalize-damos-schemes-commit-assertion.patch
selftests-damon-sysfspy-generalize-monitoring-attributes-commit-assertion.patch
selftests-damon-sysfspy-generalize-damon-context-commit-assertion.patch
selftests-damon-sysfspy-test-non-default-parameters-runtime-commit.patch
selftests-damon-sysfspy-test-runtime-reduction-of-damon-parameters.patch

