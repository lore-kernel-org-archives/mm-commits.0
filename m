Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF7614AD2D;
	Sat, 19 Jul 2025 23:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752967181; cv=none; b=pc9+krQ45UPl/UnqQgcl0l6kUHwuKC0Jtb4QGKbto8wa3Zlcy3c9/h4nhXtsdNMW607Adi9g4jxpbh/HT4wXEKV3CQUb8rfC+wrGKLew00MbRfc+UB0NKog2hvk6adgdds+dU2CkfcDJLQqZbQgrr6caKMZsxleRN9hDaN8EkPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752967181; c=relaxed/simple;
	bh=unr7d9huxr+RkXauWCpvKmPkIN/uY3TOY7mhLnHXMJQ=;
	h=Date:To:From:Subject:Message-Id; b=WwpWzS1nNkng7HKohl6qsKxZIOeYM5vPdu55IBjAK2e/Y58hFl66c3zI8+LOEYrv9l9UsSv1hpJwL1dZarMPjbQndZK6NlQ1PeYdCDwzst8N3Jr5lvr2nhvQc7pqPVYe0EOvVztECFG8E2eMaqLDXIf/etL2KYRKTlQ+DfNeS30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MJxK2l6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MJxK2l6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B770C4CEE3;
	Sat, 19 Jul 2025 23:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752967181;
	bh=unr7d9huxr+RkXauWCpvKmPkIN/uY3TOY7mhLnHXMJQ=;
	h=Date:To:From:Subject:From;
	b=MJxK2l6pXQ28AU4aMGiwcQN22uuJgnunGceUSIS8PP+0A45Smbw7EH2bZqi1jXsmC
	 ZuSSbpZS+AJBJ313oLFY+k91t0lZB4iRGCgagSZPsgSm1EZCvqgx6QihYmYsROQ753
	 FISfTFXNTKGNlXOMEAyzbv4DuSEwRFfk1cp2HhJ4=
Date: Sat, 19 Jul 2025 16:19:40 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-commit-damos_quota_goal-nid.patch added to mm-hotfixes-unstable branch
Message-Id: <20250719231941.2B770C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: commit damos_quota_goal->nid
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-commit-damos_quota_goal-nid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-commit-damos_quota_goal-nid.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-core-commit-damos_quota_goal-nid.patch
samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch
mm-damon-accept-parallel-damon_call-requests.patch
mm-damon-core-introduce-repeat-mode-damon_call.patch
mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-reclaim-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-core-do-not-call-opscleanup-when-destroying-targets.patch
mm-damon-core-add-cleanup_target-ops-callback.patch
mm-damon-core-add-cleanup_target-ops-callback-fix.patch
mm-damon-core-add-cleanup_target-ops-callback-fix-2.patch
mm-damon-vaddr-put-pid-in-cleanup_target.patch
mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch
mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch
mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch
mm-damon-core-remove-damon_callback.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

