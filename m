Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102F821638D
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343170; cv=none; b=W8HBrq4Ja96G6XTLgHbY1oGq4PHRVlPkwE06yL3Yi53QRDe5pmIom1uFU+RGf5DshPcjY72I7fuVyLOPKmh0hX0e9+iYlfvJZ/SA16zOQ/m1g1L02z8KMYEBaQBng45Nqe+1g+LFU+8GsKNKaH+TF33CD7hniYqiNJeDjbmt/NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343170; c=relaxed/simple;
	bh=ZnY56LRoqCe61kTSdXWQ3Vk5t7twuJiH9/dKHTKO9O8=;
	h=Date:To:From:Subject:Message-Id; b=MCUVKlJLmjs/OySkkV1nwEKynuWFSU0GXfsVXjrmWn71x5a1V9QSysq/mQBu4fVFEj8+gml5vb2X4XiQ1S7EfOXtvRmIuPPbYLCa6CcFHsfEZqMhYTDXYi+WTEltgCsy26+cLpqMXah6O22MPZSxXFSbVG8LP+jay36zwexeQsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NPS1R8y+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NPS1R8y+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B2BC16AAE;
	Mon, 17 Nov 2025 01:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343169;
	bh=ZnY56LRoqCe61kTSdXWQ3Vk5t7twuJiH9/dKHTKO9O8=;
	h=Date:To:From:Subject:From;
	b=NPS1R8y+gkwU5V/plCfz5779FViCAAu85lXO1VgaVEe2FomCVPGf2Gbyir4xa0wvj
	 M/Vf28yruEm2Q2ZioRRFDeidokVbTuQl4N2AG8cePIHW5uGCPArFF/4KzGsyi4/WrR
	 sqv3DxOc4rjbLmkxHcGSEroZNibl9/RtN+6wIKtA=
Date: Sun, 16 Nov 2025 17:32:49 -0800
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,wangkefeng.wang@huawei.com,sj@kernel.org,yanquanmin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-use-min_sz_region-for-core-address-alignment-when-setting-regions.patch removed from -mm tree
Message-Id: <20251117013249.D0B2BC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/reclaim: use min_sz_region for core address alignment when setting regions
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-use-min_sz_region-for-core-address-alignment-when-setting-regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Quanmin Yan <yanquanmin1@huawei.com>
Subject: mm/damon/reclaim: use min_sz_region for core address alignment when setting regions
Date: Mon, 20 Oct 2025 21:01:25 +0800

When setting regions in DAMON_RECLAIM, DAMON_MIN_REGION will be applied as
the core address alignment, and the monitoring target address ranges would
be aligned on DAMON_MIN_REGION * addr_unit.  When users 1) set addr_unit
to a value larger than 1, and 2) set the monitoring target address range
as not aligned on DAMON_MIN_REGION * addr_unit, it will cause
DAMON_RECLAIM to operate on unexpectedly large physical address ranges.

For example, if the user sets the monitoring target address range to [4,
8) and addr_unit as 1024, the aimed monitoring target address range is [4
KiB, 8 KiB).  Assuming DAMON_MIN_REGION is 4096, so resulting target
address range will be [0, 4096) in the DAMON core layer address system,
and [0, 4 MiB) in the physical address space, which is an unexpected
range.

To fix the issue, use min_sz_region for core address alignment when
setting regions.

Link: https://lkml.kernel.org/r/20251020130125.2875164-3-yanquanmin1@huawei.com
Fixes: 7db551fcfb2a ("mm/damon/reclaim: support addr_unit for DAMON_RECLAIM")
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-use-min_sz_region-for-core-address-alignment-when-setting-regions
+++ a/mm/damon/reclaim.c
@@ -251,7 +251,7 @@ static int damon_reclaim_apply_parameter
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
 					&monitor_region_end,
-					DAMON_MIN_REGION);
+					param_ctx->min_sz_region);
 	if (err)
 		goto out;
 	err = damon_commit_ctx(ctx, param_ctx);
_

Patches currently in -mm which might be from yanquanmin1@huawei.com are


