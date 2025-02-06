Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6199B2248B5
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 07:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738828647; cv=none; b=qpqYu4GFxpiSb91ycsh6iI7dX1BuETbELNxd64AoUgA+dDkM++hOqzMRS+QBvnUd3K6YhCHzOBMJ4Mz4fdqChwEwSPEVGSvlKWVVy+7h7oY9Vo7gPC9Ml5ZSUf2RTB2DoUcw6LWM853OrZzlqJhzpzGj3TeKPJT2RBH2rIIKTJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738828647; c=relaxed/simple;
	bh=nS7K+7wHN+/XGUMJxQAQ0ChZG25fFVY8Xh1MbYgP6mE=;
	h=Date:To:From:Subject:Message-Id; b=A2evOLjNy2zEy0ZaDTzmMeRpPZqnDtEbUZkf1rx06I8wLS+Eoc6J70T/yZ6+pTJHsootVIjJP8VFfZvxY47eu0GGe2ElayZuDaUbJnv8Hj/4elHC4KfMdjXRggPOAHQgHFEapYZeFOlaHux9AysRLVoNE0rwCE3Kg3yElYiAOAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XCtgpV15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XCtgpV15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEEEFC4CEE0;
	Thu,  6 Feb 2025 07:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738828646;
	bh=nS7K+7wHN+/XGUMJxQAQ0ChZG25fFVY8Xh1MbYgP6mE=;
	h=Date:To:From:Subject:From;
	b=XCtgpV15Mrm6Aayw2JiUEDh2zQNvqI8bZKBCk8d2XMUi/CjmvkfUi5OVsFTBZA5Mm
	 kPR8O3ETgJM+khdZ0pRv8qIno5VRWc7z0AoEbAGjDcFDuqWkbSCWOkWwMtf8WtmCEv
	 R+MgSnfMCxvfmZRmBR7VYJR90LwpkGYN2rier/3w=
Date: Wed, 05 Feb 2025 23:57:26 -0800
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap_statec-fix-the-obsolete-code-comment.patch added to mm-unstable branch
Message-Id: <20250206075726.BEEEFC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap_state.c: fix the obsolete code comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap_statec-fix-the-obsolete-code-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap_statec-fix-the-obsolete-code-comment.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/swap_state.c: fix the obsolete code comment
Date: Wed, 5 Feb 2025 17:27:10 +0800

Patch series "Tiny cleanup and improvements about SWAP code".

These are all made during review and from reading the patchset "[PATCH v3
00/13] mm, swap: rework of swap allocator locks" from Kairui.


This patch (of 12):

Since commit 85a1333417a7 ("mm/swap: use dedicated entry for swap in
folio"), there's a dedicated field in folio for swap entry.  Let's update
the code comment above add_to_swap_cache() accordingly.

Link: https://lkml.kernel.org/r/20250205092721.9395-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20250205092721.9395-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Baoquan he <bhe@redhat.com>
Cc: Chis Li <chrisl@kernel.org> (Google)
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap_state.c~mm-swap_statec-fix-the-obsolete-code-comment
+++ a/mm/swap_state.c
@@ -85,7 +85,7 @@ void *get_shadow_from_swap_cache(swp_ent
 
 /*
  * add_to_swap_cache resembles filemap_add_folio on swapper_space,
- * but sets SwapCache flag and private instead of mapping and index.
+ * but sets SwapCache flag and 'swap' instead of mapping and index.
  */
 int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
 			gfp_t gfp, void **shadowp)
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-swap_statec-fix-the-obsolete-code-comment.patch
mm-swap_statec-optimize-the-code-in-clear_shadow_from_swap_cache.patch
mm-swap-remove-swap_flag_prio_shift.patch
mm-swap-skip-scanning-cluster-range-if-its-empty-cluster.patch
mm-swap-rename-swap_is_has_cache-to-swap_only_has_cache.patch
mm-swapfilec-update-the-code-comment-above-swap_count_continued.patch
mm-swapfilec-optimize-code-in-setup_clusters.patch
mm-swap_statec-remove-the-meaningless-code-comment.patch
mm-swapfilec-remove-the-unneeded-checking.patch
mm-swap-rename-swap_swapcount-to-swap_entry_swapped.patch
mm-swapfilec-remove-the-incorrect-code-comment.patch
mm-swapfilec-open-code-cluster_alloc_swap.patch

