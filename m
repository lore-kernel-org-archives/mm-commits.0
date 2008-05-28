From: akpm@linux-foundation.org
Subject: + svcrdma-fix-compile-warning-on-32-bit-platforms.patch added to -mm tree
Date: Tue, 27 May 2008 20:51:25 -0700
Message-ID: <200805280351.m4S3pP6F027631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752200AbYE1Dvn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 23:51:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tom@opengridcomputing.com, bfields@fieldses.org


The patch titled
     svcrdma: fix compile warning on 32 bit platforms
has been added to the -mm tree.  Its filename is
     svcrdma-fix-compile-warning-on-32-bit-platforms.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

