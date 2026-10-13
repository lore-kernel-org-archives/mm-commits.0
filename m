Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3FE53163A
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 18:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791915970; cv=none; b=qT1aa4bbbGdVzV4pOyMHXnaszXEa05yThwB+pDGsrXc6fOp76FxmWX2hd8NMWA3vYfVfdGiWkUFDg9lEkDiJU73BfDa54hsm9eD//P3LYFpmFNrx5O9ocoV2xmVk/F9L9ooAIUMwKvDfm/XvFa1NqryfuXsfrlvIL5gD34gE6Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791915970; c=relaxed/simple;
	bh=d+IPc8IDHB//m3J2t69oZ0OivkfcsrETFSm+/p20F2o=;
	h=Date:To:From:Subject:Message-Id; b=MYJJy8ax6fqsIm5toL41C/qjWHYDUpV4+nMWvR9PrfSoOctyvNfz0dcYQSQCIaQYhGO+v6rXdiwwweZU3lfl8xErIskb8qygAepua4CIz75KrsdCpvO8yM8hMgTKFl922KMedWBnGItM7T6FoOh1BDaQPmRxur5ep/5nvbjiqbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eG7Ziiku; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eG7Ziiku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD27D1F00893;
	Tue, 13 Oct 2026 18:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791915969;
	bh=Iiv/Tgs8xNnViTH/tsUqRkpSH/3gOgrVPOkPkAP8Ocs=;
	h=Date:To:From:Subject;
	b=eG7ZiikuJW0Qu+qNJ2WgC1AwMmB9pBJj7q7MTLi5pHi2XW+HqzUeFn4AfXTh3M7tI
	 7EHJt7yNFH13Ly6gj7vFWx9KorteqPdqL6f62/L/ZFgicoWw7nu7zfIwOAHEXQmMig
	 z3eUKDbI7QrFKoQVoKHCyNJzo0vGzP42ORg5JMYQ=
Date: Tue, 13 Oct 2026 11:26:08 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-collapse-drop-the-collapse_possible-wrapper.patch removed from -mm tree
Message-Id: <20261013182608.DD27D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/collapse: drop the collapse_possible() wrapper
has been removed from the -mm tree.  Its filename was
     mm-collapse-drop-the-collapse_possible-wrapper.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/collapse: drop the collapse_possible() wrapper
Date: Mon, 28 Sep 2026 11:06:20 +0100

collapse_possible() only forwards to collapse_possible_orders() and turns
its mask into a bool.  Its three callers can test the mask themselves.

No functional change.

Link: https://lore.kernel.org/20260928100630.21870-7-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Assisted-by: LLM
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
---

 mm/khugepaged.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/mm/khugepaged.c~mm-collapse-drop-the-collapse_possible-wrapper
+++ a/mm/khugepaged.c
@@ -494,17 +494,11 @@ static unsigned long collapse_possible_o
 	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
 }
 
-static bool collapse_possible(struct vm_area_struct *vma,
-		vm_flags_t vm_flags, enum tva_type tva_flags)
-{
-	return collapse_possible_orders(vma, vm_flags, tva_flags);
-}
-
 void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
-	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) && hugepage_enabled()
-	    && collapse_possible(vma, vm_flags, TVA_KHUGEPAGED))
+	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) && hugepage_enabled() &&
+	    collapse_possible_orders(vma, vm_flags, TVA_KHUGEPAGED))
 		__khugepaged_enter(vma->vm_mm);
 }
 
@@ -2885,7 +2879,8 @@ static void collapse_scan_mm_slot(unsign
 			cc->progress++;
 			break;
 		}
-		if (!collapse_possible(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
+		if (!collapse_possible_orders(vma, vma->vm_flags,
+					      TVA_KHUGEPAGED)) {
 			cc->progress++;
 			continue;
 		}
@@ -3197,7 +3192,7 @@ int madvise_collapse(struct vm_area_stru
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!collapse_possible(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
+	if (!collapse_possible_orders(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
 		return -EINVAL;
 
 	hstart = ALIGN(start, HPAGE_PMD_SIZE);
_

Patches currently in -mm which might be from kas@kernel.org are

mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-call-collapse_file-from-collapse_single_pmd.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch

