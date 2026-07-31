Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C499F442106;
	Fri, 31 Jul 2026 17:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785520397; cv=none; b=JqZs1iCDypuYPcndWlD/NzSKIza41VJY/fegwUqwx+U/AvJ0JEPAlzQJE/MYxdulN1WwHlftGIlM+cRhXTAJNXk0koWNnPUCz6dxYaSEGOuyDPMjDmp11TClU7od+ls0COn1+gLX4QgAKdduPRXYi/5i2I3M2wLRM+F0voD+TlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785520397; c=relaxed/simple;
	bh=FkA5oFEShK23UmRSU9gc0ugvAETJkWARmPyTi18l0lY=;
	h=Date:To:From:Subject:Message-Id; b=gmtEp6Wvsizc/hc3ek7mdVB+bqRFlWx1hHlkUAx8dyqTCz0CX3eVUvyoAYhPaHzzn7++KmQCfnpd6JSgi/jTn9vMtFqQoMqc7S+J4+6lk2fSofyQteseY4Hu9zNCqKxInYPR4jEecBDPHRiWT37TaH4Zj0Scde43PN4XO+ZiKRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GfNhDTbo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GfNhDTbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4FC1F00ACA;
	Fri, 31 Jul 2026 17:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785520395;
	bh=6c9iDN37jDA8XOCofqdqgwTjdoRk9RxVZQOwtoN4qpE=;
	h=Date:To:From:Subject;
	b=GfNhDTbose38OCkSGqhvYqtwkxEy2zTCdd37vOOFYvw/pwirovrqLfKPYJ/ov9cMx
	 L9aqWtz1dy4REAf0dq5bnCdUkKgs2Y/OhpDCDLPFCDxRw98XTHob9mc432bE8EWiMT
	 IbmkhlKG8cI0RyNnzarq+7nolQ4r4dSuudGOTyz4=
Date: Fri, 31 Jul 2026 10:53:14 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,riel@surriel.com,osalvador@suse.de,muchun.song@linux.dev,leitao@debian.org,david@kernel.org,guillaume@morinfr.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-only-adjust-reservation-during-unmapping-if-mapcount-is-0.patch added to mm-new branch
Message-Id: <20260731175314.DB4FC1F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: only adjust reservation during unmapping if mapcount is 0
has been added to the -mm mm-new branch.  Its filename is
     hugetlb-only-adjust-reservation-during-unmapping-if-mapcount-is-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-only-adjust-reservation-during-unmapping-if-mapcount-is-0.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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

hugetlb-only-adjust-reservation-during-unmapping-if-mapcount-is-0.patch

