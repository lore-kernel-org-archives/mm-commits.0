Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4612773E3;
	Thu, 28 Aug 2025 05:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756359985; cv=none; b=UrF5Dej8UTw35plBINL9xk3BTrIOq3JZOu5zR8jiOKPzssKhS3aB/38JHcl773MufhiyolIcW5EoEVKxSpQeE8a+ko3a01sNm4tL1j9zOnh12agrT3oRlczQrLgrCXGHgSv6vvf6dG0Bv5tccUDPlyYHsKMgctO20YtEbYS+YvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756359985; c=relaxed/simple;
	bh=DQa15gKoGUpiUB7H3al0tGembi5Vskv0d299cWatF1s=;
	h=Date:To:From:Subject:Message-Id; b=Rf1F/9BrZe+1q1Z7OIwuqYPS/QdfrTzZe2MCK5xleG8E7qeIBbNzd11oGNBTuCU88lupfwNatJRWldrP+l47FmdFDxkWyxMNuiR1pu/K6E7//SUfwKwRhoUViQq2OHQ7YCziw3TTGiPzui+3bfjV3XkF0OcOUkm0xv6Y64aEuCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jZfR2F04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jZfR2F04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF42C4CEF6;
	Thu, 28 Aug 2025 05:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756359984;
	bh=DQa15gKoGUpiUB7H3al0tGembi5Vskv0d299cWatF1s=;
	h=Date:To:From:Subject:From;
	b=jZfR2F04O3zHHpAfuredjCBfP6MtqNMlBrkJbKXChxr1B3BXEGm/xSHNEwf9WUjyy
	 DC751c8xM6b6UY0yT+5zg7vAW9OO83l4PCSct1gV6/CdXtOJ5znMm0SeD92XXTaWdb
	 LsKfJxQdIiqtkwv1Yp9ayhbTjfJ01h3I8cFgWJnw=
Date: Wed, 27 Aug 2025 22:46:24 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,wangkefeng.wang@huawei.com,stable@vger.kernel.org,sj@kernel.org,apanyaki@amazon.com,yanquanmin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-prevent-unnecessary-overflow-in-damos_set_effective_quota.patch removed from -mm tree
Message-Id: <20250828054624.BEF42C4CEF6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: prevent unnecessary overflow in damos_set_effective_quota()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-prevent-unnecessary-overflow-in-damos_set_effective_quota.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Quanmin Yan <yanquanmin1@huawei.com>
Subject: mm/damon/core: prevent unnecessary overflow in damos_set_effective_quota()
Date: Thu, 21 Aug 2025 20:55:55 +0800

On 32-bit systems, the throughput calculation in
damos_set_effective_quota() is prone to unnecessary multiplication
overflow.  Using mult_frac() to fix it.

Andrew Paniakin also recently found and privately reported this issue, on
64 bit systems.  This can also happen on 64-bit systems, once the charged
size exceeds ~17 TiB.  On systems running for long time in production,
this issue can actually happen.

More specifically, when a DAMOS scheme having the time quota run for
longtime, throughput calculation can overflow and set esz too small.  As a
result, speed of the scheme get unexpectedly slow.

Link: https://lkml.kernel.org/r/20250821125555.3020951-1-yanquanmin1@huawei.com
Fixes: 1cd243030059 ("mm/damon/schemes: implement time quota")
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reported-by: Andrew Paniakin <apanyaki@amazon.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Cc: <stable@vger.kernel.org>	[5.16+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-prevent-unnecessary-overflow-in-damos_set_effective_quota
+++ a/mm/damon/core.c
@@ -2073,8 +2073,8 @@ static void damos_set_effective_quota(st
 
 	if (quota->ms) {
 		if (quota->total_charged_ns)
-			throughput = quota->total_charged_sz * 1000000 /
-				quota->total_charged_ns;
+			throughput = mult_frac(quota->total_charged_sz, 1000000,
+							quota->total_charged_ns);
 		else
 			throughput = PAGE_SIZE * 1024;
 		esz = min(throughput * quota->ms, esz);
_

Patches currently in -mm which might be from yanquanmin1@huawei.com are

mm-damon-lru_sort-avoid-divide-by-zero-in-damon_lru_sort_apply_parameters.patch
mm-damon-reclaim-avoid-divide-by-zero-in-damon_reclaim_apply_parameters.patch

