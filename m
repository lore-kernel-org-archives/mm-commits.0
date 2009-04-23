From: akpm@linux-foundation.org
Subject: + net-sunrpc-svc_xprtc-needs-svcsockh.patch added to -mm tree
Date: Thu, 23 Apr 2009 16:23:15 -0700
Message-ID: <200904232323.n3NNNFr5017484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49371 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760877AbZDWX0N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 19:26:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, davem@davemloft.net, hsweeten@visionengravers.com, trond.myklebust@fys.uio.no


The patch titled
     net/sunrpc/svc_xprt.c: needs svcsock.h
has been added to the -mm tree.  Its filename is
     net-sunrpc-svc_xprtc-needs-svcsockh.patch

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
Subject: net/sunrpc/svc_xprt.c: needs svcsock.h
From: "H Hartley Sweeten" <hartleys@visionengravers.com>

sparse reports the following in net/sunrpc/svc_xprt.c:

  warning: symbol 'svc_recv' was not declared. Should it be static?
  warning: symbol 'svc_drop' was not declared. Should it be static?
  warning: symbol 'svc_send' was not declared. Should it be static?
  warning: symbol 'svc_close_all' was not declared. Should it be static?

The .c file should include the .h file which contains the declarations for
the functions whcich it defines.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/svc_xprt.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN net/sunrpc/svc_xprt.c~net-sunrpc-svc_xprtc-needs-svcsockh net/sunrpc/svc_xprt.c
--- a/net/sunrpc/svc_xprt.c~net-sunrpc-svc_xprtc-needs-svcsockh
+++ a/net/sunrpc/svc_xprt.c
@@ -11,6 +11,7 @@
 #include <net/sock.h>
 #include <linux/sunrpc/stats.h>
 #include <linux/sunrpc/svc_xprt.h>
+#include <linux/sunrpc/svcsock.h>
 
 #define RPCDBG_FACILITY	RPCDBG_SVCXPRT
 
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
net-sunrpc-svc_xprtc-needs-svcsockh.patch
mm-page-writebackc-dirty-limit-type-should-be-unsigned-long.patch

