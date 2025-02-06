Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC902253F8
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 07:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738828660; cv=none; b=sSaImWZ8qNZAQdSlEfnKR6Uxkefj/4JdfGZWhMZkj9GxIVp0US1YHJWL1PKUlCs7LkjqC/FaLJhBKY8gRXkt7tV111+owH1+nGdB3QdMoSdj4JCIi+3y2nh8xLbR7Pil+hSX1y+NS67kNLC7qJkeACcBlWaxW/afo7gTCwQ8Tg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738828660; c=relaxed/simple;
	bh=SFrctGadRCX9UBT/LbTLGmE4MgzwHpAZCztQgmjot7g=;
	h=Date:To:From:Subject:Message-Id; b=LYchP5zuPQe9NdC3qzwg7rpxVa453yPYWp4xeQpuYo9SF4SaxE41WsTw9ZJbYoTJcnTpDmueJFfSl004UhqYruzCsB/Bcl9q7RbVzJ8tq2iTmEMpHzBNrMHab5CLOV96AzObqfz21ixANj7LcDvVp97a02smvXobYtst0La/eXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fFzikEGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fFzikEGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB96C4CEDD;
	Thu,  6 Feb 2025 07:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738828660;
	bh=SFrctGadRCX9UBT/LbTLGmE4MgzwHpAZCztQgmjot7g=;
	h=Date:To:From:Subject:From;
	b=fFzikEGVH/uOmG/sHzoaIhUdimAdUyPaggLXTAzQHnWae7WF8BYsz1nykfqwfbY27
	 Cigw7C0EnSh4JaX1W7reGWqNWpjkmGY5cnxf8WA45WG+t8U3jjtHoEl9CbokEpqhj7
	 BFtNn8tyOzAcb2ZhM2L7fUk0esLiyBGb3ESElLGE=
Date: Wed, 05 Feb 2025 23:57:39 -0800
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap_statec-remove-the-meaningless-code-comment.patch added to mm-unstable branch
Message-Id: <20250206075740.2BB96C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap_state.c: remove the meaningless code comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap_statec-remove-the-meaningless-code-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap_statec-remove-the-meaningless-code-comment.patch

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
Subject: mm/swap_state.c: remove the meaningless code comment
Date: Wed, 5 Feb 2025 17:27:17 +0800

Since commit 8d93b41c09d1 ("mm: Convert add_to_swap_cache to XArray"),
there's no returned _EEXIT, so the code comment doesn't make sense any
more.

Link: https://lkml.kernel.org/r/20250205092721.9395-9-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chis Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/swap_state.c~mm-swap_statec-remove-the-meaningless-code-comment
+++ a/mm/swap_state.c
@@ -203,10 +203,6 @@ bool add_to_swap(struct folio *folio)
 	err = add_to_swap_cache(folio, entry,
 			__GFP_HIGH|__GFP_NOMEMALLOC|__GFP_NOWARN, NULL);
 	if (err)
-		/*
-		 * add_to_swap_cache() doesn't return -EEXIST, so we can safely
-		 * clear SWAP_HAS_CACHE flag.
-		 */
 		goto fail;
 	/*
 	 * Normally the folio will be dirtied in unmap because its
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

