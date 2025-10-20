Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F412BF007
	for <mm-commits@vger.kernel.org>; Mon, 20 Oct 2025 18:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760983589; cv=none; b=GMIGtjsKktRhNX4hr0TV9XeYmY2MHQiznOeqc0Hm0FHZlUITnPPm7GQCNmL4pFw+fEaSzKwj5NdQbnT9BTPIGJoynhHTS3qb4VuMyPINQBnH7Px8C+yJ7mdO97LYQUu7l8tJK19nsfRhQcnl2xLt3PMXo6FpIkGqZ9zBA0Rw5uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760983589; c=relaxed/simple;
	bh=b0yDU3Yhz2gW2vafTQAUMPrY632qzWCd9oZWnQa2F08=;
	h=Date:To:From:Subject:Message-Id; b=IwxTsob/f/WIl6FzWSGtEPMmeTxuD46+qxOGwwUgfh/7lsLCxTx8J+kM+x4zSu3b4ReQIY1iBcYcnqW9q3HODpQooH9FZRzcrHlYP8uinIpFe7mFvM1J+mhHfjYwQfcDmEjfV0d2QLYL1a5gQxM5qLSybbFeWVluaTQlrzDFekI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UmNMY8lt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UmNMY8lt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DC8C4CEF9;
	Mon, 20 Oct 2025 18:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760983589;
	bh=b0yDU3Yhz2gW2vafTQAUMPrY632qzWCd9oZWnQa2F08=;
	h=Date:To:From:Subject:From;
	b=UmNMY8lt/IiNMNWWuU2MZKoC89apISyVIYrXmqjbQgfEtY6+3w7JUlBt/m2pOvN/i
	 CZSXRALwRvyKpAigsJ/Sdfryh5c0GPdx4QuM/JXBGxyH1lms3dNahd8EarBw0x1ymV
	 /i/Z+aCxK9p7sO/QgdrIpINDLHyo43VqQFaPfvqE=
Date: Mon, 20 Oct 2025 11:06:28 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,wangkefeng.wang@huawei.com,sj@kernel.org,yanquanmin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-use-min_sz_region-for-core-address-alignment-when-setting-regions.patch added to mm-new branch
Message-Id: <20251020180629.31DC8C4CEF9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/reclaim: use min_sz_region for core address alignment when setting regions
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-reclaim-use-min_sz_region-for-core-address-alignment-when-setting-regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-use-min_sz_region-for-core-address-alignment-when-setting-regions.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

mm-damon-add-a-min_sz_region-parameter-to-damon_set_region_biggest_system_ram_default.patch
mm-damon-reclaim-use-min_sz_region-for-core-address-alignment-when-setting-regions.patch

