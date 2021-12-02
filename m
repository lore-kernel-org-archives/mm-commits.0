Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B34C5C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 21:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377117AbhLBVgQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Dec 2021 16:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377097AbhLBVgP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Dec 2021 16:36:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE219C06174A
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 13:32:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 26819CE2451
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 21:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7358C00446;
        Thu,  2 Dec 2021 21:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638480769;
        bh=pptRsn0P3LfQI1hL0hOIAZvllXqdZUL3zEOTQ8tAlqU=;
        h=Date:From:To:Subject:From;
        b=UCRlDSQ1AseAiS6V33jrjXwADDcnRUcmzFGxSuYNMBdoSudFre3qB2xbi8faj64jx
         sTy6jovnRHFMtCtIChvmdlplJbxcbBaSLyGIqccMC3SGmqehTiV8tTYj4NqMuReLo+
         9tGsPW+RMXV4X9nGo4z+Q8YE2oQfJeKxeadFMjRc=
Date:   Thu, 02 Dec 2021 13:32:48 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, dan.j.williams@intel.com, dave.jiang@intel.com,
        hch@lst.de, jane.chu@oracle.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, joao.m.martins@oracle.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, songmuchun@bytedance.com,
        vishal.l.verma@intel.com, willy@infradead.org
Subject:  + device-dax-use-struct_size.patch added to -mm tree
Message-ID: <20211202213248.ZWZbsJfQY%akpm@linux-foundation.org>
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

Link: https://lkml.kernel.org/r/20211202204422.26777-7-joao.m.martins@oracle.com
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
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

