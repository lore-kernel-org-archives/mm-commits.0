Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E570833936C
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465803; cv=none; b=bfZjkhOM8Yq3GDhkpCPUqZO0466gXf0uC1s/Sv9NfIIjfd6+enhW6BnMNGbsftUOT+fyzx2vPujgg52mrv1YRDM2rKw6Hiol2L3D2pLoKGIE+iFGVZrqdLGzWNrmeauOD6pZAKu41X0uHS3hRtWN1BmMVGMKVl07p9zrT0LkrEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465803; c=relaxed/simple;
	bh=S2Wvlqj3MwbTEHdiOWb5ymBBHEAAM5TGBVUKTLg96UQ=;
	h=Date:To:From:Subject:Message-Id; b=TRiD2iNleT6vhXsqgj+9GPG9A0RpxQZAINGaOC6ZR7Zz1vBC9tq4uuJU7zOKSidV5/J2d3YCVn5xW/HD3wWWW/5OE4nSNLoCx8x3A9Xkal3RtvWqU4uEJynP4i7RYHLLIDuMs213OxL4QnyTf1unHtkNObZrNi20MPL9B5Ec+Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m/JoSScY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m/JoSScY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6E41F00A3A;
	Fri, 31 Jul 2026 02:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465801;
	bh=AxeQIQBVHadd6dYL4qoscZpmmE/B6viMfYVdwwXDij0=;
	h=Date:To:From:Subject;
	b=m/JoSScYWvo7vd/DDUodWlLmF1QFGkRE0SN5uyLMccp7ZmLPd2y8Cce40OOqgzf7w
	 P9noTn6lwIXprt7PFkecKSxho46P9fHPImtkFVzRb2zDYvVnKrr6HopFgKyfT6DP84
	 a64alB/FeCnKTbcxCUWXNbACRZQ+Ur0pnzV5kzaE=
Date: Thu, 30 Jul 2026 19:43:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@kernel.org,surenb@google.com,harry@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-relax-gfp-warn-in-nolock-allocs.patch removed from -mm tree
Message-Id: <20260731024321.BB6E41F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: relax GFP WARN in nolock allocs
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-relax-gfp-warn-in-nolock-allocs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-secretmem-dont-allow-highmem-folios.patch
mm-page_alloc-dont-spin_trylock-in-nmi-on-up.patch
mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page.patch
mm-page_alloc-rename-fpi_trylock-fpi_nolock.patch
cgroup-cpuset-update-some-comments-about-the-page-allocator.patch
mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch
mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch

