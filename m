Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD154C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 21:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377123AbhLBVgZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Dec 2021 16:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377097AbhLBVgY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Dec 2021 16:36:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9EF5C06174A
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 13:33:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2247FCE2474
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 21:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8702C00446;
        Thu,  2 Dec 2021 21:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638480778;
        bh=MjM0NQFvEz0gzg5YnEuQgUvTAq/dTl3PpAwYI7xJdrM=;
        h=Date:From:To:Subject:From;
        b=NVot7HaMzeB38NqT75Awr49d2AF7AeFEfzS0h98VvFP2QKp62vhUe4cV+ri3FJtOp
         C85jag7TYlEz4j26SnrsW7jHBg85vYx8/1pZkQS/NbcC2wJUUx/CKtU9wLrxC5dsY6
         yjYJMD8/Rl50ZSvIFt+jp2Ui/ZVhEr4H5Z52kwO8=
Date:   Thu, 02 Dec 2021 13:32:57 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, dan.j.williams@intel.com, dave.jiang@intel.com,
        hch@lst.de, jane.chu@oracle.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, joao.m.martins@oracle.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, songmuchun@bytedance.com,
        vishal.l.verma@intel.com, willy@infradead.org
Subject:  +
 device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud.patch added to -mm
 tree
Message-ID: <20211202213257.SAXQXjGYk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: set mapping prior to vmf_insert_pfn{,_pmd,pud}()
has been added to the -mm tree.  Its filename is
     device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud.patch

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

