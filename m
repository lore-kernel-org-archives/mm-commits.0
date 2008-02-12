From: akpm@linux-foundation.org
Subject: + sunprc-fix-printk-format-warning.patch added to -mm tree
Date: Tue, 12 Feb 2008 15:24:08 -0800
Message-ID: <200802122324.m1CNO8nJ028263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36739 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752355AbYBLXYN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 18:24:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdreier@cisco.com, rolandd@cisco.com


The patch titled
     SUNPRC: fix printk format warning
has been added to the -mm tree.  Its filename is
     sunprc-fix-printk-format-warning.patch

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
Subject: SUNPRC: fix printk format warning
From: Roland Dreier <rdreier@cisco.com>

net/sunrpc/xprtrdma/svc_rdma_sendto.c:160: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'u64'

Signed-off-by: Roland Dreier <rolandd@cisco.com>
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
sunprc-fix-printk-format-warning.patch
