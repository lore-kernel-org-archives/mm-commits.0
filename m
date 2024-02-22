Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBE72919
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560186; cv=none; b=ff4rS9lKsBU6Q4cpQ1PeEsouV2m00LQuDtlx93pB0PY4I6Gi6i5B3LeIashF1GsfMPEqDILG1XJkf8yrPbsqrhL24Loxevdgdhi7j/Bc5IbIQfwL0v3TXgOD60hGQQw5E2gr5rDaiErBY3SiHVHHOpH37znsM4M1FKuoNQtiVak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560186; c=relaxed/simple;
	bh=N0JJCxpGwfye13TeXQtbeiLN/6CxPHkn107dOhE0sYc=;
	h=Date:To:From:Subject:Message-Id; b=u886NoOMSc8TPLcRGL4nmPlgLFgYDoxF1TRuJT9hq5vTpwyc0q19B2PGIrEGqP14S5fW/FKZ5+cZIWReFadRkylTekUN0WX5VO+knS4IEcB2u3jrj2moYuLiO3ortYkfL6S0yJ9JvbmgyHjjEl6BVoveanf8q1QxplXN34CNTWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iXaa4WOv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iXaa4WOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832CDC43399;
	Thu, 22 Feb 2024 00:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560185;
	bh=N0JJCxpGwfye13TeXQtbeiLN/6CxPHkn107dOhE0sYc=;
	h=Date:To:From:Subject:From;
	b=iXaa4WOvw7WMmLHFBtTLyZeX6s9ynUZUjbbyFkBHKU8ESs5mD8xD+/2PyA86jMEJj
	 7LbguP0oupOBEHVOH9s4t2sbQYLUQDqu7CNzNRMjZlrrFtn/9aa32s2ITjiF9YvBl1
	 oakLhPfmuHEH35tpkBVZvjQ/KEHekI2NTwKd+CNc=
Date: Wed, 21 Feb 2024 16:03:04 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shuah@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,muchun.song@linux.dev,mhocko@kernel.org,lstoakes@gmail.com,hannes@cmpxchg.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-restore-the-reservation-if-needed.patch removed from -mm tree
Message-Id: <20240222000305.832CDC43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: restore the reservation if needed
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-restore-the-reservation-if-needed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm/hugetlb: restore the reservation if needed
Date: Mon, 5 Feb 2024 11:18:41 -0800

Patch series "mm/hugetlb: Restore the reservation", v2.

This is a fix for a case where a backing huge page could stolen after
madvise(MADV_DONTNEED).

A full reproducer is in selftest. See
https://lore.kernel.org/all/20240105155419.1939484-1-leitao@debian.org/

In order to test this patch, I instrumented the kernel with LOCKDEP and
KASAN, and run the following tests, without any regression:
  * The self test that reproduces the problem
  * All mm hugetlb selftests
	SUMMARY: PASS=9 SKIP=0 FAIL=0
  * All libhugetlbfs tests
	PASS:     0     86
	FAIL:     0      0


This patch (of 2):

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

Fix this by restoring the reserved page if necessary.

These are the condition for the page restore:

 * The system is not using surplus pages. The goal is to reduce the
   surplus usage for this case.
 * If the VMA has the HPAGE_RESV_OWNER flag set, and is PRIVATE. This is
   safely checked using __vma_private_lock()
 * The page is anonymous

Once this is scenario is found, set the `hugetlb_restore_reserve` bit in
the folio. Then check if the resv reservations need to be adjusted
later, done later, after the spinlock, since the vma_xxxx_reservation()
might touch the file system lock.

Link: https://lkml.kernel.org/r/20240205191843.4009640-1-leitao@debian.org
Link: https://lkml.kernel.org/r/20240205191843.4009640-2-leitao@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-restore-the-reservation-if-needed
+++ a/mm/hugetlb.c
@@ -5585,6 +5585,7 @@ void __unmap_hugepage_range(struct mmu_g
 	struct page *page;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
+	bool adjust_reservation = false;
 	unsigned long last_addr_mask;
 	bool force_flush = false;
 
@@ -5677,7 +5678,31 @@ void __unmap_hugepage_range(struct mmu_g
 		hugetlb_count_sub(pages_per_huge_page(h), mm);
 		hugetlb_remove_rmap(page_folio(page));
 
+		/*
+		 * Restore the reservation for anonymous page, otherwise the
+		 * backing page could be stolen by someone.
+		 * If there we are freeing a surplus, do not set the restore
+		 * reservation bit.
+		 */
+		if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
+		    folio_test_anon(page_folio(page))) {
+			folio_set_hugetlb_restore_reserve(page_folio(page));
+			/* Reservation to be adjusted after the spin lock */
+			adjust_reservation = true;
+		}
+
 		spin_unlock(ptl);
+
+		/*
+		 * Adjust the reservation for the region that will have the
+		 * reserve restored. Keep in mind that vma_needs_reservation() changes
+		 * resv->adds_in_progress if it succeeds. If this is not done,
+		 * do_exit() will not see it, and will keep the reservation
+		 * forever.
+		 */
+		if (adjust_reservation && vma_needs_reservation(h, vma, address))
+			vma_add_reservation(h, vma, address);
+
 		tlb_remove_page_size(tlb, page, huge_page_size(h));
 		/*
 		 * Bail out after unmapping reference page if supplied
_

Patches currently in -mm which might be from leitao@debian.org are


