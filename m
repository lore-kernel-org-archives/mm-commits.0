Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5104A22D9EB
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597159; cv=none; b=nDX5rOk51fmRYWRCbGEwe96e0WPZs7p2nxkadl9VdFGdoTheHTDM/VBkh1PN2+deZARknIsLK0eZvhqcQrKFg2q6C9Q5aPwv2Wz8eTeg2vIsr57k4qEytdhMOPyU59guTsIGy7k/tfSWXLWxxWLMrs1PhrzNyjcqm9+RxLftxgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597159; c=relaxed/simple;
	bh=/HgA2Cz6vU2YtuI5Z3zJn3NtSdM9c7V0TdhzX9Q0pkc=;
	h=Date:To:From:Subject:Message-Id; b=BhzqRvolwKJ4YqUJm+UptgGmiTXs+A4IuOB950OJ9W0t9OzcqhQKe15yk9Ep1CULRWFtmRn9YjZJjwWrYDFcEJBCDfVFzMzR1TeBJX1sdsuyhko6Jrj73Nrz88ui/UeGy4ds0uSLjmvcYHadfhxrwmc6sMsqgAq1h/x6FbWWPPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Th81CenD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Th81CenD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBE7C4CEF0;
	Tue, 23 Sep 2025 03:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597158;
	bh=/HgA2Cz6vU2YtuI5Z3zJn3NtSdM9c7V0TdhzX9Q0pkc=;
	h=Date:To:From:Subject:From;
	b=Th81CenDAZvZw/mDtIz05Odl7YCCzM2aGPWscFSEFndXgIXqljGqJtMPLVVBOO11B
	 10zqL5Ol2KsYJxDxyt66G+7v1HqmynqdURyN0kI/H0shxaog4x9yZJN9HDwUBw950/
	 V1E82V3LUEyr9z6Vz2JwhxAZlbnVngZy1qrQqM5Y=
Date: Mon, 22 Sep 2025 20:12:38 -0700
To: mm-commits@vger.kernel.org,jgg@nvidia.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-abstract-io_remap_pfn_range-based-on-pfn-fix.patch removed from -mm tree
Message-Id: <20250923031238.BBBE7C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: io_remap_pfn_range_pfn fixup
has been removed from the -mm tree.  Its filename was
     mm-abstract-io_remap_pfn_range-based-on-pfn-fix.patch

This patch was dropped because it was folded into mm-abstract-io_remap_pfn_range-based-on-pfn.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: io_remap_pfn_range_pfn fixup
Date: Thu, 18 Sep 2025 07:41:37 +0100

Link: https://lkml.kernel.org/r/96e4a163-a791-4b08-a006-bdd7ebbecaf9@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/include/asm/pgtable.h |    2 --
 include/linux/mm.h              |   15 ++-------------
 2 files changed, 2 insertions(+), 15 deletions(-)

--- a/arch/csky/include/asm/pgtable.h~mm-abstract-io_remap_pfn_range-based-on-pfn-fix
+++ a/arch/csky/include/asm/pgtable.h
@@ -263,6 +263,4 @@ void update_mmu_cache_range(struct vm_fa
 #define update_mmu_cache(vma, addr, ptep) \
 	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
 
-#define io_remap_pfn_range_pfn(pfn, size) (pfn)
-
 #endif /* __ASM_CSKY_PGTABLE_H */
--- a/include/linux/mm.h~mm-abstract-io_remap_pfn_range-based-on-pfn-fix
+++ a/include/linux/mm.h
@@ -3672,23 +3672,12 @@ static inline vm_fault_t vmf_insert_page
 	return VM_FAULT_NOPAGE;
 }
 
-#ifdef io_remap_pfn_range_pfn
-static inline unsigned long io_remap_pfn_range_prot(pgprot_t prot)
-{
-	/* We do not decrypt if arch customises PFN. */
-	return prot;
-}
-#else
+#ifndef io_remap_pfn_range_pfn
 static inline unsigned long io_remap_pfn_range_pfn(unsigned long pfn,
 		unsigned long size)
 {
 	return pfn;
 }
-
-static inline pgprot_t io_remap_pfn_range_prot(pgprot_t prot)
-{
-	return pgprot_decrypted(prot);
-}
 #endif
 
 static inline int io_remap_pfn_range(struct vm_area_struct *vma,
@@ -3696,7 +3685,7 @@ static inline int io_remap_pfn_range(str
 				     unsigned long size, pgprot_t orig_prot)
 {
 	const unsigned long pfn = io_remap_pfn_range_pfn(orig_pfn, size);
-	const pgprot_t prot = io_remap_pfn_range_prot(orig_prot);
+	const pgprot_t prot = pgprot_decrypted(orig_prot);
 
 	return remap_pfn_range(vma, addr, pfn, size, prot);
 }
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-specify-separate-file-and-vm_file-params-in-vm_area_desc.patch
mm-do-not-assume-file-==-vma-vm_file-in-compat_vma_mmap_prepare.patch
mm-shmem-update-shmem-to-use-mmap_prepare.patch
device-dax-update-devdax-to-use-mmap_prepare.patch
mm-add-vma_desc_size-vma_desc_pages-helpers.patch
relay-update-relay-to-use-mmap_prepare.patch
mm-vma-rename-__mmap_prepare-function-to-avoid-confusion.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete.patch
mm-abstract-io_remap_pfn_range-based-on-pfn.patch
mm-introduce-io_remap_pfn_range_.patch
mm-introduce-io_remap_pfn_range_-fix.patch
mm-add-ability-to-take-further-action-in-vm_area_desc.patch
mm-add-ability-to-take-further-action-in-vm_area_desc-fix.patch
doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch
mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch
mm-add-shmem_zero_setup_desc.patch
mm-update-mem-char-driver-to-use-mmap_prepare.patch
mm-update-resctl-to-use-mmap_prepare.patch
mm-oom_killc-fix-inverted-check.patch

