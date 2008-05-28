From: akpm@linux-foundation.org
Subject: + svcrdma-add-flush_scheduled_work-to-module-exit-function.patch added to -mm tree
Date: Tue, 27 May 2008 21:56:00 -0700
Message-ID: <200805280456.m4S4u0sM029765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480AbYE1E4E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 00:56:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tom@opengridcomputing.com


The patch titled
     svcrdma: add flush_scheduled_work to module exit function
has been added to the -mm tree.  Its filename is
     svcrdma-add-flush_scheduled_work-to-module-exit-function.patch

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
svcrdma-fix-compile-warning-on-32-bit-platforms.patch
svcrdma-fix-compile-warning-on-32-bit-platforms-checkpatch-fixes.patch
svcrdma-add-flush_scheduled_work-to-module-exit-function.patch

