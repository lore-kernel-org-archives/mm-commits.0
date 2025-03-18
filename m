Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B171A9B4D
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274499; cv=none; b=p2leNCxyOtBhVyvQ+MtXbl6Ub59chP8a2Tq6i/zFYELdYoehWRRLxxLUBNp8dmOa2SXNOZkWjVqSJkcDTdIrdlTUoQo+hyVZ+pScOAHMaOxw6mPlI8AHwBbjfU+ki04yjE8EJt0GBxZSR5sddgHR0jl22p2uQSfPdsfNDHTK6Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274499; c=relaxed/simple;
	bh=1ghwhzWWPZynHyUipmOX0ocrfbY2rRVW723CU1Xnn5k=;
	h=Date:To:From:Subject:Message-Id; b=RH098PQ7iTf3C02mwdHEv4463EK0rHdJW4zPFVuvWD0q48uxjcxtcQctB0RFkT3aUAFF1ERa/yn3A4JuCfLjVsXqW5IEWjnyshF0KxveuqI/c28iNl1bzVohQgFZUXfkBhfyOXBKTDs6lqiozqKqwHhP7W9qdrY3VCjUac3L9SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aiExcAmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aiExcAmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42F4C4CEDD;
	Tue, 18 Mar 2025 05:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274498;
	bh=1ghwhzWWPZynHyUipmOX0ocrfbY2rRVW723CU1Xnn5k=;
	h=Date:To:From:Subject:From;
	b=aiExcAmO/V8EJKZsU0Wa66QNuODsKfTGp0GvUPa/ydAbqzYiG820D64tlu3K6kMrs
	 FopugGaB0PtHjkHKjeXOXMVrdVMjaxUPyF4QI1eMw4jo5jsbJ3QPZbSIVPctcj8QgK
	 rvqZVFrJQSYsabzIiDUTSihRVS5cKVbMdja7bVWE=
Date: Mon, 17 Mar 2025 22:08:18 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,balbirs@nvidia.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-enhance-insert_page_into_pte_locked-to-create-writable-mappings.patch removed from -mm tree
Message-Id: <20250318050818.A42F4C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: enhance insert_page_into_pte_locked() to create writable mappings
has been removed from the -mm tree.  Its filename was
     mm-memory-enhance-insert_page_into_pte_locked-to-create-writable-mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/memory: enhance insert_page_into_pte_locked() to create writable mappings
Date: Fri, 28 Feb 2025 14:31:07 +1100

In preparation for using insert_page() for DAX, enhance
insert_page_into_pte_locked() to handle establishing writable mappings. 
Recall that DAX returns VM_FAULT_NOPAGE after installing a PTE which
bypasses the typical set_pte_range() in finish_fault.

Link: https://lkml.kernel.org/r/f7354fd9c2f5d0c2fa321733039f9f87e791023e.1740713401.git-series.apopple@nvidia.com
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
Cc: linmiaohe <linmiaohe@huawei.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michael "Camp Drill Sergeant" Ellerman <mpe@ellerman.id.au>
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
@@ -2145,19 +2145,39 @@ static int validate_page_before_insert(s
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
@@ -2166,7 +2186,7 @@ static int insert_page_into_pte_locked(s
 }
 
 static int insert_page(struct vm_area_struct *vma, unsigned long addr,
-			struct page *page, pgprot_t prot)
+			struct page *page, pgprot_t prot, bool mkwrite)
 {
 	int retval;
 	pte_t *pte;
@@ -2179,7 +2199,8 @@ static int insert_page(struct vm_area_st
 	pte = get_locked_pte(vma->vm_mm, addr, &ptl);
 	if (!pte)
 		goto out;
-	retval = insert_page_into_pte_locked(vma, pte, addr, page, prot);
+	retval = insert_page_into_pte_locked(vma, pte, addr, page, prot,
+					mkwrite);
 	pte_unmap_unlock(pte, ptl);
 out:
 	return retval;
@@ -2193,7 +2214,7 @@ static int insert_page_in_batch_locked(s
 	err = validate_page_before_insert(vma, page);
 	if (err)
 		return err;
-	return insert_page_into_pte_locked(vma, pte, addr, page, prot);
+	return insert_page_into_pte_locked(vma, pte, addr, page, prot, false);
 }
 
 /* insert_pages() amortizes the cost of spinlock operations
@@ -2329,7 +2350,7 @@ int vm_insert_page(struct vm_area_struct
 		BUG_ON(vma->vm_flags & VM_PFNMAP);
 		vm_flags_set(vma, VM_MIXEDMAP);
 	}
-	return insert_page(vma, addr, page, vma->vm_page_prot);
+	return insert_page(vma, addr, page, vma->vm_page_prot, false);
 }
 EXPORT_SYMBOL(vm_insert_page);
 
@@ -2609,7 +2630,7 @@ static vm_fault_t __vm_insert_mixed(stru
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


