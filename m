Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8F1217F33
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188464; cv=none; b=NKK/GHDVarENWNcHbSA0Z5HmZYjV+1oZjteILDELCVkzgiQ/tSccUaS36SYlta4k/dXY5FQe7nDRVrplIMJxck5SmKI5w7H/UobedM41JseqRWWzzv/r3AJvVcUKtY1MxPERtle7OD1vO/LsxFolhFc8Nu8pzbSnh6Ve4WQ2j6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188464; c=relaxed/simple;
	bh=xAEOo6s8kNo4wYKaoL6uV8+PyVoKei/OC6uxwLyMcyQ=;
	h=Date:To:From:Subject:Message-Id; b=nSQdtNo6kQu53xpzCP4rfpMyRJQgEQxiNhyk0ao30hmMoYNs1Lm08flahPwsLupXx511rz1qIDdoCA02z/PsFTs7x07H3TI/QXru6bCreAxKmNHlDG37REN40oV5KZU4AEu9ayzlWpD5MK8WTl9SNX7UqPFbnbKEoCRloWuYytU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N5WUqZuF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N5WUqZuF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A439DC4CEEC;
	Mon, 17 Mar 2025 05:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188464;
	bh=xAEOo6s8kNo4wYKaoL6uV8+PyVoKei/OC6uxwLyMcyQ=;
	h=Date:To:From:Subject:From;
	b=N5WUqZuFoLH503HYY139/vhyv3HatHoKfxMp6JdGF0kx57mqIFl0bUof7iySzYd9+
	 Q7VWXnvYNgzmL0WZBMKd+3AhX0g4flucCQYSjKoEjHYqd+AcgHDKW5rL0ZqZ9IUpzo
	 J1Om0p5UldW7HBkLhhAgRkVt9puJrdFSohZAd8xM=
Date: Sun, 16 Mar 2025 22:14:24 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,v-songbaohua@oppo.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-drop-the-flag-ttrs_direct.patch removed from -mm tree
Message-Id: <20250317051424.A439DC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: drop the flag TTRS_DIRECT
has been removed from the -mm tree.  Its filename was
     mm-swap-drop-the-flag-ttrs_direct.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: drop the flag TTRS_DIRECT
Date: Fri, 14 Mar 2025 00:59:30 +0800

This flag exists temporarily to allow the allocator to bypass the slot
cache during freeing, so reclaiming one slot will free the slot
immediately.

But now we have already removed slot cache usage on freeing, so this flag
has no effect now.

Link: https://lkml.kernel.org/r/20250313165935.63303-3-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

--- a/mm/swapfile.c~mm-swap-drop-the-flag-ttrs_direct
+++ a/mm/swapfile.c
@@ -158,8 +158,6 @@ static long swap_usage_in_pages(struct s
 #define TTRS_UNMAPPED		0x2
 /* Reclaim the swap entry if swap is getting full */
 #define TTRS_FULL		0x4
-/* Reclaim directly, bypass the slot cache and don't touch device lock */
-#define TTRS_DIRECT		0x8
 
 static bool swap_only_has_cache(struct swap_info_struct *si,
 			      unsigned long offset, int nr_pages)
@@ -257,23 +255,8 @@ again:
 	if (!need_reclaim)
 		goto out_unlock;
 
-	if (!(flags & TTRS_DIRECT)) {
-		/* Free through slot cache */
-		delete_from_swap_cache(folio);
-		folio_set_dirty(folio);
-		ret = nr_pages;
-		goto out_unlock;
-	}
-
-	xa_lock_irq(&address_space->i_pages);
-	__delete_from_swap_cache(folio, entry, NULL);
-	xa_unlock_irq(&address_space->i_pages);
-	folio_ref_sub(folio, nr_pages);
+	delete_from_swap_cache(folio);
 	folio_set_dirty(folio);
-
-	ci = lock_cluster(si, offset);
-	swap_entry_range_free(si, ci, entry, nr_pages);
-	unlock_cluster(ci);
 	ret = nr_pages;
 out_unlock:
 	folio_unlock(folio);
@@ -697,7 +680,7 @@ static bool cluster_reclaim_range(struct
 			offset++;
 			break;
 		case SWAP_HAS_CACHE:
-			nr_reclaim = __try_to_reclaim_swap(si, offset, TTRS_ANYWAY | TTRS_DIRECT);
+			nr_reclaim = __try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
 			if (nr_reclaim > 0)
 				offset += nr_reclaim;
 			else
@@ -849,7 +832,7 @@ static void swap_reclaim_full_clusters(s
 			if (READ_ONCE(map[offset]) == SWAP_HAS_CACHE) {
 				spin_unlock(&ci->lock);
 				nr_reclaim = __try_to_reclaim_swap(si, offset,
-								   TTRS_ANYWAY | TTRS_DIRECT);
+								   TTRS_ANYWAY);
 				spin_lock(&ci->lock);
 				if (nr_reclaim) {
 					offset += abs(nr_reclaim);
_

Patches currently in -mm which might be from kasong@tencent.com are


