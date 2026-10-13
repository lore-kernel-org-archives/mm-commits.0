Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26CD4848A5;
	Tue, 13 Oct 2026 04:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866047; cv=none; b=mhuoIQXIQOWEFXz2p1YQwLEY3ZB2XzsxX0Bj/R6q/5JOBJ+oSb67wfOjmJS/G1w8Y9hktTutOeCkxfIBh5FS3NNoMk7LAUJPPgQ4j7+Pt4T6WgzSj1cqOuzyAsMPhgM6iEJNsSp/PjYSbtSCwAR5Ze8Bt/x8mvxBbmdBxooR4jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866047; c=relaxed/simple;
	bh=beg+Q7REVhP42iavj2C5HouSLDfPxa9rSXe969Zew1Y=;
	h=Date:To:From:Subject:Message-Id; b=EZPNkCLh4Aavugbtnauk/Obsvwkp0SM9O5kyoefNXCxPUTEKSTXm9wqeIDLtGXufJ3v714W1n3Iw94X2VqNQmZJnsl/3RpYcrkwByRY6BnHZxK2wtfSs+CaIlJWkd3QJ+9bYNoO3EQuYONX6i8qqd8dIzw9Zvzds+m6QQ2N6fHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gzw5uk4h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gzw5uk4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794B31F00893;
	Tue, 13 Oct 2026 04:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866044;
	bh=CBvpEWbS4C2LqxsYy/6x1X3sgYiJ/vNd2eL+iwFxRvU=;
	h=Date:To:From:Subject;
	b=Gzw5uk4hCyWkMrlq2kduirPHKbzGJQjWCLgJTHvXGjy5BsLNVQb6rDKjduOQM9Cmj
	 glr+BYjBxHdnx1cLpHj6ivIGBmMtkX49YbDMdpsJn5PzG3avmxJz+0d+J1VkmdcOpy
	 bHAs2sFcgiGteeNnv8MtOuewmDFIGDCkhNNbjJZE=
Date: Mon, 12 Oct 2026 21:34:04 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,david@davidgow.net,brendan.higgins@linux.dev,donggeunyoo.kernel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-charge-only-the-part-of-a-region-the-filter-left.patch removed from -mm tree
Message-Id: <20261013043404.794B31F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: charge only the part of a region the filter left
has been removed from the -mm tree.  Its filename was
     mm-damon-core-charge-only-the-part-of-a-region-the-filter-left.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Subject: mm/damon/core: charge only the part of a region the filter left
Date: Mon, 21 Sep 2026 08:24:41 -0700

Patch series "mm/damon/core: fix the size charged for a filter-trimmed
region", v2.

An address range DAMOS filter that partially overlaps a monitoring region
splits it, so the scheme action reaches only one side of the boundary. 
damos_apply_scheme() reads the region size before that split and never
re-reads it, so the quota charge and schemes/<S>/stats/sz_tried account
for the whole original region.

Patch 1 re-reads the size after the core filters have run.  Patch 2 adds
KUnit coverage for what the function charges and reports, for the trimmed
cases and for the cases that must not change.


This patch (of 2):

An address range DAMOS filter that partially overlaps a monitoring region
splits the region at the filter boundary, so the scheme action is applied
to only one side of it.  damos_apply_scheme() reads the region size once
on entry, before damos_core_filter_out() performs that split.

The quota charge and the statistics update therefore account for the
region as it was before the trim.  schemes/<S>/stats/sz_tried counts
memory the filter excluded, which Documentation/mm/damon/design.rst says
is not counted as tried, and with quotas/bytes set the excluded part is
charged against the budget, throttling the scheme to a fraction of what
was configured.

User impact is that DAMOS could unexpectedly slowly run, due to
over-charged quota.  DAMOS stat could also be confusing.  No critical
events such as crashes or leask happen.

Re-read the region size after the core filters have run.

Link: https://lore.kernel.org/20260921152443.80132-1-sj@kernel.org
Link: https://lore.kernel.org/20260921152443.80132-2-sj@kernel.org
Fixes: ab9bda001b68 ("mm/damon/core: introduce address range type damos filter")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <david@davidgow.net>
Cc: <stable@vger.kernel.org>
---

 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c~mm-damon-core-charge-only-the-part-of-a-region-the-filter-left
+++ a/mm/damon/core.c
@@ -2784,6 +2784,7 @@ static void damos_apply_scheme(struct da
 		}
 		if (damos_core_filter_out(c, t, r, s))
 			return;
+		sz = damon_sz_region(r);
 		ktime_get_coarse_ts64(&begin);
 		trace_damos_before_apply(cidx, sidx, tidx, r, nr_accesses,
 				damon_nr_regions(t), do_trace);
_

Patches currently in -mm which might be from donggeunyoo.kernel@gmail.com are

userfaultfd-clear-the-inherited-uffd-bit-in-move_swap_pte.patch
mm-damon-core-prevent-size-quota-overflow-in-the-temporal-goal-tuner.patch
mm-damon-tests-core-kunit-test-the-temporal-tuners-size-quota-conversion.patch

