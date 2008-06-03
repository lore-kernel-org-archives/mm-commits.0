From: akpm@linux-foundation.org
Subject: - svcrdma-add-flush_scheduled_work-to-module-exit-function.patch removed from -mm tree
Date: Tue, 03 Jun 2008 12:02:41 -0700
Message-ID: <200806031902.m53J2fKN014818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758329AbYFCTFl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 15:05:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tom@opengridcomputing.com, mm-commits@vger.kernel.org


The patch titled
     svcrdma: add flush_scheduled_work to module exit function
has been removed from the -mm tree.  Its filename was
     svcrdma-add-flush_scheduled_work-to-module-exit-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: svcrdma: add flush_scheduled_work to module exit function
From: Tom Tucker <tom@opengridcomputing.com>

Make certain all transports pending free are flushed from the wq
before unloading the module.

Signed-off-by: Tom Tucker <tom@opengridcomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/xprtrdma/svc_rdma.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN net/sunrpc/xprtrdma/svc_rdma.c~svcrdma-add-flush_scheduled_work-to-module-exit-function net/sunrpc/xprtrdma/svc_rdma.c
--- a/net/sunrpc/xprtrdma/svc_rdma.c~svcrdma-add-flush_scheduled_work-to-module-exit-function
+++ a/net/sunrpc/xprtrdma/svc_rdma.c
@@ -236,6 +236,7 @@ static ctl_table svcrdma_root_table[] = 
 void svc_rdma_cleanup(void)
 {
 	dprintk("SVCRDMA Module Removed, deregister RPC RDMA transport\n");
+	flush_scheduled_work();
 	if (svcrdma_table_header) {
 		unregister_sysctl_table(svcrdma_table_header);
 		svcrdma_table_header = NULL;
_

Patches currently in -mm which might be from tom@opengridcomputing.com are

linux-next.patch

