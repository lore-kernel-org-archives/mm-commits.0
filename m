Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA8F12E46
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cdq4NUpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCC6C433C8;
	Fri, 29 Dec 2023 19:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879265;
	bh=8sPbemJxpODKgKvrf+q+1aCVdZIxBTQarCl5YxRiyms=;
	h=Date:To:From:Subject:From;
	b=cdq4NUpGgm0XhmsxFS12032BhgmsSG6Nx3a81sccihsx5BGXXyeHI7RVYrJCNy0P1
	 N32/0TSPIke4/IDQG+FEdfQfuL8JKLm2W8FWDCnlUoj37hDPDQ3Ml1BO39r03Rae2r
	 pH1k4QlHWLgJbbDQYvTADjhGD9PiGWNhWvQ5IsI4=
Date: Fri, 29 Dec 2023 11:47:45 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,oliver.sang@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-convert-ksm_might_need_to_copy-to-work-on-folios-fix-fix.patch removed from -mm tree
Message-Id: <20231229194745.CCCC6C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Fixup: mm: convert ksm_might_need_to_copy() to work on folios
has been removed from the -mm tree.  Its filename was
     mm-convert-ksm_might_need_to_copy-to-work-on-folios-fix-fix.patch

This patch was dropped because it was folded into mm-convert-ksm_might_need_to_copy-to-work-on-folios.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: Fixup: mm: convert ksm_might_need_to_copy() to work on folios
Date: Thu, 21 Dec 2023 23:04:30 +0100

We must only adjust the page if the folio changed. Otherwise, if we
had a large folio in the swapcache and the folio didn't change, we'd
suddenly change the page to-be-mapped.

Link: https://lkml.kernel.org/r/6a8f2110-fa91-4c10-9eae-88315309a6e3@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202312192319.fa8f5709-oliver.sang@intel.com
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Tested-by: Oliver Sang <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-convert-ksm_might_need_to_copy-to-work-on-folios-fix-fix
+++ a/mm/memory.c
@@ -3952,7 +3952,8 @@ vm_fault_t do_swap_page(struct vm_fault
 			folio = swapcache;
 			goto out_page;
 		}
-		page = folio_page(folio, 0);
+		if (folio != swapcache)
+			page = folio_page(folio, 0);
 
 		/*
 		 * If we want to map a page that's in the swapcache writable, we
_

Patches currently in -mm which might be from david@redhat.com are

mm-convert-ksm_might_need_to_copy-to-work-on-folios.patch
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

