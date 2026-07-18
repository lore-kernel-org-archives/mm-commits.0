Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E4E280331
	for <mm-commits@vger.kernel.org>; Sat, 18 Jul 2026 02:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784342890; cv=none; b=PakQQ3h9zupk7s/hLLLqJ3DLbTzA8m08vBzSigkty88jPDGFIe3RBig+C9dG3E832+UaAwwfcRIpBrOB/OXzPYcRLGBHkprtCtY7PgwT+QjeObQwCh0AgyCPbtaXdiYfS0RRt8ezn958c9+hStgV8Jf0Mt5NSEgfNpbRNsn5htk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784342890; c=relaxed/simple;
	bh=3qsxUlSpYICQZZSsE/2hmJS2CKbjCtUx6QjUIiEvVv4=;
	h=Date:To:From:Subject:Message-Id; b=lFLHHF0SGMqm/+TyAukaKjRo7+zh/M3DAL0HgtMVs+a2IDjuhe+eoBv0Pp7IRVw4S0fBKL827JnFXBelgWasmqqbktXMpNyM3UCgk8UBr/hIuBMwqOrHHQQi+V2WdStsoPf4miP2AowdSTxY/tJFj/H43X+5xyQ20BI20fDL2So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ut2536R/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ut2536R/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C831F000E9;
	Sat, 18 Jul 2026 02:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784342888;
	bh=J4xAmHD5aHNjfiPST8UvAlDNXptqYW9dE0NYTOid4xY=;
	h=Date:To:From:Subject;
	b=Ut2536R/fjT/8u1iW9H5JooIjbohATY3Ba44PBVNtGPgutm2u4Mk1Cr5zAU8Wr9tc
	 mlZpgYTu5zvMhRDtDyimP5jTC94ecp20/gn+qxrFxO8ejTViTiULOkKsSsH+wJ6Jbr
	 FZdf0N+pEkpiOofVK4x0QEHJiZB8srNfkB6HZ+DI=
Date: Fri, 17 Jul 2026 19:48:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-fold-split_folio_to_list_to_order-into-split_folio_to_order.patch added to mm-new branch
Message-Id: <20260718024808.24C831F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: fold split_folio_to_list_to_order() into split_folio_to_order()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-fold-split_folio_to_list_to_order-into-split_folio_to_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-fold-split_folio_to_list_to_order-into-split_folio_to_order.patch

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
Subject: mm/huge_memory: fold split_folio_to_list_to_order() into split_folio_to_order()
Date: Thu, 16 Jul 2026 11:03:45 +0100

split_folio_to_list_to_order() had no direct callers; its only user was
split_folio_to_order(), which always passed a NULL list.  Fold it into
split_folio_to_order() and call split_huge_page_to_list_to_order()
directly.

No functional change.

Link: https://lore.kernel.org/20260716100345.473473-3-kirill@shutemov.name
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

 include/linux/huge_mm.h |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-fold-split_folio_to_list_to_order-into-split_folio_to_order
+++ a/include/linux/huge_mm.h
@@ -823,15 +823,9 @@ static inline bool is_pmd_order(unsigned
 	return order == HPAGE_PMD_ORDER;
 }
 
-static inline int split_folio_to_list_to_order(struct folio *folio,
-		struct list_head *list, int new_order)
-{
-	return split_huge_page_to_list_to_order(&folio->page, list, new_order);
-}
-
 static inline int split_folio_to_order(struct folio *folio, int new_order)
 {
-	return split_folio_to_list_to_order(folio, NULL, new_order);
+	return split_huge_page_to_list_to_order(&folio->page, NULL, new_order);
 }
 
 /**
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

