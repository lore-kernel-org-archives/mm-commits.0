From: akpm@linux-foundation.org
Subject: - rpc-fix-the-tcp-resend-semantics-for-nfsv4.patch removed from -mm tree
Date: Sat, 21 Apr 2007 21:11:54 -0700
Message-ID: <200704220411.l3M4BsjX019257@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754078AbXDVEMA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Apr 2007 00:12:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, mm-commits@vger.kernel.org


The patch titled
     RPC: Fix the TCP resend semantics for NFSv4
has been removed from the -mm tree.  Its filename was
     rpc-fix-the-tcp-resend-semantics-for-nfsv4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: RPC: Fix the TCP resend semantics for NFSv4
From: Trond Myklebust <Trond.Myklebust@netapp.com>

Fix a regression due to the patch "NFS: disconnect before retrying NFSv4
requests over TCP"

The assumption made in xprt_transmit() that the condition

	"req->rq_bytes_sent == 0 and request is on the receive list"

should imply that we're dealing with a retransmission is false.  Firstly,
it may simply happen that the socket send queue was full at the time the
request was initially sent through xprt_transmit().  Secondly, doing this
for each request that was retransmitted implies that we disconnect and
reconnect for _every_ request that happened to be retransmitted
irrespective of whether or not a disconnection has already occurred.

Fix is to move this logic into the call_status request timeout handler.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/clnt.c |    4 ++++
 net/sunrpc/xprt.c |   10 ----------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff -puN net/sunrpc/clnt.c~rpc-fix-the-tcp-resend-semantics-for-nfsv4 net/sunrpc/clnt.c
--- a/net/sunrpc/clnt.c~rpc-fix-the-tcp-resend-semantics-for-nfsv4
+++ a/net/sunrpc/clnt.c
@@ -1046,6 +1046,8 @@ call_status(struct rpc_task *task)
 		rpc_delay(task, 3*HZ);
 	case -ETIMEDOUT:
 		task->tk_action = call_timeout;
+		if (task->tk_client->cl_discrtry)
+			xprt_disconnect(task->tk_xprt);
 		break;
 	case -ECONNREFUSED:
 	case -ENOTCONN:
@@ -1169,6 +1171,8 @@ call_decode(struct rpc_task *task)
 out_retry:
 	req->rq_received = req->rq_private_buf.len = 0;
 	task->tk_status = 0;
+	if (task->tk_client->cl_discrtry)
+		xprt_disconnect(task->tk_xprt);
 }
 
 /*
diff -puN net/sunrpc/xprt.c~rpc-fix-the-tcp-resend-semantics-for-nfsv4 net/sunrpc/xprt.c
--- a/net/sunrpc/xprt.c~rpc-fix-the-tcp-resend-semantics-for-nfsv4
+++ a/net/sunrpc/xprt.c
@@ -735,16 +735,6 @@ void xprt_transmit(struct rpc_task *task
 			xprt_reset_majortimeo(req);
 			/* Turn off autodisconnect */
 			del_singleshot_timer_sync(&xprt->timer);
-		} else {
-			/* If all request bytes have been sent,
-			 * then we must be retransmitting this one */
-			if (!req->rq_bytes_sent) {
-				if (task->tk_client->cl_discrtry) {
-					xprt_disconnect(xprt);
-					task->tk_status = -ENOTCONN;
-					return;
-				}
-			}
 		}
 	} else if (!req->rq_bytes_sent)
 		return;
_

Patches currently in -mm which might be from Trond.Myklebust@netapp.com are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
nfs-kill-the-obsolete-nfs_paranoia.patch
