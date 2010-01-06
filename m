From: akpm@linux-foundation.org
Subject: + sunrpc-fix-peername-failed-on-closed-listener.patch added to -mm tree
Date: Wed, 06 Jan 2010 15:57:55 -0800
Message-ID: <201001062357.o06NvtrI026257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933215Ab0AFX74 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jan 2010 18:59:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dfeng@redhat.com, Trond.Myklebust@netapp.com, bfields@fieldses.org, davem@davemloft.net, extmaillist@linuxbox.cz, neilb@suse.de, stable@kernel.org


The patch titled
     sunrpc: fix peername failed on closed listener
has been added to the -mm tree.  Its filename is
     sunrpc-fix-peername-failed-on-closed-listener.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
sunrpc-fix-peername-failed-on-closed-listener.patch

