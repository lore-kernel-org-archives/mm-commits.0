Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564092DB789
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968149; cv=none; b=f+4yCaHA96q7skpvUWeZmIAn9h/3d+l+yNgylKiw8MUPs+qlJ2boyBTToRkZmdtL2ijLrdUPDtHLSGTLtB7kElWVqjJTuVEIalSEcAC1vaKi2A3VeTayOO9iAAzCjTbZi6sqJ1ia6/ry4EA7wDdC3RjTVf3Afx+Ux0vHakJ+TeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968149; c=relaxed/simple;
	bh=aP3UIYkRUgMYkjFkoctEfDy9XRaCq8jJEMB7M9fiPMM=;
	h=Date:To:From:Subject:Message-Id; b=FLp1ZjUAiiiUv7AkSrityZMzxUCyLMDabXrtjKHsF2DYmQw9HYmf0QXlUYkv9lug/lKX+/Q91VDK3GXuyZG4vC2PFah6Hh2dZ0HOoGVSKgjvF/z8hm/kmzCwuXro23k497imP5WWbFK87lJXwSvJjU9lQq+LGiwjpcCQ3DVV2Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IKseDxpx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IKseDxpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94961F00893;
	Tue,  9 Jun 2026 01:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968148;
	bh=jurortO/fwg32zEGDonweU4C7xnW4VNekJ0nbXHuKOU=;
	h=Date:To:From:Subject;
	b=IKseDxpxeBl+gPkbgTV+DXlImrqntONf/KIhBN4d+mPSaLJQhkfyGjf1r32gk8kc6
	 k4W4+DHxY+7N+CqQdNEsKl6d4S3PXo3WPJ61Wc6GMYwfyJ4jFXVWndasZm2Ta2kZUy
	 4iDKiQGmVm9h+66uja3pQCwrBGwHWZ5/rBaS1mqY=
Date: Mon, 08 Jun 2026 18:22:27 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,fujunjie1@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-fix-deferred-compaction-accounting.patch removed from -mm tree
Message-Id: <20260609012227.E94961F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: fix deferred compaction accounting
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-deferred-compaction-accounting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: fujunjie <fujunjie1@qq.com>
Subject: mm/page_alloc: fix deferred compaction accounting
Date: Tue, 26 May 2026 09:12:48 +0000

COMPACT_DEFERRED means compaction did not start because past failures
caused the zone to be deferred.  try_to_compact_pages() returns the
maximum result seen while walking the zonelist, so a final
COMPACT_DEFERRED result means no later zone reported that compaction
actually ran.

__alloc_pages_direct_compact() skips COMPACTSTALL and COMPACTFAIL
accounting when try_to_compact_pages() returns COMPACT_SKIPPED, but not
when it returns COMPACT_DEFERRED.  A deferred-only direct compaction
attempt can therefore look like a stall, and then a failure if the
allocation still cannot be satisfied.

Treat COMPACT_DEFERRED like COMPACT_SKIPPED in this accounting path.  If a
later zone runs compaction and returns a result above COMPACT_DEFERRED, or
compact_zone_order() reports COMPACT_SUCCESS for a captured page, the
final result is not COMPACT_DEFERRED and the existing accounting still
runs.

Link: https://lore.kernel.org/tencent_368AF1F3821E46232637BE16D65C45CF3308@qq.com
Fixes: 06dac2f467fe ("mm: compaction: update the COMPACT[STALL|FAIL] events properly")
Signed-off-by: fujunjie <fujunjie1@qq.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-deferred-compaction-accounting
+++ a/mm/page_alloc.c
@@ -4161,7 +4161,8 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	psi_memstall_leave(&pflags);
 	delayacct_compact_end();
 
-	if (*compact_result == COMPACT_SKIPPED)
+	if (*compact_result == COMPACT_SKIPPED ||
+	    *compact_result == COMPACT_DEFERRED)
 		return NULL;
 	/*
 	 * At least in one zone compaction wasn't deferred or skipped, so let's
_

Patches currently in -mm which might be from fujunjie1@qq.com are


