Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 997C3C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 21:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244027AbhKXVWW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 16:22:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:40558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243500AbhKXVWV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 16:22:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1269960F41;
        Wed, 24 Nov 2021 21:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637788751;
        bh=Kx45E3XLFEF6EDo4DkuLzUtb2ghY5Q5zmhMtoTByIDU=;
        h=Date:From:To:Subject:From;
        b=ZNCDuKUaKiGPsb3lUULWIl31XtQbIKW5e0SAgRQ7aox/MPDIrCioJk/9vmhVwH62M
         CFIjlHg7wq1Tr5dw92H1wot2HZ/TABcsH4ro7pBthmA8xf1UCSxNAenHH0MwBZ8O8Y
         dHO5m3LL/wo01tPzuAvThIChiMFoURqw6UwOK2T8=
Date:   Wed, 24 Nov 2021 13:19:10 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, dan.j.williams@intel.com, dave.jiang@intel.com,
        hch@lst.de, jane.chu@oracle.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, joao.m.martins@oracle.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, songmuchun@bytedance.com,
        vishal.l.verma@intel.com, willy@infradead.org
Subject:  + device-dax-use-align-for-determining-pgoff.patch added
 to -mm tree
Message-ID: <20211124211910.mUhT6OPpF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: use ALIGN() for determining pgoff
has been added to the -mm tree.  Its filename is
     device-dax-use-align-for-determining-pgoff.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-use-align-for-determining-pgoff.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-use-align-for-determining-pgoff.patch

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
Subject: device-dax: use ALIGN() for determining pgoff

Rather than calculating @pgoff manually, switch to ALIGN() instead.

Link: https://lkml.kernel.org/r/20211124191005.20783-6-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
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

 drivers/dax/device.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dax/device.c~device-dax-use-align-for-determining-pgoff
+++ a/drivers/dax/device.c
@@ -234,8 +234,8 @@ static vm_fault_t dev_dax_huge_fault(str
 		 * mapped. No need to consider the zero page, or racing
 		 * conflicting mappings.
 		 */
-		pgoff = linear_page_index(vmf->vma, vmf->address
-				& ~(fault_size - 1));
+		pgoff = linear_page_index(vmf->vma,
+				ALIGN(vmf->address, fault_size));
 		for (i = 0; i < fault_size / PAGE_SIZE; i++) {
 			struct page *page;
 
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

