From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rapidio-convert-get_user_pages-pin_user_pages.patch
 added to -mm tree
Date: Mon, 18 May 2020 14:38:21 -0700
Message-ID: <20200518213821.C4IcLvJJ2%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbgERViY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 17:38:24 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.bou9@gmail.com, dan.carpenter@oracle.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org, mporter@kernel.crashing.org, sumit.semwal@linaro.org


The patch titled
     Subject: rapidio: convert get_user_pages() --> pin_user_pages()
has been added to the -mm tree.  Its filename is
     rapidio-convert-get_user_pages-pin_user_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-convert-get_user_pages-pin_user_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-convert-get_user_pages-pin_user_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: rapidio: convert get_user_pages() --> pin_user_pages()

This code was using get_user_pages_fast(), in a "Case 2" scenario
(DMA/RDMA), using the categorization from [1].  That means that it's time
to convert the get_user_pages_fast() + put_page() calls to
pin_user_pages_fast() + unpin_user_pages() calls.

There is some helpful background in [2]: basically, this is a small
part of fixing a long-standing disconnect between pinning pages, and
file systems' use of those pages.

[1] Documentation/core-api/pin_user_pages.rst

[2] "Explicit pinning of user-space pages":
    https://lwn.net/Articles/807108/

Link: http://lkml.kernel.org/r/20200517235620.205225-3-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-convert-get_user_pages-pin_user_pages
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -572,14 +572,12 @@ static void dma_req_free(struct kref *re
 	struct mport_dma_req *req = container_of(ref, struct mport_dma_req,
 			refcount);
 	struct mport_cdev_priv *priv = req->priv;
-	unsigned int i;
 
 	dma_unmap_sg(req->dmach->device->dev,
 		     req->sgt.sgl, req->sgt.nents, req->dir);
 	sg_free_table(&req->sgt);
 	if (req->page_list) {
-		for (i = 0; i < req->nr_pages; i++)
-			put_page(req->page_list[i]);
+		unpin_user_pages(req->page_list, req->nr_pages);
 		kfree(req->page_list);
 	}
 
@@ -815,7 +813,7 @@ rio_dma_transfer(struct file *filp, u32
 	struct mport_dma_req *req;
 	struct mport_dev *md = priv->md;
 	struct dma_chan *chan;
-	int i, ret;
+	int ret;
 	int nents;
 
 	if (xfer->length == 0)
@@ -862,7 +860,7 @@ rio_dma_transfer(struct file *filp, u32
 			goto err_req;
 		}
 
-		pinned = get_user_pages_fast(
+		pinned = pin_user_pages_fast(
 				(unsigned long)xfer->loc_addr & PAGE_MASK,
 				nr_pages,
 				dir == DMA_FROM_DEVICE ? FOLL_WRITE : 0,
@@ -870,7 +868,7 @@ rio_dma_transfer(struct file *filp, u32
 
 		if (pinned != nr_pages) {
 			if (pinned < 0) {
-				rmcd_error("get_user_pages_unlocked err=%ld",
+				rmcd_error("pin_user_pages_fast err=%ld",
 					   pinned);
 				nr_pages = 0;
 			} else
@@ -951,8 +949,7 @@ rio_dma_transfer(struct file *filp, u32
 
 err_pg:
 	if (!req->page_list) {
-		for (i = 0; i < nr_pages; i++)
-			put_page(page_list[i]);
+		unpin_user_pages(page_list, nr_pages);
 		kfree(page_list);
 	}
 err_req:
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

rapidio-fix-an-error-in-get_user_pages_fast-error-handling.patch
mm-gup-introduce-pin_user_pages_unlocked.patch
ivtv-convert-get_user_pages-pin_user_pages.patch
rapidio-convert-get_user_pages-pin_user_pages.patch
