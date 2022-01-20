Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A138C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347593AbiATVYL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:24:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35348 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347620AbiATVYL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:24:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2C9360B08
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFF7C340E5;
        Thu, 20 Jan 2022 21:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713850;
        bh=2IIfV0okv0nOc7dbFHMXgbpYa8PLPm+w2nd0HyE5WAE=;
        h=Date:From:To:Subject:From;
        b=JilGk5NW/PdcqMvnrjs0FyopDBh3krBswFnnGq/x9ouOo+CtLPkpgQTsiA4kNfJ/R
         /w3PC4TVygafDXrC2/TyUcGUqf5S80HwFdy++oO8tlmf2Coi1i/UjbAU5AP3SKNUhC
         n6WarNoaZYjtjZF99ruibB+PBo9jeki7xwJlyTro=
Date:   Thu, 20 Jan 2022 13:24:09 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, dan.j.williams@intel.com, dave.jiang@intel.com,
        hch@lst.de, jane.chu@oracle.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, joao.m.martins@oracle.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, songmuchun@bytedance.com,
        vishal.l.verma@intel.com, willy@infradead.org
Subject:  [merged]
 device-dax-factor-out-page-mapping-initialization.patch removed from -mm
 tree
Message-ID: <20220120212409.RpzDolRPw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: factor out page mapping initialization
has been removed from the -mm tree.  Its filename was
     device-dax-factor-out-page-mapping-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: device-dax: factor out page mapping initialization

Move initialization of page->mapping into a separate helper.

This is in preparation to move the mapping set to be prior to inserting
the page table entry and also for tidying up compound page handling into
one helper.

Link: https://lkml.kernel.org/r/20211202204422.26777-9-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
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

 drivers/dax/device.c |   45 ++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

--- a/drivers/dax/device.c~device-dax-factor-out-page-mapping-initialization
+++ a/drivers/dax/device.c
@@ -73,6 +73,27 @@ __weak phys_addr_t dax_pgoff_to_phys(str
 	return -1;
 }
 
+static void dax_set_mapping(struct vm_fault *vmf, pfn_t pfn,
+			      unsigned long fault_size)
+{
+	unsigned long i, nr_pages = fault_size / PAGE_SIZE;
+	struct file *filp = vmf->vma->vm_file;
+	pgoff_t pgoff;
+
+	pgoff = linear_page_index(vmf->vma,
+			ALIGN(vmf->address, fault_size));
+
+	for (i = 0; i < nr_pages; i++) {
+		struct page *page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
+
+		if (page->mapping)
+			continue;
+
+		page->mapping = filp->f_mapping;
+		page->index = pgoff + i;
+	}
+}
+
 static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
 				struct vm_fault *vmf, pfn_t *pfn)
 {
@@ -224,28 +245,8 @@ static vm_fault_t dev_dax_huge_fault(str
 		rc = VM_FAULT_SIGBUS;
 	}
 
-	if (rc == VM_FAULT_NOPAGE) {
-		unsigned long i;
-		pgoff_t pgoff;
-
-		/*
-		 * In the device-dax case the only possibility for a
-		 * VM_FAULT_NOPAGE result is when device-dax capacity is
-		 * mapped. No need to consider the zero page, or racing
-		 * conflicting mappings.
-		 */
-		pgoff = linear_page_index(vmf->vma,
-				ALIGN(vmf->address, fault_size));
-		for (i = 0; i < fault_size / PAGE_SIZE; i++) {
-			struct page *page;
-
-			page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
-			if (page->mapping)
-				continue;
-			page->mapping = filp->f_mapping;
-			page->index = pgoff + i;
-		}
-	}
+	if (rc == VM_FAULT_NOPAGE)
+		dax_set_mapping(vmf, pfn, fault_size);
 	dax_read_unlock(id);
 
 	return rc;
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are


