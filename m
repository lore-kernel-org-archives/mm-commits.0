From: akpm@linux-foundation.org
Subject: [patch 15/28] IB/core: disable memory registration of
 filesystem-dax vmas
Date: Wed, 29 Nov 2017 16:10:47 -0800
Message-ID: <5a1f4c87.I+FrXwXbOL6a0zuv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60668 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753564AbdK3AKt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 19:10:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dan.j.williams@intel.com, dledford@redhat.com, hal.rosenstock@gmail.com, hch@lst.de, inki.dae@samsung.com, jack@suse.cz, jgg@mellanox.com, jmoyer@redhat.com, jy0922.shim@samsung.com, kyungmin.park@samsung.com, mchehab@kernel.org, mgorman@suse.de, ross.zwisler@linux.intel.com, sean.hefty@intel.com, stable@vger.kernel.org, sw0312.kim@samsung.com, vbabka@suse.cz

From: Dan Williams <dan.j.williams@intel.com>
Subject: IB/core: disable memory registration of filesystem-dax vmas

Until there is a solution to the dma-to-dax vs truncate problem it is not
safe to allow RDMA to create long standing memory registrations against
filesytem-dax vmas.

Link: http://lkml.kernel.org/r/151068941011.7446.7766030590347262502.stgit@dwillia2-desk3.amr.corp.intel.com
Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jason Gunthorpe <jgg@mellanox.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/core/umem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/infiniband/core/umem.c~ib-core-disable-memory-registration-of-fileystem-dax-vmas drivers/infiniband/core/umem.c
--- a/drivers/infiniband/core/umem.c~ib-core-disable-memory-registration-of-fileystem-dax-vmas
+++ a/drivers/infiniband/core/umem.c
@@ -191,7 +191,7 @@ struct ib_umem *ib_umem_get(struct ib_uc
 	sg_list_start = umem->sg_head.sgl;
 
 	while (npages) {
-		ret = get_user_pages(cur_base,
+		ret = get_user_pages_longterm(cur_base,
 				     min_t(unsigned long, npages,
 					   PAGE_SIZE / sizeof (struct page *)),
 				     gup_flags, page_list, vma_list);
_
