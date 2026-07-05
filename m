Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827B332D0FC
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 07:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783236672; cv=none; b=OVocP8h/sw+y17nv8oYWZka9I79EUIA4G5j3ExAjPuwrbgJ7ffd2S0mZvwWDNHCEJB8zvXI70PWZbtlwGt9i3R2WhlS5qKsBjrEV4sviQWHon57W5fih9V6r6JtLdzJvZJ6gdzgBhA9lKxuBTuwqwqlWvnVMUsnZN970F1YxnJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783236672; c=relaxed/simple;
	bh=0DPC9rH9H6uGJOfz0et7UW9m4AEOuo8lfBivroHorH4=;
	h=Date:To:From:Subject:Message-Id; b=bxVJ7mbyK6PzA6NOz+bF+qlGHGE3LCknist4X8pRvsynhGD+77HSVIDcYNjo4maeRm53wMwXMBMKz6N2re41gJQuIhQgC4VPIpToGLieFCjKu+lc5QNIJYyNiSzUguz3Qbcf5BGKM0dxrMk+kX/uaRCDjdfl37OKkoSvuV2jIog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UEJectzc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UEJectzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152771F000E9;
	Sun,  5 Jul 2026 07:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783236671;
	bh=0CngKKa36E71BzaC+460PrSHQrY+hxNHHmPeSMn3eyI=;
	h=Date:To:From:Subject;
	b=UEJectzcdhEYd82i6j98amhJoO+Uss2aVVAsR6ld4feoYVBATSB0jFDD8apR2HVtD
	 Yz5+zC0HAgtu9Ef0T+yu6JbqaNU4QD8VuD/XqlyAnNIXv992XTHmLrJd1coNVA1v9/
	 fW4jPEv4dJL7mJsls0/yfr9Qin9j7jxMHW+ZvMBU=
Date: Sun, 05 Jul 2026 00:31:10 -0700
To: mm-commits@vger.kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-some-renames-to-clarify-alloc_flags-scopes.patch added to mm-new branch
Message-Id: <20260705073111.152771F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: some renames to clarify alloc_flags scopes
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-some-renames-to-clarify-alloc_flags-scopes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-some-renames-to-clarify-alloc_flags-scopes.patch

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
Subject: mm/page_alloc: some renames to clarify alloc_flags scopes
Date: Fri, 03 Jul 2026 12:31:42 +0000

It's pretty confusing that:

- The slowpath and fastpath have a totally distinct set of alloc_flags.

- gfp_to_alloc_flags() sounds generic but it only influences the
  slowpath.

Rename some variables to highlight which alloc_flags are
fastpath-specific.  Rename gfp_to_alloc_flags() to highlight that it's
slowpath-specific.

gfp_to_alloc_flags_cma() and gfp_to_alloc_flags_nonblocking() currently
have perfectly harmless names, but to keep the naming consistent also
rename those to the alloc_flags_*() pattern (which already exists for
alloc_flags_nofragment()).

Link: https://lore.kernel.org/20260703-alloc-trylock-v5-2-c87b714e19d3@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: JP Kobryn <jp.kobryn@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/skbuff.h |    2 +-
 mm/page_alloc.c        |   28 ++++++++++++++--------------
 2 files changed, 15 insertions(+), 15 deletions(-)

--- a/include/linux/skbuff.h~mm-page_alloc-some-renames-to-clarify-alloc_flags-scopes
+++ a/include/linux/skbuff.h
@@ -3573,7 +3573,7 @@ static inline struct page *__dev_alloc_p
 	 * 3.  If requesting a order 0 page it will not be compound
 	 *     due to the check to see if order has a value in prep_new_page
 	 * 4.  __GFP_MEMALLOC is ignored if __GFP_NOMEMALLOC is set due to
-	 *     code in gfp_to_alloc_flags that should be enforcing this.
+	 *     code in alloc_flags_slowpath() that should be enforcing this.
 	 */
 	gfp_mask |= __GFP_COMP | __GFP_MEMALLOC;
 
--- a/mm/page_alloc.c~mm-page_alloc-some-renames-to-clarify-alloc_flags-scopes
+++ a/mm/page_alloc.c
@@ -3774,8 +3774,8 @@ alloc_flags_nofragment(struct zone *zone
 }
 
 /* Must be called after current_gfp_context() which can change gfp_mask */
