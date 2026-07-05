Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A53225413
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 07:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783236693; cv=none; b=SAnQyC/FC99HJQuTkclTOecufJqdbg5cBGj3k5ppCqsrclWfr8J+hqR17dlQw/QRHX2D/ogketoqSHjYW3kbunkEPlJO/DLBv8wim1RIUgcZHgStI8nqepOK18ISQUjSdvBhPP+XVQCYRdJj2qvBjl1ZDTOPolxCdEXbb06dmQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783236693; c=relaxed/simple;
	bh=fiOQtKG/zTWVZ7Wy0AjfmeK4hGClwh+XliMSPZFQf18=;
	h=Date:To:From:Subject:Message-Id; b=cu8SWZSK/+SDuKbihM180SdgUBfhsjblbREkg5Ng+WB/iW3OTQAK986WRz2yj2xBG1BsJmc/yop6OZOjuBGnOmC27RXHzhrMgOoNSk7JgDac3Rsn6dK610AFVCEPokON9mHjmy+yVexkMw5ShtoPPmhNONFe4ZzBN/5IgyM9Fg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S1UfCGBP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S1UfCGBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A591F1F000E9;
	Sun,  5 Jul 2026 07:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783236691;
	bh=HTcjrS9hHywC89KtjU/JhK/ebB0lQayB+pljtdUZ5tM=;
	h=Date:To:From:Subject;
	b=S1UfCGBPPDIlGxXK+5CGVd08ysN5OWiHDBbzbG+e5PzNO6GSwDIBSbIu22XpgnsTB
	 fadMNy5nnccJXfDtBTY46WdqXRRzfWniKnl0qazWn+LEYj6roOmX8FTrNgTMH3HWcE
	 VGrplaC8aXbSpPHhcwU+4uF6SjI3YKJbQ5FSRC0w=
Date: Sun, 05 Jul 2026 00:31:31 -0700
To: mm-commits@vger.kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-relax-gfp-warn-in-nolock-allocs.patch added to mm-new branch
Message-Id: <20260705073131.A591F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: relax GFP WARN in nolock allocs
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-relax-gfp-warn-in-nolock-allocs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-relax-gfp-warn-in-nolock-allocs.patch

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
Subject: mm/page_alloc: relax GFP WARN in nolock allocs
Date: Fri, 03 Jul 2026 12:31:46 +0000

This WARN forbids setting other flags than __GFP_ACCOUNT but we
unconditionally set the ones in gfp_nolock so they are certainly fine for
the caller to set.

There are other GFP flags that are almost certainly fine to set here;
Willy noted GFP_HIGHMEM, GFP_DMA, GFP_MOVABLE and GFP_HARDWALL.  But,
nolock allocation is rather special, so be conservative to try and ensure
we have a chance to think carefully before nontrivial new usecases arise.

Link: https://lore.kernel.org/20260703-alloc-trylock-v5-6-c87b714e19d3@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Link: https://lore.kernel.org/linux-mm/ajS96fWbG4dzP3u3@casper.infradead.org/
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-relax-gfp-warn-in-nolock-allocs
+++ a/mm/page_alloc.c
@@ -5355,7 +5355,8 @@ struct page *__alloc_frozen_pages_noprof
 		return NULL;
 
 	if (alloc_flags & ALLOC_NOLOCK) {
-		VM_WARN_ON_ONCE(gfp & ~__GFP_ACCOUNT);
+		/* Certain other flags could be supported later if needed. */
+		VM_WARN_ON_ONCE(gfp & ~(__GFP_ACCOUNT | gfp_nolock));
 		if (!alloc_nolock_allowed())
 			return NULL;
 		gfp |= gfp_nolock;
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

