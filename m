Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C87942A82
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 05:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722663216; cv=none; b=hW8RuMOCQmYcLAa75pJJMGrnCrCoBCNZbjbs3/fHXVn6zU0/3InUCoI56V2DQHVLnKZ/NgcRqdq632Rvmw9w4iNYHPHYbfMd02XG7yJVDJ5q4U3Hld1uktPuWMFbhU90DzGGt0j/LxqD78A0Od/7djurF7t3yzwQvb1+Y6Ul4MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722663216; c=relaxed/simple;
	bh=vmuT3dXvV1uiODsptN+gkvpA2w9/h/6yAucMUQHjWEw=;
	h=Date:To:From:Subject:Message-Id; b=Zni5mjzNwNrex6BI/6cTrTcfMeBCamiQiJ9lyw4OZl7A6K0148UZlO09DahAfNH1WfMhizFcgR3gSbud5pjbv2Fp5Xi06WchlFEosFiSijSJNGGq1bjbm2ew09ZnIMxmpO8mFf1IB932TKeWLDDaT1+7FBhkhdfE1fnlA91LV78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eZTQbHyR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eZTQbHyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04158C116B1;
	Sat,  3 Aug 2024 05:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722663216;
	bh=vmuT3dXvV1uiODsptN+gkvpA2w9/h/6yAucMUQHjWEw=;
	h=Date:To:From:Subject:From;
	b=eZTQbHyRlYxxl70eYUmBfZVDTsqIJpe3wNFpp8mk6yUg/m6WM5ssQGX8Y5LrFhsso
	 lJN1HBB4hDyO9q2bnQcoma+ZQOYdVreLbSwdrIpoHCe6oLt+iO/cE/4om29tO+qN6U
	 qKsL3Zk/eOYwCaqxQ+UYJBoON2Juqnmyh/w/jVco=
Date: Fri, 02 Aug 2024 22:33:35 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,svens@linux.ibm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-provide-vm_normal_pagefolio_pmd-with-config_pgtable_has_huge_leaves.patch added to mm-unstable branch
Message-Id: <20240803053336.04158C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: provide vm_normal_(page|folio)_pmd() with CONFIG_PGTABLE_HAS_HUGE_LEAVES
has been added to the -mm mm-unstable branch.  Its filename is
     mm-provide-vm_normal_pagefolio_pmd-with-config_pgtable_has_huge_leaves.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-provide-vm_normal_pagefolio_pmd-with-config_pgtable_has_huge_leaves.patch

This patch will later appear in the mm-unstable branch at
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
From: David Hildenbrand <david@redhat.com>
Subject: mm: provide vm_normal_(page|folio)_pmd() with CONFIG_PGTABLE_HAS_HUGE_LEAVES
Date: Fri, 2 Aug 2024 17:55:14 +0200

Patch series "mm: replace follow_page() by folio_walk".

Looking into a way of moving the last folio_likely_mapped_shared() call in
add_folio_for_migration() under the PTL, I found myself removing
follow_page().  This paves the way for cleaning up all the FOLL_, follow_*
terminology to just be called "GUP" nowadays.

The new page table walker will lookup a mapped folio and return to the
caller with the PTL held, such that the folio cannot get unmapped
concurrently.  Callers can then conditionally decide whether they really
want to take a short-term folio reference or whether the can simply unlock
the PTL and be done with it.

folio_walk is similar to page_vma_mapped_walk(), except that we don't know
the folio we want to walk to and that we are only walking to exactly one
PTE/PMD/PUD.

folio_walk provides access to the pte/pmd/pud (and the referenced folio
page because things like KSM need that), however, as part of this series
no page table modifications are performed by users.

We might be able to convert some other walk_page_range() users that really
only walk to one address, such as DAMON with
damon_mkold_ops/damon_young_ops.  It might make sense to extend folio_walk
in the future to optionally fault in a folio (if applicable), such that we
can replace some get_user_pages() users that really only want to lookup a
single page/folio under PTL without unconditionally grabbing a folio
reference.

I have plans to extend the approach to a range walker that will try
batching various page table entries (not just folio pages) to be a better
replace for walk_page_range() -- and users will be able to opt in which
type of page table entries they want to process -- but that will require
more work and more thoughts.

KSM seems to work just fine (ksm_functional_tests selftests) and
move_pages seems to work (migration selftest).  I tested the leaf
implementation excessively using various hugetlb sizes (64K, 2M, 32M, 1G)
on arm64 using move_pages and did some more testing on x86-64.  Cross
compiled on a bunch of architectures.


This patch (of 11):

We want to make use of vm_normal_page_pmd() in generic page table walking
code where we might walk hugetlb folios that are mapped by PMDs even
without CONFIG_TRANSPARENT_HUGEPAGE.

So let's expose vm_normal_page_pmd() + vm_normal_folio_pmd() with
CONFIG_PGTABLE_HAS_HUGE_LEAVES.

Link: https://lkml.kernel.org/r/20240802155524.517137-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240802155524.517137-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-provide-vm_normal_pagefolio_pmd-with-config_pgtable_has_huge_leaves
+++ a/mm/memory.c
@@ -666,7 +666,7 @@ struct folio *vm_normal_folio(struct vm_
 	return NULL;
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
 struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 				pmd_t pmd)
 {
_

Patches currently in -mm which might be from david@redhat.com are

mm-turn-use_split_pte_ptlocks-use_split_pte_ptlocks-into-kconfig-options.patch
mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch
powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch
mm-simplify-arch_make_folio_accessible.patch
mm-gup-convert-to-arch_make_folio_accessible.patch
s390-uv-drop-arch_make_page_accessible.patch
mm-hugetlb-remove-hugetlb_follow_page_mask-leftover.patch
mm-rmap-cleanup-partially-mapped-handling-in-__folio_remove_rmap.patch
mm-clarify-folio_likely_mapped_shared-documentation-for-ksm-folios.patch
mm-provide-vm_normal_pagefolio_pmd-with-config_pgtable_has_huge_leaves.patch
mm-pagewalk-introduce-folio_walk_start-folio_walk_end.patch
mm-migrate-convert-do_pages_stat_array-from-follow_page-to-folio_walk.patch
mm-migrate-convert-add_page_for_migration-from-follow_page-to-folio_walk.patch
mm-ksm-convert-get_mergeable_page-from-follow_page-to-folio_walk.patch
mm-ksm-convert-scan_get_next_rmap_item-from-follow_page-to-folio_walk.patch
mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk.patch
s390-uv-convert-gmap_destroy_page-from-follow_page-to-folio_walk.patch
s390-mm-fault-convert-do_secure_storage_access-from-follow_page-to-folio_walk.patch
mm-remove-follow_page.patch
mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch

