Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC1979C0
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725246770; cv=none; b=f/uVBQcOZOpcfDHY6Kvists6IDuAx4VAlJ+rHr0fFAZ33MP0ryEXygkC7SxytbeSSENkp+EKd1wEcObRANdmaXL8OLPAEWYypV4wkYq5QQY1qWLgvpHmJ7a/pFAa0bSftZrrOudA0jl8CK+1Ae5tK70HdbKkOHqeJLthKGuSf9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725246770; c=relaxed/simple;
	bh=GHB1UVGu1g8YB6SYjVlVuMzlbkqjSyif6T7ujgwxBnc=;
	h=Date:To:From:Subject:Message-Id; b=cUYjk+O5MtXbEqossf8C2r2VJr5ZXpXafP7Ku4BzKo31HnZbfdZfSXzBhXkx7mFFjcE7fEmhvBqCgMotaOWWgfnmu6Kb31yfM/Pc3Rjvdk2vAB7DUjqOC6trzDKg8ah+X3ZjMYTuiH3FIdKJms6CSQzMml+UY42s/aopyohGm34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D0rZLfpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D0rZLfpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6359C4CEC3;
	Mon,  2 Sep 2024 03:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725246769;
	bh=GHB1UVGu1g8YB6SYjVlVuMzlbkqjSyif6T7ujgwxBnc=;
	h=Date:To:From:Subject:From;
	b=D0rZLfpDVGKI/WT0qoWENml7zbIZd7W2mp5XHCd2r+KWvC1VL3XjsG369EG/A3Yo0
	 GHVf3UDZ8VN8DNR608Ks45dOJ4pMvldhtA9ttfFtwn/zq3zNSoGDlZj7snNFX9cDkY
	 B7bK41AO1Oj5agDOr4tja16G2Ck9uu3mGy8Pxyms=
Date: Sun, 01 Sep 2024 20:12:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,svens@linux.ibm.com,ryan.roberts@arm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk-fix.patch removed from -mm tree
Message-Id: <20240902031249.D6359C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk-fix
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk-fix.patch

This patch was dropped because it was folded into mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk.patch

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
@@ -3018,7 +3018,7 @@ static void __split_huge_page(struct pag
 }
 
 /* Racy check whether the huge page can be split */
-bool can_split_folio(struct folio *folio, int *pextra_pins)
+bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
 {
 	int extra_pins;
 
@@ -3030,7 +3030,8 @@ bool can_split_folio(struct folio *folio
 		extra_pins = folio_nr_pages(folio);
 	if (pextra_pins)
 		*pextra_pins = extra_pins;
-	return folio_mapcount(folio) == folio_ref_count(folio) - extra_pins - 1;
+	return folio_mapcount(folio) == folio_ref_count(folio) - extra_pins -
+					caller_pins;
 }
 
 /*
@@ -3198,7 +3199,7 @@ int split_huge_page_to_list_to_order(str
 	 * Racy check if we can split the page, before unmap_folio() will
 	 * split PMDs
 	 */
-	if (!can_split_folio(folio, &extra_pins)) {
+	if (!can_split_folio(folio, 1, &extra_pins)) {
 		ret = -EAGAIN;
 		goto out_unlock;
 	}
@@ -3534,7 +3535,7 @@ static int split_huge_pages_pid(int pid,
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
s390-uv-convert-gmap_destroy_page-from-follow_page-to-folio_walk.patch
s390-mm-fault-convert-do_secure_storage_access-from-follow_page-to-folio_walk.patch
mm-remove-follow_page.patch
mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch
mm-rmap-minimize-folio-_nr_pages_mapped-updates-when-batching-pte-unmapping.patch
mm-rmap-use-folio-_mapcount-for-small-folios.patch
mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch
selftests-mm-fix-charge_reserved_hugetlbsh-test.patch

