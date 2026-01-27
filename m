Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9297431A81F
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486759; cv=none; b=lyqESISE2xj9xjBRUgc5/QFpCIXz3bqh746WLNdNj4zVShWNzoDZfOZCzYagYtcgytQxrKVHuf31gOV2MhhT2tH/IyzVVphtxz4RDAPLm3JwJW3daxqm5yJgosR41c16oaGuZeoi2CwsBDpVEFxqkrmiS4MwjfitiwqeFVRTPdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486759; c=relaxed/simple;
	bh=dhKDr0B+O3KdRkgtdv1wCUNo+lj0gtwDMzaoUIXeqVc=;
	h=Date:To:From:Subject:Message-Id; b=W/oP0FAqHqzGobZQHIbognum9xLHSgC244+JtiyUQVUQWqZbFNrXxbp2hjiZRBDR4BDkRF85KOqaJTXzyWqMAD8OuwkAfChzBzmHGHX7fJ+MT44Qo2Wmh419Xfz7S5mymYSIwUDYVsnwOo0JQgD3zJ5Lklj1UASHlcw40fRCQwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H1/jQc1c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H1/jQc1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE12C116C6;
	Tue, 27 Jan 2026 04:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486759;
	bh=dhKDr0B+O3KdRkgtdv1wCUNo+lj0gtwDMzaoUIXeqVc=;
	h=Date:To:From:Subject:From;
	b=H1/jQc1c+bx1fgVNwL0jTLDjxBz3R35c7fpAFFrwSv68FWGm9QIQWAzxLLOpSpOeH
	 oMI1CrdnRJ7uiNny65KwmwJPuh9d+qIVF7PPd/s+yTfKTUErWit2nHbCty0PU8RV3L
	 dsuCoQUtuq1lqgY4tb+wQli9oilcYAjZAtVdRcOg=
Date: Mon, 26 Jan 2026 20:05:58 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-use-damon_kdamond_pid.patch removed from -mm tree
Message-Id: <20260127040559.6BE12C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: use damon_kdamond_pid()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-use-damon_kdamond_pid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: use damon_kdamond_pid()
Date: Thu, 15 Jan 2026 07:20:42 -0800

DAMON sysfs interface directly uses damon_ctx->kdamond field with manual
synchronization using damon_ctx->kdamond_lock, to get the pid of the
kdamond.  Use a new dedicated function for the purpose, namely
damon_kdamond_pid(), since that doesn't require manual and error-prone
synchronization.

Avoid use of kdamond_lock outside of the core.

Link: https://lkml.kernel.org/r/20260115152047.68415-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-use-damon_kdamond_pid
+++ a/mm/damon/sysfs.c
@@ -1819,10 +1819,9 @@ static ssize_t pid_show(struct kobject *
 	if (!ctx)
 		goto out;
 
-	mutex_lock(&ctx->kdamond_lock);
-	if (ctx->kdamond)
-		pid = ctx->kdamond->pid;
-	mutex_unlock(&ctx->kdamond_lock);
+	pid = damon_kdamond_pid(ctx);
+	if (pid < 0)
+		pid = -1;
 out:
 	mutex_unlock(&damon_sysfs_lock);
 	return sysfs_emit(buf, "%d\n", pid);
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak.patch
selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size.patch
selftests-damon-access_memory-add-repeat-mode.patch
selftests-damon-wss_estimation-ensure-number-of-collected-wss.patch
selftests-damon-wss_estimation-deduplicate-failed-samples-output.patch
mm-damon-remove-damon_operations-cleanup.patch
mm-damon-core-cleanup-targets-and-regions-at-once-on-kdamond-termination.patch
mm-damon-core-cancel-damos_walk-before-damon_ctx-kdamond-reset.patch
mm-damon-core-process-damon_call_control-requests-on-a-local-list.patch
mm-damon-document-damon_call_control-dealloc_on_cancel-repeat-behavior.patch
mm-damon-core-rename-damos_filter_out-to-damos_core_filter_out.patch
mm-damon-rename-damon_min_region-to-damon_min_region_sz.patch
mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz.patch
docs-mm-damon-index-simplify-the-intro.patch
docs-mm-damon-design-link-repology-instead-of-fedora-package.patch
docs-mm-damon-design-document-damon-sample-modules.patch
docs-mm-damon-design-add-reference-to-damon_stat-usage.patch
docs-admin-guide-mm-damon-usage-introduce-damon-modules-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-stats-update-process-for-refresh_ms.patch
docs-mm-damon-maintainer-profile-fix-wrong-maitnainers-section-name.patch
docs-mm-damon-maintainer-profile-remove-damon-tests-perf-suggestion.patch
maple_tree-start-using-maple-copy-node-for-destination-fix.patch

