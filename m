Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049BB4AEF7
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247737; cv=none; b=gVH4kNwHFdaCCVPY+d+vBM/P6hrAHmFI5+nOeH1clScpx7cPi+jHkD6zMSYg4UjFnZzDTAStFPYbedMhFoUuq+QufQ0vzyJDrhMBMiZ231ckMelXaTp//T1j8Oc64n/Bq305YRec0T+uDms1YTrNoAbrueGurCGStfAFrXrPp+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247737; c=relaxed/simple;
	bh=ejH2wMFJdTIpejG69TDI/q2wXMU/BMuab+XA0H7tbN4=;
	h=Date:To:From:Subject:Message-Id; b=dwmE5nT7erAPf0IA5/bi/gkkZ/DynqaLfFAozGWZaRrQoq+4JTR81AUKUSooPymy31ZzhDKsYRzIIMtE/v6HFFfom0Q3JO1Onk4chP7sX2lvdJNTQnZWJQn2BVhEZtqDGcoVs5d2Y1le+7FejZtdQ/+Qi/naCd+NWhqOHrxLNWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T0+iAa48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T0+iAa48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB38C4CEC2;
	Mon,  2 Sep 2024 03:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247736;
	bh=ejH2wMFJdTIpejG69TDI/q2wXMU/BMuab+XA0H7tbN4=;
	h=Date:To:From:Subject:From;
	b=T0+iAa48RyzzOhbR5wU6GUvfTTs1VCWUSHBR9xvJWJ96PLuW2cVnQDuD2o6PzIabG
	 3Ulb79EhiTyZeqQN3u+MzJkztevV759mcz5CtACioylVBSbXs/8f5RcHk31p11PMuI
	 eyvF3m99C4+j5pY2NZucyi5YgWSaVojtESmnshuo=
Date: Sun, 01 Sep 2024 20:28:56 -0700
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,baolin.wang@linux.alibaba.com,kaiyang2@cs.cmu.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-consider-cma-pages-in-watermark-check-for-numa-balancing-target-node.patch removed from -mm tree
Message-Id: <20240902032856.8CB38C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: consider CMA pages in watermark check for NUMA balancing target node
has been removed from the -mm tree.  Its filename was
     mm-consider-cma-pages-in-watermark-check-for-numa-balancing-target-node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Subject: mm: consider CMA pages in watermark check for NUMA balancing target node
Date: Thu, 1 Aug 2024 18:04:56 +0000

Currently in migrate_balanced_pgdat(), ALLOC_CMA flag is not passed when
checking watermark on the migration target node.  This does not match the
gfp in alloc_misplaced_dst_folio() which allows allocation from CMA.

This causes promotion failures when there are a lot of available CMA
memory in the system.

Therefore, we change the alloc_flags passed to zone_watermark_ok() in
migrate_balanced_pgdat().

Link: https://lkml.kernel.org/r/20240801180456.25927-1-kaiyang2@cs.cmu.edu
Signed-off-by: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-consider-cma-pages-in-watermark-check-for-numa-balancing-target-node
+++ a/mm/migrate.c
@@ -2526,7 +2526,7 @@ static bool migrate_balanced_pgdat(struc
 		if (!zone_watermark_ok(zone, 0,
 				       high_wmark_pages(zone) +
 				       nr_migrate_pages,
-				       ZONE_MOVABLE, 0))
+				       ZONE_MOVABLE, ALLOC_CMA))
 			continue;
 		return true;
 	}
_

Patches currently in -mm which might be from kaiyang2@cs.cmu.edu are

mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations.patch
mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations-v4.patch

