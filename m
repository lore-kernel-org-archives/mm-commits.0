Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8504413B28B
	for <mm-commits@vger.kernel.org>; Mon,  5 Feb 2024 21:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707166883; cv=none; b=KXLIqMl3ROqZ1qEjyxtaVeu0s2OtceAZHx5+bZog+b9m3wRAmK6G/dhtWRIUJvuuMOa9RIgs3sh+brJagmTg8cxKcx4NOmkzTngRwO19Fv9aOVlwvKBZ48yyEXmk7MthtF7nqFsCbBjvdxv4mE76x5NsVDzVM2Df9r9yeHfNQdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707166883; c=relaxed/simple;
	bh=ia2ijROdOn2ykLQ1tknwTCoe6kpkPmmQGJ8rch9SnZ0=;
	h=Date:To:From:Subject:Message-Id; b=RGm/NSGY0YgWB/zXFasngBPx0vZJKJrcmHC+cymjkMa17QdAVOMSZP08Kh9FleEnZJpwVjI2gxM8IS9EyKoFJbWiZfbyOl4ChOLp79y4MCM1yrma92iGvxrcHJiJY6k/vHYrvaZfahw5gGGxWQFBQyrrCQRU+6GcTImnPwgdnQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mWPY0Cu4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mWPY0Cu4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0621BC433C7;
	Mon,  5 Feb 2024 21:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707166883;
	bh=ia2ijROdOn2ykLQ1tknwTCoe6kpkPmmQGJ8rch9SnZ0=;
	h=Date:To:From:Subject:From;
	b=mWPY0Cu4iVsMFltauBURaPd2VN8nYbBM6TvWqccMpToZQcOtLkjYiLAFGF51xCwlx
	 if35VqEC64d9hxCLqD7JhEPqj3dQ/FeSAZoK0PlxdG1ox5Ui5hOvTgkD/X4Xu7a74w
	 OFn0DmU/zjnSXbgwqwu6qKZmYM71op2/VxBwzUhY=
Date: Mon, 05 Feb 2024 13:01:22 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shuah@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,muchun.song@linux.dev,mhocko@kernel.org,lstoakes@gmail.com,hannes@cmpxchg.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-restore-the-reservation-if-needed.patch added to mm-unstable branch
Message-Id: <20240205210123.0621BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: Restore the reservation if needed
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-restore-the-reservation-if-needed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-restore-the-reservation-if-needed.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm/hugetlb: Restore the reservation if needed
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
@@ -5665,6 +5665,7 @@ void __unmap_hugepage_range(struct mmu_g
 	struct page *page;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
+	bool adjust_reservation = false;
 	unsigned long last_addr_mask;
 	bool force_flush = false;
 
@@ -5757,7 +5758,31 @@ void __unmap_hugepage_range(struct mmu_g
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

selftests-mm-new-test-that-steals-pages.patch
selftests-mm-run_vmtestssh-add-hugetlb-test-category.patch
mm-hugetlb-restore-the-reservation-if-needed.patch
selftests-mm-run_vmtestssh-add-hugetlb_madv_vs_map.patch

