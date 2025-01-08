Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC961A287E
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 06:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736317620; cv=none; b=PTd4oBIw4giXPWXb5MoqcMXxPcNVo2j3G4iaay9ISllo7ao3Qa12cwF94qWnHkHF4VbzzF501lLcTsqAW6kLXdwUuMHJe1KYYDiZQvLEyxvWaygD/MlB6C2p3aul+hhtPDVO6nD77fzToFYtjdLD88mJaV0Pnqp9wNDliK6XZYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736317620; c=relaxed/simple;
	bh=mX6ybl6mTVO7+AGsto2vEaA0nw/ISzBD4YWmCzF6MYo=;
	h=Date:To:From:Subject:Message-Id; b=ZJWJYNu8Y9d837D/l0R+HC3ffhdJK1w2z5atFdzmrkCabK5E75isflE53AB9IGk8ShtwjqY70Tej5FDuKXfWt1xcMC/5n5rdShR9K33Co91NkNDf4a4spoJDfYSAkv2ch41T+HXT1DGijY9qMx6LKrCFcYjriKyl5S+8FWE44VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ay2onvVm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ay2onvVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D80BC4CED0;
	Wed,  8 Jan 2025 06:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736317620;
	bh=mX6ybl6mTVO7+AGsto2vEaA0nw/ISzBD4YWmCzF6MYo=;
	h=Date:To:From:Subject:From;
	b=ay2onvVmIphEbgxnr56m+UV28DwQsDkHfvleYI/MXhv3qawEWeSfSiOgKJdjhflH+
	 hbLKWMbEkC7B+EtQukm9+FV7vzlSi1gpbAYKVIn9WEyU5g+8YhWfOdSr1btoDRccZl
	 WSX/LPp+uHWniMR0wwYT4fqj7kxXSZRtPuahLRPw=
Date: Tue, 07 Jan 2025 22:26:59 -0800
To: mm-commits@vger.kernel.org,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-add-vmf_insert_page_mkwrite.patch added to mm-unstable branch
Message-Id: <20250108062700.1D80BC4CED0@smtp.kernel.org>
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
Date: Tue, 7 Jan 2025 14:42:29 +1100

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

Link: https://lkml.kernel.org/r/0b56d4b4da706ef6e7194b1776fda54ed4c21599.1736221254.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/memory.c        |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

--- a/include/linux/mm.h~mm-memory-add-vmf_insert_page_mkwrite
+++ a/include/linux/mm.h
@@ -3627,6 +3627,8 @@ int vm_map_pages(struct vm_area_struct *
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
@@ -2622,6 +2622,42 @@ static vm_fault_t __vm_insert_mixed(stru
 	return VM_FAULT_NOPAGE;
 }
 
+vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
+			bool write)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	pgprot_t pgprot = vma->vm_page_prot;
+	unsigned long pfn = page_to_pfn(page);
+	unsigned long addr = vmf->address;
+	int err;
+
+	if (addr < vma->vm_start || addr >= vma->vm_end)
+		return VM_FAULT_SIGBUS;
+
+	track_pfn_insert(vma, &pgprot, pfn_to_pfn_t(pfn));
+
+	if (!pfn_modify_allowed(pfn, pgprot))
+		return VM_FAULT_SIGBUS;
+
+	/*
+	 * We refcount the page normally so make sure pfn_valid is true.
+	 */
+	if (!pfn_valid(pfn))
+		return VM_FAULT_SIGBUS;
+
+	if (WARN_ON(is_zero_pfn(pfn) && write))
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
memremap-add-is_devdax_page-and-is_fsdax_page-helpers.patch
mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch
proc-task_mmu-mark-devdax-and-fsdax-pages-as-always-unpinned.patch
mm-mlock-skip-zone_device-pmds-during-mlock.patch
fs-dax-properly-refcount-fs-dax-pages.patch
device-dax-properly-refcount-device-dax-pages-when-mapping.patch
mm-remove-pxx_devmap-callers.patch
mm-remove-devmap-related-functions-and-page-table-bits.patch
revert-riscv-mm-add-support-for-zone_device.patch

