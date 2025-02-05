Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DD925A65D
	for <mm-commits@vger.kernel.org>; Wed,  5 Feb 2025 02:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738721793; cv=none; b=refPX1jOLJM4pOQcVFkknfKHVCminkLWvx15oiEZsyfCfsi5W+4ImJHs3zJf4mcCYr97UPw1IVimImgZQ/E8o19sfjRj8L7Q9Nt9YwC5A3c1CX5TFXr4OrZ/45J+nyiv3fUpsRfHyjz429jsCHQBO/h+qY4VpX6z1jrO+Iin5hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738721793; c=relaxed/simple;
	bh=i9Es4vB/O+jESJO1+TKJtRCAj/IkcKGPNVuLmZNKsbY=;
	h=Date:To:From:Subject:Message-Id; b=quCXY+azGvNe7Ww0PVHS232/LTR4aL1O49LEdgpSgYmuNsH45AUozGGbT9ZCAHa+PsfS50dyCMEzpCWvz5zdGccOJs+0lLMGA2Lt57XJvw0Xt2Bnfo5x3zFhXBjd0o4OgxdqCoZuVEwgSRoIpF7kPLO5bf2OnMzDoVH3izc3mUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s8QnDWSB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s8QnDWSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78716C4CEDF;
	Wed,  5 Feb 2025 02:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738721792;
	bh=i9Es4vB/O+jESJO1+TKJtRCAj/IkcKGPNVuLmZNKsbY=;
	h=Date:To:From:Subject:From;
	b=s8QnDWSBwmVvrrFFYvpmFgzJ85GrC67bgulkZs94N8SZwkwlKmQsvx6kMoJUT/EDl
	 Ow4Y8AYVyc5fevnGwbOePzi04od4tfUEBc9iQl00MMRBUw3yu3Or9bi1TJKFsqpRs7
	 Zqpjkat1LRHUlHGBWZhNuWhXcMowUQ8OPHhWn6kw=
Date: Tue, 04 Feb 2025 18:16:31 -0800
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-add-vmf_insert_page_mkwrite.patch added to mm-unstable branch
Message-Id: <20250205021632.78716C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: add vmf_insert_page_mkwrite()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-add-vmf_insert_page_mkwrite.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-add-vmf_insert_page_mkwrite.patch

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
Subject: mm/memory: add vmf_insert_page_mkwrite()
Date: Wed, 5 Feb 2025 09:48:10 +1100

Currently to map a DAX page the DAX driver calls vmf_insert_pfn.  This
creates a special devmap PTE entry for the pfn but does not take a
reference on the underlying struct page for the mapping.  This is because
DAX page refcounts are treated specially, as indicated by the presence of
a devmap entry.

To allow DAX page refcounts to be managed the same as normal page
refcounts introduce vmf_insert_page_mkwrite().  This will take a reference
on the underlying page much the same as vmf_insert_page, except it also
permits upgrading an existing mapping to be writable if
requested/possible.

Link: https://lkml.kernel.org/r/e98b7e6bed4c1c63feac7b907439168388ecc9fd.1738709036.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Asahi Lina <lina@asahilina.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Dan Wiliams <dan.j.williams@intel.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
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
Cc: Mattew Wilcox <willy@infradead.org>
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

 include/linux/mm.h |    2 ++
 mm/memory.c        |   21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

--- a/include/linux/mm.h~mm-memory-add-vmf_insert_page_mkwrite
+++ a/include/linux/mm.h
@@ -3544,6 +3544,8 @@ int vm_map_pages(struct vm_area_struct *
 				unsigned long num);
 int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
 				unsigned long num);
+vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
+			bool write);
 vm_fault_t vmf_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
 vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
--- a/mm/memory.c~mm-memory-add-vmf_insert_page_mkwrite
+++ a/mm/memory.c
@@ -2624,6 +2624,27 @@ static vm_fault_t __vm_insert_mixed(stru
 	return VM_FAULT_NOPAGE;
 }
 
+vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
+			bool write)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	pgprot_t pgprot = vma->vm_page_prot;
+	unsigned long addr = vmf->address;
+	int err;
+
+	if (addr < vma->vm_start || addr >= vma->vm_end)
+		return VM_FAULT_SIGBUS;
+
+	err = insert_page(vma, addr, page, pgprot, write);
+	if (err == -ENOMEM)
+		return VM_FAULT_OOM;
+	if (err < 0 && err != -EBUSY)
+		return VM_FAULT_SIGBUS;
+
+	return VM_FAULT_NOPAGE;
+}
+EXPORT_SYMBOL_GPL(vmf_insert_page_mkwrite);
+
 vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 		pfn_t pfn)
 {
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
rmap-add-support-for-pud-sized-mappings-to-rmap.patch
huge_memory-add-vmf_insert_folio_pud.patch
huge_memory-add-vmf_insert_folio_pmd.patch
mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch
fs-dax-properly-refcount-fs-dax-pages.patch
device-dax-properly-refcount-device-dax-pages-when-mapping.patch

