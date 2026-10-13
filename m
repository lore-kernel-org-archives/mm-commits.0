Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C348477282;
	Tue, 13 Oct 2026 04:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865903; cv=none; b=DF1ArbYKdOx8yPPODwJ6DwAILbELKY2Yd2rist5PAOzFruOUdRC91OBSWq2vF6Zkz3ZiNFkAJUizSjGTZLuPa+iknOuQy9EVy1iA3MHweMVAzrsIFSNQSs60elm5eYTmziiJmHjHOO9wkcK5rP43EaLJyNR9mjZc3Sldw4iPhsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865903; c=relaxed/simple;
	bh=WdrsIjLP9SmWm9+CavLWsIsfar1EXi/LWZkbZl2CVKM=;
	h=Date:To:From:Subject:Message-Id; b=sOTGtIsEzpF5NCEPtzTWHnvvMm8KpEv7mbUJPzLYqaxarD2ZRxCBRf2wtPk8mfqB+omgqZgIqQeCJkCq6K7X941FZeggSsvzOECf33+llFglW60utE1yAlEwLLo8LpVPrHB+GP7FRGfdT+VAaSloZDsMy71AaSpvJCz+ch7qKcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZyYPuztB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZyYPuztB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9661F00893;
	Tue, 13 Oct 2026 04:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865902;
	bh=MG0GjuriJ8pkWWaid941dyXH2n9Mqxv3Dc2tT70/gIM=;
	h=Date:To:From:Subject;
	b=ZyYPuztBl16uvw2ZuAkwrPrMMYSRR1azHnz1aGGIg0A3KWycj6Bc84qIBoPITqIpK
	 wRkfUaWJhluYIWG96rlDfQf2oZHVBjBeH8j2xelOpOem7ivmqwLN837NyH4ITJFfWc
	 q9bdpNSIlxcaFU6h8EZa30UqLM4vyePknGNa9Tio=
Date: Mon, 12 Oct 2026 21:31:41 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,stable@vger.kernel.org,davidgow@davidgow.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-disallow-max-min-damos-filter-range-arguments-commit.patch removed from -mm tree
Message-Id: <20261013043141.EF9661F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: disallow max < min damos filter range arguments commit
has been removed from the -mm tree.  Its filename was
     mm-damon-core-disallow-max-min-damos-filter-range-arguments-commit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: disallow max < min damos filter range arguments commit
Date: Mon, 14 Sep 2026 07:23:21 -0700

damos_commit_filter_arg() receives range arguments for a few types of
DAMOS filters.  It allows any range including max < min range.  It is fine
for the logic, but makes no sense to support it.  Actually DAMON sysfs
interface is doing the validation on its own.  To avoid duplicated
validations in multiple DAMON API callers, it would be better to do the
validation in the core layer.  Add a validation of the given range.

Link: https://lore.kernel.org/20260914142327.92510-5-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/damon/core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-disallow-max-min-damos-filter-range-arguments-commit
+++ a/mm/damon/core.c
@@ -1325,15 +1325,21 @@ static int damos_commit_filter_arg(
 		dst->memcg_id = src->memcg_id;
 		break;
 	case DAMOS_FILTER_TYPE_ADDR:
+		if (src->addr_range.end < src->addr_range.start)
+			return -EINVAL;
 		dst->addr_range = src->addr_range;
 		break;
 	case DAMOS_FILTER_TYPE_TARGET:
 		dst->target_idx = src->target_idx;
 		break;
 	case DAMOS_FILTER_TYPE_HUGEPAGE_SIZE:
+		if (src->sz_range.max < src->sz_range.min)
+			return -EINVAL;
 		dst->sz_range = src->sz_range;
 		break;
 	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+		if (src->range_max < src->range_min)
+			return -EINVAL;
 		dst->range_min = src->range_min;
 		dst->range_max = src->range_max;
 		break;
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

