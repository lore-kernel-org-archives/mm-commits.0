Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9C579CD
	for <mm-commits@vger.kernel.org>; Fri, 16 Jan 2026 00:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768521799; cv=none; b=k60aWosAZZWW7Ewp/Ou1YfcQWWVtjhl6FZyzr+123qTfXtB9aQeFC1CKPpAKIiozzoL8Lp/7D9c4gNO7UQOkpcJkpEACPHPbQK3TGHEe4mmiaJtfUccTmpNbNXH6/rigWKUhiFB4/NFULUBfruem1fs3/BnYwunobLqkRfwRYdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768521799; c=relaxed/simple;
	bh=xcquJRe7IkPTMMhXeBK3cIYSA0jEXj4LtKOJVwhd0KY=;
	h=Date:To:From:Subject:Message-Id; b=LQ+9e8uOUwezZ47ArWbGHpdwwCrd9f9a3vhmXM0ozRcmh9cxJDXWmQOKcKeTEn/bwSLjIjBxWzPEBHZl6huk5LCvgcvBSk0GMpvq90O4Xaq8u7VT0pTZkM/G8csTkMdKl0eLVzJ19A+SJrWOCIIRDzXf2R0ij91StoYgUQkMi+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UCMH1Hu+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UCMH1Hu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA47BC116D0;
	Fri, 16 Jan 2026 00:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768521798;
	bh=xcquJRe7IkPTMMhXeBK3cIYSA0jEXj4LtKOJVwhd0KY=;
	h=Date:To:From:Subject:From;
	b=UCMH1Hu+1BGfkv0W1vvtLTiBd4L2wH2sqU+PDdoqrbTArtKtaEzxWKfKqfux1fiSG
	 IAt8PxY9YsKgl/LKJev6SkUJv3CbuKI9vph2vOEszJbcHh4WDgZMeoRN72rVb81kdn
	 q7xGu/aT0xipV7fwPPfDZUCsbwxsPZeIydd+YS5Y=
Date: Thu, 15 Jan 2026 16:03:18 -0800
To: mm-commits@vger.kernel.org,lianux.mm@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning-fix.patch added to mm-unstable branch
Message-Id: <20260116000318.AA47BC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/lru_sort: add inactive mem ratio quota goal to cold_scheme
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/damon/lru_sort: add inactive mem ratio quota goal to cold_scheme
Date: Tue, 13 Jan 2026 21:48:53 -0800

damon_lru_sort_add_quota_goals() is adding inactive memory ratio quota
goal, which is for cold pages scheme, to hot pages scheme.  Fix it.

Link: https://lkml.kernel.org/r/20260114055308.79884-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: wang lian <lianux.mm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning-fix
+++ a/mm/damon/lru_sort.c
@@ -238,7 +238,7 @@ static int damon_lru_sort_add_quota_goal
 			10000 - active_mem_bp + 2);
 	if (!goal)
 		return -ENOMEM;
-	damos_add_quota_goal(&hot_scheme->quota, goal);
+	damos_add_quota_goal(&cold_scheme->quota, goal);
 	return 0;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-nr_snapshots-damos-stat.patch
mm-damon-core-introduce-nr_snapshots-damos-stat-fix.patch
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
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning-fix.patch
docs-admin-guide-mm-damon-lru_sort-document-active_mem_bp-parameter.patch
mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-intervals-autotuning.patch
mm-damon-core-implement-damon_kdamond_pid.patch
mm-damon-sysfs-use-damon_kdamond_pid.patch
mm-damon-lru_sort-use-damon_kdamond_pid.patch
mm-damon-reclaim-use-damon_kdamond_pid.patch
mm-damon-hide-kdamond-and-kdamond_lock-of-damon_ctx.patch

