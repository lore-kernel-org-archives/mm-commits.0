From: akpm@linux-foundation.org
Subject: [merged] net-sunrpc-svc_xprtc-needs-svcsockh.patch removed from -mm tree
Date: Wed, 29 Apr 2009 12:17:52 -0700
Message-ID: <200904291917.n3TJHqb6030767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104AbZD2Td1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 15:33:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, davem@davemloft.net, hsweeten@visionengravers.com, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     net/sunrpc/svc_xprt.c: needs svcsock.h
has been removed from the -mm tree.  Its filename was
     net-sunrpc-svc_xprtc-needs-svcsockh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
mm-page-writebackc-dirty-limit-type-should-be-unsigned-long.patch

