Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629453BBA0B
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 16:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495218; cv=none; b=DojV/7Of4I71Ae32BDv7QaZIIyLc6cMbftCO1B3jSKFlPKEzX1rda3bCAMi2nVEoN/GlsmojKeOvJVLoIeQd1YdhBLHazoA2s78CU+0LPkOIQnlpiIeVlQxIMLLfsgaxDoxy135DUafy+1nuj3CzNEUHUEOTXT57mQ6nX8tDdA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495218; c=relaxed/simple;
	bh=1lvnepn7sehXHxE85Mu511FNMqGabp8ol6fHfRaJAfg=;
	h=Date:To:From:Subject:Message-Id; b=TfAfOnMvzJEGGwMgvYdwaX13twoHAwSM1TV39RMT6B03aDTl31Dh9CQY8inMya7/xzHEV27PEaSHzw9XRsCu9f1z1CStHB68vL+GV6QAk8yzIaR+ClEtG8VNsdyQFD9GWi++S/46LXWIM75MitPyrXH5gY9iuUYRTUnNTqApzHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xOO2Cwt5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xOO2Cwt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF1EC116D0;
	Thu, 15 Jan 2026 16:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768495218;
	bh=1lvnepn7sehXHxE85Mu511FNMqGabp8ol6fHfRaJAfg=;
	h=Date:To:From:Subject:From;
	b=xOO2Cwt5JHkf3pBwRwLEbmjv3piU5DMJxzBEoO2hRGYrEdzXFeq2dRaMkPSMUJXOd
	 4T3RiJvsCyvYGoPE/3I8653IvbrxaFw9x4tbHzKYWIIo8faG2vNpirPZeNCU/RDufm
	 OCKX1G4eNh0+aUH6A4gZQvtLjlk9rW8qyikdxKHs=
Date: Thu, 15 Jan 2026 08:40:17 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-use-damon_kdamond_pid.patch added to mm-new branch
Message-Id: <20260115164017.DEF1EC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/lru_sort: use damon_kdamond_pid()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-lru_sort-use-damon_kdamond_pid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-use-damon_kdamond_pid.patch

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

