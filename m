Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FC1502567
	for <mm-commits@vger.kernel.org>; Mon, 28 Sep 2026 22:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790632903; cv=none; b=cRZ8WKGyP4KStHvhPmye4TUZF3kwrLxVm4KbyjV/Jctbg4fqomGPJX/1HuR5slq/vpyFgFLrBV3Qt+NNRVxQzrNOHk7qpMjUEVLwXzMmBQxTE2kc4ayWE2JfveM0uronZPNanEK8lmyB2scT/k4AKGA4MsBzffzTzI2i17BlgW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790632903; c=relaxed/simple;
	bh=7Za8e9tW2ZUg8JTpPwBonZVoH+Hn18+WWg6sGMnZzcU=;
	h=Date:To:From:Subject:Message-Id; b=M+ETO2jBfxjEgO08lf/RgYz8RfDInCIs5bDPW+CQabVfzIa3no8MDOTEurbfSw9F9j/mxifo4RI+uLkLFjkp14eXtAbUSqwvP0TzjthjH6BO+4HvrA5zMvZ5TmIKKiEp3ggCUlHuCUZ2OvxRIe0eUYwR+1OYmFxhlRZn3xB4azI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qc6gQ23z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qc6gQ23z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC231F00893;
	Mon, 28 Sep 2026 22:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790632901;
	bh=FeZucr8mDgrMoN/d41k5oa0rISAQhErEaGrmM7m/bDE=;
	h=Date:To:From:Subject;
	b=Qc6gQ23zlktopVcZa/CbZeLWw40ZJOQ4lrYYbWSeqSxqDH1KI6MJER4Sbwmh2aLKG
	 fgARhso9VrkvZwmBLB2nwNRx4y1BoViH+6YMuwxqLNpQwwcO6NBHeGGAYMDoV7RN+h
	 uOZb0wolmQ3cbdewFQbjoE0Md4sC9lmJas0YtcKM=
Date: Mon, 28 Sep 2026 15:01:40 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-collapse-drop-the-collapse_possible-wrapper.patch added to mm-unstable branch
Message-Id: <20260928220140.DBC231F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/collapse: drop the collapse_possible() wrapper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-collapse-drop-the-collapse_possible-wrapper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-collapse-drop-the-collapse_possible-wrapper.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
 
@@ -2878,7 +2872,8 @@ static void collapse_scan_mm_slot(unsign
 			cc->progress++;
 			break;
 		}
-		if (!collapse_possible(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
+		if (!collapse_possible_orders(vma, vma->vm_flags,
+					      TVA_KHUGEPAGED)) {
 			cc->progress++;
 			continue;
 		}
@@ -3190,7 +3185,7 @@ int madvise_collapse(struct vm_area_stru
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!collapse_possible(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
+	if (!collapse_possible_orders(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
 		return -EINVAL;
 
 	hstart = ALIGN(start, HPAGE_PMD_SIZE);
_

Patches currently in -mm which might be from kas@kernel.org are

mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch
mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze.patch
mm-huge_memory-add-folio_reset_partially_mapped.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-call-collapse_file-from-collapse_single_pmd.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch
selftests-mm-raise-the-khugepaged-test-case-cap.patch
selftests-mm-skip-collapse_compound_extreme-where-the-pmd-is-too-large.patch
selftests-mm-scale-khugepageds-collapse-wait-with-the-pmd-size.patch
selftests-mm-skip-khugepaged-page-cache-cases-without-a-pmd-folio.patch
selftests-mm-make-the-swap-cases-swapout-reliable.patch
selftests-mm-stop-khugepaged-during-the-madv_collapse-cases.patch
selftests-mm-move-is_backed_by_folio-into-vm_util.patch
selftests-mm-add-folio-order-check-for-address-ranges.patch
selftests-mm-add-folio-order-detection-self-check.patch
selftests-mm-add-khugepaged-completion-barrier-helper.patch
selftests-mm-add-order-parameterized-khugepaged-collapse-cases.patch
selftests-mm-parameterize-the-mixed-source-collapse-case-by-source-order.patch
selftests-mm-cover-a-shared-source-collapse-write-race.patch
selftests-mm-run-every-supported-collapse-order-by-default.patch
selftests-mm-check-that-one-khugepaged-pass-collapses-one-window.patch
selftests-mm-add-khugepaged-race-harness.patch
selftests-mm-race-the-collapse-of-windows-with-holes.patch
selftests-mm-add-memory-pressure-threads-to-the-khugepaged-race-harness.patch
selftests-mm-zap-whole-pte-tables-in-the-khugepaged-race-harness.patch

