Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234CEC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiANWEt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:04:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46514 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiANWEt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:04:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 358AF61FF6
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3652C36AE5;
        Fri, 14 Jan 2022 22:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197888;
        bh=ed71DndyqrKIKDTVCRds4jSThgSiLtT+AJBB5N2qXeM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IfiRUp8tVcq0mjrVFvWXddXIIV8MN7alk/BxqMyRGw34WTGsTVpDKMsk5ql2S3DXe
         Owa2bKEixAdhmiHkwxGvRU3SBtJhd7rnRGT1k/So85J9Pe0u4fJdAJ5x+yxpueZw6R
         BGMrK4jd3VpgHoD8Z4H+uzWGTWHGLz1+A4vKix0w=
Date:   Fri, 14 Jan 2022 14:04:47 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net,
        dan.j.williams@intel.com, dave.jiang@intel.com, hch@lst.de,
        jane.chu@oracle.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, vishal.l.verma@intel.com,
        willy@infradead.org
Subject:  [patch 035/146] device-dax: compound devmap support
Message-ID: <20220114220447.U7zzozxTZ%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>
Subject: device-dax: compound devmap support

Use the newly added compound devmap facility which maps the assigned dax
ranges as compound pages at a page size of @align.

dax devices are created with a fixed @align (huge page size) which is
enforced through as well at mmap() of the device.  Faults, consequently
happen too at the specified @align specified at the creation, and those
don't change throughout dax device lifetime.  MCEs unmap a whole dax huge
page, as well as splits occurring at the configured page size.

Performance measured by gup_test improves considerably for
unpin_user_pages() and altmap with NVDIMMs:

$ gup_test -f /dev/dax1.0 -m 16384 -r 10 -S -a -n 512 -w
(pin_user_pages_fast 2M pages) put:~71 ms -> put:~22 ms
[altmap]
(pin_user_pages_fast 2M pages) get:~524ms put:~525 ms -> get: ~127ms put:~71ms

 $ gup_test -f /dev/dax1.0 -m 129022 -r 10 -S -a -n 512 -w
(pin_user_pages_fast 2M pages) put:~513 ms -> put:~188 ms
[altmap with -m 127004]
(pin_user_pages_fast 2M pages) get:~4.1 secs put:~4.12 secs -> get:~1sec put:~563ms

.. as well as unpin_user_page_range_dirty_lock() being just as effective
as THP/hugetlb[0] pages.

[0] https://lore.kernel.org/linux-mm/20210212130843.13865-5-joao.m.martins@oracle.com/

Link: https://lkml.kernel.org/r/20211202204422.26777-12-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
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

 drivers/dax/device.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/dax/device.c~device-dax-compound-devmap-support
+++ a/drivers/dax/device.c
@@ -78,14 +78,20 @@ static void dax_set_mapping(struct vm_fa
 {
 	unsigned long i, nr_pages = fault_size / PAGE_SIZE;
 	struct file *filp = vmf->vma->vm_file;
+	struct dev_dax *dev_dax = filp->private_data;
 	pgoff_t pgoff;
 
+	/* mapping is only set on the head */
+	if (dev_dax->pgmap->vmemmap_shift)
+		nr_pages = 1;
+
 	pgoff = linear_page_index(vmf->vma,
 			ALIGN(vmf->address, fault_size));
 
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
 
+		page = compound_head(page);
 		if (page->mapping)
 			continue;
 
@@ -443,6 +449,9 @@ int dev_dax_probe(struct dev_dax *dev_da
 	}
 
 	pgmap->type = MEMORY_DEVICE_GENERIC;
+	if (dev_dax->align > PAGE_SIZE)
+		pgmap->vmemmap_shift =
+			order_base_2(dev_dax->align >> PAGE_SHIFT);
 	addr = devm_memremap_pages(dev, pgmap);
 	if (IS_ERR(addr))
 		return PTR_ERR(addr);
_
