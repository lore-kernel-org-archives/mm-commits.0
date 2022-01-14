Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 336A6C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiANWEo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:04:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57982 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiANWEn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:04:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8AAAB8262E
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6925C36AE9;
        Fri, 14 Jan 2022 22:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197881;
        bh=8qEKIm0DQ7xfXek0F6iDSdibkKFhjySTVuu4TSBpeck=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=U5cAeLudma/AUSiCJCiDJD0LOc2YJ63SyXn8kpojJCUcIV2MvsZr54pWPG9axV0KT
         jmer/Pqp+QaqTN8wPm+AOqVnoR1X135v4Uc8JO3pxrJejgFhrYKPwjPFUACgHvgv9Q
         OA8e28hzXZPiCveDJyx5inUOh0vvxiyLB/mZFbSM=
Date:   Fri, 14 Jan 2022 14:04:40 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net,
        dan.j.williams@intel.com, dave.jiang@intel.com, hch@lst.de,
        jane.chu@oracle.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, vishal.l.verma@intel.com,
        willy@infradead.org
Subject:  [patch 033/146] device-dax: set mapping prior to
 vmf_insert_pfn{,_pmd,pud}()
Message-ID: <20220114220440.ft_KpKrLo%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>
Subject: device-dax: set mapping prior to vmf_insert_pfn{,_pmd,pud}()

Normally, the @page mapping is set prior to inserting the page into a page
table entry.  Make device-dax adhere to the same ordering, rather than
setting mapping after the PTE is inserted.

The address_space never changes and it is always associated with the same
inode and underlying pages.  So, the page mapping is set once but cleared
when the struct pages are removed/freed (i.e.  after
{devm_}memunmap_pages()).

Link: https://lkml.kernel.org/r/20211202204422.26777-10-joao.m.martins@oracle.com
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>
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

 drivers/dax/device.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/dax/device.c~device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud
+++ a/drivers/dax/device.c
@@ -121,6 +121,8 @@ static vm_fault_t __dev_dax_pte_fault(st
 
 	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
+	dax_set_mapping(vmf, *pfn, fault_size);
+
 	return vmf_insert_mixed(vmf->vma, vmf->address, *pfn);
 }
 
@@ -161,6 +163,8 @@ static vm_fault_t __dev_dax_pmd_fault(st
 
 	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
+	dax_set_mapping(vmf, *pfn, fault_size);
+
 	return vmf_insert_pfn_pmd(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
 
@@ -203,6 +207,8 @@ static vm_fault_t __dev_dax_pud_fault(st
 
 	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
+	dax_set_mapping(vmf, *pfn, fault_size);
+
 	return vmf_insert_pfn_pud(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
 #else
@@ -217,7 +223,6 @@ static vm_fault_t dev_dax_huge_fault(str
 		enum page_entry_size pe_size)
 {
 	struct file *filp = vmf->vma->vm_file;
-	unsigned long fault_size;
 	vm_fault_t rc = VM_FAULT_SIGBUS;
 	int id;
 	pfn_t pfn;
@@ -230,23 +235,18 @@ static vm_fault_t dev_dax_huge_fault(str
 	id = dax_read_lock();
 	switch (pe_size) {
 	case PE_SIZE_PTE:
-		fault_size = PAGE_SIZE;
 		rc = __dev_dax_pte_fault(dev_dax, vmf, &pfn);
 		break;
 	case PE_SIZE_PMD:
-		fault_size = PMD_SIZE;
 		rc = __dev_dax_pmd_fault(dev_dax, vmf, &pfn);
 		break;
 	case PE_SIZE_PUD:
-		fault_size = PUD_SIZE;
 		rc = __dev_dax_pud_fault(dev_dax, vmf, &pfn);
 		break;
 	default:
 		rc = VM_FAULT_SIGBUS;
 	}
 
-	if (rc == VM_FAULT_NOPAGE)
-		dax_set_mapping(vmf, pfn, fault_size);
 	dax_read_unlock(id);
 
 	return rc;
_
