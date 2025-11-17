Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCFB21638D
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343168; cv=none; b=OdcL8T60vcXt7PTByi1w6y49cHYZ+JwVCVxytX9+0g7L7Vhvo7JyV84mmRViXULyC2qpCWtXBK7pAAtqUsC19f78oBWzIkQquw1/Eycwum2I1h1iiZpQu4HTX9G/PdpB4FeawM+ed0+G67xFIgfWXKjM81qFF2n+JUZ82+2QliY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343168; c=relaxed/simple;
	bh=dzj0JJIDK4p1mLfDAMZOxNaPTWHYiM3w/ba8Tk+qCYU=;
	h=Date:To:From:Subject:Message-Id; b=fTgsLfgWBJeAXC8IpDA5sovqQninnhIMUoAevMUCt5MyNdG1hFWwMEf5pnKUrEZM67N1HAmIdQzSWslbIEkuBf652j3zRUAEJsHq1HgGzYFAfytseMrSVYqhwHFUwUXq1eMtDvQxo0TBTGDNg8TR/TaWL7AnHpN9TgsNpEs7UO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zgPCY4Ws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zgPCY4Ws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FA9C16AAE;
	Mon, 17 Nov 2025 01:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343168;
	bh=dzj0JJIDK4p1mLfDAMZOxNaPTWHYiM3w/ba8Tk+qCYU=;
	h=Date:To:From:Subject:From;
	b=zgPCY4WsgB0z37Vt72WtUEbhobCf7gRVIv7xQ4E1r9bNzOKWK/BBIedpXe0iKTvB4
	 EqA733o53kkOnghie3Qh2mxbGQKUMTpYy2F/rUenhSINrn8E5Bkz6urhoT3JyIbaCq
	 rr8vzD/YwpcDt6vsrMhOvIARqZvjAfJ7cBU4fJwY=
Date: Sun, 16 Nov 2025 17:32:47 -0800
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,wangkefeng.wang@huawei.com,sj@kernel.org,yanquanmin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-add-a-min_sz_region-parameter-to-damon_set_region_biggest_system_ram_default.patch removed from -mm tree
Message-Id: <20251117013248.48FA9C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: add a min_sz_region parameter to damon_set_region_biggest_system_ram_default()
has been removed from the -mm tree.  Its filename was
     mm-damon-add-a-min_sz_region-parameter-to-damon_set_region_biggest_system_ram_default.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Quanmin Yan <yanquanmin1@huawei.com>
Subject: mm/damon: add a min_sz_region parameter to damon_set_region_biggest_system_ram_default()
Date: Mon, 20 Oct 2025 21:01:24 +0800

Patch series "mm/damon: fixes for address alignment issues in
DAMON_LRU_SORT and DAMON_RECLAIM", v2.

In DAMON_LRU_SORT and DAMON_RECLAIM, damon_set_regions() will apply
DAMON_MIN_REGION as the core address alignment, and the monitoring target
address ranges would be aligned on DAMON_MIN_REGION * addr_unit.  When
users 1) set addr_unit to a value larger than 1, and 2) set the monitoring
target address range as not aligned on DAMON_MIN_REGION * addr_unit, it
will cause DAMON_LRU_SORT and DAMON_RECLAIM to operate on unexpectedly
large physical address ranges.

For example, if the user sets the monitoring target address range to [4,
8) and addr_unit as 1024, the aimed monitoring target address range is [4
KiB, 8 KiB).  Assuming DAMON_MIN_REGION is 4096, so resulting target
address range will be [0, 4096) in the DAMON core layer address system,
and [0, 4 MiB) in the physical address space, which is an unexpected
range.

To fix the issue, add a min_sz_region parameter to
damon_set_region_biggest_system_ram_default() and use it when calling
damon_set_regions(), replacing the direct use of DAMON_MIN_REGION.


This patch (of 2):

In DAMON_LRU_SORT, damon_set_regions() will apply DAMON_MIN_REGION as the
core address alignment, and the monitoring target address ranges would be
aligned on DAMON_MIN_REGION * addr_unit.  When users 1) set addr_unit to a
value larger than 1, and 2) set the monitoring target address range as not
aligned on DAMON_MIN_REGION * addr_unit, it will cause DAMON_LRU_SORT to
operate on unexpectedly large physical address ranges.

