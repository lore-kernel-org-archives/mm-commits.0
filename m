Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8B263AF;
	Tue, 23 Jan 2024 00:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970691; cv=none; b=CA1KD/2e3PCdtG6/YCeS6Fjw1V3zbUF/Ib+XBs1+zrrOixMshfCD20FIYrh+GtERn7IM4YpkQNZB1MDFBGIhrKvKEg5tbEZfl4CD7XGPHCgXVDPIM73NhzK6u73V7pl6V0iJrCnNRk+vE5hX+e8oltnd34udadP4cFBuAfI4LO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970691; c=relaxed/simple;
	bh=sdWOILis3ANCa3Z/eN76kpIF4XgAUHfxB71qYiGgf5o=;
	h=Date:To:From:Subject:Message-Id; b=CjW9hgY1jQ52cpr2QyZZVB+9EzeN2G6ATZ6Py44K8SkYADqP1XyXwyGFvCbF13GMY/O2PC8xEIm946geUTC5Kbgvaa1w3BuA5JRCB/20XaKnctOgBxc/M60QgIuXkiXvbkkW5rQUSYEBas7DG0VNe5DV5LwmeiwzMrnxo4807BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EYTQWPim; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EYTQWPim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6884C43390;
	Tue, 23 Jan 2024 00:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970691;
	bh=sdWOILis3ANCa3Z/eN76kpIF4XgAUHfxB71qYiGgf5o=;
	h=Date:To:From:Subject:From;
	b=EYTQWPimVCoTLOlXiSKeq67rS746vKRwz6fygIufVBSRum1fOBTnALdKIdHNqXw9Q
	 JRKWjsRMa2IoFIwzykooKkD4DFljmFwEEDeJFRlYNI0rmpHMOFn0UvsNwQzeP9JFY8
	 n84pP2opupAzXiD97KjhYdkQRCNiPW8grPx4o64g=
Date: Mon, 22 Jan 2024 16:44:48 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,riel@surriel.com,muchun.song@linux.dev,lstoakes@gmail.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-restore-the-reservation-if-needed.patch added to mm-hotfixes-unstable branch
Message-Id: <20240123004450.C6884C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: restore the reservation if needed
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-restore-the-reservation-if-needed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-restore-the-reservation-if-needed.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: mm/hugetlb: restore the reservation if needed
Date: Wed, 17 Jan 2024 09:10:57 -0800

Currently there is a bug that a huge page could be stolen, and when the
original owner tries to fault in it, it causes a page fault.

You can achieve that by:
  1) Creating a single page
	echo 1 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

  2) mmap() the page above with MAP_HUGETLB into (void *ptr1).
	* This will mark the page as reserved
  3) touch the page, which causes a page fault and allocates the page
	* This will move the page out of the free list.
	* It will also unreserved the page, since there is no more free
	  page
  4) madvise(MADV_DONTNEED) the page
	* This will free the page, but not mark it as reserved.
  5) Allocate a secondary page with mmap(MAP_HUGETLB) into (void *ptr2).
	* it should fail, but, since there is no more available page.
	* But, since the page above is not reserved, this mmap() succeed.
  6) Faulting at ptr1 will cause a SIGBUS
	* it will try to allocate a huge page, but there is none
	  available

A full reproducer is in selftest. See
https://lore.kernel.org/all/20240105155419.1939484-1-leitao@debian.org/

Fix this by restoring the reserved page if necessary.  If the page being
unmapped has HPAGE_RESV_OWNER set, and needs a reservation, set the
restore_reserve flag, which will move the page from free to reserved.

Link: https://lkml.kernel.org/r/20240117171058.2192286-1-leitao@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: Rik van Riel <riel@surriel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-restore-the-reservation-if-needed
+++ a/mm/hugetlb.c
@@ -5677,6 +5677,16 @@ void __unmap_hugepage_range(struct mmu_g
 		hugetlb_count_sub(pages_per_huge_page(h), mm);
 		hugetlb_remove_rmap(page_folio(page));
 
+		if (is_vma_resv_set(vma, HPAGE_RESV_OWNER) &&
+		    vma_needs_reservation(h, vma, start)) {
+			/*
+			 * Restore the reservation if needed, otherwise the
+			 * backing page could be stolen by someone.
+			 */
+			folio_set_hugetlb_restore_reserve(page_folio(page));
+			vma_add_reservation(h, vma, address);
+		}
+
 		spin_unlock(ptl);
 		tlb_remove_page_size(tlb, page, huge_page_size(h));
 		/*
_

Patches currently in -mm which might be from leitao@debian.org are

mm-hugetlb-restore-the-reservation-if-needed.patch
selftests-mm-run_vmtestssh-add-hugetlb_madv_vs_map.patch
selftests-mm-new-test-that-steals-pages.patch

