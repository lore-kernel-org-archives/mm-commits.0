Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1EC429825;
	Tue, 13 Oct 2026 04:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865904; cv=none; b=f2bL4Y4fIWZxYWtnPPuT4WMzXPFnsnNZu/PmILkQ04kJLDu+Sr1HUhuh8HGf/fdu9GFcP+134C9ynk8pyfT2torhndXXSNSs5kcx7DReL1cS09x2NR0+d0rnboatvDzBvuOlHB+u7NFF2mnT6ZdhBwFm5V1IM2VjqRDPZjZIny0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865904; c=relaxed/simple;
	bh=9/cx1I7Tsn4/AYh1kBWD1dBYMWD8h3WR5SyHk751BDk=;
	h=Date:To:From:Subject:Message-Id; b=TEMwI42EQAvu3TK8CV+Hku5vRCrqiTogHy1bztP6FeAiAF2uEAufwUIy1lKPqdrsNN+Oo86rJmoCyPujJfDClw4gO3QSpUEIenl9WChbB7BWGtlEcMWygWVjTi0yQJ9p0l+hdX8GP89R8Tj6ffjzyQLVYZbZFqFM8wxoNj59+Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KsnTAI9b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KsnTAI9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210D51F000FF;
	Tue, 13 Oct 2026 04:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865903;
	bh=wWHKf+xgFHrnfoFoSdc0sw+/EMVsQEwBeC6DyuXDjdA=;
	h=Date:To:From:Subject;
	b=KsnTAI9bf59U9zASIn6dmXLNOq/6QvTi2oULCq+ZmkJSwoYPWSJNuGLCAEIKZ93ZR
	 qeg5zlaRcJ275/JLVVilNiqxADDoMFZDbLfe83LrAkZ8i6us/03QC6DuxfO9O7KrF9
	 orzw0sBmbKQpfLJkVErYHIR3t37IiumoFRiPofSc=
Date: Mon, 12 Oct 2026 21:31:42 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,stable@vger.kernel.org,davidgow@davidgow.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-drop-centralized-filter-range-arg-validations.patch removed from -mm tree
Message-Id: <20261013043143.210D51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: drop centralized filter range arg validations
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-drop-centralized-filter-range-arg-validations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: drop centralized filter range arg validations
Date: Mon, 14 Sep 2026 07:23:22 -0700

DAMON sysfs interface is validating wrong range arguments for DAMOS
filters.  Now the core layer is doing the same validation.  Drop the
duplicated validation in DAMON sysfs interface.

Link: https://lore.kernel.org/20260914142327.92510-6-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/damon/sysfs-schemes.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-drop-centralized-filter-range-arg-validations
+++ a/mm/damon/sysfs-schemes.c
@@ -2832,27 +2832,14 @@ static int damon_sysfs_add_scheme_filter
 			}
 		} else if (filter->type == DAMOS_FILTER_TYPE_ADDR) {
 			filter->addr_range = sysfs_filter->addr_range;
-			if (filter->addr_range.end <
-					filter->addr_range.start) {
-				damos_destroy_filter(filter);
-				return -EINVAL;
-			}
 		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
 			filter->target_idx = sysfs_filter->target_idx;
 		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
 			filter->sz_range.min = sysfs_filter->range_min;
 			filter->sz_range.max = sysfs_filter->range_max;
-			if (filter->range_min > filter->range_max) {
-				damos_destroy_filter(filter);
-				return -EINVAL;
-			}
 		} else if (filter->type == DAMOS_FILTER_TYPE_PROBE_HITS_WSUM) {
 			filter->range_min = sysfs_filter->range_min;
 			filter->range_max = sysfs_filter->range_max;
-			if (filter->range_min > filter->range_max) {
-				damos_destroy_filter(filter);
-				return -EINVAL;
-			}
 		}
 
 		damos_add_filter(scheme, filter);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch

