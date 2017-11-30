From: akpm@linux-foundation.org
Subject: [merged] v4l2-disable-filesystem-dax-mapping-support.patch
 removed from -mm tree
Date: Thu, 30 Nov 2017 12:18:44 -0800
Message-ID: <20171130201844.XG_gIkobU%akpm__36965.9613621936$1512073153$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52316 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751582AbdK3USq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:18:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dledford@redhat.com, hal.rosenstock@gmail.com, hch@lst.de, inki.dae@samsung.com, jack@suse.cz, jgg@mellanox.com, jmoyer@redhat.com, jy0922.shim@samsung.com, kyungmin.park@samsung.com, mchehab@kernel.org, mgorman@suse.de, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com, sean.hefty@intel.com, stable@vger.kernel.org, sw0312.kim@samsung.com, vbabka@suse.cz


The patch titled
     Subject: v4l2: disable filesystem-dax mapping support
has been removed from the -mm tree.  Its filename was
     v4l2-disable-filesystem-dax-mapping-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: v4l2: disable filesystem-dax mapping support

V4L2 memory registrations are incompatible with filesystem-dax that needs
the ability to revoke dma access to a mapping at will, or otherwise allow
the kernel to wait for completion of DMA.  The filesystem-dax
implementation breaks the traditional solution of truncate of active file
backed mappings since there is no page-cache page we can orphan to sustain
ongoing DMA.

If v4l2 wants to support long lived DMA mappings it needs to arrange to
hold a file lease or use some other mechanism so that the kernel can
coordinate revoking DMA access when the filesystem needs to truncate
mappings.

Link: http://lkml.kernel.org/r/151068940499.7446.12846708245365671207.stgit@dwillia2-desk3.amr.corp.intel.com
Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/v4l2-core/videobuf-dma-sg.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/media/v4l2-core/videobuf-dma-sg.c~v4l2-disable-filesystem-dax-mapping-support drivers/media/v4l2-core/videobuf-dma-sg.c
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c~v4l2-disable-filesystem-dax-mapping-support
+++ a/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -185,12 +185,13 @@ static int videobuf_dma_init_user_locked
 	dprintk(1, "init user [0x%lx+0x%lx => %d pages]\n",
 		data, size, dma->nr_pages);
 
-	err = get_user_pages(data & PAGE_MASK, dma->nr_pages,
+	err = get_user_pages_longterm(data & PAGE_MASK, dma->nr_pages,
 			     flags, dma->pages, NULL);
 
 	if (err != dma->nr_pages) {
 		dma->nr_pages = (err >= 0) ? err : 0;
-		dprintk(1, "get_user_pages: err=%d [%d]\n", err, dma->nr_pages);
+		dprintk(1, "get_user_pages_longterm: err=%d [%d]\n", err,
+			dma->nr_pages);
 		return err < 0 ? err : -EINVAL;
 	}
 	return 0;
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


