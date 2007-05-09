From: akpm@linux-foundation.org
Subject: - knfsd-rpcgss-rpc_gss_proc_-destroy-request-will-get-a-bad-rpc.patch removed from -mm tree
Date: Wed, 09 May 2007 14:53:10 -0700
Message-ID: <200705092153.l49LrACf003062@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758697AbXEIVxi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:53:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yjwei@cn.fujitsu.com, bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: rpcgss: RPC_GSS_PROC_ DESTROY request will get a bad rpc
has been removed from the -mm tree.  Its filename was
     knfsd-rpcgss-rpc_gss_proc_-destroy-request-will-get-a-bad-rpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: rpcgss: RPC_GSS_PROC_ DESTROY request will get a bad rpc
From: Wei Yongjun <yjwei@cn.fujitsu.com>

If I send a RPC_GSS_PROC_DESTROY message to NFSv4 server, it will reply with a
bad rpc reply which lacks an authentication verifier.  Maybe this patch is
needed.

Send/recv packets as following:

send:

RemoteProcedureCall
    xid
    rpcvers = 2
    prog = 100003
    vers = 4
    proc = 0
    cred = AUTH_GSS
        version = 1
        gss_proc = 3 (RPCSEC_GSS_DESTROY)
        service  = 1 (RPC_GSS_SVC_NONE)
    verf = AUTH_GSS
        checksum

reply:

RemoteProcedureReply
    xid
    msg_type
    reply_stat
    accepted_reply

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/auth_gss/svcauth_gss.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN net/sunrpc/auth_gss/svcauth_gss.c~knfsd-rpcgss-rpc_gss_proc_-destroy-request-will-get-a-bad-rpc net/sunrpc/auth_gss/svcauth_gss.c
--- a/net/sunrpc/auth_gss/svcauth_gss.c~knfsd-rpcgss-rpc_gss_proc_-destroy-request-will-get-a-bad-rpc
+++ a/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1092,6 +1092,8 @@ svcauth_gss_accept(struct svc_rqst *rqst
 		}
 		goto complete;
 	case RPC_GSS_PROC_DESTROY:
+		if (gss_write_verf(rqstp, rsci->mechctx, gc->gc_seq))
+			goto auth_err;
 		set_bit(CACHE_NEGATIVE, &rsci->h.flags);
 		if (resv->iov_len + 4 > PAGE_SIZE)
 			goto drop;
_

Patches currently in -mm which might be from yjwei@cn.fujitsu.com are

origin.patch
