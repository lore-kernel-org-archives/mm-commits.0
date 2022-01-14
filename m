Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C621C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiANWEk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:04:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57928 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiANWEk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:04:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02908B825F5
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30386C36AE9;
        Fri, 14 Jan 2022 22:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197877;
        bh=cP2M1wf3ft2auD5+qyxpoqWOHWWusT3QFg35h1hSUBA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Z/inzFrtdOULFOfeCQ1dgtvJUgYlUXnIaqF10WchNNgTNl8B0FMclMU28VdvUeRkA
         b0xGY9Ziv3/lfIZWx9nTieglBDF8XLCoX3LdfDtGoYsijQAhSoBzWIqUI9LmDIb5rA
         /QJ1ilSoytOHz03cAbT57/X7hXl9RFOYJj7BjE8k=
Date:   Fri, 14 Jan 2022 14:04:36 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net,
        dan.j.williams@intel.com, dave.jiang@intel.com, hch@lst.de,
        jane.chu@oracle.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, vishal.l.verma@intel.com,
        willy@infradead.org
Subject:  [patch 032/146] device-dax: factor out page mapping
 initialization
Message-ID: <20220114220436.7rH5EsVGE%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
