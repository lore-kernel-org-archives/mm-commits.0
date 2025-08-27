Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B6C23BD05;
	Wed, 27 Aug 2025 23:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756335609; cv=none; b=kGNJu4TfUUhCTEllUMHCAzXoMauerIjnfhESweJoB3jo/ODXdQSyRMobXDQWTh1AHjUufLQpyRp0oXPhS1Kmma6SAda0HmRGkFHLNs8mVdH49mtsKuOI9+n2WB+aQ6hFh4Udy/ge8i9I6gkFFYsYO8Lmj1d17+vxGbfDwZM6NA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756335609; c=relaxed/simple;
	bh=3HR/1+fm+itGE9mveVV9nFCFQOMigUrg4sDm2KiU4Ac=;
	h=Date:To:From:Subject:Message-Id; b=Yy4hdV3PDZfIqNCKDuPk+0mAPWrR+YD/A/7mkG436rW6h8MVGl9TkR/iyrIanppOCCxqn4GdC1j1T748cBrdCO+wtwU7d8AfemCAnhaxLSn7raL9wEzoA8ezGPJctv8R0bStzdU/vSS/ctubmKZsboSnrReDyjAmWg42Vk1JZfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DYujPAnP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DYujPAnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E7CC4CEF6;
	Wed, 27 Aug 2025 23:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756335608;
	bh=3HR/1+fm+itGE9mveVV9nFCFQOMigUrg4sDm2KiU4Ac=;
	h=Date:To:From:Subject:From;
	b=DYujPAnPglwP0Ycy9MmEmxtMVLkZy4GvcFgneG1loH/NX3XDr30sJKzNNbkDUAe3H
	 u7PcZbNozT4CfI5JteqLmnZ8STGr/8q9S4r68rrQf7PZXEVBQKZzAueIT9N8H09W7d
	 ZGGMVj3vd3Jh2PvfiMCKnkX8aJdGKc0OTLVq8X2Q=
Date: Wed, 27 Aug 2025 16:00:08 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,wangkefeng.wang@huawei.com,stable@vger.kernel.org,sj@kernel.org,yanquanmin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-avoid-divide-by-zero-in-damon_reclaim_apply_parameters.patch added to mm-hotfixes-unstable branch
Message-Id: <20250827230008.C1E7CC4CEF6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/reclaim: avoid divide-by-zero in damon_reclaim_apply_parameters()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-reclaim-avoid-divide-by-zero-in-damon_reclaim_apply_parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-avoid-divide-by-zero-in-damon_reclaim_apply_parameters.patch

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
Subject: mm/damon/reclaim: avoid divide-by-zero in damon_reclaim_apply_parameters()
Date: Wed, 27 Aug 2025 19:58:58 +0800

When creating a new scheme of DAMON_RECLAIM, the calculation of
'min_age_region' uses 'aggr_interval' as the divisor, which may lead to
division-by-zero errors.  Fix it by directly returning -EINVAL when such a
case occurs.

Link: https://lkml.kernel.org/r/20250827115858.1186261-3-yanquanmin1@huawei.com
Fixes: f5a79d7c0c87 ("mm/damon: introduce struct damos_access_pattern")
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Cc: <stable@vger.kernel.org>	[6.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-avoid-divide-by-zero-in-damon_reclaim_apply_parameters
+++ a/mm/damon/reclaim.c
@@ -194,6 +194,11 @@ static int damon_reclaim_apply_parameter
 	if (err)
 		return err;
 
+	if (!damon_reclaim_mon_attrs.aggr_interval) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	err = damon_set_attrs(param_ctx, &damon_reclaim_mon_attrs);
 	if (err)
 		goto out;
_

Patches currently in -mm which might be from yanquanmin1@huawei.com are

mm-damon-core-prevent-unnecessary-overflow-in-damos_set_effective_quota.patch
mm-damon-lru_sort-avoid-divide-by-zero-in-damon_lru_sort_apply_parameters.patch
mm-damon-reclaim-avoid-divide-by-zero-in-damon_reclaim_apply_parameters.patch

