Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C00F48BD39
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 21:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772832823; cv=none; b=AA1ax8PtaCy3zTmFiYRrBbdXYL770anx3t558EBoozDT4xyeboC/3QqwhpSvc/EovkvNFo9kIbbDstQGekHximD1PrPzf1UXrb8Ut/kdi94C0lS/fSpelSITCk84toQH3euBiNEOWvB3GB7HFLe3knfvTiqiWDr50IWFcMj0gig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772832823; c=relaxed/simple;
	bh=rhahE8jKx9hlco1pwb3Eawz//t+uBk1nAbL9h6FeWME=;
	h=Date:To:From:Subject:Message-Id; b=lWWKgdMzKVrn6aNXQHlVtM90cLgDhTZjBRBDw8OQMYEepjj2k5WoBWc5jf0XLWPhpZQhM+trrr0+FllMHip7DolLPF/KLH2UdQaZD0PXNYAITTz71NZr9uvrIJti27ibqq3GBnsrKX7mQEMpjTet3ROBdPofOP6YmCF9+MkL3vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AXAcTEPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AXAcTEPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C02C4CEF7;
	Fri,  6 Mar 2026 21:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772832822;
	bh=rhahE8jKx9hlco1pwb3Eawz//t+uBk1nAbL9h6FeWME=;
	h=Date:To:From:Subject:From;
	b=AXAcTEPbWG+4UPnxxCEhgF9XHmcQtZrW0AAdjnL9bp1He7cMvizPv758IaQVfKOIg
	 Q4lYCmbG1vZ2aJkMyoNER9zyxD/oV9BAPPKq1GSYVc16tdwO8lPu1b5LEp7SvZDCTD
	 a0kgjLmDKLGNBRcNEgiWTWv7CIsa/uwNXmdWlhFo=
Date: Fri, 06 Mar 2026 13:33:42 -0800
To: mm-commits@vger.kernel.org,liam.howlett@oracle.com,andrewjballance@gmail.com,aliceryhl@google.com,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch added to mm-new branch
Message-Id: <20260306213342.D7C02C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/maple_tree: fix swapped arguments in mas_safe_pivot() call
has been added to the -mm mm-new branch.  Its filename is
     lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Josh Law <objecting@objecting.org>
Subject: lib/maple_tree: fix swapped arguments in mas_safe_pivot() call
Date: Fri, 6 Mar 2026 20:08:20 +0000

The call to mas_safe_pivot() in mas_wr_extend_null() has the pivot index
and maple type arguments swapped.  The function signature expects (mas,
pivots, piv, type) but the call passes (mas, pivots, type, piv).

This causes the pivot index to be interpreted as a maple node type and
vice versa, leading to incorrect pivot lookups.  In practice, this means a
null-extending store into a maple tree node can read the wrong pivot
value, potentially corrupting the range tracked by the maple state.  For a
VMA maple tree, this could cause an incorrect vm_area_struct range to be
returned during operations like mmap or munmap, leading to silent memory
mapping corruption.

Every other mas_safe_pivot() call site in the file passes the arguments in
the correct (piv, type) order; this is the only one with them reversed.

Link: https://lkml.kernel.org/r/20260306200820.2819999-1-objecting@objecting.org
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Josh Law <objecting@objecting.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call
+++ a/lib/maple_tree.c
@@ -2932,7 +2932,7 @@ static inline void mas_extend_spanning_n
 	    (r_mas->last < r_mas->max) &&
 	    !mas_slot_locked(r_mas, r_wr_mas->slots, r_mas->offset + 1)) {
 		r_mas->last = mas_safe_pivot(r_mas, r_wr_mas->pivots,
-					     r_wr_mas->type, r_mas->offset + 1);
+					     r_mas->offset + 1, r_wr_mas->type);
 		r_mas->offset++;
 		r_wr_mas->r_max = r_mas->last;
 	}
_

Patches currently in -mm which might be from objecting@objecting.org are

lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
lib-glob-fix-grammar-and-replace-non-inclusive-terminology.patch
lib-glob-add-explicit-include-for-exporth.patch
lib-glob-replace-bitwise-or-with-logical-operation-on-boolean.patch
lib-glob-clean-up-bool-abuse-in-pointer-arithmetic.patch
lib-uuid-fix-typo-reversion-to-revision-in-comment.patch
lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure.patch
lib-inflate-fix-memory-leak-in-inflate_dynamic-on-inflate_codes-failure.patch
lib-inflate-fix-grammar-in-comment-variable-to-variables.patch
lib-inflate-fix-typo-this-results-to-the-results-in-comment.patch
lib-bug-fix-inconsistent-capitalization-in-bug-message.patch
lib-bug-remove-unnecessary-variable-initializations.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

