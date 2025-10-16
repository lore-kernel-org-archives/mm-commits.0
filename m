Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077382D9EED
	for <mm-commits@vger.kernel.org>; Thu, 16 Oct 2025 20:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760645615; cv=none; b=VJt0FC6MFdjw/0XTYc3ZEu0cRuRjSYUTNFBUbIXNPeSo9LFJoxSIyBhY/nWV1iCc2lPRgkrVaH3j3LeiOwDiKPDLdOLw+B9wlYcQHNgjntvus0oASH+tPr1eSw9XHNgotoQ3LtZknjL8J+gzbYHCwfhddqGgb6NNmDsW+kzjHIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760645615; c=relaxed/simple;
	bh=wZFyouy1WC+Ib2HfmW99goZl5hEXIxO0mQrXPhW5Wtk=;
	h=Date:To:From:Subject:Message-Id; b=gatJQ+bXZ8PtpjLTMdVGYP89knM/zSSVkGPuDkQ2KPLt2WB9MEWzlo4doA4QVPziO8i/AFMEgvzq/In+LLEImSXndwBEzjBpOPXbv6fDefaovLmJaHn2ckM8vTX6RI40xAY7/UsDBeBNPfHSV1+2JrM/HGqz4R8qrg+78j8YoxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xfG/Gw3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xfG/Gw3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81692C4CEF1;
	Thu, 16 Oct 2025 20:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760645614;
	bh=wZFyouy1WC+Ib2HfmW99goZl5hEXIxO0mQrXPhW5Wtk=;
	h=Date:To:From:Subject:From;
	b=xfG/Gw3GnNhrgI6k2muoUWgSrSuIIAkiybMeZGjZy+wHrJYxEEQqhp86jXDjtIm83
	 9UzGbkyYVvzqgW9fAa1oDHkN75xH+R+05lrVjVaTInOn0HtoqRhT8ms1JHmkRoBsRF
	 gtwjdEHi4jnPp5HHXDpWofupd01eN8bZG/8a3f60=
Date: Thu, 16 Oct 2025 13:13:34 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,wangkefeng.wang@huawei.com,sj@kernel.org,yanquanmin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-add-a-min_sz_region-parameter-to-damon_set_region_biggest_system_ram_default.patch added to mm-hotfixes-unstable branch
Message-Id: <20251016201334.81692C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: add a min_sz_region parameter to damon_set_region_biggest_system_ram_default()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-add-a-min_sz_region-parameter-to-damon_set_region_biggest_system_ram_default.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-add-a-min_sz_region-parameter-to-damon_set_region_biggest_system_ram_default.patch

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
Subject: mm/damon: add a min_sz_region parameter to damon_set_region_biggest_system_ram_default()
Date: Thu, 16 Oct 2025 18:47:17 +0800

After adding addr_unit support for DAMON_LRU_SORT and DAMON_RECLAIM, the
related region setup now requires alignment based on min_sz_region.

Add min_sz_region to damon_set_region_biggest_system_ram_default() and use
it when calling damon_set_regions(), replacing the previously hardcoded
DAMON_MIN_REGION.

Link: https://lkml.kernel.org/r/20251016104717.2194909-1-yanquanmin1@huawei.com
Fixes: 2e0fe9245d6b ("mm/damon/lru_sort: support addr_unit for DAMON_LRU_SORT")
Fixes: 7db551fcfb2a ("mm/damon/reclaim: support addr_unit for DAMON_RECLAIM")
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>
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
@@ -947,7 +947,8 @@ int damon_call(struct damon_ctx *ctx, st
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
-				unsigned long *start, unsigned long *end);
+				unsigned long *start, unsigned long *end,
+				unsigned long min_sz_region);
 
 #endif	/* CONFIG_DAMON */
 
--- a/mm/damon/core.c~mm-damon-add-a-min_sz_region-parameter-to-damon_set_region_biggest_system_ram_default
+++ a/mm/damon/core.c
@@ -2770,6 +2770,7 @@ static bool damon_find_biggest_system_ra
  * @t:		The monitoring target to set the region.
  * @start:	The pointer to the start address of the region.
  * @end:	The pointer to the end address of the region.
+ * @min_sz_region:	Minimum region size.
  *
  * This function sets the region of @t as requested by @start and @end.  If the
  * values of @start and @end are zero, however, this function finds the biggest
@@ -2780,7 +2781,8 @@ static bool damon_find_biggest_system_ra
  * Return: 0 on success, negative error code otherwise.
  */
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
-			unsigned long *start, unsigned long *end)
+			unsigned long *start, unsigned long *end,
+			unsigned long min_sz_region)
 {
 	struct damon_addr_range addr_range;
 
@@ -2793,7 +2795,7 @@ int damon_set_region_biggest_system_ram_
 
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
+					param_ctx->min_sz_region);
 	if (err)
 		goto out;
 	err = damon_commit_ctx(ctx, param_ctx);
--- a/mm/damon/stat.c~mm-damon-add-a-min_sz_region-parameter-to-damon_set_region_biggest_system_ram_default
+++ a/mm/damon/stat.c
@@ -187,7 +187,8 @@ static struct damon_ctx *damon_stat_buil
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

mm-damon-add-a-min_sz_region-parameter-to-damon_set_region_biggest_system_ram_default.patch

