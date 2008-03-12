From: akpm@linux-foundation.org
Subject: + svcrdma-fix-erroneous-bug_on-in-send_write.patch added to -mm tree
Date: Tue, 11 Mar 2008 21:57:09 -0700
Message-ID: <200803120457.m2C4v9In010926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868AbYCLE5f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Mar 2008 00:57:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tom@opengridcomputing.com, bfields@citi.umich.edu, rolandd@cisco.com


The patch titled
     SVCRDMA: Fix erroneous BUG_ON in send_write
has been added to the -mm tree.  Its filename is
     svcrdma-fix-erroneous-bug_on-in-send_write.patch

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
Subject: SVCRDMA: Fix erroneous BUG_ON in send_write
From: Tom Tucker <tom@opengridcomputing.com>

The assertion that checks for sge context overflow is
incorrectly hard-coded to 32. This causes a kernel bug
check when using big-data mounts. Changed the BUG_ON to
use the computed value RPCSVC_MAXPAGES.

Signed-off-by: Tom Tucker <tom@opengridcomputing.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/xprtrdma/svc_rdma_sendto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/sunrpc/xprtrdma/svc_rdma_sendto.c~svcrdma-fix-erroneous-bug_on-in-send_write net/sunrpc/xprtrdma/svc_rdma_sendto.c
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c~svcrdma-fix-erroneous-bug_on-in-send_write
+++ a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -156,7 +156,7 @@ static int send_write(struct svcxprt_rdm
 	struct svc_rdma_op_ctxt *ctxt;
 	int ret = 0;
 
-	BUG_ON(sge_count >= 32);
+	BUG_ON(sge_count > RPCSVC_MAXPAGES);
 	dprintk("svcrdma: RDMA_WRITE rmr=%x, to=%llx, xdr_off=%d, "
 		"write_len=%d, xdr_sge=%p, sge_count=%d\n",
 		rmr, (unsigned long long)to, xdr_off,
_

Patches currently in -mm which might be from tom@opengridcomputing.com are

svcrdma-add-xprt-refs-to-fix-close-unmount-crash.patch
svcrdma-fix-erroneous-bug_on-in-send_write.patch

