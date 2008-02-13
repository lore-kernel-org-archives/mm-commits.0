From: akpm@linux-foundation.org
Subject: - sunprc-fix-printk-format-warning.patch removed from -mm tree
Date: Wed, 13 Feb 2008 12:16:06 -0800
Message-ID: <200802132016.m1DKG6CC011429@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60573 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756861AbYBMU0K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 15:26:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdreier@cisco.com, bfields@fieldses.org, davem@davemloft.net, neilb@suse.de, rolandd@cisco.com, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     SUNPRC: fix printk format warning
has been removed from the -mm tree.  Its filename was
     sunprc-fix-printk-format-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SUNPRC: fix printk format warning
From: Roland Dreier <rdreier@cisco.com>

net/sunrpc/xprtrdma/svc_rdma_sendto.c:160: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'u64'

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/xprtrdma/svc_rdma_sendto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/sunrpc/xprtrdma/svc_rdma_sendto.c~sunprc-fix-printk-format-warning net/sunrpc/xprtrdma/svc_rdma_sendto.c
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c~sunprc-fix-printk-format-warning
+++ a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -159,7 +159,7 @@ static int send_write(struct svcxprt_rdm
 	BUG_ON(sge_count >= 32);
 	dprintk("svcrdma: RDMA_WRITE rmr=%x, to=%llx, xdr_off=%d, "
 		"write_len=%d, xdr_sge=%p, sge_count=%d\n",
-		rmr, to, xdr_off, write_len, xdr_sge, sge_count);
+		rmr, (unsigned long long) to, xdr_off, write_len, xdr_sge, sge_count);
 
 	ctxt = svc_rdma_get_context(xprt);
 	ctxt->count = 0;
_

Patches currently in -mm which might be from rdreier@cisco.com are

origin.patch
input-i8042-fix-warning-on-non-x86-builds.patch
