Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E2BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiANWEr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:04:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58006 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiANWEr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:04:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24B04B8262E
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:04:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F858C36AE9;
        Fri, 14 Jan 2022 22:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197885;
        bh=fHFUYb1fwx62u3tgrkOysJKXx9pbu4Mcnp2cF0Nnpx4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xp8R+iNn9etW6hfxmhoIIa+UjJi+bepAwSlOO2Wdvu33H19vbF66djvkI5k3cYxJ+
         BJV3NDvlaZHBMzTlvRS7qTCnm57TUCBJuV4RPuqz0RLTyYB3K8WJnqLs08PW+3BQOF
         /miTdJpErE4ao0U+XC4ehv33RBRgMKn7oHacYObE=
Date:   Fri, 14 Jan 2022 14:04:43 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net,
        dan.j.williams@intel.com, dave.jiang@intel.com, hch@lst.de,
        jane.chu@oracle.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, vishal.l.verma@intel.com,
        willy@infradead.org
Subject:  [patch 034/146] device-dax: remove pfn from
 __dev_dax_{pte,pmd,pud}_fault()
Message-ID: <20220114220443.oOnsq2CFf%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>
Subject: device-dax: remove pfn from __dev_dax_{pte,pmd,pud}_fault()

After moving the page mapping to be set prior to pte insertion, the pfn in
dev_dax_huge_fault() no longer is necessary.  Remove it, as well as the
@pfn argument passed to the internal fault handler helpers.

[akpm@linux-foundation.org: fix CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=n build]
Link: https://lkml.kernel.org/r/20211202204422.26777-11-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
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

 drivers/dax/device.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

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
 
 
@@ -205,15 +208,15 @@ static vm_fault_t __dev_dax_pud_fault(st
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
-				struct vm_fault *vmf, pfn_t *pfn)
+				struct vm_fault *vmf)
 {
 	return VM_FAULT_FALLBACK;
 }
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
