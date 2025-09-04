Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A735BA34;
	Thu,  4 Sep 2025 00:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756944695; cv=none; b=HpiRkHYronOcICLqlbGJ0s+NWjD0OL/oP2BxdMo22hSJhxneIpOQh+S9iuYdON7YjFB64xODfbgOo1qLd4+VhoP6Tsn5dh421LkAbdd/2kokvFUaaRBVEXPbpNZKhcXwqvtdxvHa883kFUlUGYcXkjemitGKM+MxBT1uv5ymNC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756944695; c=relaxed/simple;
	bh=3RShdUqPw5/fhIHBavHlu0UEbuumzUtOtFQwqUzLMVs=;
	h=Date:To:From:Subject:Message-Id; b=E7X6c8RzsTkkIrsQoXxs+lLZLP461fmBNKrnaMuL/1pF6Ht3nPMInscAAMb7s1lcBnlFZEKTXSubfZMwTCC3jzW7oNp/z4TBCZn8ltsoq2yRZXEfjcEV0/Pty2oBzJtn3Dw8Bdp6PcBkcKo57ojFmDkOwGbMev+tuPjwZn54C4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TEj3wZaG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TEj3wZaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE86C4CEE7;
	Thu,  4 Sep 2025 00:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756944695;
	bh=3RShdUqPw5/fhIHBavHlu0UEbuumzUtOtFQwqUzLMVs=;
	h=Date:To:From:Subject:From;
	b=TEj3wZaG6W/xltAn5ghybdAiYtZ14RoeBJW8PNZSlg/WyiRa2s09PRv45XVdGdOgZ
	 nDiFg20UE19qH4D6G+AAdeuEU7oH/Z0vceTX79yHOVgEL7frpxtB9gQYG2/GRCDs4Y
	 ZOYTgmda1VcG21lP4baLgWbSI+B+JgADSiLb2E/M=
Date: Wed, 03 Sep 2025 17:11:34 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,leitao@debian.org,david@redhat.com,aha310510@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-add-missing-hugetlb_lock-in-__unmap_hugepage_range.patch removed from -mm tree
Message-Id: <20250904001135.6DE86C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: add missing hugetlb_lock in __unmap_hugepage_range()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-missing-hugetlb_lock-in-__unmap_hugepage_range.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeongjun Park <aha310510@gmail.com>
Subject: mm/hugetlb: add missing hugetlb_lock in __unmap_hugepage_range()
Date: Sun, 24 Aug 2025 03:21:15 +0900

When restoring a reservation for an anonymous page, we need to check to
freeing a surplus.  However, __unmap_hugepage_range() causes data race
because it reads h->surplus_huge_pages without the protection of
hugetlb_lock.

And adjust_reservation is a boolean variable that indicates whether
reservations for anonymous pages in each folio should be restored. 
Therefore, it should be initialized to false for each round of the loop. 
However, this variable is not initialized to false except when defining
the current adjust_reservation variable.

This means that once adjust_reservation is set to true even once within
the loop, reservations for anonymous pages will be restored
unconditionally in all subsequent rounds, regardless of the folio's state.

To fix this, we need to add the missing hugetlb_lock, unlock the
page_table_lock earlier so that we don't lock the hugetlb_lock inside the
page_table_lock lock, and initialize adjust_reservation to false on each
round within the loop.

Link: https://lkml.kernel.org/r/20250823182115.1193563-1-aha310510@gmail.com
Fixes: df7a6d1f6405 ("mm/hugetlb: restore the reservation if needed")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Reported-by: syzbot+417aeb05fd190f3a6da9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=417aeb05fd190f3a6da9
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-add-missing-hugetlb_lock-in-__unmap_hugepage_range
+++ a/mm/hugetlb.c
@@ -5851,7 +5851,7 @@ void __unmap_hugepage_range(struct mmu_g
 	spinlock_t *ptl;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
-	bool adjust_reservation = false;
+	bool adjust_reservation;
 	unsigned long last_addr_mask;
 	bool force_flush = false;
 
@@ -5944,6 +5944,7 @@ void __unmap_hugepage_range(struct mmu_g
 					sz);
 		hugetlb_count_sub(pages_per_huge_page(h), mm);
 		hugetlb_remove_rmap(folio);
+		spin_unlock(ptl);
 
 		/*
 		 * Restore the reservation for anonymous page, otherwise the
@@ -5951,14 +5952,16 @@ void __unmap_hugepage_range(struct mmu_g
 		 * If there we are freeing a surplus, do not set the restore
 		 * reservation bit.
 		 */
+		adjust_reservation = false;
+
+		spin_lock_irq(&hugetlb_lock);
 		if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
 		    folio_test_anon(folio)) {
 			folio_set_hugetlb_restore_reserve(folio);
 			/* Reservation to be adjusted after the spin lock */
 			adjust_reservation = true;
 		}
-
-		spin_unlock(ptl);
+		spin_unlock_irq(&hugetlb_lock);
 
 		/*
 		 * Adjust the reservation for the region that will have the
_

Patches currently in -mm which might be from aha310510@gmail.com are