For example, if the user sets the monitoring target address range to [4,
8) and addr_unit as 1024, the aimed monitoring target address range is [4
KiB, 8 KiB).  Assuming DAMON_MIN_REGION is 4096, so resulting target
address range will be [0, 4096) in the DAMON core layer address system,
and [0, 4 MiB) in the physical address space, which is an unexpected
range.

To fix the issue, add a min_sz_region parameter to
damon_set_region_biggest_system_ram_default() and use it when calling
damon_set_regions(), replacing the direct use of DAMON_MIN_REGION.

Link: https://lkml.kernel.org/r/20251020130125.2875164-1-yanquanmin1@huawei.com
Link: https://lkml.kernel.org/r/20251020130125.2875164-2-yanquanmin1@huawei.com
Fixes: 2e0fe9245d6b ("mm/damon/lru_sort: support addr_unit for DAMON_LRU_SORT")
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    3 ++-
 mm/damon/core.c       |    6 ++++--
 mm/damon/lru_sort.c   |    3 ++-
 mm/damon/reclaim.c    |    3 ++-
 mm/damon/stat.c       |    3 ++-
 5 files changed, 12 insertions(+), 6 deletions(-)

--- a/include/linux/damon.h~mm-damon-add-a-min_sz_region-parameter-to-damon_set_region_biggest_system_ram_default
+++ a/include/linux/damon.h
@@ -961,7 +961,8 @@ int damon_call(struct damon_ctx *ctx, st
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
-				unsigned long *start, unsigned long *end);
+				unsigned long *start, unsigned long *end,
+				unsigned long min_sz_region);
 
 #endif	/* CONFIG_DAMON */
 
--- a/mm/damon/core.c~mm-damon-add-a-min_sz_region-parameter-to-damon_set_region_biggest_system_ram_default
+++ a/mm/damon/core.c
@@ -2818,6 +2818,7 @@ static bool damon_find_biggest_system_ra
  * @t:		The monitoring target to set the region.
  * @start:	The pointer to the start address of the region.
  * @end:	The pointer to the end address of the region.
+ * @min_sz_region:	Minimum region size.
  *
  * This function sets the region of @t as requested by @start and @end.  If the
  * values of @start and @end are zero, however, this function finds the biggest
@@ -2828,7 +2829,8 @@ static bool damon_find_biggest_system_ra
  * Return: 0 on success, negative error code otherwise.
  */
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
-			unsigned long *start, unsigned long *end)
+			unsigned long *start, unsigned long *end,
+			unsigned long min_sz_region)
 {
 	struct damon_addr_range addr_range;
 
@@ -2841,7 +2843,7 @@ int damon_set_region_biggest_system_ram_
 
 	addr_range.start = *start;
 	addr_range.end = *end;
-	return damon_set_regions(t, &addr_range, 1, DAMON_MIN_REGION);
+	return damon_set_regions(t, &addr_range, 1, min_sz_region);
 }
 
 /*
--- a/mm/damon/lru_sort.c~mm-damon-add-a-min_sz_region-parameter-to-damon_set_region_biggest_system_ram_default
+++ a/mm/damon/lru_sort.c
@@ -242,7 +242,8 @@ static int damon_lru_sort_apply_paramete
 
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
-					&monitor_region_end);
+					&monitor_region_end,
+					param_ctx->min_sz_region);
 	if (err)
 		goto out;
 	err = damon_commit_ctx(ctx, param_ctx);
--- a/mm/damon/reclaim.c~mm-damon-add-a-min_sz_region-parameter-to-damon_set_region_biggest_system_ram_default
+++ a/mm/damon/reclaim.c
@@ -250,7 +250,8 @@ static int damon_reclaim_apply_parameter
 
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
-					&monitor_region_end);
+					&monitor_region_end,
+					DAMON_MIN_REGION);
 	if (err)
 		goto out;
 	err = damon_commit_ctx(ctx, param_ctx);
--- a/mm/damon/stat.c~mm-damon-add-a-min_sz_region-parameter-to-damon_set_region_biggest_system_ram_default
+++ a/mm/damon/stat.c
@@ -188,7 +188,8 @@ static struct damon_ctx *damon_stat_buil
 	if (!target)
 		goto free_out;
 	damon_add_target(ctx, target);
-	if (damon_set_region_biggest_system_ram_default(target, &start, &end))
+	if (damon_set_region_biggest_system_ram_default(target, &start, &end,
+							ctx->min_sz_region))
 		goto free_out;
 	return ctx;
 free_out:
_

Patches currently in -mm which might be from yanquanmin1@huawei.com are


