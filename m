Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFCA31A81F
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486761; cv=none; b=pc1fGi/rXOkU99rQ2AeT4XGl+sfn7mi3klSaqLtBwHJoITugCFwHwaoFwf980zWzAi2VdlCxuEdUVweONS2SjnIR5wHXBR4btwUCRwiQXOJIQFqdZB9MZyV2ExwWTDCGufIjFgh2979z9m3uIcX6V39+H624CpQa+2p85y7zvrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486761; c=relaxed/simple;
	bh=1trSuo3GCwg+P6x2r03LivW5m5o+Fw1Njemsbh+oVOw=;
	h=Date:To:From:Subject:Message-Id; b=IIYLdsYFWXz9tIQzjBPTt44383pm66dOaSV5rpxYyDflZUE/jAGef0HGo4Iz3r8zog1EmfWao9diWvmAjW7l6hPfQVdZpgCHnrVnJFO8ijDfWNjny1CFNfpZFMSQAQJp6SBBgLA7UstGiI+onWJqL7KbjrSar0b1waoCDf3Ks4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CRYrn9vP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CRYrn9vP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C2AC116C6;
	Tue, 27 Jan 2026 04:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486761;
	bh=1trSuo3GCwg+P6x2r03LivW5m5o+Fw1Njemsbh+oVOw=;
	h=Date:To:From:Subject:From;
	b=CRYrn9vPLLmqlvwck8W1UtMzRDtgR5SVPIFMUs750yHb4qxnBopmEmcqkfJFt3V+6
	 IliXpGsWlrc5knSHXN1a2QZ6v/uyBHSUkYMLb0OQ2o5VXSoWHGMJzntY5O0TEIMzmF
	 jWScCdlEwkl0RxOtiURUiT9YwqBAHaZSggBrJV80=
Date: Mon, 26 Jan 2026 20:06:01 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-use-damon_kdamond_pid.patch removed from -mm tree
Message-Id: <20260127040601.A3C2AC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/reclaim: use damon_kdamond_pid()
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-use-damon_kdamond_pid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: use damon_kdamond_pid()
Date: Thu, 15 Jan 2026 07:20:44 -0800

DAMON_RECLAIM directly uses damon_ctx->kdamond field with manual
synchronization using damon_ctx->kdamond_lock, to get the pid of the
kdamond.  Use a new dedicated function for the purpose, namely
damon_kdamond_pid(), since that doesn't require manual and error-prone
synchronization.

Link: https://lkml.kernel.org/r/20260115152047.68415-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-use-damon_kdamond_pid
+++ a/mm/damon/reclaim.c
@@ -307,7 +307,9 @@ static int damon_reclaim_turn(bool on)
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

