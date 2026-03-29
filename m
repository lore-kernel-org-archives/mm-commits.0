Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57020255E43
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744896; cv=none; b=mcov3gVmTwTqXYAwXJhWol0vj3GYWsb3xPQBrQni893K1fKs5pnjYuV5uJ+hTVjdg1Xf8upZNnTWxh1TsP6K20rP3hPTkqtc0XS6JMAuBBxLmKw8sWMcPe5te21DZqnc2x4g6CvRi7XPRQHKIs48GqduG9bTO05MxIVHDtAwzsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744896; c=relaxed/simple;
	bh=iFjyticbJReTeda9N4bBTdNe38mFNUKqUpJV5rtMWmA=;
	h=Date:To:From:Subject:Message-Id; b=Ht+mGcNX3+4zHi1UZZtJRKOYWD1niTV59yoWiuZlNDvVgLK7BIkaivxy2WtgY1gT31desp/WGjBGnAcIjxJXNtAL3Rz38Jqa0tUD0iIYybRBrF/6iHMMlTqw9IwxeffjdKl6wlOZsh0jO8tUq3Nqe118DAXLxaikVSTmJodoxW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p1YeRUau; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p1YeRUau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9A9C4CEF7;
	Sun, 29 Mar 2026 00:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744896;
	bh=iFjyticbJReTeda9N4bBTdNe38mFNUKqUpJV5rtMWmA=;
	h=Date:To:From:Subject:From;
	b=p1YeRUauJCA/jQjTJ7tKKYesplg+AHKIM4et3Rd3yitWmQzx1EAJTxTQdWY/kvNqH
	 SKabgT1q2+KBBySEEEL/WoVGA1Hob0lG0vjFpaLgQ1lmaMsG4Y2N9VB0GpFhX3GvWp
	 K5sIfgl27hrX52Mdz0w61GccuaBdKTVDSw1oPCLY=
Date: Sat, 28 Mar 2026 17:41:35 -0700
To: mm-commits@vger.kernel.org,yangyingliang@huawei.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default.patch removed from -mm tree
Message-Id: <20260329004136.2F9A9C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: receive addr_unit on damon_set_region_biggest_system_ram_default()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: receive addr_unit on damon_set_region_biggest_system_ram_default()
Date: Tue, 10 Mar 2026 22:29:24 -0700

damon_find_biggest_system_ram() was not supporting addr_unit in the past. 
Hence, its caller, damon_set_region_biggest_system_ram_default(), was also
not supporting addr_unit.  The previous commit has updated the inner
function to support addr_unit.  There is no more reason to not support
addr_unit on damon_set_region_biggest_system_ram_default().  Rather, it
makes unnecessary inconsistency on support of addr_unit.  Update it to
receive addr_unit and handle it inside.

Link: https://lkml.kernel.org/r/20260311052927.93921-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Yang yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 +
 mm/damon/core.c       |    7 ++++---
 mm/damon/lru_sort.c   |    1 +
 mm/damon/reclaim.c    |    1 +
 4 files changed, 7 insertions(+), 3 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default
+++ a/include/linux/damon.h
@@ -994,6 +994,7 @@ int damos_walk(struct damon_ctx *ctx, st
 
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end,
+				unsigned long addr_unit,
 				unsigned long min_region_sz);
 
 #endif	/* CONFIG_DAMON */
--- a/mm/damon/core.c~mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default
+++ a/mm/damon/core.c
@@ -3110,6 +3110,7 @@ static bool damon_find_biggest_system_ra
  * @t:		The monitoring target to set the region.
  * @start:	The pointer to the start address of the region.
  * @end:	The pointer to the end address of the region.
+ * @addr_unit:	The address unit for the damon_ctx of @t.
  * @min_region_sz:	Minimum region size.
  *
  * This function sets the region of @t as requested by @start and @end.  If the
@@ -3122,7 +3123,7 @@ static bool damon_find_biggest_system_ra
  */
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 			unsigned long *start, unsigned long *end,
-			unsigned long min_region_sz)
+			unsigned long addr_unit, unsigned long min_region_sz)
 {
 	struct damon_addr_range addr_range;
 
@@ -3130,12 +3131,12 @@ int damon_set_region_biggest_system_ram_
 		return -EINVAL;
 
 	if (!*start && !*end &&
-		!damon_find_biggest_system_ram(start, end, 1))
+			!damon_find_biggest_system_ram(start, end, addr_unit))
 		return -EINVAL;
 
 	addr_range.start = *start;
 	addr_range.end = *end;
-	return damon_set_regions(t, &addr_range, 1, min_region_sz);
+	return damon_set_regions(t, &addr_range, addr_unit, min_region_sz);
 }
 
 /*
--- a/mm/damon/lru_sort.c~mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default
+++ a/mm/damon/lru_sort.c
@@ -345,6 +345,7 @@ static int damon_lru_sort_apply_paramete
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
 					&monitor_region_end,
+					param_ctx->addr_unit,
 					param_ctx->min_region_sz);
 	if (err)
 		goto out;
--- a/mm/damon/reclaim.c~mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default
+++ a/mm/damon/reclaim.c
@@ -251,6 +251,7 @@ static int damon_reclaim_apply_parameter
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
 					&monitor_region_end,
+					param_ctx->addr_unit,
 					param_ctx->min_region_sz);
 	if (err)
 		goto out;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

