Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B4A49B5C1
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 21:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789077364; cv=none; b=IwjvqCA5Vc6n9+nck+xmnD6lVOPsdn6oDIXs/nO7lT4mmTkUA7erpAZp/GYNry3pcHGeC8lG0igpiOOnCLEbatgIyVJAf+wAgROiJVu1AEWT78sjqfwpy1Issx95agvxKtvSRyvIh3XL5a+HFO9B2yi0Hja2xnRa5ex2TVEMJB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789077364; c=relaxed/simple;
	bh=2RiXZTlYcq5xzEUvoXntpsz22W+IYAVe5854aRYZAik=;
	h=Date:To:From:Subject:Message-Id; b=juSunr9/Rbpd3R1NCCiF9lQzzZTCCZ6xIjO+qUS61FuFzUJIx9GEQNfqGJG61PqJkYYUS41a6VQna7VUujgLIhOYgaLSqPt21Y0c7sYp0rI9t8kEzvVqt0vyvq6aF9dSDKceb47zWvwbhtM8NyjJuFY9Q8GDIjz743AbDEerSY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jqK6CR57; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jqK6CR57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6489D1F000FF;
	Thu, 10 Sep 2026 21:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789077363;
	bh=FhaStHjaIZM/npXlN0knZT0vY+Sagbk8rT0yofqV66s=;
	h=Date:To:From:Subject;
	b=jqK6CR57fVPc/91vZxwPpZadqUaqQvIgHVdZl4ut0P4NZW2e+2Wy4bH0KcMo9hw0Y
	 AJvVS+iVkE0IyUu3PeSj4i1YngdesMC1J7t25KZ71v7i2fWXCs88i3ETD7rp/ba/H+
	 fU2qfppLag3RlvgNEPzuFu+uQlQrXYvHRwEuNSTQ=
Date: Thu, 10 Sep 2026 14:56:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-collapse-drop-the-collapse_possible-wrapper.patch added to mm-new branch
Message-Id: <20260910215603.6489D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/collapse: drop the collapse_possible() wrapper
has been added to the -mm mm-new branch.  Its filename is
     mm-collapse-drop-the-collapse_possible-wrapper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-collapse-drop-the-collapse_possible-wrapper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Date: Thu, 10 Sep 2026 13:02:26 +0100

collapse_possible() only forwards to collapse_possible_orders() and turns
its mask into a bool.  Its three callers can test the mask themselves.

No functional change.

Assisted-by: LLM
Link: https://lore.kernel.org/20260910120238.2529819-7-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/mm/khugepaged.c~mm-collapse-drop-the-collapse_possible-wrapper
+++ a/mm/khugepaged.c
@@ -512,17 +512,11 @@ static unsigned long collapse_possible_o
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
 
@@ -2857,7 +2851,8 @@ static void collapse_scan_mm_slot(unsign
 			cc->progress++;
 			break;
 		}
-		if (!collapse_possible(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
+		if (!collapse_possible_orders(vma, vma->vm_flags,
+					      TVA_KHUGEPAGED)) {
 			cc->progress++;
 			continue;
 		}
@@ -3170,7 +3165,7 @@ int madvise_collapse(struct vm_area_stru
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
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch

