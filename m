Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24912217F40;
	Mon, 17 Mar 2025 05:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188462; cv=none; b=Lid9A+f0qbO9e7jEE44JzytMGpjeqVph4OZl5cvKnf6LBC+dp0IwQSgQamJXRRFhVvX/m8FoQge4LBeF9edxF+ErsIfB09v/4zduycdUEKMFsDMqNOPkapLYWneNh1INKWrpFi013TW9dND6gg3yTg6OEbDgyvMtKM97tMpKOQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188462; c=relaxed/simple;
	bh=rICoZloCFImHg6uvk628PDWpnJQOCE5v29QUuUuXLnM=;
	h=Date:To:From:Subject:Message-Id; b=swXFeCmk/Vfb/cx73es2Pd5O20vntah68VP8aQC3UMVqZ+YA+sN0BBFsAYmX7mn0d5tGIL2W/sVZRXtkdMpfwffQ1aLsoT/DDQTaVx8z6ODQeyYwTCozvKXTaY4zO31z1A3eHXnFPzk03MqEZcAbpSR+3UULo1gbZoUHL9e50EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xWGme/Rk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xWGme/Rk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47F5C4CEEC;
	Mon, 17 Mar 2025 05:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188462;
	bh=rICoZloCFImHg6uvk628PDWpnJQOCE5v29QUuUuXLnM=;
	h=Date:To:From:Subject:From;
	b=xWGme/RkrLfNg50UOP7qViWvh7wr4FF8YWarTLIsEpPVeJF6DbPmBFQS2kLR0BwmC
	 dyE/neMhtW+fzFv44wG/sUryITnsC8Y87OY+FrR/wB7frxde563lw2abSsm3LVVR6M
	 ADPMX3pkZ5tv0motHhwClhodLGkJRPEAuzOX82hU=
Date: Sun, 16 Mar 2025 22:14:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,peterx@redhat.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,hughd@google.com,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-page_mapped_in_vma-hugetlb-walk-aware.patch removed from -mm tree
Message-Id: <20250317051421.E47F5C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make page_mapped_in_vma() hugetlb walk aware
has been removed from the -mm tree.  Its filename was
     mm-make-page_mapped_in_vma-hugetlb-walk-aware.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jane Chu <jane.chu@oracle.com>
Subject: mm: make page_mapped_in_vma() hugetlb walk aware
Date: Mon, 24 Feb 2025 14:14:45 -0700

When a process consumes a UE in a page, the memory failure handler
attempts to collect information for a potential SIGBUS.  If the page is an
anonymous page, page_mapped_in_vma(page, vma) is invoked in order to

  1. retrieve the vaddr from the process' address space,

  2. verify that the vaddr is indeed mapped to the poisoned page,
     where 'page' is the precise small page with UE.

It's been observed that when injecting poison to a non-head subpage of an
anonymous hugetlb page, no SIGBUS shows up, while injecting to the head
page produces a SIGBUS.  The cause is that, though hugetlb_walk() returns
a valid pmd entry (on x86), but check_pte() detects mismatch between the
head page per the pmd and the input subpage.  Thus the vaddr is considered
not mapped to the subpage and the process is not collected for SIGBUS
purpose.  This is the calling stack:

      collect_procs_anon
        page_mapped_in_vma
          page_vma_mapped_walk
            hugetlb_walk
              huge_pte_lock
                check_pte

check_pte() header says that it
"check if [pvmw->pfn, @pvmw->pfn + @pvmw->nr_pages) is mapped at the @pvmw->pte"
but practically works only if pvmw->pfn is the head page pfn at pvmw->pte.
Hindsight acknowledging that some pvmw->pte could point to a hugepage of
some sort such that it makes sense to make check_pte() work for hugepage.

Link: https://lkml.kernel.org/r/20250224211445.2663312-1-jane.chu@oracle.com
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: linmiaohe <linmiaohe@huawei.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/page_vma_mapped.c~mm-make-page_mapped_in_vma-hugetlb-walk-aware
+++ a/mm/page_vma_mapped.c
@@ -84,6 +84,7 @@ again:
  * mapped at the @pvmw->pte
  * @pvmw: page_vma_mapped_walk struct, includes a pair pte and pfn range
  * for checking
+ * @pte_nr: the number of small pages described by @pvmw->pte.
  *
  * page_vma_mapped_walk() found a place where pfn range is *potentially*
  * mapped. check_pte() has to validate this.
@@ -100,7 +101,7 @@ again:
  * Otherwise, return false.
  *
  */
-static bool check_pte(struct page_vma_mapped_walk *pvmw)
+static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
 {
 	unsigned long pfn;
 	pte_t ptent = ptep_get(pvmw->pte);
@@ -132,7 +133,11 @@ static bool check_pte(struct page_vma_ma
 		pfn = pte_pfn(ptent);
 	}
 
-	return (pfn - pvmw->pfn) < pvmw->nr_pages;
+	if ((pfn + pte_nr - 1) < pvmw->pfn)
+		return false;
+	if (pfn > (pvmw->pfn + pvmw->nr_pages - 1))
+		return false;
+	return true;
 }
 
 /* Returns true if the two ranges overlap.  Careful to not overflow. */
@@ -207,7 +212,7 @@ bool page_vma_mapped_walk(struct page_vm
 			return false;
 
 		pvmw->ptl = huge_pte_lock(hstate, mm, pvmw->pte);
-		if (!check_pte(pvmw))
+		if (!check_pte(pvmw, pages_per_huge_page(hstate)))
 			return not_found(pvmw);
 		return true;
 	}
@@ -290,7 +295,7 @@ restart:
 			goto next_pte;
 		}
 this_pte:
-		if (check_pte(pvmw))
+		if (check_pte(pvmw, 1))
 			return true;
 next_pte:
 		do {
_

Patches currently in -mm which might be from jane.chu@oracle.com are


