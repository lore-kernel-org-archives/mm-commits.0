Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DC91EB5E3
	for <mm-commits@vger.kernel.org>; Sat, 10 May 2025 01:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746841097; cv=none; b=e65CMusVlgIE1g5MOZSK2W2bgVpZ6rizcSPcVJPsj6PBFiWb/ErZOjM9MO1giTo06jsLTn0LD1bg+WfAGIhnwjN+DSoPuUEWVAsiP2SZrmzt20ctxsXwdZFQ1b4xmi9JneJ0LeWoe+0o7IE/DpfSBCcCOEYRDqNB7Hnvlwq888Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746841097; c=relaxed/simple;
	bh=ZKEZz2GRm4RAxbDRdJdzee1U0GxU0TyVcnZgtblkjsw=;
	h=Date:To:From:Subject:Message-Id; b=UC9tcKPfeBB/l+ExEaUlTkIpnZ/99NcNMsA21bgeYlm/4xkwoO2gAewfg4GeHukMZIe75EW+t/iF8Az+M/H6bSKufYlSAU6ULnBWe9iEC1OjU6xKXHDac9Io8S/vuoNb94SBd6nJicBxfxiQJBoGLVnF684NfO46DGZo88g+GLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HdpJ5rla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HdpJ5rla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA82C4CEE4;
	Sat, 10 May 2025 01:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746841096;
	bh=ZKEZz2GRm4RAxbDRdJdzee1U0GxU0TyVcnZgtblkjsw=;
	h=Date:To:From:Subject:From;
	b=HdpJ5rlaDSHcQY2VITyweN5XUwwaykMwcCGtNEfpqFVz02z6J70Woai8V3ijB6fU8
	 5Y22Zj/POQlBXMn6TVSCHLWl2or0nDaQS2anBBM/6nR8sEP950E6JywcjchuZov4R8
	 7AAWG5/enMjY+OEZfgq7YWuIqJRJMqkiqxpcRfPE=
Date: Fri, 09 May 2025 18:38:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,dev.jain@arm.com,david@redhat.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mincore-use-pte_batch_bint-to-batch-process-large-folios.patch added to mm-new branch
Message-Id: <20250510013816.0DA82C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mincore: use pte_batch_hint() to batch process large folios
has been added to the -mm mm-new branch.  Its filename is
     mm-mincore-use-pte_batch_bint-to-batch-process-large-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mincore-use-pte_batch_bint-to-batch-process-large-folios.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: mincore: use pte_batch_hint() to batch process large folios
Date: Fri, 9 May 2025 08:45:21 +0800

When I tested the mincore() syscall, I observed that it takes longer with
64K mTHP enabled on my Arm64 server.  The reason is the
mincore_pte_range() still checks each PTE individually, even when the PTEs
are contiguous, which is not efficient.

Thus we can use pte_batch_hint() to get the batch number of the present
contiguous PTEs, which can improve the performance.  I tested the
mincore() syscall with 1G anonymous memory populated with 64K mTHP, and
observed an obvious performance improvement:

w/o patch		w/ patch		changes
6022us			549us			+91%

Moreover, I also tested mincore() with disabling mTHP/THP, and did not see
any obvious regression for base pages.

Link: https://lkml.kernel.org/r/99cb00ee626ceb6e788102ca36821815cd832237.1746697240.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/mm/mincore.c~mm-mincore-use-pte_batch_bint-to-batch-process-large-folios
+++ a/mm/mincore.c
@@ -21,6 +21,7 @@
 
 #include <linux/uaccess.h>
 #include "swap.h"
+#include "internal.h"
 
 static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
 			unsigned long end, struct mm_walk *walk)
@@ -105,6 +106,7 @@ static int mincore_pte_range(pmd_t *pmd,
 	pte_t *ptep;
 	unsigned char *vec = walk->private;
 	int nr = (end - addr) >> PAGE_SHIFT;
+	int step, i;
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
@@ -118,16 +120,26 @@ static int mincore_pte_range(pmd_t *pmd,
 		walk->action = ACTION_AGAIN;
 		return 0;
 	}
-	for (; addr != end; ptep++, addr += PAGE_SIZE) {
+	for (; addr != end; ptep += step, addr += step * PAGE_SIZE) {
 		pte_t pte = ptep_get(ptep);
 
+		step = 1;
 		/* We need to do cache lookup too for pte markers */
 		if (pte_none_mostly(pte))
 			__mincore_unmapped_range(addr, addr + PAGE_SIZE,
 						 vma, vec);
-		else if (pte_present(pte))
-			*vec = 1;
-		else { /* pte is a swap entry */
+		else if (pte_present(pte)) {
+			unsigned int batch = pte_batch_hint(ptep, pte);
+
+			if (batch > 1) {
+				unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
+
+				step = min_t(unsigned int, batch, max_nr);
+			}
+
+			for (i = 0; i < step; i++)
+				vec[i] = 1;
+		} else { /* pte is a swap entry */
 			swp_entry_t entry = pte_to_swp_entry(pte);
 
 			if (non_swap_entry(entry)) {
@@ -146,7 +158,7 @@ static int mincore_pte_range(pmd_t *pmd,
 #endif
 			}
 		}
-		vec++;
+		vec += step;
 	}
 	pte_unmap_unlock(ptep - 1, ptl);
 out:
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp.patch
mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp-fix.patch
mm-khugepaged-convert-set_huge_pmd-to-take-a-folio.patch
mm-convert-do_set_pmd-to-take-a-folio.patch
mm-mincore-use-pte_batch_bint-to-batch-process-large-folios.patch

