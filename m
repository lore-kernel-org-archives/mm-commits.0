Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D7033EB17;
	Tue, 25 Aug 2026 01:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622806; cv=none; b=Jat7p2ut1UZ7unmHMhSHDd41UxGbyXb5s/EQnxpYXrY5LLGS/7+cWYqJDt82o4i/lKvTbMg+3y4AphsED5BhIlswj8EoDrY66mWBdo3rVFre1Scw5rfjIEAM10AGkSrgKI8NEuhNJN1S5BkP+1nCwjCQbW7sUSVGbyay9Cvp3xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622806; c=relaxed/simple;
	bh=jb06TWzVQc6iMew85SkUgZOO2b3Sul/rEHCGmBLxcgk=;
	h=Date:To:From:Subject:Message-Id; b=gcEzpvX8yC7+c2GE66BEI7HBx7NVtCCoYk94d4Kpx/TGIdldhd3OOVOumXERXx8tePmtTrOFobZdQ6Y6ZSm5Ci/J5VQmFHlj7pGjzeFNa8/aGjzt4XwGe+ZtMj0hPB/Pc2XpnyVq2gzfxsgTmtDH5wd+9590ZJ7rGDTKtbM864M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NyeJHEan; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NyeJHEan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214AA1F00A3A;
	Tue, 25 Aug 2026 01:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622805;
	bh=RHOrOvHy1xI4V6LzggKTKQrx409yLUb1/OijS8BEJRs=;
	h=Date:To:From:Subject;
	b=NyeJHEanmKdrwu1RKGYj7OL/LgDWnjgMy9u7gbkR684gat+EGLGVxK0nCgN4cCV04
	 49VKAQi6GE4Jk6sWMtZRtEssy7RqIfZqScbtI0ltkmHWsfle3oBh+Zkt+a4IYzFXwQ
	 nF7VmP1bDH65+JN9XvdzAZNnZ3IYHfgv1ZPCKlzg=
Date: Mon, 24 Aug 2026 18:53:24 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,riel@surriel.com,osalvador@suse.de,muchun.song@linux.dev,leitao@debian.org,david@kernel.org,guillaume@morinfr.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-only-adjust-reservation-during-unmapping-if-mapcount-is-0.patch removed from -mm tree
Message-Id: <20260825015325.214AA1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: only adjust reservation during unmapping if mapcount is 0
has been removed from the -mm tree.  Its filename was
     hugetlb-only-adjust-reservation-during-unmapping-if-mapcount-is-0.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Guillaume Morin <guillaume@morinfr.org>
Subject: hugetlb: only adjust reservation during unmapping if mapcount is 0
Date: Tue, 28 Jul 2026 21:29:03 +0200

Since df7a6d1f6405, __unmap_hugepage_range can adjust reservations.  In
the case of folio mapped in both a parent and a child, if the parent
unmaps the range first, the reservation adjustment will result in an
underflow of the reserved count.  Once the child unmaps the range, the
count is restored.  Change __unmap_hugepage_range() to check the mapcount
before adjusting the reservation.

Link: https://lore.kernel.org/all/alEJkwn5VlTTH_ZX@bender.morinfr.org/
Link: https://lore.kernel.org/amkC_1Ya6OiUoiLZ@bender.morinfr.org
Fixes: df7a6d1f6405 ("mm/hugetlb: restore the reservation if needed")
Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~hugetlb-only-adjust-reservation-during-unmapping-if-mapcount-is-0
+++ a/mm/hugetlb.c
@@ -5218,6 +5218,7 @@ void __unmap_hugepage_range(struct mmu_g
 	bool adjust_reservation;
 	unsigned long last_addr_mask;
 
+	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
 	WARN_ON(!is_vm_hugetlb_page(vma));
 	BUG_ON(start & ~huge_page_mask(h));
 	BUG_ON(end & ~huge_page_mask(h));
@@ -5309,7 +5310,10 @@ void __unmap_hugepage_range(struct mmu_g
 
 		/*
 		 * Restore the reservation for anonymous page, otherwise the
-		 * backing page could be stolen by someone.
+		 * backing page could be stolen by someone. Restore only on the
+		 * last unmap, otherwise the owner could empty its resv map
+		 * while the folio is still mapped by a child. Note that holding
+		 * i_mmap_lock_write is needed to check the number of mappings.
 		 * If there we are freeing a surplus, do not set the restore
 		 * reservation bit.
 		 */
@@ -5317,7 +5321,7 @@ void __unmap_hugepage_range(struct mmu_g
 
 		spin_lock_irq(&hugetlb_lock);
 		if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
-		    folio_test_anon(folio)) {
+		    !folio_mapped(folio) && folio_test_anon(folio)) {
 			folio_set_hugetlb_restore_reserve(folio);
 			/* Reservation to be adjusted after the spin lock */
 			adjust_reservation = true;
_

Patches currently in -mm which might be from guillaume@morinfr.org are


