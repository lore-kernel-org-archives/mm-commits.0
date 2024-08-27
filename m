Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3306B1D417F
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724802765; cv=none; b=cfpOtTzn6hNCRHH1wKYiKRG8kZ7eOu79ndi2vnO8SDqnyW3PqCRXkK0nyi5SOeiZd4r0tLHPH3FwunuNMry4YjGz7IfS7nqsdHH0l4bc+IKXAgnsMP+NyEsBUYnhPdCMPf0Od2F6mXGiV7P04ogEBtNAZWZMUfCgaCPbuPeaRUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724802765; c=relaxed/simple;
	bh=b2ABi/RNUi9u3i+B39df0K1BI721v3vwfndgH6delYM=;
	h=Date:To:From:Subject:Message-Id; b=RIcYLvQZ5w3F4yePbB4Ka+z7v2ZGggAzgwf+Jwcti2d2WNeUcR8dHSXJckC4KGr2aVyqCgKb5qrBG9Div5toN2/go3G2h0rxIauXISlUdxa28KvEOw9uEgEfDzCiDDzehpm45ehme6rPe0UElsJyVzAFi//6Bbyv0gy/r2UBLoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tIXD4hUI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tIXD4hUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0622AC32782;
	Tue, 27 Aug 2024 23:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724802765;
	bh=b2ABi/RNUi9u3i+B39df0K1BI721v3vwfndgH6delYM=;
	h=Date:To:From:Subject:From;
	b=tIXD4hUIeYPYIFghcYwbK1QevnXtnIQCWo9IM79EiWewMjOby2dCgOrAoQDaDh66a
	 ogJ2KgZ0/PA6PR4d0EbJ7tp6iLlBVb2dRnuVA2rU4H0fuO1vGOVI8OFfKcI43IckPq
	 CtM1G006FRq7tn5ZWedhZ6PHYkBbrhaW4TCR9eGE=
Date: Tue, 27 Aug 2024 16:52:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,peterx@redhat.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,agordeev@linux.ibm.com,alex.williamson@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vfio-pci-implement-huge_fault-support.patch added to mm-unstable branch
Message-Id: <20240827235245.0622AC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vfio/pci: implement huge_fault support
has been added to the -mm mm-unstable branch.  Its filename is
     vfio-pci-implement-huge_fault-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vfio-pci-implement-huge_fault-support.patch

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
From: Alex Williamson <alex.williamson@redhat.com>
Subject: vfio/pci: implement huge_fault support
Date: Mon, 26 Aug 2024 16:43:53 -0400

With the addition of pfnmap support in vmf_insert_pfn_{pmd,pud}() we can
take advantage of PMD and PUD faults to PCI BAR mmaps and create more
efficient mappings.  PCI BARs are always a power of two and will typically
get at least PMD alignment without userspace even trying.  Userspace
alignment for PUD mappings is also not too difficult.

Consolidate faults through a single handler with a new wrapper for
standard single page faults.  The pre-faulting behavior of commit
d71a989cf5d9 ("vfio/pci: Insert full vma on mmap'd MMIO fault") is removed
in this refactoring since huge_fault will cover the bulk of the faults and
results in more efficient page table usage.  We also want to avoid that
pre-faulted single page mappings preempt huge page mappings.

Link: https://lkml.kernel.org/r/20240826204353.2228736-20-peterx@redhat.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vfio/pci/vfio_pci_core.c |   60 ++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 17 deletions(-)

--- a/drivers/vfio/pci/vfio_pci_core.c~vfio-pci-implement-huge_fault-support
+++ a/drivers/vfio/pci/vfio_pci_core.c
@@ -20,6 +20,7 @@
 #include <linux/mutex.h>
 #include <linux/notifier.h>
 #include <linux/pci.h>
+#include <linux/pfn_t.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/types.h>
@@ -1657,14 +1658,20 @@ static unsigned long vma_to_pfn(struct v
 	return (pci_resource_start(vdev->pdev, index) >> PAGE_SHIFT) + pgoff;
 }
 
-static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
+static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
+					   unsigned int order)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct vfio_pci_core_device *vdev = vma->vm_private_data;
 	unsigned long pfn, pgoff = vmf->pgoff - vma->vm_pgoff;
-	unsigned long addr = vma->vm_start;
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 
+	if (order && (vmf->address & ((PAGE_SIZE << order) - 1) ||
+		      vmf->address + (PAGE_SIZE << order) > vma->vm_end)) {
+		ret = VM_FAULT_FALLBACK;
+		goto out;
+	}
+
 	pfn = vma_to_pfn(vma);
 
 	down_read(&vdev->memory_lock);
@@ -1672,30 +1679,49 @@ static vm_fault_t vfio_pci_mmap_fault(st
 	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
 		goto out_unlock;
 
-	ret = vmf_insert_pfn(vma, vmf->address, pfn + pgoff);
-	if (ret & VM_FAULT_ERROR)
-		goto out_unlock;
-
-	/*
-	 * Pre-fault the remainder of the vma, abort further insertions and
-	 * supress error if fault is encountered during pre-fault.
-	 */
-	for (; addr < vma->vm_end; addr += PAGE_SIZE, pfn++) {
-		if (addr == vmf->address)
-			continue;
-
-		if (vmf_insert_pfn(vma, addr, pfn) & VM_FAULT_ERROR)
-			break;
+	switch (order) {
+	case 0:
+		ret = vmf_insert_pfn(vma, vmf->address, pfn + pgoff);
+		break;
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+	case PMD_ORDER:
+		ret = vmf_insert_pfn_pmd(vmf, __pfn_to_pfn_t(pfn + pgoff,
+							     PFN_DEV), false);
+		break;
+#endif
+#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
+	case PUD_ORDER:
+		ret = vmf_insert_pfn_pud(vmf, __pfn_to_pfn_t(pfn + pgoff,
+							     PFN_DEV), false);
+		break;
+#endif
+	default:
+		ret = VM_FAULT_FALLBACK;
 	}
 
 out_unlock:
 	up_read(&vdev->memory_lock);
+out:
+	dev_dbg_ratelimited(&vdev->pdev->dev,
+			   "%s(,order = %d) BAR %ld page offset 0x%lx: 0x%x\n",
+			    __func__, order,
+			    vma->vm_pgoff >>
+				(VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT),
+			    pgoff, (unsigned int)ret);
 
 	return ret;
 }
 
+static vm_fault_t vfio_pci_mmap_page_fault(struct vm_fault *vmf)
+{
+	return vfio_pci_mmap_huge_fault(vmf, 0);
+}
+
 static const struct vm_operations_struct vfio_pci_mmap_ops = {
-	.fault = vfio_pci_mmap_fault,
+	.fault = vfio_pci_mmap_page_fault,
+#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
+	.huge_fault = vfio_pci_mmap_huge_fault,
+#endif
 };
 
 int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
_

Patches currently in -mm which might be from alex.williamson@redhat.com are

vfio-pci-implement-huge_fault-support.patch

