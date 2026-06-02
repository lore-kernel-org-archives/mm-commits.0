Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCE73BCD39
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439149; cv=none; b=uIvFTsHSQwrCxvDGQYnuDu0An3dETj+HbQwI7PIx7+e0sx0Yxoc7/0UWS7NZ/mGlwKKwbolf+aM3mBI5yyri76EpasjrhzJSoaLx9qJai+irAjSDY+joSE0AEifPtoK828CZw/bFn4DK+QdnC4JNomrqVHmOJ+941LNdGkUUXko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439149; c=relaxed/simple;
	bh=tkaEJZRC6V7av/YKcots93mIQMsp6ba/Zlf6LbsW7Ns=;
	h=Date:To:From:Subject:Message-Id; b=XlWS4zUGQgRyuZhRVFM5Zi5qCgmXSL9qRKX2p3uBjCte0hp7p4GarxEA0gsEZmqlN0wMgRf6CcUnVrElmKHKsTMr4VUSPxP0bVk8IgElqOKYIDdKyDj4rde1rdHQCmISnX2WxtaWVHEYbz70jaaVcYpUXj2DIXfyt3WghRMPj3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DLgBAx+W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DLgBAx+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545EE1F00898;
	Tue,  2 Jun 2026 22:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439148;
	bh=StgRRxFqabzedUhcezZs+2x6En2yWYgzMD+1yRkP3UM=;
	h=Date:To:From:Subject;
	b=DLgBAx+WwKX9G27c+WHTur84wh5pZEQfi1hcnyb1Ss9qvsRs4Akv2QD6aOzJ5Gxai
	 TsXE8/01VytZ0/c3omx7FmthKeMAyadGrXjJhI5w39ZSUODQ2YSA0u5MqAt90MNTDl
	 LBjUuuHXfKTCTOxyZgBwkweAzAUVB9z/+0a8wi7E=
Date: Tue, 02 Jun 2026 15:25:47 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-mtier-replace-damon_add_region-with-damon_set_regions.patch removed from -mm tree
Message-Id: <20260602222548.545EE1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/mtier: replace damon_add_region() with damon_set_regions()
has been removed from the -mm tree.  Its filename was
     samples-damon-mtier-replace-damon_add_region-with-damon_set_regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: samples/damon/mtier: replace damon_add_region() with damon_set_regions()
Date: Fri, 22 May 2026 08:40:14 -0700

mtier DAMON sample module and DAMON virtual address operation set (vaddr)
unit tests are using damon_add_region() for setup of DAMON monitoring
target region boundaries setup.  But, damon_set_regions() is designed for
exactly the purpose.  All other DAMON API callers use the function for the
purpose.  Replace damon_add_region() usage in mtier sample module with
damon_set_regions(), for unifying the use case and reducing the
maintenance cost.

Link: https://lore.kernel.org/20260522154026.80546-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/mtier.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/samples/damon/mtier.c~samples-damon-mtier-replace-damon_add_region-with-damon_set_regions
+++ a/samples/damon/mtier.c
@@ -75,11 +75,11 @@ static struct damon_ctx *damon_sample_mt
 	struct damon_ctx *ctx;
 	struct damon_attrs attrs;
 	struct damon_target *target;
-	struct damon_region *region;
 	struct damos *scheme;
 	struct damos_quota_goal *quota_goal;
 	struct damos_filter *filter;
 	struct region_range addr;
+	struct damon_addr_range range;
 	int ret;
 
 	ctx = damon_new_ctx();
@@ -120,10 +120,12 @@ static struct damon_ctx *damon_sample_mt
 		addr.end = promote ? node1_end_addr : node0_end_addr;
 	}
 
-	region = damon_new_region(addr.start, addr.end);
-	if (!region)
+	range.start = addr.start;
+	range.end = addr.end;
+
+	ret = damon_set_regions(target, &range, 1, DAMON_MIN_REGION_SZ);
+	if (ret)
 		goto free_out;
-	damon_add_region(region, target);
 
 	scheme = damon_new_scheme(
 			/* access pattern */
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

