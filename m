Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E092253F8
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 07:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738828665; cv=none; b=p7EAtLMATRe4VOua/9o+V1ws3xcN/rU38tDl6WpOVCmAIHBbu/x5f2d8lC7HRuChubBj7myL/pNtgAXZEJRyeroQBY0sVTEUPw37iZUpz2PpWczQ51Y/QSGkvFoMC8EW9FvBlqUxfSZdd4qXFps+Owj2YH4Ee1MQSWSR6H8tFYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738828665; c=relaxed/simple;
	bh=no5ZhfiABRWchS6ZIeIWt98iyhzbobSINx6pzu34/IQ=;
	h=Date:To:From:Subject:Message-Id; b=oYOnrqOIsOWY0c8+xpcmo+6S7wguFjsTv/LpeuilS9IzXTvggORLiiB9h8B2qzDnCzvMWRVp5h+OiU3AVauu6ifOHfJCYqpJXIA0FGGh28B2KA24ofFzj5M1ySwwZ8gQL+oRUfXxCS2/HnuAo0+bWxVLl3AmC67y4XEfgkL9liQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E2Xa9/nc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E2Xa9/nc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF59FC4CEDD;
	Thu,  6 Feb 2025 07:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738828663;
	bh=no5ZhfiABRWchS6ZIeIWt98iyhzbobSINx6pzu34/IQ=;
	h=Date:To:From:Subject:From;
	b=E2Xa9/nc1uZeuRnE/PKzotZFXkpYBZBCkaWaJHUvTbj/cO7MkUKG/rhu4u8MLfrFn
	 NkQpb88Ve6Q82FOY/2ssj5zIfCQIQQpu9o1w0UY1QfQjqKyyrzwgeudW/RkgW5ixK2
	 uGfLjE6w6nzKpoAw8fbyQwZPlh8fpmk7MxvR4RKk=
Date: Wed, 05 Feb 2025 23:57:43 -0800
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-rename-swap_swapcount-to-swap_entry_swapped.patch added to mm-unstable branch
Message-Id: <20250206075743.BF59FC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: rename swap_swapcount() to swap_entry_swapped()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-rename-swap_swapcount-to-swap_entry_swapped.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-rename-swap_swapcount-to-swap_entry_swapped.patch

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
Subject: mm/swap: rename swap_swapcount() to swap_entry_swapped()
Date: Wed, 5 Feb 2025 17:27:19 +0800

The new function name can reflect the real behaviour of the function more
clearly and more accurately.  And the renaming avoids the confusion
between swap_swapcount() and swp_swapcount().

Link: https://lkml.kernel.org/r/20250205092721.9395-11-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chis Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 +++---
 mm/swap_state.c      |    2 +-
 mm/swapfile.c        |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/swap.h~mm-swap-rename-swap_swapcount-to-swap_entry_swapped
+++ a/include/linux/swap.h
@@ -500,7 +500,7 @@ int find_first_swap(dev_t *device);
 extern unsigned int count_swap_pages(int, int);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int __swap_count(swp_entry_t entry);
-extern int swap_swapcount(struct swap_info_struct *si, swp_entry_t entry);
+extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
 struct swap_info_struct *swp_swap_info(swp_entry_t entry);
 struct backing_dev_info;
@@ -583,9 +583,9 @@ static inline int __swap_count(swp_entry
 	return 0;
 }
 
-static inline int swap_swapcount(struct swap_info_struct *si, swp_entry_t entry)
+static inline bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry)
 {
-	return 0;
+	return false;
 }
 
 static inline int swp_swapcount(swp_entry_t entry)
--- a/mm/swapfile.c~mm-swap-rename-swap_swapcount-to-swap_entry_swapped
+++ a/mm/swapfile.c
@@ -1615,7 +1615,7 @@ int __swap_count(swp_entry_t entry)
  * This does not give an exact answer when swap count is continued,
  * but does include the high COUNT_CONTINUED flag to allow for that.
  */
-int swap_swapcount(struct swap_info_struct *si, swp_entry_t entry)
+bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry)
 {
 	pgoff_t offset = swp_offset(entry);
 	struct swap_cluster_info *ci;
@@ -1624,7 +1624,7 @@ int swap_swapcount(struct swap_info_stru
 	ci = lock_cluster(si, offset);
 	count = swap_count(si->swap_map[offset]);
 	unlock_cluster(ci);
-	return count;
+	return !!count;
 }
 
 /*
@@ -1710,7 +1710,7 @@ static bool folio_swapped(struct folio *
 		return false;
 
 	if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!folio_test_large(folio)))
-		return swap_swapcount(si, entry) != 0;
+		return swap_entry_swapped(si, entry);
 
 	return swap_page_trans_huge_swapped(si, entry, folio_order(folio));
 }
--- a/mm/swap_state.c~mm-swap-rename-swap_swapcount-to-swap_entry_swapped
+++ a/mm/swap_state.c
@@ -457,7 +457,7 @@ struct folio *__read_swap_cache_async(sw
 		 * as SWAP_HAS_CACHE.  That's done in later part of code or
 		 * else swap_off will be aborted if we return NULL.
 		 */
-		if (!swap_swapcount(si, entry) && swap_slot_cache_enabled)
+		if (!swap_entry_swapped(si, entry) && swap_slot_cache_enabled)
 			goto put_and_return;
 
 		/*
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

