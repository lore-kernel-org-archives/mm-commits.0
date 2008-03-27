From: akpm@linux-foundation.org
Subject: - svcrdma-check-num_sge-when-setting-last_ctxt-bit.patch removed from -mm tree
Date: Thu, 27 Mar 2008 00:42:21 -0700
Message-ID: <200803270742.m2R7gLFE024014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754804AbYC0HnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 03:43:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tom@opengridcomputing.com, bfields@citi.umich.edu, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     svcrdma: check num_sge when setting LAST_CTXT bit
has been removed from the -mm tree.  Its filename was
     svcrdma-check-num_sge-when-setting-last_ctxt-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: svcrdma: check num_sge when setting LAST_CTXT bit
From: Tom Tucker <tom@opengridcomputing.com>

The RDMACTXT_F_LAST_CTXT bit was getting set incorrectly when the last chunk
in the read-list spanned multiple pages.  This resulted in a kernel panic when
the wrong context was used to build the RPC iovec page list.

RDMA_READ is used to fetch RPC data from the client for NFS_WRITE requests.  A
scatter-gather is used to map the advertised client side buffer to the
server-side iovec and associated page list.

WR contexts are used to convey which scatter-gather entries are handled by
each WR.  When the write data is large, a single RPC may require multiple
RDMA_READ requests so the contexts for a single RPC are chained together in a
linked list.  The last context in this list is marked with a bit
RDMACTXT_F_LAST_CTXT so that when this WR completes, the CQ handler code can
enqueue the RPC for processing.

The code in rdma_read_xdr was setting this bit on the last two contexts on
this list when the last read-list chunk spanned multiple pages.  This caused
the svc_rdma_recvfrom logic to incorrectly build the RPC and caused the kernel
to crash because the second-to-last context doesn't contain the iovec page
list.

Modified the condition that sets this bit so that it correctly detects the
last context for the RPC.

Signed-off-by: Tom Tucker <tom@opengridcomputing.com>
Tested-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff -puN net/sunrpc/xprtrdma/svc_rdma_recvfrom.c~svcrdma-check-num_sge-when-setting-last_ctxt-bit net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c~svcrdma-check-num_sge-when-setting-last_ctxt-bit
+++ a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -322,15 +322,6 @@ next_sge:
 		ctxt->direction = DMA_FROM_DEVICE;
 		clear_bit(RDMACTXT_F_READ_DONE, &ctxt->flags);
 		clear_bit(RDMACTXT_F_LAST_CTXT, &ctxt->flags);
-		if ((ch+1)->rc_discrim == 0) {
-			/*
-			 * Checked in sq_cq_reap to see if we need to
-			 * be enqueued
-			 */
-			set_bit(RDMACTXT_F_LAST_CTXT, &ctxt->flags);
-			ctxt->next = hdr_ctxt;
-			hdr_ctxt->next = head;
-		}
 
 		/* Prepare READ WR */
 		memset(&read_wr, 0, sizeof read_wr);
@@ -348,7 +339,17 @@ next_sge:
 		rdma_set_ctxt_sge(ctxt, &sge[ch_sge_ary[ch_no].start],
 				  &sgl_offset,
 				  read_wr.num_sge);
