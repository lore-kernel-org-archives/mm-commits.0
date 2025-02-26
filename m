Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A1225E822;
	Wed, 26 Feb 2025 22:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740610306; cv=none; b=mbpl80IXDH8VWpaH6IHsiixiR0m1ZjbPQ7mE4C5i65xBBKUf/da3AEWUiOiOTT6XExU57GmAEUcVWLtaPoLgFzC8xY2604uzY0VLlWWpEUtqwtpi7/jIslDBa4ZDvBEMMgY/PDDumJqf9VS/0kj1Lu+fyeyWkxWRktjg2JdhQHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740610306; c=relaxed/simple;
	bh=Zk9H/cYUSDxYBBD1ojGOTnmifz7fArhPPn70CaJTTqU=;
	h=Date:To:From:Subject:Message-Id; b=WBwAM0lFHP+vyFoIR+mEBoqbVVUzLtAcJVsLCueyNwJ4GlYoJoR1lJqVDsKnOeah0Bhr55ti6Kki8LGDcrKYG2cvQJ94KHudi/rmAaRRTQWFhwtBYK03vEuhXW5IPUvcIH0iRJH0+6YPYP9/knwOQBSbXCbPmOIycMaZSWXcHQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2euAZnt9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2euAZnt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876E8C4CED6;
	Wed, 26 Feb 2025 22:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740610305;
	bh=Zk9H/cYUSDxYBBD1ojGOTnmifz7fArhPPn70CaJTTqU=;
	h=Date:To:From:Subject:From;
	b=2euAZnt9eH3um/fE3S62Nc3x4fJPptvH2YyjJZBCJj9GB80M/mgpzei//UZxmPd1H
	 p4D11kXVxJLUE7dSkhGAkSOzMKP5xNH2adUtOImukPtVY5GvreVWobheMw5hzZy1TH
	 8L4/14BD3Ba0/xUPpPjE52qFLppNrzK+2wQ9Kr8U=
Date: Wed, 26 Feb 2025 14:51:44 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,surenb@google.com,stable@vger.kernel.org,mmaslanka@google.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,bgeffon@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-finish_fault-handling-for-large-folios.patch added to mm-hotfixes-unstable branch
Message-Id: <20250226225145.876E8C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix finish_fault() handling for large folios
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-finish_fault-handling-for-large-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-finish_fault-handling-for-large-folios.patch

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
From: Brian Geffon <bgeffon@google.com>
Subject: mm: fix finish_fault() handling for large folios
Date: Wed, 26 Feb 2025 11:23:41 -0500

When handling faults for anon shmem finish_fault() will attempt to install
ptes for the entire folio.  Unfortunately if it encounters a single
non-pte_none entry in that range it will bail, even if the pte that
triggered the fault is still pte_none.  When this situation happens the
fault will be retried endlessly never making forward progress.

This patch fixes this behavior and if it detects that a pte in the range
is not pte_none it will fall back to setting a single pte.

Link: https://lkml.kernel.org/r/20250226162341.915535-1-bgeffon@google.com
Fixes: 43e027e41423 ("mm: memory: extend finish_fault() to support large folio")
Signed-off-by: Brian Geffon <bgeffon@google.com>
Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Marek Maslanka <mmaslanka@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/mm/memory.c~mm-fix-finish_fault-handling-for-large-folios
+++ a/mm/memory.c
@@ -5185,7 +5185,11 @@ vm_fault_t finish_fault(struct vm_fault
 	bool is_cow = (vmf->flags & FAULT_FLAG_WRITE) &&
 		      !(vma->vm_flags & VM_SHARED);
 	int type, nr_pages;
-	unsigned long addr = vmf->address;
+	unsigned long addr;
+	bool needs_fallback = false;
+
+fallback:
+	addr = vmf->address;
 
 	/* Did we COW the page? */
 	if (is_cow)
@@ -5224,7 +5228,8 @@ vm_fault_t finish_fault(struct vm_fault
 	 * approach also applies to non-anonymous-shmem faults to avoid
 	 * inflating the RSS of the process.
 	 */
-	if (!vma_is_anon_shmem(vma) || unlikely(userfaultfd_armed(vma))) {
+	if (!vma_is_anon_shmem(vma) || unlikely(userfaultfd_armed(vma)) ||
+			unlikely(needs_fallback)) {
 		nr_pages = 1;
 	} else if (nr_pages > 1) {
 		pgoff_t idx = folio_page_idx(folio, page);
@@ -5260,9 +5265,9 @@ vm_fault_t finish_fault(struct vm_fault
 		ret = VM_FAULT_NOPAGE;
 		goto unlock;
 	} else if (nr_pages > 1 && !pte_range_none(vmf->pte, nr_pages)) {
-		update_mmu_tlb_range(vma, addr, vmf->pte, nr_pages);
-		ret = VM_FAULT_NOPAGE;
-		goto unlock;
+		needs_fallback = true;
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		goto fallback;
 	}
 
 	folio_ref_add(folio, nr_pages - 1);
_

Patches currently in -mm which might be from bgeffon@google.com are

mm-fix-finish_fault-handling-for-large-folios.patch

