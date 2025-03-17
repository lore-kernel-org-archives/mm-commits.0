Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370D22153EB
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188247; cv=none; b=TM6HRmXrBWyo3nqPVRvFLkUrFgKyScLfOHZEza33wrcVO9liLrm6I8tYQcsKsuK9033But+Ib7TByVi97OZcQ5WS3hw+C9zX2yCVJG7FFdJgUPdK7shEvRwzjQzuvAjxNaNqhgNu08RIeqsuAqXoxFZU2ToSigOu36JbAUSoUuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188247; c=relaxed/simple;
	bh=N1MyLNj7VbCEzpGwAp968nC8CAbRW7VdweEYYVJgcFU=;
	h=Date:To:From:Subject:Message-Id; b=lihBLuqvExqmvfAAacf0j8T7Q6wY6q/L8K1UDqGsms6/ha5L8AhdQd7AaI0fvbdWfXxQg1WKD35pPhmtuPHc1TgEHeAOpOeXmU6NKB/pUSGYbFneR42c8ytjdmlKbnhHT+Kx/PGU3z8PRiIimr2eCvxBYvQYvL95umoMWbKnXC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ALMoewJa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ALMoewJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CE8C4CEEC;
	Mon, 17 Mar 2025 05:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188246;
	bh=N1MyLNj7VbCEzpGwAp968nC8CAbRW7VdweEYYVJgcFU=;
	h=Date:To:From:Subject:From;
	b=ALMoewJa0dt7/nbCzSHdsc57/9c6CPPWTefP6/TruYH3R1skh1pvp+uKECJZfRoYo
	 DIpZy9bQa/bsdtIDoeeLT9QZSC+Gnis47qoyhYxs4HZxIAj5g0mJ+fEkUJhz3/Be1A
	 tyBQlRDtdB1wl4S6C89lZFHFeNfpEitaV8xgqat4=
Date: Sun, 16 Mar 2025 22:10:46 -0700
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-rename-swap_swapcount-to-swap_entry_swapped.patch removed from -mm tree
Message-Id: <20250317051046.A0CE8C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: rename swap_swapcount() to swap_entry_swapped()
has been removed from the -mm tree.  Its filename was
     mm-swap-rename-swap_swapcount-to-swap_entry_swapped.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/swap: rename swap_swapcount() to swap_entry_swapped()
Date: Wed, 5 Feb 2025 17:27:19 +0800

The new function name can reflect the real behaviour of the function more
clearly and more accurately.  And the renaming avoids the confusion
between swap_swapcount() and swp_swapcount().

Link: https://lkml.kernel.org/r/20250205092721.9395-11-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 +++---
 mm/swap_state.c      |    2 +-
 mm/swapfile.c        |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/swap.h~mm-swap-rename-swap_swapcount-to-swap_entry_swapped
+++ a/include/linux/swap.h
@@ -499,7 +499,7 @@ int find_first_swap(dev_t *device);
 extern unsigned int count_swap_pages(int, int);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int __swap_count(swp_entry_t entry);
-extern int swap_swapcount(struct swap_info_struct *si, swp_entry_t entry);
+extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
 struct swap_info_struct *swp_swap_info(swp_entry_t entry);
 struct backing_dev_info;
@@ -582,9 +582,9 @@ static inline int __swap_count(swp_entry
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
@@ -1620,7 +1620,7 @@ int __swap_count(swp_entry_t entry)
  * This does not give an exact answer when swap count is continued,
  * but does include the high COUNT_CONTINUED flag to allow for that.
  */
-int swap_swapcount(struct swap_info_struct *si, swp_entry_t entry)
+bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry)
 {
 	pgoff_t offset = swp_offset(entry);
 	struct swap_cluster_info *ci;
@@ -1629,7 +1629,7 @@ int swap_swapcount(struct swap_info_stru
 	ci = lock_cluster(si, offset);
 	count = swap_count(si->swap_map[offset]);
 	unlock_cluster(ci);
-	return count;
+	return !!count;
 }
 
 /*
@@ -1715,7 +1715,7 @@ static bool folio_swapped(struct folio *
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


