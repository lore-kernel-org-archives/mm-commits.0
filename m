Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C6CC43219
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 21:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244096AbhKXVWZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 16:22:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:40622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245723AbhKXVWY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 16:22:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10C3060F5B;
        Wed, 24 Nov 2021 21:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637788754;
        bh=eqzIOUo6TqLTlRMPoc/Tg/+lPmLGrLwt/vbkxMOCzP4=;
        h=Date:From:To:Subject:From;
        b=QlKjU6QroHsUE7D47iTnQ1PVSEzFAhCUQ/6n2rVw7rxJz4KEgkgjNsc1J8NywN9rk
         KIEgEFUkxbs+JtsMlrVyK+a0p3x3fgX4GuVy3A7/PSMP1kguxc/86UTzgUi8oObQwS
         RUrSa/boGhUVDtjsxIlXQBXBxousGCkQ5gb1pFu0=
Date:   Wed, 24 Nov 2021 13:19:13 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, dan.j.williams@intel.com, dave.jiang@intel.com,
        hch@lst.de, jane.chu@oracle.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, joao.m.martins@oracle.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, songmuchun@bytedance.com,
        vishal.l.verma@intel.com, willy@infradead.org
Subject:  + device-dax-use-struct_size.patch added to -mm tree
Message-ID: <20211124211913.OWvwoQD4J%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: use struct_size()
has been added to the -mm tree.  Its filename is
     device-dax-use-struct_size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-use-struct_size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-use-struct_size.patch

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
Subject: device-dax: use struct_size()

Use the struct_size() helper for the size of a struct with variable array
member at the end, rather than manually calculating it.

Link: https://lkml.kernel.org/r/20211124191005.20783-7-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/device.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/dax/device.c~device-dax-use-struct_size
+++ a/drivers/dax/device.c
@@ -404,8 +404,9 @@ int dev_dax_probe(struct dev_dax *dev_da
 		return -EINVAL;
 
 	if (!pgmap) {
-		pgmap = devm_kzalloc(dev, sizeof(*pgmap) + sizeof(struct range)
-				* (dev_dax->nr_range - 1), GFP_KERNEL);
+		pgmap = devm_kzalloc(dev,
+                       struct_size(pgmap, ranges, dev_dax->nr_range - 1),
+                       GFP_KERNEL);
 		if (!pgmap)
 			return -ENOMEM;
 		pgmap->nr_range = dev_dax->nr_range;
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

memory-failure-fetch-compound_head-after-pgmap_pfn_valid.patch
mm-page_alloc-split-prep_compound_page-into-head-and-tail-subparts.patch
mm-page_alloc-refactor-memmap_init_zone_device-page-init.patch
mm-memremap-add-zone_device-support-for-compound-pages.patch
device-dax-use-align-for-determining-pgoff.patch
device-dax-use-struct_size.patch
device-dax-ensure-dev_dax-pgmap-is-valid-for-dynamic-devices.patch
device-dax-factor-out-page-mapping-initialization.patch
device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud.patch
device-dax-compound-devmap-support.patch

