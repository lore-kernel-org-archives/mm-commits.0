Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478773B960F
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 16:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495216; cv=none; b=snqc4ZcAKz7ieVvXhhUELPc2KNxjzg3Fcoma+Sn+WQW7kwcVmmy4FqGfGWP1SPfW4xKVbWDuwz+iRNFKWyUE/bjw/3ESgHIyiITiYFRoBlSC4gjqbtZLDMOMCqZ4q02PrmdPL4Jww+Zib0PqJvrsyWFlm5TSipkhzognf+DZRCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495216; c=relaxed/simple;
	bh=O+vVOjB+u5ZnRArjQmTCxa0G+6AnI4nfcwcq8/MW8Tg=;
	h=Date:To:From:Subject:Message-Id; b=VoDCau89ZwQijYcv3pX8MfPL0ZcmFN+JtVSlNYV2pZRTo6v3m0GeMaXmJxwFx8bro9vUu8d7TMcVXKlaRhy1ehpkyCg9GdvjWISP/4ANu07ttmMSPEN0WLa2lihdQJboM8oR7KRN+TvqohIowf3FW0PtNK6OqCB51fwEicKu7nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a81+EfwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a81+EfwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8AFC116D0;
	Thu, 15 Jan 2026 16:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768495215;
	bh=O+vVOjB+u5ZnRArjQmTCxa0G+6AnI4nfcwcq8/MW8Tg=;
	h=Date:To:From:Subject:From;
	b=a81+EfwJ0tu0dR3lopOE0JSdl/AT9+ST3W8hzmxASzQ6kKzCIvBnEx3AdaTTnP3Ff
	 CKqwRCXjtFxGob5HVcNnEOw0ZX9gS5EpSVNTu8+YiB2zinRHqZ8aBMpk0WVfy7K+UV
	 BCWpBqttn/Ay3UBqrdL3Y6fOiQRVjrRCS8Ajwe9I=
Date: Thu, 15 Jan 2026 08:40:15 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-use-damon_kdamond_pid.patch added to mm-new branch
Message-Id: <20260115164015.DD8AFC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: use damon_kdamond_pid()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-use-damon_kdamond_pid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-use-damon_kdamond_pid.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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

mm-damon-core-introduce-nr_snapshots-damos-stat.patch
mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file.patch
docs-mm-damon-design-update-for-nr_snapshots-damos-stat.patch
docs-admin-guide-mm-damon-usage-update-for-nr_snapshots-damos-stat.patch
docs-abi-damon-update-for-nr_snapshots-damos-stat.patch
mm-damon-update-damos-kerneldoc-for-stat-field.patch
mm-damon-core-implement-max_nr_snapshots.patch
mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch
docs-mm-damon-design-update-for-max_nr_snapshots.patch
docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch
docs-abi-damon-update-for-max_nr_snapshots.patch
mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch
mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of-fix.patch
mm-damon-core-introduce-active-memory-ratio-damos-quota-goal-metric.patch
mm-damon-sysfs-schemes-support-damos_quota_active_mem_bp.patch
docs-mm-damon-design-document-damos_quota_active_mem_bp.patch
mm-damon-paddr-activate-damos_lru_prio-targets-instead-of-marking-accessed.patch
mm-damon-lru_sort-consider-age-for-quota-prioritization.patch
mm-damon-lru_sort-support-young-page-filters.patch
docs-admin-guide-mm-damon-lru_sort-document-filter_young_pages.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning.patch
docs-admin-guide-mm-damon-lru_sort-document-active_mem_bp-parameter.patch
mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-intervals-autotuning.patch
mm-damon-core-implement-damon_kdamond_pid.patch
mm-damon-sysfs-use-damon_kdamond_pid.patch
mm-damon-lru_sort-use-damon_kdamond_pid.patch
mm-damon-reclaim-use-damon_kdamond_pid.patch
mm-damon-hide-kdamond-and-kdamond_lock-of-damon_ctx.patch

