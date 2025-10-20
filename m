Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2755023EAA3
	for <mm-commits@vger.kernel.org>; Mon, 20 Oct 2025 18:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760983588; cv=none; b=QsGuNdMINwHKp5UQnEdBre+ArBYh2BYQmX9pzHXVMie0HKZDegGDp6SoY2AjiVkaWYwPMdHbF3PCyNjoxVP4qxgUwu2wOmLuvkoVPaTh+K8RNsAMqEF9QQWSGSigdRymb5ku2lgb7270I/IbGxF77WbneWrYY1bOOHvZodP/g9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760983588; c=relaxed/simple;
	bh=fybVKFZkmQWO+XVTDq41tYq5/VPd/knOrZFStr1+84k=;
	h=Date:To:From:Subject:Message-Id; b=nVBHQ1mCr6OaidDxtCfujB0hBSjsM0MKAEA+DnGlEwxyJY9qHbfEDLePxFNwaWI8vqiV6Qx9T1bncnAustY0KnZX2/pm8e+za2HIciWF4NEzk5vDz6DlxZNqNilgr93Co3BVJRXBW83TBxPN24QhQJ0D0OkDITfAUv9uU3dLeRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BBojfgh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BBojfgh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825B0C4CEF9;
	Mon, 20 Oct 2025 18:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760983587;
	bh=fybVKFZkmQWO+XVTDq41tYq5/VPd/knOrZFStr1+84k=;
	h=Date:To:From:Subject:From;
	b=BBojfgh8+f1/a3JRVBWvifFuS8EG71IB2vqaxbcYwyD49AS1PTrI8tgRO5AAb8p73
	 fqyDGv9uSz/JR4oCT+mnnM8K4dHSK2kEYM29TEQhCLIDWBWkRYlYP45RzveQVjAgbH
	 tFgaHb6A7brYA6Ye7Rwc5g1yMUzQG9YMFrfhI4nk=
Date: Mon, 20 Oct 2025 11:06:27 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,wangkefeng.wang@huawei.com,sj@kernel.org,yanquanmin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-add-a-min_sz_region-parameter-to-damon_set_region_biggest_system_ram_default.patch added to mm-new branch
Message-Id: <20251020180627.825B0C4CEF9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: add a min_sz_region parameter to damon_set_region_biggest_system_ram_default()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-add-a-min_sz_region-parameter-to-damon_set_region_biggest_system_ram_default.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-add-a-min_sz_region-parameter-to-damon_set_region_biggest_system_ram_default.patch

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
mm-damon-reclaim-use-min_sz_region-for-core-address-alignment-when-setting-regions.patch

