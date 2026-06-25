Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC4C28504F
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 22:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782427876; cv=none; b=D/7Gx8tFLWeCtPGtkW9bYUR9EQAUPeYyAcpHsnSUo81IGdimnITrAkgDk83CiMwDvTWArrlPEyn2+wEk1eFAtRN1wVxcizeCB9iPFt9ktAALOYyqysTEjN32BhpkEtjg4RhMblrW3I3BlPKe8D3nO0jfEF03pwcqqR9/vlwavxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782427876; c=relaxed/simple;
	bh=63v1Rpaz3A2l1rJ1xqnDJW37b0DyJ1uh+IKOTvsXNZA=;
	h=Date:To:From:Subject:Message-Id; b=Vlf6nhv59/f7ENOOcRWjQ5Vk543vC+8+hp0NApZGpPU+ETkNegskXUG6952KL8F61zRSHaOTgEaNNkupJxNQ1Gf6ZuGs8pSaype6yTUdnccQ1IfiCaVVtLGODcu4ZEL5LCxaN5xaEQEiJdah9Ej6DOP+A+Q7Oki4ffyluvrKbAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a+EJNbVF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a+EJNbVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664C71F000E9;
	Thu, 25 Jun 2026 22:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782427874;
	bh=v2WEbnfue9Dbb+l6T9CjgyhLMdQTQZ76Tt4oP+aWByI=;
	h=Date:To:From:Subject;
	b=a+EJNbVFsn5ZR6ZKK7I+qEckPfsszuMNeqteVie15O6SgxpQLfXJZV89IFm18c/F3
	 MpBckNxgQZHv7MouYHJ/gDhg/S7Q75vc07qTRhAwEOKZtBuIQujmJ4jk+oG8aRr9jl
	 bOsXpYxugbadbUBum4R/G1uAPnydQQ4xLXmEnRjI=
Date: Thu, 25 Jun 2026 15:51:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,harry@kernel.org,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-drop-flag-conversion-optimisation.patch added to mm-new branch
Message-Id: <20260625225114.664C71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: drop flag-conversion "optimisation"
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-drop-flag-conversion-optimisation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-drop-flag-conversion-optimisation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: drop flag-conversion "optimisation"
Date: Mon, 15 Jun 2026 10:54:34 +0000

This code uses flag equivalences to try to optimise conversion from GFP_
to ALLOC_ but there's no clear reason to believe it makes things faster. 
Even if it gets rid of conditional branches, it just trades them for a
data dependency.

CPUs are pretty good at conditional branches.  But, in my GCC x86 build it
doesn't look like there are any branches anyway, the compiler found some
conditional instruction tricks.  (Caveat: This was extracted & annotated
by Gemini AI, I did not actually read the disasm myself)

Old code:

        ae50:    8b 04 24                 mov    (%rsp),%eax           # Load gfp_mask
        ...
        ae5d:    41 89 c4                 mov    %eax,%r12d
        ae64:    41 81 e4 20 08 00 00     and    $0x820,%r12d          # Mask both flags at once
        ...
        ae6f:    44 89 e1                 mov    %r12d,%ecx
        ae77:    83 c9 40                 or     $0x40,%ecx            # OR with ALLOC_CPUSET (0x40)
        ae7a:    89 4c 24 60              mov    %ecx,0x60(%rsp)       # Store to alloc_flags

New code:

  For  __GFP_HIGH  ( 0x20 ):
  It uses the Carry Flag (via  sbb ) to conditionally add  0x20  to the base  0x40  ( ALLOC_CPUSET ) flag:

        ae63:    83 e0 20                 and    $0x20,%eax            # Test __GFP_HIGH
        ...
        ae6a:    83 f8 01                 cmp    $0x1,%eax             # Set carry flag if 0
        ae6f:    45 19 e4                 sbb    %r12d,%r12d           # %r12d = (gfp & 0x20) ? 0 : -1
        ae80:    41 83 e4 e0              and    $0xffffffe0,%r12d     # %r12d = (gfp & 0x20) ? 0 : -32
        ae87:    41 83 c4 60              add    $0x60,%r12d           # %r12d = (gfp & 0x20) ? 0x60 : 0x40

  For  __GFP_KSWAPD_RECLAIM  ( 0x800 ):
  It uses a conditional move ( cmov ) later in the function to set the  ALLOC_KSWAPD  ( 0x800 ) bit:

        ae72:    25 00 08 00 00           and    $0x800,%eax           # Test __GFP_KSWAPD_RECLAIM
        ae77:    89 44 24 30              mov    %eax,0x30(%rsp)       # Store result
        ...
        af2c:    80 cf 08                 or     $0x8,%bh              # Set ALLOC_KSWAPD (0x800) in temp reg
        af2f:    45 85 c9                 test   %r9d,%r9d             # Check if __GFP_KSWAPD_RECLAIM was set
        af32:    0f 44 d8                 cmove  %eax,%ebx             # If not, revert to flags without it

