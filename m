Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C00A47F4D
	for <mm-commits@vger.kernel.org>; Tue,  6 Aug 2024 19:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722972052; cv=none; b=FhKfhlGENTk/I0ej3j3HC3osznpcXpIyVl0+Ktg/lsx8kgNTD4iR3+GDo+pobfHgU7YciZigYin1cTp+1EfE0oDiI5h3jzLOSLVJC27as9qVZOPDdMyj0BKJqhMXyJ0ZjRBnpxf541OpCtPYC1oHtHuJ3OV0/dXIwLXNzBMBk80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722972052; c=relaxed/simple;
	bh=eQl8G3m1tiUo9UrUEOMG7dc/YJnBm3KYqfmcXUthDdY=;
	h=Date:To:From:Subject:Message-Id; b=UZ9M4PpHCKX45QPnMDqPvJXPv+ypovT+1ZTDztLFEn/y+jpx6rjSnfXKObRwUJZ7GsoVkuk+MJ4YCxzcygT7qGZCIdlwNpr/fyBMfIujEEM+dANkUdz2xKOIgXRH0Cu+aqQRObsWCJNV1Fk2hGxriH3s1qyh6mPlCwptWbyQPEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m4NnZSTe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m4NnZSTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE86C32786;
	Tue,  6 Aug 2024 19:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722972052;
	bh=eQl8G3m1tiUo9UrUEOMG7dc/YJnBm3KYqfmcXUthDdY=;
	h=Date:To:From:Subject:From;
	b=m4NnZSTee8ZHIgPHu/5NfMIGjPVDg2Yfz8naMU+arg0gYwMIOObcWJUxRKfxTzIRV
	 c5bK6LscgVZ+8wn5FRF8/MgR/qvp52gS+1ZzURYN004Fotna1s1NhcIWEaqYavBwUl
	 z7C1KXhFYtzk0O2Cp4GDMgz7DWjs6mQJFhuz9JMs=
Date: Tue, 06 Aug 2024 12:20:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk-fix.patch added to mm-unstable branch
Message-Id: <20240806192052.0BE86C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk-fix.patch

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
Subject: mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk-fix
Date: Tue, 6 Aug 2024 12:08:17 +0200

teach can_split_folio() that we are not holding an additional reference

Link: https://lkml.kernel.org/r/c75d1c6c-8ea6-424f-853c-1ccda6c77ba2@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    4 ++--
 mm/huge_memory.c        |    9 +++++----
 mm/vmscan.c             |    2 +-
 3 files changed, 8 insertions(+), 7 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk-fix
+++ a/include/linux/huge_mm.h
@@ -314,7 +314,7 @@ unsigned long thp_get_unmapped_area_vmfl
 		unsigned long len, unsigned long pgoff, unsigned long flags,
 		vm_flags_t vm_flags);
 
-bool can_split_folio(struct folio *folio, int *pextra_pins);
+bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
 int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order);
 static inline int split_huge_page(struct page *page)
@@ -470,7 +470,7 @@ thp_get_unmapped_area_vmflags(struct fil
 }
 
 static inline bool
-can_split_folio(struct folio *folio, int *pextra_pins)
+can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
 {
 	return false;
 }
--- a/mm/huge_memory.c~mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk-fix
+++ a/mm/huge_memory.c
@@ -3021,7 +3021,7 @@ static void __split_huge_page(struct pag
 }
 
 /* Racy check whether the huge page can be split */
-bool can_split_folio(struct folio *folio, int *pextra_pins)
+bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
 {
 	int extra_pins;
 
@@ -3033,7 +3033,8 @@ bool can_split_folio(struct folio *folio
 		extra_pins = folio_nr_pages(folio);
 	if (pextra_pins)
 		*pextra_pins = extra_pins;
-	return folio_mapcount(folio) == folio_ref_count(folio) - extra_pins - 1;
+	return folio_mapcount(folio) == folio_ref_count(folio) - extra_pins -
+					caller_pins;
 }
 
 /*
@@ -3201,7 +3202,7 @@ int split_huge_page_to_list_to_order(str
 	 * Racy check if we can split the page, before unmap_folio() will
 	 * split PMDs
 	 */
-	if (!can_split_folio(folio, &extra_pins)) {
+	if (!can_split_folio(folio, 1, &extra_pins)) {
 		ret = -EAGAIN;
 		goto out_unlock;
 	}
@@ -3537,7 +3538,7 @@ static int split_huge_pages_pid(int pid,
 		 * can be split or not. So skip the check here.
 		 */
 		if (!folio_test_private(folio) &&
-		    !can_split_folio(folio, NULL))
+		    !can_split_folio(folio, 0, NULL))
 			goto next;
 
 		if (!folio_trylock(folio))
--- a/mm/vmscan.c~mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk-fix
+++ a/mm/vmscan.c
@@ -1227,7 +1227,7 @@ retry:
 					goto keep_locked;
 				if (folio_test_large(folio)) {
 					/* cannot split folio, skip it */
-					if (!can_split_folio(folio, NULL))
+					if (!can_split_folio(folio, 1, NULL))
 						goto activate_locked;
 					/*
 					 * Split partially mapped folios right away.
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
mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk-fix.patch
s390-uv-convert-gmap_destroy_page-from-follow_page-to-folio_walk.patch
s390-mm-fault-convert-do_secure_storage_access-from-follow_page-to-folio_walk.patch
mm-remove-follow_page.patch
mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch

