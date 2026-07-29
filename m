Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59F23921FB
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298453; cv=none; b=CBhAd9gyPGbYoVoXE+QrX7ECjoJGu5CxxwjSP5uaZTdyubqNpmZ7tYv4w7VXoCp8KDm4UpkMEn8r6EvxhjgwY+5EE+bS0jx6stYWNCsAMCMwU4X/vR1hrlDSpKpv2Py1Ydth7iM86ZH3NBqpPFwoTM9xQEOZeomA78Oers9rF+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298453; c=relaxed/simple;
	bh=jAKxLdT/1nehogKBHRyQ3m24w1Tzjk/ElyL0I5ceky8=;
	h=Date:To:From:Subject:Message-Id; b=Xd5etQxqceDcWLf9RZJwYRR0u2FCAg2TK1GNRi+9IUxLP2DOloyZWp1010oByAHvW8+eTI4EcJqd5VQjCf9/CHxaZTKEn+nR4D03tXe3wPRORjbfEtK3qEIaKd5kjd8e4PUZLBpznuo+L0dYA815GBWS3nVW1kzYwJ87jCou1UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XPG845f2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XPG845f2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662091F000E9;
	Wed, 29 Jul 2026 04:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298451;
	bh=hz79l/2Q2pBe0z4vZ4kXEK4gtMQUZPFRfRh6jvSinaI=;
	h=Date:To:From:Subject;
	b=XPG845f2Osuyzzurel48pthbFhdfhkmvnftJVjAH/0QHQJ15jpo8+L1AzDpFhSbRn
	 mY8xxP4iECHMxSAdBUbyCk0mJZUT4xgwDVG9yd8RavzenRwm6dFTsRRhDZECMoUxcy
	 W7c/HAJORd1NB/fE5d8ZRL8qycc49DsgNQQQlEew=
Date: Tue, 28 Jul 2026 21:14:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,harry@kernel.org,hannes@cmpxchg.org,gourry@gourry.net,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-drop-flag-conversion-optimisation.patch removed from -mm tree
Message-Id: <20260729041411.662091F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: drop flag-conversion "optimisation"
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-drop-flag-conversion-optimisation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260629-gfp-pessimisation-v2-1-311ece6a8637@google.com
Link: https://lore.kernel.org/20260615-gfp-pessimisation-v2-1-65f1319e6818@google.com
Link: https://github.com/bjackman/aethelred/blob/2ccdc84ef087c2a631914f58e106e99e19bd3b98/page-alloc-test/page-alloc-test.c [1]
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-drop-flag-conversion-optimisation
+++ a/mm/page_alloc.c
@@ -3741,13 +3741,10 @@ static bool zone_allows_reclaim(struct z
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
@@ -4481,21 +4478,15 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsig
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
 
 	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
 		/*
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-page_alloc-rename-alloc_trylock-alloc_nolock.patch
mm-page_alloc-some-renames-to-clarify-alloc_flags-scopes.patch
mm-name-some-args-in-a-function-declaration.patch
mm-split-out-internal-page_alloch.patch
mm-page_alloc-unify-__alloc_frozen_pages_noprof.patch
mm-page_alloc-relax-gfp-warn-in-nolock-allocs.patch
mm-move-some-stuff-to-mm-page_alloch.patch
perf-x86-intel-use-higher-level-allocator-api.patch
kvm-vmx-use-higher-level-allocator-api.patch
x86-virt-use-higher-level-allocator-api.patch
sgi-xp-use-higher-level-allocator-api.patch
net-funeth-switch-to-higher-level-allocator-api.patch
mm-remove-__alloc_pages_node.patch
mm-move-__alloc_pages-to-mm-page_alloch.patch
mm-replace-__gfp_no_codetag-with-alloc_no_codetag.patch
mm-page_alloc-drop-alloc_flags-arg-from-alloc_flags_cma.patch
mm-factor-out-can_spin_trylock.patch
mm-secretmem-dont-allow-highmem-folios.patch
mm-page_alloc-dont-spin_trylock-in-nmi-on-up.patch
mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page.patch
mm-page_alloc-rename-fpi_trylock-fpi_nolock.patch
cgroup-cpuset-update-some-comments-about-the-page-allocator.patch
mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch
mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch

