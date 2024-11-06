Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCA17DA9E
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854864; cv=none; b=dEUOB+EcHy/tgYh4PbqwBBJZ//r43dLhty8EINndEyrB9DUuj75X/D9BNWG5mZxiOq7guteazpIw0zAtBkaY/iX+50GmGA6w3wtf7vKPAlLbxG5mZy2kElVCdPrObr6ox0ZXXOFAgwJi2cFca9jWvfVs4j9PIc6TGpS872pYYmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854864; c=relaxed/simple;
	bh=G5HQIH1sbsOm6g9gDmw+4tJRvwLWGDgn5ssSKbFlkDk=;
	h=Date:To:From:Subject:Message-Id; b=N0O3bX6q90d4CBBEom45QxkShk+W5urJZIRgDALIP3tesUXbleND6ntmxf/lZieljS+7p9kkl1dheBDhPo7PtwV7OwQtYnxgUFgFzVcRo2/Ax5/eZ2O8KLaU9bMDWYH79/6kGoVtsJWZFfevEnbuTQRM0nBClFTiRq6+IJw4PbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gKAz+0HU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gKAz+0HU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85375C4CED3;
	Wed,  6 Nov 2024 01:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854864;
	bh=G5HQIH1sbsOm6g9gDmw+4tJRvwLWGDgn5ssSKbFlkDk=;
	h=Date:To:From:Subject:From;
	b=gKAz+0HUxSyNyduLxf0FG7vGFRLjctY3Jwe2o1QbCt+OEFoAxiVjiirP5FWNjxkZP
	 /Ae6nNtr1jrimjyRGtRWN6+F/Ef2UM2jDxHHbXuY/uzboHI7rns5RrlmHBazdd1rf6
	 8VG7g33+0ParluSueHHflCoJNe/OOvDvEJRQjm8A=
Date: Tue, 05 Nov 2024 17:01:04 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,osalvador@suse.de,jgg@nvidia.com,david@redhat.com,jthoughton@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-missing-mmu_notifier_clear_young-for-mmu_notifier.patch removed from -mm tree
Message-Id: <20241106010104.85375C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add missing mmu_notifier_clear_young for !MMU_NOTIFIER
has been removed from the -mm tree.  Its filename was
     mm-add-missing-mmu_notifier_clear_young-for-mmu_notifier.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: James Houghton <jthoughton@google.com>
Subject: mm: add missing mmu_notifier_clear_young for !MMU_NOTIFIER
Date: Mon, 21 Oct 2024 16:02:12 +0000

Remove the now unnecessary ifdef in mm/damon/vaddr.c as well.

Link: https://lkml.kernel.org/r/20241021160212.9935-1-jthoughton@google.com
Signed-off-by: James Houghton <jthoughton@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |    7 +++++++
 mm/damon/vaddr.c             |    2 --
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/include/linux/mmu_notifier.h~mm-add-missing-mmu_notifier_clear_young-for-mmu_notifier
+++ a/include/linux/mmu_notifier.h
@@ -606,6 +606,13 @@ static inline int mmu_notifier_clear_flu
 	return 0;
 }
 
+static inline int mmu_notifier_clear_young(struct mm_struct *mm,
+					   unsigned long start,
+					   unsigned long end)
+{
+	return 0;
+}
+
 static inline int mmu_notifier_test_young(struct mm_struct *mm,
 					  unsigned long address)
 {
--- a/mm/damon/vaddr.c~mm-add-missing-mmu_notifier_clear_young-for-mmu_notifier
+++ a/mm/damon/vaddr.c
@@ -353,11 +353,9 @@ static void damon_hugetlb_mkold(pte_t *p
 		set_huge_pte_at(mm, addr, pte, entry, psize);
 	}
 
-#ifdef CONFIG_MMU_NOTIFIER
 	if (mmu_notifier_clear_young(mm, addr,
 				     addr + huge_page_size(hstate_vma(vma))))
 		referenced = true;
-#endif /* CONFIG_MMU_NOTIFIER */
 
 	if (referenced)
 		folio_set_young(folio);
_

Patches currently in -mm which might be from jthoughton@google.com are


