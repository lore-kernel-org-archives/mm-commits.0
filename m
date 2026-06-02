Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291993C063E
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439154; cv=none; b=SPbIB+0nNfjwf9kbo26HKEBNvil65AArZJdnRPFjqmoFsb1tujmdAioTKxGBl5KYxKHgDB4rbwe+E0gOXII4W/gb0irgf5Cg6yid7z71x79fGOJihbxzSr3oKBadGAT3znYUyi/imbmNsjVTxSYS9EtzUcCX4kLLz8y0mRHOrZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439154; c=relaxed/simple;
	bh=ydsa3D3xy+fIKPMzAWVI/1UHcptYb1xg+TgQSGaSYQk=;
	h=Date:To:From:Subject:Message-Id; b=Z75q7CJDpvXW2JQGgPtHORN/YU7v3kt9WHIJMaBlCrwNWTuUggaOc43R0+D5oI9MMdNQuzbmZBkEailxqjXWeunVc448e6KVWe/S9Id+Gce1eR3594qQXHCniy5BFxFu9BKFXl/hdfRmXUdpDehAWNEcCN0tDfedqhxG1u57rOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yaFfleWy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yaFfleWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07E61F00898;
	Tue,  2 Jun 2026 22:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439153;
	bh=KI/EW6QZQ6puorDW/DmhEDhIeRu2pLv2FVsCPMsA6BM=;
	h=Date:To:From:Subject;
	b=yaFfleWyef0NiYr64sVRfDHjJ11lQiXxcZHjQ07uM6aIhspedIzOFVD/EYp6teh75
	 deB+UEjaFGAucDBk14xBq7KI+dlXv/Jv/qSYuSESmpUljlpZvRsRuJtKXBgyA7cgmT
	 iUoBgFLf1oNlco680jzCevzQGBIYZXgL52Y+mu3U=
Date: Tue, 02 Jun 2026 15:25:52 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-hide-damon_destroy_region.patch removed from -mm tree
Message-Id: <20260602222552.F07E61F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: hide damon_destroy_region()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-hide-damon_destroy_region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: hide damon_destroy_region()
Date: Fri, 22 May 2026 08:40:18 -0700

damon_destroy_region() is being used by only DAMON core, but exposed to
DAMON API callers.  Exposing something that is not really being used by
others will only increase the maintenance cost.  Hide it.

Link: https://lore.kernel.org/20260522154026.80546-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 -
 mm/damon/core.c       |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-hide-damon_destroy_region
+++ a/include/linux/damon.h
@@ -1013,7 +1013,6 @@ void damon_add_probe(struct damon_ctx *c
 
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
 
-void damon_destroy_region(struct damon_region *r, struct damon_target *t);
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
 void damon_update_region_access_rate(struct damon_region *r, bool accessed,
--- a/mm/damon/core.c~mm-damon-core-hide-damon_destroy_region
+++ a/mm/damon/core.c
@@ -291,7 +291,8 @@ static void damon_free_region(struct dam
 	kmem_cache_free(damon_region_cache, r);
 }
 
-void damon_destroy_region(struct damon_region *r, struct damon_target *t)
+static void damon_destroy_region(struct damon_region *r,
+		struct damon_target *t)
 {
 	damon_del_region(r, t);
 	damon_free_region(r);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

