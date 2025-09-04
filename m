Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC20F9C0;
	Thu,  4 Sep 2025 00:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756944699; cv=none; b=NGGWDCDAaTkH8geb+DXG6vAavzRUh0HhhBm+lDt/oPXmA80RJGvZJmuH885b604bB2cyfQv7V1Jyk5PbJ/z9u1X8BV8NPGT/9UyF+Q9Z/b28aQjpoONDKUcJHyYXUJn+6X4q7koPn461qIHh/NVO4770IDFeD0Xu/JY4G3vKOgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756944699; c=relaxed/simple;
	bh=1+7k2/XhPZq7zcjjKCFl8oJd35TzLIFffzxg/nI2L0c=;
	h=Date:To:From:Subject:Message-Id; b=BqyB1u8PbuPpqRkPhc9mLsXu6gJpGf8k6KbuhYRM2nK1tLEkHYv+hDHKJECmyBpCAeY6l0gd/BuW6iqgweLhpAVuR4gOUX+sF8wLPomwGOJ3EOC3ESlnD8W+z07Z+MrSdlIj4sn/XDmTtfMJhLxSOvzJ6rpYAFgw5Ry09CboeH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U0EeSccK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U0EeSccK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC78C4CEF5;
	Thu,  4 Sep 2025 00:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756944698;
	bh=1+7k2/XhPZq7zcjjKCFl8oJd35TzLIFffzxg/nI2L0c=;
	h=Date:To:From:Subject:From;
	b=U0EeSccKOwmqXKD3dRsOE3Y2xb3mF/lKS9Ddb+kWJsxU4g0N0UyIuTdqxi667JpDo
	 c6NL92s/takrsjkq/eddkgHEpixI54OIM9rUi/ARYzjg68gjAp9qAg+UXR6n+ITqmu
	 AT374icBix1xj7JFKcc3CViHmBMhFkh2Q7fES46Q=
Date: Wed, 03 Sep 2025 17:11:37 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,wangkefeng.wang@huawei.com,stable@vger.kernel.org,sj@kernel.org,yanquanmin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-lru_sort-avoid-divide-by-zero-in-damon_lru_sort_apply_parameters.patch removed from -mm tree
Message-Id: <20250904001138.0FC78C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/lru_sort: avoid divide-by-zero in damon_lru_sort_apply_parameters()
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-avoid-divide-by-zero-in-damon_lru_sort_apply_parameters.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-add-damon_ctx-min_sz_region.patch

