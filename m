Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA7231A81F
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486760; cv=none; b=od1QSxLbF6YNF6a+RuydEzuL9P907O5lPrk8/d9SQ0SbdcieyeaTJO4RkJO7nvxatv1EZMG8ahF70UMrgBttEutRTcZT8SHZU84HErUwkN6ylUtoszK3oigeNcpsvJLJGPjsm/ta9u/W/9jqMcwyDraQljkRnoDvUeRHrBzv1rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486760; c=relaxed/simple;
	bh=1mqsPW9i0/GHQcDFM98bLkzib+AGbctXUCNbzmXj5fU=;
	h=Date:To:From:Subject:Message-Id; b=a8zVlXke98G/mFylpJfBxB6HWiBIl5v5tpVMkgrl/wBJNECz9A7+5IlHuLB62BZDwAWwzh5/Z2DdbYJCIPfIj07jQ9bz+MW5qO2abD1mfTb4Xbapk+EwHQzG+TB5YP6fe2MPvvliW9FfZ3Qb+j8U2R2FMkqIDHpTWr2q47cDTIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I9S1Oocf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I9S1Oocf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86285C116C6;
	Tue, 27 Jan 2026 04:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486760;
	bh=1mqsPW9i0/GHQcDFM98bLkzib+AGbctXUCNbzmXj5fU=;
	h=Date:To:From:Subject:From;
	b=I9S1OocfLYvpjGZMUxAqJgvWk7oNBBov6DVsb3q7qQy3GYRvFTgQUh96sR3m9iQ02
	 vPsn5OTCvGEELcRP6Q0pkRkwZ57yR+alr6BKbbKYfN/42bzgYE8K/asWiMAE+pGT5p
	 kZArDpQu5QV1I+tj4rLMBdktUyucUoJR1z8oHpDI=
Date: Mon, 26 Jan 2026 20:06:00 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-use-damon_kdamond_pid.patch removed from -mm tree
Message-Id: <20260127040600.86285C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/lru_sort: use damon_kdamond_pid()
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-use-damon_kdamond_pid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/lru_sort: use damon_kdamond_pid()
Date: Thu, 15 Jan 2026 07:20:43 -0800

DAMON_LRU_SORT directly uses damon_ctx->kdamond field with manual
synchronization using damon_ctx->kdamond_lock, to get the pid of the
kdamond.  Use a new dedicated function for the purpose, namely
damon_kdamond_pid(), since that doesn't require manual and error-prone
synchronization.

Link: https://lkml.kernel.org/r/20260115152047.68415-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-use-damon_kdamond_pid
+++ a/mm/damon/lru_sort.c
@@ -405,7 +405,9 @@ static int damon_lru_sort_turn(bool on)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
-	kdamond_pid = ctx->kdamond->pid;
+	kdamond_pid = damon_kdamond_pid(ctx);
+	if (kdamond_pid < 0)
+		return kdamond_pid;
 	return damon_call(ctx, &call_control);
 }
 
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

