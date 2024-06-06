Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62153440C;
	Thu,  6 Jun 2024 02:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717640417; cv=none; b=DNWjiQCq4S2hH02mbWdlsm2yKxHLPoE2cOETke1Z182NTyXL1r74Z4o34cfVxFuqwCUmXsuq/DANbG4pMikuz+QDdIScfll2Wfe26HwqPjWqxdxPYN6sHoXW/6z9Gi9Je9bNNDw31RlycBP7ggC08v/TK3e5rWRu7sBso8bGhCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717640417; c=relaxed/simple;
	bh=kZRxQN2CUIH0u8eN6/qoloyz8aQBYFcfcktB3ZOyHxw=;
	h=Date:To:From:Subject:Message-Id; b=aGUVfYAwjK5B1PbDU/iVRT7JcMe0SB7CgZEmFI8ufocngPTarqqfiKbcluwoE1Zpc2IfCFsJ/ivYgqpOhLwATnzi3ka4U9isVfqP++6wQoTwDsWTJoyl+C3t+Z29FffrSG/8QykuQGdoENx8D11HW+UEWwsQv74t6bOA0dy4R14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n720W3cX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n720W3cX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F04C4AF4D;
	Thu,  6 Jun 2024 02:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717640417;
	bh=kZRxQN2CUIH0u8eN6/qoloyz8aQBYFcfcktB3ZOyHxw=;
	h=Date:To:From:Subject:From;
	b=n720W3cXLpFUXFoh58AsE4bWN3vqUiEyStnWTDEYHo5wqpPJD8HBQcNmEah/07oTJ
	 p1MV70PETfMkN37H/xLo9RKA7LKSGDdu58WGjzvExDqtHry6s/ShgoJEMjM0+1AIJW
	 I+EsfcgK239xEAQhxBlK3nugn59tdPpoDhZ6VaCM=
Date: Wed, 05 Jun 2024 19:20:16 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,muchun.song@linux.dev,leitao@debian.org,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-do-not-call-vma_add_reservation-upon-enomem.patch removed from -mm tree
Message-Id: <20240606022017.33F04C4AF4D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: do not call vma_add_reservation upon ENOMEM
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-do-not-call-vma_add_reservation-upon-enomem.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm/hugetlb: do not call vma_add_reservation upon ENOMEM
Date: Tue, 28 May 2024 22:53:23 +0200

sysbot reported a splat [1] on __unmap_hugepage_range().  This is because
vma_needs_reservation() can return -ENOMEM if
allocate_file_region_entries() fails to allocate the file_region struct
for the reservation.

Check for that and do not call vma_add_reservation() if that is the case,
otherwise region_abort() and region_del() will see that we do not have any
file_regions.

If we detect that vma_needs_reservation() returned -ENOMEM, we clear the
hugetlb_restore_reserve flag as if this reservation was still consumed, so
free_huge_folio() will not increment the resv count.

[1] https://lore.kernel.org/linux-mm/0000000000004096100617c58d54@google.com/T/#ma5983bc1ab18a54910da83416b3f89f3c7ee43aa

Link: https://lkml.kernel.org/r/20240528205323.20439-1-osalvador@suse.de
Fixes: df7a6d1f6405 ("mm/hugetlb: restore the reservation if needed")
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reported-and-tested-by: syzbot+d3fe2dc5ffe9380b714b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/0000000000004096100617c58d54@google.com/
Cc: Breno Leitao <leitao@debian.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-do-not-call-vma_add_reservation-upon-enomem
+++ a/mm/hugetlb.c
@@ -5768,8 +5768,20 @@ void __unmap_hugepage_range(struct mmu_g
 		 * do_exit() will not see it, and will keep the reservation
 		 * forever.
 		 */
-		if (adjust_reservation && vma_needs_reservation(h, vma, address))
-			vma_add_reservation(h, vma, address);
+		if (adjust_reservation) {
+			int rc = vma_needs_reservation(h, vma, address);
+
+			if (rc < 0)
+				/* Pressumably allocate_file_region_entries failed
+				 * to allocate a file_region struct. Clear
+				 * hugetlb_restore_reserve so that global reserve
+				 * count will not be incremented by free_huge_folio.
+				 * Act as if we consumed the reservation.
+				 */
+				folio_clear_hugetlb_restore_reserve(page_folio(page));
+			else if (rc)
+				vma_add_reservation(h, vma, address);
+		}
 
 		tlb_remove_page_size(tlb, page, huge_page_size(h));
 		/*
_

Patches currently in -mm which might be from osalvador@suse.de are

mm-hugetlb-drop-node_alloc_noretry-from-alloc_fresh_hugetlb_folio.patch
arch-x86-do-not-explicitly-clear-reserved-flag-in-free_pagetable.patch

