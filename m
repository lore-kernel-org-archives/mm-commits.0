Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C0617BD3
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 06:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729750261; cv=none; b=RkeIPRCZHudRQGAd0WBDx/ucljT1Uk+17weevC6PQdjK0//E7FGov78L6Kp1KcOPHH791lM3z5gfJTMxpB3ETp4WE7B5kfatXdGmVaTxqfBsXL9x1XB/M1mLjywywf7BcSyAMmnj1v0fcqsrNWvNux+uGVpyIIODhhlWZwb01is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729750261; c=relaxed/simple;
	bh=bnqsbHP5qzEsRFJnBuAAdlzg0dBALBLDKxkNopHUhQU=;
	h=Date:To:From:Subject:Message-Id; b=cwEvN+8iJaxRUfUapWtN/aGdQP1rv922dVGDVPW26DaICtzrCdHcBbu4/jpTUJqRIL7dHas6i05y3jm3w/rqCpU0VfbN78Zcq5ehoSI/Bo+X+64nYJBzQPT+J13POYUO+ajJcXMKQDO8yQanEloorcItbiHI2R2kF+rJ60nIquY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iYVS8PdR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iYVS8PdR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCD5C4CEC7;
	Thu, 24 Oct 2024 06:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729750261;
	bh=bnqsbHP5qzEsRFJnBuAAdlzg0dBALBLDKxkNopHUhQU=;
	h=Date:To:From:Subject:From;
	b=iYVS8PdRN4lUNZ+gfEzS88c9WQBUCa5ES8gBuMrdWkeQvE/Zy/X6XLAHoC9mEwJlJ
	 mYVEGQmKecMZnohARw+IgDprWmhffqh0tTzeZcabX5M2j/3qudeD+01bmfc6wiUzN3
	 pfCIaTli1jZABpdVy1FzFFInwXaEUtM81zi2VH8Y=
Date: Wed, 23 Oct 2024 23:10:59 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@kernel.org,mgorman@techsingularity.net,mfleming@cloudflare.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-let-gfp_atomic-order-0-allocs-access-highatomic-reserves-v2.patch removed from -mm tree
Message-Id: <20241024061101.1FCD5C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_alloc-let-gfp_atomic-order-0-allocs-access-highatomic-reserves-v2
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-let-gfp_atomic-order-0-allocs-access-highatomic-reserves-v2.patch

This patch was dropped because it was folded into mm-page_alloc-let-gfp_atomic-order-0-allocs-access-highatomic-reserves.patch

------------------------------------------------------
From: Matt Fleming <mfleming@cloudflare.com>
Subject: mm-page_alloc-let-gfp_atomic-order-0-allocs-access-highatomic-reserves-v2
Date: Tue, 15 Oct 2024 13:51:58 +0100

update comment

Link: https://lkml.kernel.org/r/20241015125158.3597702-1-matt@readmodwrite.com
Link: https://lore.kernel.org/all/CAGis_TWzSu=P7QJmjD58WWiu3zjMTVKSzdOwWE8ORaGytzWJwQ@mail.gmail.com/
Fixes: 1d91df85f399 ("mm/page_alloc: handle a missing case for memalloc_nocma_{save/restore} APIs")
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-let-gfp_atomic-order-0-allocs-access-highatomic-reserves-v2
+++ a/mm/page_alloc.c
@@ -2893,10 +2893,10 @@ struct page *rmqueue_buddy(struct zone *
 			page = __rmqueue(zone, order, migratetype, alloc_flags);
 
 			/*
-			 * If the allocation fails, allow OOM handling access
-			 * to HIGHATOMIC reserves as failing now is worse than
-			 * failing a high-order atomic allocation in the
-			 * future.
+			 * If the allocation fails, allow OOM handling and
+			 * order-0 (atomic) allocs access to HIGHATOMIC
+			 * reserves as failing now is worse than failing a
+			 * high-order atomic allocation in the future.
 			 */
 			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
 				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
_

Patches currently in -mm which might be from mfleming@cloudflare.com are

mm-page_alloc-let-gfp_atomic-order-0-allocs-access-highatomic-reserves.patch

