Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672154;
	b=5lDnw53ij+uxSop1//oJ2a0RyR3S1H8ZRkSxerfMeGfm5W19cuXF3WeQ8wZDxIV8Bhvo
	 mQZsNr1a7SV/ClsvnBI4Iwa0sItVUeUeoiEPjcQv23923t01pUxMhbpyn4+zPdceUqlSW
	 zLHYRfz1rioGmPVDiQKdYXivkxBT2q8YX52eq6OifvC5PWzNJkX+q8mX+L3y/GoRXpg4W
	 mxz39HDeTYteFf09w41X+g1815Mvojwv5+apmAQFAL0mmsZXocBNCdXwWeydWk9xMGxUN
	 Eg38wgnq94y5pJU1+S5fFMpYPO2Sw2pQ35ixhGviJ21gnbHGqK1UJQBa4DtmYe76Y+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672154;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=8zc82ypHzo61GO4HphwSBWFVY9RadgorQVLqlpKErQY=;
	b=aCH6YDXvhnm1axVLjYPxNQ/8UoriI1sbnWLoyZeUOD66pQl85LzpkMMt+96f8lh/qnja
	 YcWn7pIusIsYc6GguLCmqRn41w9roB4Pb3MpohR/ZrKRn8Lr+kPi7NfCc4/OfJ8qPeDe7
	 roiDCWQ8XgcpO92JF/NLsyjR3qviXLdfnGqJtu7n4p+1nKEQVF51grrERcTjvLoLob41M
	 UQEXjyhKrqDBz3aDhKrduepWW1nwkEZHGP1qy8RvSXKzXTp/CHivQcMmknEt/SdrR71lo
	 ujSv4vbW4PEf+NhCuxRse8rL29538k1WLv8O180c0avdPOhywPyzNZB8Aep2bLv+WZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TfVWb82H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7636A606A333;
	Tue,  3 Nov 2026 02:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TfVWb82H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360061F0093A;
	Tue,  3 Nov 2026 02:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672154;
	bh=8zc82ypHzo61GO4HphwSBWFVY9RadgorQVLqlpKErQY=;
	h=Date:To:From:Subject;
	b=TfVWb82H2IMiZvSnzVkT4SQlTKnIpnQY7PHvyQj0GdwWSfl/0FhN7VSH5HdsChwa7
	 gKComxhAffPO6cAcEvt8wQu9/ukburB9UuILTsLsZeFWBwgRC1tFxokWJm5M9BIWds
	 HVAe2ww/hp9NNFeuoqa3q54fe6OiM9yGnqQSMzCs=
Date: Mon, 02 Nov 2026 18:15:53 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,
	vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,mhocko@suse.com,
	mgorman@techsingularity.net,matt@readmodwrite.com,hch@lst.de,
	dipiets@amazon.it,dgc@kernel.org,brendan.jackman@linux.dev,
	balbirs@nvidia.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-remove-alloc_non_block-from-alloc_reserves.patch removed from -mm tree
Message-Id: <20261103021554.360061F0093A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RESERVES
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-alloc_non_block-from-alloc_reserves.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RESERVES
Date: Wed, 28 Oct 2026 13:15:54 -0400

1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
non-blocking allocations accesses reserves") stopped handing out reserve
access for ALLOC_NON_BLOCK on its own: the extra 25% below the min
watermark is now only granted on top of ALLOC_MIN_RESERVE.  But the flag
was left in ALLOC_RESERVES, which produces something odd:

With the ALLOC_RESERVES match, __zone_watermark_unusable_free() doesn't
subtract the free highatomic pages for them.  So in the slowpath, they get
to consume regular blocks below the min watermark by the number of free
highatomic pages.  The highatomic reserve is capped at 1% of the zone,
which on any decently sized machine is a multiple of the min watermark:
GFP_NOWAIT can drain regular memory to zero.

The user-visible result is brutal hiccups during bursts of GFP_NOWAIT
allocations under memory pressure.  This was found in review and
reproduced with a synthetic burst, not observed in production, but the
sequence of events is a realistic one: On a 32G box with an anonymous
working set, swap, and a filled 290M highatomic reserve, a GFP_NOWAIT
burst drove regular free memory in the 28G Normal zone (min=60M) to 28M,
0.8M and 0.6M in three runs.  Swapout failed to allocate its swap table,
reclaim scanned 13M pages to reclaim 200k, page faults stalled for tens to
hundreds of milliseconds.  The machine survives it, but not by design:
direct reclaimers eventually fail and start unreserving highatomic blocks,
until the allocation succeeds or the reserve is gone and the OOM killer
runs.  That reserve exists for high-order atomic allocations; here it is
destroyed to bail out a GFP_NOWAIT consumer that was never entitled to the
memory.

Remove ALLOC_NON_BLOCK from ALLOC_RESERVES.  With that, the GFP_NOWAIT
burst is stopped short at the min watermark.  No direct reclaim, no
stalls, no failed allocations, and the highatomic reserve stays intact for
the requests it exists for.

__zone_watermark_ok() is unaffected, since everything it keys on
ALLOC_NON_BLOCK is already nested under ALLOC_MIN_RESERVE.  Update the
flag comments accordingly: ALLOC_NON_BLOCK just means the caller can't
block; the reserve math belongs with ALLOC_MIN_RESERVE.

GFP_ATOMIC order-0 requests have a milder version of the same problem. 
Through ALLOC_MIN_RESERVE they also count the free highatomic pages in
their watermark check, but rmqueue_buddy() serves them regular pages first
and only falls back to the reserve once those are gone.  They can still
push regular free memory to 37.5% of min minus the free highatomic pages
before the reserve is touched.  Unlike GFP_NOWAIT they are entitled to the
reserve, so this needs the watermark check and the freelist order reworked
together, and is left to a separate patch.

Link: https://lore.kernel.org/20261028171719.2043421-3-hannes@cmpxchg.org
Fixes: 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH non-blocking allocations accesses reserves")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Salvatore Dipietro <dipiets@amazon.it>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dgc@kernel.org>
Cc: Matt Fleming <matt@readmodwrite.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
---

 mm/page_alloc.h |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.h~mm-page_alloc-remove-alloc_non_block-from-alloc_reserves
+++ a/mm/page_alloc.h
@@ -32,12 +32,11 @@
 #define ALLOC_OOM		ALLOC_NO_WATERMARKS
 #endif
 
-#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. Allow access
-				       * to 25% of the min watermark or
-				       * 62.5% if __GFP_HIGH is set.
-				       */
+#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. */
 #define ALLOC_MIN_RESERVE	 0x20 /* __GFP_HIGH set. Allow access to 50%
-				       * of the min watermark.
+				       * of the min watermark, or 62.5% if
+				       * the caller cannot block either
+				       * (ALLOC_NON_BLOCK).
 				       */
 #define ALLOC_CPUSET		 0x40 /* check for correct cpuset */
 #define ALLOC_CMA		 0x80 /* allow allocations from CMA areas */
@@ -58,7 +57,7 @@
 #define ALLOC_NO_CODETAG       0x1000
 
 /* Flags that allow allocations below the min watermark. */
-#define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
+#define ALLOC_RESERVES (ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
 /* Flags that mean GFP_ATOMIC */
 #define ALLOC_MASK_ATOMIC (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


