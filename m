From: akpm@linux-foundation.org
Subject: - svcrdma-fix-compile-warning-on-32-bit-platforms.patch removed from -mm tree
Date: Tue, 03 Jun 2008 11:59:11 -0700
Message-ID: <200806031859.m53IxBV0014728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752796AbYFCS7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 14:59:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tom@opengridcomputing.com, bfields@fieldses.org, mm-commits@vger.kernel.org


The patch titled
     svcrdma: fix compile warning on 32 bit platforms
has been removed from the -mm tree.  Its filename was
     svcrdma-fix-compile-warning-on-32-bit-platforms.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: svcrdma: fix compile warning on 32 bit platforms
From: Tom Tucker <tom@opengridcomputing.com>

The ib_sge is used to store both dma_addr_t and virtual addresses.  This
causes a warning on 32b platforms when casting ptrs to the u64 addr field
of the ib_sge.  There is work underway to reduce the memory footprint of
the WR context in 2.6.27 the time frame that will remove the overloading
of the ib_sge.addr field.

Signed-off-by: Tom Tucker <tom@opengridcomputing.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |    3 ++-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c   |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN net/sunrpc/xprtrdma/svc_rdma_recvfrom.c~svcrdma-fix-compile-warning-on-32-bit-platforms net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c~svcrdma-fix-compile-warning-on-32-bit-platforms
+++ a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -231,7 +231,8 @@ static void rdma_set_ctxt_sge(struct svc
 		atomic_inc(&xprt->sc_dma_used);
 		ctxt->sge[i].addr = (unsigned long)
 			ib_dma_map_single(xprt->sc_cm_id->device,
-					  (void*)sge[i].addr, sge[i].length,
+					  (void*)(unsigned long)
+					  sge[i].addr, sge[i].length,
 					  DMA_FROM_DEVICE);
 		ctxt->sge[i].length = sge[i].length;
 		ctxt->sge[i].lkey = sge[i].lkey;
diff -puN net/sunrpc/xprtrdma/svc_rdma_sendto.c~svcrdma-fix-compile-warning-on-32-bit-platforms net/sunrpc/xprtrdma/svc_rdma_sendto.c
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c~svcrdma-fix-compile-warning-on-32-bit-platforms
+++ a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -177,7 +177,7 @@ static int send_write(struct svcxprt_rdm
 		atomic_inc(&xprt->sc_dma_used);
 		sge[sge_no].addr =
 			ib_dma_map_single(xprt->sc_cm_id->device,
-					  (void *)
+					  (void *)(unsigned long)
 					  xdr_sge[xdr_sge_no].addr + sge_off,
 					  sge_bytes, DMA_TO_DEVICE);
 		if (dma_mapping_error(sge[sge_no].addr))
@@ -416,7 +416,7 @@ static int send_reply(struct svcxprt_rdm
 		atomic_inc(&rdma->sc_dma_used);
 		ctxt->sge[sge_no].addr =
 			ib_dma_map_single(rdma->sc_cm_id->device,
-					  (void *)
+					  (void *)(unsigned long)
 					  ctxt->sge[sge_no].addr,
 					  sge_bytes, DMA_TO_DEVICE);
 	}
_

Patches currently in -mm which might be from tom@opengridcomputing.com are

linux-next.patch
svcrdma-fix-compile-warning-on-32-bit-platforms.patch
svcrdma-fix-compile-warning-on-32-bit-platforms-checkpatch-fixes.patch
svcrdma-add-flush_scheduled_work-to-module-exit-function.patch

