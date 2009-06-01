From: akpm@linux-foundation.org
Subject: + sunrpc-use-formatting-of-module-name-in-sunrpc.patch added to -mm tree
Date: Mon, 01 Jun 2009 14:35:27 -0700
Message-ID: <200906012135.n51LZR6b028411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752298AbZFAVf7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 17:35:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raa.lkml@gmail.com, Trond.Myklebust@netapp.com, cel@citi.umich.edu, davem@davemloft.net


The patch titled
     sunrpc: use formatting of module name in SUNRPC
has been added to the -mm tree.  Its filename is
     sunrpc-use-formatting-of-module-name-in-sunrpc.patch

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
Subject: sunrpc: use formatting of module name in SUNRPC
From: Alex Riesen <raa.lkml@gmail.com>

gcc-4.3.3 produces the warning:
  "format not a string literal and no format arguments"

Signed-off-by: Alex Riesen <raa.lkml@gmail.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Chuck Lever <cel@citi.umich.edu>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/xprt.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN net/sunrpc/xprt.c~sunrpc-use-formatting-of-module-name-in-sunrpc net/sunrpc/xprt.c
--- a/net/sunrpc/xprt.c~sunrpc-use-formatting-of-module-name-in-sunrpc
+++ a/net/sunrpc/xprt.c
@@ -162,7 +162,6 @@ EXPORT_SYMBOL_GPL(xprt_unregister_transp
 int xprt_load_transport(const char *transport_name)
 {
 	struct xprt_class *t;
-	char module_name[sizeof t->name + 5];
 	int result;
 
 	result = 0;
@@ -174,9 +173,7 @@ int xprt_load_transport(const char *tran
 		}
 	}
 	spin_unlock(&xprt_list_lock);
-	strcpy(module_name, "xprt");
-	strncat(module_name, transport_name, sizeof t->name);
-	result = request_module(module_name);
+	result = request_module("xprt%s", transport_name);
 out:
 	return result;
 }
_

Patches currently in -mm which might be from raa.lkml@gmail.com are

origin.patch
crypto-use-formatting-of-module-name-in-crypto-api.patch
sunrpc-use-formatting-of-module-name-in-sunrpc.patch

