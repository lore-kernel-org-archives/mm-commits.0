Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2627178E67
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 22:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b+Znv8un"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E9AC433C7;
	Thu, 21 Dec 2023 22:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703197805;
	bh=AIOmb81t6aU7KfAo+Q6b5yfp0wJzOWfQo4GEt0Cjj0E=;
	h=Date:To:From:Subject:From;
	b=b+Znv8una77pzBYRbYDiRrHuvrvuk7Ma0BXyj8Lcw08nWKVbeOv/+iJJPGsflRn4a
	 qJ+xx6Gn/4g6ke2xSnKJGod6dvCTpdTmSZnEkNsdgB6V2CEgjLKL+Hi+DDa4Xl1CB/
	 O/xVn5Ukr1L3gdlfSj0Le8GCzIOfLV0zGI1Iqrlc=
Date: Thu, 21 Dec 2023 14:30:04 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-stop-referring-to-page_remove_rmap.patch added to mm-unstable branch
Message-Id: <20231221223004.E3E9AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: stop referring to page_remove_rmap()
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-stop-referring-to-page_remove_rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-stop-referring-to-page_remove_rmap.patch

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
Subject: Documentation: stop referring to page_remove_rmap()
Date: Wed, 20 Dec 2023 23:44:55 +0100

Refer to folio_remove_rmap_*() instaed.

Link: https://lkml.kernel.org/r/20231220224504.646757-32-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/transhuge.rst       |    2 +-
 Documentation/mm/unevictable-lru.rst |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/mm/transhuge.rst~documentation-stop-referring-to-page_remove_rmap
+++ a/Documentation/mm/transhuge.rst
@@ -156,7 +156,7 @@ Partial unmap and deferred_split_folio()
 
 Unmapping part of THP (with munmap() or other way) is not going to free
 memory immediately. Instead, we detect that a subpage of THP is not in use
-in page_remove_rmap() and queue the THP for splitting if memory pressure
+in folio_remove_rmap_*() and queue the THP for splitting if memory pressure
 comes. Splitting will free up unused subpages.
 
 Splitting the page right away is not an option due to locking context in
--- a/Documentation/mm/unevictable-lru.rst~documentation-stop-referring-to-page_remove_rmap
+++ a/Documentation/mm/unevictable-lru.rst
@@ -486,7 +486,7 @@ munlock the pages if we're removing the
 Before the unevictable/mlock changes, mlocking did not mark the pages in any
 way, so unmapping them required no processing.
 
-For each PTE (or PMD) being unmapped from a VMA, page_remove_rmap() calls
+For each PTE (or PMD) being unmapped from a VMA, folio_remove_rmap_*() calls
 munlock_vma_folio(), which calls munlock_folio() when the VMA is VM_LOCKED
 (unless it was a PTE mapping of a part of a transparent huge page).
 
@@ -511,7 +511,7 @@ userspace; truncation even unmaps and de
 which had been Copied-On-Write from the file pages now being truncated.
 
 Mlocked pages can be munlocked and deleted in this way: like with munmap(),
-for each PTE (or PMD) being unmapped from a VMA, page_remove_rmap() calls
+for each PTE (or PMD) being unmapped from a VMA, folio_remove_rmap_*() calls
 munlock_vma_folio(), which calls munlock_folio() when the VMA is VM_LOCKED
 (unless it was a PTE mapping of a part of a transparent huge page).
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-rename-hugepage_add-to-hugetlb_add.patch
mm-rmap-introduce-and-use-hugetlb_remove_rmap.patch
mm-rmap-introduce-and-use-hugetlb_add_file_rmap.patch
mm-rmap-introduce-and-use-hugetlb_try_dup_anon_rmap.patch
mm-rmap-introduce-and-use-hugetlb_try_share_anon_rmap.patch
mm-rmap-add-hugetlb-sanity-checks-for-anon-rmap-handling.patch
mm-rmap-convert-folio_add_file_rmap_range-into-folio_add_file_rmap_.patch
mm-memory-page_add_file_rmap-folio_add_file_rmap_.patch
mm-huge_memory-page_add_file_rmap-folio_add_file_rmap_pmd.patch
mm-migrate-page_add_file_rmap-folio_add_file_rmap_pte.patch
mm-userfaultfd-page_add_file_rmap-folio_add_file_rmap_pte.patch
mm-rmap-remove-page_add_file_rmap.patch
mm-rmap-factor-out-adding-folio-mappings-into-__folio_add_rmap.patch
mm-rmap-introduce-folio_add_anon_rmap_.patch
mm-huge_memory-batch-rmap-operations-in-__split_huge_pmd_locked.patch
mm-huge_memory-page_add_anon_rmap-folio_add_anon_rmap_pmd.patch
mm-migrate-page_add_anon_rmap-folio_add_anon_rmap_pte.patch
mm-ksm-page_add_anon_rmap-folio_add_anon_rmap_pte.patch
mm-swapfile-page_add_anon_rmap-folio_add_anon_rmap_pte.patch
mm-memory-page_add_anon_rmap-folio_add_anon_rmap_pte.patch
mm-rmap-remove-page_add_anon_rmap.patch
mm-rmap-remove-rmap_compound.patch
mm-rmap-introduce-folio_remove_rmap_.patch
kernel-events-uprobes-page_remove_rmap-folio_remove_rmap_pte.patch
mm-huge_memory-page_remove_rmap-folio_remove_rmap_pmd.patch
mm-khugepaged-page_remove_rmap-folio_remove_rmap_pte.patch
mm-ksm-page_remove_rmap-folio_remove_rmap_pte.patch
mm-memory-page_remove_rmap-folio_remove_rmap_pte.patch
mm-migrate_device-page_remove_rmap-folio_remove_rmap_pte.patch
mm-rmap-page_remove_rmap-folio_remove_rmap_pte.patch
documentation-stop-referring-to-page_remove_rmap.patch
mm-rmap-remove-page_remove_rmap.patch
mm-rmap-convert-page_dup_file_rmap-to-folio_dup_file_rmap_.patch
mm-rmap-introduce-folio_try_dup_anon_rmap_.patch
mm-huge_memory-page_try_dup_anon_rmap-folio_try_dup_anon_rmap_pmd.patch
mm-memory-page_try_dup_anon_rmap-folio_try_dup_anon_rmap_pte.patch
mm-rmap-remove-page_try_dup_anon_rmap.patch
mm-convert-page_try_share_anon_rmap-to-folio_try_share_anon_rmap_.patch
mm-rmap-rename-compound_mapped-to-entirely_mapped.patch
mm-remove-one-last-reference-to-page_add__rmap.patch

