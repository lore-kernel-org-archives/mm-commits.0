Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3B83C1F
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 04:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739854088; cv=none; b=owjK7g67reYbPmGwoFYn6xxip3uE+6Y/JQ8gWX7cif/lcUOvrihtGOM0JbRtaf4j8lAxlxKfhYB70hZtkszhmDWz2eJeODphOwMcGVpuED59NADGFrGyZshcV1ndXCvRaWlNpvPhtU6HH1w77R4Kp5WIDNvU76vPALG0+tAbJSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739854088; c=relaxed/simple;
	bh=sA3GvluP9kU7+vGp2qTWPYOk4vNqHO+tvqT1Pro9dgY=;
	h=Date:To:From:Subject:Message-Id; b=oJ8qKHnsZDcOIphWewoRDr3I+iTQcDVKyAff+ZbvlqxGw7AM1039KzsJThaxvdAuu0ep4ca2atKSkFAGEnGImKvTo/syvKMqcwYbCMAaI0kC4vkYH5DJAHIsBzK/9Ou2/bQ6R6P0tiTebUUi0BlWSYUVxcUh5RJNA7sNAVL+CLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p/m6Wv+p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p/m6Wv+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BDC3C4CEE2;
	Tue, 18 Feb 2025 04:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739854088;
	bh=sA3GvluP9kU7+vGp2qTWPYOk4vNqHO+tvqT1Pro9dgY=;
	h=Date:To:From:Subject:From;
	b=p/m6Wv+paJQP2dHNxQ948mNOdM6H/BsmYmnyzt/NJ6iT7astsJq4StGizPPZmhfO+
	 oF9RJpCMj2+tkVkaVNbdMu3LUxUKSISjcBdqfLA3xiRsE9UHpxghNoY5pZx3QT3SjP
	 9UenQWuoBtDXum2qp9WFJY2JZC+nybB6lCp3477I=
Date: Mon, 17 Feb 2025 20:48:08 -0800
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,balbirs@nvidia.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-add-vmf_insert_page_mkwrite.patch added to mm-unstable branch
Message-Id: <20250218044808.8BDC3C4CEE2@smtp.kernel.org>
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
Date: Tue, 18 Feb 2025 14:55:29 +1100

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

Link: https://lkml.kernel.org/r/c936e2c5e569844a5f1e26968cd89fa348a31b09.1739850794.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
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
Cc: Dan Wiliams <dan.j.williams@intel.com>
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

 include/linux/mm.h |    2 ++
 mm/memory.c        |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)

--- a/include/linux/mm.h~mm-memory-add-vmf_insert_page_mkwrite
+++ a/include/linux/mm.h
@@ -3638,6 +3638,8 @@ int vm_map_pages(struct vm_area_struct *
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
@@ -2624,6 +2624,26 @@ static vm_fault_t __vm_insert_mixed(stru
 	return VM_FAULT_NOPAGE;
 }
 
+vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
+			bool write)
+{
+	pgprot_t pgprot = vmf->vma->vm_page_prot;
+	unsigned long addr = vmf->address;
+	int err;
+
+	if (addr < vmf->vma->vm_start || addr >= vmf->vma->vm_end)
+		return VM_FAULT_SIGBUS;
+
+	err = insert_page(vmf->vma, addr, page, pgprot, write);
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
mm-rmap-add-support-for-pud-sized-mappings-to-rmap.patch
mm-huge_memory-add-vmf_insert_folio_pud.patch
mm-huge_memory-add-vmf_insert_folio_pmd.patch
mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch
fs-dax-properly-refcount-fs-dax-pages.patch
device-dax-properly-refcount-device-dax-pages-when-mapping.patch

