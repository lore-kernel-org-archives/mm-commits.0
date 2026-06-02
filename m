Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DAF3C3C03
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439148; cv=none; b=dxhgYp0GXCay97wHCS9D+Jqb7LNcjI+BTBnot50LPqdv2YWgc2q1Wr7LWFNjZpBQh+4AZgIyw9hhVaSuA9emIRbU/TElGRZnpB5aVwZhYzMOgwR4FjWRz6rmSMJokcb6fWPB/vPzNLet4WdkjW8z9wS41oy51sqreG8xqh8aGoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439148; c=relaxed/simple;
	bh=GUbbFrlpa74Zw94ywUF5CNGrEXJnw4rtonSvAFPzg5k=;
	h=Date:To:From:Subject:Message-Id; b=ohdSEbZNQEKngKu6bybS/R3Pv/NNQmrsmRVKxBRc0V/721eCUfAUdJkuaKUiJBfcHuWIG9xp/QHkSyPUr9J13lErmmidmyWOrgs5ydI0FDnBSAAgUx1ZaccNav5PIxWHsqJmlbvMbFmOQ8nLttKZDZaCbfyvWUXn2MZ20D+4QK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h42Nv2VX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h42Nv2VX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291291F00893;
	Tue,  2 Jun 2026 22:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439147;
	bh=o1e76ri9MhrSZqOixbcGqHQwW9cGqe3XKANwuncPa8g=;
	h=Date:To:From:Subject;
	b=h42Nv2VXjUG/hb5F7L1sqnuI5WeCNHkx74MokjSn3JTgP+/soc57CflfDN/i6BY3h
	 gry53/rX/KITODIEOX8YPx6YNNscfxZL+JYhwLqj+YQ1BG/fLBPUd2eMFZ4Q1pOG7Z
	 uIHLy88/wuT1WankrNKIYzgeQwJcy+vP9gxmG3oo=
Date: Tue, 02 Jun 2026 15:25:46 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-do-not-use-region-out-of-a-loop-in-damon_set_regions.patch removed from -mm tree
Message-Id: <20260602222547.291291F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: do not use region out of a loop in damon_set_regions()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-do-not-use-region-out-of-a-loop-in-damon_set_regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: do not use region out of a loop in damon_set_regions()
Date: Fri, 22 May 2026 08:40:13 -0700

damon_set_regions() assumes the DAMON region iterator is referencing the
last region after the region iteration loop is completed.  The code is
indeed implemented in the way, but that is not a documented safe behavior.
Hence it is unreliable and difficult to read.  Cleanup the code to avoid
the case.

No behavioral change is intended.

Link: https://lore.kernel.org/20260522154026.80546-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-do-not-use-region-out-of-a-loop-in-damon_set_regions
+++ a/mm/damon/core.c
@@ -374,6 +374,7 @@ int damon_set_regions(struct damon_targe
 	for (i = 0; i < nr_ranges; i++) {
 		struct damon_region *first = NULL, *last, *newr;
 		struct damon_addr_range *range;
+		bool insert_before_r = false;
 
 		range = &ranges[i];
 		/* Get the first/last regions intersecting with the range */
@@ -383,8 +384,10 @@ int damon_set_regions(struct damon_targe
 					first = r;
 				last = r;
 			}
-			if (r->ar.start >= range->end)
+			if (r->ar.start >= range->end) {
+				insert_before_r = true;
 				break;
+			}
 		}
 		if (!first) {
 			/* no region intersects with this range */
@@ -394,7 +397,11 @@ int damon_set_regions(struct damon_targe
 					ALIGN(range->end, min_region_sz));
 			if (!newr)
 				return -ENOMEM;
-			damon_insert_region(newr, damon_prev_region(r), r, t);
+			if (insert_before_r)
+				damon_insert_region(newr, damon_prev_region(r),
+						r, t);
+			else
+				damon_add_region(newr, t);
 		} else {
 			/* resize intersecting regions to fit in this range */
 			first->ar.start = ALIGN_DOWN(range->start,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

