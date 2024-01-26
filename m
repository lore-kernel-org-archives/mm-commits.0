Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC14D310;
	Fri, 26 Jan 2024 07:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255762; cv=none; b=QPktsrTcgGzi4B/VbLt2/OllIw+OotZ2RjdcwU/63dkpoVMU08gbDzQ7SshAF7pdrmTGKjsu4X52U/77XAu3aDadQovmtmJsqTe9choeSKydMT0CmzCW4enkN7AnMrHkQmEFzsrde/duYzoI5+crMIstItLNFAEOznzQ8ZOvqGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255762; c=relaxed/simple;
	bh=3Te0uYkQhoD8wPt8fBPAVzbgCbkYHURjya5IUT8r9v4=;
	h=Date:To:From:Subject:Message-Id; b=AGN3L3AHQ7I4CigH1Dg1iTHH8YeBG0ZfENU39KToGAGw5q5Uyjt/tHC2Z29vIwNXQyeng5ZUyq0/unh3sSOEvJzeImLAgoJLHfyttzMfdUB3K6QdBGvrw2XY8WBtbFyL/MPUS4Qy4PhevUNrdoXTggKHEJNFRPBShbRE6gslr8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tO5jypqY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tO5jypqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14665C433C7;
	Fri, 26 Jan 2024 07:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255762;
	bh=3Te0uYkQhoD8wPt8fBPAVzbgCbkYHURjya5IUT8r9v4=;
	h=Date:To:From:Subject:From;
	b=tO5jypqYDvq/N9ZBgz4fgXZWymeOnWfWIGGmqORvzVhC389TUzdqcvN4FRVLZMJPW
	 E3s+ZdfhtJsw0017IYBiu6oOm0zDJuGy/qSrUM9U9mSxqcQEizOxQ1KKi45XrDyaTy
	 KrOQ+tHvOfWgtEsNO7hfuDPOu7S4HqV5ZNT2BsJI=
Date: Thu, 25 Jan 2024 23:55:59 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,riel@surriel.com,muchun.song@linux.dev,lstoakes@gmail.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-restore-the-reservation-if-needed.patch removed from -mm tree
Message-Id: <20240126075602.14665C433C7@smtp.kernel.org>
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

selftests-mm-new-test-that-steals-pages.patch

