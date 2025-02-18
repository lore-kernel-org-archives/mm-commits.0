Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20213C1F
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 04:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739854086; cv=none; b=BxUe8IMzlcn1hE5H9WFACtLhmXqbiQ0ap7ojp0onyhibTPTMIsPQB3a/oqdz3EG02Rrxj//3Uy3i5Crt0h8Coph1Y22OGt8VkzwO9AiStkibUvj5h5Q786bWDbLxkGQwacaZsMAhURx8zn1GzAV1HpnNfDHVYs6hoqysUZP9P04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739854086; c=relaxed/simple;
	bh=dwTthdnU0StO7u98VptzcttTbDALR2L0zV1cEm78nu0=;
	h=Date:To:From:Subject:Message-Id; b=XopBDPocuwR7tLAEWCUw5IiaJrkSjKei9e9PeDQwiGA4KTTmzWUYoXgcasdXXvjwQSjDJzUNMsbMIPs4te1GfxctdJoVpVIuj+t3ym8ee++aGRvNGbahsWTv6GvHRN9ZKe2tmL7ohBAB2LNVYoia6ET4EzCcFvEKbtwbty0XJGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=duH+Q7/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="duH+Q7/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8BCC4CEE2;
	Tue, 18 Feb 2025 04:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739854086;
	bh=dwTthdnU0StO7u98VptzcttTbDALR2L0zV1cEm78nu0=;
	h=Date:To:From:Subject:From;
	b=duH+Q7/eXsQoGMnWODuilKlbcTPlyO30qhyxUkJuGKYYkBCoatdGM6m/S7GrPumaX
	 3C8BzB4Sl2T+cNpt3YX7hd4kOTVbCOf+TFkwZsT67sU+yh1DcjVj1j1tzX5lCGqli/
	 CRSxzJQbHdnxm1Zzn6m30bR+meoOby+SdhMzWQaE=
Date: Mon, 17 Feb 2025 20:48:05 -0800
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,balbirs@nvidia.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-enhance-insert_page_into_pte_locked-to-create-writable-mappings.patch added to mm-unstable branch
Message-Id: <20250218044806.2F8BCC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: enhance insert_page_into_pte_locked() to create writable mappings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-enhance-insert_page_into_pte_locked-to-create-writable-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-enhance-insert_page_into_pte_locked-to-create-writable-mappings.patch

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
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/memory: enhance insert_page_into_pte_locked() to create writable mappings
Date: Tue, 18 Feb 2025 14:55:28 +1100

In preparation for using insert_page() for DAX, enhance
insert_page_into_pte_locked() to handle establishing writable mappings. 
Recall that DAX returns VM_FAULT_NOPAGE after installing a PTE which
bypasses the typical set_pte_range() in finish_fault.

Link: https://lkml.kernel.org/r/ee748e555fb0dc190994a0fd59a57b9c43a17dc9.1739850794.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Asahi Lina <lina@asahilina.net>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

--- a/mm/memory.c~mm-memory-enhance-insert_page_into_pte_locked-to-create-writable-mappings
+++ a/mm/memory.c
@@ -2126,19 +2126,39 @@ static int validate_page_before_insert(s
 }
 
 static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
