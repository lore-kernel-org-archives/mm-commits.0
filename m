Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D309C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 21:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377122AbhLBVgY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Dec 2021 16:36:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38444 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377097AbhLBVgY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Dec 2021 16:36:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E8806285B
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 21:33:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B89EC53FD0;
        Thu,  2 Dec 2021 21:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638480780;
        bh=JM750IRZbnTJq18VJKN7nLmDQUyxAysKuMz/TJij6eg=;
        h=Date:From:To:Subject:From;
        b=p8rc2L9mkp1JYbdLBUNPTYSVdZjCfuNxkGwnsSAZP9+3Dg5wjIlEBpOowJaNnO6Z4
         VgpCpm6FgfocQW58zMAZTtt+nDbQXGYQ2g5LBl2BOFW/7+4ukwZIUSiBmYGdlLBa6t
         lHRICHv0KYUtXHGrAhbJh38999O2YfxngKj6I0Yg=
Date:   Thu, 02 Dec 2021 13:32:59 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, dan.j.williams@intel.com, dave.jiang@intel.com,
        hch@lst.de, jane.chu@oracle.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, joao.m.martins@oracle.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, songmuchun@bytedance.com,
        vishal.l.verma@intel.com, willy@infradead.org
Subject:  +
 device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault.patch added to -mm
 tree
Message-ID: <20211202213259.OcMQAWJZY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: remove pfn from __dev_dax_{pte,pmd,pud}_fault()
has been added to the -mm tree.  Its filename is
     device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: device-dax: remove pfn from __dev_dax_{pte,pmd,pud}_fault()

After moving the page mapping to be set prior to pte insertion, the pfn in
dev_dax_huge_fault() no longer is necessary.  Remove it, as well as the
@pfn argument passed to the internal fault handler helpers.

Link: https://lkml.kernel.org/r/20211202204422.26777-11-joao.m.martins@oracle.com
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/device.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

--- a/drivers/dax/device.c~device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault
+++ a/drivers/dax/device.c
@@ -95,10 +95,11 @@ static void dax_set_mapping(struct vm_fa
 }
 
 static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
-				struct vm_fault *vmf, pfn_t *pfn)
+				struct vm_fault *vmf)
 {
 	struct device *dev = &dev_dax->dev;
 	phys_addr_t phys;
+	pfn_t pfn;
 	unsigned int fault_size = PAGE_SIZE;
 
 	if (check_vma(dev_dax, vmf->vma, __func__))
@@ -119,20 +120,21 @@ static vm_fault_t __dev_dax_pte_fault(st
 		return VM_FAULT_SIGBUS;
 	}
 
-	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
+	pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
-	dax_set_mapping(vmf, *pfn, fault_size);
+	dax_set_mapping(vmf, pfn, fault_size);
 
-	return vmf_insert_mixed(vmf->vma, vmf->address, *pfn);
+	return vmf_insert_mixed(vmf->vma, vmf->address, pfn);
 }
 
 static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
-				struct vm_fault *vmf, pfn_t *pfn)
+				struct vm_fault *vmf)
 {
 	unsigned long pmd_addr = vmf->address & PMD_MASK;
 	struct device *dev = &dev_dax->dev;
 	phys_addr_t phys;
 	pgoff_t pgoff;
+	pfn_t pfn;
 	unsigned int fault_size = PMD_SIZE;
 
 	if (check_vma(dev_dax, vmf->vma, __func__))
@@ -161,21 +163,22 @@ static vm_fault_t __dev_dax_pmd_fault(st
 		return VM_FAULT_SIGBUS;
 	}
 
-	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
+	pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
-	dax_set_mapping(vmf, *pfn, fault_size);
+	dax_set_mapping(vmf, pfn, fault_size);
 
-	return vmf_insert_pfn_pmd(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
+	return vmf_insert_pfn_pmd(vmf, pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
-				struct vm_fault *vmf, pfn_t *pfn)
+				struct vm_fault *vmf)
 {
 	unsigned long pud_addr = vmf->address & PUD_MASK;
 	struct device *dev = &dev_dax->dev;
 	phys_addr_t phys;
 	pgoff_t pgoff;
+	pfn_t pfn;
 	unsigned int fault_size = PUD_SIZE;
 
 
@@ -205,11 +208,11 @@ static vm_fault_t __dev_dax_pud_fault(st
 		return VM_FAULT_SIGBUS;
 	}
 
-	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
+	pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
-	dax_set_mapping(vmf, *pfn, fault_size);
+	dax_set_mapping(vmf, pfn, fault_size);
 
-	return vmf_insert_pfn_pud(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
+	return vmf_insert_pfn_pud(vmf, pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
 #else
 static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
@@ -225,7 +228,6 @@ static vm_fault_t dev_dax_huge_fault(str
 	struct file *filp = vmf->vma->vm_file;
 	vm_fault_t rc = VM_FAULT_SIGBUS;
 	int id;
-	pfn_t pfn;
 	struct dev_dax *dev_dax = filp->private_data;
 
 	dev_dbg(&dev_dax->dev, "%s: %s (%#lx - %#lx) size = %d\n", current->comm,
@@ -235,13 +237,13 @@ static vm_fault_t dev_dax_huge_fault(str
 	id = dax_read_lock();
 	switch (pe_size) {
 	case PE_SIZE_PTE:
-		rc = __dev_dax_pte_fault(dev_dax, vmf, &pfn);
+		rc = __dev_dax_pte_fault(dev_dax, vmf);
 		break;
 	case PE_SIZE_PMD:
-		rc = __dev_dax_pmd_fault(dev_dax, vmf, &pfn);
+		rc = __dev_dax_pmd_fault(dev_dax, vmf);
 		break;
 	case PE_SIZE_PUD:
-		rc = __dev_dax_pud_fault(dev_dax, vmf, &pfn);
+		rc = __dev_dax_pud_fault(dev_dax, vmf);
 		break;
 	default:
 		rc = VM_FAULT_SIGBUS;
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

mm-page_alloc-split-prep_compound_page-into-head-and-tail-subparts.patch
mm-page_alloc-refactor-memmap_init_zone_device-page-init.patch
mm-memremap-add-zone_device-support-for-compound-pages.patch
device-dax-use-align-for-determining-pgoff.patch
device-dax-use-struct_size.patch
device-dax-ensure-dev_dax-pgmap-is-valid-for-dynamic-devices.patch
device-dax-factor-out-page-mapping-initialization.patch
device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault.patch
device-dax-compound-devmap-support.patch

