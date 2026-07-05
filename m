Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0473603E8
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 07:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783236721; cv=none; b=HExXjZ0OV1rrAhpwch/vjclGE4Qh7QEJ1ILgLFIteiN7Arnm4jk3TECGyBFIrL3z20I9oMKgKqbuPXl4UP5ljpDPBTknDQJUlfD+/WAumEWhw7L3Ttq0GyQhx+bDbcTJkuiGBfJFoo3AnSeHO2vkGh2u94Nx2Aw4oKwfeS1e0RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783236721; c=relaxed/simple;
	bh=6SnBif3ZhF5Tpe47cXGKf89RdZjsbU8OPRjyudppikg=;
	h=Date:To:From:Subject:Message-Id; b=XKoNXE4o7NrSFHpZbs0xnw1AtOI/3GqwIBivWjBPEpTEPryRntqUZoHC9g7itw2BlQfS8DzFhsamxgO61FFovaFxcPz1X56D3NAu3Iu9pakj7EGLh7udCHESe5CXfLl3mJeaN4zbFz90r7dYrBGO24Lhu/btyTIusdeoKQgWCfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F6XngO8x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F6XngO8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE8B1F000E9;
	Sun,  5 Jul 2026 07:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783236719;
	bh=AF0wM4N0nI4tCvtFuumn8Xuqniwa/+Pam0CmhbdQW3Q=;
	h=Date:To:From:Subject;
	b=F6XngO8xgevbmYOUcatshbkAr4UiLZowmW/DfDRZMVW4Q2u4o38fjBFdOL726vXnk
	 BpcrzDV3lnls2IEFZFPZKUc/vuEAM2eS0ywUs+wXXy+XAG3FfI0bjgpcA46TZy8RYj
	 pRNAtSCv2rrNWUz0j55k6jNxdmB6Xyjs2eSnZzW4=
Date: Sun, 05 Jul 2026 00:31:59 -0700
To: mm-commits@vger.kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-drop-alloc_flags-arg-from-alloc_flags_cma.patch added to mm-new branch
Message-Id: <20260705073159.ABE8B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: drop alloc_flags arg from alloc_flags_cma()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-drop-alloc_flags-arg-from-alloc_flags_cma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-drop-alloc_flags-arg-from-alloc_flags_cma.patch

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
Subject: mm/page_alloc: drop alloc_flags arg from alloc_flags_cma()
Date: Fri, 03 Jul 2026 12:31:57 +0000

To align the style with other alloc_flags_*() functions, drop this
additive argument and just have the callers do that themselves.

Note you can't always freely or alloc_flags like these callers do (because
of the WMARK bits that encode an enum) but this is fine for ALLOC_CMA,
just like it's fine for e.g.  ALLOC_NON_BLOCK returned by
alloc_flags_nonblocking() and or'd by its caller.

Link: https://lore.kernel.org/20260703-alloc-trylock-v5-17-c87b714e19d3@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Link: https://lore.kernel.org/all/5dcdd1ef-21ad-4ed0-9e8a-0e5cf96b4392@kernel.org/
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-drop-alloc_flags-arg-from-alloc_flags_cma
+++ a/mm/page_alloc.c
@@ -3775,14 +3775,13 @@ alloc_flags_nofragment(struct zone *zone
 }
 
 /* Must be called after current_gfp_context() which can change gfp_mask */
-static inline unsigned int alloc_flags_cma(gfp_t gfp_mask,
-					   unsigned int alloc_flags)
+static inline unsigned int alloc_flags_cma(gfp_t gfp_mask)
 {
 #ifdef CONFIG_CMA
 	if (gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
-		alloc_flags |= ALLOC_CMA;
+		return ALLOC_CMA;
 #endif
-	return alloc_flags;
+	return ALLOC_DEFAULT;
 }
 
 /*
@@ -4526,7 +4525,7 @@ alloc_flags_slowpath(gfp_t gfp_mask, uns
 	} else if (unlikely(rt_or_dl_task(current)) && in_task())
 		alloc_flags |= ALLOC_MIN_RESERVE;
 
-	alloc_flags = alloc_flags_cma(gfp_mask, alloc_flags);
+	alloc_flags |= alloc_flags_cma(gfp_mask);
 
 	if (defrag_mode)
 		alloc_flags |= ALLOC_NOFRAGMENT;
@@ -4837,7 +4836,7 @@ retry:
 
 	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
 	if (reserve_flags)
-		alloc_flags = alloc_flags_cma(gfp_mask, reserve_flags) |
+		alloc_flags = alloc_flags_cma(gfp_mask) | reserve_flags |
 				ac->alloc_flags | (alloc_flags & ALLOC_KSWAPD);
 
 	/*
@@ -5070,7 +5069,7 @@ static inline bool prepare_alloc_pages(g
 	    should_fail_alloc_page(gfp_mask, order))
 		return false;
 
-	*alloc_flags = alloc_flags_cma(gfp_mask, *alloc_flags);
+	*alloc_flags |= alloc_flags_cma(gfp_mask);
 
 	/* Dirty zone balancing only done in the fast path */
 	ac->spread_dirty_pages = (gfp_mask & __GFP_WRITE);
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-page_alloc-drop-flag-conversion-optimisation.patch
mm-secretmem-disable-under-highmem.patch
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

