Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D90D14A8B;
	Tue, 26 Aug 2025 01:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756171521; cv=none; b=BGwX0ochefXAdMhXM1/a80wyH/fDE2LpLymwsNvGnMpiyA/dh+LdP3LZ9AJevyOJG7SP2sAzkmYGk3ll3oW7GP///QDR9D9vq5DvgLRgBsYfHaqBTKTMOs7y4s8A9iACkMYAF2BEzPWmG0FM4bKi2ZsUmVGaWgQTTSI0sjYPiF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756171521; c=relaxed/simple;
	bh=XaKsFiCrpF4WOiot84HlAt1C0T379kQZxh2FFYt8aaY=;
	h=Date:To:From:Subject:Message-Id; b=CDzp2iwa1UX2xVJSu9EtjKWWXd/tSPLQKYocNvx9JLF3IVYKPL8Kbow7Ka+1ajDIv0QIo4imzmwd6kNQW+ncSJzExYNmbVPRl3d+K4BjaF1KvXQxgZ5e2N4cVTRdapqnqNx6VKMI5Mmf+QAvpjmjLKH/fLLxTKRnmSEm8iWN5v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GwPYWe0s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GwPYWe0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F95AC4CEED;
	Tue, 26 Aug 2025 01:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756171518;
	bh=XaKsFiCrpF4WOiot84HlAt1C0T379kQZxh2FFYt8aaY=;
	h=Date:To:From:Subject:From;
	b=GwPYWe0sFRoEehylGO6c2dn/xd+cYbbUf8gg2cShl8w07YYMYeXZZ69erB0DSCUJZ
	 Vt0tCsff15fXFFvtms2uCIF5qTOZpSFpq27iAA2uBNhSAmgi3AScnTcetw9po2SDcX
	 VUPtELWeUWUq0ONcXejrECnQow4nZTZlTMcTBodU=
Date: Mon, 25 Aug 2025 18:25:18 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,leitao@debian.org,david@redhat.com,aha310510@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-add-missing-hugetlb_lock-in-__unmap_hugepage_range.patch added to mm-hotfixes-unstable branch
Message-Id: <20250826012518.9F95AC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: add missing hugetlb_lock in __unmap_hugepage_range()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-add-missing-hugetlb_lock-in-__unmap_hugepage_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-add-missing-hugetlb_lock-in-__unmap_hugepage_range.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-hugetlb-add-missing-hugetlb_lock-in-__unmap_hugepage_range.patch

