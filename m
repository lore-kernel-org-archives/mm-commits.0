Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2688E31077A;
	Wed, 27 Aug 2025 23:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756335608; cv=none; b=SmY98RLKHY8jUrZP192eDl89x2Ewet3kb7lqG+N1zPB/FOqe8N/qltAG6roDg6EXNatDu99YGsoe1243YqvxqNgKclIsgnElgeyo3/m9vRs+6ZbMz0UI4WrEXvbMoAZSh5BXZHOwl5js3qwmfOWNr2qSBQdGYjAlf+xMyMUYhyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756335608; c=relaxed/simple;
	bh=nvgNlFIMlr5slIXA5Dae7hHJTMrNAcdrGaLWZHkX7Mc=;
	h=Date:To:From:Subject:Message-Id; b=L80LApuX6GtOheKgTtJuxmBeDo9lvLSdUiTs1K04KxfKMNmzeuJoEokXuEtawh2fTmleQUj22LNSbO84WkNQlvgcqFAXshU8oN5cjTBGS9vHCFa4YOqYO5W+0QCLXy2FrESWymvLhV0B3MT21WVNf/TpdukeDaQ8OAQW58Vulbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=weBXS+Sb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="weBXS+Sb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC05C4CEEB;
	Wed, 27 Aug 2025 23:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756335607;
	bh=nvgNlFIMlr5slIXA5Dae7hHJTMrNAcdrGaLWZHkX7Mc=;
	h=Date:To:From:Subject:From;
	b=weBXS+SbZxEgzYg1/EhSvRUePpQMylnDwRqf9WYeqLX0BJuQD1dAjpBS8Nn5w6tJ3
	 t9+g+Tg2gU7i9Rmw9RX+XaHOmnLn0zCaQ8ESwYFDRI1G2yD8kyW75MvhG61EwbXEYN
	 cT2EoO5A3+fYlWNqb4cZJ4KUwUsMyGyoJzpT/qjk=
Date: Wed, 27 Aug 2025 16:00:06 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,wangkefeng.wang@huawei.com,stable@vger.kernel.org,sj@kernel.org,yanquanmin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-avoid-divide-by-zero-in-damon_lru_sort_apply_parameters.patch added to mm-hotfixes-unstable branch
Message-Id: <20250827230007.8EC05C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/lru_sort: avoid divide-by-zero in damon_lru_sort_apply_parameters()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-lru_sort-avoid-divide-by-zero-in-damon_lru_sort_apply_parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-avoid-divide-by-zero-in-damon_lru_sort_apply_parameters.patch

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
From: Quanmin Yan <yanquanmin1@huawei.com>
Subject: mm/damon/lru_sort: avoid divide-by-zero in damon_lru_sort_apply_parameters()
Date: Wed, 27 Aug 2025 19:58:57 +0800

Patch series "mm/damon: avoid divide-by-zero in DAMON module's parameters
application".

DAMON's RECLAIM and LRU_SORT modules perform no validation on
user-configured parameters during application, which may lead to
division-by-zero errors.

Avoid the divide-by-zero by adding validation checks when DAMON modules
attempt to apply the parameters.


This patch (of 2):

During the calculation of 'hot_thres' and 'cold_thres', either
'sample_interval' or 'aggr_interval' is used as the divisor, which may
lead to division-by-zero errors.  Fix it by directly returning -EINVAL
when such a case occurs.  Additionally, since 'aggr_interval' is already
required to be set no smaller than 'sample_interval' in damon_set_attrs(),
only the case where 'sample_interval' is zero needs to be checked.

Link: https://lkml.kernel.org/r/20250827115858.1186261-2-yanquanmin1@huawei.com
Fixes: 40e983cca927 ("mm/damon: introduce DAMON-based LRU-lists Sorting")
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Cc: <stable@vger.kernel.org>	[6.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-avoid-divide-by-zero-in-damon_lru_sort_apply_parameters
+++ a/mm/damon/lru_sort.c
@@ -198,6 +198,11 @@ static int damon_lru_sort_apply_paramete
 	if (err)
 		return err;
 
+	if (!damon_lru_sort_mon_attrs.sample_interval) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	err = damon_set_attrs(ctx, &damon_lru_sort_mon_attrs);
 	if (err)
 		goto out;
_

Patches currently in -mm which might be from yanquanmin1@huawei.com are

mm-damon-core-prevent-unnecessary-overflow-in-damos_set_effective_quota.patch
mm-damon-lru_sort-avoid-divide-by-zero-in-damon_lru_sort_apply_parameters.patch
mm-damon-reclaim-avoid-divide-by-zero-in-damon_reclaim_apply_parameters.patch

