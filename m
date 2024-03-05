Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9F08C07
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600529; cv=none; b=elq1BkwSvRuLAJy3aLdTyWCnOxoAXTBhu3eQNoLi68znCKX24hSiaud5Bfm87Kz50tSC0AitqPgDB/kKAbEtTygWPMFbPtd1hknVFgsTIPv7H6za7ykDXQq3BRWJj3hyJNz9DuqCG+Mp2v3mr0quKxmB7isUF9g4ccAabsq07U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600529; c=relaxed/simple;
	bh=9weXMcevBbaRga+fVXasTg4gd9iVre3P7mZ+cmfr4ec=;
	h=Date:To:From:Subject:Message-Id; b=FiAQrOS9ESWck8htjYzpEg5klWWJV7WADVIn/c3Q76/rVLyMqlr6TOsVXwLpa16CJXlegA3NjLqrdea75UFvU2p+C7/je0JfiKBRjcAfV21MMqBbUjzblG9CgkaFFehuBZJFOz8xm5JYZcRMCY7e6KyinlXwB/hrfEV+btl9OqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pgpwqf9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pgpwqf9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8A8C43390;
	Tue,  5 Mar 2024 01:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600529;
	bh=9weXMcevBbaRga+fVXasTg4gd9iVre3P7mZ+cmfr4ec=;
	h=Date:To:From:Subject:From;
	b=pgpwqf9cYHzq8tq+5zbXcxzIiS87jpadIMiZBchnvYJChVPGhfjxRTZtMvSAatN6W
	 z9mMm05v51/KZE5KHgN6mjGRBDFnq/16luZgrbeSAu/KCF3wTmz8urBnjrch+R8NjK
	 k/vc0/9VoklWHO/jtjBQsRixLA+noma4wnETJ2Gk=
Date: Mon, 04 Mar 2024 17:02:08 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-allow-faults-to-be-handled-under-the-vma-lock.patch removed from -mm tree
Message-Id: <20240305010209.2F8A8C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: allow faults to be handled under the VMA lock
has been removed from the -mm tree.  Its filename was
     hugetlb-allow-faults-to-be-handled-under-the-vma-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: hugetlb: allow faults to be handled under the VMA lock
Date: Wed, 21 Feb 2024 15:47:32 -0800

Hugetlb can now safely handle faults under the VMA lock, so allow it to do
so.

This patch may cause ltp hugemmap10 to "fail".  Hugemmap10 tests hugetlb
counters, and expects the counters to remain unchanged on failure to
handle a fault.

In hugetlb_no_page(), vmf_anon_prepare() may bailout with no anon_vma
under the VMA lock after allocating a folio for the hugepage.  In
free_huge_folio(), this folio is completely freed on bailout iff there is
a surplus of hugetlb pages.  This will remove a folio off the freelist and
decrement the number of hugepages while ltp expects these counters to
remain unchanged on failure.

Originally this could only happen due to OOM failures, but now it may also
occur after we allocate a hugetlb folio without a suitable anon_vma under
the VMA lock.  This should only happen for the first freshly allocated
hugepage in this vma.

Link: https://lkml.kernel.org/r/20240221234732.187629-6-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/hugetlb.c~hugetlb-allow-faults-to-be-handled-under-the-vma-lock
+++ a/mm/hugetlb.c
@@ -6379,12 +6379,6 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		 */
 	};
 
-	/* TODO: Handle faults under the VMA lock */
-	if (flags & FAULT_FLAG_VMA_LOCK) {
-		vma_end_read(vma);
-		return VM_FAULT_RETRY;
-	}
-
 	/*
 	 * Serialize hugepage allocation and instantiation, so that we don't
 	 * get spurious allocation failures if two CPUs race to instantiate
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


