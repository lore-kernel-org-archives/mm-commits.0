Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793250805;
	b=26JUaM4OKsXEkL/MPh+K1uttIThT6YdEbOxrMYwBt2Ja0K50+MVhvapM8Nm/7pGAt3dl
	 wKC8+urgMTeai2tITuKefD3Hz5d1QBadv3Kb/IkauV5V0LEUS/uXt2Lo4ukvAXr8baIXQ
	 aCIwp98ic/DY36ya+6kx38Lg3fsfCem3l0N9K6feIBG5ves1ICE1J8YoOJcC35B2Mc8YE
	 gb+ZHyBBDY6IHeboGhN5oNS1WXMFxMmjdUCHngJeo7E0qpJ0r+dPueR5jj2JhtKYCdNY5
	 dcOrtL2D3TSUc6EUPi1yCgOmv6wRMkYGIVjayL6fAkBYQd1eIzQCql2xxCL1CDoekVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793250805;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Foe1vq+NqkuZvbUjaHVfnSKmFDlcFkBCvADLFYwmu70=;
	b=N1sZFK44q/VRNjeHRI158KJjcjYvXmJG9iqB1BnSJOIzhdy6cusRmR9MKjRCRe6MYsSw
	 3fQIGtooqbS0pIVngQGFJDpvSTqSNkpzcus5SsvoYtbsD9DH6pPmgk9g11V2xLJBGK0+D
	 JKxSdHIL3uc2w/JWBcTuqELs5nLrdjAjFt5jJ7WXSihUxdga3nFekfaI7TJkTN98vn0rt
	 XJ6fRvcCeLzGcsBTr0PzTqJgs8+wUFOxcl8ylyurzOIdyX35ClrQJI8G1FwjejUIx077c
	 SZdvxlgm0jfftrR9DbbzGMLuXSGer9xOGMOPm0osKkcySkaFYf9PHBsBL+vDPsOgYRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=y+4pAkcq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7240606A31E;
	Thu, 29 Oct 2026 05:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=y+4pAkcq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597401F01825;
	Thu, 29 Oct 2026 05:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793250804;
	bh=Foe1vq+NqkuZvbUjaHVfnSKmFDlcFkBCvADLFYwmu70=;
	h=Date:To:From:Subject;
	b=y+4pAkcqT2clpGANyYQFoG7op1jAwECUHY0eE/g434RZu3SsWRyBJ82PzrRgc0IwJ
	 zhiL97C0x/4RP7gnyrvmI4BiOO1bOCmE2zg0b3uN1iGosUmu7lbuWWe70SdcVZHRmL
	 oLGOk29KnyVnqKPSbCz4xRF5rLChVKWnEXshxBa4=
Date: Wed, 28 Oct 2026 22:13:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,
	vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,mhocko@suse.com,
	mgorman@techsingularity.net,matt@readmodwrite.com,hch@lst.de,
	dipiets@amazon.it,dgc@kernel.org,brendan.jackman@linux.dev,
	hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-alloc_non_block-from-alloc_reserves.patch added to mm-hotfixes-unstable branch
Message-Id: <20261029051324.597401F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RESERVES
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-remove-alloc_non_block-from-alloc_reserves.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-alloc_non_block-from-alloc_reserves.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Vlastimil Babka <vbabka@kernel.org>
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

mm-page_alloc-do-not-give-all-non-blocking-requests-reserve-access.patch
mm-page_alloc-remove-alloc_non_block-from-alloc_reserves.patch

