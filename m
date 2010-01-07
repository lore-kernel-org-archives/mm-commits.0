From: akpm@linux-foundation.org
Subject: [merged] sunrpc-fix-peername-failed-on-closed-listener.patch removed from -mm tree
Date: Thu, 07 Jan 2010 13:10:34 -0800
Message-ID: <201001072110.o07LAYOJ017682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753159Ab0AGVNK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2010 16:13:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dfeng@redhat.com, Trond.Myklebust@netapp.com, bfields@fieldses.org, davem@davemloft.net, extmaillist@linuxbox.cz, neilb@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sunrpc: fix peername failed on closed listener
has been removed from the -mm tree.  Its filename was
     sunrpc-fix-peername-failed-on-closed-listener.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sunrpc: fix peername failed on closed listener
From: Xiaotian Feng <dfeng@redhat.com>

There're some warnings of "nfsd: peername failed (err 107)!" socket error
-107 means Transport endpoint is not connected.  This warning message was
outputed by svc_tcp_accept() [net/sunrpc/svcsock.c], when
kernel_getpeername returns -107.  This means socket might be CLOSED.

And svc_tcp_accept was called by svc_recv() [net/sunrpc/svc_xprt.c]

        if (test_bit(XPT_LISTENER, &xprt->xpt_flags)) {
        <snip>
                newxpt = xprt->xpt_ops->xpo_accept(xprt);
        <snip>

So this might happen when xprt->xpt_flags has both XPT_LISTENER and XPT_CLOSE.

Let's take a look at commit b0401d72 ("sunrpc: move the close processing
after do recvfrom method"), this commit has moved the close processing
after do recvfrom method, but this commit also introduces this warnings,
if the xpt_flags has both XPT_LISTENER and XPT_CLOSED, we should close it,
not accept then close.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Nikola Ciprich <extmaillist@linuxbox.cz>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/svc_xprt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN net/sunrpc/svc_xprt.c~sunrpc-fix-peername-failed-on-closed-listener net/sunrpc/svc_xprt.c
--- a/net/sunrpc/svc_xprt.c~sunrpc-fix-peername-failed-on-closed-listener
+++ a/net/sunrpc/svc_xprt.c
@@ -699,7 +699,8 @@ int svc_recv(struct svc_rqst *rqstp, lon
 	spin_unlock_bh(&pool->sp_lock);
 
 	len = 0;
-	if (test_bit(XPT_LISTENER, &xprt->xpt_flags)) {
+	if (test_bit(XPT_LISTENER, &xprt->xpt_flags) &&
+	    !test_bit(XPT_CLOSE, &xprt->xpt_flags)) {
 		struct svc_xprt *newxpt;
 		newxpt = xprt->xpt_ops->xpo_accept(xprt);
 		if (newxpt) {
_

Patches currently in -mm which might be from dfeng@redhat.com are

origin.patch
linux-next.patch

