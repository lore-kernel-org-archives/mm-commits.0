Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9221FC0FC
	for <mm-commits@vger.kernel.org>; Mon,  5 May 2025 22:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746482638; cv=none; b=Y/RYO+Nhs9djQcFv8J9xdcIOa+GffITUgcOv2cFugGtdOZJKPYRKT+eeD0FtKCnDndimvLk5xHvQEAWoG/U0NJ1itadVod9ifLSdehLZm05UwQNADiSSmwQvKynNV13vJ86dq/n+2wwAfEC2SMq+l9z0D5mSKI8kQhMss380hZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746482638; c=relaxed/simple;
	bh=rJErEEe32pYIsj7+ROhj/j0+0PBrrkLeqwdpIwJL4+A=;
	h=Date:To:From:Subject:Message-Id; b=C/DtgNmUXWzWOcKD4Mz2Y/wXr47104uK3NXLgSEm/lACi10GhU517sVVU25YRywGMpGFntobyDpQEvPv5zRFrDs3Fma2CCqxMFzMuwQNb2F7pKEmsCL87rTiFXYis8rdJk/VzWIhHYRQ0UGGOSOMwEehNMczG522KYxkfmdAXik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KDPs4bRx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KDPs4bRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC78C4CEE4;
	Mon,  5 May 2025 22:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746482637;
	bh=rJErEEe32pYIsj7+ROhj/j0+0PBrrkLeqwdpIwJL4+A=;
	h=Date:To:From:Subject:From;
	b=KDPs4bRxGVtAvnuwCYuBqzKMOpCye7JlfXfit6MRlktj0rgJlY+YGX64sPBQrqwQp
	 9bjSfRNFDa0Gn9fWIdqTiH34eDSwm/tlzz4/fDMHBG7Al+UALHPooX419YkLpzLr85
	 MdCpSBQw9jW99kB7Vvkolzkf0Eu6/Q9XYKZdANpA=
Date: Mon, 05 May 2025 15:03:56 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,fan.ni@samsung.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlbc-__unmap_hugepage_range-comment-cleanup.patch added to mm-unstable branch
Message-Id: <20250505220357.8BC78C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb.c: __unmap_hugepage_range(): comment cleanup
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlbc-__unmap_hugepage_range-comment-cleanup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlbc-__unmap_hugepage_range-comment-cleanup.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/hugetlb.c: __unmap_hugepage_range(): comment cleanup
Date: Mon May  5 02:54:25 PM PDT 2025

Wrap to 80 cols, fix a typo, use regular layout, parenthesize function
identifiers, fix grammar and add braces.

Cc: David Hildenbrand <david@redhat.com>
Cc: Fan Ni <fan.ni@samsung.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlbc-__unmap_hugepage_range-comment-cleanup
+++ a/mm/hugetlb.c
@@ -5969,16 +5969,19 @@ void __unmap_hugepage_range(struct mmu_g
 		if (adjust_reservation) {
 			int rc = vma_needs_reservation(h, vma, address);
 
-			if (rc < 0)
-				/* Pressumably allocate_file_region_entries failed
-				 * to allocate a file_region struct. Clear
-				 * hugetlb_restore_reserve so that global reserve
-				 * count will not be incremented by free_huge_folio.
-				 * Act as if we consumed the reservation.
+			if (rc < 0) {
+				/*
+				 * Presumably allocate_file_region_entries()
+				 * failed to allocate a file_region struct.
+				 * Clear hugetlb_restore_reserve so that the
+				 * global reserve count will not be incremented
+				 * by free_huge_folio().  Act as if we consumed
+				 * the reservation.
 				 */
 				folio_clear_hugetlb_restore_reserve(folio);
-			else if (rc)
+			} else if (rc) {
 				vma_add_reservation(h, vma, address);
+			}
 		}
 
 		tlb_remove_page_size(tlb, folio_page(folio, 0),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86-disable-image-size-check-for-test-builds-fix.patch
x86-disable-image-size-check-for-test-builds-fix-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2.patch
mm-hugetlbc-__unmap_hugepage_range-comment-cleanup.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch
mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-zblock-avoid-failing-the-build-fix.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch
compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch
revert-x86-mm-remove-unused-__set_memory_prot-fix.patch

