Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A6D35963;
	Thu,  4 Sep 2025 00:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756944699; cv=none; b=D0BSEvmKwU75BcaetzfLoDBS+SCOuZsWlE91tssTZc5HH82JsMmb6rIlxePkaaehTA+2Ziq3HNGO9NIx8EExk2TTvcAe/UB+tOat8MalVRw1et7b2UzQNeRz+RwviWdwkCuo0mPGDjVbHb26XQ1xCmoXwDQRWgCE3Ni1bKUQXf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756944699; c=relaxed/simple;
	bh=Aj8spQn/Q6oDxexs88mlwNRTwhcyf0zoPaCpEP2KJnI=;
	h=Date:To:From:Subject:Message-Id; b=kZUIe+3HLymO0FXPGubAkbB5y/O5tRJrj7AoLYFYHo1AFEWOA8+I54V+iJL3wmJhHS9Jcq8z4TIAHx0iPYzkc5iuTZ0GeldK3HSiAfoiVpCw7wYeP3uek93knLcHCU+0CF2wGeuaKIUMS5oMTniW/IjMuN/HvlUU5XJsEZCkBDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W9WtZAS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W9WtZAS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E65C4CEE7;
	Thu,  4 Sep 2025 00:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756944699;
	bh=Aj8spQn/Q6oDxexs88mlwNRTwhcyf0zoPaCpEP2KJnI=;
	h=Date:To:From:Subject:From;
	b=W9WtZAS9Re28WxXo+xh1CazBgBYNIsWH5yIokFFWl+67gylQ5FK38NMSFTa4OcZVn
	 FPsYEakJI7Nw2ClmWevdV87ixmrTrp+XEl+VlVIUfe6CFoEM0mbKgg6KUkUafFJ/7A
	 VxOqVfR1WzhpHQvpASh1MuWncowDF5TChld9zOHM=
Date: Wed, 03 Sep 2025 17:11:38 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,wangkefeng.wang@huawei.com,stable@vger.kernel.org,sj@kernel.org,yanquanmin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-reclaim-avoid-divide-by-zero-in-damon_reclaim_apply_parameters.patch removed from -mm tree
Message-Id: <20250904001139.31E65C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/reclaim: avoid divide-by-zero in damon_reclaim_apply_parameters()
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-avoid-divide-by-zero-in-damon_reclaim_apply_parameters.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-add-damon_ctx-min_sz_region.patch

