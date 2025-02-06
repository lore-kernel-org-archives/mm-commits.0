Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251B22253E9
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 07:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738828655; cv=none; b=DGYGY9L6jjrQaZy7DYzn01LlkfbTIuot0FURfwg5PEnz7pRgRRmJB8PN5eD2Rax6OoX3w2eedy4kBPGm4ykaLN5qu9Ub3Xhgud/mgUjBd24vwPThcWYGJF9KhD3v4YCW4RVp+Evxj/WmIkxgFm5wD5YaxPnffBKvwke4IrGtnpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738828655; c=relaxed/simple;
	bh=4e6M2H3a0mG7YmUHsd/yRZtezwN7tZJoZjGZB4vWgVc=;
	h=Date:To:From:Subject:Message-Id; b=CFrK2S86bpZX4Z2a7Y874Fnf+KoZ1L7kQzY5dNmoQmWyX0Lyvlr15P9Kc6a6fpbBf0BcvEdrNM+tWRw9ecaduTqghxbv+gDWoVwvgUrJEvD7GxWWykMPCfNG/Yd4aFOynI9/B6wHG1IrBcE52iO9C6g0vyL12TlgE7NJ9isc3hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QBNNHajB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QBNNHajB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D8CC4CEDD;
	Thu,  6 Feb 2025 07:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738828654;
	bh=4e6M2H3a0mG7YmUHsd/yRZtezwN7tZJoZjGZB4vWgVc=;
	h=Date:To:From:Subject:From;
	b=QBNNHajBA2XeAFCfHJrOl4MITHvtEeNBWJYSq+pg020GEnZK4pR3TrkiET3ih7mUW
	 qYtRgHGKehrBvMTCTlUoLsGOhwDpXjesrdAxrR3TgEDig4xw1Ymhd+yhSiVtub9Mug
	 D5d0JYC26NyDeqXL+axLCbx7c6ZvTSXHhn50MM7w=
Date: Wed, 05 Feb 2025 23:57:34 -0800
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-rename-swap_is_has_cache-to-swap_only_has_cache.patch added to mm-unstable branch
Message-Id: <20250206075734.82D8CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: rename swap_is_has_cache() to swap_only_has_cache()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-rename-swap_is_has_cache-to-swap_only_has_cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-rename-swap_is_has_cache-to-swap_only_has_cache.patch

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
Subject: mm/swap: rename swap_is_has_cache() to swap_only_has_cache()
Date: Wed, 5 Feb 2025 17:27:14 +0800

There are two predicates in the name of swap_is_has_cache() which is
confusing.  Renaming it to remove the confusion and can better reflect its
functionality.

Link: https://lkml.kernel.org/r/20250205092721.9395-6-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chis Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swap-rename-swap_is_has_cache-to-swap_only_has_cache
+++ a/mm/swapfile.c
@@ -161,7 +161,7 @@ static long swap_usage_in_pages(struct s
 /* Reclaim directly, bypass the slot cache and don't touch device lock */
 #define TTRS_DIRECT		0x8
 
-static bool swap_is_has_cache(struct swap_info_struct *si,
+static bool swap_only_has_cache(struct swap_info_struct *si,
 			      unsigned long offset, int nr_pages)
 {
 	unsigned char *map = si->swap_map + offset;
@@ -243,7 +243,7 @@ static int __try_to_reclaim_swap(struct
 	 * reference or pending writeback, and can't be allocated to others.
 	 */
 	ci = lock_cluster(si, offset);
-	need_reclaim = swap_is_has_cache(si, offset, nr_pages);
+	need_reclaim = swap_only_has_cache(si, offset, nr_pages);
 	unlock_cluster(ci);
 	if (!need_reclaim)
 		goto out_unlock;
@@ -1572,7 +1572,7 @@ void put_swap_folio(struct folio *folio,
 		return;
 
 	ci = lock_cluster(si, offset);
-	if (swap_is_has_cache(si, offset, size))
+	if (swap_only_has_cache(si, offset, size))
 		swap_entry_range_free(si, ci, entry, size);
 	else {
 		for (int i = 0; i < size; i++, entry.val++) {
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