-static inline unsigned int gfp_to_alloc_flags_cma(gfp_t gfp_mask,
-						  unsigned int alloc_flags)
+static inline unsigned int alloc_flags_cma(gfp_t gfp_mask,
+					   unsigned int alloc_flags)
 {
 #ifdef CONFIG_CMA
 	if (gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
@@ -4474,7 +4474,7 @@ static void wake_all_kswapds(unsigned in
 }
 
 static inline unsigned int
-gfp_to_alloc_flags_nonblocking(gfp_t gfp_mask, unsigned int order)
+alloc_flags_nonblocking(gfp_t gfp_mask, unsigned int order)
 {
 	unsigned int alloc_flags = 0;
 
@@ -4497,7 +4497,7 @@ gfp_to_alloc_flags_nonblocking(gfp_t gfp
 }
 
 static inline unsigned int
-gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
+alloc_flags_slowpath(gfp_t gfp_mask, unsigned int order)
 {
 	unsigned int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
 
@@ -4512,7 +4512,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsig
 	if (gfp_mask & __GFP_KSWAPD_RECLAIM)
 		alloc_flags |= ALLOC_KSWAPD;
 
-	alloc_flags |= gfp_to_alloc_flags_nonblocking(gfp_mask, order);
+	alloc_flags |= alloc_flags_nonblocking(gfp_mask, order);
 
 	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
 		/*
@@ -4525,7 +4525,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsig
 	} else if (unlikely(rt_or_dl_task(current)) && in_task())
 		alloc_flags |= ALLOC_MIN_RESERVE;
 
-	alloc_flags = gfp_to_alloc_flags_cma(gfp_mask, alloc_flags);
+	alloc_flags = alloc_flags_cma(gfp_mask, alloc_flags);
 
 	if (defrag_mode)
 		alloc_flags |= ALLOC_NOFRAGMENT;
@@ -4791,7 +4791,7 @@ restart:
 	 * kswapd needs to be woken up, and to avoid the cost of setting up
 	 * alloc_flags precisely. So we do that now.
 	 */
-	alloc_flags = gfp_to_alloc_flags(gfp_mask, order);
+	alloc_flags = alloc_flags_slowpath(gfp_mask, order);
 
 	/*
 	 * We need to recalculate the starting point for the zonelist iterator
@@ -4832,7 +4832,7 @@ retry:
 
 	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
 	if (reserve_flags)
-		alloc_flags = gfp_to_alloc_flags_cma(gfp_mask, reserve_flags) |
+		alloc_flags = alloc_flags_cma(gfp_mask, reserve_flags) |
 					  (alloc_flags & ALLOC_KSWAPD);
 
 	/*
@@ -5063,7 +5063,7 @@ static inline bool prepare_alloc_pages(g
 	    should_fail_alloc_page(gfp_mask, order))
 		return false;
 
-	*alloc_flags = gfp_to_alloc_flags_cma(gfp_mask, *alloc_flags);
+	*alloc_flags = alloc_flags_cma(gfp_mask, *alloc_flags);
 
 	/* Dirty zone balancing only done in the fast path */
 	ac->spread_dirty_pages = (gfp_mask & __GFP_WRITE);
@@ -5277,7 +5277,7 @@ struct page *__alloc_frozen_pages_noprof
 		int preferred_nid, nodemask_t *nodemask)
 {
 	struct page *page;
-	unsigned int alloc_flags = ALLOC_WMARK_LOW;
+	unsigned int fastpath_alloc_flags = ALLOC_WMARK_LOW;
 	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
 	struct alloc_context ac = { };
 
@@ -5299,18 +5299,18 @@ struct page *__alloc_frozen_pages_noprof
 	gfp = current_gfp_context(gfp);
 	alloc_gfp = gfp;
 	if (!prepare_alloc_pages(gfp, order, preferred_nid, nodemask, &ac,
-			&alloc_gfp, &alloc_flags))
+			&alloc_gfp, &fastpath_alloc_flags))
 		return NULL;
 
 	/*
 	 * Forbid the first pass from falling back to types that fragment
 	 * memory until all local zones are considered.
 	 */
-	alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
-	alloc_flags |= gfp_to_alloc_flags_nonblocking(gfp, order) & ALLOC_HIGHATOMIC;
+	fastpath_alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
+	fastpath_alloc_flags |= alloc_flags_nonblocking(gfp, order) & ALLOC_HIGHATOMIC;
 
 	/* First allocation attempt */
-	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
+	page = get_page_from_freelist(alloc_gfp, order, fastpath_alloc_flags, &ac);
 	if (likely(page))
 		goto out;
 
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