Testing with a modified version[0] of lib/free_pages_test.c (adding
printks with timing)...

Old results from a Sapphire Rapids consumer CPU:

[   67.157118] page_alloc_test: Testing with GFP_KERNEL
[   67.157122] page_alloc_test: Starting 1,000,000 allocations...
[   70.704446] page_alloc_test: Completed. Time: 3543002 us (Avg: 3543.00 ns per alloc+free loop)
[   70.704456] page_alloc_test: Testing with GFP_KERNEL | __GFP_COMP
[   70.704460] page_alloc_test: Starting 1,000,000 allocations...
[   70.944672] page_alloc_test: Completed. Time: 239980 us (Avg: 239.98 ns per alloc+free loop)
[   70.944675] page_alloc_test: Test completed

New results:

[   70.079015] page_alloc_test: Testing with GFP_KERNEL
[   70.079020] page_alloc_test: Starting 1,000,000 allocations...
[   73.669396] page_alloc_test: Completed. Time: 3586954 us (Avg: 3586.95 ns per alloc+free loop)
[   73.669402] page_alloc_test: Testing with GFP_KERNEL | __GFP_COMP
[   73.669405] page_alloc_test: Starting 1,000,000 allocations...
[   73.905084] page_alloc_test: Completed. Time: 235496 us (Avg: 235.49 ns per alloc+free loop)
[   73.905086] page_alloc_test: Test completed

Seems like a wash.

So, drop the flag value coupling here and let the compiler and CPU do
their job. Superscalar CPUs are pretty neat after all.

(Used AI for the disasm but the rest is all manual).

Link: https://lore.kernel.org/20260615-gfp-pessimisation-v2-1-65f1319e6818@google.com
Link: https://github.com/bjackman/aethelred/blob/2ccdc84ef087c2a631914f58e106e99e19bd3b98/page-alloc-test/page-alloc-test.c [1]
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Harry Yoo <harry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-drop-flag-conversion-optimisation
+++ a/mm/page_alloc.c
@@ -3742,13 +3742,10 @@ static bool zone_allows_reclaim(struct z
 static inline unsigned int
 alloc_flags_nofragment(struct zone *zone, gfp_t gfp_mask)
 {
-	unsigned int alloc_flags;
+	unsigned int alloc_flags = 0;
 
-	/*
-	 * __GFP_KSWAPD_RECLAIM is assumed to be the same as ALLOC_KSWAPD
-	 * to save a branch.
-	 */
-	alloc_flags = (__force int) (gfp_mask & __GFP_KSWAPD_RECLAIM);
+	if (gfp_mask & __GFP_KSWAPD_RECLAIM)
+		alloc_flags |= ALLOC_KSWAPD;
 
 	if (defrag_mode) {
 		alloc_flags |= ALLOC_NOFRAGMENT;
@@ -4505,21 +4502,15 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsig
 	unsigned int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
 
 	/*
-	 * __GFP_HIGH is assumed to be the same as ALLOC_MIN_RESERVE
-	 * and __GFP_KSWAPD_RECLAIM is assumed to be the same as ALLOC_KSWAPD
-	 * to save two branches.
-	 */
-	BUILD_BUG_ON(__GFP_HIGH != (__force gfp_t) ALLOC_MIN_RESERVE);
-	BUILD_BUG_ON(__GFP_KSWAPD_RECLAIM != (__force gfp_t) ALLOC_KSWAPD);
-
-	/*
 	 * The caller may dip into page reserves a bit more if the caller
 	 * cannot run direct reclaim, or if the caller has realtime scheduling
 	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
 	 * set both ALLOC_NON_BLOCK and ALLOC_MIN_RESERVE(__GFP_HIGH).
 	 */
-	alloc_flags |= (__force int)
-		(gfp_mask & (__GFP_HIGH | __GFP_KSWAPD_RECLAIM));
+	if (gfp_mask & __GFP_HIGH)
+		alloc_flags |= ALLOC_MIN_RESERVE;
+	if (gfp_mask & __GFP_KSWAPD_RECLAIM)
+		alloc_flags |= ALLOC_KSWAPD;
 
 	alloc_flags |= gfp_to_alloc_flags_nonblocking(gfp_mask, order);
 
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-page_alloc-drop-flag-conversion-optimisation.patch