-			unsigned long addr, struct page *page, pgprot_t prot)
+				unsigned long addr, struct page *page,
+				pgprot_t prot, bool mkwrite)
 {
 	struct folio *folio = page_folio(page);
-	pte_t pteval;
+	pte_t pteval = ptep_get(pte);
+
+	if (!pte_none(pteval)) {
+		if (!mkwrite)
+			return -EBUSY;
+
+		/* see insert_pfn(). */
+		if (pte_pfn(pteval) != page_to_pfn(page)) {
+			WARN_ON_ONCE(!is_zero_pfn(pte_pfn(pteval)));
+			return -EFAULT;
+		}
+		pteval = maybe_mkwrite(pteval, vma);
+		pteval = pte_mkyoung(pteval);
+		if (ptep_set_access_flags(vma, addr, pte, pteval, 1))
+			update_mmu_cache(vma, addr, pte);
+		return 0;
+	}
 
-	if (!pte_none(ptep_get(pte)))
-		return -EBUSY;
 	/* Ok, finally just insert the thing.. */
 	pteval = mk_pte(page, prot);
 	if (unlikely(is_zero_folio(folio))) {
 		pteval = pte_mkspecial(pteval);
 	} else {
 		folio_get(folio);
+		pteval = mk_pte(page, prot);
+		if (mkwrite) {
+			pteval = pte_mkyoung(pteval);
+			pteval = maybe_mkwrite(pte_mkdirty(pteval), vma);
+		}
 		inc_mm_counter(vma->vm_mm, mm_counter_file(folio));
 		folio_add_file_rmap_pte(folio, page, vma);
 	}
@@ -2147,7 +2167,7 @@ static int insert_page_into_pte_locked(s
 }
 
 static int insert_page(struct vm_area_struct *vma, unsigned long addr,
-			struct page *page, pgprot_t prot)
+			struct page *page, pgprot_t prot, bool mkwrite)
 {
 	int retval;
 	pte_t *pte;
@@ -2160,7 +2180,8 @@ static int insert_page(struct vm_area_st
 	pte = get_locked_pte(vma->vm_mm, addr, &ptl);
 	if (!pte)
 		goto out;
-	retval = insert_page_into_pte_locked(vma, pte, addr, page, prot);
+	retval = insert_page_into_pte_locked(vma, pte, addr, page, prot,
+					mkwrite);
 	pte_unmap_unlock(pte, ptl);
 out:
 	return retval;
@@ -2174,7 +2195,7 @@ static int insert_page_in_batch_locked(s
 	err = validate_page_before_insert(vma, page);
 	if (err)
 		return err;
-	return insert_page_into_pte_locked(vma, pte, addr, page, prot);
+	return insert_page_into_pte_locked(vma, pte, addr, page, prot, false);
 }
 
 /* insert_pages() amortizes the cost of spinlock operations
@@ -2310,7 +2331,7 @@ int vm_insert_page(struct vm_area_struct
 		BUG_ON(vma->vm_flags & VM_PFNMAP);
 		vm_flags_set(vma, VM_MIXEDMAP);
 	}
-	return insert_page(vma, addr, page, vma->vm_page_prot);
+	return insert_page(vma, addr, page, vma->vm_page_prot, false);
 }
 EXPORT_SYMBOL(vm_insert_page);
 
@@ -2590,7 +2611,7 @@ static vm_fault_t __vm_insert_mixed(stru
 		 * result in pfn_t_has_page() == false.
 		 */
 		page = pfn_to_page(pfn_t_to_pfn(pfn));
-		err = insert_page(vma, addr, page, pgprot);
+		err = insert_page(vma, addr, page, pgprot, mkwrite);
 	} else {
 		return insert_pfn(vma, addr, pfn, pgprot, mkwrite);
 	}
_

Patches currently in -mm which might be from apopple@nvidia.com are

fuse-fix-dax-truncate-punch_hole-fault-path.patch
fs-dax-return-unmapped-busy-pages-from-dax_layout_busy_page_range.patch
fs-dax-dont-skip-locked-entries-when-scanning-entries.patch
fs-dax-refactor-wait-for-dax-idle-page.patch
fs-dax-create-a-common-implementation-to-break-dax-layouts.patch
fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts.patch
fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount.patch
fs-dax-remove-page_mapping_dax_shared-mapping-flag.patch
mm-gup-remove-redundant-check-for-pci-p2pdma-page.patch
mm-mm_init-move-p2pdma-page-refcount-initialisation-to-p2pdma.patch
mm-allow-compound-zone-device-pages.patch
mm-memory-enhance-insert_page_into_pte_locked-to-create-writable-mappings.patch
mm-memory-add-vmf_insert_page_mkwrite.patch
mm-rmap-add-support-for-pud-sized-mappings-to-rmap.patch
mm-huge_memory-add-vmf_insert_folio_pud.patch
mm-huge_memory-add-vmf_insert_folio_pmd.patch
mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch
fs-dax-properly-refcount-fs-dax-pages.patch
device-dax-properly-refcount-device-dax-pages-when-mapping.patch

