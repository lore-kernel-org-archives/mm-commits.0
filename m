Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12282C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:24:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347620AbiATVYU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237208AbiATVYU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:24:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D51C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:24:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B897F60B08
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4F4C340E3;
        Thu, 20 Jan 2022 21:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713859;
        bh=xwTS8kVdqDV32lz0yKTff+6Ka0uXwVD1hRne+XrRCx4=;
        h=Date:From:To:Subject:From;
        b=N4+WjSfPHhSeb10ovX5erYDywbgM6sAfpR/tBZtm7j/XBYyCNiAnSpVUcdyI0Z66G
         sAL63duN4Px0NOmveVqw7GHf0yjFn87Zxre/zrCBI0fz4/e9FAtE93/3J+G/opgHfC
         HdK0oLGaGYMcmgWI1SqBwGDjp6x55s6uCieiCm+I=
Date:   Thu, 20 Jan 2022 13:24:18 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, dan.j.williams@intel.com, dave.jiang@intel.com,
        hch@lst.de, jane.chu@oracle.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, joao.m.martins@oracle.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, songmuchun@bytedance.com,
        vishal.l.verma@intel.com, willy@infradead.org
Subject:  [merged] device-dax-compound-devmap-support.patch removed
 from -mm tree
Message-ID: <20220120212418.93lOKp0k_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: compound devmap support
has been removed from the -mm tree.  Its filename was
     device-dax-compound-devmap-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from joao.m.martins@oracle.com are


