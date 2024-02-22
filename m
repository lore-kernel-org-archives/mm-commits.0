Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C277A2FB6
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560095; cv=none; b=dFEGJO8Wn5woj93r8EAQ/BBSWx3zvgtXDJy41WdUlrd2A2kMiwYQxdS3gI0B7OGWlkV50Q9+nToSMvz0Z+Rvkc+P+4565dicDmMzcKALwC+97oxymeTZuK6MmQvw4eU402od2zl8UkLvxSMo3CrhVgDBLiOvox4pZ+WO8UpowOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560095; c=relaxed/simple;
	bh=qJmbeFaZJ3As1ax8bWqFW/yCl4G53lLpZZpSHtJULZ4=;
	h=Date:To:From:Subject:Message-Id; b=kG2ibgm7Q1GMuATQ0Hos7coukLe+m9HpCFPrBZQadSMMsN82MQC2lhZJRSvDdKbEH13HzQr9FNo5aetA/Sb0upaCBG5EjE5zPQM06DBjy6P9ELsgrylMmJlMZ9CDQ4c8wnD3f5ho2w0lTRBlK/HEW9Rqt3erhhS8bX9g/+WRHiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=da0wPTjw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="da0wPTjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988A1C433C7;
	Thu, 22 Feb 2024 00:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560095;
	bh=qJmbeFaZJ3As1ax8bWqFW/yCl4G53lLpZZpSHtJULZ4=;
	h=Date:To:From:Subject:From;
	b=da0wPTjwgu20C7j86p2Aw6q9gG23qHKLI1PJ1TQdRMpQ2XoLrCu7ZanBfWYrlrafX
	 LB8mlyM14UYz608F1ewioydZjLpdiEnQTYA3xR3d2oJxvcXsCEvIUBZqwBwPN5L/Kx
	 xCqGccAHlDyL6XZpFdwK8O0URM/+8HTCYJZIR/+A=
Date: Wed, 21 Feb 2024 16:01:35 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,ying.huang@intel.com,nphamcs@gmail.com,hannes@cmpxchg.org,chrisl@kernel.org,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-enforce-updating-inuse_pages-at-the-end-of-swap_range_free.patch removed from -mm tree
Message-Id: <20240222000135.988A1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: enforce updating inuse_pages at the end of swap_range_free()
has been removed from the -mm tree.  Its filename was
     mm-swap-enforce-updating-inuse_pages-at-the-end-of-swap_range_free.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: swap: enforce updating inuse_pages at the end of swap_range_free()
Date: Wed, 24 Jan 2024 04:51:11 +0000

Patch series "mm: zswap: simplify zswap_swapoff()", v2.

These patches aim to simplify zswap_swapoff() by removing the unnecessary
trees cleanup code.  Patch 1 makes sure that the order of operations
during swapoff is enforced correctly, making sure the simplification in
patch 2 is correct in a future-proof manner.


This patch (of 2):

In swap_range_free(), we update inuse_pages then do some cleanups (arch
invalidation, zswap invalidation, swap cache cleanups, etc).  During
swapoff, try_to_unuse() checks that inuse_pages is 0 to make sure all swap
entries are freed.  Make sure we only update inuse_pages after we are done
with the cleanups in swap_range_free(), and use the proper memory barriers
to enforce it.  This makes sure that code following try_to_unuse() can
safely assume that swap_range_free() ran for all entries in thr swapfile
(e.g.  swap cache cleanup, zswap_swapoff()).

In practice, this currently isn't a problem because swap_range_free() is
called with the swap info lock held, and the swapoff code happens to spin
for that after try_to_unuse().  However, this seems fragile and
unintentional, so make it more relable and future-proof.  This also
facilitates a following simplification of zswap_swapoff().

Link: https://lkml.kernel.org/r/20240124045113.415378-1-yosryahmed@google.com
Link: https://lkml.kernel.org/r/20240124045113.415378-2-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swap-enforce-updating-inuse_pages-at-the-end-of-swap_range_free
+++ a/mm/swapfile.c
@@ -737,8 +737,6 @@ static void swap_range_free(struct swap_
 		if (was_full && (si->flags & SWP_WRITEOK))
 			add_to_avail_list(si);
 	}
-	atomic_long_add(nr_entries, &nr_swap_pages);
-	WRITE_ONCE(si->inuse_pages, si->inuse_pages - nr_entries);
 	if (si->flags & SWP_BLKDEV)
 		swap_slot_free_notify =
 			si->bdev->bd_disk->fops->swap_slot_free_notify;
@@ -752,6 +750,14 @@ static void swap_range_free(struct swap_
 		offset++;
 	}
 	clear_shadow_from_swap_cache(si->type, begin, end);
+
+	/*
+	 * Make sure that try_to_unuse() observes si->inuse_pages reaching 0
+	 * only after the above cleanups are done.
+	 */
+	smp_wmb();
+	atomic_long_add(nr_entries, &nr_swap_pages);
+	WRITE_ONCE(si->inuse_pages, si->inuse_pages - nr_entries);
 }
 
 static void set_cluster_next(struct swap_info_struct *si, unsigned long next)
@@ -2049,7 +2055,7 @@ static int try_to_unuse(unsigned int typ
 	unsigned int i;
 
 	if (!READ_ONCE(si->inuse_pages))
-		return 0;
+		goto success;
 
 retry:
 	retval = shmem_unuse(type);
@@ -2130,6 +2136,12 @@ retry:
 		return -EINTR;
 	}
 
+success:
+	/*
+	 * Make sure that further cleanups after try_to_unuse() returns happen
+	 * after swap_range_free() reduces si->inuse_pages to 0.
+	 */
+	smp_mb();
 	return 0;
 }
 
_

Patches currently in -mm which might be from yosryahmed@google.com are


