Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F72155C97
	for <mm-commits@vger.kernel.org>; Sat, 18 Jul 2026 02:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784342888; cv=none; b=nS8IwdjR2I/hAivMahPfuHt9RrpJnghTmLgM00+75XXYVRSjFcM0YOGpJSdbkSrbQYyN0sLDSN6oSCIaHzruXvZMBXbzICIHOip83yvS0eIjHZtJYpasQCayiOFjdmbMhGL8HhjrT5zwLJNkE/UJja3uxlH9ahH7kIuCdZJOHWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784342888; c=relaxed/simple;
	bh=HDMErfW5tbaEPqKlE4LUkuGm5y7sWkzko0uZEtSb5fc=;
	h=Date:To:From:Subject:Message-Id; b=ehHFLoXh7BQPX8IN38W3b1XpKxxlkejq5vS6Bpu9hsRlHnX1ZGxtPOcM84I4o+Cj8RRpdyhZgxHuA26pE4xFRyneNKWf/gstPpOrotdLdSkqIpf3unS7+HpOnbVeVsn112GSm7oDl4oerlQKe7tcR4/PUlBoHgYdn3DRBenYWL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uBo7v7Hx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uBo7v7Hx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AACA1F000E9;
	Sat, 18 Jul 2026 02:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784342886;
	bh=vkr1VUsLxSqX8sIZGr4QC9F1J/VCHwYEPBFKyigbsmg=;
	h=Date:To:From:Subject;
	b=uBo7v7HxWR4E1ZOe+LyWEARMdC82iEi9fSVZHx8jMg+aXczxMT/AECDr1rsFTpLXU
	 /ZVNOdUN2ulpZ8KbghPNfYUqemBnsew4akrGl47nh/TsolUsB8tZafFr8Yo5NXxIkv
	 WHZ+Jg962gun7wTttKJ0L1KcUC3ubUho59iHr+k8=
Date: Fri, 17 Jul 2026 19:48:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-remove-unused-can_split_folio.patch added to mm-new branch
Message-Id: <20260718024806.2AACA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: remove unused can_split_folio()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-remove-unused-can_split_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-remove-unused-can_split_folio.patch

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
Subject: mm/huge_memory: remove unused can_split_folio()
Date: Thu, 16 Jul 2026 11:03:44 +0100

Patch series "mm/huge_memory: drop dead split helper variants".

Two trivial cleanups in the folio split API, found while auditing the
split helpers for the inode UAF fix [1]:

 - can_split_folio() is dead: only the !THP stub remains, no definition
   under CONFIG_TRANSPARENT_HUGEPAGE and no callers. Leftover from an
   earlier cleanup.

 - split_folio_to_list_to_order() has no direct callers; its only user
   is split_folio_to_order(), which always passes a NULL list. Fold it.

No functional change.


This patch (of 2):

can_split_folio() has no callers and no definition under
CONFIG_TRANSPARENT_HUGEPAGE; only the !THP stub remains, left behind by an
earlier cleanup.  Remove it.

No functional change.

Link: https://lore.kernel.org/20260716100345.473473-1-kirill@shutemov.name
Link: https://lore.kernel.org/20260716100345.473473-2-kirill@shutemov.name
Link: https://lore.kernel.org/linux-mm/aldjhtfVByHDQXe6@thinkstation [1]
Link: https://lore.kernel.org/linux-mm/20260714122344.351895-1-kirill@shutemov.name [2]
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-remove-unused-can_split_folio
+++ a/include/linux/huge_mm.h
@@ -642,11 +642,6 @@ thp_get_unmapped_area_vmaflags(struct fi
 	return 0;
 }
 
-static inline bool
-can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
-{
-	return false;
-}
 static inline int
 split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order)
_

Patches currently in -mm which might be from kas@kernel.org are

fs-proc-task_mmu-fix-pagemap_scan-written-state-for-unpopulated-ptes.patch
mm-hugetlb-fix-swap-entry-corruption-when-clearing-uffd-wp-at-fork.patch
fs-proc-task_mmu-fix-pagemap_scan-written-state-for-pmd-holes.patch
mm-decouple-protnone-helpers-from-config_numa_balancing.patch
mm-rename-uffd-wp-pte-bit-macros-to-uffd.patch
mm-rename-uffd-wp-pte-accessors-to-uffd.patch
userfaultfd-test-uffd-vma-flags-through-the-vma_flags_t-api.patch
mm-add-vm_uffd_rwp-vma-flag.patch
mm-add-mm_cp_uffd_rwp-change_protection-flag.patch
mm-preserve-rwp-marker-across-pte-rewrites.patch
mm-handle-vm_uffd_rwp-in-khugepaged-rmap-and-gup.patch
userfaultfd-add-uffdio_register_mode_rwp-and-uffdio_rwprotect-plumbing.patch
mm-userfaultfd-add-rwp-fault-delivery-and-expose-uffdio_register_mode_rwp.patch
mm-pagemap-add-page_is_accessed-for-rwp-tracking.patch
userfaultfd-add-uffd_feature_rwp_async-for-async-fault-resolution.patch
userfaultfd-add-uffdio_set_mode-for-runtime-sync-async-toggle.patch
selftests-mm-add-userfaultfd-rwp-tests.patch
documentation-userfaultfd-document-rwp-working-set-tracking.patch
selftests-mm-add-pagemap_scan-test-for-thp-pmd-holes.patch
mm-huge_memory-remove-unused-can_split_folio.patch
mm-huge_memory-fold-split_folio_to_list_to_order-into-split_folio_to_order.patch

